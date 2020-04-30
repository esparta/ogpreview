require 'rails_helper'

RSpec.describe "Previews", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/preview/show"
      expect(response).to have_http_status(:success)
    end
  end

end
