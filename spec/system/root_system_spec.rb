# frozen_string_literal: true

RSpec.describe 'Root', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'root' do
    visit '/'
    expect(page).to have_text('Hello Previewer')
  end

  it 'status' do
    visit '/status'
    expect(page.response_headers).to be_truthy
  end

  context 'Return an acknowledge ID' do
    let(:acknowledge) { '0a5692e33d9635240d377bbe1ab082c6' }
    let(:website) { 'example.com' }
    it 'is able to post the URL' do
      allow(SecureRandom).to receive(:hex) { acknowledge }
      visit '/'
      fill_in 'url', with: website
      click_button 'Preview'
      expect(
        JSON.parse(page.body)
      ).to match('ack' => acknowledge)
    end
  end
end
