if $('.masonry-brick').length
  $(".like-btn-<%= @post.id %>").html "<%=j render('posts/masonry_like', post: @post) %>"
  $(".masonry-title-likes-<%= @post.id %>").html "<%= @post.like_relationships_count %>"

else
  $("#like-btn-<%= @post.id %>").html "<%=j render('posts/like', post: @post) %>"
  $(".likes-count").html "<%= @post.user.likes_count %>"
  $('.post-likes-click').click ->
    $('#hidden-like-form').submit()
