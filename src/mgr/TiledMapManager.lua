--
-- Author: Your Name
-- Date: 2015-09-23 22:20:19
--



local Grid = require("3rd.jumper.grid")
local PF = require("3rd.jumper.pathfinder")


TiledMapManager = class("TiledMapManager")


-- 获取测试grid层
function TiledMapManager:getGridLayer()
    return self.gridLayer_
end

-- /// 给静态物体增加碰撞 /// 注意，用此函数瓦片之外必须没有物体，否则出错
function TiledMapManager:loadStaticLayer(rect)
    assert(rect,"static rect is nil")

    -- local x,y = rect.x,rect.y
    -- local tilePos = self:getTileCoordsFromPosition(cc.p(x,y))
    --self.pathGrid_[tilePos.y][tilePos.x] = 1

    local mapSize = self.map_:getMapSize()
    local tileSize = self.map_:getTileSize()

    for y = 1, mapSize.height do
        for x = 1, mapSize.width do
            local pos = self:getPositionFromTileCoords(cc.p(x,y))
            local gridRect = cc.rect(pos.x,pos.y,
                tileSize.width,tileSize.height)

            if cc.rectIntersectsRect(rect, gridRect) then
                self.pathGrid_[y][x] = 1
            end

        end
    end
    

end

-- 算法
function TiledMapManager:getMapSizePx()

    local mapSize = self.map_:getMapSize()
    local tileSize = self.map_:getTileSize()

    return cc.size(mapSize.width * tileSize.width, 
        mapSize.height * tileSize.height)
end

-- 转换成tiledmap的坐标
function TiledMapManager:getTileCoordsFromPosition(posPx)

    local mapSize = self.map_:getMapSize()
    local tileSize = self.map_:getTileSize()

    return cc.p(math.ceil(posPx.x/tileSize.width), 
        mapSize.height + 1 - math.ceil(posPx.y/tileSize.height))

end

-- 转换成地图的坐标
function TiledMapManager:getPositionFromTileCoords(pos)

    local mapSize = self:getMapSizePx() -- 跟普通获取不一样
    local tileSize = self.map_:getTileSize()

    return cc.p(tileSize.width*pos.x - tileSize.width/2, 
        mapSize.height - tileSize.height*pos.y + tileSize.height/2)
end

-- 寻路系统从tiledmap中获取路径
function TiledMapManager:getPath(startPoint,endPoint )

    local sPos = self:getTileCoordsFromPosition(startPoint)
    local ePos = self:getTileCoordsFromPosition(endPoint)

    local grid = Grid(self.pathGrid_)

    local walkable = function(v) return v~=1 end

    local finder = PF(grid, 'ASTAR',0)
    --finder:annotateGrid()
    --local finderNames = PF:getFinders()

    local sx, sy = sPos.x,sPos.y
    local ex, ey = ePos.x,ePos.y
    
    -- Calculates the path, and its length
    local path = finder:getPath(sx, sy, ex, ey)

    return path
    
end

-- 创建tiledmap视图
function TiledMapManager:createView(parent,fileName)

    self.parent_ = parent

	-- 加载瓦块地图
    self.map_ = cc.TMXTiledMap:create(fileName)
    self.map_:align(display.LEFT_BOTTOM, 0, 0)
    self.map_:addNodeEventListener(cc.NODE_EVENT, function(event)
        -- 地图对象删除时，自动从缓存里卸载地图材质
        if event.name == "exit" then
            display.removeSpriteFrameByImageName(bgIMG)
        end
    end)

    parent:addChild(self.map_)


    return self.map_

end


function TiledMapManager:setMap(pathGrid)

    -- self._ttf =cc.LabelTTF:create("0%","黑体",80)
    -- self._ttf:setPosition(display.cx,display.cy)
    -- self._ttf:setColor(cc.c3b(0,255,0))
    -- parent:addChild(self._ttf,999)
    self:loadPathGrid_()
    self:addGridLayer_()
    --self.pathGrid_ = pathGrid
    
end

