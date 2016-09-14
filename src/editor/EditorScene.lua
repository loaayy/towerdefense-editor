

local scheduler = require("framework.scheduler")
local EditorConstants = require("editor.EditorConstants")
local Map = require("app.map.Map")

local EditorScene = class("EditorScene", function()
    return display.newPhysicsScene("EditorScene")
end)


local DEBUGDRAW_ALL   = 0
local GRAVITY         = 0
local WALL_THICKNESS  = 64
local WALL_FRICTION   = 1.0
local WALL_ELASTICITY = 0.5


function EditorScene:ctor()

 
    -- create physics world
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, GRAVITY))
    if DEBUGDRAW_ALL == 1 then
        self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    end
    self:setPhysicsWorldListener()

    local wallBox = display.newNode()
    wallBox:setAnchorPoint(cc.p(0.5, 0.5))
    wallBox:setPhysicsBody(
        cc.PhysicsBody:createEdgeBox(cc.size(display.width, display.height - WALL_THICKNESS)))
    wallBox:setPosition(display.cx, display.height/2 + WALL_THICKNESS/2)
    self:addChild(wallBox)

    -- 根据设备类型确定工具栏的缩放比例
    self.toolbarLines = 2
    self.editorUIScale = 1
    self._statusCount = 1
    if (device.platform == "ios" and device.model == "iphone") or device.platform == "android" then
        self.editorUIScale = 2
        self.toolbarLines = 2
    end

    local bg = display.newTilesSprite("EditorBg.png")
    self:addChild(bg)

    -- mapLayer 包含地图的整个视图
    self._mapLayer = display.newNode()
    self._mapLayer:align(display.LEFT_BOTTOM, 0, 0)
    self:addChild(self._mapLayer)

    -- touchLayer 用于接收触摸事件
    self._touchLayer = display.newLayer()
    self._touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)


        return self:onTouch(event.name, event.x, event.y)
    end)
    self._touchLayer:setTouchEnabled(true)
    self:addChild(self._touchLayer)


    -- uiLayer 用于显示编辑器的 UI（工具栏等）
    self._uiLayer = display.newNode()
    self._uiLayer:setPosition(display.cx, display.cy)
    self:addChild(self._uiLayer)

    -- 创建地图对象
    local mapName = MapManager:getMapName()
    print("current map name:",mapName)
    self._map = Map.new(mapName, true) -- 参数：地图ID, 是否是编辑器模式
    self._map:init()
    self._map:createView(self._mapLayer)
    -- 将当前地图信息传递给管理者
    MapManager:setMap(self._map)

    -- 创建工具栏
    self:createToolbar()

    -- 切换模式
    cc.ui.UIPushButton.new({normal = "#ToggleDebugButton.png", pressed = "#ToggleDebugButtonSelected.png"})
        :onButtonClicked(function(event)
            self._map:setDebugViewEnabled(not self._map:isDebugViewEnabled())
        end)
        :align(display.CENTER, display.left + 32 * self.editorUIScale, display.top - 32 * self.editorUIScale)
        :addTo(self._playToolbar)
        :setScale(self.editorUIScale)

    cc.ui.UIPushButton.new({normal = "#StopMapButton.png", pressed = "#StopMapButtonSelected.png"})
        :onButtonClicked(function(event)
            self:editMap()
        end)
        :align(display.CENTER, display.left + 88 * self.editorUIScale, display.top - 32 * self.editorUIScale)
        :addTo(self._playToolbar)
        :setScale(self.editorUIScale)


    -- 创建测试场景
    utils.delayExecute(self,function()
        --local mainlayer = require("view.MainLayer").new():addTo(self)
        --local mainlayer = require("view.MistLayer").new():addTo(self)
    end,0.5)
         

end

-- 注册物理碰撞监听事件
function EditorScene:setPhysicsWorldListener()

    local onContactBegin = function (contact)
        local bodyA = contact:getShapeA():getBody():getNode()
        local bodyB = contact:getShapeB():getBody():getNode()
        local tagA = bodyA:getTag()
        local tagB = bodyB:getTag()
        --print("A:"..tagA)
        --print("B:"..tagB)
        if (tagB == 1 and tagA == 2) or (tagB == 2 and tagA == 1) then
            --print("撞击！")            
            --self._map:updateView()
            local x,y
            if tagB == 1 then
                x,y = bodyB:getPosition()
                bodyB.updateView(x,y)

            elseif tagA == 1 then
                x,y = bodyA:getPosition()
                bodyA.updateView(x,y)
                
            end
            --print(x,y)
        end
        return true
    end 

    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local dispather = cc.Director:getInstance():getEventDispatcher()
    dispather:addEventListenerWithFixedPriority(contactListener, 1)
end

