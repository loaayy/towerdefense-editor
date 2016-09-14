
--[[--

    定义了所有的静态对象

]]

-- 工具栏中可选择都建筑对象

local MapConstants = require("app.map.MapConstants")

local StaticObjectsProperties = {}

local defines = {}

----------------------------------------

local object = {
    classId      = "static",
    framesName   = "IncreaseHp%04d.png",
    framesBegin  = 1,
    framesLength = 28,
    framesTime   = 1.0 / 28,
    radius       = 60,
    scale        = 2.0,
    offsetY      = 20,
    zorder       = 30000,
    viewZOrdered = false,
}
defines["IncreaseHp"] = object

----------------------------------------

local object = {
    classId     = "static",
    imageName   = "#Building01.png",
    radius      = 60,
    offsetX     = -10,
    offsetY     = 35,
    decorations = {},
    campId      = MapConstants.ENEMY_CAMP,
}
defines["Building01"] = object

----------------------------------------

local object = {
    classId     = "static",
    imageName   = {"#PlayerTower0101.png", "#PlayerTower0102.png"},
    radius      = 32,
    offsetX     = {-15, -16, -16},
    offsetY     = {3, 3, 2},
    towerId     = "PlayerTower01L01",
    decorations = {"PlayerTower01Destroyed"},
    behaviors   = {"TowerBehavior"},
    fireOffsetX = {0, 0, 0},
    fireOffsetY = {24, 24, 24},
    campId      = MapConstants.PLAYER_CAMP,
}
defines["PlayerTower01"] = object

local object = {
    classId     = "static",
    imageName   = {"#PlayerTower0201.png", "#PlayerTower0202.png"},
    radius      = 32,
    offsetX     = {-15, -16, -16},
    offsetY     = {3, 3, 2},
    towerId     = "PlayerTower02L01",
    decorations = {"PlayerTower02Destroyed"},
    behaviors   = {"TowerBehavior"},
    fireOffsetX = {0, 0, 0},
    fireOffsetY = {24, 24, 24},
    campId      = MapConstants.PLAYER_CAMP,
}
defines["PlayerTower02"] = object

----------------------------------------

local object = {
    classId       = "static",
    radius        = 40,
    imageName     = "#EnemyShip01.png",
    radiusOffsetY = 30,
    offsetY       = 33,
    decorations   = {"ShipWavesUp", "ShipWaves"},
    behaviors     = {},
}
defines["EnemyShip01"] = object

----------------------------------------


---------------------------------------- 舰船

local object = {
    classId       = "static",
    radius        = 40,
    framesName      = "ShipWaveUpA%04d.png",
    framesBegin     = 1,            -- 从 ShipWaveUp0001.png 开始
    framesLength    = 16,           -- 一共有 16 帧
    framesTime      = 1.0 / 20,     -- 播放速度为每秒 20 帧

    -- 以下为都为可选设定
    zorder          = 1,            -- 在被装饰对象的 ZOrder 基础上 +1，默认值为 0
    playForever     = true,         -- 是否循环播放，默认值为 false
    autoplay        = true,         -- 是否自动开始播放，默认值为 false
    removeAfterPlay = false,        -- 播放一次后自动删除，仅当 playForever = false 时有效，默认值为 false
    hideAfterPlay   = false,        -- 播放一次后隐藏，仅当 playForever = false 时有效，默认值为 false
    visible         = true,         -- 是否默认可见，默认值为 true
    offsetX         = 0,            -- 图像的横向偏移量，默认值为 0
    offsetY         = -4,           -- 图像的纵向偏移量，默认值为 0
}
defines["ShipWavesUp"] = object

local object = {
    classId       = "static",
    radius        = 40,
    framesName   = "ShipWaveA%04d.png",
    framesBegin  = 1,
    framesLength = 16,
    framesTime   = 1.0 / 20,
    zorder       = -2,
    playForever  = true,
    autoplay     = true,
    offsetX      = 0,
    offsetY      = -4,
}
defines["ShipWaves"] = object

local object = {
    classId       = "static",
    radius        = 40,
    framesName      = "ShipExplode%04d.png",
    framesBegin     = 1,
    framesLength    = 12,
    framesTime      = 0.6 / 12,
    offsetX         = 14,
    offsetY         = 24,
    scale           = 2,
    zorder          = 5,
    delay           = 0.4,
    removeAfterPlay = true,
}
defines["ShipExplode"] = object

local object = {
    classId       = "static",
    radius        = 40,
    framesName      = "ShipExplodeSmall01%04d.png",
    framesBegin     = 1,
    framesLength    = 8,
    framesTime      = 0.35 / 8,
    offsetX         = 0,
    offsetY         = 24,
    zorder          = 6,
    scale           = 2,
    removeAfterPlay = true,
}
defines["ShipExplodeSmall01"] = object

local object = {
    classId       = "static",
    radius        = 40,
    framesName      = "ShipExplodeSmall02%04d.png",
    framesBegin     = 1,
    framesLength    = 6,
    framesTime      = 0.25 / 6,
    offsetX         = -6,
    offsetY         = 30,
    zorder          = 6,
    scale           = 1,
    removeAfterPlay = true,
}
defines["ShipExplodeSmall02"] = object

local object = {
    classId       = "static",
    radius        = 40,
    imageName = {"#PlayerTower0101Destroyed.png", "#PlayerTower0102Destroyed.png"},
    offsetX   = {-13, -14, -14},
    offsetY   = {5, 5, 5},
    visible   = false,
}
defines["PlayerTower01Destroyed"] = object

local object = {
    classId       = "static",
    radius        = 40,
    imageName = {"#PlayerTower0201Destroyed.png", "#PlayerTower0202Destroyed.png"},
    offsetX   = {-24, -24, -24},
    offsetY   = {10, 13, 12},
    visible   = false,
}
defines["PlayerTower02Destroyed"] = object

function StaticObjectsProperties.getAllIds()
    local keys = table.keys(defines)
    table.sort(keys)
    return keys
end

function StaticObjectsProperties.get(defineId)
    assert(defines[defineId], string.format("StaticObjectsProperties.get() - invalid defineId %s", tostring(defineId)))
    return clone(defines[defineId])
end

function StaticObjectsProperties.isExists(defineId)
    return defines[defineId] ~= nil
end

return StaticObjectsProperties
