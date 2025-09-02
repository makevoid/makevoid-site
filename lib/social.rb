SOCIAL = {
  github: "https://github.com/makevoid",
  twitter: "https://twitter.com/makevoid",
  instagram: "https://instagram.com/makevoid",
  linkedin: "https://linkedin.com/in/makevoid",
}

SocialProfilesCheck = -> {
  require 'net/http'
  SOCIAL.each do |social, url|
    next if social == :twitter # ... twitter 404s without user agent
    puts "=> #{url}"
    # puts url
    resp = Net::HTTP.get_response URI url
    p resp
    puts resp.body[0..300] # gets a preview of the page on terminal
    sleep 0.1
  end
}

# if running as `ruby social.rb`
if __FILE__ == $0
  SocialProfilesCheck.()
end
