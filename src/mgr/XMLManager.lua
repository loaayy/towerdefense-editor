--
-- Author: Your Name
-- Date: 2015-08-26 22:20:07
--

XMLManager = class("XMLManager")

local PLAYER = cc.UserDefault:getInstance()

function XMLManager:isRecord()

	if not PLAYER:getBoolForKey("isRecordXML") then
		
		PLAYER:setBoolForKey("isRecordXML", true)
		PLAYER:setStringForKey("PlayerRecord", "zhuqiang")
		PLAYER:flush()
		return false
	else
		return true
	end

end
-- XML记录
function XMLManager:getRecord(key)

	--print('XMLManager:getRecord:',key)
	
	if XMLManager.isRecord() then
		local var = PLAYER:getStringForKey(key)
    	return var
	end
end

function XMLManager:setRecord(key,var)

	--print('XMLManager:setRecord')
	
	PLAYER:setStringForKey(key,var)

end


return XMLManager