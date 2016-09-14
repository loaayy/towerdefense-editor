--
-- Author: Your Name
-- Date: 2015-10-05 14:10:40
--
--[[
===============
ChatSence
聊天系统模块
===============
]]--

-- 类
local ChatLayer = {}
ChatLayer.uiLayer = nil
ChatLayer.widget = nil

-- 窗口大小
local winSize = nil

-- 获得UI界面上的3个按钮
local worldButton = nil
local partyButton = nil
local chatButton = nil

-- 获得三个每个按钮对应的三个面板
local wordPanel = nil
local partyPanel = nil
local chatPanel = nil

-- 获得每个面板的ListView
local worldList = nil
local partyList = nil
local chatList = nil

-- 列表项
local listview_item = nil
local head_icon = nil
local level = nil
local name = nil
local text = nil

-- 列表项个数
local items_count = nil

-- 获得输入框
local inputBox = nil
local sendButton = nil

-- 弹出对话框
local dialog = nil
local chat = nil
local lahei = nil
local closeButton = nil

-- 三个标记
local flag = nil
local TAG_WORLD = 1 -- 标识世界
local TAG_PARTY = 2 -- 标识公会
local TAG_CHAT = 3 -- 标识私聊

-- 一些按钮的Tag
local TAG_WORLD_BUTTON = 1
local TAG_PARTY_BUTTON = 2
local TAG_CHAT_BUTTON = 3
local TAG_SEND_BUTTON = 4
local TAG_CHAT_BUTTON2 = 5
local TAG_LAHEI_BUTTON = 6
local TAG_CLOSE_BUTTON = 7



--[[
touchEvent
触摸事件回调方法
]]--
local function touchEvent( sender, eventType )
    if sender:getTag() == TAG_WORLD_BUTTON then
        wordPanel:setVisible(true)
        partyPanel:setVisible(false)
        chatPanel:setVisible(false)
        dialog:setVisible(false)
        ChatLayer.setCurrentTag( TAG_WORLD )
    elseif sender:getTag() == TAG_PARTY_BUTTON then
        partyPanel:setVisible(true)
        wordPanel:setVisible(false)
        chatPanel:setVisible(false)
        dialog:setVisible(false)
        ChatLayer.setCurrentTag( TAG_PARTY )
    elseif sender:getTag() == TAG_CHAT_BUTTON then
        partyPanel:setVisible(false)
        wordPanel:setVisible(false)
        chatPanel:setVisible(true)
        dialog:setVisible(false)
        ChatLayer.setCurrentTag( TAG_CHAT )
    elseif sender:getTag() == TAG_SEND_BUTTON then
        print("sendText...")
        -- 获得输入框的文本
        local value = inputBox:getStringValue()
        local textView = ccui.Text:create(value,"Arial",20)
        print("value:"..value)
        if eventType == ccui.TouchEventType.began then
--            local custom_text = ChatLayer.RichText()
            local custom_item = ccui.Layout:create()
            custom_item:setContentSize( textView:getContentSize() )
            textView:setPosition( cc.p( custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0 ) )
            custom_item:addChild( textView )
            -- 如果当前Tag为世界
            if ChatLayer.getCurrentTag() == TAG_WORLD then
                -- 插入自定义项
                worldList:insertCustomItem( custom_item, 0 )
                --                worldList:addChild(custom_item)
            elseif ChatLayer.getCurrentTag() == TAG_PARTY then
                --                partyList:addChild(custom_item)
                partyList:insertCustomItem( custom_item, 0 )
            elseif ChatLayer.getCurrentTag() == TAG_CHAT then
                --                chatList:addChild(custom_item)
                chatList:insertCustomItem( custom_item, 0 )
            end
        end
    elseif sender:getTag() == TAG_CHAT_BUTTON2 then
        partyPanel:setVisible(false)
        wordPanel:setVisible(false)
        chatPanel:setVisible(true)
        dialog:setVisible(false)
    elseif sender:getTag() == TAG_LAHEI_BUTTON then
        print("我就把你拉黑，逗比")
    elseif sender:getTag() == TAG_CLOSE_BUTTON then
        dialog:setVisible(false)
    elseif sender:getTag() == 8 then
        if eventType == ccui.TouchEventType.ended then
            ChatLayer.widget:setVisible( not ChatLayer.widget:isVisible() )
        end
    end
end

