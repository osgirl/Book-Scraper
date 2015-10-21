#!/usr/bin/ruby

class Logger
   
    LOGFILE = 'scraper.log'
    
    def initialize
        # Nothing to do here atm 
    end
    
    def append(text)
        open(LOGFILE, 'a') do |fout|
            fout << text
        end 
    end
    
end