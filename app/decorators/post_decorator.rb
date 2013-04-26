class PostDecorator < Draper::Base
  decorates :post

  def list_item
    h.link_to humanize_title, post_route
  end

  private

    def humanize_title
      t = model.filename.match(/^(\d+)_([\w_]+).+$/)
      t[2].humanize
    end

    def post_route
      t = model.filename.match(/^(.+)(.html.md|.html.markdown)$/)
      h.post_path(t[1])
    end
end
