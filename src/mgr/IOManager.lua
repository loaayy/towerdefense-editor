--
-- Author: Your Name
-- Date: 2015-08-26 14:38:05
--
local lfs = require("lfs")


IOManager = class("IOManager")


local ALL_FILES = {}
local ALL_IMG = {}

local FIND_PATH = nil

-- 获取某文件夹下所有子lua文件
function IOManager:getAllFiles()

    local path = ROOT_PATH.."src/"
    self:searchAllFile_( path )
    return ALL_FILES
end

function IOManager:getAllImg()

    local path = ROOT_PATH.."res/"
    self:searchAllFile_( path )
    return ALL_IMG
end


function IOManager:isHaveFile(fileName)

    local f = self:searchFilePath( fileName )

    if f then
        return true
    else
        return false
    end
end

-- 递归搜索某文件夹下所有子文件
function IOManager:searchAllFile_( path )
    if io.exists(path) == false then
        return
    end
    local lines = {}
    for file in lfs.dir(path) do

        if file ~= "." and file ~= ".." then
            local f = unpack(string.split(file, "."))
            local str = string.sub(file,#f + 1)
            if tostring(str) == ".lua" then
               
                ALL_FILES[#ALL_FILES + 1] = file 
            elseif tostring(str) == ".png" or tostring(str) == ".jpg" 
                or tostring(str) == ".tmx" or tostring(str) == ".plist" then
                ALL_IMG[#ALL_IMG + 1] = file
            else 
                
                local p = path..file.."/"
                self:searchAllFile_( p )
                  
            end
        end
    end
end

function IOManager:searchFilePath( fileName )

    local path = ROOT_PATH.."src/"
    local fileName = fileName
    self:searchFilePath_( path,fileName )

    return FIND_PATH
end

function IOManager:searchImgPath( fileName )

    local path = ROOT_PATH.."res/"
    local fileName = fileName
    self:searchFilePath_( path,fileName )

    return FIND_PATH
end

function IOManager:searchFilePath_( rootPath,fileName )

    if io.exists(rootPath) == false then
        return
    end

    local lines = {}
    local path = rootPath
    local _f = fileName
    local _p = {}
   
    for file in lfs.dir(path) do

        if file ~= "." and file ~= ".." then
            local f = unpack(string.split(file, "."))
            local str = string.sub(file,#f + 1)
            if tostring(str) == ".lua" then
               
            elseif tostring(str) == ".png" or tostring(str) == ".jpg" 
                or tostring(str) == ".tmx" or tostring(str) == ".plist" then
                
            else 
                
                local p = path..file.."/"

                self:searchFilePath_(p, _f)
                
            end

            if tostring(f) == _f then

                FIND_PATH = path

            end
            
        end
    end
  
end

function IOManager:searchLuaFile( path )
	local lines = {}
	for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = unpack(string.split(file, "."))
            local str = string.sub(file,#f + 1)
            if tostring(str) == ".lua" then
                --print(file)
                lines[#lines + 1] = file 
                
            end
        end
    end
    return lines
end


-- 只提供给切换地图功能，搜索地图资源
function IOManager:searchImgFile( path )
	local lines = {}
	for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = unpack(string.split(file, "."))
            local str = string.sub(file,#f + 1)
            if tostring(str) == ".png" or tostring(str) == ".jpg" 
                or tostring(str) == ".tmx" then
                --print(file)
                lines[#lines + 1] = file 
                
            end
        end
    end
    return lines
end


return IOManager