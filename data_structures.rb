#!/usr/bin/ruby

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
    
    # An array to store all departments associated with this term
    attr_accessor :depts
    # Friendly name of the term
    attr_accessor :termName
    # ID corresponding to this term
    attr_accessor :termId
    
    def initialize 
        @depts = nil
        @termName = nil
        @termId = nil
    end
    
end

class Dept
    
    # An array to store all courses associated with this department
    attr_accessor :courses
    # Friendly name of the dept
    attr_accessor :deptName
    # ID corresponding to this dept
    attr_accessor :deptId
    
    def initialize 
        @courses = nil
        @deptName = nil
        @deptId = nil
    end
    
end

class Course
    
    # An array to store all sections associated with this course
    attr_accessor :sections
    # Friendly name of the course
    attr_accessor :courseName
    # ID corresponding to this course
    attr_accessor :courseId
    
    def initialize 
        @sections = nil
        @courseName = nil
        @courseId = nil
    end
    
end

class Section
    
    # Friendly name of the section
    attr_accessor :sectionName
    # ID corresponding to this section
    attr_accessor :sectionId
    
    def initialize 
        @sectionName = nil
        @sectionId = nil
    end
    
end