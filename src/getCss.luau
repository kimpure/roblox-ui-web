--!strict

type getCssImpl = {
    frame: (frame: Frame) -> (string),
    textLable: (textTable: TextLabel) -> (string),
};

local getCss = {} :: getCssImpl;

function getCss.frame(frame)
    --// base Setting
    local result = 'position: absolute;';
    
    --// size
    local width = (frame.Size.X.Offset / 10) + (frame.Size.X.Scale * 100);
    local height = (frame.Size.Y.Offset / 10) + (frame.Size.Y.Scale * 100);
    result ..= `height: {height}vh; width: {width}vw;`;
    
    --// AnchordPoint
    local AnchordPoint = { x = frame.AnchorPoint.X * 100, y = frame.AnchorPoint.Y * 100 };
    result ..= `transform: translate(-{AnchordPoint.x}%, -{AnchordPoint.y}%);`;
    
    --// position
    local left = (frame.Position.X.Offset / 10) + (frame.Position.X.Scale * 100);
    local top = (frame.Position.Y.Offset / 10) + (frame.Position.Y.Scale * 100);
    result ..= `left: {left}vw; top: {top}vh;`;

    --// Background Color & Background Transparency
    local BackgroundColor = frame.BackgroundColor3;
    local BackgroundTransparency = frame.BackgroundTransparency;
    result ..= `background-color: rgba({BackgroundColor.R * 255}, {BackgroundColor.G * 255}, {BackgroundColor.B * 255}, {1 - BackgroundTransparency});`;

    --// BoderMode & BorderSizePixel & BorderColor
    local BorderSizePixel = frame.BorderSizePixel;
    local BoderColor = frame.BorderColor3;
    result ..= `border: {BorderSizePixel}px solid rgb({BoderColor.R * 255}, {BoderColor.G * 255}, {BoderColor.B * 255});`;

    --// Rotation
    local Rotation = frame.Rotation;
    result ..= `transform: rotate({Rotation}deg);`;

    return result
end

function getCss.textLable(textLable)
    local result = getCss.frame(textLable :: any);
    result ..= if textLable.FontFace.Bold then `font-weight: {textLable.FontFace.Weight.Value};` else '';
    result ..= if textLable.FontFace.Family then `font-style: oblique;` else '';
    result ..= if textLable.TextScaled then 'font-size: 100%;' else `font-size: {textLable.TextSize}px;`;

    --// TextStrokeColor3 & TextStrokeTransparency
    local TextStrokeColor3 = textLable.TextStrokeColor3;
    local TextStrokeTransparency = textLable.TextStrokeTransparency;
    result ..=  `-webkit-text-stroke-width: 1px;`;
    result ..= `-webkit-text-stroke-color: rgba({TextStrokeColor3.R * 255}, {TextStrokeColor3.G * 255}, {TextStrokeColor3.B * 255}, {1 - TextStrokeTransparency});`;

    --// TextColor & TextTransparency
    local TextColor = textLable.TextColor3;
    local TextTransparency = textLable.TextTransparency;
    result ..= `color: rgba({TextColor.R * 255}, {TextColor.G * 255}, {TextColor.B * 255}, {1 - TextTransparency});`;
    
    --// display changed
    result ..= 'display: flex;';

    --// TextXAlignment & TextYAlignment
    local TextXAlignment = textLable.TextXAlignment;
    local TextYAlignment = textLable.TextYAlignment;
    result ..= `justify-content: { if TextXAlignment.Value == 1 then 'start' elseif TextXAlignment.Value == 2 then 'center' else 'end' };`;
    result ..= `align-items: { if TextYAlignment.Value == 0 then 'start' elseif TextYAlignment.Value == 1 then 'center' else 'end' };`;

    return result; 
end

return getCss;