class HomeController < ApplicationController

  def index
    @files = Dir.entries(File.join(Rails.root, "app/views/articles"))
    @files = @files.map do |x|
      x if x.index(/\.md$|\.markdown$/).present?
    end
    @files.compact!
  end
end
