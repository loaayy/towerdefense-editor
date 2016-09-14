--
-- Author: Your Name
-- Date: 2015-08-30 00:55:28
--


COLOR = {

	PURPLE = cc.c4b(117,41,105,255),
	
	GREEN = cc.c4b(58,179,42,255),

	RED = cc.c4b(199,23,23,255),

	YELLOW = cc.c4b(228,164,56,255),

	BLACK = cc.c4b(56,22,13,255),

}

-- print table
function printTab(tab)
  for i,v in pairs(tab) do
    if type(v) == "table" then
      print("table",i..":","{")
      printTab(v)
      print("}")
    else
     print(v)
    end
  end
end