#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches the published iCloud calendar and writes the upcoming events to
# _data/events.yml so they can be rendered server-side by Jekyll.
#
# Why we bake instead of fetching client-side:
# the previous approach relied on api.cors.lol as a CORS proxy and started
# returning 429s. Doing this at build time removes the runtime dependency
# entirely; an hourly GitHub Actions cron keeps the page fresh.

require "date"
require "icalendar"
require "net/http"
require "time"
require "uri"
require "yaml"

ICAL_URL = "https://p57-caldav.icloud.com/published/2/MTM1OTE1NDM4NDEzNTkxNaX01E2vsgBXvJdLR2tCYdnBQr270iUB0EOJMVZDENhd7yA7Y6hr9WU4O5INm8o3z6VsjHUBf9vvzDKWqvIJzhc"
DATA_FILE = File.expand_path("../_data/events.yml", __dir__)
# Match the previous "shows are listed about a month in advance" copy with a
# little extra slack so a slow cron tick can't drop the next show off.
LOOKAHEAD_DAYS = 45

def fetch_ical(url)
  response = Net::HTTP.get_response(URI(url))
  raise "iCal fetch failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

  response.body
end

def to_time(value)
  return value if value.is_a?(Time)

  # Round-trip through iso8601 instead of DateTime#to_time, which emits a
  # deprecation warning on Ruby 4.x about timezone preservation.
  Time.parse(value.iso8601)
end

def all_day?(value)
  value.is_a?(Date) && !value.is_a?(DateTime)
end

raw = fetch_ical(ICAL_URL)
calendars = Icalendar::Calendar.parse(raw)

now = Time.now
cutoff = now + (LOOKAHEAD_DAYS * 86_400)

events = []
calendars.each do |cal|
  cal.events.each do |event|
    start_time = to_time(event.dtstart)
    next if start_time < now - 3600 # tiny grace window so an in-progress show still shows
    next if start_time > cutoff

    end_time = event.dtend ? to_time(event.dtend) : nil

    events << {
      "title"       => event.summary.to_s,
      "start"       => start_time.iso8601,
      "end"         => end_time&.iso8601,
      "all_day"     => all_day?(event.dtstart),
      "location"    => event.location.to_s,
      "description" => event.description.to_s,
      "url"         => event.url.to_s,
    }
  end
end

events.sort_by! { |e| e["start"] }

File.write(DATA_FILE, events.to_yaml)
puts "Wrote #{events.size} event(s) to #{DATA_FILE}"
