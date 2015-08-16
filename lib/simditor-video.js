(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  (function(factory) {
    if ((typeof define === 'function') && define.amd) {
      return define(['simditor', 'video'], factory);
    } else {
      return factory(window.Simditor, window.video);
    }
  })(function(Simditor, _video) {
    var VideoButton, VideoPopover;
    VideoButton = (function(_super) {
      __extends(VideoButton, _super);

      function VideoButton() {
        this.command = __bind(this.command, this);
        return VideoButton.__super__.constructor.apply(this, arguments);
      }

      VideoButton.prototype.name = 'video';

      VideoButton.prototype.icon = 'video-o';

      VideoButton.prototype.htmlTag = 'embed, iframe';

      VideoButton.prototype.disableTag = 'pre, table, div';

      VideoButton.prototype.videoPlaceholder = 'video';

      VideoButton.prototype.videoPoster = 'http://pic.yupoo.com/ccking/ESzA3WGs/svIoz.png';

      VideoButton.prototype.needFocus = true;

      VideoButton.prototype._init = function() {
        this.title = this._t(this.name);
        $.merge(this.editor.formatter._allowedTags, ['embed', 'iframe', 'video']);
        $.extend(this.editor.formatter._allowedAttributes, {
          embed: ['class', 'width', 'height', 'type', 'pluginspage', 'src', 'wmode', 'play', 'loop', 'menu', 'allowscriptaccess', 'allowfullscreen'],
          iframe: ['class', 'width', 'height', 'src', 'frameborder'],
          video: ['class', 'width', 'height', 'poster', 'controls', 'allowfullscreen', 'src', 'data-link', 'data-tag']
        });
        $(document).on('click', '.J_UploadVideoBtn', (function(_this) {
          return function(e) {
            var videoData;
            videoData = {
              link: $('.video-link').val(),
              width: $('#video-width').val() || 100,
              height: $('#video-height').val() || 100
            };
            $('.video-link').val('');
            $('#video-width').val('');
            $('#video-height').val('');
            return _this.loadVideo($('.J_UploadVideoBtn').data('videowrap'), videoData, function() {
              return _this.editor.trigger('valuechanged');
            });
          };
        })(this));
        this.editor.body.on('click', 'video', (function(_this) {
          return function(e) {
            var $video, range;
            $video = $(e.currentTarget);
            _this.popover.show($video);
            range = document.createRange();
            range.selectNode($video[0]);
            _this.editor.selection.range(range);
            if (!_this.editor.util.support.onselectionchange) {
              _this.editor.trigger('selectionchanged');
            }
            return false;
          };
        })(this));
        this.editor.body.on('mouseenter', '.simditor-video .real-video', (function(_this) {
          return function(e) {
            var $video;
            $video = $(e.currentTarget).siblings('video').show();
            return _this.popover.show($video);
          };
        })(this));
        this.editor.body.on('mousedown', (function(_this) {
          return function() {
            var $videoWrap;
            $videoWrap = $('.J_UploadVideoBtn').data('videowrap');
            if ($videoWrap && $videoWrap.html() === _this.videoPlaceholder) {
              $videoWrap.remove();
              $('.J_UploadVideoBtn').data('videowrap', null);
            }
            return _this.popover.hide();
          };
        })(this));
        this.editor.on('decorate', (function(_this) {
          return function(e, $el) {
            return $el.find('video').each(function(i, video) {
              return _this.decorate($(video));
            });
          };
        })(this));
        this.editor.on('undecorate', (function(_this) {
          return function(e, $el) {
            return $el.find('video').each(function(i, video) {
              return _this.undecorate($(video));
            });
          };
        })(this));
        return VideoButton.__super__._init.call(this);
      };

      VideoButton.prototype.decorate = function($video) {
        var videoData, videoSrc;
        videoData = {
          tag: $video.attr('data-tag'),
          link: $video.attr('data-link'),
          width: $video.attr('width'),
          height: $video.attr('height')
        };
        videoSrc = this.parseVideo(videoData);
        if ($video.parent('.simditor-video').length > 0) {
          this.undecorate($video);
        }
        $video.wrap('<p class="simditor-video"></p>');
        $video.parent().prepend(videoSrc);
        $video.hide();
        return $video.parent();
      };

      VideoButton.prototype.undecorate = function($video) {
        if (!($video.parent('.simditor-video').length > 0)) {
          return;
        }
        $video.siblings('.real-video').remove();
        return $video.parent().replaceWith($video);
      };

      VideoButton.prototype.render = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        VideoButton.__super__.render.apply(this, args);
        return this.popover = new VideoPopover({
          button: this
        });
      };

      VideoButton.prototype.renderMenu = function() {
        return VideoButton.__super__.renderMenu.call(this);
      };

      VideoButton.prototype._status = function() {
        return this._disableStatus();
      };

      VideoButton.prototype.loadVideo = function($video, videoData, callback) {
        var e, originNode, realVideo, videoLink, videoTag;
        if (!videoData.link && !$video.attr('data-link')) {
          $video.remove();
        } else {
          if (!videoData.link) {
            videoData.link = $video.attr('data-link');
          }
          try {
            originNode = $(videoData.link);
            videoTag = originNode.get(0).tagName.toLowerCase();
            videoLink = originNode.attr('src');
          } catch (_error) {
            e = _error;
            videoLink = videoData.link;
            videoTag = '';
          }
          videoData.tag = videoTag;
          $video.attr({
            'data-link': videoLink,
            'data-tag': videoTag,
            'width': videoData.width || 100,
            'height': videoData.height || 100
          });
          realVideo = $video.siblings('.real-video');
          if (realVideo.length) {
            videoData.link = videoLink;
            realVideo.replaceWith(this.parseVideo(videoData));
          } else {
            this.decorate($video);
          }
        }
        this.popover.hide();
        return callback($video);
      };

      VideoButton.prototype.createVideo = function() {
        var $videoWrap, range;
        if (!this.editor.inputManager.focused) {
          this.editor.focus();
        }
        range = this.editor.selection.range();
        if (range) {
          range.deleteContents();
          this.editor.selection.range(range);
        }
        $videoWrap = $('<video/>').attr({
          'poster': this.videoPoster,
          'width': 100,
          'height': 100
        });
        range.insertNode($videoWrap[0]);
        this.editor.selection.setRangeAfter($videoWrap, range);
        this.editor.trigger('valuechanged');
        return $videoWrap;
      };

      VideoButton.prototype.parseVideo = function(videoData) {
        var src;
        switch (videoData.tag) {
          case 'embed':
            src = '<embed class="real-video" width=' + videoData.width + ' height= ' + videoData.height + ' src="' + videoData.link + ' "type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" wmode="transparent" loop="false" menu="false" allowscriptaccess="never" allowfullscreen="true">';
            break;
          case 'iframe':
            src = '<iframe class="real-video" width=' + videoData.width + ' height= ' + videoData.height + ' src=" ' + videoData.link + '" frameborder=0 allowfullscreen></iframe>';
            break;
          default:
            src = videoData.link;
        }
        return src;
      };

      VideoButton.prototype.command = function() {
        var $video, _self;
        _self = this;
        $video = this.createVideo();
        return this.popover.show($video);
      };

      return VideoButton;

    })(Simditor.Button);
    VideoPopover = (function(_super) {
      __extends(VideoPopover, _super);

      function VideoPopover() {
        return VideoPopover.__super__.constructor.apply(this, arguments);
      }

      VideoPopover.prototype.offset = {
        top: 6,
        left: -4
      };

      VideoPopover.prototype.render = function() {
        var tpl;
        tpl = "<div class=\"link-settings\">\n  <div class=\"settings-field\">\n    <label>" + (this._t('video')) + "</label>\n    <input placeholder=\"" + (this._t('videoPlaceholder')) + "\" type=\"text\" class=\"video-link\">\n  </div>\n  <div class=\"settings-field\">\n    <label>" + (this._t('videoSize')) + "</label>\n    <input class=\"image-size video-size\" id=\"video-width\" type=\"text\" tabindex=\"2\" />\n    <span class=\"times\">×</span>\n    <input class=\"image-size video-size\" id=\"video-height\" type=\"text\" tabindex=\"3\" />\n  </div>\n  <div class=\"video-upload\">\n    <button class=\"btn J_UploadVideoBtn\">" + (this._t('uploadVideoBtn')) + "</div>\n  </div>\n</div>";
        this.el.addClass('video-popover').append(tpl);
        this.srcEl = this.el.find('.video-link');
        this.widthEl = this.el.find('#video-width');
        this.heightEl = this.el.find('#video-height');
        this.el.find('.video-size').on('keydown', (function(_this) {
          return function(e) {
            if (e.which === 13 || e.which === 27) {
              e.preventDefault();
              return $('.J_UploadVideoBtn').click();
            }
          };
        })(this));
        this.srcEl.on('keydown', (function(_this) {
          return function(e) {
            if (e.which === 13 || e.which === 27) {
              e.preventDefault();
              return $('.J_UploadVideoBtn').click();
            }
          };
        })(this));
        return this.editor.on('valuechanged', (function(_this) {
          return function(e) {
            if (_this.active) {
              return _this.refresh();
            }
          };
        })(this));
      };

      VideoPopover.prototype._loadVideo = function(videoData, callback) {
        if (videoData && this.target.attr('src') === videoData.src) {
          return;
        }
        return $('.J_UploadVideoBtn').data('videowrap') && this.button.loadVideo($('.J_UploadVideoBtn').data('videowrap'), videoData, (function(_this) {
          return function(img) {
            if (!img) {

            }
          };
        })(this));
      };

      VideoPopover.prototype.show = function() {
        var $video, $videoWrap, args, videoData;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        VideoPopover.__super__.show.apply(this, args);
        $video = arguments[0] || this.target;
        this.width = $video.attr('width') || $video.width();
        this.height = $video.attr('height') || $video.height();
        if ($video.attr('data-link')) {
          videoData = {
            link: $video.attr('data-link'),
            tag: $video.attr('data-tag'),
            width: this.width,
            height: this.height
          };
          this.src = this.button.parseVideo(videoData);
        }
        this.widthEl.val(this.width);
        this.heightEl.val(this.height);
        this.srcEl.val(this.src);
        $('.J_UploadVideoBtn').data('videowrap', $video);
        return $videoWrap = this.target;
      };

      return VideoPopover;

    })(Simditor.Popover);
    return Simditor.Toolbar.addButton(VideoButton);
  });

}).call(this);
