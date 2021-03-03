#!/usr/bin/env ruby

require 'json'
require 'selenium-webdriver'

# SLEEP_LENGTH since UI takes time to respond
SLEEP_LENGTH = 0.2

if ARGV.length <= 0
  puts "Need user info JSON file. See example.json"
  exit 1
end
filepath = ARGV[0]

file = File.read(filepath)
user_info = JSON.parse(file)

Selenium::WebDriver::Chrome::Service.class_eval do
  def stop
    # STDOUT.puts "#{self.class}#stop: no-op"
  end
end

driver = Selenium::WebDriver.for :chrome

driver.navigate.to "https://covid19results.ehealthontario.ca:4443/agree"

el = driver.find_element(xpath: "//span[@id='fld_id-type_ohc_label']")
el.click
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//button[@id='btn_step2_ohc_known']")
el.click
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//span[@id='cp-agreement_acceptedTerm1_label']")
el.click
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//button[@id='button_submit']")
el.click
sleep SLEEP_LENGTH

# Fill out form
el = driver.find_element(xpath: "//input[@id='hcn']")
user_info["healthCardNumber"].each_char do |c|
  el.send_keys(c)
  sleep SLEEP_LENGTH
end

el = driver.find_element(xpath: "//input[@id='vCode']")
el.send_keys(user_info["healthCardVersionCode"])
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//input[@id='scn']")
el.send_keys(user_info["stockControlNumber"])
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//input[@id='fname']")
el.send_keys(user_info["firstName"])
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//input[@id='lname']")
el.send_keys(user_info["lastName"])
sleep SLEEP_LENGTH

dob = user_info["dateOfBirth"].split("-")
if dob.length < 3
  puts "dateOfBirth must by in format YYYY-MM-DD"
  exit 1
end
y = dob[0]
m = dob[1]
d = dob[2]
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//input[@id='dob-igc-yyyy']")
el.send_keys(y)

el = driver.find_element(xpath: "//input[@id='dob-igc-mm']")
el.send_keys(m)

el = driver.find_element(xpath: "//input[@id='dob-igc-dd']")
el.send_keys(d)

if user_info["gender"].downcase == "male"
  el = driver.find_element(xpath: "//span[@id='fld_gender_male_label']")
elsif user_info["gender"].downcase == "female"
  el = driver.find_element(xpath: "//span[@id='fld_gender_female_label']")
else
  el = driver.find_element(xpath: "//span[@id='fld_gender_other_label']")
end
el.click
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//input[@id='pCode']")
el.send_keys(user_info["postalCode"])
sleep SLEEP_LENGTH

el = driver.find_element(xpath: "//button[@id='button_verify']")
el.click

exit 0
