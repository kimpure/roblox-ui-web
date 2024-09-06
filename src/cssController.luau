--!strict
local getCss = require'./getCss';

type cssControllerImpl = {
    frame: (frame: Frame) -> (string),
}

local cssController = {} :: cssControllerImpl;


function cssController.frame(frame)
    local result = '';
    
    return ''
end


return cssController;