local function onExit(strEventName)
    ChatLayer.uiLayer:release()
    ChatLayer.uiLayer = nil
end

--[[
=================
addOpenButton
添加一个打开的按钮
=================
]]--
function ChatLayer.addOpenButton()
    local openButton = ccui.Button:create() -- 创建一个按钮
    openButton:setTouchEnabled(true)-- 设置可触摸
    openButton:loadTextures( "cocosui/animationbuttonnormal.png", "cocosui/animationbuttonpressed.png", "" )--加载纹理
    openButton:setAnchorPoint( cc.p( 0, 0 ) )
    openButton:setPosition( cc.p( winSize.width -100, winSize.height - 50 ) )
    ChatLayer.uiLayer:addChild(openButton, 1)
    openButton:setTag(8)
    openButton:addTouchEventListener(touchEvent)
end

--[[
==============
textFieldEvent
输入框监听事件回调方法
==============
]]--
local function textFieldEvent(sender, eventType)
    if eventType == ccui.TextFiledEventType.attach_with_ime then
        print("attach_with_ime")
    elseif eventType == ccui.TextFiledEventType.detach_with_ime then
        print("detach_with_ime")
    elseif eventType == ccui.TextFiledEventType.insert_text then
        print("insert_text")
    elseif eventType == ccui.TextFiledEventType.delete_backward then
        print("delete_backward")

    end
end


-- ListView点击事件回调
local function listViewEvent(sender, eventType)
    -- 事件类型为点击结束
    if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        print("select child index = ",sender:getCurSelectedIndex())
        if dialog:isVisible() == true then
            dialog:setVisible(false)
        else
            ChatLayer.showDialog()
        end
    end
end

-- 滚动事件方法回调
local function scrollViewEvent(sender, eventType)
    -- 滚动到底部
    if eventType == ccui.ScrollviewEventType.scrollToBottom then
        print("SCROLL_TO_BOTTOM")
        -- 滚动到顶部
    elseif eventType == ccui.ScrollviewEventType.scrollToTop then
        print("SCROLL_TO_TOP")
    end

end

--[[
====================
createChatLayer
创建聊天层
====================
]]--
function ChatLayer.create()

    ChatLayer.uiLayer = cc.Layer:create()-- 创建ui层
    print("getReferenceCount1:"..ChatLayer.uiLayer:getReferenceCount())
    winSize = cc.Director:getInstance():getWinSize()-- 获得屏幕大小

    ChatLayer.setCurrentTag(TAG_WORLD)
    ChatLayer.addOpenButton()
    ChatLayer.findViews()
    -- ChatLayer.setTouchEnabled()
    -- ChatLayer.setTags()
    -- ChatLayer.addTouchEventListener()


    -- 初始化三组数据
    local array = {}
    for i = 1, 2 do
        array[i] = string.format("请叫我巫大大asdadaa u s da d ha j%d", i - 1)
    end

    local array1 = {}
    for i = 1, 2 do
        array1[i] = string.format("公会开放啦%d", i - 1 )
    end

    local array2 = {}
    for i = 1, 2 do
        array2[i] = string.format("私聊列表项%d", i - 1 )
    end


    -- 创建模型
    local default_button = ccui.Button:create("cocosui/backtotoppressed.png", "cocosui/backtotopnormal.png")
    default_button:setName("Title Button")

    -- 创建默认item
    local default_itme = ccui.Layout:create()
    default_itme:setTouchEnabled(true)
    default_itme:setContentSize(default_button:getContentSize())
    default_button:setPosition(cc.p( default_itme:getContentSize().width / 2.0, default_itme:getContentSize().height / 2.0 ))
    default_itme:addChild(default_button)

    -- 设置模型
    worldList:setItemModel(default_itme)
    
    
    
    -- 这里是5项
    --    for i = 1, math.floor( count / 4 ) do
    --        print("i:"..i)
    --        --  压栈一个默认项(通过克隆创建的)进listView.
    --        worldList:pushBackDefaultItem()
    --    end
    --
    --    -- 插入默认项
    --    for i = 1, math.floor( count / 4 ) do
    --        -- 插入一个默认项(通过克隆创建的)进listView.
    --        worldList:insertDefaultItem(0)
    --    end

    --使用cleanup清空容器（container）中的所有子节点（children）
    --    worldList:removeAllChildren()

    --    local testSprite = cc.Sprite:create("cocosui/backtotoppressed.png")
    --    testSprite:setPosition(cc.p(200,200))
    --    worldList:addChild(testSprite)


    -- 获得数组的大小
    local count = table.getn(array)
    print("count:"..count)
    -- 添加自定义item
    for i = 1, count do
        -- 创建一个Button
        local custom_button = ccui.Button:create("cocosui/button.png", "cocosui/buttonHighlighted.png")
        -- 设置Button名字
        custom_button:setName("Title Button")
        --  设置按钮使用九宫（scale9）渲染器进行渲染
        custom_button:setScale9Enabled(true)
        -- 设置内容尺寸
        custom_button:setContentSize(default_button:getContentSize())

        -- 创建一个布局
        local custom_item = ccui.Layout:create()
        -- 设置内容大小
        custom_item:setContentSize(custom_button:getContentSize())
        -- 设置位置
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        -- 往布局中添加一个按钮
        custom_item:addChild(custom_button)
        -- 往ListView中添加一个布局
        worldList:addChild(custom_item)

    end

    --    local function customButtonListener(sender, touchType)
    --        if sender:getTag() == 1 then
    --            dialog:setVisible(true)
    --        end
    --    end


    for i = 1, 20 do
        local custom_button = ccui.Button:create("cocosui/button.png", "cocosui/buttonHighlighted.png")
        custom_button:setName("wwj")
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0) )
        custom_item:addChild(custom_button)
        partyList:addChild(custom_item)
    end

    for i = 1, 20 do
        local custom_button = ccui.Button:create( "cocosui/button.png", "cocosui/buttonHighlighted.png" )
        custom_button:setName("wwj")
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize( default_button:getContentSize() )

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize( custom_button:getContentSize() )
        custom_button:setPosition( cc.p( custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0 ) )
        custom_item:addChild( custom_button )
        chatList:addChild( custom_item )
    end

    for i = 1, 5 do
        local custom_text = ChatLayer.RichText()

        local custom_item = ccui.Layout:create()
        custom_item:setTouchEnabled(true)
        custom_item:setContentSize( custom_text:getContentSize() )
        custom_text:setPosition( cc.p( custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0) )
        custom_item:addChild( custom_text )
        chatList:addChild( custom_item )


