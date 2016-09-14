

local EditorConstants = require("editor.EditorConstants")

local FileListView = class("FileListView")

FileListView.EditButtonSize        = 16

FileListView.POSITION_LEFT_TOP     = "LEFT_TOP"
FileListView.POSITION_RIGHT_TOP    = "RIGHT_TOP"
FileListView.POSITION_LEFT_BOTTOM  = "LEFT_BOTTOM"
FileListView.POSITION_RIGHT_BOTTOM = "RIGHT_BOTTOM"

FileListView.ALL_POSITIONS = {
    FileListView.POSITION_LEFT_TOP,
    FileListView.POSITION_RIGHT_TOP,
    FileListView.POSITION_RIGHT_BOTTOM,
    FileListView.POSITION_LEFT_BOTTOM,
}

function FileListView:ctor(map, scale, toolbarLines)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()


    self.map_            = map
    self.sprite_         = nil
    self.bg_             = nil
    self.size_           = {0, 0}
    self.position_       = FileListView.POSITION_RIGHT_BOTTOM
    self.behaviorsLabel_ = {}
    self.isVisible_      = true
    self.scale_          = scale or 1
    self.toolbarLines_   = toolbarLines or 1

    if device.platform == "ios" or device.platform == "android" then
        self.position_ = FileListView.POSITION_RIGHT_TOP
    end
end


function FileListView:getView()
    return self.sprite_
end

function FileListView:createView(parent)

	-- bg
    local layer = display.newNode()
    local bg = display.newSprite("#EditorPanelBg.png")
    local size = bg:getContentSize()
    bg:align(display.LEFT_TOP, 0, 0)
    bg:getTexture():setAliasTexParameters()
    layer:addChild(bg)
    layer:setVisible(false)
    layer:setScale(self.scale_)
    parent:addChild(layer)

    -- 关闭按钮
    local closeButton = display.newSprite("#EditorPanelCloseButton.png")
    local offset = EditorConstants.PANEL_BUTTON_SIZE / 2 + EditorConstants.PANEL_BUTTON_OFFSET
    closeButton:setPosition(offset, -offset)
    layer:addChild(closeButton)
    closeButton:setTouchEnabled(true)
    closeButton:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()
    	self:removeObject()
    end)

    self.positionButton_ = display.newSprite("#EditorPanelPositionButton.png")
    self.positionButton_:setPosition(0, -offset)
    layer:addChild(self.positionButton_)

    if device.platform == "ios" or device.platform == "android" then
        self.positionButton_:setVisible(false)
    end

    self.bg_ = bg
    self.sprite_ = layer
    return layer
end

function FileListView:removeView()
    if self.sprite_ then
        self.sprite_:removeSelf()
        self.sprite_ = nil
    end
end

function FileListView:setPosition()
    local width, height = unpack(self.size_)

    local size = self.bg_:getContentSize()
    self.bg_:setScaleX(width / size.width)
    self.bg_:setScaleY(height / size.height)

    width = width * self.scale_
    height = height * self.scale_

    local offset = EditorConstants.PANEL_OFFSET * self.scale_

    if self.position_ == FileListView.POSITION_LEFT_TOP then
        self.sprite_:align(display.LEFT_TOP,
                           display.c_left + offset,
                           display.c_top - offset)
    elseif self.position_ == FileListView.POSITION_RIGHT_TOP then
        self.sprite_:align(display.LEFT_TOP,
                           display.c_right - width - offset,
                           display.c_top - offset)
    elseif self.position_ == FileListView.POSITION_LEFT_BOTTOM then
        local y = display.c_bottom + height + offset
        if self.scale_ == 1 then
            y = y + EditorConstants.MAP_TOOLBAR_HEIGHT * self.toolbarLines_
        end
        self.sprite_:align(display.LEFT_TOP, display.c_left + offset, y)
    else
        local y = display.c_bottom + height + offset
        if self.scale_ == 1 then
            y = y + EditorConstants.MAP_TOOLBAR_HEIGHT * self.toolbarLines_
        end
        self.sprite_:align(display.LEFT_TOP, display.c_right - width - offset, y)
    end

    local offset = EditorConstants.PANEL_BUTTON_SIZE / 2 + EditorConstants.PANEL_BUTTON_OFFSET
    self.positionButton_:setPositionX(width / self.scale_ - offset)
end

