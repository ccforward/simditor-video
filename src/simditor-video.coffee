((factory)->
  if (typeof define is 'function') and define.amd
    define ['simditor', 'video'], factory
  else
    factory window.Simditor, window.video
)((Simditor, _video)->
  class VideoButton extends Simditor.Button

    name: 'video'

    icon: 'video-o'

    htmlTag: 'embed, iframe'

    disableTag: 'pre, table, div'

    videoPlaceholder: 'video'

    videoPoster: 'http://pic.yupoo.com/ccking/ESzA3WGs/svIoz.png'

    # defaultImage: ''

    needFocus: true

    _init: () ->
      @title = @_t(@name)
      $.merge(
        @editor.formatter._allowedTags,
        ['embed', 'iframe','video']
      )
      $.extend @editor.formatter._allowedAttributes,
        embed: ['class', 'width', 'height', 'type', 'pluginspage', 'src', 'wmode', 'play', 'loop', 'menu', 'allowscriptaccess', 'allowfullscreen'],
        iframe: ['class', 'width', 'height', 'src', 'frameborder'],
        video: ['class', 'width', 'height', 'poster', 'controls', 'allowfullscreen', 'src', 'data-link', 'data-tag']
      
      # $.extend @editor.i18n,
      #   'zh-CN': 
      #     video: '视频'
      #     videoSize: '视频尺寸',
      


      # @defaultImage = @editor.opts.defaultImage

      # @editor.body.on 'click', 'img:not([data-non-image])', (e) =>
      #   $img = $(e.currentTarget)

      #   @popover.show $img
      #   range = document.createRange()
      #   range.selectNode $img[0]
      #   @editor.selection.range range
      #   unless @editor.util.support.onselectionchange
      #     @editor.trigger 'selectionchanged'

      #   false
      $(document).on 'click', '.J_UploadVideoBtn', (e) =>
        videoData = 
          link: $('.video-link').val()
          width: $('#video-width').val() || 100
          height: $('#video-height').val() || 100

        $('.video-link').val('')
        $('#video-width').val('')
        $('#video-height').val('')
        @loadVideo $('.J_UploadVideoBtn').data('videowrap'), videoData, =>
          @editor.trigger 'valuechanged'


      @editor.body.on 'click', 'video', (e) =>
        $video = $(e.currentTarget)

        @popover.show $video
        range = document.createRange()
        range.selectNode $video[0]
        @editor.selection.range range
        unless @editor.util.support.onselectionchange
          @editor.trigger 'selectionchanged'

        false

      @editor.body.on 'mouseenter', '.simditor-video .real-video', (e)=>
        # debugger
        # $realVideo = $(e.currentTarget)
        $video = $(e.currentTarget).siblings('video').show()

        @popover.show $video


      # @editor.body.on 'mouseup', 'img:not([data-non-image])', (e) ->
      #   return false

      # @editor.on 'selectionchanged.video', =>
      #   debugger
      #   range = @editor.selection.range()
      #   return unless range?

      #   $contents = $(range.cloneContents()).contents()
      #   if $contents.length == 1 and $contents.is('img:not([data-non-image])')
      #     $img = $(range.startContainer).contents().eq(range.startOffset)
      #     @popover.show $img
      #   else
      #     @popover.hide()
      @editor.body.on 'mousedown', =>
        $videoWrap = $('.J_UploadVideoBtn').data('videowrap')
        if $videoWrap and $videoWrap.html() == @videoPlaceholder
          $videoWrap.remove()
          $('.J_UploadVideoBtn').data('videowrap',null)
        @popover.hide()

      # @editor.on 'valuechanged.image', =>
      #   $masks = @editor.wrapper.find('.simditor-image-loading')
      #   return unless $masks.length > 0
      #   $masks.each (i, mask) =>
      #     $mask = $(mask)
      #     $img = $mask.data 'img'
      #     unless $img and $img.parent().length > 0
      #       $mask.remove()
      #       if $img
      #         file = $img.data 'file'
      #         if file
      #           @editor.uploader.cancel file
      #           if @editor.body.find('img.uploading').length < 1
      #             @editor.uploader.trigger 'uploadready', [file]

      @editor.on 'decorate', (e, $el) =>
        $el.find('video').each (i, video) =>
          @decorate $(video)

      @editor.on 'undecorate', (e, $el) =>
        $el.find('video').each (i, video) =>
          @undecorate $(video)
      super()

    decorate: ($video) ->
      # 转换video标签
      videoData =
        tag: $video.attr('data-tag')
        link: $video.attr('data-link')
        width: $video.attr('width')
        height: $video.attr('height')
      # 视频播放的完整标签
      videoSrc = @parseVideo videoData

      if $video.parent('.simditor-video').length > 0
        @undecorate $video

      $video.wrap '<p class="simditor-video"></p>'
      $video.parent().prepend(videoSrc)
      $video.hide()
      $video.parent()

    undecorate: ($video) ->
      return unless $video.parent('.simditor-video').length > 0
      $video.siblings('.real-video').remove()
      $video.parent().replaceWith($video)


    render: (args...) ->
      super args...
      @popover = new VideoPopover
        button: @

      # if @editor.opts.VideoButton == 'upload'
      #   @_initUploader @el

    renderMenu: ->
      super()
      # @_initUploader()

    # _initUploader: ($uploadItem = @menuEl.find('.menu-item-upload-image')) ->
    #   unless @editor.uploader?
    #     @el.find('.btn-upload').remove()
    #     return

      # $input = null
      # createInput = =>
      #   $input.remove() if $input
      #   $input = $ '<input/>',
      #     type: 'file'
      #     title: @_t('uploadImage')
      #     accept: 'image/*'
      #   .appendTo($uploadItem)

      # createInput()

      # $uploadItem.on 'click mousedown', 'input[type=file]', (e) ->
      #   e.stopPropagation()

      # $uploadItem.on 'change', 'input[type=file]', (e) =>
      #   if @editor.inputManager.focused
      #     @editor.uploader.upload($input, {
      #       inline: true
      #     })
      #     createInput()
      #   else
      #     @editor.one 'focus', (e) =>
      #       @editor.uploader.upload($input, {
      #         inline: true
      #       })
      #       createInput()
      #     @editor.focus()
      #   @wrapper.removeClass('menu-on')


      # @editor.uploader.on 'beforeupload', (e, file) =>
      #   return unless file.inline

      #   if file.img
      #     $img = $(file.img)
      #   else
      #     $img = @createVideo(file.name)
      #     #$img.click()
      #     file.img = $img

      #   $img.addClass 'uploading'
      #   $img.data 'file', file

      #   @editor.uploader.readImageFile file.obj, (img) =>
      #     return unless $img.hasClass('uploading')
      #     src = if img then img.src else @defaultImage

      #     @loadVideo $img, src, =>
      #       if @popover.active
      #         @popover.refresh()
      #         @popover.srcEl.val(@_t('uploading'))
      #           .prop('disabled', true)

      # uploadProgress = $.proxy @editor.util.throttle((e, file, loaded, total) ->
      #   return unless file.inline

      #   $mask = file.img.data('mask')
      #   return unless $mask

      #   $img = $mask.data('img')
      #   unless $img.hasClass('uploading') and $img.parent().length > 0
      #     $mask.remove()
      #     return

      #   percent = loaded / total
      #   percent = (percent * 100).toFixed(0)
      #   percent = 99 if percent > 99
      #   $mask.find('.progress').height "#{100 - percent}%"
      # , 500), @
      # @editor.uploader.on 'uploadprogress', uploadProgress

      # @editor.uploader.on 'uploadsuccess', (e, file, result) =>
      #   return unless file.inline

      #   $img = file.img
      #   return unless $img.hasClass('uploading') and $img.parent().length > 0

      #   $img.removeData 'file'
      #   $img.removeClass 'uploading'
      #     .removeClass 'loading'

      #   $mask = $img.data('mask')
      #   $mask.remove() if $mask
      #   $img.removeData 'mask'

      #   # in case mime type of response isnt correct
      #   if typeof result != 'object'
      #     try
      #       result = $.parseJSON result
      #     catch e
      #       result =
      #         success: false

      #   if result.success == false
      #     msg = result.msg || @_t('uploadFailed')
      #     alert msg
      #     $img.attr 'src', @defaultImage
      #   else
      #     $img.attr 'src', result.file_path

      #   if @popover.active
      #     @popover.srcEl.prop('disabled', false)
      #     @popover.srcEl.val result.file_path

      #   @editor.trigger 'valuechanged'
      #   if @editor.body.find('img.uploading').length < 1
      #     @editor.uploader.trigger 'uploadready', [file, result]


      # @editor.uploader.on 'uploaderror', (e, file, xhr) =>
      #   return unless file.inline
      #   return if xhr.statusText == 'abort'

      #   if xhr.responseText
      #     try
      #       result = $.parseJSON xhr.responseText
      #       msg = result.msg
      #     catch e
      #       msg = @_t('uploadError')

      #     alert msg

      #   $img = file.img
      #   return unless $img.hasClass('uploading') and $img.parent().length > 0

      #   $img.removeData 'file'
      #   $img.removeClass 'uploading'
      #     .removeClass 'loading'

      #   $mask = $img.data('mask')
      #   $mask.remove() if $mask
      #   $img.removeData 'mask'

      #   $img.attr 'src', @defaultImage
      #   if @popover.active
      #     @popover.srcEl.prop('disabled', false)
      #     @popover.srcEl.val @defaultImage

      #   @editor.trigger 'valuechanged'
      #   if @editor.body.find('img.uploading').length < 1
      #     @editor.uploader.trigger 'uploadready', [file, result]


    _status: ->
      @_disableStatus()

    loadVideo: ($video, videoData, callback) ->
      # positionMask = =>
      #   videoOffset = $video.offset()
      #   wrapperOffset = @editor.wrapper.offset()
      #   $mask.css({
      #     top: videoOffset.top - wrapperOffset.top
      #     left: videoOffset.left - wrapperOffset.left
      #     width: $video.width(),
      #     height: $video.height()
      #   }).show()

      # $video.addClass('loading')
      # $mask = $video.data('mask')
      if !videoData.link and !$video.attr('data-link')
        $video.remove()
      else
        if !videoData.link
          videoData.link = $video.attr('data-link')
        try
          originNode = $(videoData.link)
          videoTag = originNode.get(0).tagName.toLowerCase()
          videoLink = originNode.attr('src')
        catch e
          videoLink = videoData.link
          videoTag = ''
        videoData.tag = videoTag
        $video.attr({'data-link':videoLink ,'data-tag': videoTag, 'width': videoData.width || 100, 'height': videoData.height || 100})

        realVideo = $video.siblings('.real-video')
        if realVideo.length
          # replace
          videoData.link = videoLink
          realVideo.replaceWith @parseVideo videoData
        else
          @decorate $video
          # append
      @popover.hide()

      # if !$mask
      #   $mask = $('''
      #     <div class="simditor-image-loading">
      #       <div class="progress"></div>
      #     </div>
      #   ''')
      #     .hide()
      #     .appendTo(@editor.wrapper)
      #   # positionMask()
      #   $video.data('mask', $mask)
      #   $mask.data('video', $video)

      callback($video)



    createVideo: () ->
      @editor.focus() unless @editor.inputManager.focused
      range = @editor.selection.range()
      if range
        range.deleteContents()
        @editor.selection.range range

      $videoWrap = $('<video/>').attr({'poster': @videoPoster, 'width': 100, 'height': 100});
      range.insertNode $videoWrap[0]
      @editor.selection.setRangeAfter $videoWrap, range
      @editor.trigger 'valuechanged'

      # $nextBlock = $block.next 'p'
      # unless $nextBlock.length > 0
      #   $nextBlock = $('<p/>').append(@editor.util.phBr).insertAfter($block)
      # @editor.selection.setRangeAtStartOf $nextBlock

      $videoWrap

    # 暂时为字符转的拼接
    # todo: 模板引擎方式
    parseVideo: (videoData)->
      switch videoData.tag
        when 'embed' then src = '<embed class="real-video" width=' + videoData.width + ' height= ' + videoData.height + ' src="' + videoData.link + ' "type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" wmode="transparent" loop="false" menu="false" allowscriptaccess="never" allowfullscreen="true">'
        when 'iframe' then src = '<iframe class="real-video" width=' + videoData.width + ' height= ' + videoData.height + ' src=" ' +  videoData.link + '" frameborder=0 allowfullscreen></iframe>'
        else 
          src = videoData.link
      src

    command: () =>
      _self = this
      $video = @createVideo()
      #先弹出输入框
      @popover.show($video)
      
          # @editor.util.reflow $video
          # $video.click()

          # _self.popover.one 'popovershow', =>
          #   _self.popover.srcEl.focus()
          #   _self.popover.srcEl[0].select()


  class VideoPopover extends Simditor.Popover

    offset:
      top: 6
      left: -4

    render: ->
      tpl = """
      <div class="link-settings">
        <div class="settings-field">
          <label>#{ @_t 'video' }</label>
          <input placeholder="#{ @_t 'videoPlaceholder' }" type="text" class="video-link">
        </div>
        <div class="settings-field">
          <label>#{ @_t 'videoSize' }</label>
          <input class="image-size video-size" id="video-width" type="text" tabindex="2" />
          <span class="times">×</span>
          <input class="image-size video-size" id="video-height" type="text" tabindex="3" />
        </div>
        <div class="video-upload">
          <button class="btn J_UploadVideoBtn">#{ @_t 'uploadVideoBtn' }</div>
        </div>
      </div>
      """
      @el.addClass('video-popover')
        .append(tpl)
      @srcEl = @el.find '.video-link'
      @widthEl = @el.find '#video-width'
      @heightEl = @el.find '#video-height'
      # @altEl = @el.find '#image-alt'

      # @srcEl.on 'keydown', (e) =>
      #   return unless e.which == 13 and !@target.hasClass('uploading')
      #   e.preventDefault()
      #   range = document.createRange()
      #   @button.editor.selection.setRangeAfter @target, range
      #   @hide()

      # @srcEl.on 'blur', (e) =>
      #   @_loadImage @srcEl.val()
      
      # @srcEl.on 'blur', (e) =>
      #   $('.J_UploadVideoBtn').click()

        # return
        # @_loadVideo @srcEl.val()

      # @el.find('.image-size').on 'blur', (e) =>
      #   @_resizeImg $(e.currentTarget)
      #   @el.data('popover').refresh()

      # @el.find('.video-size').on 'blur', (e) =>
      #   $('.J_UploadVideoBtn').click()
        # return
        # @_resizeVideo $(e.currentTarget)
        # @el.data('popover').refresh()

      # @el.find('.image-size').on 'keyup', (e) =>
      #   inputEl = $(e.currentTarget)
      #   unless e.which == 13 or e.which == 27 or e.which == 9
      #     @_resizeImg inputEl, true

      @el.find('.video-size').on 'keydown', (e) =>
        if e.which == 13 or e.which == 27
          e.preventDefault()
          $('.J_UploadVideoBtn').click()

      @srcEl.on 'keydown', (e) =>
        if e.which == 13 or e.which == 27
          e.preventDefault()
          $('.J_UploadVideoBtn').click()


      # @el.find('.image-size').on 'keydown', (e) =>
      #   inputEl = $(e.currentTarget)
      #   if e.which == 13 or e.which == 27
      #     e.preventDefault()
      #     if e.which == 13
      #       @_resizeImg inputEl
      #     else
      #       @_restoreImg()

      #     $img = @target
      #     @hide()
      #     range = document.createRange()
      #     @button.editor.selection.setRangeAfter $img, range
      #   else if e.which == 9
      #     @el.data('popover').refresh()

      # @altEl.on 'keydown', (e) =>
      #   if e.which == 13
      #     e.preventDefault()

      #     range = document.createRange()
      #     @button.editor.selection.setRangeAfter @target, range
      #     @hide()

      @editor.on 'valuechanged', (e) =>
        @refresh() if @active

      # @_initUploader()

    # _initUploader: ->
    #   $uploadBtn = @el.find('.btn-upload')
    #   unless @editor.uploader?
    #     $uploadBtn.remove()
    #     return

    #   createInput = =>
    #     @input.remove() if @input
    #     @input = $ '<input/>',
    #       type: 'file'
    #       title: @_t('uploadImage')
    #       accept: 'image/*'
    #     .appendTo($uploadBtn)

    #   createInput()

    #   @el.on 'click mousedown', 'input[type=file]', (e) ->
    #     e.stopPropagation()

    #   @el.on 'change', 'input[type=file]', (e) =>
    #     @editor.uploader.upload(@input, {
    #       inline: true,
    #       img: @target
    #     })
    #     createInput()

    # _resizeImg: (inputEl, onlySetVal = false) ->
    #   value = inputEl.val() * 1
    #   return unless @target and ($.isNumeric(value) or value < 0)



    #   if inputEl.is @widthEl
    #     width = value
    #     height = @height * value / @width
    #     @heightEl.val height
    #   else
    #     height = value
    #     width = @width * value / @height
    #     @widthEl.val width

    #   unless onlySetVal
    #     @target.attr
    #       width: width
    #       height: height
    #     @editor.trigger 'valuechanged'

    # _restoreImg: ->
    #   size = @target.data('image-size')?.split(",") || [@width, @height]
    #   @target.attr
    #     width: size[0] * 1
    #     height: size[1] * 1
    #   @widthEl.val(size[0])
    #   @heightEl.val(size[1])

    #   @editor.trigger 'valuechanged'

    # _loadImage: (src, callback) ->
    #   if /^data:image/.test(src) and not @editor.uploader
    #     callback(false) if callback
    #     return

    #   return if @target.attr('src') == src

    #   @button.loadImage @target, src, (img) =>
    #     return unless img

    #     if @active
    #       @width = img.width
    #       @height = img.height

    #       @widthEl.val @width
    #       @heightEl.val @height

    #     if /^data:image/.test(src)
    #       blob = @editor.util.dataURLtoBlob src
    #       blob.name = "Base64 Image.png"
    #       @editor.uploader.upload blob,
    #         inline: true
    #         img: @target
    #     else
    #       @editor.trigger 'valuechanged'

    #     callback(img) if callback


    _loadVideo: (videoData, callback) ->
      return if videoData and @target.attr('src') == videoData.src
      $('.J_UploadVideoBtn').data('videowrap') && @button.loadVideo $('.J_UploadVideoBtn').data('videowrap'), videoData, (img) =>
        return unless img


    show: (args...) ->
      super args...
      $video = arguments[0] || @target
      @width = $video.attr('width') || $video.width()
      @height = $video.attr('height') || $video.height()
      if $video.attr 'data-link'
        videoData =
          link: $video.attr 'data-link'
          tag: $video.attr 'data-tag'
          width: @width
          height: @height
        @src = @button.parseVideo(videoData)

      @widthEl.val @width
      @heightEl.val @height
      @srcEl.val @src

      $('.J_UploadVideoBtn').data('videowrap', $video)
      $videoWrap = @target
      # @width = $img.width()
      # @height = $img.height()
      # @alt = $img.attr 'alt'

      # if $img.hasClass 'uploading'
      #   @srcEl.val @_t('uploading')
      #     .prop 'disabled', true
      # else
      #   @srcEl.val $img.attr('src')
      #     .prop 'disabled', false
        # @widthEl.val @width
        # @heightEl.val @height
        # @altEl.val @alt


  Simditor.Toolbar.addButton VideoButton
)