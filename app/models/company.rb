class Company < ApplicationRecord
  has_rich_text :description

  validate :check_email, if: proc {|company| company.email.present? }
  validate :check_and_set_city_state

  def check_email
  	domain_pattern = /\b.+@getmainstreet\.com\z/
  	return if URI::MailTo::EMAIL_REGEXP.match?(email) && domain_pattern.match?(email)

    errors.add(:email, 'invalid! Email address must have @getmainstreet.com')
  end


  def check_and_set_city_state
    place_details = ZipCodes.identify(zip_code)
    if !place_details.nil?
	  self.city = place_details[:city]
	  self.state = place_details[:state_code]
	  return
	else
		errors.add(:zipcode, 'invalid!')
	end
  end

end
