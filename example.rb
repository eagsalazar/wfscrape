#!/usr/bin/env ruby

require 'wf'

wf = WF.new
wf.signon ENV['WFUN'], ENV['WFPW']
pp wf.accounts
