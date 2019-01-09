RSpec.describe PublishVacancy do
  let(:vacancy) { create(:vacancy, :draft) }

  describe '#call' do
    it 'updates the vacancy"s status to published' do
      PublishVacancy.new(vacancy: vacancy).call

      expect(vacancy.status).to eq('published')
    end
  end
end
