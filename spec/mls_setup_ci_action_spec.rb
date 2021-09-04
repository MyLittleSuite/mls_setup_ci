describe Fastlane::Actions::MlsSetupCiAction do
  describe "MLS Setup CI Integration" do
    let(:keychain_name) { "mylittlesuite_fastlane_keychain" }
    let(:keychain_password) { "" }
    let(:schema) { "CUSTOM_SCHEMA" }
    let(:is_flutter) { true }

    before :each do
      stub_const("ENV", {})
    end

    it "runs outside CI" do
      run_testing_fastfile
      expected_envs_default("")
      expected_envs_gym_includes(true)
      expected_envs_no_ci

      run_testing_fastfile_schema
      expected_envs_default(schema)
      expected_envs_gym_includes(true)
      expected_envs_no_ci

      run_testing_fastfile_flutter
      expected_envs_default("")
      expected_envs_gym_includes(false)
      expected_envs_no_ci
    end

    it "runs inside CI" do
      run_testing_fastfile_force
      expected_envs_default("")
      expected_envs_gym_includes(true)
      expected_envs_with_ci

      run_testing_fastfile_schema
      expected_envs_default(schema)
      expected_envs_gym_includes(true)
      expected_envs_with_ci

      run_testing_fastfile_flutter
      expected_envs_default("")
      expected_envs_gym_includes(false)
      expected_envs_with_ci
    end

    private

    def expected_envs_default(schema)
      expect(ENV["FASTLANE_SKIP_UPDATE_CHECK"]).to eql(Fastlane::Helper.ci?.to_s)
      expect(ENV["FASTLANE_HIDE_CHANGELOG"]).to eql(Fastlane::Helper.ci?.to_s)
      expect(ENV["FL_COCOAPODS_TRY_REPO_UPDATE_ON_ERROR"]).to eql(true.to_s)
      expect(ENV["FL_COCOAPODS_SILENT"]).to eql(Fastlane::Helper.ci?.to_s)
      expect(ENV["MATCH_TYPE"]).to eql("appstore")
      expect(ENV["SCAN_BUILDLOG_PATH"]).to eql("./logs/scan/#{schema}")
      expect(ENV["SCAN_DERIVED_DATA_PATH"]).to eql("./build/#{schema}")
      expect(ENV["SCAN_REINSTALL_APP"]).to eql(Fastlane::Helper.ci?.to_s)
      expect(ENV["GYM_BUILDLOG_PATH"]).to eql("./logs/gym/#{schema}")
      expect(ENV["GYM_BUILD_PATH"]).to eql("./build/#{schema}")
      expect(ENV["GYM_ARCHIVE_PATH"]).to eql("./build/archive/#{schema}")
      expect(ENV["GYM_DERIVED_DATA_PATH"]).to eql("./build/derived_data/#{schema}")
      expect(ENV["GYM_EXPORT_XCARGS"]).to eql("-allowProvisioningUpdates")
      expect(ENV["SNAPSHOT_REINSTALL_APP"]).to eql(true.to_s)
      expect(ENV["SNAPSHOT_CLEAR_PREVIOUS_SCREENSHOTS"]).to eql(true.to_s)
      expect(ENV["SNAPSHOT_SKIP_OPEN_SUMMARY"]).to eql(Fastlane::Helper.ci?.to_s)
      expect(ENV["SNAPSHOT_DERIVED_DATA_PATH"]).to eql("./build/derived_data/#{schema}")
      expect(ENV["SNAPSHOT_BUILDLOG_PATH"]).to eql("./logs/snapshot/#{schema}")
    end

    def expected_envs_gym_includes(includes)
      expect(ENV["GYM_INCLUDE_SYMBOLS"]).to eql(includes.to_s)
      expect(ENV["GYM_INCLUDE_BITCODE"]).to eql(includes.to_s)
    end

    def expected_envs_no_ci
      expect(ENV["MATCH_KEYCHAIN_NAME"]).to be_nil
      expect(ENV["MATCH_KEYCHAIN_PASSWORD"]).to be_nil
      expect(ENV["MATCH_READONLY"]).to be_nil
    end

    def expected_envs_with_ci
      expect(ENV["MATCH_KEYCHAIN_NAME"]).to eql(keychain_name)
      expect(ENV["MATCH_KEYCHAIN_PASSWORD"]).to eql(keychain_password)
      expect(ENV["MATCH_READONLY"]).to eql(Fastlane::Helper.ci?.to_s)
    end

    def run_testing_fastfile
      Fastlane::FastFile.new.parse("lane :test do
                mls_setup_ci
            end").runner.execute(:test)
    end

    def run_testing_fastfile_force
      Fastlane::FastFile.new.parse("lane :test do
                mls_setup_ci(force: true)
            end").runner.execute(:test)
    end

    def run_testing_fastfile_schema
      Fastlane::FastFile.new.parse("lane :test do
                mls_setup_ci(schema: \"#{schema}\")
            end").runner.execute(:test)
    end

    def run_testing_fastfile_flutter
      Fastlane::FastFile.new.parse("lane :test do
                mls_setup_ci(is_flutter: \"#{is_flutter}\")
            end").runner.execute(:test)
    end
  end
end
