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
    url = Url.create(uri: 'http://example.com', acknowledge_id: SecureRandom.hex)
    visit "/status?ack=#{url.acknowledge_id}"
    expect(page.response_headers).to be_truthy
  end

  context 'Return an acknowledge ID' do
    let(:website) { 'example.com' }
    it 'is able to post the URL' do
      visit '/'
      fill_in 'url', with: website
      click_button 'Preview'
      expect(
        JSON.parse(page.body)
      ).to match('ack' => an_instance_of(String))
    end
  end
end
