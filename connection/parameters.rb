#!/usr/bin/ruby

require_relative '../scrapeLogger'

class Parameters
    
    DROPDOWN_OPTIONS = [TERM = "term", DEPT = "dept", COURSE = "course", nil]
    
    attr_accessor :termId
    attr_accessor :deptId
    attr_accessor :courseId
    attr_accessor :sectionId
    attr_accessor :dropdown
    
    # Class variable logger 
    @@logger = ScrapeLogger.new
    
    # Parameters termId, deptId and courseId should either be nil or a valid value pulled from B&N site
    # Parameter dropdown should be one of the 3 constants, TERM, DEPT, COURSE
    def initialize(termId, deptId, courseId, sectionId, dropdown)
        
        if termId.nil?
            @@logger.append "Unable to establish backend connection because term ID provided is nil"
            @@logger.append "Raising exception and terminating unless rescued."
            raise "If term is nil, a backend connection cannot be established."
        end
        @termId = termId
        
        # Cannot have 'section' without having a course, etc.
        if !deptId.nil?
            @deptId = deptId
            if !courseId.nil?
                @courseId = courseId
                if !sectionId.nil?
                    @sectionId = sectionId
                else
                    @sectionId = nil
                end
            else
                @courseId = nil
                @sectionId = nil
            end
        else
            @deptId = nil
            @courseId = nil
            @sectionId = nil
        end
        
        if DROPDOWN_OPTIONS.include?(dropdown)
            @dropdown = dropdown
        else
            @@logger.append "Invalid dropdown option provided."
            @@logger.append "Raising exception and terminating unless rescued."
            raise "Not a valid dropdown option."
        end
        
        if @dropdown === DEPT and @deptId.nil?
            @@logger.append "Invalid dropdown option provided."
            @@logger.append "Raising exception and terminating unless rescued."
            raise "Cannot dropdown on nil department"
        elsif @dropdown === COURSE and @courseId.nil?
            @@logger.append "Invalid dropdown option provided."
            @@logger.append "Raising exception and terminating unless rescued."
            raise "Cannot dropdown on nil course"
        end
        
    end
    
    def to_s
        rep = "&termId=#{@termId}"
        
        if !@deptId.nil?
            rep = rep + "&deptId=#{@deptId}"
            if !@courseId.nil?
                rep = rep + "&courseId=#{@courseId}"
                if !@sectionId.nil?
                    rep = rep + "&sectionId=#{@sectionId}"
                end
            end
        end
        
        if !@dropdown.nil?
            rep = rep + "&dropdown=#{@dropdown}"            
        end
        
        return rep
    end
    
    # Save this to filename
    def saveParameters(filename)
        open(filename, 'w') do |fout|
            fout << "#{@termId}|#{@deptId}|#{@courseId}|#{@sectionId}|#{@dropdown}\n"
        end 
    end
    
    # load the first line of filename into a Parameters object
    def self.loadCurrentParameters(filename)
        lines = nil
        open(filename, 'r') do |fin|
            lines = fin.readline.chomp!.split('|')
        end 
        
        return Parameters.new(lines[0], lines[1], lines[2], lines[3], lines[4])
        
    end
    
end
