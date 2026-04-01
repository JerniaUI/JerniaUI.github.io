--Services
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local isStudio = game:GetService("RunService"):IsStudio() or false
if isStudio then
	CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local function loadWithTimeout(url: string, timeout: number?): ...any
	assert(type(url) == "string", "Expected string, got " .. type(url))
	timeout = timeout or 5
	local requestCompleted = false
	local success, result = false, nil

	local requestThread = task.spawn(function()
		local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url) -- game:HttpGet(url)
		-- If the request fails the content can be empty, even if fetchSuccess is true
		if not fetchSuccess or #fetchResult == 0 then
			if #fetchResult == 0 then
				fetchResult = "Empty response" -- Set the error message
			end
			success, result = false, fetchResult
			requestCompleted = true
			return
		end
		local content = fetchResult -- Fetched content
		local execSuccess, execResult = pcall(function()
			return loadstring(content)()
		end)
		success, result = execSuccess, execResult
		requestCompleted = true
	end)

	local timeoutThread = task.delay(timeout, function()
		if not requestCompleted then
			warn("Request for " .. url .. " timed out after " .. tostring(timeout) .. " seconds")
			task.cancel(requestThread)
			result = "Request timed out"
			requestCompleted = true
		end
	end)

	-- Wait for completion or timeout
	while not requestCompleted do
		task.wait()
	end
	-- Cancel timeout thread if still running when request completes
	if coroutine.status(timeoutThread) ~= "dead" then
		task.cancel(timeoutThread)
	end
	if not success then
		warn("Failed to process " .. tostring(url) .. ": " .. tostring(result))
	end
	return if success then result else nil
end
-- Thanks to Latte Softworks for the Lucide integration for Roblox
local Icons = isStudio and require(script.Parent.icons) or loadWithTimeout('https://raw.githubusercontent.com/JerniaUI/JerniaUI.github.io/refs/heads/main/icons.lua')
local function getIcon(name : string): {id: number, imageRectSize: Vector2, imageRectOffset: Vector2}
	if not Icons then
		warn("Lucide Icons: Cannot use icons as icons library is not loaded")
		return
	end
	name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
	local sizedicons = Icons['48px']
	local r = sizedicons[name]
	if not r then
		error("Lucide Icons: Failed to find icon by the name of \"" .. name .. "\"", 2)
	end

	local rirs = r[2]
	local riro = r[3]

	if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
		error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
	end

	local irs = Vector2.new(rirs[1], rirs[2])
	local iro = Vector2.new(riro[1], riro[2])

	local asset = {
		id = r[1],
		imageRectSize = irs,
		imageRectOffset = iro,
	}

	return asset
end
local JerniaSettings = {
	Name = "Jernia Example Window",
	Icon = 0,
	LoadingTitle = "Jernia User Interface",
	ShowText = "Jernia",
	Theme = "Default",

	ToggleUIKeybind = "K",

	DisableJerniaPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil,
		FileName = "Big Hub"
	},

	KeySystem = false,
	KeySettings = {
		Title = "Jernia",
		Note = "No method of obtaining the key is provided",
		GrabKeyFromSite = false,
		Key = {"Hello", "World"}
	}
}

--platform detection
local platform

local function detectPlatform(input)
	if UserInputService.TouchEnabled then
		platform = "Mobile"
	elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		platform = "Desktop"
	elseif UserInputService.GamepadEnabled then
		platform = "Console"
	else
		platform = "Unknown"
	end
end

UserInputService.InputBegan:Connect(detectPlatform)

local JerniaLibrary = {
	Flags = {},
	Themes = {
		Default = {
			Background = Color3.fromRGB(30, 30, 30),
			Stroke = Color3.fromRGB(60, 60, 60),
			TStroke = Color3.fromRGB(90, 90, 90),
			Text = Color3.fromRGB(255, 255, 255),
			Subtext = Color3.fromRGB(150, 150, 150),
			PlaceholderText = Color3.fromRGB(170, 170, 170),
			Textboxbg = Color3.fromRGB(45, 45, 45),
			Accent = Color3.fromRGB(0, 170, 255),
			Error = Color3.fromRGB(255, 80, 80),
			font = {
				default = Enum.Font.Gotham,
				bold = Enum.Font.GothamBold
			}
		}
	}
}


