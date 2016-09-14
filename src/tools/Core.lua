-----------------------------------------------------------------
--  姓名：
--  功能：常用的方法
--  日期：2014年11月17日 15:21:42
--  备注：以前的这个文件存在很多没用到的函数，现在需要什么函数，自己在这里加上
-----------------------------------------------------------------

-- 注意，module之前必须重新赋值一些常用的类型，module后的此类函数可以不用添加类型
local ipairs = ipairs
local string = string
local pairs = pairs
local print = print
local math = math
local tostring = tostring
local type = type
local cc=cc
local assert = assert
local tonumber = tonumber
local table = table
local error = error
local g_TableShielding_word = {"操你妈","傻逼","操你麻痹"}

module "Core"

-----------------------------------------------------------------
--通过名字获取node(如果一个node的孩子里有相同名字，结果不可预计)
-----------------------------------------------------------------
function findNodeByName(node,nodeName)
  
  if node == nil then
    return nil;
  end
  
  local findNode=node:getChildByName(nodeName);
  
  if findNode ~= nil then
    return findNode;
  end
  
  local children=node:getChildren();
  for k,v in ipairs(children) do  
      findNode=findNodeByName(v,nodeName);
      if findNode ~= nil then
          return findNode;
      end
  end 
  return nil;
end

-----------------------------------------------------------------
--通过tag获取node(如果一个node的孩子里有相同tag，结果不可预计)
-----------------------------------------------------------------
function findNodeByTag(node,tag)
  
  if node == nil then
    return nil;
  end
  
  local findNode=node:getChildByTag(tag);
  
  if findNode ~= nil then
    return findNode;
  end
  
  local children=node:getChildren();
  
  for k,v in ipairs(children) do  
      findNode=findNodeByTag(v,tag);
      if findNode ~= nil then
          return findNode;
      end
  end 
  return nil;
end




-------------------------------------------------------------------------------
--刘岩朝
--将可变参数表中的字符串使用separator分隔符连接起来
-------------------------------------------------------------------------------
function getMergeStringByArguments(separator, ...)
	local arg = {...};
	local argCount = #arg;
	local _retStr = "";
	for k,v in ipairs(arg) do
		_retStr = _retStr .. v;
		if k ~= argCount then
			_retStr = _retStr .. separator;
		end;
	end;
	
	return _retStr;
end;



-------------------------------------------------------------------------------
--遍历strTable将其中的字符串使用separator分隔符连接起来
-------------------------------------------------------------------------------
function getMergeStringByTable(separator, strTable)
	
	local _retStr = "";
	local _tableCount = #strTable;
	for k,v in ipairs(strTable) do
		_retStr = _retStr .. v;
		if k ~= _tableCount then
			_retStr = _retStr .. separator;
		end;
	end;
	
	return _retStr;
end;


-----------------------------------------------------------------
--字符串切割
-----------------------------------------------------------------
function split(szFullString, szSeparator, isNumber)
  local nFindStartIndex = 1  
  local nSplitIndex = 1  
  local nSplitArray = {}  
  if #szFullString ~= 0 then
    while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
    if not nFindLastIndex then  
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
      break
    end
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
    nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
    nSplitIndex = nSplitIndex + 1  
    end
  end
  if isNumber then
    for k,v in pairs(nSplitArray) do
      nSplitArray[k] = tonumber(v)
    end
  end
  return nSplitArray
  --用法:
  --local list = split("abc,123,345", ",")
  --然后list里面就是
  --abc
  --123
  --345
  --第二个参数可以是多个字符
end 

-------------------------------------------------------------------------------
--打印lua中的table
-------------------------------------------------------------------------------
function print_lua_table(lua_table, indent)
  indent = indent or 0
  for k, v in pairs(lua_table) do
    if type(k) == "string" then
      k = string.format("%q", k)
    end
    local szSuffix = ""
    if type(v) == "table" then
      szSuffix = "{"
    end
    local szPrefix = string.rep("    ", indent)
    formatting = szPrefix.."["..k.."]".." = "..szSuffix
    if type(v) == "table" then
      -- print(formatting)
      -- print_lua_table(v, indent + 1)
      -- print(szPrefix.."},")
    else
      local szValue = ""
      if type(v) == "string" then
        szValue = string.format("%q", v)
      else
        szValue = tostring(v)
      end
      -- print(formatting..szValue..",")
    end
  end
