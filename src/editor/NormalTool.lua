--
-- Author: Your Name
-- Date: 2015-08-25 01:22:02
--

local ToolBase = require("editor.ToolBase")
local NormalTool = class("NormalTool", ToolBase)

local SetStaticCollision_Count = 0

function NormalTool:ctor(toolbar, map)
    NormalTool.super.ctor(self, "NormalTool", toolbar, map)

    self.buttons = {
        {
            name          = "NewScene",
            image         = "#SaveMapButton.png",
            imageSelected = "#SaveMapButtonSelected.png",
        },
        {
            name          = "TiledGrid",
            image         = "#ToggleDebugButton.png",
            imageSelected = "#ToggleDebugButtonSelected.png",
        },
        {
            name          = "SetStaticCollision",
            image         = "#ToggleDebugButton.png",
            imageSelected = "#ToggleDebugButtonSelected.png",
        },
        
    }

end

function NormalTool:selected(selectedButtonName)
    if selectedButtonName == "NewScene" then

    	local value = device.showInputBox("New Scene", "创建新场景并保存当前地图")

    	if value == "" then
    		print("创建失败")
    	else
            
            MapManager:createFile(value)
            display.replaceScene(require("editor.EditorScene").new())
    		self.toolbar_:dispatchEvent({name = "NEW_SCENE",value = value})
    	end
    	
    end
    if selectedButtonName == "TiledGrid" then

        local tiledLayer = TiledMapManager:getGridLayer()

        if tiledLayer then
           tiledLayer:setVisible(not tiledLayer:isVisible())
        end
        
        
    end
    if selectedButtonName == "SetStaticCollision" then

        SetStaticCollision_Count = SetStaticCollision_Count + 1

        if SetStaticCollision_Count % 2 == 1 then

            print("StaticObjectsCollision ==> true")
            self.map_:setStaticObjectsCollision(true)
            --MapManager:dumpToFile()
            display.replaceScene(require("editor.EditorScene").new())

            
        else
            
            print("StaticObjectsCollision ==> false")
            self.map_:setStaticObjectsCollision(false)
            display.replaceScene(require("editor.EditorScene").new())

        end

       
        
    end
end


return NormalTool
