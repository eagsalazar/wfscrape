#!/usr/bin/env ruby

require 'mechanize'

username = ENV['WFUN']
password = ENV['WFPW']
signon_url = 'https://online.wellsfargo.com/signon/'
session_url = "https://online.wellsfargo.com/das/cgi-bin/session.cgi?screenid=SIGNON_PORTAL_PAUSE"

agent = Mechanize.new { |a|
  a.ssl_version = 'SSLv3'
  a.verify_mode = OpenSSL::SSL::VERIFY_NONE
}

# get first page
page = agent.get signon_url

# find and fill form
form = page.form_with(:name => 'Signon')
form['userid'] = username
form['password'] = password
page = agent.submit form

# Redirect to logged in
page = agent.get session_url

# Grab shit
accounts = page.search('[id^=cashAcct]').map {|el| el.ancestors('tr') }.map {|el| [el.search('a.account').text.strip , el.search('a.amount').text.strip] }

puts accounts.map {|account| "#{account[0]} : #{account[1]}" }
