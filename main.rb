#!/usr/bin/ruby

require_relative 'data_structures'
require_relative 'scrape'
require_relative 'scrapeLogger'

# Main class used as controller for the book scraper.
# @Date Created: 10/02/15
# run this program with command 'ruby main.rb'

class Main
    
    # Class variable logger 
    @@logger = ScrapeLogger.new

    #main running function to be called to begin the game
    def run

        loop do
            @books = Hash.new()
            input = displayMenu
            if input == 1 
                begin
                    Scrape.new.scrape
                    puts "Scraping Complete."
                    @@logger.append "Scraping Complete."
                rescue SystemExit, Interrupt # Catch ctrl + c and exit gracefully
                    puts "Program interrupt received."
                    @@logger.append "Program interrupt received"
                    break
                rescue SocketError
                    puts "Connection error at #{Time.new.strftime("%H:%M:%S")}"
                    @@logger.append "Connection error"
                end
            elsif input == 2 # Output instructions
                puts "Option 1 will scrape all books from the B&N website associated with the OSU department courses."
            elsif input == 3 #force update
                break
            end
        end
    end
    
    def initialize
        @connection = nil
    end

    def displayMenu
        #output menu to user
        puts "Choose an option:"
        puts "1. Scrape a book"
        puts "2. Instructions"
        puts "3. Quit"
        
        input = nil
        while(true)
            puts "Choice: "
            input = gets.chomp #Get user input
            #attempt to convert input to an integer
            #make sure integer is between 1 and 3
            input = Integer(input) rescue nil
            if input.nil? || !input.between?(1,3)
                puts "Invalid menu option. Please choose again."
            else
                return input
            end
        end
    end

end

#run the program
driver = Main.new
driver.run
