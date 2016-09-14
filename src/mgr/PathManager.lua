--
-- Author: Your Name
-- Date: 2015-08-26 14:56:20
--
PathManager = class("PathManager")


ROOT_PATH = cc.FileUtils:getInstance():getWritablePath()

function PathManager:getRootPath()

	return ROOT_PATH.."src/"

end
-- 获取src资源
function PathManager:getMapsPath()

	return ROOT_PATH.."src/maps/"

end

function PathManager:getEventsPath()
	
	return ROOT_PATH.."src/maps/events/"

end

-- 获取最上层图片资源
function PathManager:getImgPath()
	
	return ROOT_PATH.."res/"

end



return PathManager