local composer = require( "composer" )
local scene = composer.newScene()
local centerX, centerY = display.contentCenterX, display.contentCenterY
local physics = require("physics")
physics.start( )
physics.setGravity( 0, 2 )
--physics.setDrawMode( "hybrid" )
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------

-- Change to menu scene --
function gotoMenu(event)
   display.setDefault( "background", 0, 0, 0 )
   composer.setVariable( "selectedTime", selectedTime)
   local goToSceneOptions = {
      effect = "fade",
      time = 300
   }
   composer.gotoScene( "title", goToSceneOptions)
end
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   

end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      print("phase show", phase)
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
   	local w,h = display.contentWidth, display.contentHeight
   	local buttomBar = display.newRect( centerX, 900, w, 20 )

   	hangedMan = display.newImage(sceneGroup,"assets/hanged.jpg", centerX, centerY)
	
	 menuButton = display.newImage (sceneGroup,"assets/menu.png",174,172);
      menuButton.x = centerX
      menuButton.y = centerY + 100
      menuButton.xScale = 0.40
      menuButton.yScale = 0.40

      menuButton:addEventListener( "tap", gotoMenu )   
	
	gameOver = display.newImage(sceneGroup,"assets/gameOver.png", centerX, 0)
	physics.addBody( gameOver, "dynamic",{ density=1, friction=0.3, bounce=0.95} )
	physics.addBody( buttomBar, "static" )
	hangedMan.xScale = 2
	hangedMan.yScale = 2
	gameOver.xScale = 0.5
	gameOver.yScale = 0.5
			
      
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase

 
   if ( phase == "will" ) then
      print("phase hide", phase)
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene