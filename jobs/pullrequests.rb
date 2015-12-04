require 'net/http'
require 'json'
require 'rest_client'

url = 'https://api.github.com/repos/julienschmidt/httprouter/pulls'

pull_requests = Hash.new({ value: 0 })

SCHEDULER.every '10m' do
	response = RestClient.get(url)
	pr_data = JSON.parse(response)
	puts pr_data[0]["title"]
	pr_data.map.with_index do |pr, index|
		pull_requests[pr_data[index]["title"]] = { label: pr_data[index]["title"], value: pr_data[index]["user"]["login"]}
		#puts pr_data[index]["user"]["login"]
	end
	send_event('pullrequests', { items: pull_requests.values })
	# result = RestClient.post('https://github.com/login/oauth/access_token',
 #                          {:client_id => ENV['CLIENT_ID'],
 #                           :client_secret => ENV['CLIENT_SECRET'],
 #                           :code => ENV['SESSION_CODE']},
 #                           :accept => :json)

	# extract the token and granted scopes
	#access_token = JSON.parse(result)['access_token']
	#auth_result = JSON.parse(RestClient.get('https://api.github.com/user',
                                        #{:params => {:access_token => access_token}}))
	#puts auth_result
end