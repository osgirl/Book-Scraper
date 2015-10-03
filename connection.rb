#!/usr/bin/ruby

# Require the two classes to use the mechanize functionality.
require 'rubygems'
require 'mechanize'
# require access to the book object
require_relative 'book'

# Connection class : Create a connection to the B&N website using the mechanize gem.
# @date created:	09/26/15
class Connection

	# Url of the webpage to connect to every time a new connection starts.
	@@webpage = "http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/TBWizardView?catalogId=10001&langId=-1&storeId=33552"

    # Create a connection to the website
    def initialize
		@page = nil
	end

	# Open the connection to the website
	def open_connection
        @page = Mechanize.new.get(@@webpage) # grab pointer to the root webpage
		
		if @page.nil? 
            raise "Unable to connect to webpage. Check your internet connection and try again."
		end
        
        puts @page.search(".bookRowContainer") #Print the book containers
		
	end
	
	# Close the connection to the webpage and do any cleanup necessary to deconstruct the class.
	def close_connection
		@page = nil
	end

    # Parse the webpage and return an array of book records found on the site
	def parse
		records = []

		# ensure page has been connected to before parsing it 
		if @page.nil?
			raise "Unable to parse a nil connection."	
		end
		
		#return the array of records to the caller
		return records
	
	end

end

