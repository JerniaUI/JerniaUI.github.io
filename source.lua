--Services
local CoreGui = game:GetService("CoreGui")
local isStudio = game:GetService("RunService"):IsStudio()
if isStudio then
	CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local function normsie(x, y)
	return UDim2.new(x[1], x[2], y[1], y[2])
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

function JerniaLibrary:CreateWindow(Settings)
	assert(type(Settings) == "table", "CreateWindow Error")
	if Settings.Name then
		assert(type(Settings.Name) == "string", "Name Error")
		JerniaSettings.Name = Settings.Name
	end
	if Settings.Icon then 
		assert(type(Settings.Icon) == "number", "Icon Error")
		JerniaSettings.Icon = Settings.Icon
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
	local UIStroke = Instance.new("UIStroke", LoadingScreen)
	UIStroke.Color = sTheme.Stroke
	UIStroke.Thickness = 0.01
	UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	
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
	
	--UI
	
	local UI = Instance.new("Frame")
	
	task.spawn(function()
		task.wait(3)
		local swait = 0.5
		local tween = TweenService:Create(LoadingScreen, TweenInfo.new(swait), {BackgroundTransparency = 1})
		local tween2 = TweenService:Create(Title, TweenInfo.new(swait), {TextTransparency = 1})
		local tween3 = TweenService:Create(sub, TweenInfo.new(swait), {TextTransparency = 1})
		local tween4 = TweenService:Create(UIStroke, TweenInfo.new(swait), {Transparency = 1})
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
	
	
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == sToggleUIKeybind then
			
		end
	end)

	local Window = {}

	function Window:CreateTab(Settings)
		assert(type(Settings) == "table", "CreateTab Error")
		assert(type(Settings.Name) == "string", "Name Error")
		if Settings.Icon then 
			assert(type(Settings.Icon) == "number", "Icon Error")
		end
	end

	return Window
end
return JerniaLibrary
