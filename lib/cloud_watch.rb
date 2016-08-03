require 'aws-sdk'

class CloudWatch
  def initialize
    @client = Aws::CloudWatch::Client.new(region: ENV['AWS_REGION'])
  end


  def get_metrics(**options)
    parsed_options = build_metric_options(options)
    @client.get_metric_statistics(parsed_options)
  end

  def build_metric_options(namespace: 'AWS/EC2', metric_name:, dimensions: [], instance_id:, start_time: 3.hours.ago, end_time: Time.now, period: 300)
    {
      namespace: namespace,
      metric_name: metric_name,
      dimensions: [
        {
          name: 'InstanceId',
          value: instance_id
        }
      ].concat(dimensions),
      start_time: start_time.utc.iso8601, # required
      end_time: end_time.utc.iso8601, # required
      period: period, # required
      statistics: ["Average"], # required, accepts SampleCount, Average, Sum, Minimum, Maximum
    }
  end
end
