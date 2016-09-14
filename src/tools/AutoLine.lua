----------------------------------------------------------------------------------------------------------------------------
--自动换行
----------------------------------------------------------------------------------------------------------------------------
--数组

AutoLine = class("AutoLine")

local array = {}
local utf8_max_byte			=	3
local ascii_chat_max_byte	=	128
--自动换行
function AutoLine:autoLine(node,width,info,func)
	-- cclog("autoLine")
	if nil == node or "" == info or nil == info then
		return
	end
	array = nil
	array = {}
	array[1] = {}
	local line = 1
	local str = info
	local substr = nil
	local index = 1 --索引
	local size	=	nil
	local str_width	=	0
	while index <= #str do
		substr = string.sub(str,index,index)
		local byte = string.byte(substr)
		if byte > ascii_chat_max_byte then
			substr = string.sub(str,index,index+2)
			index = index + utf8_max_byte
		else
			index = index + 1
		end
		func(node,substr)
		size = node:getContentSize()
		if (str_width + size.width) < width then
			local count = #array[line]
			array[line][count + 1] = substr
		else
			local count = #array[line]
			array[line][count + 1] = substr
			line = line + 1
			str_width = 0
			if nil == array[line] then
				array[line] = {}
			end
		end
		str_width = str_width + size.width
	end
	-- cclog("组织数据")
	str = ""
	index = 1
	while index <= #array do
		if nil ~= array[index] then
			local str_index = 1
			while str_index <= #array[index] do
				str = str..array[index][str_index]
				str_index = str_index + 1
			end
		end
		str = str.."\r\n"
		index = index + 1
	end
	return str
end

function AutoLine:autoLineForText(fontSize,width,info)
	-- cclog("autoLine")
	if "" == info or nil == info then
		return
	end
	local text = ccui.Text:create()
	text:setFontSize(fontSize)
	array = nil
	array = {}
	array[1] = {}
	local line = 1
	local str = info
	local substr = nil
	local index = 1 --索引
	local size	=	nil
	local str_width	=	0
	while index <= #str do
		substr = string.sub(str,index,index)
		local byte = string.byte(substr)
		if byte > ascii_chat_max_byte then
			substr = string.sub(str,index,index + 2)
			index = index + utf8_max_byte
		else
			index = index + 1
		end
		if '$' ~= substr then
			local bShow = true
			if 'n' == substr then
				local s = string.sub(str,index - 2,index - 2)
				if '$' == s then
					bShow	=	false
				end
			elseif 't' == substr then
				local s = string.sub(str,index - 2,index - 2)
				if '$' == s then
					text:setText(" ")
					size = text:getContentSize()
					str_width = str_width + (size.width * 4)
					bShow	=	false
				end
			end
			if bShow then
				text:setText(substr)
				size = text:getContentSize()
				local count = #array[line]
				array[line][count + 1] = substr
				if (str_width + size.width) >= width then
					line = line + 1
					str_width = 0
					if nil == array[line] then
						array[line] = {}
					end
				end
				str_width = str_width + size.width
			end
		else
			local s = string.sub(str,index,index)
			if 'n' == s then--换行
				line = line + 1
				str_width = 0
				if nil == array[line] then
					array[line] = {}
				end
			elseif 't' == s then
				for i = 1,4 do
					text:setText(" ")
					size = text:getContentSize()
					local count = #array[line]
					array[line][count + 1] = " "
					if (str_width + size.width) >= width then
						line = line + 1
						str_width = 0
						if nil == array[line] then
							array[line] = {}
						end
					end
				end
			end
		end
	end
	str = ""
	index = 1
	while index <= #array do
		if nil ~= array[index] then
			local str_index = 1
			while str_index <= #array[index] do
				str = str..array[index][str_index]
				str_index = str_index + 1
			end
		end
		str = str.."\r\n"
		index = index + 1
	end
	return str,array
end