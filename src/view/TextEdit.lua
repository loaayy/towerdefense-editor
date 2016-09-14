--
-- Author: Your Name
-- Date: 2015-09-28 16:38:15
--

local KEYBOARD_TAG = 1

local TextEdit = class("TextEdit", function()
		return display.newNode()
	end)

function TextEdit:ctor(args)
	self.textHolderClr_ = args.placeHolderClr or cc.c4b(128, 128, 128, 128)
	self.textClr_ = args.textClr or cc.c4b(255, 255, 255, 255)
	self.textHolder_ = args.placeHolder or "Input Text"
	self.text_ = args.text
	self.max_ = args.max or 10
	self:setContentSize(args.size or cc.size(1, 1))

	local label = cc.LabelTTF:create(self.text_ or self.textHolder_,"黑体",24)
	self:addChild(label)
	local contentSize = self:getContentSize()
	label:align(display.CENTER, contentSize.width/2, contentSize.height/2)
	self.label_ = label
	self:changeClr_()

	local touchlabel = cc.LabelTTF:create("_______________","黑体",24)
	self:addChild(touchlabel)
	touchlabel:align(display.CENTER, contentSize.width/2, contentSize.height/2)
	touchlabel:setTouchEnabled(true)
	touchlabel:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()
		self:showKeyBoard_()
	end)

	local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    -- listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    -- listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function TextEdit:onKeyBoardCreate(callback)
	self.onKeyboardCreate_ = callback
end

function TextEdit:onTouchBegan(touch)
	local touchPos = touch:getLocation()
	if self:isKeyBoardShow() then
		local keyBoard = self.keyBoard_
		if not cc.rectContainsPoint(keyBoard:getBoundingBox(),touchPos) then
			self:disappearKeyBoard_()
		end
		return true
	else
		
		return false

	end
end

function TextEdit:onTouchMoved()
end

function TextEdit:onTouchEnded()
end

function TextEdit:showKeyBoard_()
	local keyBoard = self:getKeyBoardView_()
	keyBoard:setVisible(true)
end

function TextEdit:disappearKeyBoard_()
	local keyBoard = self:getKeyBoardView_()
	keyBoard:setVisible(false)
end

function TextEdit:isKeyBoardShow()
	local keyBoard = self.keyBoard_ -- self:getChildByTag(KEYBOARD_TAG)
	if keyBoard then
		return keyBoard:isVisible()
	end
	return false
end

function TextEdit:hitTest(point)
	if self:isKeyBoardShow() then
		local boundingBox = self:getBoundingBox()
		local pos = self:convertToWorldSpace(cc.p(boundingBox.x, boundingBox.y))
		boundingBox.x = pos.x
		boundingBox.y = pos.y
		if cc.rectContainsPoint(boundingBox, point) then
			return true
		end
	end
	return false
end

function TextEdit:setString(str)
	self.text_ = str
	if self.text_ then
		if string.len(self.text_) > self.max_ then
			self.text_ = string.sub(self.text_, 1, self.max_)
		end
		self.label_:setString(self.text_)
	else
		self.label_:setString("")
	end
	self:changeClr_()
end

function TextEdit:getString()
	return self.text_
end

function TextEdit:setColor(clr)
	self.textClr_ = clr

	self:changeClr_()
end

function TextEdit:changeClr_()
	if self.text_ then
		self.label_:setColor(self.textClr_)
	else
		self.label_:setColor(self.textHolderClr_)
	end
end