-- 创建工具栏
function EditorScene:createToolbar()
    
    self._toolbar = require("editor.Toolbar").new(self._map)
    self._toolbar:addTool(require("editor.GeneralTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.ObjectTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.PathTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.RangeTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.ScaleTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.NormalTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.SelectMapTool").new(self._toolbar, self._map))
    self._toolbar:addTool(require("editor.DumpTool").new(self._toolbar, self._map))


    -- 创建工具栏的视图
    self._toolbarView = self._toolbar:createView(self._uiLayer, "#ToolbarBg.png", EditorConstants.TOOLBAR_PADDING, self.editorUIScale, self.toolbarLines)
    self._toolbarView:setPosition(display.c_left, display.c_bottom)
    self._toolbar:setDefaultTouchTool("GeneralTool")
    self._toolbar:selectButton("GeneralTool", 1)


    -- 初始化工具视窗
    self:initToolbarView()

    -- 初始化文件控制视窗
    self:initFileControlView()

    -- 创建运行地图时的工具栏
    self._playToolbar = display.newNode()
    self._playToolbar:setVisible(false)
    self:addChild(self._playToolbar)
end

-- 创建对象信息面板
function EditorScene:initToolbarView()
    
    self._objectInspector = require("editor.ObjectInspector").new(self._map)
    self._objectInspector:addEventListener("UPDATE_OBJECT", function(event)
        self._toolbar:dispatchEvent(event)
        print("UPDATE_OBJECT")
    end)
    self._objectInspector:createView(self._uiLayer)


     self._toolbar:addEventListener("SELECT_OBJECT", function(event)

        print('SELECT_OBJECT')
        self._objectInspector:setObject(event.object)
        self._fileListView:removeObject()
        
    end)
    self._toolbar:addEventListener("UPDATE_OBJECT", function(event)
        print('UPDATE_OBJECT')
        self._objectInspector:setObject(event.object)
        self._fileListView:removeObject()
        
    end)
    self._toolbar:addEventListener("UNSELECT_OBJECT", function(event)
        print('UNSELECT_OBJECT')
        self._objectInspector:removeObject()
        
    end)
    self._toolbar:addEventListener("PLAY_MAP", function()

        self:playMap()
        self._fileListView:removeObject()
        self._objectInspector:removeObject()
        --self:playMapStatus()
        
    end)
    self._toolbar:addEventListener("SELECT_PATH", function(event)

         print(event.object:getId())
        
        self._objectInspector:setObject(event.object)

        
    end)
   
    self._toolbar:addEventListener("SELECT_MAP", function(event)
        
        self._objectInspector:removeObject()
        self._fileListView:setObject()

      
    end)


end

function EditorScene:initFileControlView()

    -- 创建文件滚动层
    self._fileListView = require("editor.FileListView").new(self._map)
    self._fileListView:addEventListener("SELECT_FILE", function(event)

        if event.mapName ~= nil then
            MapManager:setMapName(event.mapName)    
            display.replaceScene(require("editor.EditorScene").new())
        end

        if event.eventName ~= nil then
            MapManager:setEventName(event.eventName)
            MapManager:dumpToFile()
        end

        if event.imgName ~= nil then

            -- 更新方案
            MapManager:setImgName(event.imgName)
            MapManager:dumpToFile()
            ReloadManager:reload(MapManager:getMapName())    
            display.replaceScene(require("editor.EditorScene").new())
        end
       
    end)
    self._fileListView:createView(self._uiLayer)


end

function EditorScene:playMapStatus()

    self._mapLayer:setPositionY(60)
    -- self._mapRuntime:setPositionY(60)
    self._mapRuntime:startPlay()

    self:disabelResult()
    self:disableStatus()

    self:showStatusCurve()
    self:statusTimerBegin()

end

-- 开始运行地图
function EditorScene:playMap()
    -- cc.Director:getInstance():setDisplayStats(true)

    -- 隐藏编辑器界面
    self._toolbar:getView():setVisible(false)
    self._playToolbar:setVisible(true)

    self._map:setDebugViewEnabled(false)
    self._map:getBackgroundLayer():setVisible(true)
    self._map:getBackgroundLayer():setOpacity(255)

    local camera = self._map:getCamera()
    camera:setMargin(0, 0, 0, 0)
    camera:setOffset(0, 0)

    -- 强制垃圾回收
    collectgarbage()
    collectgarbage()

    -- 开始执行地图
    self._mapRuntime = require("app.map.MapRuntime").new(self._map)
    self._mapRuntime:preparePlay()
    if (device.platform == "mac" or device.platform == "windows") then
        self._mapRuntime:startPlay()
    end
    self:addChild(self._mapRuntime)
end

-- 开始编辑地图
function EditorScene:editMap()
 
    display.replaceScene(require("editor.EditorScene").new())


    -- 强制垃圾回收
    collectgarbage()
    collectgarbage()
end

