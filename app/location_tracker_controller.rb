class LocationTrackerController < UIViewController
  DEFAULT_URL = "https://domain.com/users/1/update_location/:secret"

  attr_accessor :url

  def viewDidLoad
    @locationManager = App.delegate.location_manager
    @defaults = NSUserDefaults.standardUserDefaults

    @label = UILabel.alloc.initWithFrame([[20, 20], [270, 10]])
    @label.textAlignment = UITextAlignmentCenter
    @label.textColor = UIColor.whiteColor
    @label.backgroundColor = UIColor.blackColor
    @label.font = UIFont.fontWithName("Arial Rounded MT Bold", size: 12.0)
    @label.text = "Periodically POST your location to this URL:"
    view.addSubview @label

    @address_field = UITextField.alloc.initWithFrame([[20, 45], [270, 20]])
    @address_field.backgroundColor = UIColor.whiteColor
    @address_field.delegate = self
    @address_field.text = @defaults["url"] || DEFAULT_URL
    @address_field.returnKeyType = UIReturnKeyDone
    view.addSubview @address_field

    @map = MKMapView.alloc.initWithFrame([[20, 80], [270, 400]])
    @map.showsUserLocation = true
    view.addSubview @map

    true
  end
  
  def textFieldShouldReturn(textField)
    if textField == @address_field
      @defaults["url"] = @address_field.text == DEFAULT_URL ? nil : @address_field.text
      textField.resignFirstResponder
      true
    else
      false
    end
  end

  def url
    @address_field.text
  end
end
