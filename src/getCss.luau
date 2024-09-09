--!strict

type getCssImpl = {
	frame: (frame: Frame) -> (string),
	textLable: (textTable: TextLabel) -> (string),
	imageLabel: (imageLabel: ImageLabel) -> (string),
	UIAspectRatioConstraint: (UIAspectRatioConstraint: UIAspectRatioConstraint) -> (string),
    UICorner: (UICorner: UICorner) -> (string),
};

local getCss = {} :: getCssImpl;

function getCss.frame(frame)
	--// base Setting
	local result = 'position: absolute;';

	--// size
	local width = frame.Size.X
	local height = frame.Size.Y
	result ..= `height: calc({height.Scale * 100}% + {height.Offset}px); width: calc({width.Scale * 100}% + {width.Offset}px);`;

	--// position
	local left = frame.Position.X;
	local top = frame.Position.Y;
	result ..= `left: calc({left.Scale * 100}% + {left.Offset}px); top: calc({top.Scale * 100}% + {top.Offset}px);`;
	
	--// Background Color & Background Transparency
	local BackgroundColor = frame.BackgroundColor3;
	local BackgroundTransparency = frame.BackgroundTransparency;
	result ..= `background-color: rgba({BackgroundColor.R * 255}, {BackgroundColor.G * 255}, {BackgroundColor.B * 255}, {1 - BackgroundTransparency});`;

	--// BoderMode & BorderSizePixel & BorderColor
	local BorderSizePixel = frame.BorderSizePixel;
	local BoderColor = frame.BorderColor3;
	result ..= `border: {BorderSizePixel}px solid rgb({BoderColor.R * 255}, {BoderColor.G * 255}, {BoderColor.B * 255});`;

	--// Rotation & AnchordPoint
	local AnchordPoint = { x = frame.AnchorPoint.X * 100, y = frame.AnchorPoint.Y * 100 };
	local Rotation = frame.Rotation;
	result ..= `transform: translate({AnchordPoint.x * -1}%, -{AnchordPoint.y * -1}%) rotate({Rotation}deg);`;

	--// Z-Index
	local ZIndex = frame.ZIndex;
	result ..= `z-index: {ZIndex};`;

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

function getCss.imageLabel(imageLabel)
	local result = getCss.frame(imageLabel :: any);

	--// Image
	local Image = imageLabel.Image;
	result ..= `background-image: url('https://assetdelivery.roblox.com/v1/asset/?id={Image:sub(14)}');`;
	result ..= 'background-size: cover;background-repeat: no-repeat;background-position: center;';

	-- ImageColor & ImageTransparency
	local ImageColor = imageLabel.ImageColor3;
	local ImageTransparency = imageLabel.ImageTransparency;
	result ..= `filter: opacity({1 - ImageTransparency}) drop-shadow(0 0 0 rgb({ImageColor.R * 255}, {ImageColor.G * 255}, {ImageColor.B * 255}));`;

	return result;
end

--// UIAGet Css
function getCss.UIAspectRatioConstraint(UIAspectRatioConstraint)
	local result = '';

	local Frame = UIAspectRatioConstraint.Parent :: Frame | ImageLabel | TextLabel;

	local AspectRatio = UIAspectRatioConstraint.AspectRatio;
	local AspectType = UIAspectRatioConstraint.AspectType.Name;

	result ..= if (UIAspectRatioConstraint.DominantAxis.Name == 'Width') then
            `height: auto;aspect-ratio: {AspectRatio} / 1;`
		else 
			`Width: auto;aspect-ratio: 1 / {AspectRatio};`

	if AspectType == 'FitWithinMaxSize' then
		local width = Frame.Size.X;
		local height = Frame.Size.Y;
		result ..= `max-height: calc({height.Scale * 100}% + {height.Offset}px); max-width: calc({width.Scale * 100}% + {width.Offset}px);`;    
	end

	return result;
end

function getCss.UICorner(UICorner)
    local result = '';

	local CornerRadius = UICorner.CornerRadius

    result ..= `border-radius: {CornerRadius.Scale * 100 + CornerRadius.Offset}px;`;
	result ..= `border: 0px;`;

    return result;
end

return getCss;