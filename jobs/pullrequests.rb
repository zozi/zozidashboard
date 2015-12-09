require 'net/http'
require 'json'
require 'rest_client'
require 'github_api'
url = ENV['GITHUB_PULLS_URL']
access_token = ENV['GITHUB_API_TOKEN']

pull_requests = Hash.new({ value: 0 })
max_shown = 15

SCHEDULER.every '1m' do
	response = RestClient.get(url+"?access_token="+access_token)
	pr_data = JSON.parse(response)
	for index in (0..max_shown) do
		pull_requests[pr_data[index]["title"]] = { label: pr_data[index]["title"], value: pr_data[index]["user"]["login"]}
		#puts pr_data[index]["user"]["login"]
	end
	if(pr_data.length > max_shown)
		pull_requests["ZZZZZZZZZ"] = { label: (pr_data.length - max_shown).to_s + " more not shown", value: ""}
	end
	send_event('pullrequests', { items: pull_requests.values })
end
