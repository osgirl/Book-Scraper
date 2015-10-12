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
                    if 1+rand(10) != 10
                        next
                    end
                    @connection = BackendConnection.new(Parameters.new(term.category.id, dept.category.id, course.category.id, nil, Parameters::COURSE))
                    @connection.open_connection
                    @sections = @connection.parseSections
                    @connection.close_connection 
                    course.sections = @sections
                    # For each section, get the books
                    puts "Parsing #{term.category.name} #{dept.category.name} #{course.category.name} at #{Time.new.strftime("%H:%M:%S")}"
                    @sections.each do |section|
                        puts "Visually connecting to: #{section.category.id}"
                        @connection = VisualConnection.new(Parameters.new(term.category.id, dept.category.id, course.category.id, section.category.id, nil))
                        @connection.open_connection
                        @connection.selectCourse
                        @connection.close_connection
                        puts "Parsed section: #{section.category.id}"
                    end
                    puts "Parsed #{term.category.name} #{dept.category.name} #{course.category.name} at #{Time.new.strftime("%H:%M:%S")}"

                    sleep((1+rand(3))) # Sleep for random time between 1 and 3 seconds. Don't spam servers.
                end
            end
        end
	end

	# Ensure the record is not a duplicate record or a supplement to a previous record
	def self.validate? (record)
		if record.type.casecmp("Supplement") == 0 || record.type.casecmp("Supplemental") == 0 || record.type == "" || record.location == "--" || record.location.casecmp("Supplement") == 0
			return false
		else
			return true
		end
	end

	#ensure startDate,endDate are valid DateTime objects, and that endDate is later than startDate
	#return an array of dates with the largest possible difference between each date being MAXIMUM_CONNECTION_LENGTH in days
	def parseDates(startDate,endDate)
		# ensure date passed as a parameter is a DateTime object
		if !startDate.is_a? DateTime or !endDate.is_a? DateTime
			raise "date is not a DateTime."
		end

		dateDifference = endDate-startDate

		#ensure endDate is later than startDate
		if dateDifference.to_i < 0
			raise "end date must be greater than start date"
		end

		#create an array of DateTime objects that have an acceptable length to pass to connection class
		#ie ensure that the greatest time difference between any two dates is less than the MAXIMUM_RECORD_LENGTH
		dates = []
		dates.push startDate
		while dateDifference.to_i > MAXIMUM_CONNECTION_LENGTH
			startDate = startDate + MAXIMUM_CONNECTION_LENGTH
			dates.push startDate

			dateDifference = endDate-startDate
		end
		dates.push endDate

		return dates
	end
end
#
#        rows = @page.search(".bookRowContainer") # collect all search rows
#        first_row = rows[0]
#        term_options = first_row.search(".termColumn li")
#        term_options[0].click
#        dept_options = first_row.search(".deptColumn")
#        #term_options = term.search("li");
#        #puts term_options
#        puts dept_options
#        return
#        term.click
#        
#        course = first_row.search(".courseColumn")
#        section = first_row.search(".sectionColumn")
#        
#        puts term
#        puts dept
#        puts course
#        puts section

