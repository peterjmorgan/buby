#!/usr/bin/env jruby
require 'rubygems'
require 'buby'

=begin
  I use multiple user profiles in Chrome for testing different auth levels in an app.
  I append Testing1-3 to the UA string in each version, then have burp highlight based on that string match.
  Set the $hash key to be the search parameter in the User Agent, and value to the color you want 

  To use:

  Start buby, then in buby:
   load "highlighter.rb"
   $burp.extend(Highlighter)
=end

$hash = {
  "Testing1" => "orange",
  "Testing2" => "cyan",
  "Testing3" => "blue"
}

module Highlighter
  def evt_http_message(tool_name, is_request, msg_info)
    ua = msg_info.req_headers.flatten.index("User-Agent")
    req = msg_info.req_headers.flatten[ua+1]

    if is_request 
      $hash.map do |k,v|
        if req.match(k)
          msg_info.setHighlight(v)
        end
      end
      return super(tool_name, is_request, msg_info.dup)
    else
      return super(tool_name, is_request, msg_info)
    end
  end
end

if __FILE__ == $0
  $burp = Buby.new()
  $burp.extend(Highlighter)
  $burp.start_burp()
end
