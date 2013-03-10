def app_path
  ENV['APP_BUNDLE_PATH'] || (defined?(APP_BUNDLE_PATH) && APP_BUNDLE_PATH)
end

Given /^I launch the app$/ do
  sdk = ENV['FRANK_SDK']
  idiom = ENV['FRANK_IDIOM'] || 'ipad'
  launch_app( app_path, sdk, idiom )
end

Given /^I launch the app using iOS (\d\.\d)$/ do |sdk|
  # You can grab a list of the installed SDK with sim_launcher
  # > run sim_launcher from the command line
  # > open a browser to http://localhost:8881/showsdks
  # > use one of the sdk you see in parenthesis (e.g. 4.2)
  idiom = ENV['FRANK_IDIOM'] || 'ipad'
  launch_app app_path, sdk, idiom
end

Given /^I launch the app using iOS (\d\.\d) and the (iphone|ipad) simulator$/ do |sdk, idiom|
  launch_app app_path, sdk, idiom
end
