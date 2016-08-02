require 'dotenv'
Dotenv.load
require './lib/cloud_watch'
require './lib/application'

applications = Application.init

client = CloudWatch.new

# CPUUtilization
SCHEDULER.every '20s', allow_overlapping: false do

  applications.each do |application|
    series = application.instances.map do |instance_id, instance_name|
      response = client.get_metrics(
        metric_name: 'CPUUtilization',
        instance_id: instance_id
      )

      {
        name: instance_name,
        data: response.datapoints.map {|point| { x: point.timestamp.to_i, y: point.average}}
      }
    end

    send_event("#{application.name}_aws_cpu", series: series)
  end

end

# # Memory Utilization
SCHEDULER.every '20s', allow_overlapping: false do

  applications.each do |application|
    series = application.instances.map do |instance_id, instance_name|
      response = client.get_metrics(
        namespace: 'System/Linux',
        metric_name: 'MemoryUtilization',
        instance_id: instance_id
      )

      {
        name: instance_name,
        data: response.datapoints.map {|point| { x: point.timestamp.to_i, y: point.average}}
      }
    end

    send_event("#{application.name}_aws_memory", series: series)
  end

end

# # Disk Space Utilization
SCHEDULER.every '20s', allow_overlapping: false do

  applications.each do |application|
    data = application.instances.map.with_index do |(instance_id, instance_name), index|
      response = client.get_metrics(
        namespace: 'System/Linux',
        metric_name: 'DiskSpaceUtilization',
        instance_id: instance_id,
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

    send_event("#{application.name}_aws_disk_usage", title: 'Disk Usage', progress_items: data)
  end

end
