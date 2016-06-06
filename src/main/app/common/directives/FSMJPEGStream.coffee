name = 'fabscan.directives.FSMJPEGStream'
angular.module(name, []).directive('mjpeg', [
  '$log'
  ($log)->

    restrict: 'E'
    replace: true
    template: '<span></span>'
    scope:
          'url': '='
          'mode': '='

    link: (scope, element, attrs) ->

      scope.createFrame = (newVal) ->

        iframe = document.createElement('iframe')
        iframe.setAttribute 'frameborder', '0'
        iframe.setAttribute 'scrolling', 'no'
        iframe.setAttribute 'style' , "height:100%;  position:absolute;"


        #element.replaceChild(iframe,iframe)
        if element.childElementCount > 0
          element.childNodes[0].destroy()
          #element.replaceChild(iframe, )
          element.append iframe
        else
          element.append iframe


        if scope.mode == "texture"
          iframe.setAttribute 'width', '100%'

          iframeHtml = '<html><head><base target="_parent" /><style type="text/css">html, body { margin: 0; padding: 0; height: 320px; }</style><script> function resizeParent() { var ifs = window.top.document.getElementsByTagName("iframe"); for (var i = 0, len = ifs.length; i < len; i++) { var f = ifs[i]; var fDoc = f.contentDocument || f.contentWindow.document; if (fDoc === document) { f.height = 0; f.height = document.body.scrollHeight; } } }</script></head><body style="" onresize="resizeParent()"><img src="' + newVal + '" style="z-index:1000; opacity: 0.4; width: 60%; bottom:70px; left:20%;  position:absolute;" onload="resizeParent()" /></body></html>'


        if scope.mode == "preview"
            #iframe.setAttribute 'width', '320px'
            iframe.setAttribute 'height', '240px'
            iframeHtml = '<html><head><base target="_parent" /><style type="text/css">html, body { margin: 0; padding: 0; height: 240px; }</style><script> function resizeParent() { var ifs = window.top.document.getElementsByTagName("iframe"); for (var i = 0, len = ifs.length; i < len; i++) { var f = ifs[i]; var fDoc = f.contentDocument || f.contentWindow.document; if (fDoc === document) { f.width = 0; f.width = document.body.scrollWidth; } } }</script></head><body onresize="resizeParent()"><img src="' + newVal + '" style="z-index:1000; opacity: 1.0; height:240px; position:absolute;" onload="resizeParent()" /><div style="position:absolute;  text-align:center; background-color:black; width:180px;  height:240px; float:left; z-index:-1000;"><img style="margin-top:100px; margin-left:70px width:50px; height:50px;" src="icons/spinner.gif" /></div></body></html>'


        doc = iframe.document
        if iframe.contentDocument
            doc = iframe.contentDocument
        else if iframe.contentWindow
            doc = iframe.contentWindow.document

        doc.open()
        doc.writeln iframeHtml
        doc.close()

      scope.$watch 'url', ((newVal, oldVal) ->

        #if newVal != oldVal || newVal != undefined
          scope.createFrame(newVal)
        #else
        #  element.html '<span style="position:absolute; text-align:center; left:0px; top:0px;"><img style="margin-top:100px; width:50px; height:50px;" src="icons/spinner.gif"></span>'
        #return
      ), true
      return
])