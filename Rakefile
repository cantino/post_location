# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require
require 'motion-cocoapods'

# Make a file called settings.json in this directory that looks like the following:
#
# {
#   "provisioning_profile": "~/path/to/your/provisioning/profile.mobileprovision",
#   "codesign_certificate": "iPhone Developer: Your Name (SOMETHING)",
# }
#
# Then install on your phone with "rake device"

settings = JSON.parse(File.read(File.expand_path(File.join(File.dirname(__FILE__), "settings.json"))))

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'PostLocation'
  app.frameworks += ["CoreLocation", "CoreData", "MapKit"]
  app.provisioning_profile = File.expand_path(settings["provisioning_profile"])
  app.codesign_certificate = settings["codesign_certificate"]
  app.entitlements['aps-environment'] = 'development'
  app.entitlements['get-task-allow'] = true
  app.info_plist['UIBackgroundModes'] = ['location']
  app.info_plist['UIRequiredDeviceCapabilities'] = ['location-services']
end
