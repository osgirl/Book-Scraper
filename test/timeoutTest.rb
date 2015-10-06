#!/usr/bin/ruby

require 'timeout'

(1..5).each do
    begin
        timeout(5) do
            sleep 6 
        end
    rescue Timeout::Error
        puts "Timeout!" 
    end
end