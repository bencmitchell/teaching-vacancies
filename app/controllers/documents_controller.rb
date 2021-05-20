class DocumentsController < ApplicationController
  def show
    # TODO: Replace this with a frontend-triggered event so we will be able to cache this document
    request_event.trigger(:vacancy_document_downloaded, vacancy_id: vacancy.id, document_id: document.id, filename: document.filename)

    redirect_to document
  end

  private

  def vacancy
    @vacancy ||= Vacancy.listed.friendly.find(params[:job_id])
  end

  def document
    @document ||= vacancy.supporting_documents.find(params[:id])
  end
end
