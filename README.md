# PostLocation

PostLocation is an iOS application that POSTs your location information to a server of your choosing.

## Installation

PostLocation is written with RubyMotion.  You will need RubyMotion in order to build it.

Install and run on your developer-mode iDevice with

    rake device

### Push Notifications

There is some experimental push notification support.  It doesn't really do anything yet.

1) Run `bundle install`

2) Start up push notifications server

  ruby push-notification-server.rb

3) Deploy app to iPhone (cannot be tested in simulator)

## License

This code is released under the MIT License.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
