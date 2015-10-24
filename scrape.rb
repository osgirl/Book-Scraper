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
    
	def initialize
        # Nothing to do here atm
	end

	def scrape
		@connection = BackendConnection.new
        # Get the terms
        @connection.open_connection
        @terms = @connection.parseTerms
        @connection.close_connection

        # For each term, get the departments
        @terms.each do |term|
            puts "Scraping term: #{term.category.name}"
            @connection = BackendConnection.new(Parameters.new(term.category.id, nil, nil, nil,Parameters::TERM))
            @connection.open_connection
            @depts = @connection.parseDepts
            @connection.close_connection
            term.depts = @depts
            # For each department, get the courses
            @depts.each do |dept|
                puts "Scraping department: #{dept.category.name}"
                @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, nil, nil,Parameters::DEPT))
                @connection.open_connection
                @courses = @connection.parseCourses
                @connection.close_connection
                dept.courses = @courses
                # For each course, get the sections
                @courses.each do |course|
                    puts "Scraping course: #{course.category.name}"
                    @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, course.category.id, nil, Parameters::COURSE))
                    @connection.open_connection
                    @sections = @connection.parseSections
                    @connection.close_connection 
                    course.sections = @sections
                    # For each section, get the books
                    @@logger.append "Began parsing #{term.category.name} #{dept.category.name} #{course.category.name}"
                    @sections.each do |section|
                        puts "Scraping section: #{section.category.name}"
                        @connection = VisualConnection.new(Parameters.new(term.category.id, dept.category.name, course.category.name, section.category.name, nil))
                        #@connection = VisualConnection.new(Parameters.new('67388865', 'AEROENG', '3560', '6747', nil))
                        @connection.open_connection
                        @connection.selectCourse
                        @connection.submitRequest
                        scrapedBooks = @connection.scrapeBooks
                        # for each scraped book, move it onto the csv of books
                        scrapedBooks.each do |scrapedBook|
                            scrapedBook.append('books.csv')
                            puts scrapedBook.to_s
                        end
                        @connection.close_connection
                    end
                    @@logger.append "Finished parsing #{term.category.name} #{dept.category.name} #{course.category.name}"
                end
            end
        end
	end
end
