simditor-video
==============

[Simditor](http://simditor.tower.im/)扩展，给编辑器添加视频

当前版本 0.0.2


### 如何使用

```html
<link rel="stylesheet" type="text/css" href="css/simditor-video.css">
<script src="js/simditor-video.js"></script>
```

### demo
[simditor-video](http://simditor.sinaapp.com)

### 配置

```javascript
new Simditor({
    textarea: textareaElement,
    ...,
    toolbar: [..., 'video']
})
```

### 注意
点击 video 按钮，可以在编辑器里添加视频。

可以解析 `textarea` 里 `video` 标签为对应的 embed 或者 iframe 视频格式播放

编辑器里鼠标滑过视频弹出视频编辑标签  
PS: 这里会有些交互上的问题，因为视频点击后会播放，所以会出现误操作  
对于这一点，后面会改变交互方式，毕竟视频会有多种的播放器，不像图片点击后无交互动作


### History

v0.0.2
将所有视频统一到 `video` 标签管理，`video` 标签作为一个视频信息存储媒介  
但是这种方式在编辑视频时候会存在交互上问题，等确认交互后改版

v0.0.1

对于不同格式的视频分享，使用不同的标签(embed video iframe)来展示
