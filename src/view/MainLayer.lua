--
-- Author: Your Name
-- Date: 2015-09-28 19:40:35
--
local MainLayer = class("MainLayer",function()

	return cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
end)


local GAMESCENE_EMOJI_TAG = 101
local GAMESCENE_WORLD_CHAT_TAG = 102

function MainLayer:ctor()

	local guiNode = display.newNode():addTo(self)
	guiNode:setLocalZOrder(100)
	self.guiNode_ = guiNode

	local sp = display.newScale9Sprite(img_1_border_png)
		:align(display.CENTER, display.cx, display.cy)
		:addTo(guiNode)
		:setContentSize(display.width, display.height)

	local bottom = display.newNode():addTo(guiNode)
	local bottomBg = display.newScale9Sprite("#bar-container.png", cc.rect(460, 7, 40, 20))
    	:align(display.CENTER_BOTTOM, display.cx, 0)
    	:addTo(bottom)
    local size = bottomBg:getContentSize()
    bottomBg:setContentSize(cc.size(display.width, size.height))

	local bottom = display.newNode():addTo(guiNode)
	local bottomBg = display.newScale9Sprite("#bar-container.png", cc.rect(460, 7, 40, 20))
    	:align(display.CENTER_BOTTOM, display.cx, 0)
    	:addTo(bottom)
    local size = bottomBg:getContentSize()
    bottomBg:setContentSize(cc.size(display.width, size.height))


	local bloodFg = display.newSprite("#healthbar.png")
	local bloodSize = bloodFg:getContentSize()
	bloodSize.width = bloodSize.width - 12
	bloodSize.height = bloodSize.height - 6
	
    local blood = display.newScale9Sprite(img_common_blood_png):addTo(bottom)
    	:align(display.LEFT_BOTTOM, 3 + 6, 4 + 3)
    blood:setContentSize(bloodSize)
    self.bloodSize_ = bloodSize
    self.blood_ = blood
    bloodFg:align(display.LEFT_BOTTOM, 3, 4):addTo(bottom)

    local btn_count = 0
    local chatBtn = display.newSprite("#chatbtn.png"):addTo(bottom)
    	:align(display.LEFT_BOTTOM, display.right - 120, 4)
	chatBtn:setTouchEnabled(true)
	chatBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()
		btn_count = btn_count + 1
		if btn_count % 2 == 1 then
			self:showEmojiTable()
		else
			self:hideEmojiTable()
		end
		
	end)

    self:showWorldChat()

    --self:showRevive()

    local str = "emoji:9"
    local args = {name = "小明",msg = str}

    -- 匹配模式
    local idx = string.match(args.msg, "emoji:(%d+)")
    --print(args.msg,idx)
    self:addWorlChat(args)



    
end

function MainLayer:showEmojiTable()
	local guiNode = self.guiNode_
	local node
	node = guiNode:getChildByTag(GAMESCENE_EMOJI_TAG)
	if node then
		node:setVisible(true)
	else
		node = display.newNode()
		local width = 5
		local height = 3
		local gridSize = cc.size(34, 34)
		for y=1, height do
			for x=1, width do
				local imgName = "emoji/" .. ((y - 1) * width + x) .. ".jpg"
				local img = display.newSprite(imgName)
				local rect = img:getBoundingBox()
				node:addChild(img)
				img:align(display.LEFT_BOTTOM, gridSize.width * (x - 1), gridSize.height * (y - 1))
				img:setTouchEnabled(true)
				img:setTag(x * y)
				img:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()

					print(img:getTag())
					-- send chat 
					--Game:sendCmd("play.chat", {id = Game:getUser():getId(), name = Game:getUser():getNickName(), msg = "emoji:" .. idx})
					node:setVisible(false)


				end)
			end
		end
		guiNode:addChild(node)
		node:setTag(GAMESCENE_EMOJI_TAG)
		node:setPosition(display.right - gridSize.width * width, 34)
		self._emojiTable = node
		
	end
end
function MainLayer:hideEmojiTable()

	self._emojiTable:setVisible(false)
end



function MainLayer:showWorldChat()
	local guiNode = self.guiNode_
	local bgNode

	bgNode = display.newScale9Sprite(img_common_chatbg_png)
	local bgSize = cc.size(250, 34 * 5 + 20) -- only show last five chat
	bgNode:setContentSize(bgSize)
	bgNode:align(display.LEFT_BOTTOM, 8, 34)
	bgNode:addTo(guiNode)

	local clip = cc.ClippingRectangleNode:create()
	local space = 20
	bgSize.width = bgSize.width - space * 2
	bgSize.height = bgSize.height - space
	clip:setClippingRegion(bgSize)
	clip:align(display.LEFT_BOTTOM, 8 + space, 34)
	clip:addTo(guiNode)
	clip:setTag(GAMESCENE_WORLD_CHAT_TAG)
end



function MainLayer:showRevive()

	local bg = display.newSprite("#parchment.png")
	bg:setTag(201)
	bg:align(display.CENTER, display.cx, display.cy)
	bg:setScaleX(0.1)
	bg:setLocalZOrder(101)
	bg:addTo(self)

	local function gameover()
		local bounding = bg:getBoundingBox()
		local label = cc.LabelTTF:create("You Are Dead!", "黑体",24)
		label:align(display.CENTER, bounding.width/2, bounding.height/2 + 10)
		label:setColor(cc.c4b(0, 0, 0, 250))
		label:addTo(bg)

		local button = display.newSprite("#buttonRevive.png"):addTo(bg)
		:align(display.CENTER, bounding.width/2, bounding.height/2 - 30)
		button:setTouchEnabled(true)
		button:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()

			print("哈哈")

		end)
	end
	
	local call1 = cc.CallFunc:create(function()
		bg:scaleTo(1, 1)
	end)
	local call2 = cc.CallFunc:create(function()
		gameover(1, 1)
	end)
	local delay = cc.DelayTime:create(1)
	bg:runAction(cc.Sequence:create(call1,delay,call2))
	
end


function MainLayer:addWorlChat(args)
	local guiNode = self.guiNode_
	local node = guiNode:getChildByTag(GAMESCENE_WORLD_CHAT_TAG)

	local lineNode = display.newNode()
	local account
	if args.name then
		account = args.name .. ": "
	else
		account = "[anonymous]: "
	end
	local name = cc.LabelTTF:create(account,"黑体",36)
		:align(display.LEFT_BOTTOM, 0, 0)
		:addTo(lineNode)
	local nameSize = name:getContentSize()

	local idx = string.match(args.msg, "emoji:(%d+)")
	if idx then
		local msg = display.newSprite("emoji/" .. idx .. ".jpg")
		:align(display.LEFT_BOTTOM, nameSize.width, 0)
		:addTo(lineNode)
	end
	
	node:removeChildByTag(5)
	for i=5, 1, -1 do
		local child = node:getChildByTag(i)
		if child then
			local posX, posY = child:getPosition()
			child:setPositionY(posY + 34)
			child:setTag(i + 1)
		end
	end
	lineNode:setTag(1)
	lineNode:addTo(node)
end



return MainLayer