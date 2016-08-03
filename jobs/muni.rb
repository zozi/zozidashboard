# require 'muni'

# fourtyseven = []
# next_munis = Hash.new({ value: 0 })

# SCHEDULER.every '1m' do
# 	fourtyseven = Muni::Route.find(47).outbound.stop_at("Powell and Beach").predictions
# 	failtrain = Muni::Route.find("F").outbound.stop_at("Embarcadero and Stockton").predictions
# 	next_munis["47"] = { label: "47", value: fourtyseven[0][:minutes]+"m and "+fourtyseven[1][:minutes]+"m"}
# 	next_munis["Fail Train"] = {label: "Fail Train", value: failtrain[0][:minutes]+"m and "+failtrain[1][:minutes]+"m"}
# 	send_event('nextmuni', {items: next_munis.values})
# end
