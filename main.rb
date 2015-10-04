#!/usr/bin/ruby

require_relative 'book'
require_relative 'connection'
require_relative 'visualConnection'

# Main class used as controller for the book scraper.
# @Date Created: 10/02/15
# run this program with command 'ruby main.rb'

class Main

    #main running function to be called to begin the game
    def runProg

        loop do
            @books = Hash.new()
            input = displayMenu
            if input == 1 
                @connection = VisualConnection.new
                @connection.open_connection
                @connection.selectCourse
                #@connection.close_connection
            elsif input == 2 # Output instructions
                puts "Option 1 will scrape a single book from a random term, department, course and section"
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
driver.runProg
