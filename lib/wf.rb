#!/usr/bin/env ruby

require 'mechanize'

class WF

  SIGNON_URL = 'https://online.wellsfargo.com/signon/'
  SESSION_URL = "https://online.wellsfargo.com/das/cgi-bin/session.cgi?screenid=SIGNON_PORTAL_PAUSE"

  def initialize
    @agent = Mechanize.new do |a|
      a.ssl_version = 'SSLv3'
      a.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def signon username, password
    page = @agent.get SIGNON_URL

    form = page.form_with(:name => 'Signon')
    form['userid'] = username
    form['password'] = password
    page = @agent.submit form

    @logged_in_page = @agent.get SESSION_URL
  end

  def accounts
    raise unless @logged_in_page
    unless @_accounts
      @_accounts = {}
      @logged_in_page.search('[id^=cashAcct]').map {|el| el.ancestors('tr') }.each { |el|
        account = el.search('a.account').text.strip
        match = account.match(/^(.+) XXXXXX(.+)$/)
        @_accounts[match[2]] = {
          balance: el.search('a.amount').text.strip.gsub("$", "").to_f,
          name: match[1]
        }
      }
    end
    @_accounts
  end

  def balance ending_in
    @_accounts[ending_in]
  end

end

