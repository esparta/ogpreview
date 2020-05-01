# frozen_string_literal: true

RSpec.describe 'Root', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'root' do
    visit '/'
    expect(page).to have_text('Hello Previewer')
  end

  it 'is able to post the URL' do
    visit '/'
    fill_in 'url', with: 'example.com'
    click_button 'Preview'
    expect(page).to have_text('Preview has been submitted')
  end
end
