class Post
  extend  ActiveModel::Naming

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

end
