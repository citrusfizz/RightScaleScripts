#!/usr/bin/env ruby 
# Curtis Joslin 10.29.14

require 'uri'
require 'net/http'
require 'net/https'
require 'launchy'

# CHANGE THIS AUTHENTICATION !!

email = ''
password = ''


# Handel the Inputs
if ARGV[0] !=~ URI::regexp
    account = ARGV[0]
elsif ARGV[0] =~ URI::regexp
  argsplit = URI(ARGV[0]).path.split("/") 
  account = argsplit[2]
else
  puts "Need and account number or URL" if !ARGV[0]
  exit if !ARGV[0]
end

#Request cookie under master account
masteraccount = '/api/accounts/60072'
uri_auth = URI.parse('https://us-3.rightscale.com/api/session')
https_auth = Net::HTTP.new(uri_auth.host,uri_auth.port)
https_auth.use_ssl = true
req_auth = Net::HTTP::Post.new(uri_auth.path, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
req_auth['X_API_VERSION'] = '1.5'
req_auth.set_form_data('email' => "#{email}", 'password' => "#{password}",'account_href' => "#{masteraccount}", )
do_auth = https_auth.request(req_auth)  #perform the authentication to get the cookie
cookie = do_auth.response['set-cookie']  #save the cookie from the response

#Use cookie to authenticate and observer client account
uri_obs = URI.parse('https://us-3.rightscale.com/global//admin_accounts/' + account.to_s + '/access')
https_obs = Net::HTTP.new(uri_obs.host,uri_obs.port)
https_obs.use_ssl = true
req_obs = Net::HTTP::Post.new(uri_obs.path, {'Host' => 'us-3.rightscale.com', 'Referer' => 'https://us-3.rightscale.com/global//admin_accounts/' + account.to_s, 'cookie' => "#{cookie}"})
do_obs = https_obs.request(req_obs)

#launch the link in the default OS Browser
ARGV[0] =~ URI::regexp ? (Launchy.open(ARGV[0])) : (puts "Time to open account in Browser!")

