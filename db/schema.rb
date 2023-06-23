# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_23_114227) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["course_id"], name: "index_branches_on_course_id"
  end

  create_table "configurations", force: :cascade do |t|
    t.string "examination_name"
    t.string "examination_type"
    t.string "academic_year"
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.bigint "semester_id", null: false
    t.bigint "division_id", null: false
    t.text "subject_ids"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_configurations_on_branch_id"
    t.index ["course_id"], name: "index_configurations_on_course_id"
    t.index ["division_id"], name: "index_configurations_on_division_id"
    t.index ["semester_id"], name: "index_configurations_on_semester_id"
    t.index ["user_id"], name: "index_configurations_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.bigint "semester_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["semester_id"], name: "index_divisions_on_semester_id"
  end

  create_table "exam_time_tables", force: :cascade do |t|
    t.string "name"
    t.bigint "semester_id", null: false
    t.bigint "subject_id", null: false
    t.date "date"
    t.text "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.string "academic_year"
    t.integer "day"
    t.string "time_table_type"
    t.index ["branch_id"], name: "index_exam_time_tables_on_branch_id"
    t.index ["course_id"], name: "index_exam_time_tables_on_course_id"
    t.index ["semester_id"], name: "index_exam_time_tables_on_semester_id"
    t.index ["subject_id", "time_table_type"], name: "index_exam_time_tables_on_subject_id_and_time_table_type", unique: true
    t.index ["subject_id"], name: "index_exam_time_tables_on_subject_id"
  end

  create_table "examination_names", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examination_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "maximum_marks"
  end

  create_table "excel_sheets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faculty_marks_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.bigint "semester_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_faculty_marks_entries_on_course_id"
    t.index ["semester_id"], name: "index_faculty_marks_entries_on_semester_id"
    t.index ["subject_id"], name: "index_faculty_marks_entries_on_subject_id"
    t.index ["user_id"], name: "index_faculty_marks_entries_on_user_id"
  end

  create_table "faculty_subjects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type"
    t.index ["subject_id"], name: "index_faculty_subjects_on_subject_id"
    t.index ["user_id"], name: "index_faculty_subjects_on_user_id"
  end

  create_table "faculty_supervisions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "data"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_faculty_supervisions_on_subject_id"
    t.index ["user_id"], name: "index_faculty_supervisions_on_user_id"
  end

  create_table "marks_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "examination_name"
    t.string "academic_year"
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.bigint "semester_id", null: false
    t.string "entry_type"
    t.bigint "division_id", null: false
    t.index ["branch_id"], name: "index_marks_entries_on_branch_id"
    t.index ["course_id"], name: "index_marks_entries_on_course_id"
    t.index ["division_id"], name: "index_marks_entries_on_division_id"
    t.index ["semester_id"], name: "index_marks_entries_on_semester_id"
    t.index ["user_id"], name: "index_marks_entries_on_user_id"
  end

  create_table "marks_entry_subjects", force: :cascade do |t|
    t.bigint "marks_entry_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["marks_entry_id"], name: "index_marks_entry_subjects_on_marks_entry_id"
    t.index ["subject_id"], name: "index_marks_entry_subjects_on_subject_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.string "scopes"
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "other_duties", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "assigned_duties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "examination_name"
    t.string "academic_year"
    t.bigint "course_id"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_other_duties_on_branch_id"
    t.index ["course_id"], name: "index_other_duties_on_course_id"
    t.index ["user_id"], name: "index_other_duties_on_user_id"
  end

  create_table "role_emails", force: :cascade do |t|
    t.string "email"
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_emails_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "default_email"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "semesters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id", null: false
    t.index ["branch_id"], name: "index_semesters_on_branch_id"
  end

  create_table "student_marks", force: :cascade do |t|
    t.string "examination_name"
    t.string "examination_type"
    t.string "academic_year"
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.bigint "semester_id", null: false
    t.bigint "division_id", null: false
    t.bigint "subject_id", null: false
    t.string "marks"
    t.boolean "lock_marks", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_id", null: false
    t.boolean "publish_marks", default: false
    t.index ["branch_id"], name: "index_student_marks_on_branch_id"
    t.index ["course_id"], name: "index_student_marks_on_course_id"
    t.index ["division_id"], name: "index_student_marks_on_division_id"
    t.index ["semester_id"], name: "index_student_marks_on_semester_id"
    t.index ["student_id"], name: "index_student_marks_on_student_id"
    t.index ["subject_id"], name: "index_student_marks_on_subject_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "enrollment_number"
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fees_paid", default: false
    t.string "barcode"
    t.string "qrcode"
    t.index ["branch_id"], name: "index_students_on_branch_id"
    t.index ["course_id"], name: "index_students_on_course_id"
    t.index ["semester_id"], name: "index_students_on_semester_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.string "category"
    t.string "lecture"
    t.string "tutorial"
    t.string "practical"
    t.index ["branch_id"], name: "index_subjects_on_branch_id"
    t.index ["course_id"], name: "index_subjects_on_course_id"
    t.index ["semester_id"], name: "index_subjects_on_semester_id"
  end

  create_table "supervisions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "academic_year"
    t.string "list_type"
    t.string "examination_name"
    t.integer "no_of_supervisions"
    t.bigint "course_id", null: false
    t.bigint "branch_id"
    t.bigint "semester_id"
    t.integer "time", default: 0
    t.string "supervision_type"
    t.index ["branch_id"], name: "index_supervisions_on_branch_id"
    t.index ["course_id"], name: "index_supervisions_on_course_id"
    t.index ["semester_id"], name: "index_supervisions_on_semester_id"
    t.index ["user_id"], name: "index_supervisions_on_user_id"
  end

  create_table "syllabuses", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "course_id", null: false
    t.bigint "branch_id", null: false
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_syllabuses_on_branch_id"
    t.index ["course_id"], name: "index_syllabuses_on_course_id"
    t.index ["semester_id"], name: "index_syllabuses_on_semester_id"
    t.index ["subject_id"], name: "index_syllabuses_on_subject_id"
  end

  create_table "time_table_block_wise_reports", force: :cascade do |t|
    t.bigint "exam_time_table_id", null: false
    t.integer "rooms"
    t.integer "blocks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "academic_year"
    t.float "no_of_students"
    t.string "examination_name"
    t.bigint "course_id", null: false
    t.bigint "branch_id"
    t.bigint "semester_id"
    t.string "report_type"
    t.index ["branch_id"], name: "index_time_table_block_wise_reports_on_branch_id"
    t.index ["course_id"], name: "index_time_table_block_wise_reports_on_course_id"
    t.index ["exam_time_table_id"], name: "index_time_table_block_wise_reports_on_exam_time_table_id"
    t.index ["semester_id"], name: "index_time_table_block_wise_reports_on_semester_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "established_year"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "gender"
    t.string "contact_address"
    t.string "permanent_address"
    t.string "status"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "department"
    t.string "designation"
    t.datetime "date_of_joining"
    t.bigint "course_id"
    t.bigint "branch_id"
    t.integer "user_type", default: 0
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["course_id"], name: "index_users_on_course_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "branches", "courses"
  add_foreign_key "configurations", "branches"
  add_foreign_key "configurations", "courses"
  add_foreign_key "configurations", "divisions"
  add_foreign_key "configurations", "semesters"
  add_foreign_key "configurations", "users"
  add_foreign_key "divisions", "semesters"
  add_foreign_key "exam_time_tables", "branches"
  add_foreign_key "exam_time_tables", "courses"
  add_foreign_key "exam_time_tables", "semesters"
  add_foreign_key "exam_time_tables", "subjects"
  add_foreign_key "faculty_marks_entries", "courses"
  add_foreign_key "faculty_marks_entries", "semesters"
  add_foreign_key "faculty_marks_entries", "subjects"
  add_foreign_key "faculty_marks_entries", "users"
  add_foreign_key "faculty_subjects", "subjects"
  add_foreign_key "faculty_subjects", "users"
  add_foreign_key "faculty_supervisions", "subjects"
  add_foreign_key "faculty_supervisions", "users"
  add_foreign_key "marks_entries", "branches"
  add_foreign_key "marks_entries", "courses"
  add_foreign_key "marks_entries", "divisions"
  add_foreign_key "marks_entries", "semesters"
  add_foreign_key "marks_entries", "users"
  add_foreign_key "marks_entry_subjects", "marks_entries"
  add_foreign_key "marks_entry_subjects", "subjects"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "other_duties", "branches"
  add_foreign_key "other_duties", "courses"
  add_foreign_key "other_duties", "users"
  add_foreign_key "role_emails", "roles"
  add_foreign_key "semesters", "branches"
  add_foreign_key "student_marks", "branches"
  add_foreign_key "student_marks", "courses"
  add_foreign_key "student_marks", "divisions"
  add_foreign_key "student_marks", "semesters"
  add_foreign_key "student_marks", "students"
  add_foreign_key "student_marks", "subjects"
  add_foreign_key "students", "branches"
  add_foreign_key "students", "courses"
  add_foreign_key "students", "semesters"
  add_foreign_key "subjects", "branches"
  add_foreign_key "subjects", "courses"
  add_foreign_key "subjects", "semesters"
  add_foreign_key "supervisions", "branches"
  add_foreign_key "supervisions", "courses"
  add_foreign_key "supervisions", "semesters"
  add_foreign_key "supervisions", "users"
  add_foreign_key "syllabuses", "branches"
  add_foreign_key "syllabuses", "courses"
  add_foreign_key "syllabuses", "semesters"
  add_foreign_key "syllabuses", "subjects"
  add_foreign_key "time_table_block_wise_reports", "branches"
  add_foreign_key "time_table_block_wise_reports", "courses"
  add_foreign_key "time_table_block_wise_reports", "exam_time_tables"
  add_foreign_key "time_table_block_wise_reports", "semesters"
  add_foreign_key "users", "branches"
  add_foreign_key "users", "courses"
end
