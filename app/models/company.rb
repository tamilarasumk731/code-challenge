class Company < ApplicationRecord
  has_rich_text :description


  validate :set_city_state
  validate :check_email

  def check_email
  	return if email.blank?

    if email =~ (/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    	domain = email.split('@').last
        if domain != "getmainstreet.com"
          errors.add(:email, "The domain #{domain} does not acceptable. Please enter a valid email address.")
        end
    else
      errors.add(:email, 'Invalid email address.')
    end
  end


  def set_city_state
    place_details = ZipCodes.identify(zip_code)
    if !place_details.nil?
	  self.city = place_details[:city]
	  self.state = place_details[:state_code]
	  return
	else
		errors.add(:zipcode, 'Invalid!')
	end
  end

end
