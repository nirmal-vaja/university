require 'roo'
namespace :import do
  desc "Import data from spreadsheet"
  task :faculty_details, [:id] => [:environment] do

    # puts 'Importing Data'

    excel_sheet = ExcelSheet.find_by_id(args[:id])

    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(excel_sheet.sheet)
      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i+=1
      end
      user_data = []
      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      puts downcased_headers
      data.each_with_index do |row, idx|
        next if idx == 0 # skip header
        # create hash from headers and cells
        user_data = Hash[[downcased_headers, row].transpose]

        user_data.each do |user|
          first_name = user[:faculty_name].split(' ')[0]
          last_name = user[:faculty_name].split(' ')[1]
          phone_number = user[:phone_number]
          designation = user[:designation]
          date_of_joining = user[:doj]
          gender = user[:gender]
          department = user[:department]
          email = user[:email]
          current_subject = Subject.find_by_code(user[:current_subject_code])
          previous_subject = Subject.find_by_code(user[:previous_subject_code])

          new_user = User.new(
            first_name: first_name,
            last_name: last_name,
            phone_number: phone_number,
            designation: designation,
            date_of_joining: date_of_joining,
            email: email,
            department: department,
            gender: gender,
            status: true
          )

          new_user.save

          if current_subject
            faculty_subject = FacultySubject.find_or_initialize_by(user_id: new_user.id, subject_id: current_subject.id, type: 0)
            faculty_subject.save
          end

          if previous_subject
            faculty_subject = FacultySubject.find_or_initialize_by(user_id: new_user.id, subject_id: previous_subject.id, type: 1)
            faculty_subject.save
          end
        end
      end
    end
  end

  task :course_and_semester, [:id] => [:environment] do |task, args|
    puts 'Importing Data'
    excel_sheet = ExcelSheet.find_by_id(args[:id])
    if excel_sheet.sheet.attached?
      data = Array.new
      excel_sheet.sheet.open do |file|
        data = Roo::Spreadsheet.open(file)
        headers = Array.new
        i = 0
        while headers.compact.empty?
          headers = data.row(i)
          i+=1
        end
        downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
        data.each_with_index do |row, idx|
          next if idx == 0 || idx == 1

          cs_data = Hash[[downcased_headers, row].transpose]

          course = Course.find_or_initialize_by(
            name: cs_data["course"]
          )

          course.save
          cs_data["semesters"].times do |i|
            semester = Semester.find_or_initialize_by(name: i+1, course_id: course.id)
            semester.save
          end
        end
      end
    end
  end

  task :subject_details, [:id] => [:environment] do |task, args|
    puts 'Importing Data'

    excel_sheet = ExcelSheet.find_by_id(args[:id])
    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(excel_sheet.sheet)
      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i+=1
      end
      user_data = []
      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      puts downcased_headers
      data.each_with_index do |row, idx|
        next if idx == 0
        
        subject_details = Hash[[downcased_headers, row].transpose]

        subject_details.each do |i|
          course = Course.find_by_name(data[:course])
          semester = course.semesters.find_by_name(data[:semester])

          subject = Subject.find_or_initialize_by(code: data[:subject_code]).tap do |s|
            s.name = data[:subject_name]
            s.semester_id = semester.id
            s.save
          end
        end
      end
    end
  end

  task :supervision_list, [:id] => [:environment] do |task, args|

    puts 'Importing Data'

    excel_sheet = ExcelSheet.find_by_id(args[:id])
    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(excel_sheet.sheet)
      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i+=1
      end
      user_data = []
      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      puts downcased_headers
      data.each_with_index do |row, idx|
        next if idx == 0

        supervision_details = Hash[[downcased_headers, row].transpose]

        supervision_details.each do |sd|
          faculty = User.find_by_name(sd[:faculty_name])
          subject = Subject.find_by_code(sd[:subject_code])

          faculty_supervision = FacultySupervison.new(
            user_id: faculty.id,
            subject_id: subject.id,
            date: sd[:date],
            time: sd[:time]
          )

          faculty_supervision.save
        end
      end
    end
  end

  task :marks_entry, [:id] => [:environment] do |task, args|
    puts 'Importing Data'

    excel_sheet = ExcelSheet.find_by_id(args[:id])
    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(excel_sheet.sheet)
      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i+=1
      end
      user_data = []
      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      puts downcased_headers
      data.each_with_index do |row, idx|
        next if idx == 0

        marks_entry_details = Hash[[downcased_headers, row].transpose]

        marks_entry_details.each do |marks|
          subject = Subject.find_by(code: marks[:code])

          marks_entry = MarksEntry.find_or_initialize_by(enrollment_number: marks[:enrollment_number], subject_id: subject.id).tap do |mark|
            mark.marks = marks[:marks]
            mark.save
          end
        end
      end
    end
  end

  task :faculty_assignment_for_marks_entry, [:id] => [:environment] do |task, args|
    puts 'Importing Data'

    excel_sheet = ExcelSheet.find_by_id(args[:id])
    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(excel_sheet.sheet)
      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i+=1
      end
      user_data = []
      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      puts downcased_headers
      data.each_with_index do |row, idx|
        next if idx == 0

        faculty_assign_details = Hash[[downcased_headers, row].transpose]

        faculty_assign_details.each do |detail|
          course = Course.find_by_name(detail[:course])
          semester = course.semesters.find_by_name(detail[:semester])
          subject = semester.subjects.find_by_code(detail[:subject])
          user = subject.users.find_by_name(detail[:faculty_name])

          assign_faculty = FacultyMarkEntry.find_or_initialize_by(course_id: course.id, semester_id: semester.id, subject_id: subject.id, user_id: user.id)

          assign_faculty.save

        end
      end
    end
  end
end
