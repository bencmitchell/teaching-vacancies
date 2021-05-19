class SupportingDocumentComponent < GovukComponent::Base
  attr_reader :supporting_document

  def initialize(supporting_document:, classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    @supporting_document = supporting_document
  end

  def document_size
    number_to_human_size(supporting_document.blob.byte_size)
  end

  private

  def default_classes
    %w[supporting-document-component icon icon--left icon--document]
  end
end
