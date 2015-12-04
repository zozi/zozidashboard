require 'dotenv'
Dotenv.load
require 'net/http'
require 'uri'
require 'json'
require 'rest_client'

uri = URI.parse('https://api.newrelic.com/v2/servers.json')
url = 'https://api.newrelic.com/v2/servers.json'

SCHEDULER.every '1m' do
	response = RestClient.get(
		url,
		:'X-Api-Key' => ENV['NEWRELIC_API_KEY']
	)
	server_data = JSON.parse(response)
	servers = server_data["servers"]
	meters = []
	servers.map.with_index do |server, index|
		meter_data = {		
			name: servers[index]["name"],
			value: servers[index]["summary"]["memory"]
		}
		meters << meter_data
		#return meters
	end
	meters.each_with_index do |meter, index|
		send_event("memory"+(index+1).to_s,   { value: meters[index][:value], moreinfo: meters[index][:name] })
	end
	#puts meters[0]
end
