require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class MlsSetupCiHelper
      # class methods that you define here become available in your action
      # as `Helper::MlsSetupCiHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the mls_setup_ci plugin helper!")
      end
    end
  end
end
