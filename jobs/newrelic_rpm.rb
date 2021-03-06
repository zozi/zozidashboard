require 'rest_client'
require 'active_support/all'
require 'byebug'
require './lib/application'

applications = Application.init

# Emitted metrics:
# - rpm_apdex
# - rpm_error_rate
# - rpm_throughput
# - rpm_errors
# - rpm_response_time
# - rpm_db
# - rpm_cpu
# - rpm_memory

SCHEDULER.every '10s', :first_in => 0 do |job|

  applications.each do |application|
    fetch_new_relic_stats(application.new_relic[:app_id], application.name)
  end

end

def fetch_new_relic_stats(app_id, app_name)
  response = RestClient.get("https://api.newrelic.com/v2/applications/#{app_id}/metrics/data.json",
    params: {
      names: ['HttpDispatcher', 'Errors/all'],
      values: ['requests_per_minute', 'error_count'],
      from: "#{3.hours.ago}",
      to: "#{Time.now}"
    },
    'X-Api-Key' => ENV['NEWRELIC_API_KEY'])

  parsed_response = JSON.parse(response)

  rpm_graph_points = generate_points(parsed_response, 'HttpDispatcher', 'requests_per_minute')
  error_graph_points = generate_points(parsed_response, 'Errors/all', 'error_count')

  send_event("#{app_name}_rpm_throughput", points: rpm_graph_points)
  send_event("#{app_name}_rpm_errors", points: error_graph_points)
end


def generate_points(data_source, metric_name, value_name)
  metric_data = data_source['metric_data']['metrics'].find { |metric| metric['name'] == metric_name }
  metric_data['timeslices'].map.with_index do |value, index|
    {
      x: DateTime.parse(value['from']).in_time_zone('Pacific Time (US & Canada)').to_i,
      y: value["values"][value_name]
    }
  end
end
