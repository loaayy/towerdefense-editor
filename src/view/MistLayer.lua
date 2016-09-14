--
-- Author: Your Name
-- Date: 2015-10-01 00:35:18
--

local MistLayer = class("MistLayer", function()
    return display.newNode()
end)

function MistLayer:ctor()
    self:InitTiledMap()
end

function MistLayer:InitTiledMap()
    self._map = cc.TMXTiledMap:create("cloudMap.tmx")


    --初始化瓦片顶点值集合
    --[[
    {
        [瓦片的一维坐标] = { 左上角, 右上角, 左下角, 右下角 },
        ...
    }
    ]]
    --瓦片的一维坐标 = tiled.x * cloudSize.width + tiled.y
    g_tiledValueSet = {}
    LEFT_UP_CORNER = 1
    RIGHT_UP_CORNER = 2
    LEFT_DOWN_CORNER = 3
    RIGHT_DOWN_CORNER = 4
    TIELD_VALUE_NUM = 4

    --初始化瓦片的图素集合
    --[[
    瓦片地图的数值：
    0 4 8 12
    1 5 9 13
    2 6 10 14
    3 7 11 15
    瓦片图素序号：
    1 2 3 4
    5 6 7 8
    9 10 11 12
    13 14 15 16
    ]]
    g_gidsArray = { 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16 }

    --绑定触摸事件
    self._map:setTouchEnabled(true)
    self._map:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            --1、取得点击的瓦片坐标
            local tiled = self:getTiledPoint(event)
            --2、修改相关瓦片的顶点值并调整图素
            self:changeTiledCornerValue(tiled)
            return true
        elseif event.name == "moved" then
            local tiled = self:getTiledPoint(event)
            --2、修改相关瓦片的顶点值并调整图素
            self:changeTiledCornerValue(tiled)
            return true
        elseif event.name == "ended" then
            return true
        end
    end)
    self:addChild(self._map, 1)
end

function MistLayer:applyChangeImage(cornerTable, x, y, tiledLayer)
    local sum = 0
    for i = 1, TIELD_VALUE_NUM do
        sum = sum + cornerTable[i]
    end
    print(g_gidsArray[sum + 1], x, y)
    tiledLayer:setTileGID(g_gidsArray[sum + 1], cc.p(x, y))
    
end

function MistLayer:changeTiledCornerValue(tiled)
    local tiledLayer = self._map:getLayer("layer1")
    local cloudSize = self._map:getMapSize()
    local curTiledIndex = tiled.x * cloudSize.width + tiled.y
    local curTiledCell = g_tiledValueSet[curTiledIndex] or { 0, 0, 0, 0 }

    --1、修改当前瓦片的右下角的顶点值为4
    curTiledCell[RIGHT_DOWN_CORNER] = 4
    g_tiledValueSet[curTiledIndex] = curTiledCell
    self:applyChangeImage(curTiledCell, tiled.x, tiled.y, tiledLayer)

    --2、修改当前瓦片右侧瓦片的左下角顶点值为8
    if tiled.x + 1 < 10 then
        local rightIndex = (tiled.x + 1) * cloudSize.width + tiled.y
        local tiledCell = g_tiledValueSet[rightIndex] or { 0, 0, 0, 0 }
        tiledCell[LEFT_DOWN_CORNER] = 8
        g_tiledValueSet[rightIndex] = tiledCell
        self:applyChangeImage(tiledCell, tiled.x + 1, tiled.y, tiledLayer)
    end


    --3、修改当前瓦片下方瓦片的右上角顶点值为1
    if tiled.y + 1 < 10 then
        local downIndex = tiled.x * cloudSize.width + tiled.y + 1
        local tiledCell = g_tiledValueSet[downIndex] or { 0, 0, 0, 0 }
        tiledCell[RIGHT_UP_CORNER] = 1
        g_tiledValueSet[downIndex] = tiledCell
        self:applyChangeImage(tiledCell, tiled.x, tiled.y + 1, tiledLayer)
    end

    --4、修改当前瓦片右下侧瓦片的左上角顶点值为2
    if (tiled.x + 1 < 10) and (tiled.y + 1 < 10) then
        local rightdownIndex = (tiled.x + 1) * cloudSize.width + tiled.y + 1
        local tiledCell = g_tiledValueSet[rightdownIndex] or { 0, 0, 0, 0 }
        tiledCell[LEFT_UP_CORNER] = 2
        g_tiledValueSet[rightdownIndex] = tiledCell
        self:applyChangeImage(tiledCell, tiled.x + 1, tiled.y + 1, tiledLayer)
    end
end

function MistLayer:getTiledPoint(event)
    local tiledSize = self._map:getTileSize()
    local cloudSize = self._map:getMapSize()
    local tiledX = math.floor(event.x / tiledSize.width)
    local tiledY = math.floor((tiledSize.height * cloudSize.height - event.y) / tiledSize.height)
    return cc.p(tiledX, tiledY)
end

function MistLayer:onEnter()
end

function MistLayer:onExit()
end

return MistLayer
