--
-- Author: Your Name
-- Date: 2015-08-30 22:24:33
--

local ToolBase = require("editor.ToolBase")
local EditorConstants = require("editor.EditorConstants")


local DumpTool = class("DumpTool", ToolBase)

function DumpTool:ctor(toolbar, map)
    DumpTool.super.ctor(self, "DumpTool", toolbar, map)

    self.buttons = {
        {
            name          = "DumpData",
            image         = "#SaveMapButton.png",
            imageSelected = "#SaveMapButtonSelected.png",
        },
        
    }

end

function DumpTool:selected(selectedButtonName)
    if selectedButtonName == "DumpData" then

    	MapManager:createImgTable()
    	self.toolbar_:showNotice("新导入图片资源成功", 70, 0.5)
    	self.toolbar_:selectButton("GeneralTool", 1)
	    self.toolbar_:dispatchEvent({name = "DUMP_DATA"})
    	
    end
end


return DumpTool
