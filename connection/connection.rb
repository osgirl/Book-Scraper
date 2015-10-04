#!/usr/bin/ruby

class Connection
    
    # Url of the webpage to connect to every time a new connection starts.
    BASE_WEBPAGE = "http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/"
    COMMON_PARAMETERS = "catalogId=10001&langId=-1&storeId=33552"
    
    attr_accessor :page
    attr_accessor :session
    
    # Set up defaults to use when opening a connection
    def initialize
        @page = nil
        @session = nil
    end
    
    # Ensure a connection has been established
    def check_connection
        
        if @page.nil? 
            raise "Unable to connect to webpage. Check your internet connection and the webpage URL."
		end
        
    end
    
    # Terminate the connection to the B&N site
    def close_connection
        
        @session = nil
        @page = nil
        
    end
    
end