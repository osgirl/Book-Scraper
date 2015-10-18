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
    # Image of the book 
    attr_accessor :image

	# Create a single record
	def initialize
		@isbn = nil
        @title = ""
		@author = ""
        @publisher = ""
        @edition = ""
        @image = nil
	end

	# return a string representation of the record
	def to_s
		return "#{@title} by #{@author} edition #{@edition} published by #{@publisher}"
	end

	# Other possible methods relevant to the record class

end

# Common structure for all Terms, Depts, Courses and Sections
class Category
    # Friendly name of this category
    attr_accessor :name
    # ID corresponding to this category
    attr_accessor :id
    
    def initialize 
        @name = nil
        @id = nil
    end
    
end

class Term
    
    # An array to store all departments associated with this term
    attr_accessor :depts
    attr_accessor :category
    
    def initialize 
        @depts = nil
        @category = Category.new
    end
    
    def to_s
        rep = "ID: #{@category.id} #{@category.name}\n"
        if !@depts.nil?
            depts.each do |dept|
                rep = "#{rep}\t#{dept.to_s}\n" 
            end
        end
    end
    
end

class Dept
    
    # An array to store all courses associated with this department
    attr_accessor :courses
    attr_accessor :category
    
    def initialize 
        @courses = nil
        @category = Category.new
    end
    
end

class Course
    
    # An array to store all sections associated with this course
    attr_accessor :sections
    attr_accessor :category
    
    def initialize 
        @sections = nil
        @category = Category.new
    end
    
end

class Section
    
    attr_accessor :category
    
    def initialize
        @category = Category.new
    end
    
end