class Importer
  attr_reader :excel_sheet_id

  def initialize(excel_sheet_id)
    @excel_sheet_id = excel_sheet_id
  end

  def create_faculty_details
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(create_temp_file(excel_sheed.id))
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
        next if idx == 0 || idx == 1 # skip header
        # create hash from headers and cells
        user_data = Hash[[downcased_headers, row].transpose]

        user = User.find_or_initialize_by(
          first_name = user_data[:faculty_name].split(' ')[0],
          last_name = user_data[:faculty_name].split(' ')[1]
        )

        user.phone_number = user_data[:phone_number]
        user.designation = user_data[:designation]
        user.password = "password"
        user.date_of_joining = user_data[:doj]
        user.gender = user_data[:gender]
        user.department = user_data[:department]
        user.email = user_data[:email]
        current_subject = Subject.find_by_code(user_data[:current_subject_code])
        previous_subject = Subject.find_by_code(user_data[:previous_subject_code])

        user.save

        if current_subject
          faculty_subject = FacultySubject.find_or_initialize_by(user_id: user.id, subject_id: current_subject.id, type: 0)
          faculty_subject.save
        end

        if previous_subject
          faculty_subject = FacultySubject.find_or_initialize_by(user_id: user.id, subject_id: previous_subject.id, type: 1)
          faculty_subject.save
        end
      end
    end
  end

  def create_course_and_semester
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)
    if excel_sheet.sheet.attached?
      data = Array.new
      # excel_sheet.sheet.open do |file|
        data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))
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
      # end
    end
  end

  def create_subject
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)
    if excel_sheet.sheet.attached?
      data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))
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
        next if idx == 0 || idx == 1
        
        subject_details = Hash[[downcased_headers, row].transpose]

        course = Course.find_by_name(subject_details[:course])
        semester = course.semesters.find_by_name(subject_details[:semester])

        subject = Subject.find_or_initialize_by(code: subject_details[:subject_code]).tap do |s|
          s.name = subject_details[:subject_name]
          s.semester_id = semester.id
          s.save
        end
      end
    end
  end

  private

  def create_temp_file(sheet_id)
    excel_sheet = ExcelSheet.find_by_id(sheet_id)
    file_name = excel_sheet.sheet.blob.filename
      @tmp = Tempfile.new([file_name.base, file_name.extension_with_delimiter], binmode: true)
      @tmp.write(excel_sheet.sheet.download)
      @tmp.rewind
      @tmp
  end
end