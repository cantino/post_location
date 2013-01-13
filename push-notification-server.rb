# A proof-of-concept push notification server
#
# To read more details about the whole process, read the README here:
# https://github.com/highgroove/grocer

require 'sinatra'
require 'grocer'


post '/' do
  puts "Device Token: #{params[:device_token]}"
  puts "Longitude: #{params[:longitude]}"
  puts "Latitude: #{params[:latitude]}"

  pusher = Grocer.pusher(
    certificate: "#{Dir.pwd}/certificate.pem",
    gateway:     "gateway.sandbox.push.apple.com"
  )

  device_token = params[:device_token]
  unless device_token.nil?
    notification = Grocer::Notification.new(
      device_token: "#{device_token}",
      alert:        "Hello from Grocer!"
    )
    pusher.push(notification)
  end
end