--        local custom_button = ccui.Button:create("cocosui/button.png", "cocosui/buttonHighlighted.png")
--        custom_button:setName("wwj")
--        custom_button:setScale9Enabled(true)
--        custom_button:setContentSize(default_button:getContentSize())

        --        local custom_item2 = ccui.Layout:create()
        --        custom_item2:setContentSize(custom_button:getContentSize())
        --        custom_button:setPosition(cc.p(custom_item2:getContentSize().width / 0.6, custom_item2:getContentSize().height / 0.6) )
        --        custom_item2:addChild(custom_button)
        --        custom_button:setTag(i)
        --        custom_button:addTouchEventListener(customButtonListener)
        --        chatList:addChild(custom_item2)

    end

    -- 插入自定义item
    local items = worldList:getItems()--返回项的集合
    -- 获得项的个数
    local items_count = table.getn(items)
    --    for i = 1, math.floor( count / 4 ) do
    --        local custom_button = ccui.Button:create("cocosui/button.png", "cocosui/buttonHighlighted.png")
    --        custom_button:setName("Title Button")--改变widget的名字，使用名字可以更轻松地识别出该widget
    --        custom_button:setScale9Enabled(true)-- 设置按钮使用九宫（scale9）渲染器进行渲染
    --        custom_button:setContentSize(default_button:getContentSize())
    --
    --        local custom_item = ccui.Layout:create()
    --        custom_item:setContentSize(custom_button:getContentSize())
    --        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
    --        custom_item:addChild(custom_button)
    --        custom_item:setTag(1)
    --        worldList:insertCustomItem(custom_item, items_count)
    --    end

    -- 设置item data
    items_count = table.getn(worldList:getItems())
    for i = 1, items_count do
        -- 返回一个索引和参数相同的项.
        local item = worldList:getItem( i - 1 )
        local button = item:getChildByName("Title Button")
        local index = worldList:getIndex(item)
        button:setTitleText(array[index + 1])
    end

    local partyListItems_count = table.getn(partyList:getItems())
    for i = 1, partyListItems_count do
        local item = partyList:getItem( i - 1 )
        local button = item:getChildByName("wwj")
        local index = partyList:getIndex(item)
        button:setTitleText(array1[index + 1])

    end

    local chatListItems_count = table.getn(chatList:getItems())
    for i = 1, 20 do
        local item = chatList:getItem( i - 1 )
        local button = item:getChildByName( "wwj" )
        local index = chatList:getIndex( item )
        button:setTitleText( array2[ index + 1 ] )
    end

    -- 移除Tag=1的子节点
    --    worldList:removeChildByTag(1)

    -- 移除项by index
    --    items_count = table.getn(worldList:getItems())
    -- worldList:removeItem(items_count - 1)

    -- 设置ListView对齐方式为横向居中
    worldList:setGravity(ccui.ListViewGravity.centerVertical)
    --set items margin
    worldList:setItemsMargin(2.0)
    worldList:setBounceEnabled(true)
    -- 设置ListView对齐方式为横向居中
    partyList:setGravity(ccui.ListViewGravity.centerVertical)
    --set items margin
    partyList:setItemsMargin(2.0)

    inputBox:addEventListener(textFieldEvent)

    ChatLayer.uiLayer:addChild(ChatLayer.widget)
    ChatLayer.widget:setVisible(false)
    --    ChatLayer.uiLayer:registerScriptHandler(onExit)

    return ChatLayer.uiLayer