end

-------------------------------------------------------------------------------
--刘岩朝
--计算2点之间距离
-------------------------------------------------------------------------------
function get2PointDistance(x1,y1,x2,y2)
    local i = (x1 - x2)^2 + (y1 - y2)^2;
    return math.sqrt(i); 
end



-------------------------------------------------------------------------------
--计算2点之间距离，用于仇恨排序
-------------------------------------------------------------------------------
function get2PointDistance_2(x1,y1,x2,y2)
	local _distance = math.abs(x2 - x1) + math.abs(y2 - y1);
	return _distance;
end


-------------------------------------------------------------------------------
--获取UIF - 8字符长度
-------------------------------------------------------------------------------
function getUtfStrLen(str)
  local len = #str
  local left = len
  local cnt = 0
  local arr = {0,0xc0,0xe0,0xf0,0xf8,0xfc}
  while left ~= 0 do
    local tmp=string.byte(str,-left)
    local i=#arr
    while arr[i] do
      if tmp>=arr[i] then
        left=left-i
        break
      end
      i=i-1
    end
    cnt=cnt+1
  end
  return cnt
end


-------------------------------------------------------------------------------
--cs
--字符串自动加换行
-------------------------------------------------------------------------------
local arr = {0,0x7f,0x7FF,0xffff}
--获取字符占多少字节
local function getByteSize(byte)
    if byte <= 0x7f then
      return 1
    elseif byte > 0x7f and byte < 0x7FF then
      return 3
    end
   assert(false, "未知字符！")
end
--获取字符宽多少 英文+数字为1 汉子为2
local function getWidth(byte)
    if byte <= 0x7f then
      return 1
    elseif byte > 0x7f then
      return 2
    end
   assert(false, "未知字符！")
end

function wrap(str, len)
  assert(len > 1,"添加换行符，长度必须大于1")
  --中文字符字节为3 宽为2，英文字节为1，宽为1
  local _str = {}
  local byte
  local count = 1
  local index = 0
  local width = 0
  while true do
    --每次自加1
--    print("index = "..index)
    if not str:byte(index+ 1 ) then
      table.insert(_str, string.sub(str,1, -1))   
      break
    end
    byte = str:byte(index+1)
    index = index + getByteSize(byte)
    width = width + getWidth(byte)    
    if width == len then      
      table.insert(_str, string.sub(str,1, index))    
      str = string.sub(str, index+1, -1)
      count = count + 1
      index =  0
      width = 0
    elseif str:byte(index+1) and (getWidth(str:byte(index+1)) + width) > len then      
      table.insert(_str, string.sub(str,1, index))
      str = string.sub(str, index+1, -1)
      count = count + 1
      index = 0
      width = 0      
    end
  end
  return table.concat(_str, "\n"), count
end


-- function wrap(str, len)
--   assert(len > 1)
--   --str = "吹起有法力的短笛，吹散所有迷雾将花费100元宝，是否确定？"
--   --len = 48
--   local str = str
--   local _str = ""
--   local byte
--   local count = 1
--   local index = 1
--   while true do
--     --每次自加1
--     byte = str:byte(index)
--     index = index + getStrSize(byte)
--     if not str:byte(index+1) then
--       _str = _str .. string.sub(str,1, -1)
--       print("结束")
--       break
--     elseif index == len then
--       _str = _str .. string.sub(str,1, index).."\n"
--       str = string.sub(str, index+1, -1)
--       print("刚好满足")
--       count = count + 1
--       index =  1
--     elseif getStrSize(str:byte(index+1)) + index > len then
--       print(getStrSize(str:byte(index+1)) , index, len)
--       _str = _str .. string.sub(str,1, index).."\n"
--       str = string.sub(str, index+1, -1)
--       count = count + 1
--       index =  1
--       print("下一个字符大于了长度")
--     end
--   end
--   print(_str)
--   return _str, count
-- end
-------------------------------------------------------------------
----返回一个枚举函数，枚举第一个数为number，默认为1
-------------------------------------------------------------------
function getEnumFunction(number)
  local n = number or 0
  if number == n then
    n = n - 1
  end
  return function ()
    n = n + 1
    return n
  end
