--
-- Author: Your Name
-- Date: 2015-09-28 01:55:01
--

LoginScene = class("LoginScene",function()

	return display.newScene()
end)



function LoginScene:ctor()

	-- add background image
    local bg = cc.Sprite:create(img_1_wood_png, cc.size(display.width, display.height))
    bg:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
    bg:align(display.CENTER, display.cx, display.cy):addTo(self)

	 -- logo
    local logo = display.newSprite("#logo.png")
    	:align(display.CENTER, display.cx, display.height - 100)
    	:addTo(self)

    -- bg
    local parchment = display.newSprite("#parchment.png")
    	:align(display.CENTER, display.cx, display.cy)
    	:addTo(self)

    -- str
    local parchmentSize = parchment:getContentSize()
    local str = cc.LabelTTF:create("A Massively Multiplayer Adventure", "黑体",12)
    str:setColor(cc.c4b(0, 0, 0, 255))
    str:align(display.CENTER, parchmentSize.width/2, parchmentSize.height - 30)
    	:addTo(parchment)
    local strSize = str:getContentSize()

    local leftsp = display.newSprite("#left-ornament.png")
    	:align(display.RIGHT_CENTER, parchmentSize.width/2 - strSize.width/2 - 10, parchmentSize.height - 30)
    	:addTo(parchment)
    local rightsp = display.newSprite("#right-ornament.png")
    	:align(display.LEFT_CENTER, parchmentSize.width/2 + strSize.width/2 + 10, parchmentSize.height - 30)
    	:addTo(parchment)

    -- 小人
    local rolesp = display.newSprite("#character.png")
    	:align(display.CENTER, parchmentSize.width/2, parchmentSize.height - 50)
    	:addTo(parchment)

    -- 名字背景
    local nameBgSize = cc.size(200, 30)
    local nameBg = cc.LayerColor:create(cc.c4b(0, 0, 0, 60))
    nameBg:setContentSize(nameBgSize)
    nameBg:align(display.CENTER, 120, parchmentSize.height - 100)
    nameBg:addTo(parchment)

    -- 虚拟键盘
    local textfield = require("view.TextEdit").new(
    	{placeHolder = "Name your character",size = nameBgSize})
        :align(display.CENTER, nameBgSize.width/2, nameBgSize.height/2)
        :addTo(nameBg)
    textfield:onKeyBoardCreate(function(keyBoard)
        self:addChild(keyBoard, 2)
        local boundingBox = textfield:getBoundingBox()
        local pos = textfield:convertToWorldSpace(cc.p(boundingBox.x, boundingBox.y))
        pos = self:convertToNodeSpace(pos)
        keyBoard:align(display.CENTER_TOP, pos.x + boundingBox.width/2, pos.y - 5)
        boundingBox = keyBoard:getBoundingBox()
    end)


    local btn = utils.newButton("#button.png", function()
    	print("点击")
    end, setAlpha)
    btn:setPosition(parchmentSize.width/2, parchmentSize.height - 135)
    parchment:addChild(btn)
        

end


return LoginScene