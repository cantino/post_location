class AppDelegate

  attr_accessor :location_manager
  attr_accessor :device_token

  def log(msg)
    NSLog "#{msg}\n" 
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @controller = LocationTrackerController.alloc.init
    @window.rootViewController = @controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)

    # location_manager.startUpdatingLocation # Continuous updates
    location_manager.startMonitoringSignificantLocationChanges # Updates only when things change
    
    log "Now launched with options #{launchOptions}"

    true
  end

  def applicationDidEnterBackground(application)
    log "Now in background"
  end

  def applicationWillResignActive(application)
    log "Now resigning active"
  end

  def applicationWillTerminate(application)
    log "Now in terminated"
  end

  def applicationDidBecomeActive
    log "Now active"
  end

  def application(application, didReceiveRemoteNotification:userInfo)
    log "didReceiveRemoteNotification"
  end

  def application(app, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    @device_token = deviceToken.description.gsub(" ", "").gsub("<", "").gsub(">", "")

    # Log the push notification to the console
    log @device_token
  end

  def application(app, didFailToRegisterForRemoteNotificationsWithError:error)
    show_alert "Error when registering for device token", "Error, #{error}"
  end

  def device_token
    @device_token
  end

  def location_manager
    if @locationManager.nil?
      @locationManager = CLLocationManager.alloc.init
      @locationManager.setDesiredAccuracy(KCLLocationAccuracyKilometer) #KCLLocationAccuracyBest) #KCLLocationAccuracyKilometer
      @locationManager.distanceFilter = 30
      @locationManager.delegate = self
    end
    @locationManager
  end

  # iOS >= 4
  def locationManager(manager, didUpdateToLocation:current_location, fromLocation:last_location)
    log "Location #{current_location} [iOS 5]"
  end

  # iOS >= 6
  def locationManager(manager, didUpdateLocations:locations)
    # if App.shared.applicationState == UIApplicationStateBackground
      withBackgroundHandling do
        location = locations.last
        
        data = {
          :latitude => location.coordinate.latitude,
          :longitude => location.coordinate.longitude,
          :timestamp => location.timestamp.timeIntervalSince1970,
          :altitude => location.altitude,
          :horizontal_accuracy => location.horizontalAccuracy,
          :vertical_accuracy => location.verticalAccuracy,
          :speed => location.speed,
          :course => location.course,
          :device_token => @device_token
        }
        
        data_str = data.map {|k, v| "#{k}=#{v.to_s}" }.join("&")

        url_string = ("#{@controller.url}").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        log "Sending to #{url_string} this data: #{data_str}"

        url = NSURL.URLWithString(url_string)

        request = NSMutableURLRequest.requestWithURL(url)
        request.setHTTPMethod("POST")
        request.setHTTPBody(data_str.to_s.dataUsingEncoding(NSUTF8StringEncoding))

        response = nil
        error = nil
        data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
        raise "BOOM!" unless (error.nil?)
        json = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)
        log "Server response: #{json}"
      end
    # end
  end
  
  def withBackgroundHandling
    bgTask = nil
    bgTask = App.shared.beginBackgroundTaskWithExpirationHandler lambda do
      log "Background task cleaned up."
      UIApp.shared.endBackgroundTask bgTask
      bgTask = UIBackgroundTaskInvalid
    end
    log bgTask == UIBackgroundTaskInvalid ? "UIBackgroundTaskInvalid: Valid, with remaining time #{App.shared.backgroundTimeRemaining}" : "UIBackgroundTaskInvalid: Invalid, with remaining time #{App.shared.backgroundTimeRemaining}"
    
    yield
    
    if bgTask != UIBackgroundTaskInvalid
      App.shared.endBackgroundTask bgTask
      bgTask = UIBackgroundTaskInvalid
    end
  end

  def locationManager(manager, didFailWithError:error)
    log "Location manager failed with error: #{error}"
  end

  def show_alert(title, message)
    alert = UIAlertView.new
    alert.title = title
    alert.message = message
    alert.show
  end
end
