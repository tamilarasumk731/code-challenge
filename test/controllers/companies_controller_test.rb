require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text "City, State"
  end

  test "Update" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  test "Delete Inner" do

    company_to_destroy = Company.first
    company_count_before = Company.count

    visit company_path(company_to_destroy)

    accept_confirm do
      find_link('Delete', href: "/companies/#{company_to_destroy.id}").click
    end

    # View assertions
    assert_text 'Company deletion successful'

    # DB assertions
    assert_not Company.exists?(company_to_destroy.id)
    assert_not_equal company_count_before, Company.count
  end

  test "Outer Delete" do 
    company_to_delete = Company.first
    company_count_before = Company.count

    visit companies_path

    accept_confirm do
      find("button[id=\"#{company_to_delete.id}\"]").click
    end

    assert_text 'Company deletion successful'

    assert_not Company.exists?(company_to_delete.id)
    assert_not_equal company_count_before, Company.count

  end

  test "Email validation error" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "Great Painting")
      fill_in("company_zip_code", with: "92483")
      fill_in("company_phone", with: "8746727485")
      fill_in("company_email", with: "greatpaintings@something.com")
      click_button "Create Company"
    end

    assert_text "Email invalid! Email address must have @getmainstreet.com"

    assert_not Company.exists?(email: 'greatpaintings@something.com')
  end

  test "Zipcode validation error" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "Great Painting")
      fill_in("company_zip_code", with: "924583")
      fill_in("company_phone", with: "8746727485")
      fill_in("company_email", with: "greatpaintings@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Zipcode invalid!"

    assert_not Company.exists?(email: 'greatpaintings@getmainstreet.com')
  end

end
