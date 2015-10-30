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
    # Array of courses this book belongs to
    attr_accessor :course

	# Create a single record
	def initialize
		@isbn = nil
        @title = ""
		@author = ""
        @publisher = ""
        @edition = ""
        @image = nil
        @course = Course.new
	end

	# return a string representation of the record
	def to_s
        return "#{@title} by #{@author} edition #{@edition} published by #{@publisher} with ISBN: #{@isbn} for course #{@course.to_s}"
	end

    # Append record to a provided file
    def append(filename, delimiter)
        if !File.file? filename
             open(filename, 'w') do |fout|
                fout << "ISBN#{delimiter}TITLE#{delimiter}AUTHOR#{delimiter}PUBLISHER#{delimiter}EDITION#{delimiter}DEPARTMENT#{delimiter}COURSE_NUMBER#{delimiter}IMAGE_URL\n"
            end
        end
        open(filename, 'a') do |fout|
            fout << "#{@isbn}#{delimiter}#{@title}#{delimiter}#{@author}#{delimiter}#{@publisher}#{delimiter}#{@edition}#{delimiter}#{@course.department}#{delimiter}#{@course.number}#{delimiter}#{@image}\n"
        end 
    end

end

# Structure to store course information
class Course
    # Store the department
    attr_accessor :department
    # Store the course number
    attr_accessor :number
    
    def initialize
        @department = nil
        @number = nil 
    end
    
    def to_s
        return "#{@department} #{@number}" 
    end
    
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
    
    attr_accessor :category
    
    def initialize
        @category = Category.new
    end
    
    def to_s
        rep = "ID: #{@category.id} #{@category.name}\n"
    end
    
end

class Dept
    
    attr_accessor :category
    
    def initialize
        @category = Category.new
    end
    
end

class Course
    
    attr_accessor :category
    
    def initialize
        @category = Category.new
    end
    
end

class Section
    
    attr_accessor :category
    
    def initialize
        @category = Category.new
    end
    
end