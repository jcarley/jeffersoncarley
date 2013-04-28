class HomeController < ApplicationController

  EXTENSION_REGEX = /\.md$|\.markdown$/
  SAMPLEFILE_REGEX = /sample\..+[\.md$|\.markdown$]/

  def index
    files = Dir.entries(File.join(Rails.root, "app/views/articles"))
    posts = files.map do |x|
      Post.new(x) if include?(x)
    end
    posts.compact!

    @decorator = PostDecorator.decorate(posts)
  end

  private

  def include?(filename)
    if Rails.env.production?
      filename.index(EXTENSION_REGEX).present? && !filename.index(SAMPLEFILE_REGEX).present?
    else
      filename.index(EXTENSION_REGEX).present?
    end
  end
end