local sTheme = JerniaLibrary.Themes.Default
local sToggleUIKeybind = Enum.KeyCode["K"]

-- Create window

function JerniaLibrary:CreateWindow(Settings)
	local icon = "rbxassetid://" .. 0
	local imageRectSize = Vector2.new(0, 0)
	local imageRectOffset = Vector2.new(0, 0)
	assert(type(Settings) == "table", "CreateWindow Error")
	if Settings.Name then
		assert(type(Settings.Name) == "string", "Name Error")
		JerniaSettings.Name = Settings.Name
	end
	if Settings.Icon then 
		assert(type(Settings.Icon) == "number" or type(Settings.Icon) == "string", "Icon Error")
		if type(Settings.Icon) == "string" then
			local asset = getIcon(Settings.Icon)
			icon = "rbxassetid://" .. asset.id
			JerniaSettings.Icon = asset.id
			imageRectSize = asset.imageRectSize
			imageRectOffset = asset.imageRectOffset

		elseif type(Settings.Icon) == "number" then
			JerniaSettings.Icon = Settings.Icon
			icon = "rbxassetid://" .. Settings.Icon
		else
			JerniaSettings.Icon = "rbxassetid://" .. 0
			icon = "rbxassetid://" .. 0
		end
	end
	if Settings.LoadingTitle then 
		assert(type(Settings.LoadingTitle) == "string", "LoadingTitle Error")
		JerniaSettings.LoadingTitle = Settings.LoadingTitle
	end
	if Settings.ShowText then 
		assert(type(Settings.ShowText) == "string", "ShowText Error")
		JerniaSettings.ShowText = Settings.ShowText
	end
	if Settings.Theme then 
		assert(self.Themes[Settings.Theme], "Theme Error")
		JerniaSettings.Theme = Settings.Theme
		sTheme = self.Themes[Settings.Theme]
	end
	if Settings.ToggleUIKeybind then 
		assert(type(Settings.ToggleUIKeybind) == "string", "ToggleUIKeybind Error")
		JerniaSettings.ToggleUIKeybind = Settings.ToggleUIKeybind
		sToggleUIKeybind = Enum.KeyCode[Settings.ToggleUIKeybind]
	end
	if Settings.DisableJerniaPrompts then 
		assert(type(Settings.DisableJerniaPrompts) == "boolean", "DisableJerniaPrompts Error")
		JerniaSettings.DisableJerniaPrompts = Settings.DisableJerniaPrompts
	end
	if Settings.DisableBuildWarnings then 
		assert(type(Settings.DisableBuildWarnings) == "boolean", "DisableBuildWarnings Error")
		JerniaSettings.DisableBuildWarnings = Settings.DisableBuildWarnings
	end
	if Settings.ConfigurationSaving then
		assert(type(Settings.ConfigurationSaving) == "table", "ConfigurationSaving Error")
		if Settings.ConfigurationSaving.Enabled then
			if Settings.ConfigurationSaving.FolderName ~= nil then
				assert(type(Settings.ConfigurationSaving.FolderName) == "string", "ConfigurationSaving.FolderName Error")
			end
			assert(type(Settings.ConfigurationSaving.FileName) == "string", "ConfigurationSaving.FileName Error")
			JerniaSettings.ConfigurationSaving.Enabled = Settings.ConfigurationSaving.Enabled
			JerniaSettings.ConfigurationSaving.FolderName = Settings.ConfigurationSaving.FolderName
			JerniaSettings.ConfigurationSaving.FileName = Settings.ConfigurationSaving.FileName
		end
	end
	if Settings.KeySystem then 
		assert(type(Settings.KeySystem) == "boolean", "KeySystem Error")
		JerniaSettings.KeySystem = Settings.KeySystem
	end
	if Settings.KeySettings then
		assert(type(Settings.KeySettings) == "table", "KeySettings Error")
		if Settings.KeySystem then
			assert(type(Settings.KeySettings.Title) == "string", "KeySettings.Title Error")
			assert(type(Settings.KeySettings.Note) == "string", "KeySettings.Note Error")
			if Settings.KeySettings.GrabKeyFromSite then
				assert(type(Settings.KeySettings.GrabKeyFromSite) == "boolean", "KeySettings.GrabKeyFromSite Error")
			end
			assert(type(Settings.KeySettings.Key) == "table", "KeySettings.Key Error")
		end
	end
	local gui = CoreGui:FindFirstChild("Jernia")
	if gui then
		gui:Destroy()
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "Jernia"
	gui.ResetOnSpawn = false
	gui.Parent = CoreGui
	gui.ScreenInsets = Enum.ScreenInsets.None
	gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None

	--KeySystem
	if Settings.KeySystem then
		local keys = {}
		if Settings.KeySettings.GrabKeyFromSite and not isStudio then
			for _, v in pairs(Settings.KeySettings.Key) do
				local zxcvb, success = pcall(function()
					return game:GetService("HttpService"):GetAsync(v)
				end)
				if success then
					table.insert(keys, zxcvb)
				end
			end
		else
			for _, v in pairs(Settings.KeySettings.Key) do
				table.insert(keys, v)
			end
		end

		local keygui = Instance.new("Frame")
		keygui.Name = "KeyGui"
		keygui.Size = UDim2.new(0.198, 0, 0.238, 0)
		keygui.Position = UDim2.new(0.5, 0, 0.5, 0)
		keygui.AnchorPoint = Vector2.new(0.5, 0.5)
		keygui.BackgroundColor3 = sTheme.Background
		keygui.Parent = gui

		local corner = Instance.new("UICorner", keygui)
		corner.CornerRadius = UDim.new(0.05, 0)

		local stroke = Instance.new("UIStroke", keygui)
		stroke.Color = sTheme.Stroke
		stroke.Thickness = 0.005
		stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize

		local layout = Instance.new("UIListLayout", keygui)
		layout.Padding = UDim.new(0.075, 0)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
		layout.FillDirection = Enum.FillDirection.Vertical
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local dragger = Instance.new("UIDragDetector", keygui)

		local padding = Instance.new("UIPadding", keygui)
		padding.PaddingTop = UDim.new(0.075,0)
		padding.PaddingBottom = UDim.new(0.075,0)

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(0.943, 0,0.182, 0)
		title.BackgroundTransparency = 1
		title.Text = Settings.KeySettings.Title
		title.TextScaled = true
		title.TextColor3 = sTheme.Text
		title.Font = sTheme.font.bold
		title.Parent = keygui

		local subtitle = Instance.new("TextLabel")
		subtitle.Size = UDim2.new(0.943, 0, 0.114, 0)
		subtitle.BackgroundTransparency = 1
		subtitle.Text = Settings.KeySettings.Note
		subtitle.TextScaled = true
		subtitle.TextColor3 = sTheme.Subtext
		subtitle.Font = sTheme.font.default
		subtitle.Parent = keygui

		local keyBox = Instance.new("TextBox")
		keyBox.Size = UDim2.new(0.8, 0, 0.159, 0)
		keyBox.PlaceholderText = "Enter key..."
		keyBox.Text = ""
		keyBox.TextScaled = true
		keyBox.BackgroundColor3 = sTheme.Textboxbg
		keyBox.TextColor3 = sTheme.Text
		keyBox.PlaceholderColor3 = sTheme.PlaceholderText
		keyBox.Font = sTheme.font.default
		keyBox.Parent = keygui

		local boxCorner = Instance.new("UICorner", keyBox)
		boxCorner.CornerRadius = UDim.new(0.2, 0)

		local status = Instance.new("TextLabel")
		status.Size = UDim2.new(0.943, 0, 0.091, 0)
		status.BackgroundTransparency = 1
		status.Text = ""
		status.TextScaled = true
		status.TextColor3 = Color3.fromRGB(255, 80, 80)
		status.Font = sTheme.font.default
		status.Parent = keygui

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.5, 0 , 0.159, 0)
		button.Text = "Submit"
		button.TextScaled = true
		button.BackgroundColor3 = sTheme.Accent
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.Font = sTheme.font.bold
		button.Parent = keygui

		local btnCorner = Instance.new("UICorner", button)
		btnCorner.CornerRadius = UDim.new(0.2, 0)	

		title.LayoutOrder = 0
		subtitle.LayoutOrder = 1
		keyBox.LayoutOrder = 2
		status.LayoutOrder = 3
		button.LayoutOrder = 4

		local KeyEntered = Instance.new("BindableEvent")

		button.Activated:Connect(function()
			if table.find(keys, keyBox.Text) then
				KeyEntered:Fire()
			else
				status.Text = "Invalid key"
			end
		end)

		KeyEntered.Event:Wait()
		KeyEntered:Destroy()
		local swait = 0.5
		local tween = TweenService:Create(keygui, TweenInfo.new(swait), {BackgroundTransparency = 1})
		local tween2 = TweenService:Create(keyBox, TweenInfo.new(swait), {BackgroundTransparency = 1})
		local tween3 = TweenService:Create(status, TweenInfo.new(swait), {TextTransparency = 1})
		local tween4 = TweenService:Create(button, TweenInfo.new(swait), {TextTransparency = 1})
		local tween5 = TweenService:Create(keyBox, TweenInfo.new(swait), {TextTransparency = 1})
		local tween6 = TweenService:Create(button, TweenInfo.new(swait), {BackgroundTransparency = 1})
		local tween7 = TweenService:Create(title, TweenInfo.new(swait), {TextTransparency = 1})
		local tween8 = TweenService:Create(subtitle, TweenInfo.new(swait), {TextTransparency = 1})
		local tween9 = TweenService:Create(stroke, TweenInfo.new(swait), {Transparency = 1})

		tween:Play()
		tween2:Play()
		tween3:Play()
		tween4:Play()
		tween5:Play()
		tween6:Play()
		tween7:Play()
		tween8:Play()
		tween9:Play()

		task.wait(swait)
		swait = nil
		keygui:Destroy()
		tween = nil
		tween2 = nil
		tween3 = nil
		tween4 = nil
		tween5 = nil
		tween6 = nil
		tween7 = nil
		tween8 = nil
		tween9 = nil

	end

	-- Loading Screen
	local LoadingScreen = Instance.new("Frame", gui)
	LoadingScreen.Name = "LoadingScreen"
	LoadingScreen.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingScreen.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingScreen.Size = UDim2.new(0.179, 0, 0.214, 0)
	LoadingScreen.BackgroundColor3 = sTheme.Background
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", LoadingScreen)
	UIAspectRatioConstraint.AspectRatio = 1.596
	local UICorner = Instance.new("UICorner", LoadingScreen)
	UICorner.CornerRadius = UDim.new(0.05, 0)
	local UItroke = Instance.new("UIStroke", LoadingScreen)
	UItroke.Color = sTheme.Stroke
	UItroke.Thickness = 0.01
	UItroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize

	local Title = Instance.new("TextLabel", LoadingScreen)
	Title.Name = "Title"
	Title.Size = UDim2.new(0.9, 0, 0.266, 0)
	Title.Position = UDim2.new(0.5, 0, 0.05, 0)
	Title.AnchorPoint = Vector2.new(0.5, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "Loading..."
	Title.TextColor3 = sTheme.Text
	Title.TextScaled = true
	Title.Font =  sTheme.font.bold
	local sub = Instance.new("TextLabel", Title)
	sub.Name = "sub"
	sub.Size = UDim2.new(1, 0, 2, 0)
	sub.Position = UDim2.new(0, 0, 1, 0)
	sub.BackgroundTransparency = 1
	sub.Text = Settings.LoadingTitle
	sub.TextColor3 = sTheme.Subtext
	sub.TextScaled = true
	sub.Font =  sTheme.font.default
	local lsub = sub
	local lTitle = Title
	local lUItroke = UItroke

	--UI
	local UIshow = Instance.new("TextButton", gui)
	UIshow.Name = "UIshow"
	UIshow.Visible = false
	UIshow.BackgroundColor3 = Color3.fromRGB(255,255,255)
	UIshow.BackgroundTransparency = 0.5
	UIshow.Text = Settings.ShowText
	UIshow.TextScaled = true
	UIshow.Font = sTheme.font.bold
	local UICorner = Instance.new("UICorner", UIshow)
	UICorner.CornerRadius = UDim.new(0.5, 0)
	UIshow.Text = Settings.ShowText
	UIshow.ZIndex = 1000
	UIshow.Size = UDim2.new(0.1, 0, 0.05, 0)
	UIshow.Position = UDim2.new(0.5, 0, 0, 0)
	UIshow.AnchorPoint = Vector2.new(0.5, 0)


	if platform ~=  "Desktop" then
		UIshow.Visible = true
	end

	local UI = Instance.new("Frame")
	UI.AnchorPoint = Vector2.new(0.5, 0.5)
	UI.ClipsDescendants = false
	UI.Position = UDim2.new(0.5, 0, 0.5, 0)
	UI.Size = UDim2.new(0.274, 0, 0.46, 0)
	Instance.new("UIDragDetector", UI)
	local underdrag = Instance.new("Frame")
	underdrag.Parent = UI
	underdrag.Size = UDim2.new(0.3, 0, 0.01, 0)
	underdrag.Position = UDim2.new(0.5, 0, 1.1, 0)
	underdrag.AnchorPoint = Vector2.new(0.5, 0)
	underdrag.BackgroundTransparency = 0.5
	underdrag.BackgroundColor3 = Color3.fromRGB(255,255,255)
	local corner = Instance.new("UICorner", underdrag)
	corner.CornerRadius = UDim.new(5, 0)
	local underdrag = Instance.new("Frame")
	underdrag.Parent = UI
	underdrag.Size = UDim2.new(0.3, 0, 0.01, 0)
	underdrag.Position = UDim2.new(0.5, 0, 1.1, 0)
	underdrag.AnchorPoint = Vector2.new(0.5, 0)
	underdrag.BackgroundTransparency = 1
	underdrag.BackgroundColor3 = Color3.fromRGB(255,255,255)
	local corner = Instance.new("UICorner", underdrag)
	corner.CornerRadius = UDim.new(5, 0)
	local drag = Instance.new("UIDragDetector", underdrag)

	local lastPos = underdrag.Position

	underdrag:GetPropertyChangedSignal("Position"):Connect(function()
		local current = underdrag.Position

		local deltaX = current.X.Offset - lastPos.X.Offset
		local deltaY = current.Y.Offset - lastPos.Y.Offset

		UI.Position = UI.Position + UDim2.new(0, deltaX, 0, deltaY)

		lastPos = current
	end)

	drag.DragEnd:Connect(function()
		underdrag.Position = UDim2.new(0.5, 0, 1.1, 0)
		lastPos = underdrag.Position
	end)


	local aspect = Instance.new("UIAspectRatioConstraint", UI)
	aspect.AspectRatio = 1.336
	UI.BackgroundColor3 = sTheme.Background
	local UIStroke = Instance.new("UIStroke", UI)
	UIStroke.Color = sTheme.Stroke
	UIStroke.Thickness = 0.005
	UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	local UICorner = Instance.new("UICorner", UI)
	UICorner.CornerRadius = UDim.new(0.05, 0)
	local stasdad = 1
	local Frame = Instance.new("Frame", UI)
	Frame.Size = UDim2.new(1, 0, 0.075, 0)
	Frame.Position = UDim2.new(0, 0, 0.05, 0)
	Frame.BackgroundTransparency = stasdad
	Frame.BackgroundColor3 = sTheme.Stroke
	Frame.ZIndex = 49
	Frame.BorderSizePixel = 0
	local Framed = Instance.new("Frame", Frame)
	Framed.Size = UDim2.new(1, 0, 0.1, 0)
	Framed.Position = UDim2.new(0, 0, 1, 0)
	Framed.AnchorPoint = Vector2.new(0, 1)
	Framed.BackgroundTransparency = stasdad
	Framed.BackgroundColor3 = Color3.fromRGB(0,0,0)
	Framed.ZIndex = 49
	Framed.BorderSizePixel = 0
	local Frame = Instance.new("Frame", UI)
	Frame.Size = UDim2.new(1, 0, 0.1, 0)
	Frame.Position = UDim2.new(0, 0, 0, 0)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = sTheme.Stroke
	Frame.ZIndex = 50
	Frame.BorderSizePixel = 0
	local UICorner = Instance.new("UICorner", Frame)
	UICorner.CornerRadius = UDim.new(0.5, 0)
	local Title = Instance.new("TextLabel", Frame)
	Title.Size = UDim2.new(0.55, 0, 1, 0)
	Title.Position = UDim2.new(0.025, 0, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = Settings.Name
	Title.TextColor3 = sTheme.Text
	Title.TextScaled = true
	Title.Font =  sTheme.font.bold
	Title.ZIndex = 51
	local Icon = Instance.new("ImageLabel", Frame)
	Icon.Size = UDim2.new(0.4, 0, 1, 0)
	Icon.Position = UDim2.new(0.6, 0, 0.5, 0)
	Icon.AnchorPoint = Vector2.new(0, 0.5)
	Icon.BackgroundTransparency = 1
	Icon.Image = icon
	Icon.ZIndex = 51
	Icon.ImageRectSize = imageRectSize
	Icon.ImageRectOffset = imageRectOffset
	local uia = Instance.new("UIAspectRatioConstraint", Icon)
	uia.AspectRatio = 1
	local close = Instance.new("ImageButton", Frame)
	close.Size = UDim2.new(0.15, 0, 1, 0)
	close.Position = UDim2.new(1, 0, 0.5, 0)
	close.AnchorPoint = Vector2.new(1, 0.5)
	local img = getIcon("x")
	close.Image = "rbxassetid://" .. img.id
	close.ImageRectSize = img.imageRectSize
	close.ImageRectOffset = img.imageRectOffset
	close.BackgroundTransparency = 1
	close.ZIndex = 52
	local uia = Instance.new("UIAspectRatioConstraint", close)
	uia.AspectRatio = 1

	local tabs = Instance.new("ScrollingFrame", UI)
	tabs.Size = UDim2.new(1, 0, 0.1, 0)
	tabs.Position = UDim2.new(0, 0, 0.1, 0)
	tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabs.BackgroundTransparency = 1
	tabs.ZIndex = 48
	tabs.ScrollBarThickness = 0
	local UICorner = Instance.new("UICorner", tabs)
	UICorner.CornerRadius = UDim.new(0.5, 0)

	--Loading end
	task.spawn(function()
		task.wait(3)
		local swait = 0.5
		local tween = TweenService:Create(LoadingScreen, TweenInfo.new(swait), {BackgroundTransparency = 1})
		local tween2 = TweenService:Create(lTitle, TweenInfo.new(swait), {TextTransparency = 1})
		local tween3 = TweenService:Create(lsub, TweenInfo.new(swait), {TextTransparency = 1})
		local tween4 = TweenService:Create(lUItroke, TweenInfo.new(swait), {Transparency = 1})
		tween:Play()
		tween2:Play()
		tween3:Play()
		tween4:Play()
		task.wait(swait)
		swait = nil
		LoadingScreen:Destroy()
		tween = nil
		tween2 = nil
		tween3 = nil
		tween4 = nil
		UI.Parent = gui
	end)

	local function Ushow()
		UI.Visible = not UI.Visible
		UI.Position = UDim2.new(0.5, 0, 0.5, 0)
	end

	UIshow.Activated:Connect(Ushow)
	close.Activated:Connect(Ushow)
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == sToggleUIKeybind and not TextChatService:FindFirstChild("ChatInputBarConfiguration").IsFocused then
			Ushow()
		end
		if platform ~=  "Desktop" then
			UIshow.Visible = true
		else
			UIshow.Visible = false
		end
	end)

	local Window = {
		tabs = tabs,
		scrolls = ""
	}

	function Window:CreateTab(Settings)
		assert(type(Settings) == "table", "CreateTab Error")
		assert(type(Settings.Name) == "string", "Name Error")
		if Settings.Icon then 
			assert(type(Settings.Icon) == "number", "Icon Error")
		end
	end

	return Window
end

--Destroy Core

function JerniaLibrary:Destroy()
	CoreGui:FindFirstChild("Jernia"):Destroy()
	print("Jernia Destroyed")
end

--Notify User
function JerniaLibrary:Notify(Settings)
	local gui = CoreGui:FindFirstChild("Jernia")
	if gui then
		if gui:FindFirstChild("Notify") then
			gui:FindFirstChild("Notify"):Destroy()
		end
		local noitify = Instance.new("Frame", gui)
		noitify.Size = UDim2.new(0.2, 0, 0.15, 0)
		noitify.Position = UDim2.new(1, 0, 0.75, 0)
		noitify.AnchorPoint = Vector2.new(1.1, 0.5)
		noitify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		noitify.BackgroundTransparency = 0.5
		noitify.ZIndex = 100
		noitify.Name = "Notify"
		local UICorner = Instance.new("UICorner", noitify)
		UICorner.CornerRadius = UDim.new(0.2, 0)
		local uia = Instance.new("UIAspectRatioConstraint", noitify)
		uia.AspectRatio = 3.07

		local image = Instance.new("ImageLabel", noitify)
		image.Size = UDim2.new(0.4, 0, 1, 0)
		image.Position = UDim2.new(0, 0, 0.5, 0)
		image.AnchorPoint = Vector2.new(0, 0.5)
		image.BackgroundTransparency = 1
		local img = getIcon(Settings.Icon or "bell")
		image.Image = "rbxassetid://" .. img.id
		image.ImageRectSize = img.imageRectSize
		image.ImageRectOffset = img.imageRectOffset
		image.BackgroundTransparency = 1
		image.ZIndex = 101
		local uia = Instance.new("UIAspectRatioConstraint", image)
		uia.AspectRatio = 1

		local text = Instance.new("TextLabel", noitify)
		text.Size = UDim2.new(0.5, 0, 0.5, 0)
		text.Position = UDim2.new(0.4, 0, 0, 0)
		text.AnchorPoint = Vector2.new(0, 0)
		text.BackgroundTransparency = 1
		text.Text = Settings.Title or "No Set Title"
		text.Font = Enum.Font.GothamBold
		text.TextColor3 = Color3.fromRGB(255, 255, 255)
		text.TextScaled = true
		text.ZIndex = 101

		local texts = Instance.new("TextLabel", noitify)
		texts.Size = UDim2.new(0.5, 0, 0.5, 0)
		texts.Position = UDim2.new(0.4, 0, 0.5, 0)
		texts.AnchorPoint = Vector2.new(0, 0)
		texts.BackgroundTransparency = 1
		texts.Text = Settings.Content or "No Set Content"
		texts.Font = Enum.Font.Gotham
		texts.TextColor3 = Color3.fromRGB(255/2, 255/2, 255/2)
		texts.TextScaled = true
		texts.ZIndex = 101

		task.wait(Settings.Duration or 3)
		local tween = TweenService:Create(noitify, TweenInfo.new(0.5), {BackgroundTransparency = 1})
		local tween2 = TweenService:Create(image, TweenInfo.new(0.5), {ImageTransparency = 1})
		local tween3 = TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 1})
		local tween4 = TweenService:Create(texts, TweenInfo.new(0.5), {TextTransparency = 1})

		tween:Play()
		tween2:Play()
		tween3:Play()
		tween4:Play()
		task.wait(0.5)
		noitify:Destroy()
	end
end
return JerniaLibrary