function EditorScene:tick(dt)
    if self._mapRuntime then
        self._mapRuntime:tick(dt)
    end
end

function EditorScene:onTouch(event, x, y)
    if self._mapRuntime then
        -- 如果正在运行地图，将触摸事件传递到地图
        
        if self._mapRuntime:onTouch(event, x, y, map) == true then
            return true
        end
        

        if event == "began" then
            self.drag = {
                startX  = x,
                startY  = y,
                lastX   = x,
                lastY   = y,
                offsetX = 0,
                offsetY = 0,
            }
            return true
        end

        if event == "moved" then
            if self.drag == nil then
                return
            end
            self.drag.offsetX = x - self.drag.lastX
            self.drag.offsetY = y - self.drag.lastY
            self.drag.lastX = x
            self.drag.lastY = y
            self._map:getCamera():moveOffset(self.drag.offsetX, self.drag.offsetY)
            
        else -- "ended" or CCTOUCHCANCELLED
            
            self.drag = nil
        end

        return
    end

    -- 如果没有运行地图，则将事件传递到工具栏
    x, y = math.round(x), math.round(y)
    if event == "began" then
        if self._objectInspector:getView():isVisible() and self._objectInspector:checkPointIn(x, y) then
            return self._objectInspector:onTouch(event, x, y)
        end

        --print(x,y)
    end

    return self._toolbar:onTouch(event, x, y)
end

function EditorScene:onEnter()
   
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    self:scheduleUpdate()
end

function EditorScene:onExit()
    if self._mapRuntime then
        self._mapRuntime:stopPlay()
    end

    self._fileListView:removeAllEventListeners()
    self._objectInspector:removeAllEventListeners()
    self._toolbar:removeAllEventListeners()

end

