class SaveStudentDetails
  def initialize(student_id, contact_params, address_params, parent_params, guardian_params)
    @student_id = student_id
    @contact_params = contact_params
    @address_params = address_params
    @parent_params = parent_params
    @guardian_params = guardian_params
  end

  def call
    @student = Student.find_by_id(@student_id)

    if @contact_params.present?
      @student.contact_detail.nil? ? @student.build_contact_detail(@contact_params) : @student.contact_detail.update(@contact_params)
    end

    if @address_params.present?
      @student.address_detail.nil? ? @student.build_address_detail(@address_params) : @student.address_detail.update(@address_params)
    end

    if @parent_params.present?
      @student.parent_detail.nil? ? @student.build_parent_detail(@parent_params) : @student.parent_detail.update(@parent_params)
    end

    if @guardian_params.present?
      @student.guardian_detail.nil? ? @student.build_guardian_detail(@guardian_params) : @student.guardian_detail.update(@guardian_params)
    end

    @student.save
    @student
  end
end