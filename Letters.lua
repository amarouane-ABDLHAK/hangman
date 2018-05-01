local hanger = require("hanger")
local composer = require( "composer" )

local Letters = {word = "test"}
local frames = {}
local width, height = 96
local str = "agmsybhntzciou,djpv.ekqw?flrx!"
local alphabets = "abcdefghijklmnopqrstuvwxyz"
local player = require("player")
local playerScore = player:new({xPos = 0, yPos=0})
playerScore:displayScore(0)
local myHanger = hanger:new()
myHanger:draw()

local  letterMap = {}
local centerX, centerY = display.contentCenterX, display.contentCenterY


-- Go nextLevel -- 
function gotoLevel(lev)
   display.setDefault( "background", 0, 0, 0 )
   local goToSceneOptions = {
      effect = "crossFade",
      time = 1400,   
   }
   composer.gotoScene( "game", goToSceneOptions)
end
function initFrames(  )
	local x, y, count = -96, -96, 0
	
	
		for i=1,6 do
			x=x+96
			y = -96
			
			for j=1,5 do
				count = count +1
				local letter = string.sub(str, count, count)
				
				frames[letter]={}
				y = y+96
				
				frames[letter] = {x=x, y = y}
			end

		end
	
end
local spriteFrames = {}
initFrames(  )
for i = 1, string.len(alphabets) do
	local letter = string.sub(alphabets, i, i)
	letterMap[letter] = i
	spriteFrames[i] = {x=frames[letter].x, y = frames[letter].y, width = 96, height = 96}
    --print(string.sub(alphabets, i, i), frames[string.sub(alphabets, i, i)])
end

local myFrame = {{x=frames['d'].x, y = frames['d'].y, width = 96, height = 96},
		{x=96, y = 0, width = 96, height = 96}}
print(frames['a'].x, frames['b'].y)
local lettersOpt =
{
	frames = spriteFrames
};

local lettersSheet = graphics.newImageSheet( "assets/Letters.jpg", lettersOpt );


function shuffle(word)
	local shufledWord = ""
	local wordLength = string.len(word)
	if(wordLength%2 ~= 0)then
		
		word = word..'z'
	end

	
	for i = 1, string.len(word)/2 do
		letterEven = string.sub(word, i, i)
		letterPair = string.sub(word, wordLength-i+1, wordLength-i+1)

		shufledWord = shufledWord..letterPair..letterEven

	end
	
  	return shufledWord
end

function letterInWord(word, letter)
	for i = 1, string.len(word) do
		if(letter == string.sub(word, i, i)) then
			return true
		end
  	end
  	return false
end


function Letters:getRandomLetters(word, numOfLetters)
	local pos = math.random( 1,26 )
	local count = 0
	while count < numOfLetters do
		
		rand = math.random( 1,26 )
		
		if(not letterInWord(word, string.sub(alphabets, rand, rand)) ) then
			word  = word..string.sub(alphabets, rand, rand)

			count = count + 1
		end
	end
	print("word", word)
	return shuffle(word)
end

function Letters:new( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	return o
end

function Letters:getLettersProsition_2( word )
	LettersXposYpos = {}
	local xPos, yPos = 30, (3*centerY/2) - 100
	
	for i = 1, string.len(word) do
		
			local ele = string.sub(word, i, i)
			
		
			if(i % 6 ~= 0) then
				xPos = xPos+(64)
			else

				xPos = 30+64
				
				yPos = yPos + 64
			
			end


			LettersXposYpos[i] = display.newRect( xPos - 60, yPos - 48, 48, 48 )
			
	end

	return LettersXposYpos
	
end


function Letters:getLettersProsition_1( word )
	local count = 0
	local objects, checkLetters = {}, {}
	local xPos, yPos = 30, (3*centerY/2)+15
	local lettersPosition = {}
	for i = 1, string.len(word) do
		local ele = string.sub(word, i, i)
		if(lettersPosition[ele] == nil) then
			lettersPosition[ele]=i
		else
			lettersPosition[ele]  = lettersPosition[ele]..i
		end
	end
	
	word = self:getRandomLetters(word, 4)
	for i = 1, string.len(word) do
		local ele = string.sub(word, i, i)

		if(checkLetters[ele] == nil) then
			count = count + 1
			
		
			local temp= self:displayLetter(ele, xPos,yPos, lettersPosition[ele] )
			if(count % 5 ~= 0) then
				
				xPos = xPos+(64)
			else
				xPos = 30
				yPos = yPos + 64
			
			end

			objects[count] = temp

			
			checkLetters[ele] = ele
		end
	

	end
	return objects
end

function Letters:tap( event )
	local hasMultiLetters = false
	

	if(event.target.lettersPosition == nil) then
		event.target:removeSelf( )
		print("DRAW PARTS")
		print("Maintain the wrong values !!")
		myHanger:onWrongSelect()
		if(myHanger.wrongSelectionCount >= 4) then
			print("SHow game over")
		end
		
		

		return
	end
	for i = 1, string.len(event.target.lettersPosition) do
		local pos = tonumber(string.sub(event.target.lettersPosition, i, i))
		playerScore.tries = playerScore.tries + 1
		local placeHolder = self.letterXposYpos[pos]
		local x, y = placeHolder.x, placeHolder.y
		local shapeTrasn = event.target
		if(hasMultiLetters) then
			
			shapeTrasn = self:displayLetter( event.target.letter , event.target.x, event.target.y, nil ).shape
		end
		transition.to( shapeTrasn, { time=1500, x= x, y= y, onComplete= function () placeHolder:removeSelf( )
			-- body
		end } )

		hasMultiLetters = true
		
	end
	
	if(playerScore.tries ==  string.len(self.ChosedWord) and myHanger.wrongSelectionCount < 4) then
		playerScore.tries = 0
		myHanger.wrongSelectionCount = 0
		
		playerScore:displayScore(1)
		print("SHOW NEXT WORD", myHanger.wrongSelectionCount)
		gotoLevel(2)
	end
	
	--TODO Add logic if USER misses a letter
end

function Letters:displayWord( word )
	self.ChosedWord = word
	self.letterXposYpos = self:getLettersProsition_2( word )
	
	return self:getLettersProsition_1( word )
end

function Letters:displayLetter( letter , xPos, yPos, lettersPosition )
	
	local letterObj ={}
	letterObj.shape = display.newImage( lettersSheet, letterMap[letter] );
	letterObj.shape.x = xPos
	letterObj.shape.y = yPos
	letterObj.shape.xScale = (0.5/display.contentWidth) * 320
	letterObj.shape.yScale = (0.5/display.contentHeight) * 480 
	letterObj.shape.letter = letter
	letterObj.shape.lettersPosition = lettersPosition

	return letterObj
end

-- function Letters:show(  )
-- 	display.newSprite( [parent,] imageSheet, sequenceData )
-- end
return Letters