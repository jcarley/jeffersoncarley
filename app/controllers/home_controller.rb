class HomeController < ApplicationController

  def index
    files = Dir.entries(File.join(Rails.root, "app/views/articles"))
    posts = files.map do |x|
      Post.new(x) if x.index(/\.md$|\.markdown$/).present?
    end
    posts.compact!

    @decorator = PostDecorator.decorate(posts)
  end
end
