#!/usr/bin/ruby

#require the class to establish the connection
require_relative 'connection/connection'
require_relative 'connection/visualConnection'
require_relative 'connection/backendConnection'
require_relative 'connection/parameters'
require_relative 'scrapeLogger'

require 'optparse'
require 'fileutils'

# Scrape class :    Scrape books from the B&N site utilitizing the provided connection classes
# @date created:	10/12/15
class Scrape
    
    # Class variable logger 
    @@logger = ScrapeLogger.new
    
    # Store the next set of parameters in the case that this is a continuation of a previous scrape
    LastScrapedFile = 'last.dat'
    attr_accessor :next
    
	def initialize
        @next = nil
        @next = Parameters.loadCurrentParameters(LastScrapedFile) if File.file?(LastScrapedFile) 
	end

	def scrape
		@connection = BackendConnection.new
        # Get the terms
        @connection.open_connection
        @terms = @connection.parseTerms
        @connection.close_connection

        # For each term, get the departments
        @terms.each do |term|
            if (!@next.nil? and !@next.termId.nil?)
                if term.category.id.eql? @next.termId 
                    @next.termId = nil
                else
                    next
                end
            end
            puts "Scraping term: #{term.category.name}"
            @connection = BackendConnection.new(Parameters.new(term.category.id, nil, nil, nil,Parameters::TERM))
            @connection.open_connection
            @depts = @connection.parseDepts
            @connection.close_connection
            # For each department, get the courses
            @depts.each do |dept|
                if (!@next.nil? and !@next.deptId.nil?)
                    if dept.category.id.eql? @next.deptId 
                        @next.deptId = nil
                    else
                        next
                    end
                end
                puts "Scraping department: #{dept.category.name}"
                @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, nil, nil,Parameters::DEPT))
                @connection.open_connection
                @courses = @connection.parseCourses
                @connection.close_connection
                # For each course, get the sections
                @courses.each do |course|
                    if (!@next.nil? and !@next.courseId.nil?)
                        if course.category.id.eql? @next.courseId 
                            @next = nil
                            next
                        else
                            next
                        end
                    end
                    puts "Scraping course: #{course.category.name}"
                    @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, course.category.id, nil, Parameters::COURSE))
                    @connection.open_connection
                    @sections = @connection.parseSections
                    @connection.close_connection 
                    # For each section, get the books
                    @@logger.append "Began parsing #{term.category.name} #{dept.category.name} #{course.category.name}"
                    @connection = VisualConnection.new(Parameters.new(term.category.id, dept.category.name, course.category.name, nil, nil))
                    #@connection = VisualConnection.new(Parameters.new('67388865', 'AEROENG', '3560', nil, nil))
                    2.times do |currTry|
                        begin
                            @connection.open_connection
                            @connection.enterCourseInformation(@sections)
                            @connection.submitRequest
                            break
                        rescue # If the connection fails to load the page properly, try again after 5 seconds
                            if currTry < 1
                                @@logger.append "Connection failed to initialize page fully. Retrying in 5 seconds."
                                sleep(5)
                            else
                                @@logger.append "Connection failed to initialize page fully. Terminating."
                                raise "Unable to establish connection."
                            end
                        end
                    end
                    scrapedBooks = @connection.scrapeBooks
                    
                    # Only append unique books per course to the csv file
                    uniqueBooks = Array.new
                    scrapedBooks.each do |scrapedBook|
                        unique = true
                        uniqueBooks.each do |uniqueBook|
                            if scrapedBook.to_s.eql? uniqueBook.to_s
                                unique = false
                                break
                            end
                        end
                        if unique
                            uniqueBooks << scrapedBook 
                            scrapedBook.append("data/#{term.category.id}.#{dept.category.name}.csv.lock", '|')
                            puts scrapedBook.to_s
                        end
                    end
                    @connection.close_connection
                    # Save the parameters to a file. Signifies it being the last file scraped
                    Parameters.new(term.category.id, dept.category.id, course.category.id, nil, nil).saveParameters(LastScrapedFile, false)
                    sleep(2) # try to avoid spamming the hell out of B&N site
                    @@logger.append "Finished parsing #{term.category.name} #{dept.category.name} #{course.category.name}"
                end # end the course scrape
                
                # Unlock the file for the finished department
                FileUtils.mv("data/#{term.category.id}.#{dept.category.name}.csv.lock","data/#{term.category.id}.#{dept.category.name}.csv", :force => true)
                
            end # end dept scrape
        end # end term scrape
    end # end scrape method
end # end scrape class

# Confirm that the user wants to start the scraping process from the start
def confirm
    puts "Are you sure you wish to reset the scraping process? (Y|N)"

    input = nil
    while(true)
        input = gets.chomp 
        if input.nil?
            puts "Invalid option."
        else
            if input.eql? "Y" or input.eql? "y"
                return true
            elsif input.eql? "N" or input.eql? "n"
                return false
            end
        end
    end
end

# Parse the command line options 
options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: scrape.rb [options]"

    opts.on('-r', '--reset') { |v| options[:reset] = 1 }
    opts.on('-f', '--force') { |v| options[:force] = 1 }

end.parse!

# check if the user has initiated a reset
if !options[:reset].nil?
    if !options[:force].nil? or confirm
        puts "Deleting scraped books and bookmark."
        FileUtils.rm('last.dat', :force => true)
        Dir.glob('*.csv').each do |f|
            FileUtils.rm(f, :force => true)
        end
        Dir.glob('*.csv.lock').each do |f|
            FileUtils.rm(f, :force => true)
        end
    end
end

# Begin scraping
logger = ScrapeLogger.new
begin
    scraper = Scrape.new
    puts "Scraping Started."
    logger.append "Scraping Started."
    scraper.scrape
    puts "Scraping Complete."
    logger.append "Scraping Complete."
rescue SystemExit, Interrupt # Catch ctrl + c and exit gracefully
    puts "Program interrupt received."
    logger.append "Program interrupt received"
rescue SocketError
    puts "Connection error at #{Time.new.strftime("%H:%M:%S")}"
    logger.append "Connection error"
end
