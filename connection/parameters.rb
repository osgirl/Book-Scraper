#!/usr/bin/ruby

class Parameters
    
    DROPDOWN_OPTIONS = [TERM = "term", DEPT = "dept", COURSE = "course"]
    
    attr_reader :termId
    attr_reader :deptId
    attr_reader :courseId
    attr_reader :sectionId
    attr_reader :dropdown
    
    # Parameters termId, deptId and courseId should either be nil or a valid value pulled from B&N site
    # Parameter dropdown should be one of the 3 constants, TERM, DEPT, COURSE
    def initialize(termId, deptId, courseId, sectionId, dropdown)
        
        if termId.nil?
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
            raise "Not a valid dropdown option."
        end
        
        if @dropdown === DEPT and @deptId.nil?
            raise "Cannot dropdown on nil department"
        elsif @dropdown === COURSE and @courseId.nil?
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
        
        rep = rep + "&dropdown=#{@dropdown}"
        
        return rep
    end
    
end
