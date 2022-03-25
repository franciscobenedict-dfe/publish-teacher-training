module Courses
  class AssignProgramTypeService
    def execute(funding_type, course)
      case funding_type
      when "salary"
        update_salaried_program(course)
      when "apprenticeship"
        course.program_type = :pg_teaching_apprenticeship
      when "fee"
        course.program_type = update_fee_program(course)
      end

      # NOTE: This looks like unwarranted side effects
      course.save
    end

  private

    def update_salaried_program(course)
      course.program_type = :school_direct_salaried_training_programme
    end

    def update_fee_program(course)
      if !course.self_accredited?
        :school_direct_training_programme
      elsif course.provider.scitt?
        :scitt_programme
      else
        :higher_education_programme
      end
    end
  end
end
