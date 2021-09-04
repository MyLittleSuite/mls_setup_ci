require 'fastlane/action'
require_relative '../helper/mls_setup_ci_helper'

module Fastlane
  module Actions
    class MlsSetupCiAction < Action
      def self.run(params)
        force = params[:force]
        schema = params[:schema]
        is_flutter = params[:is_flutter]

        setup_fastlane(schema, is_flutter)
        setup_cocoapods(schema, is_flutter)
        setup_match(schema, is_flutter)
        setup_scan(schema, is_flutter)
        setup_gym(schema, is_flutter)
        setup_snapshot(schema, is_flutter)

        if !Helper.ci? && !force
          UI.message("Currently not running on CI system.")
          return
        end

        setup_keychain(schema, is_flutter)
      end

      def self.setup_fastlane(schema, is_flutter)
        UI.message("Setting fastlane default values.")
        ENV["FASTLANE_SKIP_UPDATE_CHECK"] = Helper.ci?.to_s
        ENV["FASTLANE_HIDE_CHANGELOG"] = Helper.ci?.to_s
      end

      def self.setup_cocoapods(schema, is_flutter)
        UI.message("Setting cocoapods default values.")
        ENV["FL_COCOAPODS_TRY_REPO_UPDATE_ON_ERROR"] = true.to_s
        ENV["FL_COCOAPODS_SILENT"] = Helper.ci?.to_s
      end

      def self.setup_match(schema, is_flutter)
        UI.message("Setting match default values.")
        ENV["MATCH_TYPE"] = "appstore"
      end

      def self.setup_scan(schema, is_flutter)
        UI.message("Setting scan default values.")
        ENV["SCAN_DERIVED_DATA_PATH"] = "./build/#{schema}"
        ENV["SCAN_BUILDLOG_PATH"] = "./logs/scan/#{schema}"
        ENV["SCAN_REINSTALL_APP"] = Helper.ci?.to_s
      end

      def self.setup_gym(schema, is_flutter)
        include_string = is_flutter ? "false" : "true"

        UI.message("Setting gym default values.")
        ENV["GYM_BUILD_PATH"] = "./build/#{schema}"
        ENV["GYM_ARCHIVE_PATH"] = "./build/archive/#{schema}"
        ENV["GYM_DERIVED_DATA_PATH"] = "./build/derived_data/#{schema}"
        ENV["GYM_BUILDLOG_PATH"] = "./logs/gym/#{schema}"
        ENV["GYM_INCLUDE_SYMBOLS"] = include_string
        ENV["GYM_INCLUDE_BITCODE"] = include_string
        ENV["GYM_EXPORT_XCARGS"] = "-allowProvisioningUpdates"
      end

      def self.setup_snapshot(schema, is_flutter)
        UI.message("Setting snapshot default values.")
        ENV["SNAPSHOT_REINSTALL_APP"] = true.to_s
        ENV["SNAPSHOT_CLEAR_PREVIOUS_SCREENSHOTS"] = true.to_s
        ENV["SNAPSHOT_SKIP_OPEN_SUMMARY"] = Helper.ci?.to_s
        ENV["SNAPSHOT_DERIVED_DATA_PATH"] = "./build/derived_data/#{schema}"
        ENV["SNAPSHOT_BUILDLOG_PATH"] = "./logs/snapshot/#{schema}"
      end

      def self.setup_keychain(schema, is_flutter)
        keychain_name = "mylittlesuite_fastlane_keychain"
        keychain_password = ""

        UI.message("Creating temporary keychain: \"#{keychain_name}\".")
        Actions::CreateKeychainAction.run(
          name: keychain_name,
          default_keychain: true,
          unlock: true,
          timeout: 0,
          lock_when_sleeps: false,
          password: keychain_password
        )

        UI.message("Setting env for match and enabling match readonly mode.")
        ENV["MATCH_KEYCHAIN_NAME"] = keychain_name
        ENV["MATCH_KEYCHAIN_PASSWORD"] = keychain_password
        ENV["MATCH_READONLY"] = Helper.ci?.to_s
      end

      def self.description
        "MyLittleSuite Setup CI"
      end

      def self.authors
        ["Angelo Cassano"]
      end

      def self.details
        "MyLittleSuite Setup CI"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :force,
                                       env_name: "FL_MYLITTLESUITE_SETUP_CI_FORCE",
                                       description: "Force setup, even if not executed in a CI",
                                       type: Boolean,
                                       optional: true,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :schema,
                                       env_name: "FL_MYLITTLESUITE_SETUP_CI_SCHEMA",
                                       description: "Define schema, useful to customize building paths to avoid concurrency",
                                       type: String,
                                       optional: true,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :is_flutter,
                                       env_name: "FL_MYLITTLESUITE_SETUP_CI_IS_FLUTTER",
                                       description: "Is this a Flutter project?",
                                       type: Boolean,
                                       optional: true,
                                       default_value: false)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
