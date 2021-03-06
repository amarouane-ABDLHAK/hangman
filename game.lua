local composer = require( "composer" )
local scene = composer.newScene()

require "try-catch"

local hanger = require("hanger")
local myHanger = hanger:new()
local Letters = require("Letters")
local words = require("words")
local ShowDefinition = require("ShowDefinition")
local objects
local definition = ShowDefinition:new({xPos =10, yPos=display.actualContentHeight -100})
local myletter = Letters:new()
myHanger:draw()
myletter.myHanger = myHanger
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
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
      
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then

      local wordIndex = math.random( 1,12 )
      local pickedWord = words["easy"][wordIndex]
      local word = pickedWord["word"]
      
      
      
      definition:show(pickedWord["definition"])

      objects = myletter:displayWord(word)

      
      for k,v in ipairs(objects) do
         
            v.shape:addEventListener( "tap", myletter )

            
        
      end
 
      
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
      for k,v in ipairs(objects) do
         try {
         function()
            v.shape:removeSelf( )
       end,

         catch {
      function(error)
         print('caught error: ' .. error)
      end
         }
         }
            

            
        
      end
     
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