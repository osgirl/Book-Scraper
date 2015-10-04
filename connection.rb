#!/usr/bin/ruby

# Require the two classes to use the Capybara functionality.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'
    
# require access to the book object
require_relative 'book'

class Connection
    
    # Url of the webpage to connect to every time a new connection starts.
    BASE_WEBPAGE = "http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/"
	VISUAL_WEBPAGE = "TBWizardView"
    BACKEND_WEBPAGE = "TextBookProcessDropdownsCmd"
    COMMON_PARAMETERS = "catalogId=10001&langId=-1&storeId=33552"
    
    attr_accessor :page
    attr_accessor :session
    
    # Set up defaults to use when opening a connection
    def initialize
        Capybara.default_driver = :selenium
        Capybara.app_host = BASE_WEBPAGE
        Capybara.run_server = false
        Capybara.default_selector = :xpath
        @page = nil
        @session = nil
    end
    
    def open_connection
        
        @session = Capybara::Session.new(:selenium)
        @session.visit("/#{VISUAL_WEBPAGE}?#{COMMON_PARAMETERS}")
        @page = @session.find('//body')
        
        if @page.nil? 
            raise "Unable to connect to webpage. Check your internet connection and the webpage URL."
		end
        
    end
    
    def close_connection
        
        @session.driver.quit
        @session = nil
        @page = nil
        
    end
    
end