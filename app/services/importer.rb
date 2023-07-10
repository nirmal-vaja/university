class Importer
  attr_reader :excel_sheet_id

  def initialize(excel_sheet_id)
    @excel_sheet_id = excel_sheet_id
  end

  def create_faculty_details
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)
  
    return { message: "Excel sheet not found", status: :unprocessable_entity } unless excel_sheet&.sheet.attached?
  
    data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))
    headers = []
    i = 0
    while headers.compact.empty?
      headers = data.row(i).compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      i += 1
    end
    users = []
  
    data.each_with_index do |row, idx|
      next if row.include?(nil) || row[1].gsub(/\s+/, '').underscore == headers[1] # Skip header and nil rows
  
      user_data = Hash[[headers, row].transpose]
  
      begin
        ActiveRecord::Base.transaction do
          user = User.find_or_initialize_by(email: user_data["email"])
          course = Course.includes(:branches).find_by_name(user_data["course"])
          branch = course&.branches&.find_by_name(user_data["department"])
  
          if course.nil?
            return { message: "#{user_data['course']} not found", status: :unprocessable_entity }
          end
  
          if branch.nil?
            return { message: "#{user_data['department']} not found in #{course.name}!", status: :unprocessable_entity }
          end
  
          name = user_data["faculty_name"].split(' ')

          user_details = {
            first_name: name[0],
            last_name: name[1],
            phone_number: user_data["phone_number"].to_i,
            designation: user_data["designation"],
            password: "password",
            date_of_joining: user_data["dateof_joining"],
            gender: user_data["gender"],
            status: "true",
            department: user_data["department"],
            course: course,
            branch: branch,
            user_type: user_data["type"] == "Junior" ? 0 : 1
          }

          if user.id.present?
            user.update(user_details)
          else
            user.assign_attributes(
              first_name: name[0],
              last_name: name[1],
              phone_number: user_data["phone_number"].to_i,
              designation: user_data["designation"],
              password: "password",
              date_of_joining: user_data["dateof_joining"],
              gender: user_data["gender"],
              status: "true",
              department: user_data["department"],
              course: course,
              branch: branch,
              user_type: user_data["type"] == "Junior" ? 0 : 1
            )
            user.save!
            user.add_role(:faculty)
            users << user
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        return { message: "#{user.first_name}'s " + user.errors.full_messages.join(' '), status: :unprocessable_entity }
      rescue StandardError => e
        return { message: e.to_s, status: :unprocessable_entity }
      end
    end
  
    {
      message: "Excel Sheet has been uploaded successfully",
      data: {
        users: users.compact
      },
      status: :created
    }
  end
  

  # def create_faculty_details
  #   excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

  #   if excel_sheet.sheet.attached?
  #     data = Array.new
  #     data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))
  #     headers = Array.new
  #     i = 0
  #     while headers.compact.empty?
  #       headers = data.row(i)
  #       i+=1
  #     end
  #     user_data = []
  #     downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
  #     data.each_with_index do |row, idx|
  #       next if row.include?(nil) || row[0] == headers[0] # skip header and nil rows
  #       # create hash from headers and cells
  #       user_data = Hash[[downcased_headers, row].transpose]
  #       ActiveRecord::Base.transaction do
  #         user = User.find_or_initialize_by(
  #           email: user_data["email"]
  #         )
  #         course = Course.find_by_name(user_data["course"])
  
  #         unless course
  #           return {
  #             message: "#{user_data["course"]} not found",
  #             status: :unprocessable_entity
  #            }
  #         end
  
  #         branch = course.branches.find_by_name(user_data["department"])
  
  #         unless branch
  #           return { 
  #             message: "#{user_data["department"]} not found in #{course.name}!",
  #             status: :unprocessable_entity
  #            }
  #         end
  
  #         name = user_data["faculty_name"].split(' ')
  
  #         user.first_name = name[0]
  #         user.last_name = name[1]
  #         user.phone_number = user_data["phone_number"].to_i
  #         user.designation = user_data["designation"]
  #         user.password = "password" if user.password.nil?
  #         user.date_of_joining = user_data["dateof_joining"]
  #         user.gender = user_data["gender"]
  #         user.status = "true"
  #         user.department = user_data["department"]
  #         user.course = course
  #         user.branch = branch
  #         user.user_type = user_data["type"] == "Junior" ? 0 : 1
  
  #         user.add_role :faculty
  #         user.save
  #       rescue ActiveRecord::RecordInvalid
  #           return { message: "#{user.first_name}'s " + user.errors.full_messages.join(' '), status: :unprocessable_entity }
  #           raise ActiveRecord::Rollback
  #           break
  #       rescue StandardError => e
  #         return {message: e, status: :unprocessable_entity}
  #         raise ActiveRecord::Rollback
  #         break
  #       end
  #     end
  #     {
  #       message: "Excel Sheet has been uploaded successfully",
  #       data: {
  #         users: User.with_role(:faculty)
  #       }, status: :created
  #     }
  #   end
  # end

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

        unless course.save
          return { message: course.errors.full_messages.join(', '), status: :unprocessable_entity }
        end

        branch = course.branches.find_or_initialize_by(
          name: cs_data["branch"]
        )

        branch.code = cs_data["branch_code"].to_i

        unless branch.save
          return { message: branch.errors.full_messages.join(', '), status: :unprocessable_entity }
        end

        cs_data["semesters"].to_i.times do |i|
          semester = branch.semesters.find_or_initialize_by(name: i+1)
          unless semester.save
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

        unless course
          return {
            message: "#{subject_details["department"]} not found!",
            status: :unprocessable_entity
          }
        end

        branch = course.branches.find_by_name(subject_details["branch"])

        unless branch
          return {
            message: "#{subject_details["branch"]} not found in #{course.name}",
            status: :unprocessable_entity
          }
        end
        semester = branch.semesters.find_by_name(subject_details["semester"].to_i)

        unless semester
          return {
            message: "Semester - #{subject_details["semester"].to_i} not found #{course.name} #{branch.name}",
            status: :unprocessable_entity
          }
        end

        subject = semester.subjects.find_or_initialize_by(code: subject_details["subject_code"].to_i).tap do |s|
          s.name = subject_details["subject_name"]
          s.course_id = course.id
          s.branch_id = branch.id
          s.lecture = subject_details["lecture"].to_i
          s.category = subject_details["category"]
          s.tutorial = subject_details["tutorial"].to_i
          s.practical = subject_details["practical"].to_i

          unless s.save
            return {
              message: s.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
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

  def create_divisions
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

    if excel_sheet.sheet.attached?
      data = Array.new
      data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))

      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i += 1
      end

      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      data.each_with_index do |row, idx|
        next if row.include?(nil) || row[0] == headers[0]

        cs_data = Hash[[downcased_headers, row].transpose]

        course = Course.find_by(
          name: cs_data["course"]
        )
        
        unless course
          return {
            message: "#{cs_data["course"]} not found!",
            status: :unprocessable_entity
          }
        end

        branch = course.branches.find_by(
          name: cs_data["branch"]
        )

        unless branch
          return {
            message: "#{cs_data["branch"]} not found in #{course.name}",
            status: :unprocessable_entity
          }
        end

        semester = branch.semesters.find_by(
          name: cs_data["semester"].to_i
        )

        unless semester
          return {
            message: "Semester - #{cs_data["semester"]} not found in #{course.name} #{branch.name}",
            status: :unprocessable_entity
          }
        end

        alphabets = ('A'..'Z').take(cs_data["no_of_divisions"].to_i)

        alphabets.each do |alphabet|
          division = semester.divisions.find_or_initialize_by(name: alphabet)
          unless division.save
            return {message: division.errors.full_messages.join(', '), status: :unprocessable_entity}
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

  def create_students
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

    if excel_sheet.sheet.attached?
      data = Array.new
      data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))

      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i += 1
      end

      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      data.each_with_index do |row, idx|
        next if row.include?(nil) || row[0] == headers[0]

        student_data = Hash[[downcased_headers, row].transpose]

        course = Course.find_by_name(student_data["department"])

        unless course
          return {
            message: "#{student_data["department"]} not found!",
            status: :unprocessable_entity
          }
        end

        branch = course.branches.find_by_name(student_data["branch"])

        unless branch
          return {
            message: "#{student_data["branch"]} not found in #{course.name}",
            status: :unprocessable_entity
          }
        end

        semester = branch.semesters.find_by_name(student_data["semester"].to_i)

        unless semester
          return {
            message: "Semester - #{student_data["semester"].to_i} not found in #{course.name} #{branch.name}",
            status: :unprocessable_entity
          }
        end

        student = Student.find_or_initialize_by(enrollment_number: student_data["enrollment_number"].to_i.to_s)

        student.course_id = course.id
        student.branch_id = branch.id
        student.semester_id = semester.id
        student.name = student_data["name"]
        student.fees_paid = student_data["fees_paid"].to_i === 0 ? false : true

        unless student.save
          return {
            message: student.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
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

  def create_syllabus
    excel_sheet = ExcelSheet.find_by_id(@excel_sheet_id)

    if excel_sheet.sheet.attached?
      data = Array.new
      data = Roo::Spreadsheet.open(create_temp_file(excel_sheet.id))

      headers = Array.new
      i = 0
      while headers.compact.empty?
        headers = data.row(i)
        i += 1
      end

      downcased_headers = headers.compact.map{ |header| header.gsub(/\s+/, '') }.map(&:underscore)
      data.each_with_index do |row, idx|
        next if row[0] == headers[0]

        syllabus_data = Hash[[downcased_headers, row].transpose]

        course = Course.find_by_name(syllabus_data["department"])

        unless course
          return {
            message: "#{syllabus_data["department"]} not found!",
            status: :unprocessable_entity
          }
        end

        branch = course.branches.find_by_name(syllabus_data["branch"])

        unless branch
          return {
            message: "#{syllabus_data["branch"]} not found in #{course.name}",
            status: :unprocessable_entity
          }
        end

        semester = branch.semesters.find_by_name(syllabus_data["semester"])

        unless semester
          return {
            message: "Semester - #{syllabus_data["semester"].to_i} not found #{course.name} #{branch.name}",
            status: :unprocessable_entity
          }
        end

        subject = semester.subjects.find_by_code(syllabus_data["subject_code"]) || semester.subjects.find_by_name(syllabus_data["subject_name"])

        unless subject
          return {
            message: "#{syllabus_data["subject_name"]} not found",
            status: :unprocessable_entity
          }
        end

        syllabus = Syllabus.find_or_initialize_by(subject_id: subject.id)
        
        syllabus.course_id = course.id
        syllabus.branch_id = branch.id
        syllabus.semester_id = semester.id

        unless syllabus.save
          return {
            message: syllabus.errors.full_messages.join(', '),
            status: :unprocessable_entity
          }
        end
      end
      {
        message: "Excel sheet has been uploaded successfully!",
        status: :created
      }
    else
      {
        message: "Excel sheet has not been uploaded, try again!",
        status: :unprocessable_entity
      }
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