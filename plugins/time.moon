export get_coords = (input) ->
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{URL.escape(input)}"
  jstr, res = http.request url
  if res ~= 200
    return "_No results_"

  jdat = JSON.decode jstr

  if jdat.status == 'ZERO_RESULTS'
    return "_No results_"

  return {
    lat: jdat.results[1].geometry.location.lat
  	lon: jdat.results[1].geometry.location.lng
  }

run = (msg, matches) ->
  coords = get_coords matches[1]
  if type(coords) == 'string'
    return "_No connection_"

  url = "https://maps.googleapis.com/maps/api/timezone/json?location=#{coords.lat},#{coords.lon}&timestamp=#{}"
  jstr, res = https.request url
  if res ~= 200
    return "_No connection_"

  jdat = JSON.decode jstr
  timestamp = os.time! + (jdat.rawOffset or 0) + jdat.dstOffset
  utcoff = (jdat.rawOffset or 0 + jdat.dstOffset) / 3600
  if utcoff == math.abs(utcoff)
    utcoff = "+#{utcoff}"

  message = "#{os.date('*%I:%M %p*\n', timestamp)}#{os.date('%A, %B %d, %Y\n_', timestamp)}#{jdat.timeZoneName}_
`UTC #{utcoff}`"
  return message


description = "*Time !*"
usage = [[
`/time [location]`
Returns the time, date, and timezone for the given location
]]
patterns = {
  "^[/!#]time +(.+)$"
}

return {
  :description
  :usage
  :patterns
  :run
}
