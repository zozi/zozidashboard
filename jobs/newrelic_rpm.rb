require 'rest_client'
require 'active_support/all'
require 'byebug'

# Monitored applications
app_name = "ZOZI (Production)"

# Emitted metrics:
# - rpm_apdex
# - rpm_error_rate
# - rpm_throughput
# - rpm_errors
# - rpm_response_time
# - rpm_db
# - rpm_cpu
# - rpm_memory

zozi_pro_app_id = 161122

url = "https://api.newrelic.com/v2/applications/#{zozi_pro_app_id}/metrics/data.json"


SCHEDULER.every '5s', :first_in => 0 do |job|
  response = RestClient.get(url,
    params: {
      names: ['HttpDispatcher'],
      values: ['requests_per_minute'],
      from: "#{3.hours.ago}",
      to: "#{Time.now}"
    },
    'X-Api-Key' => ENV['NEWRELIC_API_KEY'])

  parsed_response = JSON.parse(response)

  metric_data = parsed_response['metric_data']['metrics'].find { |metric| metric['name'] == 'HttpDispatcher'}
  points = metric_data['timeslices'].map.with_index do |value, index|
    {
      x: DateTime.parse(value['from']).in_time_zone('Pacific Time (US & Canada)').to_i,
      y: value["values"]["requests_per_minute"]
    }
  end

  send_event(:rpm_throughput, points: points)
end