end

-------------------------------------------------------------------
----弹框效果  参数 1节点 2缩小比例 3放大比例 4 缩放所需时间
-------------------------------------------------------------------
function setScaleWindow(node,stval,edval)

  if node == nil then 
    -- cclog("传入node为nil！！！！！！！！！！！！！！")
    return 
  end

  local layer = node 
  local act0 = cc.ScaleTo:create(0,0.8) 
  local act1 = cc.ScaleTo:create(0.08,stval) 
  local act2 = cc.ScaleTo:create(0.04,edval) 
  layer:runAction(cc.Sequence:create(act0,act1,act2));

end

function rectContainsPoint(rect, point)
  if (point.x >= rect.x) and (point.x <= rect.x + rect.width) and
     (point.y >= rect.y) and (point.y <= rect.y + rect.height) then
      return true
  end
  return false
end

-------------------------------------------------------------------
-- 是否存在屏蔽字
-- 存在则返回true
-- 不存在则返回false
-------------------------------------------------------------------
function isSensitive(str)
  local is
    for i, _str in pairs(g_TableShielding_word) do
      is = string.find(str, _str)
      if is then
        return true
      end
    end
    return false
end

-------------------------------------------------------------------
-- 替换屏蔽字
-- @返回替换后的字符串
-------------------------------------------------------------------
function replaceSensitive(str)
  local str = str or ""
  for i, _str in pairs(g_TableShielding_word) do
    str = string.gsub(str, _str, "*")
  end
  return str
end 
-------------------------------------------------------------------
----弹框效果  参数 1节点 2缩小比例 3放大比例 4 缩放所需时间
-------------------------------------------------------------------
-- function setChouQuTX(node,time)

--   if node == nil then 
--     cclog("传入node为nil！！！！！！！！！！！！！！")
--     return 
--   end

--   local layer = node 
--   local animation = clsAnimation.new()
--   animation:init(1097)
--   act0 = cc.DelayTime:create(1)
--   act1 = cc.CallFunc:create(function()
--     node:setVisible(false)
--   end)
--   local act2 = cc.ScaleTo:create(0,0) 
--   act3 = cc.CallFunc:create(function()

--     animation:registerCallBack(ANIMATION_CALLBACK_TYPE.TYPE_COMPLETE,function()
--     node:setVisible(true)
--     end)
--     animation:player(0,1,0)

    
--   end)
--   local act4 = cc.ScaleTo:create(time,1) 
--   layer:runAction(cc.Sequence:create(act1,act2,act3,act4,nil));

-- end

-------------------------------------------------------------------
----清空一个表
-------------------------------------------------------------------
function clearTable(t)
	if t == nil then
		return;
	end;
	
	local _tableCount = #t;
	if _tableCount == 0 then
		return
	end;
	
	for i = _tableCount,1,-1 do
		table.remove(t);
	end;
end;


-------------------------------------------------------------------
----从一个表中移除一个元素
-------------------------------------------------------------------
function removeObjFromTable(t,obj)
	if t == nil then
		return;
	end;
	
	for k,v in pairs(t) do
		if obj == v or obj:getUnitObjIndex() == k then
			table.remove(t,k);
		end;
	end;
end;


-------------------------------------------------------------------
----检查一个表中是否包含一个元素
-------------------------------------------------------------------
function tableContains(t,value)
	
	for k,v in ipairs(t) do
		if v == value then
			return true;
		end;
	end;
	return false;
end;



function getIntersectRect(rect1,rect2)
	if cc.rectIntersectsRect(rect1,rect2) == true then
		local tl_x,tl_y;
		local br_x,br_y;

		tl_x = math.max(rect1.x,rect2.x);
		tl_y = math.max(rect1.y,rect2.y);

		br_x = math.min(rect1.x + rect1.width,rect2.x + rect2.width);
		br_y = math.min(rect1.y + rect1.height,rect2.y + rect2.height);

		if tl_x > br_x or tl_y > br_y then
			return nil;
		end;
		
		local _retRect = cc.rect(tl_x,tl_y,br_x - tl_x,br_y - tl_y);
		return _retRect;
	end;
	
	return nil;
end;

