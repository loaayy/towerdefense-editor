--
-- Author: Your Name
-- Date: 2015-08-26 07:45:20
--
MapManager = class("MapManager")

local curMap = nil

--⬆️⬆️ 默认不许改动 ⬆️⬆️－－
local curMapName = "MapA0001Data"

local curEventName = "MapA0001Events"

local curMapImgName = "MapA0001Bg.png"

--⬆️⬆️ 默认不许改动 ⬆️⬆️－－


function MapManager:setMap(map)


	curMap = map
	curMapName = curMap:getMapName()
	curEventName = curMap:getMapEvent()
	curMapImgName = curMap:getBgImg()

	self:setMapName(curMapName)
	self:setEventName(curEventName)
	self:setImgName(curMapImgName)

	--MapManager:dumpToFile()
	

end


function MapManager:setMapName(fileName)

	XMLManager:setRecord("curMapName", fileName)
	
	IS_REMOVE = false

	curMapName = tostring(fileName)

end

function MapManager:getMapName()

	local msg = XMLManager:getRecord("curMapName")
	local isHaveFile = IOManager:isHaveFile(msg)

	if msg and msg ~= "" and isHaveFile then

		ReloadManager:reload(msg)

		return msg
	else
		
		XMLManager:setRecord("curMapName", curMapName)
		return curMapName
	end
end


function MapManager:setEventName(fileName)

	XMLManager:setRecord("curEventName", fileName)
	
	curEventName = tostring(fileName)
end

function MapManager:getEventName()

	local msg = XMLManager:getRecord("curEventName")
	local isHaveFile = IOManager:isHaveFile(msg)

	if msg and msg ~= "" and isHaveFile then

		ReloadManager:reload(msg)

		return msg
	else

		XMLManager:setRecord("curEventName", curEventName)	
		return curEventName
	end
	
end


function MapManager:setImgName(fileName)

	XMLManager:setRecord("curMapImgName", fileName)
	curMapImgName = tostring(fileName)
end

function MapManager:getImgName()

	local msg = XMLManager:getRecord("curMapImgName")
	local isHaveFile = IOManager:isHaveFile(msg)

	if msg and msg ~= "" and isHaveFile then
		
		return msg
	else

		XMLManager:setRecord("curMapImgName", curMapImgName)
			
		return curMapImgName
	end

end

function MapManager:dumpToFile(fileName)

	if fileName ~= nil then
		curMapName = fileName
	end

	local function dump()
		local lines = {}
	    lines[#lines + 1] = ""

	    lines[#lines + 1] = string.format("------------ %s ------------",curMapName)
	    lines[#lines + 1] = ""
	    lines[#lines + 1] = "local map = {}"
	    lines[#lines + 1] = ""
	    lines[#lines + 1] = string.format("map.size = {width = %d, height = %d}", curMap.width_, curMap.height_)
	    lines[#lines + 1] = string.format("map.imageName = \"%s\"", curMapImgName)
	    lines[#lines + 1] = string.format("map.eventName = \"%s\"", curEventName)
	    lines[#lines + 1] = TiledMapManager:dump()
	    lines[#lines + 1] = ""

	    -- objects
	    local allid = table.keys(curMap.objects_)
	    table.sort(allid)
	    lines[#lines + 1] = "local objects = {}"
	    lines[#lines + 1] = "--⬆️⬆️⬆️⬆️⬆️⬆️不可删除⬆️⬆️⬆️⬆️⬆️⬆️--"

	    for i, id in ipairs(allid) do
	        lines[#lines + 1] = ""
	        lines[#lines + 1] = curMap.objects_[id]:dump("local object")
	        
	        lines[#lines + 1] = string.format("objects[\"%s\"] = object", id)
	        lines[#lines + 1] = ""
	        lines[#lines + 1] = "----"
	    end
	    lines[#lines + 1] = "--⬇️⬇️⬇️⬇️⬇️⬇️不可删除⬇️⬇️⬇️⬇️⬇️⬇️--"
	    lines[#lines + 1] = "map.objects = objects"
	    lines[#lines + 1] = ""
	    lines[#lines + 1] = "return map"
	    lines[#lines + 1] = ""
	    return table.concat(lines, "\n")
	end


	local contents = dump()

    local path = nil
    local name = fileName
    if name then
       path = cc.FileUtils:getInstance():getWritablePath()
       .."src/maps/"..string.format("%s.lua", name)
    else
        
        local modelName = string.format("maps.%s", curMapName)
        path = self:findModulePath(modelName)
        --error("..................cant find module path................")
    end
    
    if path then
        --printf("save data filename \"%s\" [%s]", path, os.date("%Y-%m-%d %H:%M:%S"))
        io.writefile(path, contents)

        return true
    else
        --printf("not found module file, dump [%s]", os.date("%Y-%m-%d %H:%M:%S"))
        --echo("\n\n" .. contents .. "\n")
        return false
    end
end

function MapManager:createFile( fileName )
	
	curMap:removeAllObjects()
	self:setMapName(fileName)
	self:dumpToFile(fileName)
end

function MapManager:findModulePath(moduleName)
    local filename = string.gsub(moduleName, "%.", "/") .. ".lua"

    local paths = string.split(package.path, ";")
    for i, path in ipairs(paths) do
        if string.sub(path, -5) == "?.lua" then
            path = string.sub(path, 1, -6)
            if not string.find(path, "?", 1, true) then
                local fullpath = path .. filename
                if io.exists(fullpath) then
                    return fullpath
                end
            end
        end
    end
    return false
end


-- 注意！同一个png文件与plist文件不能分开放在不同的文件夹，否则会出错
function MapManager:createImgTable()

	local function dump()
		local t = IOManager:getAllImg()
	    local lines = {}
	    --lines[#lines + 1] = "IMG = {"
	    lines[#lines + 1] = "\n"
	    lines[#lines + 1] = "	-----------------此文件为工具自动生成-----------------"
	
	    for k,v in pairs(t) do
	        --print(k,v)
	        --local name = unpack(string.split(v,"."))

	        -- 获取图片地址格式
	        local img = ReloadManager:searchImgPath(v)

	        -- 根据文件格式生成变量
	        local tab = string.split(img,"/")
	        local var_lines = {}
	        local v1,v2
	        for k,v in pairs(tab) do
	        	if k == #tab then

	        		-- 不规范命名调整
	        		v,v2 = unpack(string.split(v,"-"))
	        		if v2 then
	        			v,v2 = unpack(string.split(v2,"."))
	        		else
	        			-- 默认情况
	        			v,v2 = unpack(string.split(v,"."))

	        		end
	        	
	        		
	        	end
	        	var_lines[#var_lines + 1] = v
	        	
	        end
	        var_lines[#var_lines + 1] = v2
	        local name = table.concat(var_lines,"_")
	      
	        lines[#lines + 1] = string.format("	%s = '%s'", name,img)
	       
	    end
	    --lines[#lines + 1] = "}"
	    table.sort(lines)
	    return table.concat(lines,"\n")

	end

	local contents = dump()
	local path = cc.FileUtils:getInstance():getWritablePath().."src/mgr/GameRes.lua"
   	if path then
   		io.writefile(path, contents)
   	end
	
end




return MapManager