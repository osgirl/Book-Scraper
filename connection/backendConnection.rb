#!/usr/bin/ruby

# Require classes to use the Mechanize functionality.
require 'rubygems'
require 'mechanize'

# Need the data structures to create the scrape tree.
require_relative '../data_structures'

class BackendConnection < Connection
    
    
    attr_reader :webpage
    
    # Set up defaults to use when opening a connection
    def initialize(parameters = nil)
        
        super
        @webpage = nil
        
    end
    
    # Open a connection to the B&N site
    # Enter the ID value into each of the corresponding boxes. If no ID value currently exists, use nil.
    def open_connection
        
        # If connection already exists, close it before opening a new one
        if !@page.nil?
            close_connection 
        end
        
        # If no parameters have been provided, open visual webpage with mechanize
        if @parameters.nil?
            @webpage = "#{BASE_WEBPAGE}#{VISUAL_WEBPAGE_FILE}?#{COMMON_PARAMETERS}"    
        else
            @webpage = "#{BASE_WEBPAGE}#{BACKEND_WEBPAGE_FILE}?#{COMMON_PARAMETERS}#{@parameters.to_s}"    
        end
        
        # Wait 20 seconds max for connection
        agent = Mechanize.new
        agent.read_timeout = 20
        @session = agent.get(@webpage)
        check_connection
        @page = @session.body
        
    end
    
    # Terminate the connection to the B&N site
    def close_connection
        
        super
        
    end
    
    # Return all possible terms
    def parseTerms
        
        if @session.nil?
            raise "Unable to parse nil session." 
        end
        
        rows = @session.search('.bookRowContainer')
        if rows.nil? # either page loaded wrong or the schema has changed
            raise "Check your connection and ensure the HTML schema has not changed. Then, try again."
        end
        
        # Put both terms into a terms array
        terms = Array.new
        rows[0].search('.termOptions li').each do |termRaw|
            term = Term.new
            term.category = Category.new
            term.category.name = termRaw.text
            term.category.id = termRaw.attributes['data-optionvalue'].to_s
            terms << term # push element onto end of array
        end
        
        return terms
    end
    
    # Return all possible categories matching the regex in a 2D array
    def parseCategory
        return @page.scan(/"categoryName":"(\w*)","categoryId":"(\w*)"/)
    end
    
    def parseDepts
        
        if @session.nil?
            raise "Unable to parse nil session." 
        end
        
        depts = Array.new
        parseCategory.each do |category|
            dept = Dept.new
            dept.category = Category.new
            dept.category.name = category[0]
            dept.category.id = category[1]
            depts << dept
        end
        
        return depts
    end
    
    def parseCourses
        
        if @session.nil?
            raise "Unable to parse nil session." 
        end
        
        courses = Array.new
        parseCategory.each do |category|
            course = Course.new
            course.category = Category.new
            course.category.name = category[0]
            course.category.id = category[1]
            courses << course
        end
        
        return courses
    end
    
    def parseSections
        
        if @session.nil?
            raise "Unable to parse nil session." 
        end
        
        sections = Array.new
        parseCategory.each do |category|
            section = Course.new
            section.category = Category.new
            section.category.name = category[0]
            section.category.id = category[1]
            sections << section
        end
        
        return sections
    end
    
end