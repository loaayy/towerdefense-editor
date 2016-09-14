--
-- Author: Your Name
-- Date: 2015-08-21 04:34:53
--
local ToolBase = require("editor.ToolBase")
local ScaleTool = class("ScaleTool",ToolBase)


function ScaleTool:ctor(toolbar, map)
	ScaleTool.super.ctor(self, "ScaleTool", toolbar, map)

	self.buttons = {
        {
            name          = "ZoomIn",
            image         = "#ZoomInButton.png",
            imageSelected = "#ZoomInButton.png",
        },
        {
            name          = "ZoomOut",
            image         = "#ZoomOutButton.png",
            imageSelected = "#ZoomOutButton.png",
        },
      
    }

end

function ScaleTool:selected(selectedButtonName)
    ScaleTool.super.selected(self, selectedButtonName)
   	print('selected')

   	if selectedButtonName == "ZoomIn"  then
   		local scale = self.map_:getCamera():getScale()
	    if scale < 2.0 then
	        scale = scale + 0.5
	        if scale > 2.0 then scale = 2.0 end
	        self.map_:getCamera():setScale(scale)
	        self.map_:updateView()
	        self.toolbar_:showNotice(string.format("%0.2f", scale),100,0.5)

          self.toolbar_:selectButton("GeneralTool", 1)

	    end
   	end

   	if selectedButtonName == "ZoomOut"  then
   		local scale = self.map_:getCamera():getScale()
	    if scale > 0.5 then
	        scale = scale - 0.5
	        if scale < 0.5 then scale = 0.5 end
	        self.map_:getCamera():setScale(scale)
	        self.map_:updateView()
	        self.toolbar_:showNotice(string.format("%0.2f", scale),100,0.2)

          self.toolbar_:selectButton("GeneralTool", 1)
	    end

   	end
   	
end


function ScaleTool:onTouch(event, x, y)
    local x, y = self.map_:getCamera():convertToMapPosition(x, y)

    print(x,y)
end



return ScaleTool