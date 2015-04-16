module CommentsHelper

  def commenter_name(comment)
    comment.commenter.present? ? comment.commenter : "Anonymous coward"
  end
end
