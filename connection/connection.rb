#!/usr/bin/ruby

require_relative '../scrapeLogger'

class Connection
    
    # Url of the webpage to connect to every time a new connection starts.
    BACKEND_WEBPAGE_FILE = "TextBookProcessDropdownsCmd"
    VISUAL_WEBPAGE_FILE = "TBWizardView"
    BASE_WEBPAGE = "http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/"
    COMMON_PARAMETERS = "catalogId=10001&langId=-1&storeId=33552"
    
    attr_accessor :page
    attr_accessor :session
    attr_accessor :parameters
    
    # Class variable logger 
    @@logger = ScrapeLogger.new
    
    # Set up defaults to use when opening a connection
    def initialize(parameters)
        @page = nil
        @session = nil
        
        if !parameters.nil? and parameters.instance_of? Parameters
            @parameters = parameters
        else
            @parameters = nil
        end
        
    end
    
    # Ensure a connection has been established
    def check_connection
        
        if @session.nil? 
            @@logger.append "Unable to connect to webpage. Internet connection may be spotty or disconnected. Webpage URL also may be invalid."
            raise "Unable to connect to webpage. Check your internet connection and the webpage URL."
		end
        
    end
    
    # Terminate the connection to the B&N site
    def close_connection
        
        @session = nil
        @page = nil
        
    end
    
end