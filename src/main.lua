
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("res/")

require("config")
require("cocos.init")
require("framework.init")
require("utils")
require("global")
require("AStar")

require("mgr.XMLManager")
require("mgr.IOManager")
require("mgr.PathManager")
require("mgr.UIManager")
require('mgr.ReloadManager')
require("mgr.MapManager")
require("mgr.TiledMapManager")
require("mgr.LableManager")
require("mgr.LoadManager")
require("mgr.GameRes")
require "sproto.core"
print("++++++++++++++++++++++++++++123")


require("tools.AutoLine")
require("tools.Core")

LoadManager:loadData()
display.addSpriteFrames("SheetMapBattle.plist", "SheetMapBattle.png")
display.addSpriteFrames("SheetEditor.plist", "SheetEditor.png")

display.replaceScene(require("editor.EditorScene").new())
