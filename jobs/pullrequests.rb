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
		pull_requests[pr_data[index]["title"]] = { label: pr_data[index]["title"], value: 0}
		puts pr["title"]
	end
	send_event('pullrequests', { items: pull_requests.values })
end