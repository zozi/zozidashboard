require 'dotenv'
Dotenv.load
require 'net/http'
require 'json'
require 'rest_client'

url = 'https://api.newrelic.com/v2/servers.json?filter[ids]=1557588,+2709321,+2514170,+2297767,+2709479'

SCHEDULER.every '30s' do
	response = RestClient.get(
		url,
		:'X-Api-Key' => ENV['NEWRELIC_API_KEY']
	)
	server_data = JSON.parse(response)
	servers = server_data["servers"]
	meters = []
	servers.map.with_index do |server|
		meter_data = {		
			name: server["name"],
			value: server["summary"]["memory"]
		}
		meters << meter_data
		#return meters
	end
	meters.each_with_index do |meter, index|
		send_event("memory"+(index+1).to_s,   { value: meters[index][:value], moreinfo: meters[index][:name] })
	end
	#puts meters[0]
end