-- 显示性能指标
function EditorScene:showStatusCurve()
    if not self.bgStatus_ then
        self.bgStatus_ = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
        self.bgStatus_:setContentSize(display.width, 60)
        self.bgStatus_:setTouchEnabled(false)
        self:addChild(self.bgStatus_)
    end
    self.bgStatus_:setVisible(true)

    self.fpsArray_ = {}
    self.fps_ = self.fps_ or {}
    if 0 == #self.fps_ then
        table.insert(self.fps_, cc.p(0, 0))
    end

    if not self.statusDraw_ then
        if utils.useNVGDrawNode then
            self.statusDraw_ = cc.NVGDrawNode:create():addTo(self.bgStatus_)
            self.statusDraw_:drawPolygon(self.fps_, #self.fps_, false, cc.c4f(1, 0, 0, 1))
        else
            self.statusDraw_ = display.newDrawNode():addTo(self.bgStatus_)
        end
    end
    self.statusDraw_:setVisible(true)

    self.objectsCount_ = self.objectsCount_ or {}
    if 0 == #self.objectsCount_ then
        table.insert(self.objectsCount_, cc.p(0, 0))
    end

    if not self.objectsDraw_ then
        if utils.useNVGDrawNode then
            self.objectsDraw_ = cc.NVGDrawNode:create():addTo(self.bgStatus_)
            self.objectsDraw_:drawPolygon(self.objectsCount_, #self.objectsCount_, false, cc.c4f(0, 0, 1, 1))
        else
            self.objectsDraw_ = display.newDrawNode():addTo(self.bgStatus_)
        end
    end
    self.objectsDraw_:setVisible(true)

    if not self.statusLabel_ then
        self.statusLabel_ = cc.ui.UILabel.new({text = " ", size = 10, color = display.COLOR_BLACK})
        :align(display.CENTER_RIGHT, display.right - 10, 10)
        :addTo(self)
    end

    self.statusLabel_:setVisible(true)

    -- self.recordBtn_:setButtonLabel(cc.ui.UILabel.new({text = "统计中", size = 20, color = display.COLOR_BLACK}))
end

-- 隐藏性能指标
function EditorScene:disableStatus()
    self.fps_ = nil
    self.objectsCount_ = nil
    self._statusCount = 1
    if self.bgStatus_ then
        self.bgStatus_:setVisible(false)
    end
    if self.statusDraw_ then
        self.statusDraw_:removeFromParent()
        self.statusDraw_ = nil
    end
    if self.objectsDraw_ then
        self.objectsDraw_:removeFromParent()
        self.objectsDraw_ = nil
    end
end


function EditorScene:addFPS()
    self._statusCount = self._statusCount + 1
    local deltaTime = cc.Director:getInstance():getDeltaTime()
    local fps = 1/deltaTime

    table.insert(self.fpsArray_, fps)

    -- print(string.format("deltaTime:%f, fps:%d", deltaTime, fps))

    local pos = cc.p(display.left + display.width/60 * self._statusCount, fps)
    table.insert(self.fps_, pos)
    if utils.useNVGDrawNode then
        self.statusDraw_:addPoint(pos)
    else
        -- print("drawnode:" .. tostring(self.statusDraw_))
        self.statusDraw_:drawSegment(
            self.fps_[#self.fps_ - 1],
            self.fps_[#self.fps_],
            0.5, cc.c4f(1, 0, 0, 1))
    end

    local count = table.nums(self._map.objects_)
    pos = cc.p(display.left + display.width/60 * self._statusCount, count)
    table.insert(self.objectsCount_, pos)

    if utils.useNVGDrawNode then
        self.objectsDraw_:addPoint(pos)
    else
        self.objectsDraw_:drawSegment(
            self.objectsCount_[#self.objectsCount_ - 1],
            self.objectsCount_[#self.objectsCount_],
            0.5, cc.c4f(0, 0, 1, 1))
    end

    self.statusLabel_:setString(string.format("Object:%d,FPS:%d", count, fps))

    if self._statusCount > 60 then
        self:statusTimerEnd()
    end
end

function EditorScene:statusTimerBegin()
    print('statusTimerBegin')
    self.statusTimer_ = scheduler.scheduleGlobal(handler(self, self.addFPS), 1)
end

function EditorScene:statusTimerEnd()
    if not self.statusTimer_ then
        return
    end

    scheduler.unscheduleGlobal(self.statusTimer_)
    self.statusTimer_ = nil

    self:showResult()
end

--显示统计结果
function EditorScene:showResult()
    self._mapRuntime:pausePlay()
    -- self.recordBtn_:setButtonLabel(cc.ui.UILabel.new({text = "统计运行状态", size = 20, color = display.COLOR_BLACK}))

    local dialogSize = cc.size(display.width/2, display.height/2)
    local bg = cc.LayerColor:create(cc.c4b(128, 128, 128, 200))
                :pos((display.width - dialogSize.width)/2, (display.height - dialogSize.height)/2)
                :addTo(self)
    bg:setContentSize(dialogSize.width, dialogSize.height)

    local totoalScore = 0
    local minScore = 60
    local maxScore = 0

    table.walk(self.fpsArray_, function(v, k)
            if v < minScore then
                minScore = v
            end
            if v > maxScore then
                maxScore = v
            end
            totoalScore = totoalScore + v
        end)

    cc.ui.UILabel.new({text = "Score:", size = 24, color = display.COLOR_BLACK})
        :align(display.CENTER_RIGHT, dialogSize.width/2 - 10, dialogSize.height - 40)
        :addTo(bg)
    cc.ui.UILabel.new({text = string.format("%d", totoalScore), size = 24, color = display.COLOR_RED})
        :align(display.CENTER_LEFT, dialogSize.width/2 + 10, dialogSize.height - 40)
        :addTo(bg)

    cc.ui.UILabel.new({text = "Min FPS:", size = 24, color = display.COLOR_BLACK})
        :align(display.CENTER_RIGHT, dialogSize.width/2 - 10, dialogSize.height - 100)
        :addTo(bg)
    cc.ui.UILabel.new({text = string.format("%d", minScore), size = 24, color = display.COLOR_RED})
        :align(display.CENTER_LEFT, dialogSize.width/2 + 10, dialogSize.height - 100)
        :addTo(bg)

    cc.ui.UILabel.new({text = "Max FPS:", size = 24, color = display.COLOR_BLACK})
        :align(display.CENTER_RIGHT, dialogSize.width/2 - 10, dialogSize.height - 160)
        :addTo(bg)
    cc.ui.UILabel.new({text = string.format("%d", maxScore), size = 24, color = display.COLOR_RED})
        :align(display.CENTER_LEFT, dialogSize.width/2 + 10, dialogSize.height - 160)
        :addTo(bg)

    cc.ui.UILabel.new({text = "Average FPS:", size = 24, color = display.COLOR_BLACK})
        :align(display.CENTER_RIGHT, dialogSize.width/2 - 10, dialogSize.height - 220)
        :addTo(bg)
    cc.ui.UILabel.new({text = string.format("%d", totoalScore/#self.fpsArray_), size = 24, color = display.COLOR_RED})
        :align(display.CENTER_LEFT, dialogSize.width/2 + 10, dialogSize.height - 220)
        :addTo(bg)

    cc.ui.UIPushButton.new("GreenButton.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "结束", size = 20, color = display.COLOR_BLACK}))
        :setButtonSize(130, 40)
        :align(display.CENTER, dialogSize.width/2, dialogSize.height - 280)
        :addTo(bg)
        :onButtonClicked(function()
            cc.Director:getInstance():endToLua()
            os.exit()
        end)

    self._resultDialog = bg
end

function EditorScene:disabelResult()
    if self._resultDialog then
        self._resultDialog:removeFromParent()
        self._resultDialog = nil
    end
end

return EditorScene
