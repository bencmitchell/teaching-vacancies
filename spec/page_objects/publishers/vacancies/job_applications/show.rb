module PageObjects
  module Publishers
    module Vacancies
      module JobApplications
        class Show < SitePrism::Page
          set_url "/organisation/jobs/{job_id}/job_applications/{id}"

          section :banner, ".jobs-banner" do
            element :job_title, "h1.govuk-heading-xl"
            element :status, "strong.govuk-tag"
          end

          section :timeline, ".timeline-component" do
            elements :dates, ".timeline-component__dates"
          end

          element :actions, ".job-application-actions"
        end
      end
    end
  end
end