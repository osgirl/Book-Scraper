#!/usr/bin/ruby

# Require classes to use the Capybara functionality.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

class VisualConnection < Connection
    
    # Set up defaults to use when opening a connection
    def initialize
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
    def selectCourse 
 
        if @page.nil?
            raise "Unable to work on a null connection."
        end
=begin
        form = @page.find(:xpath, '//*[@id="FindCourse"]')
        rows = form.all('.bookRowContainer') # collect all search rows
        first_row = rows[0]
        puts first_row.path
        term_options = first_row.all('li.termOption')
        option = @page.find(:xpath, '/html/body/section/form/div/div[1]/div[2]/div[1]/ul/li[1]/div/div[2]/ul/li[1]')
        puts option
        for term in term_options
            puts term.text
            puts term.value
            puts term.path
        end
        puts term_options[0].path

        all('a').each { |a| a[:href] }
=end
        
    end
    
end