

-- lua热加载
ReloadManager = class("ReloadManager")


-- 同个字段字符串切割
function ReloadManager:split(str, separator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
	   local nFindLastIndex = string.find(str, separator, nFindStartIndex)
	   if not nFindLastIndex then
	    nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, string.len(str))
	    break
	   end
	   nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(separator)
	   nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end


function ReloadManager:dealLuaFiles(fileName)

	local path = IOManager:searchFilePath( fileName )
	local str = string.format("%s%s", path,fileName)
	local s1,s2 = unpack(self:split(str,"src"))
	local tab = self:split(s2,"/")
	local lines = {}
	for k,v in pairs(tab) do

		if v ~= "" then
			lines[#lines + 1] = v
		end
	end
	local model = table.concat(lines,".")

	return model
end

function ReloadManager:reload(fileName)

	local model = self:dealLuaFiles(fileName)
	if model then
		package.loaded[model] = nil
    	require(model)
	end

end


function ReloadManager:searchImgPath(file)

	local fileName = unpack(string.split(file,"."))

	local path = IOManager:searchImgPath( fileName )
	local str = string.format("%s%s", path,file)
	local s1,s2 = unpack(self:split(str,"res"))
	local tab = self:split(s2,"/")
	local lines = {}
	for k,v in pairs(tab) do

		if v ~= "" then
			lines[#lines + 1] = v
		end
	end
	local model = table.concat(lines,"/")

	return model
end



return ReloadManager