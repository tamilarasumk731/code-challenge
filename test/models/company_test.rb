require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test 'should fail the validation when email domain is not getmainstreet.com' do
    company = Company.new(company_attributes)
    assert company.invalid?
    assert_equal ['invalid! Email address must have @getmainstreet.com'], company.errors[:email]
  end

  test 'should pass the validation when email domain is getmainstreet.com' do
    company = Company.new(company_attributes(:wolf_painting))
    assert company.valid?
  end

  test 'should not validate email if blank' do
    company = Company.new(company_attributes(:brown_painting))
    assert company.valid?
  end

  test 'should populate city, state details from pincode on save or update' do
    company = Company.create!(company_attributes(:wolf_painting))
    assert_equal 'Atlanta', company.city
    assert_equal 'GA', company.state
  end

  test 'should fail the validation when zipcode is empty' do
    company = Company.new(company_attributes(:marcus_painting))
    assert company.invalid?
    assert_equal ['invalid!'], company.errors[:zipcode]
  end

  test 'should fail the validation when unknown zipcode enters' do
    company = Company.new(company_attributes(:armstrong_painting))
    assert company.invalid?
    assert_equal ['invalid!'], company.errors[:zipcode]
  end

  private

  def company_attributes(key = :thompson_patining)
    companies(key).attributes.except('id')
  end
end