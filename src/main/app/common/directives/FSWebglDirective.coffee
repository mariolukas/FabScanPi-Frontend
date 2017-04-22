name = 'fabscan.directives.FSWebglDirective'

angular.module(name,[]).directive("fsWebgl", [
  '$log'
  '$rootScope'
  '$http'
  'fabscan.services.FSEnumService'
  'common.services.Configuration'

  ($log,$rootScope,$http,FSEnumService, Configuration)->

    restrict: "A"
    #scope:
    #  width: "="
    #  height: "="
    #  fillcontainer: "="
    #  scale: "="
    #  materialType: "="
    #  newPoints: "="


    link: postLink = (scope, element, attrs) ->
      camera = undefined
      scene = undefined
      current_point = 0
      renderer = undefined
      positions = undefined
      colors = undefined
      controls = undefined
      pointcloud = undefined
      mesh = undefined
      cameraTarget= undefined
      currentPointcloudAngle = 0
      mousedown = false
      scanLoaded = false
      scanLoaded = false
      turntable = undefined
      rad = 0

      scope.height = window.innerHeight
      scope.width = window.innerWidth
      scope.fillcontainer = true
      scope.materialType = 'lambert'
      scope.objectGeometry = null

      scope.setPointHandlerCallback(scope.addPoints)
      scope.setClearViewHandlerCallback(scope.clearView)
      scope.loadPLYHandlerCallback(scope.loadPLY)
      scope.loadSTLHandlerCallback(scope.loadSTL)
      scope.getRendererCallback(renderer)
      scope.setRenderTypeCallback(scope.renderObjectAsType)

      mouseX = 0
      mouseY = 0
      contW = (if (scope.fillcontainer) then element[0].clientWidth else scope.width)
      contH = scope.height
      windowHalfX = contW / 2
      windowHalfY = contH / 2
      materials = {}

      turntable_radius = 70
      turntable_thickness = 5

      $rootScope.$on('clearcanvas',() ->
          $log.info "view cleared"
          scope.clearView()
      )

      scope.$on(FSEnumService.events.ON_STATE_CHANGED, (events,data) ->
          if data['state'] == FSEnumService.states.SCANNING
            scope.clearView()

      )

      scope.$on(FSEnumService.events.ON_INFO_MESSAGE, (event, data) ->

          if data['message'] == 'SCANNING_TEXTURE'
            scene.remove( turntable )

          if data['message'] == 'SCANNING_OBJECT'
            if not scene.getObjectByName('turntable')
              scene.add(turntable)

          if data['message'] == 'SCAN_CANCELED'
            scope.clearView()
            if not scene.getObjectByName('turntable')
              scene.add(turntable)

          if data['message'] == 'SCAN_COMPLETE'
            scope.createPreviewImage(data['scan_id'])
            scope.scanComplete = true
            scope.currentPointcloudAngle = 0
      )

      scope.init = ->

        # Camera
        #camera = new THREE.PerspectiveCamera(48, window.innerWidth / window.innerHeight, 1, 4800)
        #camera.position.z = 1380
        #camera.position.y = 850


        #camera.rotation.order = 'YXZ'
        #camera.position.set(0,0,1500)
        current_point = 0

        camera = new THREE.PerspectiveCamera(48.8,window.innerWidth/window.innerHeight, 1,1000);
        camera.position.z = 180;
        camera.position.y = 40;


        #this.triDViewer.addToScene( turnTable, "helpers"  )
        # Scene
        scene = new THREE.Scene()
        scene.fog = new THREE.Fog( 0x72645b, 200, 600 )


        plane = new THREE.Mesh(
          new THREE.PlaneBufferGeometry( 2000, 2000 ),
          new THREE.MeshPhongMaterial( { ambient: 0x999999, color: 0x999999, specular: 0x101010 } )
        )
        plane.rotation.x = -Math.PI/2;
        #thickness of turntable
        plane.position.y = -turntable_thickness;
        scene.add( plane )

        plane.receiveShadow = true


        scene.add( new THREE.AmbientLight( 0x777777 ) )

        #light = new THREE.DirectionalLight( 0xffffff );
        #light.position.set( 0, 1, 1 ).normalize();
        #scene.add(light);

        scope.addShadowedLight( 1, 1, 1, 0xffffff, 0.35 )
        scope.addShadowedLight( 0.5, 1, -1, 0xffaa00, 1 )
        #scene.add( new THREE.HemisphereLight( 0x443333, 0x111122 ) );

        #addShadowedLight( 1, 1, 1, 0xffffff, 1.35 );
        #addShadowedLight( 0.5, 1, -1, 0xffaa00, 1 );
        #Grid
        #gridXZ = new THREE.GridHelper(4000, 100)

        #scene.add(gridXZ)

        axes = new THREE.AxisHelper(10);
        #scene.add(axes)

        #controls = new THREE.TrackballControls(camera)
        #controls.rotateSpeed = 1.0
        #controls.zoomSpeed = 10.2
        #controls.panSpeed = 0.8
        #controls.noZoom = true
        #controls.noPan = true
        #controls.staticMoving = true
        #controls.dynamicDampingFactor = 0.3
        #controls.keys = [65, 17, 18]

        # plane
        #plane = new THREE.Mesh(new THREE.PlaneGeometry(300, 300), new THREE.MeshNormalMaterial());
        #plane.overdraw = true;
        #plane.rotation.x = -Math.PI / 2
        #scene.add(plane);


        geometry = new THREE.CylinderGeometry( turntable_radius, turntable_radius, turntable_thickness, 32 );
        material = new THREE.MeshPhongMaterial({color: 0xd3d2c9});
        turntable = new THREE.Mesh( geometry, material )
        turntable.name = "turntable"
        scene.add( turntable )


        renderer = new THREE.WebGLRenderer(
          preserveDrawingBuffer: true
        )
        #renderer.setColor(0x000000, 0)
        #renderer.setSize( window.innerWidth, window.innerHeight )
        #renderer.setSize(contW,contH-4)
        #renderer = new THREE.WebGLRenderer( { antialias: true } )
        renderer.setClearColor( scene.fog.color )
        #renderer.setPixelRatio( window.devicePixelRatio )
        renderer.setSize( window.innerWidth, window.innerHeight )

        renderer.gammaInput = true;
        renderer.gammaOutput = true;

        renderer.shadowMapEnabled = true;
        renderer.shadowMapCullFace = THREE.CullFaceBack


        # element is provided by the angular directive
        element[0].appendChild renderer.domElement
        window.addEventListener "resize", scope.onWindowResize, false
        window.addEventListener "DOMMouseScroll", scope.onMouseWheel, false
        window.addEventListener "mousewheel", scope.onMouseWheel, false
        document.addEventListener "keydown", scope.onKeyDown, false

        element[0].addEventListener "mousemove", scope.onMouseMove, false
        element[0].addEventListener "mousedown", scope.onMouseDown, false
        element[0].addEventListener "mouseup", scope.onMouseUp, false

        return

      # ----------------------------------
      # Controls
      # ----------------------------------



      # -----------------------------------
      # Event listeners
      # -----------------------------------

      scope.createPreviewImage= (id) ->
        screenshot = renderer.domElement.toDataURL( 'image/png' )
        $http.post(Configuration.installation.httpurl+"api/v1/scans/"+id+"/previews",
          image: screenshot
          id: id
        ).success (response) ->
          $log.info response
          return

      scope.onWindowResize = ->
        scope.resizeCanvas()
        return

      scope.onMouseDown = (evt) ->
        mousedown = true

      scope.onMouseUp = (evt) ->
        mousedown = false

      scope.onStart = (evt) ->
        mousedown = true

      scope.onStop = (evt) ->
        mousedown = false

      scope.onDrag = (evt) ->
          $log.info evt

      scope.onMouseMove = (evt) ->
        if mousedown
          d = ((if (evt.movementX > 0) then 0.1 else -0.1))
          if pointcloud and scope.scanLoaded
            pointcloud.rotation.z += d
          if pointcloud and scope.scanComplete
            pointcloud.rotation.y +=d
          if mesh and scope.scanLoaded
            mesh.rotation.z += d


      #scope.onMouseWheel = (evt) ->

      #  d = ((if (typeof evt.wheelDelta isnt "undefined") then (-evt.wheelDelta) else evt.detail))
      #  d =  ((if (d > 0) then 0.1 else -0.1))
        #console.log d
        #cPos = camera.position
        #return  if isNaN(cPos.x) or isNaN(cPos.y) or isNaN(cPos.y)
      #  if pointcloud
      #    if scope.scanComplete
      #        pointcloud.rotation.y +=d
      #    else
      #        pointcloud.rotation.z += d

        # Your zomm limitation
        # For X axe you can add anothers limits for Y / Z axes
        #return  if cPos.z > 50 or cPos.z < -50
        #mb = (if d > 0 then 1.1 else 0.9)
        #cPos.x = cPos.x * mb
        #cPos.y = cPos.y * mb
        #cPos.z = cPos.z * mb
      #  return

      # Handle colors and pointsize
      scope.onKeyDown = (evt) ->

        # Increase/decrease point size
        pointSize -= 0.003  if evt.keyCode is 189 or evt.keyCode is 109
        pointSize += 0.003  if evt.keyCode is 187 or evt.keyCode is 107
        changeColor "x"  if evt.keyCode is 49
        changeColor "y"  if evt.keyCode is 50
        changeColor "z"  if evt.keyCode is 51
        changeColor "rgb"  if evt.keyCode is 52

        # Re-render the scene
        material = new THREE.ParticleBasicMaterial(
          size: pointSize
          vertexColors: true
        )
        pointcloud = new THREE.ParticleSystem(geometry, material)
        scene = new THREE.Scene()
        #scene.fog = new THREE.FogExp2(0x000000, 0.0009)
        scene.add pointcloud
        scope.render()



      # -----------------------------------
      # Updates
      # -----------------------------------
      scope.resizeCanvas = ->
        contW = (if (scope.fillcontainer) then element[0].clientWidth else scope.width)
        contH = scope.height
        windowHalfX = contW / 2
        windowHalfY = contH / 2
        camera.aspect = contW / contH
        camera.updateProjectionMatrix()
        renderer.setSize contW, contH
        return

      scope.resizeObject = ->
        #icosahedron.scale.set scope.scale, scope.scale, scope.scale
        #shadowMesh.scale.set scope.scale, scope.scale, scope.scale
        return

      scope.changeMaterial = ->
        #icosahedron.material = materials[scope.materialType]
        return

      scope.Float32Concat = (first, second) ->
        firstLength = first.length
        result = new Float32Array(firstLength + second.length)
        result.set first
        result.set second, firstLength
        result


      scope.addShadowedLight = (x, y, z, color, intensity) ->
          directionalLight = new (THREE.DirectionalLight)(color, intensity)
          directionalLight.position.set x, y, z
          scene.add directionalLight
          directionalLight.castShadow = true
          # directionalLight.shadowCameraVisible = true;
          d = 1
          directionalLight.shadowCameraLeft = -d
          directionalLight.shadowCameraRight = d
          directionalLight.shadowCameraTop = d
          directionalLight.shadowCameraBottom = -d
          directionalLight.shadowCameraNear = 1
          directionalLight.shadowCameraFar = 4
          directionalLight.shadowMapWidth = 1024
          directionalLight.shadowMapHeight = 1024
          directionalLight.shadowBias = -0.005


      scope.renderMesh = (meshFormat) ->

          scope.clearView()

          scope.objectGeometry.computeFaceNormals();

          if meshFormat == 'stl'

              material = new THREE.MeshPhongMaterial(
                  color: 0x0000FF,
                  specular: 0x111111,
                  shininess: 100
              )

          else
              material = new THREE.MeshBasicMaterial(
                  shininess: 200 ,
                  wireframe:false,
                  vertexColors: THREE.FaceColors
              )

          mesh = new THREE.Mesh(scope.objectGeometry, material );

          mesh.position.set( 0, - 0.25, 0 );
          mesh.rotation.set( - Math.PI / 2, 0 , 0);
          mesh.scale.set( 0.1, 0.1, 0.1 );

          if meshFormat == 'stl'
              mesh.castShadow = true;
              mesh.receiveShadow = true;

          scene.add( mesh )


      scope.renderPLY = () ->
          pointcloud = new (THREE.Object3D)
          material = new (THREE.PointsMaterial)(
              size: 0.5,
              vertexColors : THREE.FaceColors
          )
          pointcloud = new (THREE.Points)(scope.objectGeometry, material)
          pointcloud.rotation.set( - Math.PI / 2, 0 , 0);
          scene.add(pointcloud)

      scope.renderObjectAsType = (type) ->

          if type == "MESH"
            scope.clearView()
            scope.renderMesh('ply')

          if type == "POINTCLOUD"
            scope.clearView()
            scope.renderPLY()

      scope.loadSTL = (file) ->
        scope.clearView()
        scope.scanComplete = false
        loader = new THREE.STLLoader();

        loader.load  file,  ( objectGeometry ) ->
            #scene.add( new THREE.Mesh( geometry ) )
            scope.objectGeometry = objectGeometry
            if file.indexOf("mesh") > -1
                scope.renderMesh('stl')
            scope.scanLoaded = true

        loader.addEventListener 'progress', (item) ->
          scope.progressHandler(item)

         $log.info("Not implemented yet")

      scope.loadPLY = (file) ->
        scope.clearView()
        scope.scanComplete = false
        loader = new THREE.PLYLoader()
        loader.useColor = true
        loader.colorsNeedUpdate = true
        loader.addEventListener 'progress', (item) ->
          scope.progressHandler(item)

        loader.load file, (objectGeometry) ->
          scope.objectGeometry = objectGeometry
          if file.indexOf("mesh") > -1
            scope.renderMesh()
          else
            scope.renderPLY()

          return

      scope.addPoints = (points, progress, resolution) ->

        scope.scanComplete = false
        if (points.length > 0)
          if pointcloud
            currentPointcloudAngle = pointcloud.rotation.y+80
            scene.remove(pointcloud)
          else
            currentPointcloudAngle = 90*(Math.PI/180)+80

          new_positions = new Float32Array(points.length*3)
          new_colors = new Float32Array(points.length*3)

          i = 0
          while i< points.length
              new_positions[3*i] = parseFloat(points[i]['x'])
              new_positions[3*i+1] = parseFloat(points[i]['y'])
              new_positions[3*i+2] = parseFloat(points[i]['z'])

              color = new THREE.Color("rgb("+points[i]['r']+","+points[i]['g']+","+points[i]['b']+")")
              new_colors[3*i] = color.r
              new_colors[3*i+1] =color.g
              new_colors[3*i+2] = color.b
              i++

          if positions is undefined
            positions = new_positions
            colors = new_colors
          else
            positions = scope.Float32Concat(positions,new_positions)
            colors = scope.Float32Concat(colors,new_colors)

          geometry = new THREE.BufferGeometry()
          geometry.dynamic = true
          geometry.addAttribute( 'position', new THREE.BufferAttribute( positions, 3 ) );
          geometry.addAttribute( 'color', new THREE.BufferAttribute( colors, 3 ) );

          if !pointcloud
            material = new THREE.PointsMaterial({size: 0.5 , vertexColors: THREE.VertexColors })
            pointcloud = new THREE.Points(geometry, material)
          else
            pointcloud.geometry.dispose()
            pointcloud.geometry = geometry


          degree =  360/resolution
          $log.info degree
          scope.rad = degree*(Math.PI/180)


          scene.add(pointcloud)

          if pointcloud
            pointcloud.rotation.y +=  scope.rad
          #  $log.info currentPointcloudAngle - scope.rad


        #while i < points.length
          #point = new THREE.Vector3(parseFloat(points[i].x), parseFloat(points[i].z)+450, parseFloat(points[i].y))
          #pointcloud.geometry.vertices.push(point)
          #pointcloud.geometry.dispose()
          #_points[current_point] = points
          #i++
          #current_point++

        #if progress == resolution
          #scope.createScreenShot()
        #pointcloudRotation = angle

      scope.clearView = () ->
        if pointcloud
          positions = undefined
          colors = undefined
          scene.remove(pointcloud)
          scene.remove(mesh)

      # -----------------------------------
      # Draw and Animate
      # -----------------------------------
      scope.animate = ->
        requestAnimationFrame scope.animate
        scope.render()
        return

      scope.render = ->
        #camera.position.x += (mouseX - camera.position.x) * 0.05

        #camera.position.y += ( - mouseY - camera.position.y ) * 0.05;

        #camera.lookAt scene.position

        #camera.lookAt scene
        #pointcloud.add( camera )
        #camera.position.set( 15, 0, 0 );
        #camera.lookAt( new THREE.Vector3( 0, 0, 0 ) );
        #pointcloud.rotation.y
        #camera.lookAt( cameraTarget )
        renderer.render scene, camera
        #controls.update()
        return

      # -----------------------------------
      # Watches
      # -----------------------------------

      scope.$watch "newPoints", (newValue, oldValue) ->
        if newValue != oldValue
          scope.addPoints newValue

        return

      scope.$watch "fillcontainer + width + height", ->
        scope.resizeCanvas()
        return

      scope.$watch "scale", ->
        scope.resizeObject()
        return

      scope.$watch "materialType", ->
        #scope.changeMaterial()
        return


      # Begin
      scope.init()
      scope.animate()
      return
])
