require 'spec_helper'

describe PostsController do

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end

    it "returns a list of articles" do
      get :index
      expect(assigns(:files).length).to be >= 1
    end
  end


end
