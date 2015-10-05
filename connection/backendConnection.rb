#!/usr/bin/ruby

# Require classes to use the Mechanize functionality.
require 'rubygems'
require 'mechanize'

# Need the data structures to create the scrape tree.
require_relative '../data_structures'

class BackendConnection < Connection
    
    attr_accessor :parameters
    attr_reader :webpage
    
    # Set up defaults to use when opening a connection
    def initialize(parameters = nil)
        
        super()
        
        if !parameters.nil? and parameters.instance_of? Parameters
            @parameters = parameters
        else
            @parameters = nil
        end
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
        
        @session = Mechanize.new.get(@webpage)
        @page = @session.body
        check_connection
        
    end
    
    # Terminate the connection to the B&N site
    def close_connection
        
        super
        
    end
    
    # Return all possible terms
    def parseTerms
        rows = @session.search('.bookRowContainer')
        if rows.nil? # either page loaded wrong or the schema has changed
            raise "Check your connection and ensure the HTML schema has not changed. Then, try again."
        end
        
        # Put both terms into a terms array
        terms = Array.new
        rows[0].search('.termOptions li').each do |termRaw|
            term = Term.new
            term.termName = termRaw.text
            term.termId = termRaw.attributes['data-optionvalue'].to_s
            terms << term # push element onto end of array
        end
        
        return terms
    end
    
    # Return all possible departments
    def parseDepts
        
    end
    
    # Return all possible courses
    def parseCourses
        
    end
    
    # Return all possible sections
    def parseSections
        
    end
    
end