function TextEdit:getKeyBoardView_()
	local keyBoard = self.keyBoard_ -- self:getChildByTag(KEYBOARD_TAG)
	if not keyBoard then
		self.keyMap_ = {}

		local alphSize = cc.size(60, 60)
		keyBoard = display.newNode()
		keyBoard:setContentSize(cc.size(alphSize.width * 10, alphSize.height * 3))
		self.keyBoard_ = keyBoard -- keyBoard:setTag(KEYBOARD_TAG)

		local boundingBox = self:getBoundingBox()
		keyBoard:align(display.CENTER_TOP, boundingBox.x + boundingBox.width/2, boundingBox.y - 5)

		if self.onKeyboardCreate_ then
			self.onKeyboardCreate_(keyBoard)
		else
			self:addChild(keyBoard)
		end

		local line = 1
		local row = 1
		for i = 1, 26 do
			local alphabetic = display.newScale9Sprite(img_common_alphabeticbg_png)-- display.newNode()
			alphabetic:addTo(keyBoard)
			alphabetic:setContentSize(alphSize)
			alphabetic:setColor(cc.c3b(128, 128, 128))
			


			local character = string.char(string.byte("A") + i - 1)
			local alph = cc.LabelTTF:create(character,"黑体",24)
			alph:align(display.CENTER, alphSize.width/2, alphSize.height/2)
			alph:addTo(alphabetic)

			local function onTouch(event)
				if event.name == "began" then
					self:onAlphabeticDown(character)

					return true
				end

				if event.name == "ended" then
					self:onAlphabeticUp(character)
				end
			end
			
			alphabetic:setTouchEnabled(true)
			alphabetic:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
				return onTouch(event)
			end)

			

		    self.keyMap_[character] = alphabetic

			alphabetic:align(display.LEFT_BOTTOM, alphSize.width * (row - 1), alphSize.height * (3 - line))
			row = row + 1
			if row > 10 then
				line = line + 1
				row = row - 10
			end
		end

		-- add shift button
		local shiftBtn = display.newSprite(img_common_uppersymbol_png)
			:addTo(keyBoard)
			:align(display.LEFT_BOTTOM, alphSize.width * (row - 1), alphSize.height * (3 - line))
		shiftBtn:setScale(2)

		local function onTouch(event)
			if event.name == "began" then
				local posX, posY = shiftBtn:getPosition()
				shiftBtn:setPosition(posX + 2, posY - 2)

				return true
			end

			if event.name == "ended" then
				local posX, posY = shiftBtn:getPosition()
				shiftBtn:setPosition(posX - 2, posY + 2)
				self.lowerAlphabetic_ = not self.lowerAlphabetic_
				local spriteFrame
				if self.lowerAlphabetic_ then
					spriteFrame = cc.SpriteFrame:create(img_common_lowersymbol_png, cc.rect(0, 0, 30, 30));
				else
					spriteFrame = cc.SpriteFrame:create(img_common_uppersymbol_png, cc.rect(0, 0, 30, 30));
				end
				shiftBtn:setSpriteFrame(spriteFrame)

				for k,v in pairs(self.keyMap_) do
					v = v:getChildren()[1]
					local char = v:getString()
					if self.lowerAlphabetic_ then
						char = string.lower(char)
					else
						char = string.upper(char)
					end
					v:setString(char)
				end
			end
		end
		shiftBtn:setTouchEnabled(true)
		shiftBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
			return onTouch(event)
		end)
		

		-----------
		row = row + 1
		local delBtn = display.newSprite(img_common_deletesymbol_png)
			:addTo(keyBoard)
			:align(display.LEFT_BOTTOM, alphSize.width * (row - 1), alphSize.height * (3 - line))
		delBtn:setScale(2)
		local function onTouch(event)
			if event.name == "began" then
				local posX, posY = delBtn:getPosition()
				delBtn:setPosition(posX + 2, posY - 2)
		    	
				return true
			end

			if event.name == "ended" then
				local posX, posY = delBtn:getPosition()
				delBtn:setPosition(posX - 2, posY + 2)

				local str = self:getString()
				if not str then
					return
				end
				local len = string.len(str)
				if 0 == len then
					return
				end
				str = string.sub(str, 1, len - 1)
				self:setString(str)
			end
		end
		delBtn:setTouchEnabled(true)
		delBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
			return onTouch(event)
		end)
		
	end

	return keyBoard
end

function TextEdit:onAlphabeticDown(character)
	local node = self:getCharNode_(character)
	local posX, posY = node:getPosition()
	node:setPosition(posX + 2, posY - 2)
end

function TextEdit:onAlphabeticUp(character)
	local node = self:getCharNode_(character)
	local posX, posY = node:getPosition()
	node:setPosition(posX - 2, posY + 2)

	local label = self:getAlphabeticLabel(character)
	local alphabetic = label:getString()
	if self.text_ then
		self:setString(self.text_ .. label:getString())
	else
		self:setString(label:getString())
	end
end

function TextEdit:getCharNode_(character)
	local key = string.upper(character)
	return self.keyMap_[key]
end

function TextEdit:getAlphabeticLabel(character)
	local node = self:getCharNode_(character)
	return node:getChildren()[1]
end

return TextEdit