end

local function ListViewItem()
    local layout = ccui.Layout:create()

    layout:setSizePercent( cc.p( 200, 200 ) )
    layout:setBackGroundColorType( ccui.LayoutBackGroundColorType.solid )
    layout:setBackGroundColor(cc.c3b(255,0,0))

    local image = ccui.ImageView:create("")
    layout:addChild(image)
    return layout
end


local function loadListViewItemFromJson()
    listview_item = ccs.GUIReader:getInstance():widgetFromJsonFile( "listview_item/listview_item.ExportJson" )
    head_icon = listview_item:getChildByTag( 6 )
    level = listview_item:getChildByTag( 7 )
    name = listview_item:getChildByTag( 8 )
    text = listview_item:getChildByTag( 9 )
end


--[[
===================
设置相关标记
===================
]]--
function ChatLayer.setTags()
    worldButton:setTag(TAG_WORLD_BUTTON)
    partyButton:setTag(TAG_PARTY_BUTTON)
    chatButton:setTag(TAG_CHAT_BUTTON)
    sendButton:setTag(TAG_SEND_BUTTON)
    chat:setTag(TAG_CHAT_BUTTON2)
    lahei:setTag(TAG_LAHEI_BUTTON)
    closeButton:setTag(TAG_CLOSE_BUTTON)
end


--[[
============================
findViews()
找到UI控件
============================
]]--
function ChatLayer.findViews()
    ChatLayer.widget = ccs.GUIReader:getInstance():widgetFromJsonFile( "ChatUI_1/ChatUI_1.json" )
    ChatLayer.widget:setPosition( cc.p( 40, 40 ) )

    loadListViewItemFromJson()
    -- 获得UI界面上的3个按钮
    worldButton = ChatLayer.widget:getChildByTag(6)
    partyButton = ChatLayer.widget:getChildByTag(7)
    chatButton = ChatLayer.widget:getChildByTag(8)

    -- 获得三个每个按钮对应的三个面板
    wordPanel = ChatLayer.widget:getChildByTag(5)
    partyPanel = ChatLayer.widget:getChildByTag(9)
    chatPanel = ChatLayer.widget:getChildByTag(10)

    -- 获得每个面板的ListView
    worldList = wordPanel:getChildByTag(13)
    partyList = partyPanel:getChildByTag(14)
    chatList = chatPanel:getChildByTag(15)

    -- 获得输入框
    inputBox = ChatLayer.widget:getChildByTag(11)
    sendButton = ChatLayer.widget:getChildByTag(12)

    dialog = ChatLayer.widget:getChildByTag(20)
    chat = dialog:getChildByTag(21)
    lahei = dialog:getChildByTag(22)
    closeButton = dialog:getChildByTag(27)
end

