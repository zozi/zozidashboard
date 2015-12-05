require 'tracker_api'

# This sends events for each of these projects
# to widgets with IDs of 'pivotal-<project_id>' (e.g. 'pivotal-1133342')
projects = [1170950]

client = TrackerApi::Client.new(token: ENV['PIVOTAL_API_TOKEN'])

SCHEDULER.every '10s', :first_in => 0 do
  projects.each do |project_id|
    project = client.project(project_id, fields: ':default,current_volatility,current_velocity')

    iterations = project.iterations(fields: 'start,stories(estimate,accepted_at)').select{ |i| i.start <= DateTime.now }
    velocities = iterations.map.with_index(1) do |iteration, x|
      {
        #"start" => iteration.start.strftime("%b %d"),
        "x"     => x,
        "y"     => iteration.stories.reject { |s| s.accepted_at.nil? }.reduce(0) { |points,story| points += (story.estimate || 0) }
      }
    end
    send_event("pivotal", points: velocities, displayedValue: project.current_velocity)
  end
end