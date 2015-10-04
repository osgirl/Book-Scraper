#!/usr/bin/ruby

# Require the two classes to use the Capybara functionality.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

class Test
    
    # Url of the webpage to connect to every time a new connection starts.
    BASE_WEBPAGE = "http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/"
	VISUAL_WEBPAGE = "TBWizardView"
    BACKEND_WEBPAGE = "TextBookProcessDropdownsCmd"
    COMMON_PARAMETERS = "catalogId=10001&langId=-1&storeId=33552"
    
    attr_accessor :page
    attr_accessor :connection
    
    # Set up defaults to use when opening a connection
    def initialize
        Capybara.default_driver = :selenium
        Capybara.app_host = BASE_WEBPAGE
        Capybara.run_server = false
        @page = nil
        @connection = Capybara
    end
    
    def scrape
        @connection.visit("/#{VISUAL_WEBPAGE}?#{COMMON_PARAMETERS}")
    end
    
end

Test.new.scrape