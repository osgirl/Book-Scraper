#!/usr/bin/ruby

# need to require date to create DateTime objects
require 'date'

# Record class : Store data and methods relevant to a single Book record
# date created:	09/25/15
class Book
	
    # the unique identifier of the book
	attr_accessor :isbn
    # title of the book
    attr_accessor :title
    # author of the book
	attr_accessor :author
    # publisher of the book
    attr_accessor :publisher
    # book edition
    attr_accessor :edition
    # Price of the book
    attr_accessor :price
    # Image of the book 
    attr_accessor :image

	# Create a single record
	def initialize
		@isbn = nil
        @title = ""
		@author = ""
        @publisher = ""
        @edition = ""
        @price = 0
        @image = nil
	end

	# return a string representation of the record
	def to_s

		return "#{@title} by #{@author} edition #{@edition} published by #{@publisher}"

	end

	# Other possible methods relevant to the record class

end

class Term
    
end

class Dept
    
end

class Course
    
end

class Section
    
end