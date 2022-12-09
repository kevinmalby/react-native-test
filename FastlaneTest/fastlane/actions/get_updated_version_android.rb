module Fastlane
  module Actions
    
    class GetUpdatedVersionAndroidAction < Action
      def self.run(params)
        Actions.verify_gem!('uri')
        Actions.verify_gem!('net/http')
        Actions.verify_gem!('openssl')
        Actions.verify_gem!('json')
        require 'uri'
        require 'net/http'
        require 'openssl'
        require 'json'

        providedVersion = params[:app_version]
        appPackageName = params[:app_package_name] || "com.xemelgo"

        testFairyUser = ENV['TF_API_USER']
        testFairyApiKey = ENV['TF_API_KEY']

        puts testFairyUser
        puts testFairyApiKey

        return getTestFairyVersionInfo(appPackageName, testFairyUser, testFairyApiKey, providedVersion)
      end

      def self.getTestFairyVersionInfo(appPackageName, testFairyUser, testFairyApiKey, userProvidedVersion)
        projectId = getAppIdFromTestFairy(appPackageName, testFairyUser, testFairyApiKey)
        uri = URI("https://api.testfairy.com/api/1/projects/#{projectId}/builds")

        result = makeSecureAuthedRequest(uri, testFairyUser, testFairyApiKey)

        mostRecentBuild = result['builds'][0]
        mostRecentAppVersion = mostRecentBuild['appVersion']
        mostRecentAppVersionCode = mostRecentBuild['appVersionCode']

        parts = mostRecentAppVersion.split(".")

        major = parts[0]
        minor = parts[1]

        if(userProvidedVersion.nil?)
          target_version = major + "." + (minor.to_i + 1).to_s
        else
          target_version = userProvidedVersion.to_s
        end

        return target_version, (mostRecentAppVersionCode.to_i + 1).to_s
      end

      def self.getAppIdFromTestFairy(appPackageName, testFairyUser, testFairyApiKey)
          uri = URI("https://api.testfairy.com/api/1/projects")

          result = makeSecureAuthedRequest(uri, testFairyUser, testFairyApiKey)
          targetProject = result["projects"].find {|project| project["packageName"] == appPackageName}
          return targetProject["id"]
      end

      def self.makeSecureAuthedRequest(uri, testFairyUser, testFairyApiKey)
          Net::HTTP.start(uri.host, uri.port,
            :use_ssl => uri.scheme == "https", 
            :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
  
              request = Net::HTTP::Get.new uri.request_uri
              request.basic_auth testFairyUser, testFairyApiKey
  
              response = http.request request
  
              result = JSON.parse(response.body)

              return result
            end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Updates the app version in the gradle.build file"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "Reaches out to Google Play and TestFairy to get the most recent version and updates gradle"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_version,
                                      env_name: "FL_ANDROID_APP_VERSION",
                                      description: "Android version to update the gradle file to",
                                      optional: true),
          FastlaneCore::ConfigItem.new(key: :app_package_name,
                                      env_name: "FL_ANDROID_APP_PACKAGE_NAME",
                                      description: "The app package name used to lookup the current version",
                                      optional: true,
                                      is_string: true)
        ]
      end

      def self.return_value
        "A string array containing the incremented version number and code"
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