-- 属性展示label
function FileListView:setObject()
  
    if self.panel_ then self:removeObject() end
    local panel = display.newNode()
    self.sprite_:addChild(panel)
    self.panel_ = panel

    -- 添加Map列表选项
    local path = PathManager:getMapsPath()
    local fileName = IOManager:searchLuaFile( path )
    local mapName = MapManager:getMapName()

    local maxWidth = 0
    local labelX = 26
    local labelY = -50

    table.sort(fileName)

    for i, pair in ipairs(fileName) do

        local text   = string.format("%s", tostring(pair))
        if mapName == unpack(string.split(text,"."))then
            text   = string.format("%s    %s", tostring(pair),"<==")
        end

        local label  = cc.ui.UILabel.new({
            text  = text,
            font  = EditorConstants.PANEL_LABEL_FONT,
            size  = EditorConstants.PANEL_LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_LEFT,
            x     = labelX,
            y     = labelY,
        }):align(display.CENTER_LEFT)
        panel:addChild(label)
        label:setTouchEnabled(true)
        -- 添加监听事件
        label:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()

        	local file = label:getString()
        	local mapName = unpack(string.split(file, "."))
        	self:dispatchEvent({name = "SELECT_FILE", mapName = mapName})
        end)

        labelY = labelY - EditorConstants.PANEL_LABEL_FONT_SIZE - 3
        local size = label:getContentSize()
        if size.width > maxWidth then
            maxWidth = size.width
        end
       
    end

    local panelWidth  = maxWidth + 30
    if panelWidth < EditorConstants.INSPECTOR_WIDTH then
        panelWidth = EditorConstants.INSPECTOR_WIDTH
    end
   
    -- 添加Events选项
    local path = PathManager:getEventsPath()
    local fileName = IOManager:searchLuaFile( path )
    local curEventName = MapManager:getEventName()

    local column = 0
    local selectBtn = {}
    local numCols = math.floor(panelWidth / EditorConstants.BEHAVIOR_LABEL_WIDTH)
    local numRows = math.ceil(#fileName / numCols)
    local panelHeight = -labelY + 54 + (numRows - 1) * 26

    for i, pair in ipairs(fileName) do

        local sprite = display.newSprite("#BehaviorLabelBackground.png")
        local size = sprite:getContentSize()
        panel:addChild(sprite)

        local text   = string.format("%s", tostring(pair))
        local eventName = unpack(string.split(text,"."))

        selectBtn[eventName] = display.newSprite("#BehaviorLabelSelected.png")
        selectBtn[eventName]:align(display.LEFT_BOTTOM, 0, 0)
        sprite:addChild(selectBtn[eventName])

        -- 判断是否显示
        --print(curEventName,text)
        local isVisible = curEventName == eventName
        selectBtn[eventName]:setVisible(isVisible)

        local label  = cc.ui.UILabel.new({
            text  = eventName,
            font  = EditorConstants.PANEL_LABEL_FONT,
            size  = EditorConstants.PANEL_LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_LEFT,
            x     = 10,
            y     = 12,
        }):align(display.CENTER_LEFT)
        sprite:addChild(label)

        sprite:setTouchEnabled(true)
        -- 添加监听事件
        sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()
           
            local eventName = label:getString() 
            for k,v in pairs(selectBtn) do
                if tostring(k) == eventName then
                    v:setVisible(true)
                    self:dispatchEvent({name = "SELECT_FILE", eventName = eventName})
                else
                    v:setVisible(false)
                end
            end

        end)
        local label = {
            x        = labelX + EditorConstants.BEHAVIOR_LABEL_WIDTH * column,
            y        = labelY,
            width    = size.width,
            height   = size.height,
            isLocked = false,
        }
        sprite:align(display.LEFT_TOP, label.x, label.y)

        column = column + 1
        if column == numCols then
            column = 0
            labelY = labelY - 26
        end

    end

    -- 添加图片选项
    labelY = labelY - 52
    local path = PathManager:getImgPath()
    local fileName = IOManager:searchImgFile( path )
    local imgName = MapManager:getImgName()
    --local res,imgName = unpack(string.split(MapManager:getImgName(), "/"))

    table.sort(fileName)
    for i, pair in ipairs(fileName) do

        local text   = string.format("%s", tostring(pair))
        if imgName == text then
            text   = string.format("%s    %s", tostring(pair),"<==")
        end

        local label  = cc.ui.UILabel.new({
            text  = text,
            font  = EditorConstants.PANEL_LABEL_FONT,
            size  = EditorConstants.PANEL_LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_LEFT,
            x     = labelX,
            y     = labelY,
        }):align(display.CENTER_LEFT)
        panel:addChild(label)
        label:setTouchEnabled(true)
        -- 添加监听事件
        label:addNodeEventListener(cc.NODE_TOUCH_EVENT,function()

            local imgName = pair
            self:dispatchEvent({name = "SELECT_FILE", imgName = imgName})
        end)

        labelY = labelY - EditorConstants.PANEL_LABEL_FONT_SIZE - 3
        local size = label:getContentSize()
        if size.width > maxWidth then
            maxWidth = size.width
        end

    end

    --print(imglabelY)
    panelHeight = -labelY + (#fileName - 1) + 20
    self.size_ = {panelWidth, panelHeight}
    self:setPosition()
    self.sprite_:setVisible(self.isVisible_)

end

function FileListView:removeObject()
    if self.panel_ then
        self.sprite_:setVisible(false)
        self.panel_:removeSelf()
        self.panel_ = nil
        self.isVisible_ = true
    end
end

return FileListView
