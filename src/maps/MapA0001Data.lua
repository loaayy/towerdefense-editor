
------------ MapA0001Data ------------

local map = {}

map.size = {width = 1600, height = 1000}
map.imageName = "MapA0001Bg.png"
map.eventName = "MapA0001Events"
map.pathGrid = {{1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,},{0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,},{0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,},{0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,},{0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,},{0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,},{0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,},{0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,},{0,1,1,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,},{0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,},{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,},{0,1,1,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,},{0,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,},{0,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},}


local objects = {}
--⬆️⬆️⬆️⬆️⬆️⬆️不可删除⬆️⬆️⬆️⬆️⬆️⬆️--

local object = {
    points = {
        {1115,  817}, {1058,  854}, { 992,  878}, { 902,  890}, { 863,  892}, { 811,  885},
        { 773,  871}, { 748,  849}, { 733,  828}, { 720,  810}, { 713,  790}, { 711,  771},
        { 717,  741}, { 727,  709}, { 748,  662}, { 778,  610}, { 811,  569}, { 846,  535},
        { 876,  501}, { 910,  454}, { 944,  405}, { 972,  352}, { 986,  330}, { 998,  322},
        {1020,  318}, {1047,  317}, {1090,  330}, {1142,  344}, {1181,  352}, {1230,  356},
        {1269,  352}, {1329,  331}, {1375,  304}, {1395,  281}, {1407,  254}, {1407,  231},
        {1404,  214}, {1395,  174}, {1385,  145}, {1373,  123},
     }
}
objects["path:1"] = object

----

local object = {
    points = {
        { 230,  559}, { 209,  521}, { 198,  493}, { 190,  472}, { 182,  438}, { 182,  404},
        { 187,  371}, { 196,  343}, { 210,  319}, { 229,  295}, { 255,  269}, { 283,  249},
        { 319,  235}, { 365,  227}, { 422,  221}, { 476,  225}, { 518,  233}, { 556,  245},
        { 581,  254}, { 598,  257}, { 626,  256}, { 649,  247}, { 692,  240}, { 742,  233},
        { 802,  233}, { 853,  238}, { 893,  252}, { 933,  267}, { 977,  288}, {1017,  301},
        {1053,  311}, {1090,  324}, {1123,  333}, {1162,  344}, {1206,  350}, {1250,  349},
        {1291,  340}, {1344,  317}, {1383,  289}, {1399,  262}, {1402,  243}, {1397,  193},
        {1388,  159}, {1370,  127},
     }
}
objects["path:2"] = object

----

local object = {
    points = {
        { 379,  673}, { 400,  637}, { 427,  611}, { 465,  622}, { 487,  652}, { 490,  688},
        { 470,  721}, { 444,  718}, { 421,  708}, { 415,  679}, { 429,  652}, { 455,  650},
        { 465,  677}, { 464,  702}, { 441,  699}, { 439,  686}, { 445,  677},
     }
}
objects["path:4"] = object

----

local object = {
    points = {
        { 243,  745}, { 240,  655}, { 333,  656}, { 334,  744}, { 265,  741}, { 263,  676},
        { 312,  676}, { 304,  727}, { 287,  720}, { 286,  692},
     }
}
objects["path:6"] = object

----

local object = {
   y = 101,
   x = 1375,
   radius = 51,
   tag = 0,
}
objects["range:21"] = object

----

local object = {
   y = 573,
   x = 781,
   radius = 80,
   tag = 0,
}
objects["range:23"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 588,
   towerId = 'PlayerTower02L01',
   defineId = 'PlayerTower02',
   y = 177,
   tag = 0,
}
objects["static:11"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 180,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 478,
   tag = 0,
}
objects["static:12"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 698,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 350,
   tag = 0,
}
objects["static:14"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 782,
   towerId = 'PlayerTower02L01',
   defineId = 'PlayerTower02',
   y = 359,
   tag = 0,
}
objects["static:15"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 684,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 946,
   tag = 0,
}
objects["static:16"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 1008,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 774,
   tag = 0,
}
objects["static:17"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 853,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 787,
   tag = 0,
}
objects["static:18"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 616,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 799,
   tag = 0,
}
objects["static:19"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 628,
   towerId = 'PlayerTower02L01',
   defineId = 'PlayerTower02',
   y = 662,
   tag = 0,
}
objects["static:20"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'MovableBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   towerId = 'PlayerTower02L01',
   y = 259,
   campId = 1,
   x = 116,
   bindingMovingForward = true,
   defineId = 'PlayerTower02',
   tag = 0,
}
objects["static:22"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'MovableBehavior',
         'NPCBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   npcId = 'NPC001',
   y = 519,
   campId = 2,
   x = 459,
   bindingMovingForward = true,
   defineId = 'EnemyShip01',
   tag = 0,
}
objects["static:26"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'MovableBehavior',
         'NPCBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   npcId = 'NPC001',
   y = 139,
   campId = 2,
   x = 744,
   bindingMovingForward = true,
   defineId = 'EnemyShip01',
   tag = 0,
}
objects["static:28"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'MovableBehavior',
         'NPCBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   npcId = 'NPC001',
   y = 469,
   campId = 2,
   x = 327,
   bindingMovingForward = true,
   defineId = 'Building01',
   tag = 0,
}
objects["static:29"] = object

----

local object = {
   y = 91,
   x = 1367,
   defineId = 'Building01',
   flipSprite = false,
   tag = 0,
}
objects["static:3"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'MovableBehavior',
         'NPCBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   npcId = 'NPC001',
   y = 544,
   campId = 2,
   x = 57,
   bindingMovingForward = true,
   defineId = 'PlayerTower02Destroyed',
   tag = 0,
}
objects["static:30"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'MovableBehavior',
         'NPCBehavior',
         'PlayerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   npcId = 'NPC001',
   y = 277,
   campId = 2,
   x = 435,
   bindingMovingForward = true,
   defineId = 'ShipExplodeSmall01',
   tag = 0,
}
objects["static:32"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 872,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 352,
   tag = 0,
}
objects["static:4"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 1009,
   towerId = 'PlayerTower02L01',
   defineId = 'PlayerTower02',
   y = 548,
   tag = 0,
}
objects["static:7"] = object

----

local object = {
   behaviors = {
         'CampBehavior',
         'CollisionBehavior',
         'DecorateBehavior',
         'DestroyedBehavior',
         'FireBehavior',
         'TowerBehavior',
   },
   decorationsMore = {
   },
   flipSprite = false,
   collisionEnabled = true,
   campId = 1,
   x = 568,
   towerId = 'PlayerTower01L01',
   defineId = 'PlayerTower01',
   y = 432,
   tag = 0,
}
objects["static:9"] = object

----
--⬇️⬇️⬇️⬇️⬇️⬇️不可删除⬇️⬇️⬇️⬇️⬇️⬇️--
map.objects = objects

return map
