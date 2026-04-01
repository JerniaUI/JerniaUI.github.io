--[[
JERNIA UI
BY BROTHAISHACKIER
]]--

local CoreGui = game:GetService("CoreGui")
local isStudio = game:GetService("RunService"):IsStudio()
if isStudio then
	CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
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
		Subtitle = "Jernia Key System",
		Note = "No method of obtaining the key is provided",
		GrabKeyFromSite = false,
		Key = {""}
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
			PlaceholderText = Color3.fromRGB(170, 170, 170),
			Textboxbg = Color3.fromRGB(45, 45, 45),
			Accent = Color3.fromRGB(0, 170, 255),
			Error = Color3.fromRGB(255, 80, 80)
		}
	}
}

local sTheme = JerniaLibrary.Themes.Default

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
		if Settings.ConfigurationSaving.Enabled then
			assert(type(Settings.KeySettings.Title) == "string", "KeySettings.Title Error")
			assert(type(Settings.KeySettings.Subtitle) == "string", "KeySettings.Subtitle Error")
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
	
	if Settings.KeySystem then
		local keys = {}
		if Settings.KeySettings.GrabKeyFromSite and not isStudio then
			for _, v in pairs(Settings.KeySettings.Key) do
				table.insert(keys, game:HttpGet(v))
			end
		else
			for _, v in pairs(Settings.KeySettings.Key) do
				table.insert(keys, v)
			end
		end

		local keygui = Instance.new("Frame")
		keygui.Name = "KeyGui"
		keygui.Size = UDim2.new(0, 350, 0, 220)
		keygui.Position = UDim2.new(0.5, 0, 0.5, 0)
		keygui.AnchorPoint = Vector2.new(0.5, 0.5)
		keygui.BackgroundColor3 = sTheme.Background
		keygui.Parent = gui

		local corner = Instance.new("UICorner", keygui)
		corner.CornerRadius = UDim.new(0, 10)

		local stroke = Instance.new("UIStroke", keygui)
		stroke.Color = sTheme.Stroke
		stroke.Thickness = 1

		local layout = Instance.new("UIListLayout", keygui)
		layout.Padding = UDim.new(0, 10)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
		layout.FillDirection = Enum.FillDirection.Vertical
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local padding = Instance.new("UIPadding", keygui)
		padding.PaddingTop = UDim.new(0, 15)
		padding.PaddingBottom = UDim.new(0, 15)

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -20, 0, 40)
		title.BackgroundTransparency = 1
		title.Text = Settings.KeySettings.Title
		title.TextScaled = true
		title.TextColor3 = sTheme.Text
		title.Font = Enum.Font.GothamBold
		title.Parent = keygui

		local subtitle = Instance.new("TextLabel")
		subtitle.Size = UDim2.new(1, -20, 0, 25)
		subtitle.BackgroundTransparency = 1
		subtitle.Text = Settings.KeySettings.Subtitle
		subtitle.TextScaled = true
		subtitle.TextColor3 = sTheme.PlaceholderText
		subtitle.Font = Enum.Font.Gotham
		subtitle.Parent = keygui

		local keyBox = Instance.new("TextBox")
		keyBox.Size = UDim2.new(0.8, 0, 0, 35)
		keyBox.PlaceholderText = "Enter key..."
		keyBox.Text = ""
		keyBox.TextScaled = true
		keyBox.BackgroundColor3 = sTheme.Textboxbg
		keyBox.TextColor3 = sTheme.Text
		keyBox.PlaceholderColor3 = sTheme.PlaceholderText
		keyBox.Font = Enum.Font.Gotham
		keyBox.Parent = keygui

		local boxCorner = Instance.new("UICorner", keyBox)
		boxCorner.CornerRadius = UDim.new(0, 6)

		local status = Instance.new("TextLabel")
		status.Size = UDim2.new(1, -20, 0, 20)
		status.BackgroundTransparency = 1
		status.Text = ""
		status.TextScaled = true
		status.TextColor3 = Color3.fromRGB(255, 80, 80)
		status.Font = Enum.Font.Gotham
		status.Parent = keygui

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.5, 0, 0, 35)
		button.Text = "Submit"
		button.TextScaled = true
		button.BackgroundColor3 = sTheme.Accent
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.Font = Enum.Font.GothamBold
		button.Parent = keygui

		local btnCorner = Instance.new("UICorner", button)
		btnCorner.CornerRadius = UDim.new(0, 6)	

		title.LayoutOrder = 0
		subtitle.LayoutOrder = 1
		keyBox.LayoutOrder = 2
		status.LayoutOrder = 3
		button.LayoutOrder = 4

		local KeyEntered = Instance.new("BindableEvent")

		button.Activated:Connect(function()
			if table.find(keys, keyBox.Text) then
				keygui:Destroy()
				KeyEntered:Fire()
			else
				status.Text = "Invalid key"
			end
		end)

		KeyEntered.Event:Wait()
		KeyEntered:Destroy()
	end
	
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
