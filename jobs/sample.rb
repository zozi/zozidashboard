current_valuation = 0
# current_karma = 220

SCHEDULER.every '5s' do
  last_valuation = current_valuation
  # last_karma     = current_karma
  current_valuation = rand(100)
  # current_karma     = last_karma + rand(-10..10)

  send_event('valuation', { current: current_valuation, last: last_valuation })
  # send_event('pageload', { current: current_karma, last: last_karma })
  #send_event('memory',   { value: rand(100) })
end

current_imported = 13000
current_stuck = 10000
current_provisionable = 8000
current_laps = 6000

SCHEDULER.every '1m' do
	send_event('mychart', slices: [
        ['Imported to ZOZI', 'Hours per Day'],
        ['Imported to ZOZI', current_imported + rand(0..20)],
        ['Missing Data',     current_stuck + rand(-13..2)],
        ['Provisionable',      current_provisionable + rand(-11..2)],
        ['Published LAPs',  current_laps + rand(-1..9)]
      ])
end