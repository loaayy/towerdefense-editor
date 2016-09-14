

-- 工作任务

-- 1，将聊天源码熟悉

-- 2，替换编辑器资源成BROWSER QUEST的

function ObjectInspector:setPath(object)

    -- 显示定制
    local isVisible = self.isVisible_
    local changeVisible = self.object_ ~= object
    if self.panel_ then self:removeObject() end
    if not changeVisible then
        self.isVisible_ = isVisible
    end

    local panel = display.newNode()
    self.sprite_:addChild(panel)
    self.panel_ = panel

    self.size_ = {300, 200}
    self:setPosition()
    self.sprite_:setVisible(self.isVisible_)


    -- 显示路径信息
    local pair = {}
    if object:hasBehavior("PathEditorBehavior") then
        pair = {
            name  = object:getId(),
            value = "PointsCount:"..object:getPointsCount(),
            edit  = true,
            editNote = "pathId is string",
            editFunction = function(object, newvalue)
                self.map_:resetPathName(object:getId(),
                    string.format("path:%d",newvalue))
                self.map_:updateView()
            end
        }
    end
    local labelX = 0
    local labelY = -50
    local prefix = string.rep(" ", EditorConstants.PROPERTY_PREFIX_LEN - string.len(pair.name)) .. pair.name
    local text   = string.format("%s = %s", tostring(prefix), tostring(pair.value))
    local label  = cc.ui.UILabel.new({
        text  = text,
        font  = EditorConstants.PANEL_LABEL_FONT,
        size  = EditorConstants.PANEL_LABEL_FONT_SIZE,
        align = cc.ui.TEXT_ALIGN_LEFT,
        x     = labelX,
        y     = labelY,
    }):align(display.CENTER_LEFT)
    panel:addChild(label)

    
end
