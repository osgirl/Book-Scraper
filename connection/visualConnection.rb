#!/usr/bin/ruby

# Require classes to use the Capybara functionality.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

class VisualConnection < Connection
    
    # Set up defaults to use when opening a connection
    def initialize(parameters = nil)
        super
        Capybara.default_driver = :selenium
        Capybara.app_host = BASE_WEBPAGE
        Capybara.run_server = false
    end
    
    # Open a connection to the B&N site and grab the body 
    def open_connection
        
        @session = Capybara::Session.new(:selenium)
        @session.visit("/#{VISUAL_WEBPAGE_FILE}?#{COMMON_PARAMETERS}")
        @page = @session.find(:xpath, '//body')
        check_connection
        
    end
    
    # Terminate the connection to the B&N site
    def close_connection
        
        @session.driver.quit
        super
        
    end
    
    # Fill out the form and press submit button
    # term instance_of? Term, dept instance_of? Dept, course instance_of? Course, section instance_of? Section
    def selectCourse
 
        if @page.nil?
            raise "Unable to work on a nil connection."
        end
        
        if @parameters.nil? 
            raise "Unable to scrape a book from a nil course. Provide VisualConnection with a valid Parameters list." 
        end
        
        rows = @session.all('.bookRowContainer')
        if rows.nil? # either page loaded wrong or the schema has changed
            raise "Check your connection and ensure the HTML schema has not changed. Then, try again."
        end
        
        headerElements = ['.termHeader', '.deptSelectInput', '.courseSelectInput', '.sectionSelectInput']
        childElements = ['.termHeader li', '.deptColumn li', '.courseColumn li', '.sectionColumn li']
        paramValues = [parameters.termId, parameters.deptId, parameters.courseId, parameters.sectionId]
        
        # Click on the header element
        4.times do |currElement|
            rows[0].find(headerElements[currElement]).click 
            foundElement = false
            @session.all('.bookRowContainer')[0].all(childElements[currElement]).each do |element|
                if currElement === 0 
                    if element['data-optionvalue'].eql? paramValues[currElement]
                        element.click
                        foundElement = true
                        break
                    end
                else
                    if element.text.eql? paramValues[currElement]
                        element.click
                        foundElement = true
                        break
                    end 
                end
            end
            if !foundElement 
                raise "Unable to find element #{paramValues[currElement]} on page." 
            end
        end
    
    @page.find_by_id('findMaterialButton').click
        
    end
    
end