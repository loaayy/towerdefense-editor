--
-- Author: Your Name
-- Date: 2015-08-25 14:28:57
--
local ToolBase = require("editor.ToolBase")
local EditorConstants = require("editor.EditorConstants")


local SelectMapTool = class("SelectMapTool", ToolBase)

function SelectMapTool:ctor(toolbar, map)
    SelectMapTool.super.ctor(self, "SelectMapTool", toolbar, map)

    self.buttons = {
        {
            name          = "SelectMap",
            image         = "#SaveMapButton.png",
            imageSelected = "#SaveMapButtonSelected.png",
        },
        
    }

end

function SelectMapTool:selected(selectedButtonName)
    if selectedButtonName == "SelectMap" then
    	
	    self.toolbar_:dispatchEvent({name = "SELECT_MAP"})
    	
    end
end


return SelectMapTool