--[[
==================
addTouchEventListener
添加触摸事件
==================
]]--
function ChatLayer.addTouchEventListener()
    -- 设置按钮监听事件
    worldButton:addTouchEventListener(touchEvent)
    partyButton:addTouchEventListener(touchEvent)
    chatButton:addTouchEventListener(touchEvent)
    sendButton:addTouchEventListener(touchEvent)
    chat:addTouchEventListener(touchEvent)
    lahei:addTouchEventListener(touchEvent)
    closeButton:addTouchEventListener(touchEvent)

    -- 设置ListView的监听事件
    worldList:addScrollViewEventListener(scrollViewEvent)
    worldList:addEventListener(listViewEvent)
    partyList:addScrollViewEventListener(scrollViewEvent)
    partyList:addEventListener(listViewEvent)
    chatList:addScrollViewEventListener(scrollViewEvent)
    chatList:addEventListener(listViewEvent)
    
    --- 键盘事件监听回调方法
    local function onkeyPressed(keycode, event)
        print("keypress")
        if keycode == cc.KeyCode.KEY_BACKSPACE then
           local str = inputBox:getStringValue()
            str = string.sub( str, 0, string.len( str ) - 1 )
            inputBox:setText( str )        
        end
    end
    
    -- 键盘监听事件
    local keyListener = cc.EventListenerKeyboard:create()
    keyListener:registerScriptHandler(onkeyPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    local eventDispatcher = ChatLayer.uiLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(keyListener, ChatLayer.uiLayer)
end


--[[
==================
RichText
富文本
=================
]]--
function ChatLayer.RichText()
    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(100, 100))

    local re1 = ccui.RichElementText:create( 1, cc.c3b(255, 255, 255), 255, "This color is white. ", "Helvetica", 10 )
    local re2 = ccui.RichElementText:create( 2, cc.c3b(255, 255,   0), 255, "And this is yellow. ", "Helvetica", 10 )
    local re3 = ccui.RichElementText:create( 3, cc.c3b(0,   0, 255), 255, "This one is blue. ", "Helvetica", 10 )
    local re4 = ccui.RichElementText:create( 4, cc.c3b(0, 255,   0), 255, "And green. ", "Helvetica", 10 )
    local re5 = ccui.RichElementText:create( 5, cc.c3b(255,  0,   0), 255, "Last one is red ", "Helvetica", 10 )

    local reimg = ccui.RichElementImage:create( 6, cc.c3b(255, 255, 255), 255, "cocosui/sliderballnormal.png" )

    -- 添加ArmatureFileInfo, 由ArmatureDataManager管理
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo( "cocosui/100/100.ExportJson" )
    local arr = ccs.Armature:create( "100" )
    arr:getAnimation():play( "Animation1" )

    local recustom = ccui.RichElementCustomNode:create( 1, cc.c3b(255, 255, 255), 255, arr )
    local re6 = ccui.RichElementText:create( 7, cc.c3b(255, 127,   0), 255, "Have fun!! ", "Helvetica", 10 )
    richText:pushBackElement(re1)
    richText:insertElement(re2, 1)
    richText:pushBackElement(re3)
    richText:pushBackElement(re4)
    richText:pushBackElement(re5)
    richText:insertElement(reimg, 2)
    richText:pushBackElement(recustom)
    richText:pushBackElement(re6)

    richText:setLocalZOrder(10)

    return richText
end

local function textFieldCompleteHandler()

end


--[[
=====================
setTouchEnabled
设置一些控件可触摸
====================
]]--
function ChatLayer.setTouchEnabled()
    -- 设置可触摸
    worldButton:setTouchEnabled(true)
    partyButton:setTouchEnabled(true)
    chatButton:setTouchEnabled(true)
    sendButton:setTouchEnabled(true)
    chat:setTouchEnabled(true)
    lahei:setTouchEnabled(true)
    closeButton:setTouchEnabled(true)
    inputBox:setTouchEnabled(true)
end

--[[
=================
setCurrentTag
设置当前Tag
=================
]]--
function ChatLayer.setCurrentTag(tag)
    flag = tag;
end

--[[
================
获得当前Tag
===============
]]--
function ChatLayer.getCurrentTag()
    return flag
end

--[[
===============
显示dialogs
===============
]]--
function ChatLayer.showDialog()
    local popup  = cc.Sequence:create(cc.ScaleTo:create( 0.0, 0.0 ),
        cc.ScaleTo:create( 0.06, 1.05 ),
        cc.ScaleTo:create( 0.08, 0.95 ),
        cc.ScaleTo:create( 0.08, 1.0 ),
        nil)
    dialog:setVisible(true)
    dialog:runAction( popup )
end


-- 返回场景
return ChatLayer
