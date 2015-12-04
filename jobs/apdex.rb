require 'dotenv'
Dotenv.load
require 'net/http'
require 'json'
require 'rest_client'

url = 'https://api.newrelic.com/v2/key_transactions.json?filter[ids]=7937'
current_page_load = 0

SCHEDULER.every '1m' do
  response = RestClient.get(url, :'X-Api-Key' => ENV['NEWRELIC_API_KEY'] )
  data = JSON.parse(response)
  river_data = data['key_transactions']

  page_load_time = river_data[0]['end_user_summary']['response_time']
  apdex_target = river_data[0]['end_user_summary']['apdex_target']
  apdex_score = river_data[0]['end_user_summary']['apdex_score']

  send_event('pageload', { current: page_load_time.to_f, last: page_load_time.to_f } )
end