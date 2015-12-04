current_valuation = 0
current_karma = 220

SCHEDULER.every '5s' do
  last_valuation = current_valuation
  last_karma     = current_karma
  current_valuation = rand(100)
  current_karma     = last_karma + rand(-10..10)

  send_event('valuation', { current: current_valuation, last: last_valuation })
  send_event('pageload', { current: current_karma, last: last_karma })
  #send_event('memory',   { value: rand(100) })
end

current_work = 11
current_eat = 2
current_commute = 3
current_tv = 2

SCHEDULER.every '10s' do
	send_event('mychart', slices: [
        ['Task', 'Hours per Day'],
        ['Work',     current_work + rand(-1..1)],
        ['Eat',      current_eat + rand(-1..1)],
        ['Commute',  current_commute + rand(-1..1)],
        ['Watch TV', current_tv + rand(-1..1)]
      ])
end