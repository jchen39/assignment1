require 'csv'

CourseInfo = []
StudentInfo = []

class Create

    CID = []
    CNUM = []
    Title = 

    # Populates our input arrays with the data from the csv file with course id, section, and names
    # Then each course is instantiated with their corresponding values
    def create_courses
        begin
            puts "Enter the name of the course list file(include .csv):"
            listFile = gets.chomp

            CSV.foreach(("FYS-course-list.csv"), headers: true, col_sep: ",") do |col|
                CID << col[0]
                CNUM << col[1]
                Title << col[2]
            end
        rescue
            puts "File cannot be found, try again:"
            create_courses
        end

        # Object instantiation
        for i in 0..CID.length - 1
            CourseInfo[i] = Course.new(CID[i], CNUM[i], Title[i], 0, 18)
        end
    end

    SID = []
    Selection = []

    # Populates our input arrays with the data from the csv file with student id and selections
    # Then each student is instantiated with their ids and course choices
    def create_students
        begin
            puts "Enter the name of the students & selections file(include .csv):"
            selectFile = gets.chomp
        
            CSV.foreach(("FYS-Selections.csv"), headers: true, col_sep: ",") do |col|
                SID << col[0]
                Selection << col[1]
            end
        rescue
            puts "File cannot be found, try again:"
            create_students
        end

        # Object instantiation
        for i in 0..SID.length - 1
            StudentInfo[i] = Student.new(SID[i], Selection[i])
        end
    end
end

# Course class containing attributes that help identify the course
class Course
    attr_accessor :cID, :cNum, :cName, :numStudents, :max

    def initialize(id, num, nam, stu, max)
        @cID = id
        @cNum = num
        @cName = nam
        @numStudents = stu
        @max = max
    end

    # Checks if the current course has space for another student
    def is_open
        if @numStudents < @max
            return true
        end
    end

    # Checks if the current course has reached the capacity
    def at_capacity
        if @numStudents == @max
            return true
        end
    end
    
    # Checks if current course has less than 10 students
    def under_10
        if @numStudents < 10
            return true
        end
    end

end

# Student class to help identify each student and their choices
class Student
    attr_accessor :sID, :choices, :course

    def initialize(id, cho)
        @sID = id
        @choices = cho
    end

    # Checks if the current student is already enrolled in a course
    def has_course
        if @course
            return true
        end
        return false
    end

end

# Checks the list of courses available
# If the course is open, assign the student to that course
def assign_to_open(course, student)
    for i in 0..course.length - 1
        if course[i].at_capacity
            next
        end
        for j in 0..student.length - 1
            if course[i].is_open
                student[j].course = course[i].cID
                course[i].numStudents += 1
                return course[i].cID
            end
        end
    end
end

# Assigns each student to a course based on their choices
# If a student doesn't have a choice, then assign them to any open course
def assign_course(student, course)
    for i in 0..student.length - 1
        if student[i].has_course
            next
        else
            for j in 0..course.length - 1
                if course[j].cID == student[i].choices && course[j].is_open
                    student[i].course = course[j].cID
                    course[j].numStudents += 1
                    break
                elsif course[j].at_capacity
                    next
                elsif student[i].choices == ""
                    student[i].course = assign_to_open(course, student)
                end
            end
        end
    end
end

def get_input
    
    puts "How many FYS are offered?"
    numCourses = gets.chomp

    puts "How many students are in the incoming class?"
    numStudents = gets.chomp

end

def get_output

    puts "Enter the desired name of output file 1(.csv):"
    out1 = gets.chomp

    puts "Enter the desired name of output file 2(.csv):"
    out2 = gets.chomp

    puts "Enter the desired name of output file 3(.txt):"
    out3 = gets.chomp

    
    CSV.open(out1, 'wb') do |csv|
        csv << ["Course ID", "Student ID"]
    end

    CSV.open(out2, 'wb') do |csv|
        csv << ["Course ID", "Course Number", "Course Title", "Student ID", "Under 10?"]
    end

    output = File.new(out3, "w")
    output.puts("The number of students enrolled in a course:")
    output.puts("The number of students not enrolled in a course:")
    output.puts("The number of courses that can run:")
    output.puts("The number of courses with fewer than 10 students:")

    puts "All files have been created. Please check your current directory"

end

get_input
c= Create.new
c.create_courses
c.create_students
assign_course(StudentInfo, CourseInfo)
get_output
