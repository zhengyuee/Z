$ ->
  $('.cloudinary-fileupload').attr('accept', 'image/*')

  $('#choose-post-photo-btn').click ->
    $('#hidden_post_form .cloudinary-fileupload').click()

  $('#hidden_post_form .cloudinary-fileupload').bind 'fileuploadstart', ->
    $('#choose-post-photo-btn').text('Uploading...').prop('disabled', true)

  $('#hidden_post_form .cloudinary-fileupload').bind 'fileuploadfail', ->
    showNotification 'Something went wrong. Try again.'
    $('#choose-post-photo-btn').text('Choose a photo').prop('disabled', false)
    $('#from-web-post-form input:submit').val('Fetch image').prop('disabled', false)

  $('#hidden_post_form .cloudinary-fileupload').bind 'cloudinarydone', (e,data) ->
    # check image size
    if data.result.width < 640 or data.result.height < 640
      showNotification 'Your photo is too small :('
      $('#choose-post-photo-btn').text('Choose a photo').prop('disabled', false)
      $('#from-web-post-form input:submit').val('Fetch image').prop('disabled', false)
    else
      # sometimes the hidden field is not added in Safari
      if !$('#post_cloudinary_data').length
        value = "image/upload/#{data.result.path}##{data.result.signature}"
        $('#upload-post-submit').before("<input id='post_cloudinary_data' name='post[cloudinary_data]'' type='hidden' value='#{value}' />")

      $('#upload-post-submit').click()


  window.from_web_post_validator = $('#from-web-post-form').validate
    rules:
      'web_link':
        required: true
        url: true

    messages:
      'web_link':
        required: "It's empty :("
        url: 'The link looks invalid..'

    submitHandler: (form) ->
      $('input:submit', form).val('Fetching...').prop('disabled', true)
      $('#hidden_post_form .cloudinary-fileupload').cloudinary_upload_url($('#web-link').val())