-- 增加格子(与debugLayer独立出来)
function TiledMapManager:addGridLayer_()
    local node = cc.DrawNode:create()

    local mapSize = self.map_:getMapSize()
    local tileSize = self.map_:getTileSize()

    local startPoint = cc.p(0, 0)
    local endPoint = cc.p(0, tileSize.height * mapSize.height)

    local lines = mapSize.height
    --print(lines)

    for x=1,mapSize.width do
        startPoint.x = x * tileSize.width
        endPoint.x = startPoint.x
        node:drawLine(startPoint, endPoint, cc.c4f(1, 0, 0, 1))
        for y=1,lines do
            node:drawLine(startPoint, endPoint, cc.c4f(1, 0, 0, 1))
        end
    end

    startPoint.x = 0
    endPoint.x = tileSize.width * mapSize.width
    for y = 1, lines do
        startPoint.y = y * tileSize.height
        endPoint.y = startPoint.y
        node:drawLine(startPoint, endPoint, cc.c4f(1, 0, 0, 1))
    end

    self.map_:addChild(node, 99)

    self.gridLayer_ = node
end


-- 获取地图数据(顺便判断障碍物，设置为1不可穿越)
function TiledMapManager:loadMapLayer_(layerName)
    
    local layer = self.map_:getLayer(layerName)

    if not layer then
        return
    end

    local mapSize = self.map_:getMapSize()
    local tileSize = self.map_:getTileSize()

    for y = 1, mapSize.height do
        for x = 1, mapSize.width do

            -- 如果tile资源不为0，即空，则将其标记为1
            if 0 ~= layer:getTileGIDAt(cc.p(x - 1, y - 1)) then
                
                --print("tile pos (%d,%d)", x, y)
                self.pathGrid_[y][x] = 1

            end

        end
    end

end


-- 初始化一个tiledmap的空二维数组
function TiledMapManager:initPathGrid_()
     
    self.pathGrid_ = {}
    local mapSize = self.map_:getMapSize()
    local tileSize = self.map_:getTileSize()
    local map = {}
    for y = 1, mapSize.height do
        
        map[y] = {}
        for x = 1, mapSize.width do

            map[y][x] = 0

        end
    end

    self.pathGrid_ = clone(map)

end


-- 遍历tiledmap碰撞层
function TiledMapManager:loadPathGrid_()

    self:initPathGrid_()

    -- collision layers
    local layers = {
        
        "sea",
        "green",
    }

    -- 使用协程每一帧加载资源
    local co = coroutine.create(function()
        for i,v in ipairs(layers) do
          
            self:loadMapLayer_(v)

            -- 加载进度
            local percent = math.ceil(i / #layers * 100)
            
            --self._ttf:setString(percent.."%")

            if i == #layers then
                self._scheduler.unscheduleGlobal(self._sc)
                self._sc = nil
                self._scheduler = nil
                -- self._ttf:removeSelf()
                -- self._ttf = nil      
                print("load mapdata done!!!")

                -- 逆转table里面的数据 // 暂时不需要，看坐标转换
                --self.pathGrid_ = utils.reverseTab(self.pathGrid_)
                -- 将阻挡Grid标记为1
                for y,v in pairs(self.pathGrid_) do
                    for x,v in pairs(v) do
                        if v == 1 then
                            local pos = self:getPositionFromTileCoords(cc.p(x,y))
                            utils.createLabel("1",self.map_,pos)
                        end
                    end
                end

            end

            coroutine.yield()
        end
    end)

   
    local frame = cc.Director:getInstance():getAnimationInterval()
    self._scheduler = require("framework.scheduler")

    self._sc = self._scheduler.scheduleGlobal(function()

        coroutine.resume(co)

    end,frame)
    
end


-- 导出地图static瓦块
function TiledMapManager:dump()
    
    local state = clone(self.pathGrid_)
    if not state then
        return
    end
    local lines = {}

    lines[#lines + 1] = "map.pathGrid = {"

    for y,v in pairs(state) do
        lines[#lines + 1] = "{"
        
        for x,v in pairs(v) do
            
            lines[#lines + 1] = string.format("%s,",v)

        end
         lines[#lines + 1] = "},"
    end

    lines[#lines + 1] = "}"
    lines[#lines + 1] = "\n"

    return table.concat(lines)
end



return TiledMapManager