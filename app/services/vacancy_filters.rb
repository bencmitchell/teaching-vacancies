class VacancyFilters
  AVAILABLE_FILTERS = %i[location radius subject job_title minimum_salary working_pattern
                         phase newly_qualified_teacher].freeze

  attr_reader(*AVAILABLE_FILTERS)

  def initialize(args)
    args = ActiveSupport::HashWithIndifferentAccess.new(args)

    @location = args[:location]
    @radius = args[:radius].to_s if args[:radius].present?
    @subject = args[:subject]
    @job_title = args[:job_title]
    @minimum_salary = args[:minimum_salary]
    @newly_qualified_teacher = args[:newly_qualified_teacher]
    @working_pattern = extract_working_pattern(args)
    @phase = extract_phase(args)
  end

  def to_hash
    {
      location: location,
      radius: radius,
      subject: subject,
      job_title: job_title,
      minimum_salary: minimum_salary,
      working_pattern: working_pattern,
      phase: phase,
      newly_qualified_teacher: newly_qualified_teacher,
    }
  end

  def only_active_to_hash
    to_hash.delete_if { |_, v| v.blank? }
  end

  def any?
    filters = only_active_to_hash
    filters.delete_if { |k, _| k.eql?(:radius) }
    filters.any?
  end

  private

  def extract_working_pattern(params)
    Vacancy.working_patterns.include?(params[:working_pattern]) ? params[:working_pattern] : nil
  end

  def extract_phase(params)
    School.phases.include?(params[:phase]) ? params[:phase] : nil
  end
end
