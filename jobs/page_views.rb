require 'dotenv'
Dotenv.load
require 'net/http'
require 'json'
require 'rest_client'

def get_page_views(date)
  url = "https://api.newrelic.com/v2/usages/BROWSER.json?start_date=" + date.to_s + "&end_date=" + date.to_s
  response = RestClient.get(url, :'X-Api-Key' => ENV['NEWRELIC_API_KEY'] )
  data = JSON.parse(response)
  return data['usage_data']['usages'][0]['usage']
end

date_yesterday = (Date.today.prev_day).strftime("%Y-%m-%d")
page_views_yesterday = get_page_views(date_yesterday)

SCHEDULER.every '1m' do
  date_today = (DateTime.now).strftime("%Y-%m-%d")
  page_views_today = get_page_views(date_today)
  send_event('page_views', { current: page_views_today, last: page_views_yesterday })
end
