#!/usr/bin/ruby

class ScrapeLogger
   
    LOGFILE = 'scraper.log'
    
    def initialize
        # Nothing to do here atm 
    end
    
    # Append time, message, and new line character to the scraper log file.
    def append(text)
        open(LOGFILE, 'a') do |fout|
            fout << "#{Time.new.strftime("%Y/%m/%d %H:%M:%S")}: #{text}\n"
        end 
    end
    
end