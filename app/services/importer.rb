class Importer
  attr_reader :excel_sheet_id

  def initialize(excel_sheet_id)
    @excel_sheet_id = excel_sheet_id
  end

  def create_faculty_details
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

    if excel_sheet.sheet.attached?
      data = Array.new
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
      success = 0
      users = 0
      data.each_with_index do |row, idx|
        next if  row.include?(nil) || row[0] == headers[0] # skip header and nil rows
        # create hash from headers and cells
        user_data = Hash[[downcased_headers, row].transpose]
        user = User.find_or_initialize_by(
          email: user_data["email"]
        )
        user.first_name = user_data["faculty_name"].split(' ')[0]
        user.last_name = user_data["faculty_name"].split(' ')[1]
        user.phone_number = user_data["phone_number"].to_i
        user.designation = user_data["designation"]
        user.password = "password" if user.password.nil?
        user.date_of_joining = user_data["dateof_joining"]
        user.gender = user_data["gender"]
        user.status = "true"
        user.department = user_data["department"]
        user.course = Course.find_by_name(user_data["department"])
        user.add_role :faculty
        users += 1
        if user.save
          success += 1
        else
          return { message: "#{user.first_name}'s " + user.errors.full_messages.join(' '), status: :unprocessable_entity }
        end
      end
      if success == users
        {
          message: "Excel Sheet has been uploaded successfully",
          data: {
            users: User.with_role(:faculty)
          }, status: :created
        }
      end
    end
  end

  def create_course_and_semester
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)
    if excel_sheet.sheet.attached?
      data = Array.new
      data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))
      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i+=1
      end
      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      data.each_with_index do |row, idx|
        next if row.include?(nil) || row[0] == headers[0]

        cs_data = Hash[[downcased_headers, row].transpose]
        course = Course.find_or_initialize_by(
          name: cs_data["course"]
        )

        if course.save
        else
          return { message: course.errors.full_messages.join(', '), status: :unprocessable_entity }
        end

        branch = Branch.find_or_initialize_by(
          name: cs_data["branch"]
        )
        branch.course = course

        if branch.save
        else
          return { message: branch.errors.full_messages.join(', '), status: :unprocessable_entity }
        end

        cs_data["semesters"].to_i.times do |i|
          semester = Semester.find_or_initialize_by(name: i+1, branch_id: branch.id)
          if semester.save
          else
            return { message: semester.errors.full_messages.join(', '), status: :unprocessable_entity }
          end
        end
      end

      {
        message: "Excel Sheet has been uploaded successfully!",
        status: :created
      }
    else
      {
        message: "Excel Sheet has not been uploaded, try again!",
        status: :unprocessable_entity
      }
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
        next if row.include?(nil) || row[0] == headers[0]
        
        subject_details = Hash[[downcased_headers, row].transpose]
        course = Course.find_by_name(subject_details["course"])
        branch = course.branches.find_by_name(subject_details["branch"])
        semester = branch.semesters.find_by_name(subject_details["semester"].to_i)
        subject = Subject.find_or_initialize_by(code: subject_details["subject_code"].to_i).tap do |s|
          s.name = subject_details["subject_name"]
          s.semester_id = semester.id
          s.save
        end
      end
      {
        message: "Excel Sheet has been uploaded successfully!",
        data: {
          subjects: Subject.all
        },
        status: :created
      }
    else
      {
        messsage: "Excel sheet has not been uploaded, try again!",
        status: :unprocessable_entity
      }
    end
  end

  # def create_supervision_list
  #   excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)
  #   if excel_sheet.sheet.attached?
  #     data = Roo::SpreadSheet.open(create_temp_file(excel_sheet.id))
  #     headers = Array.new
  #     i = 0
  #     while headers.compact.empty?
  #       headers = data.row(i)
  #       i+=1
  #     end
  #     user_data = []
  #     downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
  #     puts downcased_headers
  #     data.each_with_index do |row, idx|
  #       next if idx == 0

  #       supervision_details = Hash[[downcased_headers, row].transpose]

  #       supervision_details.each do |sd|
  #         faculty = User.find_by_name(sd[:faculty_name])
  #         subject = Subject.find_by_code(sd[:subject_code])

  #         faculty_supervision = FacultySupervison.new(
  #           user_id: faculty.id,
  #           subject_id: subject.id,
  #           date: sd[:date],
  #           time: sd[:time]
  #         )

  #         faculty_supervision.save
  #       end
  #     end
  #   end
  # end

  # def create_marks_entry
  #   excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)
  #   if excel_sheet.sheet.attached?
  #     data = Roo::SpreadSheet.open(create_temp_file(excel_sheet.id))
  #     headers = Array.new
  #     i = 0
  #     while headers.compact.empty?
  #       headers = data.row(i)
  #       i += 1
  #     end
  #     downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
  #     puts downcased_headers
  #     data.each_with_index do |row, idx|
  #       next if idx == 0

  #       marks_entry_details = Hash[[downcased_headers, row].transpose]

  #       marks_entry_details.each do |marks|
  #         subject = Subject.find_by(code: marks[:code])

  #         marks_entry = MarksEntry.find_or_initialize_by(enrollment_number: marks[:enrollment_number], subject_id: subject.id).tap do |mark|
  #           mark.marks = marks[:marks]
  #           mark.save
  #         end
  #       end
  #     end
  #   end
  # end

  # def create_faculty_assignment_for_marks_entry
  #   excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

  #   if excel_sheet.sheet.attached?
  #     data = Roo::SpreadSheet.open(create_temp_file(excel_sheet.id))
  #     headers = Array.new

  #     i = 0
  #     while headers.compact.empty?
  #       headers = data.row(i)
  #       i += 1
  #     end

  #     downcased_headers =  headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
  #     puts downcased_headers
  #     data.each_with_index do |row, idx|
  #       next if idx == 0

  #       faculty_assign_details = Hash[[downcased_headers, row].transpose]

  #       faculty_assign_details.each do |detail|
  #         course = Course.find_by_name(detail[:course])
  #         semester = course.semesters.find_by_name(detail[:semester])
  #         subject = semester.subjects.find_by_code(detail[:subject])
  #         user = subject.users.find_by_name(detail[:faculty_name])
  #         assign_faculty = FacultyMarkEntry.find_or_initialize_by(course_id: course.id, semester_id: semester.id, subject_id: subject.id, user_id: user.id)
  #         assign_faculty.save
  #       end
  #     end
  #   end
  # end

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