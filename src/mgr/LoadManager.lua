--
-- Author: Your Name
-- Date: 2015-09-28 03:23:38
--
LoadManager = class("LoadManager")


function LoadManager:loadData()

	print("loading...")
    local layers = {
        
        -- {SheetMapBattle_plist,SheetMapBattle_png},
        -- {SheetEditor_plist,SheetEditor_png},
        {img_1_achievements_plist,img_1_achievements_png},
        {img_1_barsheet_plist,img_1_barsheet_png},
        {img_1_border_plist,img_1_border_png},
        {img_1_gplus_plist,img_1_guard_png},
        {img_1_spritesheet_plist,img_1_spritesheet_png},
        {img_1_thingy_plist,img_1_thingy_png},
        

    }

    local co = coroutine.create(function()
        for i,v in ipairs(layers) do

            local percent = math.ceil(i / #layers * 100)
            print(percent)

            display.addSpriteFrames(v[1],v[2])
          
            -- 加载完成做的动作
            if i == #layers then
                self._scheduler.unscheduleGlobal(self._sc)
                self._sc = nil
                self._scheduler = nil
                print("load img done!!!")

                return true
            end

            coroutine.yield()
        end
    end)

   
    local frame = cc.Director:getInstance():getAnimationInterval()
    self._scheduler = require("framework.scheduler")
    self._sc = self._scheduler.scheduleGlobal(function()

        coroutine.resume(co)

    end,frame)
    
    
end
