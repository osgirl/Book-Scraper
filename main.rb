#!/usr/bin/ruby

require_relative 'data_structures'
require_relative 'connection/connection'
require_relative 'connection/backendConnection'
require_relative 'connection/visualConnection'
require_relative 'connection/parameters'

# Main class used as controller for the book scraper.
# @Date Created: 10/02/15
# run this program with command 'ruby main.rb'

class Main

    #main running function to be called to begin the game
    def run

        loop do
            @books = Hash.new()
            input = displayMenu
            if input == 1 
                begin
                    @connection = BackendConnection.new
                    # Get the terms
                    @connection.open_connection
                    @terms = @connection.parseTerms
                    @connection.close_connection

                    # For each term, get the departments
                    @terms.each do |term|
                        @connection = BackendConnection.new(Parameters.new(term.category.id, nil, nil, Parameters::TERM))
                        @connection.open_connection
                        @depts = @connection.parseDepts
                        @connection.close_connection
                        term.depts = @depts
                        # For each department, get the courses
                        @depts.each do |dept|
                            @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, nil, Parameters::DEPT))
                            @connection.open_connection
                            @courses = @connection.parseCourses
                            @connection.close_connection
                            dept.courses = @courses
                            # For each course, get the sections
                            @courses.each do |course|
                                if 1+rand(10) != 10
                                    next
                                end
                                @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, course.category.id, Parameters::COURSE))
                                @connection.open_connection
                                @sections = @connection.parseSections
                                @connection.close_connection 
                                course.sections = @sections
                                puts "Parsed #{term.category.name} #{dept.category.name} #{course.category.name} at #{Time.new.strftime("%H:%M:%S")}"
                                sleep((1+rand(3))) # Sleep for random time between 1 and 3 seconds. Don't spam servers.
                            end
                        end
                    end
                rescue SystemExit, Interrupt # Catch ctrl + c and exit gracefully
                    puts "Program interrupt received."
                    break
                rescue SocketError
                    puts "Connection error at #{Time.new.strftime("%H:%M:%S")}"
                end
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
driver.run
