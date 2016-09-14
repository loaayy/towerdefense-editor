--
-- Author: Your Name
-- Date: 2015-09-27 04:44:30
--
LableManager = class("LableManager")


local t = {}


function LableManager:createLabel(label,parent,pos)

	local ttf = cc.LabelTTF:create(label,"黑体",20)
    ttf:setColor(cc.c3b(255,0,0))
    ttf:setPosition(pos)
    parent:addChild(ttf,999)

    t[#t + 1] = ttf

end

function LableManager:removeAll()

	for k,v in pairs(t) do
		--print(k,v)
		v:removeSelf()
		v = nil
	end
	t = {}
end




return LableManager