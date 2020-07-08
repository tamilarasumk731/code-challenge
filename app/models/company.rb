class Company < ApplicationRecord
  has_rich_text :description


  validate :set_city_state


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
