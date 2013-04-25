class PostsController < ApplicationController

  def show
    template = params[:id]
    render :template => "articles/#{template}"
  end
end
