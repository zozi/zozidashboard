require 'net/http'
require 'json'

#Id of the widget
id = "businesscat"

#What meme to show
meme = "Business-Cat"

#The Memegenerator API
server = "http://version1.api.memegenerator.net"


SCHEDULER.every '5m', :first_in => 0 do |job|
    #The uri getting the instances of the meme that have been popular the last 7 days
    uri = URI("#{server}/Instances_Select_ByPopular?languageCode=en&pageIndex=0&pageSize=12&urlName=#{meme}&days=30")

    res = Net::HTTP.get(uri)
    
    #Marshal the json into an object
    j = JSON.parse(res)

    #We want a random result
    instances = j["result"].shuffle
    imageUrl = instances[0]["instanceImageUrl"]

    #Send the meme to the image widget
    send_event(id, { image: "#{imageUrl}" })
end