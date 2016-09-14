--
-- Author: Your Name
-- Date: 2015-08-25 02:38:20
--
-- 适配管理类
UIManager = class('UIManager')

-- Interface design of the full screen size
local DESIGN_WIDTH       = 1600
local DESIGN_HEIGHT      = 1000

-- layer location mode
UI = 
{
	LEFT_TOP              = 1,
	LEFT_CENTER           = 2,
	LEFT_BOTTOM           = 3,
	MIDDLE_TOP            = 4,
	MIDDLE_CENTER         = 5,
	MIDDLE_BOTTOM         = 6,
	RIGHT_TOP             = 7,
	RIGHT_CENTER          = 8,
	RIGHT_BOTTOM          = 9,
}


UIManager.UIList = {}

function UIManager:setLayer(name, layer)
	self.UIList[name] = layer
end

function UIManager:getLayer(name)
	return self.UIList[name]
end

function UIManager:isShowLayer(name)
	if self.UIList[name] then
		local layer = self.UIList[name]:getLayer()
		if layer and layer:getParent() then
			return true
		else
			return false
		end
	else
		return false
	end
end

function UIManager:closeLayer(name)
	local layer = self.UIList[name].getLayer()
	if layer and layer:getParent() then
		layer:removeFromParent(true)
		self.UIList[name] = nil
	end
end

function UIManager:popLayer(name)
	if not self:isShowLayer(name) then
		if self.UIList[name] then
			local layer = self.UIList[name].getLayer()
			if not layer then
				layer = self.UIList[name]:create()
			end
			if layer then

				cc.Director:getInstance():getRunningScene():addChild(layer)
				--self.UIList[name].openRefresh()
			end
		end
	end
end

function UIManager:setLocation(pLayer, layerSize, locationMode,isScale)
 
  
  local layerWidth = layerSize.width
  local layerHeight = layerSize.height
  
  -- 是否拉伸
  if isScale == true then
	local scaleX = display.width / DESIGN_WIDTH
	local scaleY = display.height / DESIGN_HEIGHT
	local layerWidth = layerSize.width * scaleX
	local layerHeight = layerSize.height * scaleY
	pLayer:setScaleX(scaleX)
	pLayer:setScaleY(scaleY)
  end
  pLayer:setContentSize(layerSize)
  pLayer:ignoreAnchorPointForPosition(true) 
  pLayer:setAnchorPoint(cc.p(0, 0))
  pLayer:setTouchEnabled(true)
  if locationMode == UI.LEFT_TOP then
    pLayer:setPosition(cc.p(0, display.height - layerHeight))
  elseif locationMode == UI.LEFT_CENTER then
    pLayer:setPosition(cc.p(0, display.height/2 - layerHeight/2))
  elseif locationMode == UI.LEFT_BOTTOM then
    pLayer:setPosition(cc.p(0, 0))
  elseif locationMode == UI.MIDDLE_TOP then
    pLayer:setPosition(cc.p(display.width/2 - layerWidth/2, display.height - layerHeight))
  elseif locationMode == UI.MIDDLE_CENTER then
    pLayer:setPosition(cc.p(display.width/2 - layerWidth/2, display.height/2 - layerHeight/2))
  elseif locationMode == UI.MIDDLE_BOTTOM then
    pLayer:setPosition(cc.p(display.width/2 - layerWidth/2, 0))
  elseif locationMode == UI.RIGHT_TOP then
    pLayer:setPosition(cc.p(display.width - layerWidth, display.height - layerHeight))
  elseif locationMode == UI.RIGHT_CENTER then
    pLayer:setPosition(cc.p(display.width - layerWidth, display.height/2 - layerHeight/2))
  elseif locationMode == UI.RIGHT_BOTTOM then
    pLayer:setPosition(cc.p(display.width - layerWidth, 0))
  else
    pLayer:setPosition(cc.p(0, 0))
  end   
end

return UIManager