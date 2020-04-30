# frozen_string_literal: true

RSpec.describe 'Root', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'root' do
    visit '/'
    expect(page).to have_text('Hello Previewer')
  end
end
