

-- 画线行为类
local EditorConstants = require("editor.EditorConstants")
local BehaviorBase = require("app.map.behaviors.BehaviorBase")

-- 继承行为基类
local PathEditorBehavior = class("PathEditorBehavior", BehaviorBase)

PathEditorBehavior.SELECTED_COLOR = cc.c4b(0, 255, 0, 255)
PathEditorBehavior.UNSELECTED_COLOR = cc.c4b(0, 255, 0, 255)

function PathEditorBehavior:ctor()
    -- 超继承,继承并初始化ctor
    PathEditorBehavior.super.ctor(self, "PathEditorBehavior", nil, 0)
end


-- 重写绑定函数
function PathEditorBehavior:bind(object)
    object.isSelected_  = false
    object.groupName_   = object.state_.groupName_
    if type(object.groupName_) ~= "string" then
        object.groupName_ = "default"
    end
    object.flagsSprite_ = {}

    local function isSelected(object)
        return object.isSelected_
    end
    object:bindMethod(self, "isSelected", isSelected)

    local function setSelected(object, isSelected)
        object.isSelected_ = isSelected
    end
    object:bindMethod(self, "setSelected", setSelected)

    local function getGroupName(object)
        return object.groupName_
    end
    object:bindMethod(self, "getGroupName", getGroupName)

    local function setGroupName(object, groupName)
        object.groupName_ = tostring(groupName)
    end
    object:bindMethod(self, "setGroupName", setGroupName)

    local function isViewCreated(object)
        return object.idLabel_ ~= nil
    end
    object:bindMethod(self, "isViewCreated", isViewCreated)

    local function createView(object, batch, marksLayer, debugLayer)
        object.idLabel_ = cc.ui.UILabel.new({
            text  = object:getId(),
            font  = EditorConstants.LABEL_FONT,
            size  = EditorConstants.LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_CENTER,
        })
        :align(display.CENTER)
        debugLayer:addChild(object.idLabel_, EditorConstants.LABEL_ZORDER)
    end
    object:bindMethod(self, "createView", createView)

    local function removeView(object)
        object.idLabel_:removeSelf()
        object.idLabel_ = nil

        object.polygon_:removeSelf()
        object.polygon_ = nil

        for i, flag in ipairs(object.flagsSprite_) do
            flag:removeSelf()
        end
        object.flagsSprite_ = nil
    end
    object:bindMethod(self, "removeView", removeView, true)

    local function updateView(object)
        if object.polygon_ then
            object.polygon_:removeSelf()
            object.polygon_ = nil
        end

        if #object.points_ < 1 then return end

        object.polygon_ = utils.drawPolygon(object.points_)
      
        object.debugLayer_:addChild(object.polygon_, EditorConstants.POLYGON_ZORDER)

        if object.isSelected_ then
            object.polygon_:setLineColor(PathEditorBehavior.SELECTED_COLOR)
            object.idLabel_:setColor(cc.c3b(unpack(EditorConstants.SELECTED_LABEL_COLOR)))
           
        else
            object.polygon_:setLineColor(PathEditorBehavior.UNSELECTED_COLOR)
            object.idLabel_:setColor(cc.c3b(unpack(EditorConstants.UNSELECTED_LABEL_COLOR)))
            
        end

        local scale = object.debugLayer_:getScale()
        if scale > 1 then scale = 1 / scale end

        for index, point in ipairs(object.points_) do
            local x, y = unpack(point)

            if index == 1 then
                object.idLabel_:setPosition(x, y - 10 - EditorConstants.LABEL_OFFSET_Y)
                object.idLabel_:setScale(1.5)
                object.x_, object.y_ = x, y
            end

            if not object.flagsSprite_ then object.flagsSprite_ = {} end
            local flag = object.flagsSprite_[index]
            if not flag then
                flag = display.newSprite("#PointFlag.png")
                object.debugLayer_:addChild(flag, EditorConstants.FLAG_ZORDER)
                object.flagsSprite_[index] = flag
            end

            
            -- 设置路径点大小
            if flag then
                if index == 1 then
                  
                    flag:setScale(5)
                    flag:setPosition(x, y)
                else
                    
                    flag:setScale(scale)
                    flag:setPosition(x, y)
                end
                
            end
        end

        for index = #object.points_ + 1, #object.flagsSprite_ do
            object.flagsSprite_[index]:removeSelf()
            object.flagsSprite_[index] = nil
        end
    end
    object:bindMethod(self, "updateView", updateView)
end

function PathEditorBehavior:unbind(object)
    object.isSelected_  = nil
    object.groupName_   = nil
    object.flagsSprite_ = nil

    object:unbindMethod(self, "isSelected")
    object:unbindMethod(self, "setSelected")
    object:unbindMethod(self, "getGroupName")
    object:unbindMethod(self, "setGroupName")
    object:unbindMethod(self, "isViewCreated")
    object:unbindMethod(self, "createView")
    object:unbindMethod(self, "removeView")
    object:unbindMethod(self, "updateView")
end

return PathEditorBehavior
