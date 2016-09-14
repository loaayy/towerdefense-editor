

-- 画线条工具类

-- 重新封装cc函数
cc.c4fFromc4b = function (c4b)
	return cc.c4f(c4b.r/255.0, c4b.g/0.0, c4b.b/255.0, c4b.a/255.0)
end

-- SpriteBatchNode
cc.Node.reorderChild = function(self, sp, zorder)
	sp:setLocalZOrder(zorder)
end

utils = {}

-- 判断cc是否有NVGDrawNode,有则创建
if cc.NVGDrawNode then
	utils.useNVGDrawNode = true
end

-- 画圆
function utils.drawCircle(radius, params)
  
	if utils.useNVGDrawNode then
		params = params or {}
		local posX = params.x or 0
        local posY = params.y or 0
        local borderColor = params.borderColor or cc.c4f(1, 1, 1, 1)

		local drawNode = cc.NVGDrawNode:create()
		drawNode:setLineWidth(0.5)
		drawNode:drawCircle(cc.p(posX, posY), radius, borderColor)

		return drawNode
	else
		return display.newCircle(radius, params)
	end
end

-- 画矩形
function utils.drawRect(rect, params)
	if not rect then
	end

	if utils.useNVGDrawNode then
		params = params or {}
        local borderColor = params.borderColor or cc.c4f(1, 1, 1, 1)

		local drawNode = cc.NVGDrawNode:create()
		if params.borderWidth then
			drawNode:setLineColor(params.borderWidth)
		end
		if params.fillColor then
			drawNode:setFillColor(params.fillColor)
			drawNode:setFill(true)
		end
		drawNode:drawRect(cc.p(rect.x, rect.y),
			cc.p(rect.x, rect.y + rect.height),
			cc.p(rect.x + rect.width, rect.y + rect.height),
			cc.p(rect.x + rect.width, rect.y),
			borderColor)

		return drawNode
	else
		return display.newRect(radius, params)
	end
end

-- 点连线
function utils.drawPolygon(points)
	if utils.useNVGDrawNode then

		-- 线条集合
		local path = {}

		-- 画线核心
		for _, v in ipairs(points) do
			table.insert(path, cc.p(v[1], v[2]))
		end

		params = params or {}
        local borderColor = params.borderColor or cc.c4f(1, 1, 1, 1)

		local drawNode = cc.NVGDrawNode:create()
		drawNode:setLineWidth(0.5)
		drawNode:drawPolygon(path, #path, false, borderColor);

		return drawNode
	else
		return display.newPolygon(points)
	end
end

-- 创建简单的字体
function utils.createLabel(label,parent,pos)

	local ttf = cc.LabelTTF:create(label,"黑体",20)
    ttf:setPosition(pos)
    ttf:setColor(cc.c3b(255,0,0))
    parent:addChild(ttf,999)

    return ttf

end

-- 将表里的数据倒转
function utils.reverseTab(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

-- 震动
function utils:shake(target)
    local time = 0.1
    local actions = {}
    actions[#actions + 1] = cc.MoveBy:create(time/2, cc.p(-5, 0))
    actions[#actions + 1] = cc.MoveBy:create(time, cc.p(10, 0))
    actions[#actions + 1] = cc.MoveBy:create(time, cc.p(-10, 0))
    actions[#actions + 1] = cc.MoveBy:create(time, cc.p(5, 0))
    local seq = transition.sequence(actions)
    target:runAction(seq)
end


-- 查找一个子结点
function utils.seekNodeByName(parent, name)
  if not parent then
    return
  end

  if name == parent.name then
    return parent
  end

  local findNode
  local children = parent:getChildren()
  local childCount = parent:getChildrenCount()
  if childCount < 1 then
    return
  end
  for i=1, childCount do
    if "table" == type(children) then
      parent = children[i]
    elseif "userdata" == type(children) then
      parent = children:objectAtIndex(i - 1)
    end

    if parent then
      if name == parent:getName() then
        return parent
      end
    end


  end

  for i=1, childCount do
    if "table" == type(children) then
      parent = children[i]
    elseif "userdata" == type(children) then
      parent = children:objectAtIndex(i - 1)
    end

    if parent then
      findNode = Utils.seekNodeByName(parent, name)
      if findNode then
        return findNode
      end
    end

  end

  return

end


-- 设置某个函数延时执行
function utils.delayExecute(target, func, delay)
    local wait = cc.DelayTime:create(delay)
    target:runAction(cc.Sequence:create(wait, cc.CallFunc:create(func)))
end



function utils.newButton(imageName, listener, setAlpha)
    local sprite = display.newScale9Sprite(imageName)
    if setAlpha == nil then setAlpha = true end

    sprite:setTouchEnabled(true)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            if setAlpha then 

            	sprite:setOpacity(128) 
            
            end
            return true
        end

        local touchInSprite = sprite:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y))
        if event.name == "moved" then
            if touchInSprite then
                if setAlpha then sprite:setOpacity(128) end
            else
                sprite:setOpacity(255)
            end
        elseif event.name == "ended" then
            if touchInSprite then listener() end
            sprite:setOpacity(255)
        else
            sprite:setOpacity(255)
        end
    end)

    return sprite
end




