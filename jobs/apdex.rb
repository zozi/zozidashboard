# require 'dotenv'
# Dotenv.load
# require 'net/http'
# require 'json'
# require 'rest_client'

# url = 'https://api.newrelic.com/v2/key_transactions.json?filter[ids]=7937'
# current_page_load = 1

# SCHEDULER.every '1m' do
#   last_page_load = current_page_load
#   response = RestClient.get(url, :'X-Api-Key' => ENV['NEWRELIC_API_KEY'] )
#   data = JSON.parse(response)
#   river_data = data['key_transactions']

#   current_page_load = river_data[0]['end_user_summary']['response_time']
#   apdex_target = river_data[0]['end_user_summary']['apdex_target']
#   apdex_score = river_data[0]['end_user_summary']['apdex_score']

#   send_event('pageload', { current: current_page_load.to_f, last: last_page_load.to_f })
#   send_event('apdex', { current: apdex_score.to_f, last: apdex_target.to_f, goal: 4, title1: 'Goal', title2: 'Current' })
# end
