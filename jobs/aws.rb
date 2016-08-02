require 'dotenv'
Dotenv.load
require './lib/cloud_watch'

# CPUUtilization

prod_instances = {
  "i-814e011d" => "stinson-app1",
  "i-834e011f" => "stinson-app2",
  "i-f64e016a" => "stinson-app3",
  "i-f74e016b" => "stinson-app4",
  "i-431659df" => "stinson-load1",
  "i-357c33a9" => "stinson-util1",
  "i-e56d2279" => "stinson-es1"
}

client = CloudWatch.new

SCHEDULER.every '20s', allow_overlapping: false do
  series = prod_instances.map do |instance_id, instance_name|
    response = client.get_metrics(
      metric_name: 'CPUUtilization',
      instance_id: instance_id,
      start_time: 3.hours.ago,
      end_time: Time.now
    )

    {
      name: instance_name,
      data: response.datapoints.map {|point| { x: point.timestamp.to_i, y: point.average}}
    }
  end

  send_event('aws_cpu', series: series)
end

SCHEDULER.every '20s', allow_overlapping: false do
  series = prod_instances.map do |instance_id, instance_name|
    response = client.get_metrics(
      namespace: 'System/Linux',
      metric_name: 'MemoryUtilization',
      instance_id: instance_id,
      start_time: 3.hours.ago,
      end_time: Time.now
    )

    {
      name: instance_name,
      data: response.datapoints.map {|point| { x: point.timestamp.to_i, y: point.average}}
    }
  end

  send_event('aws_memory', series: series)
end


SCHEDULER.every '20s', allow_overlapping: false do
  data = prod_instances.map.with_index do |(instance_id, instance_name), index|
    response = client.get_metrics(
      namespace: 'System/Linux',
      metric_name: 'DiskSpaceUtilization',
      instance_id: instance_id,
      start_time: 3.hours.ago,
      end_time: Time.now,
      period: 300,
      dimensions: [
        {
          name: 'Filesystem',
          value: '/dev/xvda1'
        },
        {
          name: "MountPath",
          value: "/"
        }
      ]
    )

    {
      name: instance_name,
      progress: response.datapoints.last.average.round(2)
    }
  end

  send_event('aws_disk_usage', title: 'Disk Usage', progress_items: data)
end
