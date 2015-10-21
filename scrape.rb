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

    attr_reader :books
    
    # Class variable logger 
    @@logger = ScrapeLogger.new
    
	def initialize
        @books = Array.new
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
                        # for each book, if it already exists, add the course to it, otherwise, add it to books array
                        scrapedBooks.each do |scrapedBook|
                            exists = false
                            @books.each do |book|
                                if book.to_s.eql? scrapedBook.to_s
                                    book.courses.each do |course|
                                        # If the course is already inside the book, don't add it again
                                        if course.to_s.eql? scrapedBook.courses[0].to_s
                                            exists = true
                                            break
                                        end
                                    end
                                    # Course was not inside the book. Append it onto the list of books
                                    if !exists
                                        book.courses << scrapedBook.courses[0]
                                        exists = true
                                    end
                                    break
                                end
                            end 
                            @books << scrapedBook if !exists
                        end
                        @connection.close_connection
                        @books.each do |book|
                            puts book.to_s
                            book.courses.each do |course|
                                puts course 
                            end
                        end
                    end
                    @@logger.append "Finished parsing #{term.category.name} #{dept.category.name} #{course.category.name}"

                    #sleep((1+rand(3))) # Sleep for random time between 1 and 3 seconds. Don't spam servers.
                end
            end
        end
	end
end
