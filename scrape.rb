#!/usr/bin/ruby

#require the class to establish the connection
require_relative 'connection/connection'
require_relative 'connection/visualConnection'
require_relative 'connection/backendConnection'
require_relative 'connection/parameters'
require_relative 'scrapeLogger'

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
                    2.times do 
                        begin
                            @connection.open_connection
                            @connection.enterCourseInformation(@sections)
                            @connection.submitRequest
                            break
                        rescue # If the connection fails to load the page properly, try again after 5 seconds
                            @@logger.append "Connection failed to initialize page fully. Retrying in 5 seconds."
                            sleep(5)
                        end
                    end
                    scrapedBooks = @connection.scrapeBooks
                    # for each scraped book, move it onto the csv of books
                    scrapedBooks.each do |scrapedBook|
                        scrapedBook.append('books.csv')
                        puts scrapedBook.to_s
                    end
                    @connection.close_connection
                    # Save the parameters to a file. Signifies it being the last file scraped
                    Parameters.new(term.category.id, dept.category.id, course.category.id, nil, nil).saveParameters(LastScrapedFile)
                    sleep(2) # try to avoid spamming the hell out of B&N site
                    @@logger.append "Finished parsing #{term.category.name} #{dept.category.name} #{course.category.name}"
                end # end the course scrape
            end # end dept scrape
        end # end term scrape
    end # end scrape method
end # end scrape class
