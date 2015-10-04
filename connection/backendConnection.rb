#!/usr/bin/ruby

# Require classes to use the Mechanize functionality.
require 'rubygems'
require 'mechanize'

class BackendConnection < Connection
    
    BACKEND_WEBPAGE = "TextBookProcessDropdownsCmd"
    
    # Set up defaults to use when opening a connection
    def initialize
        super
    end
    
    # Open a connection to the B&N site
    def open_connection
        
        @session = Mechanize.new.get("#{BASE_WEBPAGE}#{BACKEND_WEBPAGE}?#{COMMON_PARAMETERS}") # grab pointer to the root webpage
        @page = @session
        check_connection
        
    end
    
    # Terminate the connection to the B&N site
    def close_connection
        
        super
        
    end
    
end