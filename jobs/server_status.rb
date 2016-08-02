require 'rest_client'
require 'csv'

# Check whether a server is responding

SCHEDULER.every '60s', :first_in => 0 do |job|

  statuses = Array.new

  url = "http://#{ENV['HA_PROXY_USER']}:#{ENV['HA_PROXY_PASSWORD']}@zozi.com:9100/;csv"

  response = RestClient.get(url)

  csv = CSV.parse(response.body[2..-1], headers: true)

  csv.each do |row|
    if row['pxname'] == 'application-backend' && row['svname'].match(/stinson-app[0-4]/)
      if row['status'] == 'UP'
        arrow = 'icon-ok-sign'
        color = 'green'
      else
        arrow = 'icon-warning-sign'
        color = 'red'
      end

      statuses.push({label: row['svname'], value: row['status'], arrow: arrow, color: color})
    end
  end

  # print statuses to dashboard
  send_event('server_status', {items: statuses})
end
