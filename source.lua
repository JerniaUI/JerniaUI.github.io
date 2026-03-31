--[[
JERNIA UI
BY BROTHAISHACKIER
]]--

local settings = {
	Name = "Jernia Example Window",
	Icon = 0,
	LoadingTitle = "Jernia User Interface",
	ShowText = "Jernia", -- for mobile users to show the UI after clicking the close button
	Theme = "Defualt",

	ToggleUIKeybind = "K", -- The keybind to toggle the UI (use string)

	DisableJerniaPrompts = false,
	DisableBuildWarnings = false, -- Prevents Jernia from showing warnings about the build used

	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Big Hub" --please change this to prevent overlaping
	},

	KeySystem = false, --Enables the keysystem for jernia (stops all scripts from Jernia:Createwindow() until key is passed)
	KeySettings = {
		Title = "Jernia",
		Subtitle = "Jernia Key System",
		Note = "No method of obtaining the key is provided", -- use this to tell the user how to obtain the key
		GrabKeyFromSite = false, -- if enabled set the key to a table with a raw url with the key example Key = {"https://pastebin.com/raw/iamanexamplenotused/"}
		Key = {""} -- list of keys that can be used
	}
}
local JerniaLibrary = {
	Flags = {}, 
	Theme = {
		Defualt = {}
	}
}
function JerniaLibrary:CreateWindow(Settings)
	local color = self.Theme[settings.Theme] or self.Theme["Defualt"]
	print("sucess")
end
return JerniaLibrary
