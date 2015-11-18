#!/usr/bin/ruby

require_relative 'scrapeLogger'

# Persistent Scrape procedure: attempt to abstract out the connection failures.
# @date created:	11/17/15
logger = ScrapeLogger.new

failCount = 0
begin
    load 'scrape.rb'
rescue
    # wait a little while before attempting again
    logger.append('Persistent Scrape failed.')
    failCount = failCount + 1
    sleep 20
    retry # will never terminate unless terminated by user
end
