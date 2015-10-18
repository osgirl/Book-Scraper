#!/usr/bin/ruby

#require the class to establish the connection
require_relative 'connection/connection'
require_relative 'connection/visualConnection'
require_relative 'connection/backendConnection'
require_relative 'connection/parameters'

# Scrape class :    Scrape books from the B&N site utilitizing the provided connection classes
# @date created:	10/12/15
class Scrape 

	def initialize
        # Nothing to do currently
	end

	def scrape
		@connection = BackendConnection.new
        # Get the terms
        @connection.open_connection
        @terms = @connection.parseTerms
        @connection.close_connection

        # For each term, get the departments
        @terms.each do |term|
            @connection = BackendConnection.new(Parameters.new(term.category.id, nil, nil, nil,Parameters::TERM))
            @connection.open_connection
            @depts = @connection.parseDepts
            @connection.close_connection
            term.depts = @depts
            # For each department, get the courses
            @depts.each do |dept|
                @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, nil, nil,Parameters::DEPT))
                @connection.open_connection
                @courses = @connection.parseCourses
                @connection.close_connection
                dept.courses = @courses
                # For each course, get the sections
                @courses.each do |course|
                    @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, course.category.id, nil, Parameters::COURSE))
                    @connection.open_connection
                    @sections = @connection.parseSections
                    @connection.close_connection 
                    course.sections = @sections
                    # For each section, get the books
                    puts "Began parsing #{term.category.name} #{dept.category.name} #{course.category.name} at #{Time.new.strftime("%H:%M:%S")}"
                    @sections.each do |section|
                        puts "Scraping books for section #{section.category.name}"
                        @connection = VisualConnection.new(Parameters.new(term.category.id, dept.category.name, course.category.name, section.category.name, nil))
                        #@connection = VisualConnection.new(Parameters.new('67388865', 'AEROENG', '3560', '6747', nil))
                        @connection.open_connection
                        @connection.selectCourse
                        @connection.submitRequest
                        @connection.scrapeBooks
                        @connection.close_connection
                    end
                    puts "Finished parsing #{term.category.name} #{dept.category.name} #{course.category.name} at #{Time.new.strftime("%H:%M:%S")}"

                    #sleep((1+rand(3))) # Sleep for random time between 1 and 3 seconds. Don't spam servers.
                end
            end
        end
	end
end
