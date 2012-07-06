# encoding: UTF-8
require 'pathname'

namespace :deploy do
  desc 'Deploy archive to TestFlight'
  task :testflight do
    # Only useful if we're re-signing the app with a different cert.
    # SIGNING_IDENTITY = ENV['CODE_SIGN_IDENTITY']
    # PROVISIONING_PROFILE = Pathname.new(ENV['BUILT_PRODUCTS_DIR']) + ENV['CONTENTS_FOLDER_PATH'] + ENV['EMBEDDED_PROFILE_NAME']
    raise 'This task can only be run as part of Xcode Archive build' if !ENV['ARCHIVE_PATH']
    raise 'Must set TESTFLIGHT_API_TOKEN and TESTFLIGHT_TEAM_TOKEN' if !TESTFLIGHT_API_TOKEN or !TESTFLIGHT_TEAM_TOKEN

    ARCHIVE_PATH = Pathname.new(ENV['ARCHIVE_PATH'].gsub(/^'|'$/,''))
    ARCHIVE_DSYMS_PATH = Pathname.new(ENV['ARCHIVE_DSYMS_PATH']) + ENV['DWARF_DSYM_FILE_NAME']
    ARCHIVE_APP_PATH = Pathname.new(ENV['ARCHIVE_PRODUCTS_PATH']) + 'Applications' + ENV['CONTENTS_FOLDER_PATH']

    # create an ipa
    DESTINATION_DIR = Pathname.new('/tmp') + 'testflight'
    Dir.mkdir DESTINATION_DIR if !Dir.exists? DESTINATION_DIR

    prompt_script = DESTINATION_DIR + 'should_upload.scpt'
    IO.write(prompt_script, <<-EOF)
    set front_app to (path to frontmost application as Unicode text)
    tell application front_app
      set noButton to "No"
      set yesButton to "Yes"

      set upload_dialog to display dialog ¬
        "Upload #{ENV['PRODUCT_NAME']} Testflight?" buttons {"No", "Yes"} ¬
        default button "Yes" with icon 1
      return button returned of upload_dialog is "Yes"
    end tell
    EOF
    should_upload = `osascript #{prompt_script}`.chomp == 'true'
    if should_upload
      IPA_PATH = DESTINATION_DIR + %{#{ENV['PRODUCT_NAME']}.ipa}
      File.delete IPA_PATH if File.exists? IPA_PATH
      sh %{xcrun -sdk iphoneos PackageApplication -v "#{ARCHIVE_APP_PATH}" -o "#{IPA_PATH}"}

      # create a dsym zip
      DSYM_PATH = DESTINATION_DIR + %{#{ENV['PRODUCT_NAME']}.dSYM.zip}
      File.delete DSYM_PATH if File.exists? DSYM_PATH
      sh %{zip -r "#{DSYM_PATH}" "#{ARCHIVE_DSYMS_PATH}"}

      sh %W{curl "http://testflightapp.com/api/builds.json"
            -F file=@"#{IPA_PATH}"
            -F dsym=@"#{DSYM_PATH}"
            -F api_token="#{TESTFLIGHT_API_TOKEN}"
            -F team_token="#{TESTFLIGHT_TEAM_TOKEN}"
            -F notes="Auto-upload from Xcode."
      }.join ' '

      sh %{open "https://testflightapp.com/dashboard/builds/"}
    end
  end
end
