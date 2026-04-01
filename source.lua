local CoreGui = game:GetService("CoreGui")
local isStudio = game:GetService("RunService"):IsStudio()
if isStudio then
	CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

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

	-- KeySystem
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

		-- Key GUI creation (same as before)
	end

	-- Loading Screen
	local LoadingScreen = Instance.new("Frame")
	LoadingScreen.Name = "LoadingScreen"
	LoadingScreen.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingScreen.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingScreen.Size = UDim2.new(0.248, 0,0.338, 0)

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
