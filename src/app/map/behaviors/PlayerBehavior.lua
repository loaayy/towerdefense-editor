
local math2d       = require("math2d")
local BehaviorBase = require("app.map.behaviors.BehaviorBase")
local PlayerBehavior = class("PlayerBehavior", BehaviorBase)



PlayerBehavior.MOVING_STATE_STOPPED   = 0
PlayerBehavior.MOVING_STATE_SPEEDUP   = 1
PlayerBehavior.MOVING_STATE_SPEEDDOWN = 2
PlayerBehavior.MOVING_STATE_FULLSPEED = 3

PlayerBehavior.SPEED_SCALE = 1.0 / 300


function PlayerBehavior:ctor()
	 local depends = {

        "MovableBehavior",
    }
   
    PlayerBehavior.super.ctor(self, "PlayerBehavior", depends, 100)
end


function PlayerBehavior:setNextPosition(object)

    object.nextPointIndex_ = object.nextPointIndex_ + 1
    local count = #object.path_

    if object.nextPointIndex_ >= count then

        object.movingState_ = PlayerBehavior.MOVING_STATE_STOPPED

    end

    -- +1是忽略第一点坐标
    local pos = object.path_[object.nextPointIndex_ + 1]

    if pos then
        object.nextX_, object.nextY_ = pos.x,pos.y
        object.nextRadians_ = math2d.radians4point(object.x_, object.y_, object.nextX_, object.nextY_)
        object.nextDist_    = math2d.dist(object.x_, object.y_, object.nextX_, object.nextY_)
        
    end

    object.currentDist_ = 0
    
end


function PlayerBehavior:bind(object)

    object.nextDist_             = 0
    object.currentSpeed_         = 0
    object.currentDist_          = 0
    object.nextPointIndex_       = 0
    object.nextX_, object.nextY_ = nil
    object.path_                 = {}
    object.ttfMgr_               = {}
    object.palyerSpeed_          = object:getSpeed()


	local function goTo(object,mapx,mapy)

        -- 不停点击同一坐标触发无效,(也可以适用没有瓦块地图的场景中，要做范围判断)
        -- if #object.path_ > 0 then
        --     local finalPos = object.path_[#object.path_]
        --     local tileCoords1 = TiledMapManager:getTileCoordsFromPosition(finalPos)
        --     local tileCoords2 = 
        --     TiledMapManager:getTileCoordsFromPosition(cc.p(mapx,mapy))

        --     if tileCoords1.x == tileCoords2.x and 
        --         tileCoords1.y == tileCoords2.y  then
        --         return
        --     end
        -- end
   
        -- 重置状态
        object.nextPointIndex_       = 0
        object.path_                 = {}

        -- 删除坐标
        for k,v in pairs(object.ttfMgr_) do
            v:removeSelf()
            v = nil
        end
        object.ttfMgr_ = {}
      

        if object.movingState_ == PlayerBehavior.MOVING_STATE_STOPPED
                or object.movingState_ == PlayerBehavior.MOVING_STATE_SPEEDDOWN then
            object.movingState_ = PlayerBehavior.MOVING_STATE_SPEEDUP
        else
            --object.movingState_ = PlayerBehavior.MOVING_STATE_STOPPED
        end
       
       -- 获取瓦块地图路径
        local path = TiledMapManager:getPath(cc.p(object:getPosition()),cc.p(mapx,mapy))
        if path then
            for node, count in path:nodes() do
               
                -- 转换成地图坐标
                local tilePos = cc.p(node:getX(),node:getY())
                local pos = TiledMapManager:getPositionFromTileCoords(tilePos)
            
                -- 创建路径点
                local ttf = utils.createLabel("0",object.map_:getBatchLayer(),pos)
                object.ttfMgr_[#object.ttfMgr_ + 1] = ttf

                --LableManager:createLabel("0",object.map_:getBatchLayer(),pos,"POINT")

                -- 转换路径点
                if pos then
                    object.path_[#object.path_ + 1] = pos
                end

            end
            self:setNextPosition(object)
        end

    end
    object:bindMethod(self, "goTo", goTo)

        
    local function tick( object,dt )

        -- 移动状态，以及速度计算方法
        local state = object.movingState_
        if state == PlayerBehavior.MOVING_STATE_STOPPED then return end

        if state == PlayerBehavior.MOVING_STATE_SPEEDUP
                or (state == PlayerBehavior.MOVING_STATE_FULLSPEED
                    and object.currentSpeed_ < object.maxSpeed_) then
            object.currentSpeed_ = object.currentSpeed_ + object.speedIncr_
            if object.currentSpeed_ >= object.maxSpeed_ then
                object.currentSpeed_ = object.maxSpeed_
                object.movingState_ = PlayerBehavior.MOVING_STATE_FULLSPEED
            end
        elseif state == PlayerBehavior.MOVING_STATE_SPEEDDOWN then
            object.currentSpeed_ = object.currentSpeed_ - object.speedDecr_
            if object.currentSpeed_ <= 0 then
                object.currentSpeed_ = 0
                object.movingState_ = PlayerBehavior.MOVING_STATE_STOPPED
            end
        elseif object.currentSpeed_ > object.maxSpeed_ then
            
            object.currentSpeed_ = object.currentSpeed_ - object.speedDecr_
            if object.currentSpeed_ < object.maxSpeed_ then
                object.currentSpeed_ = object.maxSpeed_
            end
        end

        local x, y = object:getPosition()
        local currentDist = object.currentDist_ + object.currentSpeed_

        if currentDist >= object.nextDist_ then

            if #object.path_ > 1 then

                --print(object.nextX_, object.nextY_)
                object:setPosition(object.nextX_, object.nextY_)
                currentDist = currentDist - object.nextDist_

                self:setNextPosition(object)

                x, y = math2d.pointAtCircle(object.x_, object.y_, object.nextRadians_, currentDist)
            end
            
        else
            local ox, oy = math2d.pointAtCircle(0, 0, object.nextRadians_, object.currentSpeed_)
            x = x + ox
            y = y + oy
        end
        object.currentDist_ = currentDist

        -- 方向转换
        if x < object.x_ then
            object:setFlipSprite(true)
        elseif x > object.x_ then
            object:setFlipSprite(false)
        end
        
        object:setPosition(x,y)
        object:updateView()

       
    end
    object:bindMethod(self, "tick", tick)

    local function setPlayerSpeed(object, maxSpeed)

        object.palyerSpeed_ = checknumber(maxSpeed)

        object:setSpeed(object.palyerSpeed_)


    end
    object:bindMethod(self, "setPlayerSpeed", setPlayerSpeed)

    local function getPlayerSpeed(object)

       return object.palyerSpeed_
    end
    object:bindMethod(self, "getPlayerSpeed", getPlayerSpeed)


end

function PlayerBehavior:unbind(object)

    object.path_ = nil

    object:unbindMethod(self, "goTo")
    object:unbindMethod(self, "tick")
    object:unbindMethod(self, "setPlayerSpeed")
    object:unbindMethod(self, "getPlayerSpeed")

    
end

function PlayerBehavior:reset(object)

    object:setPlayerSpeed(object.palyerSpeed_)
    object.currentSpeed_ = 0
    object.movingState_  = PlayerBehavior.MOVING_STATE_STOPPED
   
end

return PlayerBehavior
