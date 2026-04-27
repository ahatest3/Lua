--//Services
local DATA_STORE_SERVICE = game:GetService("DataStoreService")
local REPLICATED_SERVICE = game:GetService("ReplicatedStorage")
local SERVER_STORAGE = game:GetService("ServerStorage")
local TWEEN_SERVICE = game:GetService("TweenService")
local RUN_SERVICE = game:GetService("RunService")
local MARKET_PLACE_SERVICE = game:GetService("MarketplaceService")
local HTTPS_SERVICE = game:GetService("HttpService")
local MESSAGING_SERVICE = game:GetService("MessagingService")
local PLAYERS = game:GetService("Players")
local GROUP_SERVICE = game:GetService("GroupService")

--//Folders
local MODULES_FOLDER = REPLICATED_SERVICE:WaitForChild("Modules")
local BUTTONS_FOLDER = workspace:FindFirstChild("Buttons")
local PARTS_FOLDER = workspace:WaitForChild("Parts")
local TEMPLATES_FOLDER = REPLICATED_SERVICE:WaitForChild("Templates")
local EVENTS_FOLDER = REPLICATED_SERVICE:WaitForChild("Events")
local SOUNDS_FOLDER = game:GetService("SoundService"):WaitForChild("Sounds")

local GROUP_ID = 35983952

--//Modules
local SETTINGS_MODULE = require(MODULES_FOLDER:WaitForChild("Settings"))
local FORMAT_MODULE = require(MODULES_FOLDER:WaitForChild("FormatNumber"))
local NOTIFICATION_MODULE = require(MODULES_FOLDER:WaitForChild("Notifications"))

local DATA_STORE = DATA_STORE_SERVICE:GetDataStore(SETTINGS_MODULE.DataKey)
local PARTS_STORE = DATA_STORE_SERVICE:GetDataStore(SETTINGS_MODULE.DataKey.."_Parts")
local OBBIES_STORE = DATA_STORE_SERVICE:GetDataStore(SETTINGS_MODULE.DataKey.."_Obbies")
local DONATED_STORE = DATA_STORE_SERVICE:GetDataStore(SETTINGS_MODULE.DataKey.."_Donated")

local PARTS_LEADERBOARD_DATA_STORE = DATA_STORE_SERVICE:GetOrderedDataStore("Parts"..SETTINGS_MODULE.DataKey)
local ROBUX_LEADERBOARD_DATA_STORE = DATA_STORE_SERVICE:GetOrderedDataStore("Robux"..SETTINGS_MODULE.DataKey)
local TIME_LEADERBOARD_DATA_STORE = DATA_STORE_SERVICE:GetOrderedDataStore("Time"..SETTINGS_MODULE.DataKey)
local OBBIES_LEADERBOARD_DATA_STORE = DATA_STORE_SERVICE:GetOrderedDataStore("Obbies"..SETTINGS_MODULE.DataKey)
local DONATED_LEADERBOARD_DATA_STORE = DATA_STORE_SERVICE:GetOrderedDataStore("Donated"..SETTINGS_MODULE.DataKey)

local BAN_DATA = DATA_STORE_SERVICE:GetDataStore("BanData")

local GLOBAL_BLOCKS_DATA = DATA_STORE_SERVICE:GetDataStore("GlobalBlocks")

local BLOCKS_SPAWN = workspace:WaitForChild("BlockSpawn")
local BOWL = workspace:WaitForChild("Bowl")
local INNER_CIRCLE = BOWL:WaitForChild("INNER")

local UPDATE_BLOCKS_EVENT = EVENTS_FOLDER:WaitForChild("updateServerBlocks")
local UPDATE_GLOBAL_BLOCKS = EVENTS_FOLDER:WaitForChild("updateGlobalBlocks")
local REWARD_TIME_EVENT = EVENTS_FOLDER:WaitForChild("UpdateRewardTime")
local TELEPORT_TO_SPAWN_EVENT = EVENTS_FOLDER:WaitForChild("teleportToSpawn")
local SOUND_EVENT = EVENTS_FOLDER:WaitForChild("playSound")
local GRAVITY_EVENT = EVENTS_FOLDER:WaitForChild("Gravity")
local OBBY_TELEPORTS = workspace:WaitForChild("ObbyTeleports")
local OBBIES = workspace:WaitForChild("Obbies")
--//Leaderboards
local BLOCK_LEADER_BOARD = workspace:WaitForChild("BlocksLeaderboard")
local BLOCKS_LEADER_HOLDER = BLOCK_LEADER_BOARD:WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder")
local ROBUX_LEADER_BOARD = workspace:WaitForChild("RobuxLeaderboard")
local ROBUX_LEADER_HOLDER = ROBUX_LEADER_BOARD:WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder")
local OBBIES_LEADER_HOLDER = workspace:WaitForChild("ObbiesLeaderboard"):WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder")
local TIME_LEADER_BOARD = workspace:WaitForChild("TimeLeaderboard")
local TIME_LEADER_HOLDER = TIME_LEADER_BOARD:WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder")
local DONATED_LEADER_HOLDER = workspace:WaitForChild("DonationLeaderboard"):WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder")

local LEADERBOARD_TEMPLATE = TEMPLATES_FOLDER:WaitForChild("LeaderboardTemplate")

local playTimes = {}
local playerJoinTimes = {}
local lastPlayerObbies = {}
local justCompletedObbys = {}
local isInObby = {}
local timeInObby = {}

local BUTTON_STUDS_TEMPLATE = TEMPLATES_FOLDER:WaitForChild("ButtonStuds")
local Joinwebhook = "https://discord.com/api/webhooks/1493331783079563444/uKv6FQlRZ-s6xkwNBtRDP7WBwWdixxkl4Lji98y3i_hxs8q2gBCoNGlaivIosgOXxFg8"
local Leavehook = "https://discord.com/api/webhooks/1493331734996058354/f3jyMpVsmaye-rHyh_gRyk-apxk9EsUnA5Z-qBSqJHNRkVWXL1-FQZaUej1iGpdvJwAE"
local studShopHook = "https://discord.com/api/webhooks/1493331672702259273/chPazmpuJBSHlPpEWVS73bE64slMOl-SLJseYsDPlWM3b0_YPs63Enxzse_wgj4lRlfl"
local robuxWebhook = "https://discord.com/api/webhooks/1493331604544688250/1CVi1qNvdUWQ9MZtwtQtlhYEvP5eFtP46s7lYRTkFDQKqeRAXIN6lQAlpl2kI24IMa3c"
local obbiesWebhook = "https://discord.com/api/webhooks/1493331532067111114/SxKF1cczQdSYSPa6BGCtxka8uyj6s6rfrzLLKBtxQ0hT1F7rKG09UAsdS0DTeqQIYZ8o"
local socialHook = "https://discord.com/api/webhooks/1493331473753837641/NKMe3gDCALyy9FZqQ-e8O8CVKobwAxFyy7yC9JOhEkIW9Khi6ha9PikW-gREpTW8_RoC"
local inviteHook = "https://discord.com/api/webhooks/1493331390022946877/5JutG3_jSgDlSsSm2Nf-BpHO8VjAMwMxOUJttC-4qlWOBvxvPMEnHWXxnpnQm3JXOaIj"
local adminHook = "https://discord.com/api/webhooks/1493331331156017254/5q4Am59q8AnN7-WkdXhzon5wdAa29sus_cwySVlU98MXJaOCKUu7OBcG5QEJF0tSS9Jv"
local serverRewardHook = "https://discord.com/api/webhooks/1493331274310615060/oDdqmrN4wc3ZelvMzGnxWeASpZmk0dDeJukPmIBkVhFV3jjndJls_nJwvs8NEEQopxEH"
local likeHook = "https://discord.com/api/webhooks/1493331214415953982/EdHVbFeJ8sRHH-ISlQLHXed6jo8Teicp4Rt2hp4ZenbjaayL1IZz5x2WYvoxd7QYQxxY"
local playerRewardHook = "https://discord.com/api/webhooks/1493331126792622152/jHHM7cQqeLUc1xss9ghdMyrILzmvTPNY1uICnnz5Ryg9ECYv9fpK-EuYxI4Obuhwi3PH"
local antiCheatHook = "https://discord.com/api/webhooks/1493331060589592637/KjraiRDrcjy0dHPEQbHeFvpetU7Fil3bkUDZOcCmt9FOAPDSuvma3VPS3QRs5mW-nomf"
local bigRobuxHook = "https://discord.com/api/webhooks/1493330925302583336/ycV5Wjf8SE0G6iimwS7ox3sWhaqtXb-RwrRMm4iYq4Bl5vh6uqD5ExsjEeFD5QZJk8-8"

local isGlobalRemoving = false
local isServerRemoving = false
local NUM_PARTS = 0
local NUM_PLAYERS = 0

local SERVER_MULTIPLIER = Instance.new("NumberValue")
SERVER_MULTIPLIER.Value = 1

local adminIDS = {7473271998, 9500086952} --1227397429 = iiXut, 1483415687 = Ben    9500086952 = holdgamesholder
local builderIDS = {1539734472, 1549953139} --1539734472 = ilysia  1549953139 = cynic
local area2Admins = {1539734472, 1549953139, 9500086952, 7473271998}

local serverBlockQueueValue = Instance.new("IntValue")
serverBlockQueueValue.Value = 0


local function SetupData(player:Player)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	local ValuesFolder = Instance.new("Folder", player)
	ValuesFolder.Name = "Values"
	
	local obbiesCompleted = Instance.new("IntValue", ValuesFolder)
	obbiesCompleted.Name = "ObbiesCompleted"
	obbiesCompleted.Value = 0
	
	local timesPlayed = Instance.new("IntValue", ValuesFolder)
	timesPlayed.Name = "TimesPlayed"
	timesPlayed.Value = 0
	
	local fromSocial = Instance.new("BoolValue", ValuesFolder)
	fromSocial.Name = "FromSocial"
	fromSocial.Value = false
	
	local TotalTimePlayed = Instance.new("IntValue", ValuesFolder)
	TotalTimePlayed.Value = 0
	TotalTimePlayed.Name = "TotalTimePlayed"
	
	local lastPlayed = Instance.new("IntValue", ValuesFolder)
	lastPlayed.Value = 0
	lastPlayed.Name = "LastPlayed"
		
	local PartsSpawned = Instance.new("IntValue", leaderstats)
	PartsSpawned.Name = SETTINGS_MODULE.PartsName
	PartsSpawned.Value = 0
		
	local RobuxSpent = Instance.new("IntValue", ValuesFolder)
	RobuxSpent.Name = SETTINGS_MODULE.RobuxName
	RobuxSpent.Value = 0
	
	local tutorialCompleted = Instance.new("BoolValue", ValuesFolder)
	tutorialCompleted.Value = false
	tutorialCompleted.Name = "TutorialCompleted"
	
	local lastLogin = Instance.new("IntValue", ValuesFolder)
	lastLogin.Name = "LastLogin"
	lastLogin.Value = 0
	
	local obbiesLastMinute = Instance.new("IntValue", ValuesFolder)
	obbiesLastMinute.Value = 0
	obbiesLastMinute.Name = "ObbiesLastMinute"
	
	local playerMultiplier = Instance.new("NumberValue", ValuesFolder)
	playerMultiplier.Name = "PlayerMultiplier"
	playerMultiplier.Value = 1
	
	local TotalStudsContributed = Instance.new("NumberValue", ValuesFolder)
	TotalStudsContributed.Name = "TotalStudsContributed"
	TotalStudsContributed.Value = 0
	
	local OwnsDoubleParts = Instance.new("BoolValue", ValuesFolder)
	OwnsDoubleParts.Name = "OwnsDoubleParts"
	OwnsDoubleParts.Value = false
	
	local unlockedArea2 = Instance.new("BoolValue", ValuesFolder)
	unlockedArea2.Value = false
	unlockedArea2.Name = "UnlockedArea2"
	
	local Immunities = Instance.new("NumberValue", ValuesFolder)
	Immunities.Name = "Immunities"
	Immunities.Value = 0
	
	local Donated = Instance.new("NumberValue", ValuesFolder)
	Donated.Name = "Donated"
	Donated.Value = 0
	
	
	
	local success, existingData = pcall(function()
		return DATA_STORE:GetAsync(player.UserId.."-Data")
	end)
	if success and existingData then
		if existingData.RobuxSpent ~= nil then
			RobuxSpent.Value = existingData.RobuxSpent
		end
		if existingData.TimesPlayed ~= nil then
			timesPlayed.Value = existingData.TimesPlayed
		end
		if existingData.ObbiesCompleted ~= nil then
			obbiesCompleted.Value = existingData.ObbiesCompleted
		end
		if existingData.TotalTimePlayed ~= nil then
			TotalTimePlayed.Value = existingData.TotalTimePlayed
		end
		if existingData.FromSocial ~= nil then
			fromSocial.Value = existingData.FromSocial
		end
		if existingData.TutorialCompleted ~= nil then
			tutorialCompleted.Value = existingData.TutorialCompleted
		end
		if existingData.LastPlayed ~= nil then
			lastPlayed.Value = existingData.LastPlayed
		end
		if existingData.LastLogin ~= nil then
			lastLogin.Value = existingData.LastLogin
		end
		if existingData.PlayerMultiplier ~= nil then
			if existingData.PlayerMultiplier == 0 then playerMultiplier = 1 return end
			playerMultiplier.Value = existingData.PlayerMultiplier
		end
		if existingData.TotalStudsContributed ~= nil then
			TotalStudsContributed.Value = existingData.TotalStudsContributed
		end
		if existingData.OwnsDoubleParts ~= nil then
			OwnsDoubleParts.Value = existingData.OwnsDoubleParts
		end
		if existingData.UnlockedArea2 ~= nil then
			unlockedArea2.Value = existingData.UnlockedArea2
		end
		if existingData.Immunities ~= nil then
			Immunities.Value = existingData.Immunities
		end
	end
	--print(existingData)
	
	local success, PartsData = pcall(function()
		return PARTS_STORE:GetAsync("Player_"..player.UserId)
	end)
	if success and PartsData then
		PartsSpawned.Value = PartsData
	elseif PartsData and not success then
		warn("Failed to retrieve parts data for "..player.Name)
		player:Kick("Failed to fetch data, please rejoin!")
	
	end
	local success, ObbyData = pcall(function()
		return OBBIES_STORE:GetAsync("Player_"..player.UserId)
	end)
	if success and ObbyData then
		obbiesCompleted.Value = ObbyData
	elseif ObbyData and not success then
		warn("Failed to retrieve obby data for "..player.Name)
		player:Kick("Failed to fetch data, please rejoin!")
	end
	local success, DonatedData = pcall(function()
		return DONATED_STORE:GetAsync("Player_"..player.UserId)
	end)
	if success and DonatedData then
		Donated.Value = DonatedData
	elseif DonatedData and not success then
		warn("Failed to retrieve donated data for "..player.Name)
		player:Kick("Failed to fetch data, please rejoin!")
	end
	
end

local blocksAmount = 0

--[[local function UpdateGlobalBlocks(change)
	local success, err = pcall(function()
		blocksAmount = GLOBAL_BLOCKS_DATA:UpdateAsync("GlobalBlocks", function(oldValue)
			oldValue = oldValue or 0
			return oldValue + change
		end)
	end)

	if success then
		UPDATE_GLOBAL_BLOCKS:FireAllClients(blocksAmount)
	else
		warn("Failed to update global blocks:", err)
	end
end--[]]

local playersSaving = {}

local function SaveData(player:Player)
	for i=1, SETTINGS_MODULE.SaveRetries do
	local leaderstats = player:WaitForChild("leaderstats")
	local values = player:WaitForChild("Values")
	local RobuxSpent = values:WaitForChild(SETTINGS_MODULE.RobuxName)
	local PartsSpawned = leaderstats:WaitForChild(SETTINGS_MODULE.PartsName)
	local timesPlayed = values:WaitForChild("TimesPlayed")
	local ObbiesCompleted = values:WaitForChild("ObbiesCompleted")
	local TotalTimePlayed = values:WaitForChild("TotalTimePlayed")
	local FromSocial = values:WaitForChild("FromSocial")
	local tutorialCompleted = values:WaitForChild("TutorialCompleted")
	local lastPlayed = values:WaitForChild("LastPlayed")
	local lastLogin = values:WaitForChild("LastLogin")
	local playerMultiplier = values:WaitForChild("PlayerMultiplier")
	local totalStudsContributed = values:WaitForChild("TotalStudsContributed")
	local ownsDoubleParts = values:WaitForChild("OwnsDoubleParts")
	local unlockedArea2 = values:WaitForChild("UnlockedArea2")
	local Immunities = values:WaitForChild("Immunities")
	local Donated = values:WaitForChild("Donated")
	
	
	local data = {
		RobuxSpent = RobuxSpent.Value,
		TimesPlayed = timesPlayed.Value,
		ObbiesCompleted = ObbiesCompleted.Value,
		TotalTimePlayed = TotalTimePlayed.Value,
		FromSocial = FromSocial.Value,
		TutorialCompleted = tutorialCompleted.Value,
		LastPlayed = lastPlayed.Value,
		LastLogin = lastLogin.Value,
		PlayerMultiplier = playerMultiplier.Value,
		TotalStudsContributed = totalStudsContributed.Value,
		OwnsDoubleParts = ownsDoubleParts.Value,
		UnlockedArea2 = unlockedArea2.Value,
		Immunities = Immunities.Value,
	}
		
		local successData, errormsg = pcall(function()
			DATA_STORE:SetAsync(player.UserId.."-Data", data)
			
		OBBIES_LEADERBOARD_DATA_STORE:SetAsync(tostring(player.UserId), data.ObbiesCompleted)
		TIME_LEADERBOARD_DATA_STORE:SetAsync(tostring(player.UserId), TotalTimePlayed.Value)
		end)
		if successData then
		--	print("Saved data for "..player.Name)
			
			local successRobux, errormsg = pcall(function()
			ROBUX_LEADERBOARD_DATA_STORE:SetAsync(tostring(player.UserId), data.RobuxSpent) -- set ordered data
			end)
		if not successRobux then
			warn("Failed to save data for "..player.Name..": "..errormsg)
			end
		end
		
		local successDonated, errormsg = pcall(function()
			DONATED_STORE:SetAsync("Player_"..player.UserId, Donated.Value)
			DONATED_LEADERBOARD_DATA_STORE:SetAsync(tostring(player.UserId), Donated.Value)
		end)
		if not successDonated then
			warn("Failed to save donated data for "..player.Name..": "..errormsg)
		end
		
		local successObby, errormsg = pcall(function()
			OBBIES_STORE:SetAsync("Player_"..player.UserId, data.ObbiesCompleted)
		end)
		if not successObby then
			warn("Failed to save obbies data for "..player.Name..": "..errormsg)
		end
		
		local successParts, errormsg = pcall(function()
			PARTS_STORE:SetAsync("Player_"..player.UserId, PartsSpawned.Value)
		end)
		if successParts then
		--	print("Saved parts data for "..player.Name)
		PARTS_LEADERBOARD_DATA_STORE:SetAsync(tostring(player.UserId), PartsSpawned.Value) -- set ordered data
		else
			warn("Failed to save parts data for "..player.Name..": "..errormsg)
		end
		break
	end
end

local function formatTime(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds % 86400
	local hours = math.floor(seconds / 3600)
	seconds = seconds % 3600
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60

	return string.format("%dd : %dh : %dm : %ds", days, hours, minutes, secs)
end

PLAYERS.ChildAdded:Connect(function()
	NUM_PLAYERS = #PLAYERS:GetChildren()
end)
PLAYERS.ChildRemoved:Connect(function()
	NUM_PLAYERS = #PLAYERS:GetChildren()
end)

local function getLeaderboardTop()

	local success, pages = pcall(function()
		return PARTS_LEADERBOARD_DATA_STORE:GetSortedAsync(false, SETTINGS_MODULE.LeaderboardSpotsDisplayed, 20)
	end)
	if success then
		local data = pages:GetCurrentPage()
		for _, template in pairs(BLOCKS_LEADER_HOLDER:GetChildren()) do
			if not template:IsA("UIListLayout") then
				template:Destroy()
			end
		end
		for rank, entry in ipairs(data) do
			local template = LEADERBOARD_TEMPLATE:Clone()
			local Rank = template:WaitForChild("Rank")
			local Name = template:WaitForChild("Name")
			local value = template:WaitForChild("Value")
			local suc, entryName = pcall(function()
			return game.Players:GetNameFromUserIdAsync(entry.key)
			end)
			if not suc or not entryName then continue end
			Rank.Text = tostring(rank)
			
			if rank == 1 then
				Rank.TextColor3 = Color3.fromRGB(255, 215, 0)
			elseif rank == 2 then
				Rank.TextColor3 = Color3.fromRGB(192, 192, 192)
			elseif rank == 3 then
				Rank.TextColor3 = Color3.fromRGB(205, 127, 50)
			end
			
			Name.Text = tostring(entryName)
			value.Text = tostring(FORMAT_MODULE.Finalize(entry.value))
			template.LayoutOrder = rank
			template.Parent = BLOCKS_LEADER_HOLDER
		end
	else
		warn("Failed to get leaderboard data")
	end
	
	local success, pages = pcall(function()
		return OBBIES_LEADERBOARD_DATA_STORE:GetSortedAsync(false, SETTINGS_MODULE.LeaderboardSpotsDisplayed, 1)
	end)
	if success then
		local data = pages:GetCurrentPage()
		for _, template in pairs(OBBIES_LEADER_HOLDER:GetChildren()) do
			if not template:IsA("UIListLayout") then
				template:Destroy()
			end
		end
		for rank,entry in ipairs(data) do
			local template = LEADERBOARD_TEMPLATE:Clone()
			local Rank = template:WaitForChild("Rank")
			local Name = template:WaitForChild("Name")
			local value = template:WaitForChild("Value")
			local suc, entryName = pcall(function()
				return game.Players:GetNameFromUserIdAsync(entry.key)
			end)
			if not suc or not entryName then continue end
			Rank.Text = tostring(rank)

			if rank == 1 then
				Rank.TextColor3 = Color3.fromRGB(255, 215, 0)
			elseif rank == 2 then
				Rank.TextColor3 = Color3.fromRGB(192, 192, 192)
			elseif rank == 3 then
				Rank.TextColor3 = Color3.fromRGB(205, 127, 50)
			end

			Name.Text = tostring(entryName)
			value.Text = tostring(FORMAT_MODULE.Finalize(entry.value))
			template.LayoutOrder = rank
			template.Parent = OBBIES_LEADER_HOLDER
		end
	else
		warn("Failed to get leaderboard data")
	end
	
	--[[local success, pages = pcall(function()
		return ROBUX_LEADERBOARD_DATA_STORE:GetSortedAsync(false, SETTINGS_MODULE.LeaderboardSpotsDisplayed, 2)
	end)
	if success then
		local data = pages:GetCurrentPage()
		for _, template in pairs(ROBUX_LEADER_HOLDER:GetChildren()) do
			if not template:IsA("UIListLayout") then
				template:Destroy()
			end
		end
		for rank,entry in pairs(data) do
			local template = LEADERBOARD_TEMPLATE:Clone()
			local Rank = template:WaitForChild("Rank")
			local Name = template:WaitForChild("Name")
			local value = template:WaitForChild("Value")
			local suc, entryName = pcall(function()
				return game.Players:GetNameFromUserIdAsync(entry.key)
			end)
			if not suc or not entryName then continue end
			Rank.Text = tostring(rank)
			
			if rank == 1 then
				Rank.TextColor3 = Color3.fromRGB(255, 215, 0)
			elseif rank == 2 then
				Rank.TextColor3 = Color3.fromRGB(192, 192, 192)
			elseif rank == 3 then
				Rank.TextColor3 = Color3.fromRGB(205, 127, 50)
			end
			
			Name.Text = tostring(entryName)
			value.Text = tostring("R$"..FORMAT_MODULE.Finalize(entry.value))
			template.LayoutOrder = rank
			template.Parent = ROBUX_LEADER_HOLDER
		end
	else
		warn("Failed to get leaderboard data")
	end--]]

	local success, pages = pcall(function()
		return TIME_LEADERBOARD_DATA_STORE:GetSortedAsync(false, SETTINGS_MODULE.LeaderboardSpotsDisplayed, 10)
	end)

	if success then
		local data = pages:GetCurrentPage()

		-- Clear old entries
		for _, template in pairs(TIME_LEADER_HOLDER:GetChildren()) do
			if not template:IsA("UIListLayout") then
				template:Destroy()
			end
		end

		-- Populate leaderboard
		for rank, entry in ipairs(data) do
			local template = TEMPLATES_FOLDER:WaitForChild("LeaderboardTemplateTime"):Clone()
			local Rank = template:WaitForChild("Rank")
			local Name = template:WaitForChild("Name")
			local value = template:WaitForChild("Value")
			
			local suc, entryName = pcall(function()
			return game.Players:GetNameFromUserIdAsync(entry.key)
			end)
			if not suc or not entryName then continue end

			Rank.Text = tostring(rank)
			if rank == 1 then
				Rank.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
			elseif rank == 2 then
				Rank.TextColor3 = Color3.fromRGB(192, 192, 192) -- Silver
			elseif rank == 3 then
				Rank.TextColor3 = Color3.fromRGB(205, 127, 50) -- Bronze
			end

			Name.Text = tostring(entryName)
			value.Text = formatTime(entry.value) -- <-- Here we format the time

			template.LayoutOrder = rank
			template.Parent = TIME_LEADER_HOLDER
			end
	else
		warn("Failed to get leaderboard data")
	end

	local success, pages = pcall(function()
		return DONATED_LEADERBOARD_DATA_STORE:GetSortedAsync(false, SETTINGS_MODULE.LeaderboardSpotsDisplayed, 2)
	end)

	if success then
		local data = pages:GetCurrentPage()

		-- Clear old entries
		for _, template in pairs(DONATED_LEADER_HOLDER:GetChildren()) do
			if not template:IsA("UIListLayout") then
				template:Destroy()
			end
		end
	--	print("e")

		-- Populate leaderboard
		for rank, entry in ipairs(data) do
			local template = TEMPLATES_FOLDER:WaitForChild("LeaderboardTemplateDonated"):Clone()
			local Rank = template:WaitForChild("Rank")
			local Name = template:WaitForChild("Name")
			local value = template:WaitForChild("Value")

			local suc, entryName = pcall(function()
				return game.Players:GetNameFromUserIdAsync(entry.key)
			end)
			if not suc or not entryName then continue end

			Rank.Text = tostring(rank)
			if rank == 1 then
				Rank.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
			elseif rank == 2 then
				Rank.TextColor3 = Color3.fromRGB(192, 192, 192) -- Silver
			elseif rank == 3 then
				Rank.TextColor3 = Color3.fromRGB(205, 127, 50) -- Bronze
			end

			Name.Text = tostring(entryName)
				value.Text = FORMAT_MODULE.Finalize(tonumber(entry.value)).."R$" -- <-- Here we format the time

			template.LayoutOrder = rank
			template.Parent = DONATED_LEADER_HOLDER
		end
	else
		warn("Failed to get leaderboard data")
	end

end	

local function DestroyAllBlocks()
	local blockSize = Vector3.new(SETTINGS_MODULE.BlockSize, SETTINGS_MODULE.BlockSize, SETTINGS_MODULE.BlockSize)
	local toDestroy = {}

	-- Collect first (fast, no yielding)
	for _, obj in ipairs(PARTS_FOLDER:GetChildren()) do
		if obj:IsA("BasePart") and obj.Size == blockSize then
			table.insert(toDestroy, obj)
		end
	end

	-- Destroy in chunks (avoid lag spikes)
	for i, part in ipairs(toDestroy) do
		part:Destroy()

		-- Yield every 100 destructions to keep performance stable
		if i % 100 == 0 then
			task.wait(0.1)
		end
	end
end


local function obbyCompletionEffects(player:Player)
	
end

local function checkIfImmunity(player:Player)
	local immunities = player:WaitForChild("Values"):WaitForChild("Immunities")
	if immunities.Value >= 1 then
		return true
		else return false
	end
end

local function useImmunity(player:Player)
	local immunities = player:WaitForChild("Values"):WaitForChild("Immunities")
	if immunities.Value >= 1 then
		immunities.Value -= 1
		NOTIFICATION_MODULE.PlayerNotification(player, "ImmunityUsed", 5,false,false,false,immunities.Value)
	end
end


local function killPlayer(player)
	while true do
	if player and player.Character then
		local hum = player.Character:FindFirstChild("Humanoid")
		if not hum then continue end
		hum.Health = 0
		--player:LoadCharacter()  -- forces respawn
		GRAVITY_EVENT:FireClient(player,"Back")
		SOUND_EVENT:FireClient(player, SOUNDS_FOLDER:WaitForChild("Oof"))
		break
	else
		continue
	  end
	end
end

local lastPlayerSpots = {}

local function resetPlayer(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	if not char then return end

	local humRoot = char:FindFirstChild("HumanoidRootPart")
	if humRoot then
		lastPlayerSpots[player.UserId] = humRoot.CFrame
	end

	local humanoid = char:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- Kill player
	humanoid.Health = 0

	player.CharacterAdded:Wait()

	task.wait(0.02)

	local newChar = player.Character
	if not newChar then return end

	local newHumRoot = newChar:WaitForChild("HumanoidRootPart", 5)
	if newHumRoot and lastPlayerSpots[player.UserId] then
		newHumRoot.CFrame = lastPlayerSpots[player.UserId]
		print("Returned to last spot")
		lastPlayerSpots[player.UserId] = nil
	end
end


local partsOn = {}

local function setAnchored(part)
	task.delay(10, function()
		repeat wait() until not partsOn[part]
		
		if part and part.Parent then
			if part:IsA("Part") then
				part.Anchored = true
			else
			for _, object in pairs(part:GetChildren()) do
					if object:IsA("Part") or object:IsA("MeshPart") or object:IsA("BasePart") then
					object.Anchored = true
					end
			   end
			end
		end
	end)
end

local function turnIntoBanana(targetPlayer:Player)
	task.spawn(function()
	task.wait(0.1)
	local banana = SERVER_STORAGE:WaitForChild("Banana"):Clone()
	banana.Name = targetPlayer.Name -- Character must match player name
	banana:WaitForChild("HumanoidRootPart").Position = targetPlayer.Character:WaitForChild("HumanoidRootPart").Position
	targetPlayer.Character = banana
	banana.Parent = workspace
	targetPlayer:SetAttribute("HasBanana", true)


	task.wait(SETTINGS_MODULE.BananaTime)
	targetPlayer:SetAttribute("HasBanana", false)
	resetPlayer(targetPlayer)
	end)
end

local function doFireEvent(player:Player)
	task.spawn(function()
		local fire = Instance.new("Fire")
		fire.Size = 15
		fire.Parent = player.Character:WaitForChild("HumanoidRootPart")
		local humanoid = player.Character:WaitForChild("Humanoid")
		SOUND_EVENT:FireClient(player, SOUNDS_FOLDER:WaitForChild("FireAlarm"))
		repeat humanoid.Health -= 1 wait(math.random(0.2,0.5)) until
		humanoid.Health == 0
		if not fire then return end
		fire:Destroy()
	end)
end

local function checkMagnitude(part: Part)
	local endPart = workspace:WaitForChild("Ramp"):WaitForChild("End")
	
		task.delay(15, function()
		--print((endPart.Position - part.Position).Magnitude)
		if (endPart.Position - part.Position).Magnitude > 255 then
			setAnchored(part)
		else part:Destroy()
		end
		end)
end


local function addToBlockQueue(amount)
	serverBlockQueueValue.Value += tonumber(amount)
end

local function spawnBlocks(amount)
	for i = 1, amount do
		
		if NUM_PLAYERS < 10 then task.wait(0.05)
			else
			task.wait(0.08)
		end

		local newPart = Instance.new("Part")
		newPart.Anchored = false
		newPart.CanCollide = true
		newPart.CanTouch = true
		newPart.CastShadow = false
		newPart.Parent = PARTS_FOLDER

		-- Mark as special block
		newPart:SetAttribute("IsGameBlock", true)

		-- Shape
		if SETTINGS_MODULE.IncludeSpheres and math.random(1,2) == 2 then
			newPart.Shape = Enum.PartType.Ball
		else
			newPart.Shape = Enum.PartType.Block
		end

		-- Size
		local studSize
		if SETTINGS_MODULE.DoRandomSize then
			studSize = math.random(1, SETTINGS_MODULE.BlockSize)
		else
			studSize = SETTINGS_MODULE.BlockSize
		end
		newPart.Size = Vector3.new(studSize, studSize, studSize)

		-- Position + Color
		newPart.Position = BLOCKS_SPAWN.Position + Vector3.new(math.random(-100,100), 5, 0)
		newPart.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))

		-- Schedule anchor
		coroutine.wrap(function()
		checkMagnitude(newPart)
		end)()
	end
end

local brainRots = SERVER_STORAGE:WaitForChild("Brainrots"):GetChildren()

local function spawnBrainrots(amount)
	for i = 1, amount do
		task.wait(0.05)
		local index = math.random(1, #brainRots)
		local newPart = brainRots[index]:Clone()
		
		for _, object in newPart:GetChildren() do
			if object:IsA("BasePart") or object:IsA("Part") or object:IsA("MeshPart") then
			object.Anchored = false
			object.CanCollide = true
			object.CanTouch = true
			object.CastShadow = false
			end
		end

		newPart.Parent = PARTS_FOLDER

		-- Mark as special block
		newPart:SetAttribute("IsGameBlock", true)



		local offset = Vector3.new(math.random(-100,100), 5, 0)
		newPart:PivotTo(CFrame.new(BLOCKS_SPAWN.Position + offset))

	end
end


--// Track parts on bottomPart
local bottomPart = workspace:WaitForChild("Ramp"):WaitForChild("BottomPart")

--[[bottomPart.Touched:Connect(function(hit)
	if (hit.Parent == PARTS_FOLDER) then
			partsOn[hit] = true
			task.delay(SETTINGS_MODULE.BlockIdleTimeout, function()
				if hit and hit.Parent == PARTS_FOLDER and partsOn[hit] then
					hit:Destroy()
					partsOn[hit] = nil
				end
			end)
		end
end)--]]

--[[bottomPart.TouchEnded:Connect(function(hit)
	if (hit.Parent == PARTS_FOLDER) then
		partsOn[hit] = nil
		
		if hit.Anchored == true then
			hit:Destroy()
		else for _, item in pairs(hit:GetChildren()) do
				if item:IsA("Part") or item:IsA("BasePart") and item.Anchored == true then
					--print("ANCHOR")
					hit:Destroy()
					break
				end
			end
		end
	end
end)--]]

local processingQueue = false -- prevents multiple loops

-- Drain queue when it changes
serverBlockQueueValue.Changed:Connect(function()
	if processingQueue then return end
	processingQueue = true

	while serverBlockQueueValue.Value > 0 do
		if SETTINGS_MODULE.IsBrainRots then
		spawnBrainrots(1)
		else
			spawnBlocks(1)
		end
		serverBlockQueueValue.Value -= 1
	end

	processingQueue = false
end)


local function sendObbyWebhook(player, ObbyNumber, studs, ObbyName)
	local data = {
		embeds = {{
			title = "Obby Completed",
			color = 0xED4245, -- red
			fields = {
				{
					name = "Player",
					value = player.Name,
					inline = true
				},
				{
					name = "User ID",
					value = tostring(player.UserId),
					inline = true
				},
				{
					name = "Obby Name",
					value = ObbyName
				},
				{ 
					
				name = "Studs",
				value = studs,
				inline = true ,
				
				},
			},
			footer = { text = "Roblox Game Logs" },
			timestamp = DateTime.now():ToIsoDate()
		}}
	}

	HTTPS_SERVICE:PostAsync(obbiesWebhook, HTTPS_SERVICE:JSONEncode(data))
end
local function sendRobuxWebhook(player, price, product,isBig)
	local data = {
		embeds = {{
			title = "Robux Purchase",
			color = 0xFDDA0D, -- green color (decimal or hex)
			fields = {
				{
					name = "Player",
					value = player.Name,
					incline = true

				},
				{
					name = "Product",
					value = product,
					inline = true
				},
				{
					name = "Price",
					value = "?"..price,
					inline = true

				},

			},
			footer = {
				text = "Roblox Game Logs"
			},
			timestamp = DateTime.now():ToIsoDate()
		}}
	}
	
	if isBig then
		HTTPS_SERVICE:PostAsync(bigRobuxHook, HTTPS_SERVICE:JSONEncode(data))
	else
		HTTPS_SERVICE:PostAsync(robuxWebhook, HTTPS_SERVICE:JSONEncode(data))
	end
end


local currentSkyTween = nil
local currentSkyTask = nil

local function skyTween(HoldTime, TintColor)
	local colorCorrection = game:GetService("Lighting"):WaitForChild("ColorCorrection")
	local tweenInfo = TweenInfo.new(0.3)

	-- Cancel previous tween
	if currentSkyTween then
		currentSkyTween:Cancel()
		currentSkyTween = nil
	end

	-- Cancel previous hold/reset task
	if currentSkyTask then
		coroutine.close(currentSkyTask) -- or use a flag to stop it
		currentSkyTask = nil
	end

	-- Start new tint tween
	currentSkyTween = TWEEN_SERVICE:Create(colorCorrection, tweenInfo, {TintColor = TintColor})
	currentSkyTween:Play()

	-- Start a coroutine to wait and reset
	currentSkyTask = coroutine.create(function()
		task.wait(HoldTime)
		currentSkyTween = TWEEN_SERVICE:Create(colorCorrection, tweenInfo, {TintColor = Color3.fromRGB(231, 242, 255)})
		currentSkyTween:Play()
	end)
	coroutine.resume(currentSkyTask)
end





local function ProcessReceipt(ReceiptInfo)
	local productInfo = MARKET_PLACE_SERVICE:GetProductInfo(ReceiptInfo.ProductId, Enum.InfoType.Product)
local productPrice = productInfo.PriceInRobux
local productName = productInfo.Name

local player = PLAYERS:GetPlayerByUserId(ReceiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	if productPrice >= 60 then sendRobuxWebhook(player, productPrice, productName, true)
	end

   if  SETTINGS_MODULE.ProductIds[ReceiptInfo.ProductId] then
	local blockAmount = SETTINGS_MODULE.ProductIds[ReceiptInfo.ProductId] if not blockAmount then return end
	local leaderstats = player:WaitForChild("leaderstats")
	local robuxStat = player:WaitForChild("Values"):FindFirstChild(SETTINGS_MODULE.RobuxName)
	local partsStat = leaderstats:FindFirstChild(SETTINGS_MODULE.PartsName)
	if not robuxStat or not partsStat then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	robuxStat.Value += tonumber(productPrice)
	partsStat.Value += tonumber(blockAmount)
	
		sendRobuxWebhook(player, productPrice, productName)
		NOTIFICATION_MODULE.Notify("Purchase", blockAmount, player, 7)
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
	addToBlockQueue(blockAmount)
	
		player:WaitForChild("Values"):WaitForChild("TotalStudsContributed").Value += blockAmount

	
	if blockAmount <= 30 then
		SERVER_MULTIPLIER.Value += 0.1
	else SERVER_MULTIPLIER.Value += 0.5 end
	
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
   elseif ReceiptInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.FireAll then
		if not RUN_SERVICE:IsStudio() then
			local leaderstats = player:WaitForChild("leaderstats")
			local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
			Robux.Value += productPrice	
		end
		
		NOTIFICATION_MODULE.Notify("FireAll", 0, player, 5)
		for _, target in pairs(PLAYERS:GetChildren()) do
			if checkIfImmunity(target) then useImmunity(target) continue end

			doFireEvent(target)
		end
		
		sendRobuxWebhook(player, productPrice, productName)
return Enum.ProductPurchaseDecision.PurchaseGranted
   
		
   elseif ReceiptInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs["Spawn250"] then
		if not RUN_SERVICE:IsStudio() then
			sendRobuxWebhook(player, productPrice, productName)
			local leaderstats = player:WaitForChild("leaderstats")
			local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
			Robux.Value += productPrice	
		end
		addToBlockQueue(250)
		NOTIFICATION_MODULE.Notify("Purchase", 250, player, 10)
		NOTIFICATION_MODULE.PlayerNotification(player,"RobuxPurchase", 5)
		SERVER_MULTIPLIER.Value += 0.5
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
   elseif ReceiptInfo.ProductId == SETTINGS_MODULE.DestroyId then
		NOTIFICATION_MODULE.Notify("Destroy", 0, player, 10)
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		if not RUN_SERVICE:IsStudio() then
			sendRobuxWebhook(player, productPrice, productName)
		   local leaderstats = player:WaitForChild("leaderstats")
		   local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		   Robux.Value += productPrice
		end
DestroyAllBlocks()
	   
		SERVER_MULTIPLIER.Value += 1
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
   elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.KillAll then
		NOTIFICATION_MODULE.Notify("KillAll", 0, player, 5)
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)

		local leaderstats = player:WaitForChild("leaderstats")
		local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		if not RUN_SERVICE:IsStudio() then
			sendRobuxWebhook(player, productPrice, productName)
			Robux.Value += productPrice
		end
		for _, Player in pairs(PLAYERS:GetChildren()) do
			if checkIfImmunity(player) then useImmunity(player) continue end

			killPlayer(Player)
		end
		
		SERVER_MULTIPLIER.Value += 0.5
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
		
   elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.Banana then
		NOTIFICATION_MODULE.Notify("Banana", 0, player, 10)
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		sendRobuxWebhook(player, productPrice, productName)

		if not RUN_SERVICE:IsStudio() then
			player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName).Value += productPrice
		end
	
		for _, target in pairs(PLAYERS:GetChildren()) do
			if checkIfImmunity(player) then useImmunity(player) continue end

			turnIntoBanana(target)
		end
		SERVER_MULTIPLIER.Value += 0.2
   return Enum.ProductPurchaseDecision.PurchaseGranted
		
	elseif productInfo.ProductId == SETTINGS_MODULE.Buy100 then
		NOTIFICATION_MODULE.Notify("Purchase", 100, player, 10)
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)

					sendRobuxWebhook(player, productPrice, productName)
		if not RUN_SERVICE:IsStudio() then
			local leaderstats = player:WaitForChild("leaderstats")	
			local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
			robux.Value += productPrice
		end
		addToBlockQueue(100)
		
		SERVER_MULTIPLIER.Value += 0.5
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs["GlobalManiac"] then
		print("PUBLISHING")
		local suc, errorMsg = pcall(function()
		MESSAGING_SERVICE:PublishAsync("Global100Studs", {Name = player.Name})
		end)
		if suc then print("Success") else warn(errorMsg) end
		sendRobuxWebhook(player, productPrice, productName)
		local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		Robux.Value += productPrice
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		SERVER_MULTIPLIER.Value += 0.5
	return Enum.ProductPurchaseDecision.PurchaseGranted
	
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs["GlobalRemove"] then
		print("PUBLISHING")
		local suc, errorMsg = pcall(function()
			MESSAGING_SERVICE:PublishAsync("GlobalDestroy", {Name = player.Name})
		end)
		if suc then print("Success") else warn(errorMsg) end
		sendRobuxWebhook(player, productPrice, productName)
		local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		if not RUN_SERVICE:IsStudio() then
		Robux.Value += productPrice
		end
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		SERVER_MULTIPLIER.Value += 3
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs["GlobalKill"] then
		print("PUBLISHING")
		local suc, errorMsg = pcall(function()
			MESSAGING_SERVICE:PublishAsync("GlobalKill", {Name = player.Name})
		end)
	if suc then 
		print("Success") else warn(errorMsg) end
		sendRobuxWebhook(player, productPrice, productName)
		local Robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		if not RUN_SERVICE:IsStudio() then
		Robux.Value += productPrice
		end
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		SERVER_MULTIPLIER.Value += 2
		return Enum.ProductPurchaseDecision.PurchaseGranted	
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.Immunity then
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		if not RUN_SERVICE:IsStudio() then
			robux.Value += productPrice
		end
		local immunity = player:WaitForChild("Values"):WaitForChild("Immunities")
		immunity.Value += 1
		NOTIFICATION_MODULE.PlayerNotification(player,"Immunity", 5, false, false, false, immunity.Value)
		
		sendRobuxWebhook(player, productPrice, productName)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.Compliment then
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		robux.Value += productPrice
		NOTIFICATION_MODULE.PlayerNotification(player, "Compliment", 8)
		sendRobuxWebhook(player, productPrice, productName)
		
		SERVER_MULTIPLIER.Value += 0.1
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.TempSpeed then
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		robux.Value += productPrice
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		local clone1 = SERVER_STORAGE:FindFirstChild("SpeedCoil"):Clone()
		local clone2 = SERVER_STORAGE:FindFirstChild("SpeedCoil"):Clone()
		if clone1 and clone2 then
			clone1.Parent = player.Backpack
			clone2.Parent = player.StarterGear
			sendRobuxWebhook(player, productPrice, productName)
			
			SERVER_MULTIPLIER.Value += 0.2
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
	elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.TempSlap then
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		robux.Value += productPrice
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		local clone1 = SERVER_STORAGE:FindFirstChild("Slap Hand"):Clone()
		local clone2 = SERVER_STORAGE:FindFirstChild("Slap Hand"):Clone()
		if clone1 and clone2 then
			clone1.Parent = player.Backpack
			clone2.Parent = player.StarterGear
			sendRobuxWebhook(player, productPrice, productName)
			
			SERVER_MULTIPLIER.Value += 0.2
			return Enum.ProductPurchaseDecision.PurchaseGranted
			end
		elseif productInfo.ProductId == SETTINGS_MODULE.ShopRobuxIDs.TeleportAll then
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
			
			if not RUN_SERVICE:IsStudio() then
				robux.Value += productPrice
			end
			NOTIFICATION_MODULE.Notify("TeleportAll", 0, player, 5)
			NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
			
		for _, target in pairs(PLAYERS:GetPlayers()) do
			if checkIfImmunity(player) then useImmunity(player) continue end

			coroutine.wrap(function()
				if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					local root = target.Character.HumanoidRootPart
					local targetRoot = player.Character.HumanoidRootPart
					root.CFrame = targetRoot.CFrame + Vector3.new(0, 25, 0)
				end
			end)()
		end

				return Enum.ProductPurchaseDecision.PurchaseGranted
				
		elseif table.find(SETTINGS_MODULE.DoubleUpgradeJustProducts, productInfo.ProductId) then
		SERVER_MULTIPLIER.Value = SERVER_MULTIPLIER.Value * 2
		
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		sendRobuxWebhook(player, productPrice, productName)
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
			if not RUN_SERVICE:IsStudio() then
				robux.Value += productPrice
			end
		NOTIFICATION_MODULE.Notify("DoubleMultiplier", 0, player, 10)
			return Enum.ProductPurchaseDecision.PurchaseGranted
		
	elseif table.find(SETTINGS_MODULE.DonationIDS, productInfo.ProductId) then
		local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
		local donated = player:WaitForChild("Values"):WaitForChild("Donated")
		if not RUN_SERVICE:IsStudio() then
			robux.Value += productPrice
		end
		donated.Value += productPrice
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)
		sendRobuxWebhook(player, productPrice, productName)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	
		
	end
end

MARKET_PLACE_SERVICE.ProcessReceipt = ProcessReceipt

for _, Button in pairs(BUTTONS_FOLDER:GetChildren()) do
	local prox = Button:FindFirstChild("MeshPart"):FindFirstChild("ProximityPrompt")
	local blockAmount = string.gsub(Button.Name, "Button", "")
	if not prox or not blockAmount then continue end

	prox.Triggered:Connect(function(player)
		if Button.Name ~= "bigBlock" then
			local productID = SETTINGS_MODULE.BlockIds[tonumber(blockAmount)]
			if not productID then return end
			MARKET_PLACE_SERVICE:PromptProductPurchase(player, productID)
		end
	end)
end


MARKET_PLACE_SERVICE.PromptGamePassPurchaseFinished:Connect(function(player, passId, wasPurchased)
	local leaderstats = player:WaitForChild("leaderstats")
	local robux = player:WaitForChild("Values"):WaitForChild(SETTINGS_MODULE.RobuxName)
	local info = MARKET_PLACE_SERVICE:GetProductInfo(passId, Enum.InfoType.GamePass)
	if wasPurchased then
		NOTIFICATION_MODULE.PlayerNotification(player, "RobuxPurchase", 5)

		local price = info.PriceInRobux
		local name = info.Name
		local data = {
			embeds = {{
				title = "Robux Purchase",
				color = 0xFDDA0D, -- green color (decimal or hex)
				fields = {
					{
						name = "Player",
						value = player.Name,
						incline = true
						
					},
					{
						name = "Product",
						value = name,
						inline = true
					},
					{
					    name = "Price",
						value = "?"..price,
						inline = true
						
					},
					
				},
				footer = {
					text = "Roblox Game Logs"
				},
				timestamp = DateTime.now():ToIsoDate()
			}}
		}
		HTTPS_SERVICE:PostAsync(robuxWebhook, HTTPS_SERVICE:JSONEncode(data))
		HTTPS_SERVICE:PostAsync(bigRobuxHook, HTTPS_SERVICE:JSONEncode(data))
	end
	
	if wasPurchased and passId == SETTINGS_MODULE.DoubleStudID then
		local valuesFolder = player:WaitForChild("Values")
		local OwnsPass = valuesFolder:WaitForChild("OwnsDoubleParts").Value
		if OwnsPass then return end
		valuesFolder:WaitForChild("OwnsDoubleParts").Value = true
		robux.Value += info.PriceInRobux
	end
	if wasPurchased and passId == SETTINGS_MODULE.CoilId then
		if player.Backpack:FindFirstChild("Fusion Coil") then player.Backpack:FindFirstChild("Fusion Coil"):Destroy() end
		if player.StarterGear:FindFirstChild("Fusion Coil") then player.StarterGear:FindFirstChild("Fusion Coil"):Destroy() end
		
		local coil = SERVER_STORAGE:WaitForChild("Fusion Coil"):Clone()
		coil.Parent = player.Backpack
		if not RUN_SERVICE:IsStudio() then
		robux.Value += info.PriceInRobux
		
		SERVER_MULTIPLIER.Value += 0.7
		end
	elseif wasPurchased and passId == SETTINGS_MODULE.CarpetId then
		if player.Backpack:FindFirstChild("FlyingCarpet") then player.Backpack:FindFirstChild("FlyingCarpet"):Destroy() end
		if player.StarterGear:FindFirstChild("FlyingCarpet") then player.StarterGear:FindFirstChild("FlyingCarpet"):Destroy() end
		
		local carpet = SERVER_STORAGE:WaitForChild("FlyingCarpet"):Clone()
		carpet.Parent = player.Backpack
		if not RUN_SERVICE:IsStudio() then
			robux.Value += info.PriceInRobux
		end
		SERVER_MULTIPLIER.Value += 1
	elseif wasPurchased and passId == SETTINGS_MODULE.SlapID then
		if player.Backpack:FindFirstChild("Slap Hand") then player.Backpack:FindFirstChild("Slap Hand"):Destroy() end
		if player.StarterGear:FindFirstChild("Slap Hand") then player.StarterGear:FindFirstChild("Slap Hand"):Destroy() end
		
		local slap = SERVER_STORAGE:WaitForChild("Slap Hand"):Clone()
		  slap.Parent = player.Backpack
		if not RUN_SERVICE:IsStudio() then
			robux.Value += info.PriceInRobux
		end
		SERVER_MULTIPLIER.Value += 0.7
		
	elseif wasPurchased and passId == SETTINGS_MODULE.AdminId then
		if not RUN_SERVICE:IsStudio() then
		robux.Value += info.PriceInRobux
		end
		SERVER_MULTIPLIER.Value += 2

	end
end)


local function givePartsToAllPlayers(amount:number)
	for _, player in pairs(PLAYERS:GetPlayers()) do
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then return end 
		local Parts = leaderstats:FindFirstChild(SETTINGS_MODULE.PartsName)
		if not Parts then return end 

		Parts.Value += tonumber(amount)
	end
end

local currentGoalIndex = 1
local rewardDebounce = false

local function detectServerGoal()
	local partsAmount = #PARTS_FOLDER:GetChildren()

	if isGlobalRemoving or isServerRemoving then
		currentGoalIndex = 1
		EVENTS_FOLDER:WaitForChild("UpdateCompletionPercent"):FireAllClients(SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal)
		EVENTS_FOLDER:WaitForChild("UpdateServerReward"):FireAllClients(
			SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal,
			SETTINGS_MODULE.serverRewards[currentGoalIndex].Reward
		)
		return
	end

--checks if goal already maxed, if its not, it will change players ui to match blocks
	if not (currentGoalIndex > #SETTINGS_MODULE.serverRewards) then
		EVENTS_FOLDER:WaitForChild("UpdateCompletionPercent"):FireAllClients(SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal)
	end


	-- ? Always check for reset first
	if partsAmount == 0 then
		print("RESETTING")
		-- Reset to first goal when studs are cleared
		currentGoalIndex = 1
		EVENTS_FOLDER:WaitForChild("UpdateServerReward"):FireAllClients(
			SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal,
			SETTINGS_MODULE.serverRewards[currentGoalIndex].Reward
		)
		EVENTS_FOLDER:WaitForChild("UpdateCompletionPercent"):FireAllClients(SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal)
		--print("Reset to Goal 1")
		return
	end

--------------------------------------------------------------------------------------------------------------------------------------- all above is fine
	-- Get current goal
	if currentGoalIndex > #SETTINGS_MODULE.serverRewards then return end

	local goalData = SETTINGS_MODULE.serverRewards[currentGoalIndex]
	local CURRENT_STUD_GOAL = goalData.Goal
	local CURRENT_STUD_REWARD = goalData.Reward

	-- ? Normal progression
	if partsAmount >= CURRENT_STUD_GOAL then
		if rewardDebounce then return end
		rewardDebounce = true
		--print("Server reached goal "..CURRENT_STUD_GOAL.."! Reward: "..CURRENT_STUD_REWARD)
		NOTIFICATION_MODULE.Notify("ServerReward", CURRENT_STUD_REWARD, nil, 8)

		-- Give reward
		givePartsToAllPlayers(CURRENT_STUD_REWARD)

		-- Move to next goal
		currentGoalIndex += 1	
		
		
		
		

		coroutine.wrap(function()
			local data = {
				embeds = {{
					title = "Server Reward",
					color = 0xED4245, -- red
					fields = {
						{
							name = "ServerId",
							value = tostring(game.JobId) or "Studio",
							inline = true
						},
						{
							name = "Reward Amount",
							value = tostring(CURRENT_STUD_REWARD),
							inline = true
						},
						{
							name = "Goal",
							value = tostring(CURRENT_STUD_GOAL),
							inline = true
						},
						{ 
							name = "Players Rewarded",
							value = tostring(#PLAYERS:GetChildren()),
							inline = true,
						},
						{
							name = "Total Studs Rewarded",
							value = (CURRENT_STUD_REWARD)*(#PLAYERS:GetChildren()),
							inline = true
						},
					},
					footer = { text = "Roblox Game Logs" },
					timestamp = DateTime.now():ToIsoDate()
				}}
			}

			HTTPS_SERVICE:PostAsync(serverRewardHook, HTTPS_SERVICE:JSONEncode(data))
		end)()

		if not (currentGoalIndex > #SETTINGS_MODULE.serverRewards) then
			EVENTS_FOLDER:WaitForChild("UpdateCompletionPercent"):FireAllClients(SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal)
		end

		--print(currentGoalIndex)

		-- Send next goal or max reached message
		if currentGoalIndex <= #SETTINGS_MODULE.serverRewards then
			local nextGoal = SETTINGS_MODULE.serverRewards[currentGoalIndex]
			EVENTS_FOLDER:WaitForChild("UpdateServerReward"):FireAllClients(nextGoal.Goal, nextGoal.Reward)
		else
			EVENTS_FOLDER:WaitForChild("UpdateServerReward"):FireAllClients(
				"Max Goal Reached",
				"Destroy Studs to Reset"
			)
		end
		task.wait(3)
		rewardDebounce = false
	end
end

local recentChange = false
local function safeDetect()
--	if recentChange then return end
	--recentChange = true
	--task.delay(0.5, function() recentChange = false end)
	detectServerGoal()
end

PARTS_FOLDER.ChildAdded:Connect(safeDetect)
PARTS_FOLDER.ChildRemoved:Connect(safeDetect)




coroutine.wrap(function()
	--while not RUN_SERVICE:IsStudio() do
	while true do
	getLeaderboardTop()
		task.wait(SETTINGS_MODULE.TimeBetweenLeaderboardUpdates)
		end
	--end
end)()

local function setupTotalBlocks(player:Player)
	UPDATE_BLOCKS_EVENT:FireClient(player, NUM_PARTS)
end

PARTS_FOLDER.ChildAdded:Connect(function()
	NUM_PARTS = #PARTS_FOLDER:GetChildren()
	UPDATE_BLOCKS_EVENT:FireAllClients(NUM_PARTS)
end)

PARTS_FOLDER.ChildRemoved:Connect(function()
	NUM_PARTS = #PARTS_FOLDER:GetChildren()
	UPDATE_BLOCKS_EVENT:FireAllClients(NUM_PARTS)
end)

INNER_CIRCLE.Touched:Connect(function(hit)
	local Humanoid = hit.Parent:FindFirstChild("Humanoid")
	if Humanoid then
		Humanoid.Health = 0
	end
end)

local function setupGamepassTools(player: Player)
	if MARKET_PLACE_SERVICE:UserOwnsGamePassAsync(player.UserId, SETTINGS_MODULE.CarpetId) then
		local carpet = SERVER_STORAGE:WaitForChild("FlyingCarpet")
		if carpet and not player.Backpack:FindFirstChild("FlyingCarpet") then
			local tool1 = carpet:Clone()
			tool1.Parent = player.Backpack

			local tool2 = carpet:Clone()
			tool2.Parent = player.StarterGear
		   end
		end
		if MARKET_PLACE_SERVICE:UserOwnsGamePassAsync(player.UserId, SETTINGS_MODULE.CoilId) then
			local coil = SERVER_STORAGE:WaitForChild("Fusion Coil")
			if coil and not player.Backpack:FindFirstChild("Fusion Coil") then
				local tool1 = coil:Clone()
				tool1.Parent = player.Backpack

				local tool2 = coil:Clone()
				tool2.Parent = player.StarterGear
			end
		end
		if MARKET_PLACE_SERVICE:UserOwnsGamePassAsync(player.UserId, SETTINGS_MODULE.SlapID) then
			local slapTool = SERVER_STORAGE:WaitForChild("Slap Hand")
			if slapTool and not player.Backpack:FindFirstChild("Slap Hand") then
				local tool1 = slapTool:Clone()
				tool1.Parent = player.Backpack

				local tool2 = slapTool:Clone()
				tool2.Parent = player.StarterGear
			end
		end
	end
	
		
		
local function giveBackTools(character)
	local player = PLAYERS:GetPlayerFromCharacter(character)
	if player then
		setupGamepassTools(player)
	end
end

	



local PlayerObbyDebounces = {} --[player][obbynumber] = true/false
local partsToReward
local isInObbies = {}
local function connectObby(Obby, obbyNumber)
	local endPart = Obby:FindFirstChild("End")
	local startPart = Obby:FindFirstChild("Start")
	local backPart = Obby:FindFirstChild("Back")
	if not endPart or not startPart then return end

	-- Connect End part if not already connected
	if not endPart:GetAttribute("Connected") then
		endPart:SetAttribute("Connected", true)

		endPart.Touched:Connect(function(hit)
			local char = hit.Parent
			local humanoid = char and char:FindFirstChild("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local player = humanoid and PLAYERS:GetPlayerFromCharacter(char)
			if not player or not hrp then return end
			
			local valuesFolder = player:WaitForChild("Values")
			local unlockedArea2 = valuesFolder:FindFirstChild("UnlockedArea2")

			if tonumber(obbyNumber) >= 50 and (not unlockedArea2 or unlockedArea2.Value ~= true) then
				NOTIFICATION_MODULE.PlayerNotification(player, "NotUnlockedArea2", 5)
				killPlayer(player)
				return
			end


			PlayerObbyDebounces[player.UserId] = PlayerObbyDebounces[player.UserId] or {}
			if PlayerObbyDebounces[player.UserId][tostring(obbyNumber)] then return end
			PlayerObbyDebounces[player.UserId][tostring(obbyNumber)] = true

			-- Reward player
			local leaderstats = player:FindFirstChild("leaderstats")
			local playerOwnsDouble = player:WaitForChild("Values"):WaitForChild("OwnsDoubleParts").Value
			local Parts = leaderstats and leaderstats:FindFirstChild(SETTINGS_MODULE.PartsName)
			local ObbiesCompleted = player:FindFirstChild("Values"):FindFirstChild("ObbiesCompleted")
			if leaderstats and Parts and ObbiesCompleted then
				if playerOwnsDouble then
				 partsToReward = (math.floor(((SETTINGS_MODULE.ObbyRewards[tonumber(obbyNumber)]) * SERVER_MULTIPLIER.Value) * player:WaitForChild("Values"):WaitForChild("PlayerMultiplier").Value)) * 2
				else
				 partsToReward = math.floor(((SETTINGS_MODULE.ObbyRewards[tonumber(obbyNumber)]) * SERVER_MULTIPLIER.Value) * player:WaitForChild("Values"):WaitForChild("PlayerMultiplier").Value)
				 end
				 SERVER_MULTIPLIER.Value += SETTINGS_MODULE.ObbyMultiIncreases[tonumber(obbyNumber)]
				 player:WaitForChild("Values"):WaitForChild("TotalStudsContributed").Value += partsToReward
				if not RUN_SERVICE:IsStudio() then
					Parts.Value += partsToReward
				end
			end

			-- Notification and spawn blocks
			local suc, err = pcall(function()
			sendObbyWebhook(player, obbyNumber, partsToReward, SETTINGS_MODULE.ObbyNames[tonumber(obbyNumber)] or "No Name")
			end)
			ObbiesCompleted.Value += 1
			player:WaitForChild("Values"):WaitForChild("ObbiesLastMinute").Value += 1
			NOTIFICATION_MODULE.Notify("Obby", partsToReward, player, 5)
			addToBlockQueue(partsToReward)
			
			lastPlayerObbies[player.UserId] = tonumber(obbyNumber)
			justCompletedObbys[player.UserId] = true
			isInObby[player.UserId] = false
			
			coroutine.wrap(function()
				task.delay(5, function()
					justCompletedObbys[player.UserId] = false
				end)
			end)()

			-- Kill / respawn player
			killPlayer(player)
			

			-- Reset debounce after 10 seconds
			task.delay(10, function()
				PlayerObbyDebounces[player.UserId][tostring(obbyNumber)] = false
			end)
		end)
	end

	-- Connect Back part if exists
	if backPart and not backPart:GetAttribute("Connected") then
		backPart:SetAttribute("Connected", true)

		backPart.Touched:Connect(function(hit)
			local player = PLAYERS:GetPlayerFromCharacter(hit.Parent)
			if player then
				killPlayer(player)
			end
		end)
	end
end


EVENTS_FOLDER:WaitForChild("SendPlayerNotification").OnServerEvent:Connect(function(player, type)
	NOTIFICATION_MODULE.PlayerNotification(player,type,5)
end)

--// Teleporters
local function teleportToObby()
	for _, teleporter in pairs(OBBY_TELEPORTS:GetChildren()) do
		teleporter.Touched:Connect(function(hit)
			local char = hit.Parent
			local humanoid = char and char:FindFirstChild("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local player = humanoid and PLAYERS:GetPlayerFromCharacter(char)
			if not humanoid or not hrp or not player then return end

			-- Get target obby
			local teleportName = teleporter.Name:gsub("Teleport", "")
			local Obby = OBBIES:FindFirstChild(teleportName)
			if not Obby then return end

			local obbyNumber = (Obby.Name:gsub("Obby", ""))
			local startPart = Obby:FindFirstChild("Start")
			if not startPart then return end

			-- Teleport player to start
			hrp.CFrame = startPart.CFrame + Vector3.new(0,3,0) -- slight offset
			isInObby[player.UserId] = true
			isInObbies[player.UserId] = tonumber(obbyNumber)
			if tonumber(obbyNumber) == 4 then
				
				task.spawn(function()
				wait(0.5)
				if isInObbies[player.UserId] == tonumber(4) then
			GRAVITY_EVENT:FireClient(player, "To")
			end
				end)
				
			end
			
			task.spawn(function()
				timeInObby[player.UserId] = 0
				repeat timeInObby[player.UserId] = timeInObby[player.UserId] + 1 task.wait(1) until 
				isInObby[player.UserId] == false or not PLAYERS:FindFirstChild(player.Name)
			end)

			-- Ensure obby is connected
			connectObby(Obby, obbyNumber)
		end)
	end
end

--// Reset connections on server start
for _, obby in pairs(OBBIES:GetChildren()) do
	local endPart = obby:FindFirstChild("End")
	if endPart then endPart:SetAttribute("Connected", false) end
	local backPart = obby:FindFirstChild("Back")
	if backPart then backPart:SetAttribute("Connected", false) end
end


--// Start teleport connections
teleportToObby()
local activeRewardLoops = {}

local function DoRewardQueue(player)
	local leaderstats = player:WaitForChild("leaderstats")
	local Parts = leaderstats:WaitForChild(SETTINGS_MODULE.PartsName)

	-- mark loop as active
	activeRewardLoops[player.UserId] = true

	while activeRewardLoops[player.UserId] and player.Parent == PLAYERS do
		for i = SETTINGS_MODULE.RewardTime, 0, -1 do
			if not activeRewardLoops[player.UserId] or not PLAYERS:FindFirstChild(player.Name) then
				return -- stop immediately if player leaves
			end
			task.wait(1)
			REWARD_TIME_EVENT:FireClient(player, i)
		end

		if Parts and activeRewardLoops[player.UserId] then
				Parts.Value += SETTINGS_MODULE.RewardBlockAmount
			addToBlockQueue(SETTINGS_MODULE.RewardBlockAmount)
			NOTIFICATION_MODULE.Notify("Reward", SETTINGS_MODULE.RewardBlockAmount, player, 5)
			
			local Data = {
				embeds = {{
					title = "Player Rewarded",
					color = 0xED4245, -- red
					fields = {
						{
							name = "Player",
							value = player.Name,
							inline = true
						},
						{
							name = "UserId",
							value = player.UserId,
							inline = true
						},
						{
							name = "Reward",
							value = SETTINGS_MODULE.RewardBlockAmount,
							inline = true,
						},
					},
					footer = { text = "Roblox Game Logs" },
					timestamp = DateTime.now():ToIsoDate()
				}}
			}

			HTTPS_SERVICE:PostAsync(playerRewardHook, HTTPS_SERVICE:JSONEncode(Data))
		end
	end
end


EVENTS_FOLDER:WaitForChild("BackToObby").OnServerEvent:Connect(function(player)
	if lastPlayerObbies[player.UserId] then
		if not (justCompletedObbys[player.UserId] or isInObby[player.UserId]) then
			return
		end

		local lastObby = lastPlayerObbies[player.UserId]
		local obby = OBBIES:FindFirstChild("Obby" .. lastObby)
		if obby then
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = obby:WaitForChild("Start").CFrame + Vector3.new(0, 3, 0)
				EVENTS_FOLDER:WaitForChild("BackToObby"):FireClient(player, false)
				justCompletedObbys[player.UserId] = false
			end
		end
	end
end)


local referralCooldowns = {} -- [referrerUserId] = os.time() when last rewarded
local REFERRAL_COOLDOWN = 60 

local function GetReferral(player: Player)
	local joinData = player:GetJoinData()
	local referredByPlayerId = joinData.ReferredByPlayerId

	if referredByPlayerId then
		local referrerPlayer = PLAYERS:GetPlayerByUserId(referredByPlayerId)
		if referrerPlayer then
			local now = os.time()
			local lastReward = referralCooldowns[referredByPlayerId] or 0

			if now - lastReward < REFERRAL_COOLDOWN then
				warn(referrerPlayer.Name .. " is still on referral cooldown.")
				return
			end

			referralCooldowns[referredByPlayerId] = now
			print("Referral reward given to", referrerPlayer.Name)

			local leaderstats = referrerPlayer:WaitForChild("leaderstats")
			local Parts = leaderstats:FindFirstChild(SETTINGS_MODULE.PartsName)
			if Parts then
				if not RUN_SERVICE:IsStudio() then
				Parts.Value += SETTINGS_MODULE.InviteAmount
				end
				
				local data = {
					embeds = {{
						title = "Player Invited",
						color = 0xFFA500, -- green color (decimal or hex)
						fields = {
							{
								name = "Player",
								value = referrerPlayer.Name,
								inline = true
							},
							{
								name = "User ID",
								value = tostring(referrerPlayer.UserId),
								inline = true
							},
							{
								name = "Player Invited",
								value = player.Name,
								incline = true
							},
							{
								name = "Player Invited UserId",
								value = player.UserId,
								incline = true
							},
						},
						footer = {
							text = "Roblox Game Logs"
						},
						timestamp = DateTime.now():ToIsoDate()
					}}
				}
				HTTPS_SERVICE:PostAsync(inviteHook, HTTPS_SERVICE:JSONEncode(data))
				
				NOTIFICATION_MODULE.Notify("Invite", SETTINGS_MODULE.InviteAmount, referrerPlayer, 5)
				addToBlockQueue(SETTINGS_MODULE.InviteAmount)
			end
		end
	end
end



--//Display what buttons do
for _, button in pairs(BUTTONS_FOLDER:GetChildren()) do
	local DisplayParts = string.gsub(button.Name, "Button", "")
	
	local clone = BUTTON_STUDS_TEMPLATE:Clone()
	local cloneText = clone:WaitForChild("TextLabel")
	if tonumber(DisplayParts) < 1000 then
	cloneText.Text = "+"..FORMAT_MODULE.Finalize(tonumber(DisplayParts).." studs")
	clone.Parent = button
	elseif tonumber(DisplayParts) == 1000 then
		cloneText.Text = "+"..FORMAT_MODULE.Finalize(tonumber(DisplayParts).." studs | 120 ROBUX ONLY TODAY")
		clone.Parent = button
	elseif tonumber(DisplayParts) > 1000 then
		cloneText.Text = "+"..FORMAT_MODULE.Finalize(tonumber(DisplayParts).." studs")
		clone.Parent = button
	
	end
end


local TWEEN_SERVICE = game:GetService("TweenService")
local isFading = {}

for _, Part in pairs(workspace:GetDescendants()) do
	if not Part:IsA("Part") then continue end

	-- DAMAGE PARTS
	if Part.Name == "DamagePart" then
		Part.Touched:Connect(function(hit)
			local player = PLAYERS:FindFirstChild(hit.Parent.Name)
			local Humanoid = hit.Parent:FindFirstChild("Humanoid")
			if Humanoid then
				Humanoid:TakeDamage(10)
				if Humanoid.Health <= 0 then
					if player and player:IsA("Player") then
					GRAVITY_EVENT:FireClient(player, "Back")
					end
				end
			end
		end)
	elseif Part.Name == "SlightDamage" then
		Part.Touched:Connect(function(hit)
			local player = PLAYERS:FindFirstChild(hit.Parent.Name)
			local Humanoid = hit.Parent:FindFirstChild("Humanoid")
			if Humanoid then
				Humanoid:TakeDamage(5)
				end
			end)
	
	-- FADING PARTS
	elseif Part.Name == "Fading Part" then
		Part.Touched:Connect(function(hit)
			local Humanoid = hit.Parent:FindFirstChild("Humanoid")
			if Humanoid and not isFading[Part] then
				isFading[Part] = true

				local fadeTween = TWEEN_SERVICE:Create(Part, TweenInfo.new(2), {Transparency = 1})
				local fadeOutTween = TWEEN_SERVICE:Create(Part, TweenInfo.new(1), {Transparency = 0})

				fadeTween:Play()
				fadeTween.Completed:Once(function()
					Part.CanCollide = false
					task.wait(2)
					fadeOutTween:Play()
				end)

				fadeOutTween.Completed:Once(function()
					Part.CanCollide = true
					isFading[Part] = false
				end)
			end
		end)

	-- CONVEYORS
	elseif Part.Name == "Conveyor" then
		local beam = Part:FindFirstChild("Beam")
		local speed = Part:FindFirstChild("Speed")

		if beam and speed then
			Part.AssemblyLinearVelocity = Part.CFrame.LookVector * speed.Value

			Part.FrontSurface = Enum.SurfaceType.Studs
			beam.TextureSpeed = speed.Value / beam.TextureLength
		end
	elseif Part.Name == "FullKill" then
		Part.Touched:Connect(function(hit)
			if not hit.Parent:FindFirstChild("Humanoid") then return end
			local player = PLAYERS:FindFirstChild(hit.Parent.Name)
			if player and player:IsA("Player") then
				killPlayer(player)
			end
		end)
	end
end

local function detectAdminUse(admin, command, amount, target)
	local data = {
		embeds = {{
			title = "Admin Command",
			color = 0xED4245, -- red
			fields = {
				{
					name = "Player",
					value = admin.Name,
					inline = true
				},
				{
					name = "UserId"	,
					value = admin.UserId,
					inline = true
				},
				{
					name = "Command"	,
					value = command,
					inline = true
				},
				{
					name = "Amount"	,
					value = amount or "nil",
					inline = true
				},
				{
					name = "Target"	,
					value = target or "nil",
					inline = true
				},
			},
			footer = { text = "Roblox Game Logs" },
			timestamp = DateTime.now():ToIsoDate()
		}}
	}
	HTTPS_SERVICE:PostAsync(adminHook, HTTPS_SERVICE:JSONEncode(data))
end


local donationBoard = workspace:WaitForChild("Donations"):WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder"):WaitForChild("Options")
local donationTemlate = TEMPLATES_FOLDER:WaitForChild("DonationTemplate")


coroutine.wrap(function()

	for i, id in pairs(SETTINGS_MODULE.DonationIDS) do
		local productInfo = MARKET_PLACE_SERVICE:GetProductInfo(id, Enum.InfoType.Product)
		if productInfo then
			local price = productInfo.PriceInRobux
			if price then
				local template = donationTemlate:Clone()
				template:WaitForChild("Button").Text = FORMAT_MODULE.Finalize(price)
				template.LayoutOrder = i
				template.Parent = donationBoard
				template.Name = tostring(price)
				template:SetAttribute("ProductId", productInfo.ProductId)
				if i == 1  then
					local padding = Instance.new("UIPadding")
					padding.Parent = template
					padding.PaddingLeft = UDim.new(0, 5)
					elseif i == #SETTINGS_MODULE.DonationIDS then
					local padding = Instance.new("UIPadding")
					padding.Parent = template
					padding.PaddingRight = UDim.new(0, 5)
				end
			end
		end
	end

end)()

local isArea2Admin = {}
local function area2AdminChat(player:Player)
	
	for _, adminId in pairs(area2Admins) do
		if player.UserId == adminId then
			isArea2Admin[player.UserId] = true
			break
		end
	end
	
	player.Chatted:Connect(function(message)
		local args = string.split(message, " ")
		if args[1] == ".Area2" and PLAYERS:FindFirstChild(args[2]) and isArea2Admin[player.UserId]  then
			local target = PLAYERS:FindFirstChild(args[2])
			if target then
				local area2Value = target:WaitForChild("Values"):WaitForChild("UnlockedArea2")
				if area2Value ~= true then
					area2Value.Value = true
					NOTIFICATION_MODULE.PlayerNotification(target, "UnlockArea2", 5)
					NOTIFICATION_MODULE.PlayerNotification(player, "PlayerUnlocked" ,5, false, target.Name)
					EVENTS_FOLDER:WaitForChild("BuyArea2"):FireClient(target)
					detectAdminUse(player, "Area 2", nil, target.Name)

				end
			end
		end
	end)
end

local isAdmins = {}
local function adminChat(player: Player)
	
	for _, adminId in pairs(adminIDS) do
		if player.UserId == adminId then
			isAdmins[player.UserId] = true
			break
		end
	end
	
	player.Chatted:Connect(function(msg)
			if not (isAdmins[player.UserId] == true) then return end
			local args = string.split(msg, " ") -- break message into words
			if args[1] == ".Spawn" and args[2] then
				local amount = tonumber(args[2])
				if amount and amount <= 3000 then
				detectAdminUse(player, "Server Spawn", amount)
					NOTIFICATION_MODULE.Notify("Admin", amount, player, 10)
				skyTween(5, SETTINGS_MODULE.EventColors.SPAWN)

					addToBlockQueue(amount)
				end
			elseif args[1] == ".Destroy" and isAdmins[player.UserId] then
				NOTIFICATION_MODULE.Notify("Destroy", 0, player, 10)
			skyTween(8, Color3.fromRGB(190, 41, 36))
			detectAdminUse(player, "Server Destroy")
			
			isServerRemoving = true
			DestroyAllBlocks()

			isServerRemoving = false
			elseif args[1] ==".Global" and args[2] and isAdmins[player.UserId] then
				local amount = tonumber(args[2])
				if amount and amount <= 3001 then
				detectAdminUse(player, "GLOBAL Spawn", amount)
			  MESSAGING_SERVICE:PublishAsync("GlobalAdmin", {
					Studs = amount,
					Name = player.Name,
			  })
				end
			elseif args[1] == ".GlobalDestroy" and isAdmins[player.UserId] then
			detectAdminUse(player, "GLOBAL Destroy")
				MESSAGING_SERVICE:PublishAsync("AdminDestroy", {Name = player.Name})
				
			elseif args[1] == ".Ban" and PLAYERS:GetUserIdFromNameAsync(args[2]) and isAdmins[player.UserId] then
				for _, id in pairs(adminIDS) do
					if id == PLAYERS:GetUserIdFromNameAsync(args[2]) then
						return end
				end
				print("BANNING")
				local userId = PLAYERS:GetUserIdFromNameAsync(args[2])
				local suc, data = pcall(function()
					return BAN_DATA:GetAsync("Player_"..player.UserId)
				end)
				if suc then
					if data then return end
				end
				
				MESSAGING_SERVICE:PublishAsync("Ban", {
					UserId = userId,
					Name = args[2],
				})	
				
				
				NOTIFICATION_MODULE.PlayerNotification(player, "Ban", 6, false, args[2], userId)
				
				
			local data = {
				embeds = {{
					title = "Admin Command",
					color = 0xED4245, -- red
					fields = {
						{
							name = "Admin",
							value = player.Name,
							inline = true
						},
						{
							name = "Admin UserId"	,
							value = player.UserId,
							inline = true
						},
						{

							name = "Command",
							value = "Ban",
							inline = true

						},
						{
							name = "Banned Player",
							value = "@"..PLAYERS:GetNameFromUserIdAsync(userId).."(#"..userId..")",
							inline = true
						},
					},
					footer = { text = "Roblox Game Logs" },
					timestamp = DateTime.now():ToIsoDate()
				}}
			}
			HTTPS_SERVICE:PostAsync(adminHook, HTTPS_SERVICE:JSONEncode(data))
				
		elseif args[1] == ".Banland" and isAdmins[player.UserId] then
			local suc, data = pcall(function()
				return BAN_DATA:ListKeysAsync()
			end)

			if suc and data then
				local BanlandList = player:WaitForChild("PlayerGui"):WaitForChild("Banland"):WaitForChild("Holder"):WaitForChild("List")

				-- Clear old entries
				for _, item in pairs(BanlandList:GetChildren()) do
					if item:IsA("TextLabel") then
						item:Destroy()
					end
				end

				-- Loop through all pages
				while true do
					local page = data:GetCurrentPage()

					for _, v in pairs(page) do
						local success, value = pcall(function()
							return BAN_DATA:GetAsync(v.KeyName)
						end)

						if success and value == true then
							local id = string.gsub(v.KeyName, "Player_", "")
							local playerName = PLAYERS:GetNameFromUserIdAsync(tonumber(id))

							print("@"..playerName.." (#"..id..")")

							local template = TEMPLATES_FOLDER:WaitForChild("BanlandText"):Clone()
							template.Text = "@"..playerName.." (#"..id..")"
							template.Parent = BanlandList
						end
					end

					-- Move to next page or stop
					if data.IsFinished then
						NOTIFICATION_MODULE.PlayerNotification(player, "Banland", 4, false)
						break
					else
						data:AdvanceToNextPageAsync()
					end
				end

				print("SHOWING")
				EVENTS_FOLDER:WaitForChild("ShowBanland"):FireClient(player)
			else
				warn("Failed to list keys from BAN_DATA")
		end
		elseif args[1] == ".Unban" and isAdmins[player.UserId] and PLAYERS:GetUserIdFromNameAsync(args[2]) then
				local userId = PLAYERS:GetUserIdFromNameAsync(args[2])
				
				local suc, data = pcall(function() 
					return BAN_DATA:GetAsync("Player_"..userId)
				end)
				if data == true then
					local suc, error = pcall(function()
						BAN_DATA:SetAsync("Player_"..userId, false)
					end)
					if suc then
						print("Unbanned @"..PLAYERS:GetNameFromUserIdAsync(userId).."(#"..userId..")")
						NOTIFICATION_MODULE.PlayerNotification(player, "Unban", 6, false, PLAYERS:GetNameFromUserIdAsync(userId), userId, nil)
					local data = {
						embeds = {{
							title = "Admin Command",
							color = 0xED4245, -- red
							fields = {
								{
									name = "Admin",
									value = player.Name,
									inline = true
								},
								{
									name = "Admin UserId"	,
									value = player.UserId,
									inline = true
								},
								{
									
								name = "Command",
								value = "Unban",
								inline = true
									
								},
								{
									name = "Unbanned Player",
									value = "@"..PLAYERS:GetNameFromUserIdAsync(userId).."(#"..userId..")",
									inline = true
								},
							},
							footer = { text = "Roblox Game Logs" },
							timestamp = DateTime.now():ToIsoDate()
						}}
					}
					HTTPS_SERVICE:PostAsync(adminHook, HTTPS_SERVICE:JSONEncode(data))
					else
						print("Failed to unban user, are you sure they're banned?")
					end
				end
		elseif args[1] == ".AddParts" and PLAYERS:GetUserIdFromNameAsync(args[2]) and isAdmins[player.UserId] and args[3] then
			print("WORKING")

			local userId = PLAYERS:GetUserIdFromNameAsync(args[2])
			local name = PLAYERS:GetNameFromUserIdAsync(userId)
			local amount = tonumber(args[3])
			MESSAGING_SERVICE:PublishAsync("AddParts", {
				UserId = userId,
				Name = name,
				Amount = amount
			})
			
				NOTIFICATION_MODULE.PlayerNotification(player, "AddParts", 5, false, name, userId, amount)


				local data = {
					embeds = {{
						title = "Admin Command",
						color = 0xED4245,
						fields = {
							{
								name = "Admin",
								value = player.Name,
								inline = true
							},
							{
								name = "Admin UserId"	,
								value = player.UserId,
								inline = true
							},
							{

								name = "Command",
								value = "Add Parts",
								inline = true

							},
							{
								name = "Target",
								value = "@"..PLAYERS:GetNameFromUserIdAsync(userId).."(#"..userId..")",
								inline = true
							},
							{
								name = "Amount",
								value = tonumber(amount),
								inline = true

							},
						},
						footer = { text = "Roblox Game Logs" },
						timestamp = DateTime.now():ToIsoDate()
					}}
				}
				HTTPS_SERVICE:PostAsync(adminHook, HTTPS_SERVICE:JSONEncode(data))
		elseif args[1] == ".Commands" and isAdmins[player.UserId] then
			EVENTS_FOLDER:WaitForChild("ShowCommands"):FireClient(player)
			NOTIFICATION_MODULE.PlayerNotification(player, "Commands", 4, false)
		elseif args[1] == ".ResetParts" and isAdmins[player.UserId] and PLAYERS:GetUserIdFromNameAsync(args[2]) then
			local userId = PLAYERS:GetUserIdFromNameAsync(args[2])
			MESSAGING_SERVICE:PublishAsync("ResetParts", {
				Name = PLAYERS:GetNameFromUserIdAsync(userId),
				UserId = userId,
			})
			
			NOTIFICATION_MODULE.PlayerNotification(player, "ResetParts", 5, false, PLAYERS:GetNameFromUserIdAsync(userId), userId)
			
		elseif args[1] == ".SetMultiplier" and args[2] and isAdmins[player.UserId] then
			local amount = tonumber(args[2])
			if amount then
				SERVER_MULTIPLIER.Value = amount
				NOTIFICATION_MODULE.Notify("MultiplierChange", amount, nil, 5, nil)
			end
			
		elseif args[1] == ".GlobalMultiplier" and args[2] and isAdmins[player.UserId] then
			local amount = tonumber(args[2])
			if amount then
				MESSAGING_SERVICE:PublishAsync("GlobalMultiplier", {Amount = amount})
			--	NOTIFICATION_MODULE.PlayerNotification(player, "MultiplierAdmin", 5, nil,nil,nil, amount)
			end
		
		elseif args[1] == ".ClearQueue" and isAdmins[player.UserId] then
			serverBlockQueueValue.Value = 0
		NOTIFICATION_MODULE.PlayerNotification(player,"ClearQueue", 5)
		elseif args[1] == ".ResetObbies" and isAdmins[player.UserId] and args[2] then
			
			local userId = PLAYERS:GetUserIdFromNameAsync(args[2])
			MESSAGING_SERVICE:PublishAsync("ResetObbies", {
				Name = PLAYERS:GetNameFromUserIdAsync(userId),
				UserId = userId,
			})

			NOTIFICATION_MODULE.PlayerNotification(player, "ResetObbies", 5, false, PLAYERS:GetNameFromUserIdAsync(userId), userId)
		
		end
	end)
end



TELEPORT_TO_SPAWN_EVENT.OnServerEvent:Connect(function(player)
	killPlayer(player)
end)


local function sendStudShopHook(player:Player, Name)
	
	local data = {
		embeds = {{
			title = "Stud Shop Purchase",
			color = 0xFF0000, -- green color (decimal or hex)
			fields = {
				{
					name = "Player",
					value = player.Name.."(#"..player.UserId..")",
					incline = true
				},
				{
					name = "Purchase",
					value = Name,
					inline = true
				},
			},
			footer = {
				text = "Roblox Game Logs"
			},
			timestamp = DateTime.now():ToIsoDate()
		}}
	}
	HTTPS_SERVICE:PostAsync(studShopHook, HTTPS_SERVICE:JSONEncode(data))
	
end


EVENTS_FOLDER:WaitForChild("Buy").OnServerEvent:Connect(function(player, Name)
	local Price = tonumber(SETTINGS_MODULE.ShopPrices[Name])

	local leaderstats = player:WaitForChild("leaderstats")
	local parts = leaderstats:FindFirstChild(SETTINGS_MODULE.PartsName)
	local ownedSpeed = player.Backpack:FindFirstChild("SpeedCoil")
	local ownedSlap = player.Backpack:FindFirstChild("Slap Hand")
	
	if not parts and not Price and Name then return end
	if ownedSpeed and Name == "TempSpeed" then return end
	if ownedSlap and Name == "TempSlap" then return end
	
		if parts.Value >= Price then
			parts.Value -= Price
		else NOTIFICATION_MODULE.PlayerNotification(player, "CantAfford", 4) return end
		
			if Name == "KillAll" then
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("Death"))

		skyTween(8, SETTINGS_MODULE.EventColors.Kill)

				for _, Player in pairs(PLAYERS:GetChildren()) do
					if checkIfImmunity(Player) then useImmunity(Player) continue end
					killPlayer(Player)
				end
				NOTIFICATION_MODULE.Notify("KillAll", 0, player, 5)
			sendStudShopHook(player, "Kill All")
			
			elseif Name == "DestroyBlocks" then
				NOTIFICATION_MODULE.Notify("DestroyAll", 0, player, 15)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("Alarm"))

			sendStudShopHook(player, "Destroy Blocks")
			
		skyTween(10, SETTINGS_MODULE.EventColors.Destroy)

			isServerRemoving = true
		DestroyAllBlocks()

		isServerRemoving = false
		
			elseif Name == "Spawn100" then
			sendStudShopHook(player, "Spawn 100 Studs")

			NOTIFICATION_MODULE.Notify("Spawn", 100, player, 5)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("money"))
		skyTween(5, SETTINGS_MODULE.EventColors.SPAWN)

		player:WaitForChild("Values"):WaitForChild("TotalStudsContributed").Value += 100

				addToBlockQueue(100)
				
			elseif Name == "TeleportAll" then
				sendStudShopHook(player, "Teleport All")
				NOTIFICATION_MODULE.Notify("TeleportAll", 0, player, 5)
				
		for _, target in pairs(PLAYERS:GetPlayers()) do
			if checkIfImmunity(target) then useImmunity(target) continue end

			coroutine.wrap(function()
				if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					local root = target.Character.HumanoidRootPart
					local targetRoot = player.Character.HumanoidRootPart
					root.CFrame = targetRoot.CFrame + Vector3.new(0, 25, 0)
				end
			end)()
		end

	
			elseif Name == "Spawn250" then
		sendStudShopHook(player, "Spawn 250 Studs")

		NOTIFICATION_MODULE.Notify("Spawn", 250, player, 10)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("money"))
		skyTween(5, SETTINGS_MODULE.EventColors.SPAWN)
		player:WaitForChild("Values"):WaitForChild("TotalStudsContributed").Value += 250


		addToBlockQueue(250)			
				
			elseif Name == "Banana" then
				sendStudShopHook(player, "Banana")
				NOTIFICATION_MODULE.Notify("Banana", 0, player, 10)
				
				for _, target in pairs(PLAYERS:GetChildren()) do
			if checkIfImmunity(target) then useImmunity(target) continue end

				turnIntoBanana(target)
				end
			
		elseif Name == "GlobalManiac" then
			print("PUBLISHING")
			MESSAGING_SERVICE:PublishAsync("Global100Studs", {
				Name = player.Name
			})
		player:WaitForChild("Values"):WaitForChild("TotalStudsContributed").Value += 100

			sendStudShopHook(player, "Spawn 100 Studs Global")

		elseif Name == "FireAll" then
			NOTIFICATION_MODULE.Notify("FireAll", 0, player, 5)
			for _, target in pairs(PLAYERS:GetChildren()) do
				if checkIfImmunity(target) then useImmunity(target) continue end
				
				doFireEvent(target)
			end
		sendStudShopHook(player, "Fire All")

		
		elseif Name == "GlobalRemove" then
			print("PUBLISHING REMOVE")
			MESSAGING_SERVICE:PublishAsync("GlobalDestroy", {Name = player.Name})
			sendStudShopHook(player, "Destroy All Studs")
		elseif Name == "GlobalKill" then
			MESSAGING_SERVICE:PublishAsync("GlobalKill", {Name = player.Name})
		sendStudShopHook(player, "Global Kill")
		elseif Name == "Compliment" then
		NOTIFICATION_MODULE.PlayerNotification(player, "Compliment", 8)
		--sendStudShopHook(player, "Compliment")
		elseif Name == "TempSpeed" then
			local SpeedClone1 = SERVER_STORAGE:WaitForChild("SpeedCoil"):Clone()
			local SpeedClone2 = SERVER_STORAGE:WaitForChild("SpeedCoil"):Clone()
			SpeedClone1.Parent = player.Backpack
			SpeedClone2.Parent = player.StarterGear
			NOTIFICATION_MODULE.PlayerNotification(player, "Received", 5)
		sendStudShopHook(player, "Temporary Speed")
		
		elseif Name == "TempSlap" then
			local SlapClone1 = SERVER_STORAGE:WaitForChild("Slap Hand"):Clone()
			local SlapClone2 = SERVER_STORAGE:WaitForChild("Slap Hand"):Clone()
			SlapClone1.Parent = player.Backpack
			SlapClone2.Parent = player.StarterGear
			NOTIFICATION_MODULE.PlayerNotification(player, "Received", 5)
			sendStudShopHook(player, "Temporary Slap")
			
		elseif Name == "Immunity" then
		local immunity = player:WaitForChild("Values"):WaitForChild("Immunities")
			immunity.Value += 1
			NOTIFICATION_MODULE.PlayerNotification(player,"Immunity", 5, false, false, false, immunity.Value)
		sendStudShopHook(player, "Immunity")

		
	end
end)






--[[local partsOn = {}
local bottomPart = workspace:WaitForChild("Ramp"):WaitForChild("BottomPart")

bottomPart.Touched:Connect(function(hit)
	if hit:IsA("Part") and hit.Size == Vector3.new(SETTINGS_MODULE.BlockSize, SETTINGS_MODULE.BlockSize, SETTINGS_MODULE.BlockSize) then
		   if not partsOn[hit] then
			   partsOn[hit] = true

			   task.delay(10, function()
				   if partsOn[hit] and hit.Parent then
					hit:Destroy()
					partsOn[hit] = nil
				end
			end)
		end
	end
end)

bottomPart.TouchEnded:Connect(function(hit)
	if hit:IsA("Part") and hit.Size == Vector3.new(SETTINGS_MODULE.BlockSize, SETTINGS_MODULE.BlockSize, SETTINGS_MODULE.BlockSize) then
		partsOn[hit] = nil
	end
end)--]]

local function StudChanged(player:Player)
	local leaderstats = player:WaitForChild("leaderstats")
	local parts = leaderstats:WaitForChild(SETTINGS_MODULE.PartsName)
	EVENTS_FOLDER:WaitForChild("updateStuds"):FireClient(player, parts.Value)
	parts.Changed:Connect(function()
		EVENTS_FOLDER:WaitForChild("updateStuds"):FireClient(player, parts.Value)
	end)
end

local area2hook = "https://discord.com/api/webhooks/1435060495626539041/v0_ondCI6YVWtumyHU04YPC8D1aMa9-3nk1BUGNE2jYNAMjUsXjMTYrBCuq-S_RGuWgE"
EVENTS_FOLDER:WaitForChild("BuyArea2").OnServerEvent:Connect(function(player)
	if player:WaitForChild("Values"):WaitForChild("UnlockedArea2").Value == true then return end
	
	if player:WaitForChild("leaderstats"):WaitForChild(SETTINGS_MODULE.PartsName).Value >= SETTINGS_MODULE.Area2Price then
		player:WaitForChild("leaderstats"):WaitForChild(SETTINGS_MODULE.PartsName).Value -= SETTINGS_MODULE.Area2Price
		player:WaitForChild("Values"):WaitForChild("UnlockedArea2").Value = true
		
		local data = {
			embeds = {{
				title = "Area 2 Purchase!",
				color = 0x57F287, -- green color (decimal or hex)
				fields = {
					{
						name = "Player",
						value = player.Name,
						inline = true
					},
					{
						name = "User ID",
						value = tostring(player.UserId),
						inline = true
					},
				},
				footer = {
					text = "Roblox Game Logs"
				},
				timestamp = DateTime.now():ToIsoDate()
			}}
		}

		HTTPS_SERVICE:PostAsync(area2hook, HTTPS_SERVICE:JSONEncode(data))
		
		EVENTS_FOLDER:WaitForChild("BuyArea2"):FireClient(player)
		NOTIFICATION_MODULE.PlayerNotification(player, "UnlockArea2", 6)
	end
end)

local joinTimes = {}
local function sendJoinWebhook(player: Player)
	if player.Name == "Holdifyy" or player.Name == "HoldGamesHolder" then return end
	local timesPlayed = player:WaitForChild("Values"):WaitForChild("TimesPlayed")
	
	joinTimes[player.UserId] = os.time()
	repeat wait() until timesPlayed.Value >= 1

	local data = {
		embeds = {{
			title = "Player Joined!",
			color = 0x57F287, -- green color (decimal or hex)
			fields = {
				{
					name = "Player",
					value = player.Name,
					inline = true
				},
				{
					name = "User ID",
					value = tostring(player.UserId),
					inline = true
				},
				{
					name = "Times Joined",
					value = timesPlayed.Value,
					incline = true
				},
			},
			footer = {
				text = "Roblox Game Logs"
			},
			timestamp = DateTime.now():ToIsoDate()
		}}
	}

	HTTPS_SERVICE:PostAsync(Joinwebhook, HTTPS_SERVICE:JSONEncode(data))
end

local function sendLeaveWebhook(player: Player)
	local obbiesCompleted = player:WaitForChild("Values"):WaitForChild("ObbiesCompleted")
	local timesPlayed = player:WaitForChild("Values"):WaitForChild("TimesPlayed")
	local totalTimePlayed = player:WaitForChild("Values"):WaitForChild("TotalTimePlayed")
	
	local joinTime = joinTimes[player.UserId] or os.time()
	local sessionLength = os.time() - joinTime

	-- Format session length (H:M:S)
	local hours = math.floor(sessionLength / 3600)
	local mins = math.floor((sessionLength % 3600) / 60)
	local secs = sessionLength % 60
	local formattedTime = string.format("%02dh %02dm %02ds", hours, mins, secs)
	
	local totalHours = math.floor(totalTimePlayed.Value / 3600)
	local totalMins = math.floor((totalTimePlayed.Value % 3600) / 60)
	local totalSecs = totalTimePlayed.Value % 60
	local formattedTotalTime = string.format("%02dh %02dm %02ds", totalHours, totalMins, totalSecs)

	if player.Name == "Holdifyy" or player.Name == "HoldGamesHolder" then return end

	local data = {
		embeds = {{
			title = "Player Left",
			color = 0xED4245, -- red
			fields = {
				{
					name = "Player",
					value = player.Name,
					inline = true
				},
				{
					name = "User ID",
					value = tostring(player.UserId),
					inline = true
				},
				{
					name = "Obbies Completed",
					value = obbiesCompleted.Value,
					inline = true
				},
				{
					name = "Times Joined",
					value = timesPlayed.Value,
					incline = true
					
				},
				{
					name = "Session Length",
					value = formattedTime,
					inline = false
				},
				{
					name = "Time Played",
					value = formattedTotalTime,
					inline = false
				},
			},
			footer = { text = "Roblox Game Logs" },
			timestamp = DateTime.now():ToIsoDate()
		}}
	}

	HTTPS_SERVICE:PostAsync(Leavehook, HTTPS_SERVICE:JSONEncode(data))
end

local function detectSocialChat(player:Player)
	local FromSocial = player:WaitForChild("Values"):WaitForChild("FromSocial")
	local PartsValue = player:WaitForChild("leaderstats"):WaitForChild(SETTINGS_MODULE.PartsName)
	player.Chatted:Connect(function(msg)
		if msg == "Social" and FromSocial.Value ~= true then
			FromSocial.Value = true
			
			local data = {
				embeds = {{
					title = "Social Media",
					color = 0xED4245, -- red
					fields = {
						{
							name = "Player",
							value = player.Name,
							inline = true
						},
						{
						name = "UserId"	,
						value = player.UserId,
						inline = true
						},
					},
					footer = { text = "Roblox Game Logs" },
					timestamp = DateTime.now():ToIsoDate()
				}}
			}
			HTTPS_SERVICE:PostAsync(socialHook, HTTPS_SERVICE:JSONEncode(data))
			
			NOTIFICATION_MODULE.Notify("Social", 50, player, 5)
			PartsValue.Value += 50
			addToBlockQueue(50)
			
		end
	end)
end


local UniverseId = game.GameId
local LikesPerStep = 5 -- every 5 likes = full bar

local Board:Part = game.Workspace:WaitForChild("LikeGoal"):WaitForChild("List")
local LikesText = Board:WaitForChild("List"):WaitForChild("Holder"):WaitForChild("Likes")
local likesBar = LikesText.Parent:WaitForChild("Bar"):WaitForChild("Fill")

-- store previous full cycles to detect when a new cycle is reached
local previousFullCycles = 0
local initialized = false

local function GetLikes()
	local Success, Result, data

	repeat
		Success, Result = pcall(HTTPS_SERVICE.RequestAsync, HTTPS_SERVICE, {
			Url = string.format("https://games.roproxy.com/v1/games/%d/votes", UniverseId),
			Method = "GET"
		})

		if Success and Result.StatusCode >= 200 and Result.StatusCode < 300 then
			data = HTTPS_SERVICE:JSONDecode(Result.Body)
			break -- success, exit loop
		else
			-- warn("Failed to fetch likes, retrying...")
			task.wait(0.1) -- tiny delay to prevent tight loop
		end
	until false

	local UpVotes = data.upVotes or 0

	-- current full cycles
	local fullCycles = math.floor(UpVotes / LikesPerStep)
	local currentProgress = UpVotes % LikesPerStep

	-- update text
	LikesText.Text = string.format("%d/%d", currentProgress, LikesPerStep)

	-- progress bar
	local Percentage = currentProgress / LikesPerStep
	local TargetSize = UDim2.fromScale(Percentage, 1)

	local Info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local Tween = TWEEN_SERVICE:Create(likesBar, Info, {Size = TargetSize})
	Tween:Play()

	-- reward check
	if fullCycles > previousFullCycles then
		if initialized then
			previousFullCycles = fullCycles

			-- REWARD LOGIC HERE
			addToBlockQueue(100)
			givePartsToAllPlayers(100)
			NOTIFICATION_MODULE.Notify("LikeGoal", nil, nil, 10, nil)

			local WebData = {
				embeds = {{
					title = "Like Goal Reached",
					color = 0xED4245, -- red
					fields = {
						{
							name = "Likes",
							value = tostring(UpVotes),
							inline = true
						},
						{
							name = "Players Rewarded In Server",
							value = #PLAYERS:GetChildren(),
							inline = true
						},
					},
					footer = { text = "Roblox Game Logs" },
					timestamp = DateTime.now():ToIsoDate()
				}}
			}

			HTTPS_SERVICE:PostAsync(likeHook, HTTPS_SERVICE:JSONEncode(WebData))
		else
			-- first run: sync but don’t reward
			previousFullCycles = fullCycles
			initialized = true
		end
	end
end

EVENTS_FOLDER:WaitForChild("GetServerMultiplier").OnServerInvoke = function(player)
	return SERVER_MULTIPLIER.Value
end

-- repeated calls
coroutine.wrap(function()
	while true do
		GetLikes()
		task.wait(20)
	end
end)()

local function check2xOwned(player:Player)
	local values = player:WaitForChild("Values")
	local owns2x = values:WaitForChild("OwnsDoubleParts").Value
	
	if owns2x then return
	end
	
	local ownsPass = MARKET_PLACE_SERVICE:UserOwnsGamePassAsync(player.UserId, SETTINGS_MODULE.DoubleStudID)
	if ownsPass then
		values:WaitForChild("OwnsDoubleParts").Value = true
	end
end

local MultiHolder = workspace:WaitForChild("ServerMultiplier"):WaitForChild("List"):WaitForChild("List"):WaitForChild("Holder")
local MultiText = MultiHolder:WaitForChild("Multiplier")
local formattedMultiplier


SERVER_MULTIPLIER.Changed:Connect(function()
	EVENTS_FOLDER:WaitForChild("UpdateServerMultiplier"):FireAllClients(SERVER_MULTIPLIER.Value)
	
	-- Check if it's a whole number
	if SERVER_MULTIPLIER.Value % 1 == 0 then
		formattedMultiplier = string.format("%.1f", SERVER_MULTIPLIER.Value) -- 1 decimal
	else
		formattedMultiplier = string.format("%.2f", SERVER_MULTIPLIER.Value) -- 2 decimals
	end

	MultiText.Text = formattedMultiplier .. "x"
end)



if SERVER_MULTIPLIER.Value % 1 == 0 then
	formattedMultiplier = string.format("%.1f", SERVER_MULTIPLIER.Value) -- 1 decimal
else
	formattedMultiplier = string.format("%.2f", SERVER_MULTIPLIER.Value) -- 2 decimals
end

MultiText.Text = formattedMultiplier .. "x"


EVENTS_FOLDER:WaitForChild("CheckIfFirstDay").OnServerInvoke = function(player)
	return player:WaitForChild("Values"):WaitForChild("TimesPlayed").Value
end

local function setupNameTags(player:Players)
	local char = player.Character or player.CharacterAdded:Wait()
	
	local nametagTemplate = TEMPLATES_FOLDER:WaitForChild("NameTag")
	local subroleTemplate = TEMPLATES_FOLDER:WaitForChild("SubRole")
	
	local clone = nametagTemplate:Clone()
	local text = clone:WaitForChild("Text")
	text.Text = player.Name
	clone.Parent = char:WaitForChild("Head")
	
	
	if table.find(adminIDS, player.UserId) then
		local clone2 = subroleTemplate:Clone()
		clone2:WaitForChild("Text").Text = "Owner"
		clone2:FindFirstChild("Text").TextColor3 = Color3.fromRGB(26, 255, 129)
		clone2.Parent = char:WaitForChild("Head")
		return
	end
	
	if table.find(builderIDS, player.UserId) then
		local clone2 = subroleTemplate:Clone()
		clone2:WaitForChild("Text").Text = "Builder"
		clone2:FindFirstChild("Text").TextColor3 = Color3.fromRGB(213, 255, 24)
		clone2.Parent = char:WaitForChild("Head")
		return
	end
	
	if player:IsInGroup(GROUP_ID) then
    if player:GetRoleInGroup(GROUP_ID) == "Beta Tester" then
        local clone2 = subroleTemplate:Clone()
        clone2.Parent = char:WaitForChild("Head")
        clone2:WaitForChild("Text").Text = "Beta Tester"
        clone2:WaitForChild("Text").TextColor3 = Color3.fromRGB(119, 255, 198)
        return
    end
end
	
	if player:IsInGroup(GROUP_ID) then
		if player:GetRoleInGroup(GROUP_ID) == "Member" then
			local clone2 = subroleTemplate:Clone()
			clone2.Parent = char:WaitForChild("Head")
			clone2:WaitForChild("Text").Text = "Member"
			clone2:WaitForChild("Text").TextColor3 = Color3.fromRGB(78, 155, 255)
			return
		end
	end

		clone.StudsOffset = Vector3.new(0,1.95)

	end



local multiplierTimeText = workspace:WaitForChild("ServerMultiplier"):WaitForChild("Time"):WaitForChild("Time"):WaitForChild("TextLabel")

coroutine.wrap(function()
	local isLooping = false
	while true do
		if isLooping then return end
		isLooping = true

		local totalTime = SETTINGS_MODULE.ResetMultiplierTime

		while totalTime > 0 do
			local minutes = math.floor(totalTime / 60)
			local seconds = totalTime % 60
			multiplierTimeText.Text = string.format("Resets in %02d:%02d", minutes, seconds)

			task.wait(1)
			totalTime -= 1
		end

		isLooping = false
		SERVER_MULTIPLIER.Value = 1
		NOTIFICATION_MODULE.Notify("MultiplierReset", 0, 0, 8)
	end
end)()


local function sendAntiCheatHook(player:Player, type)
	local data = {
		embeds = {{
			title = "Player Banned",
			color = 0x57F287, -- green color (decimal or hex)
			fields = {
				{
					name = "Player",
					value = player.Name,
					inline = true
				},
				{
					name = "User ID",
					value = tostring(player.UserId),
					inline = true
				},
				{
					name = "Type",
					value = type,
					incline = true
				},
			},
			footer = {
				text = "Roblox Game Logs"
			},
			timestamp = DateTime.now():ToIsoDate()
		}}
	}

	HTTPS_SERVICE:PostAsync(antiCheatHook, HTTPS_SERVICE:JSONEncode(data))
end


local function updateStatistics(player:Player)
	local values = player:WaitForChild("Values")
	local totalStudsContributed = values:WaitForChild("TotalStudsContributed")
	local obbiesCompleted = values:WaitForChild("ObbiesCompleted")
	local playerMultiplier = values:WaitForChild("PlayerMultiplier")
	local timePlayed = values:WaitForChild("TotalTimePlayed")
	
	EVENTS_FOLDER:WaitForChild("UpdateStatistics"):FireClient(player, timePlayed.Value, obbiesCompleted.Value, totalStudsContributed.Value, playerMultiplier.Value)
	
	
	totalStudsContributed.Changed:Connect(function()
		EVENTS_FOLDER:WaitForChild("UpdateStatistics"):FireClient(player, timePlayed.Value, obbiesCompleted.Value, totalStudsContributed.Value, playerMultiplier.Value)
	end)
	
	obbiesCompleted.Changed:Connect(function()
		EVENTS_FOLDER:WaitForChild("UpdateStatistics"):FireClient(player, timePlayed.Value, obbiesCompleted.Value, totalStudsContributed.Value, playerMultiplier.Value)
	end)
	
	timePlayed.Changed:Connect(function()
		EVENTS_FOLDER:WaitForChild("UpdateStatistics"):FireClient(player, timePlayed.Value, obbiesCompleted.Value, totalStudsContributed.Value, playerMultiplier.Value)
	end)
	
	playerMultiplier.Changed:Connect(function()
		EVENTS_FOLDER:WaitForChild("UpdateStatistics"):FireClient(player, timePlayed.Value, obbiesCompleted.Value, totalStudsContributed.Value, playerMultiplier.Value)
	end)
end
-------------------------------------------------------------------------------------------------------
local function OnPlayerAdded(player:Player) --runs when player joins the game.
	
local suc, data = pcall(function()
	return BAN_DATA:GetAsync("Player_"..player.UserId)
end)
if suc and data then
	if data == true then
		player:Kick("You are banned.")
	end
	return
end

	--print("ADDING")
	SetupData(player)
	setupNameTags(player)

	
	
	if player:WaitForChild("Values"):WaitForChild("UnlockedArea2").Value == true then
		EVENTS_FOLDER:WaitForChild("BuyArea2"):FireClient(player)
	end
	
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.DisplayDistanceType = "None"
	
	
	playerJoinTimes[player.UserId] = tick()
	coroutine.wrap(function()
		wait(1)
		playTimes[player.UserId] = (tick() - playerJoinTimes[player.UserId])
	end)
	
	coroutine.wrap(function()
		local values = player:WaitForChild("Values")
		local totalTime = values:WaitForChild("TotalTimePlayed")

		while player and player.Parent do
			task.wait(1)
			if not player or not player.Parent then break end
			totalTime.Value += 1
		end
	end)()


--setup server reward text
task.spawn(function()
if currentGoalIndex > #SETTINGS_MODULE.serverRewards then
	EVENTS_FOLDER:WaitForChild("UpdateCompletionPercent"):FireClient(player, SETTINGS_MODULE.serverRewards[#SETTINGS_MODULE.serverRewards].Goal)
		EVENTS_FOLDER:WaitForChild("UpdateServerReward"):FireAllClients(
			"Max Goal Reached",
			"Destroy Studs to Reset"
		)
		
else
		EVENTS_FOLDER:WaitForChild("UpdateCompletionPercent"):FireClient(player, SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal)
		EVENTS_FOLDER:WaitForChild("UpdateServerReward"):FireClient(player, SETTINGS_MODULE.serverRewards[currentGoalIndex].Goal, SETTINGS_MODULE.serverRewards[currentGoalIndex].Reward)
end
end)

	playersSaving[player.UserId] = true
	coroutine.wrap(function()
		while playersSaving[player.UserId] == true do
			task.wait(SETTINGS_MODULE.TimeBetweenSaves)
			SaveData(player)
		end
	end)()
	coroutine.wrap(function()
		detectSocialChat(player)
	end)()
	
	local values = player:WaitForChild("Values")
	local timesPlayed = values:WaitForChild("TimesPlayed")
	timesPlayed.Value += 1
	
	task.spawn(function()
	   local suc, err = pcall(function()
	sendJoinWebhook(player)
	end)
	end)
	updateStatistics(player)
	check2xOwned(player)
	setupTotalBlocks(player)
	setupGamepassTools(player)
	GetReferral(player)
	adminChat(player)
	area2AdminChat(player)
	StudChanged(player)
	coroutine.wrap(function()
	DoRewardQueue(player)
	end)()
	
	coroutine.wrap(function()
		wait(4)
		if not player:FindFirstChild("leaderstats") then
			player:Kick("Failed to load data, please rejoin!")
		end
	end)()
	
	
	local obbiesLastMinute = values:WaitForChild("ObbiesLastMinute")
	task.spawn(function()
		while player and player.Parent do
			task.wait(60)
			obbiesLastMinute.Value = 0
		end
	end)

	obbiesLastMinute.Changed:Connect(function(newValue)
		if newValue >= 10 then
			coroutine.wrap(function()
				-- Small delay to ensure it’s not a temporary spike (optional)
				task.wait(0.1)
				if obbiesLastMinute.Value >= 10  and not player.StarterGear:FindFirstChild("FlyingCarpet") then
					
					if table.find(adminIDS, player.UserId) then return end

					local suc, errorMsg = pcall(function()
						BAN_DATA:SetAsync("Player_"..player.UserId, true)
					end)

					if not suc then
						warn("Failed to ban player: " .. errorMsg)
					else
						task.spawn(function()
						sendAntiCheatHook(player, tostring(obbiesLastMinute.Value).." Obbies Completed Per Minute")
						end)
						player:Kick("You have been detected by the anti-cheat. If you believe this to be false, contact the owner.")
					end
				end
			end)()
		end
	end)
	
EVENTS_FOLDER:WaitForChild("UpdateServerMultiplier"):FireClient(player, SERVER_MULTIPLIER.Value)


	humanoid.Died:Connect(function()
		if player:GetAttribute("HasBanana") then turnIntoBanana(player) end

		if justCompletedObbys[player.UserId] or isInObby[player.UserId] then
			EVENTS_FOLDER:WaitForChild("BackToObby"):FireClient(player, true)
		end
		wait(2)
		if timeInObby[player.UserId] and timeInObby[player.UserId] > 2 then
			isInObby[player.UserId] = false
		end
end)

--print("SETUP PLAYER SUCCESSFULLY")


	player.CharacterAdded:Connect(function(character)
		giveBackTools(character)
		
		task.spawn(function()
		setupNameTags(player)
		end)
		
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.DisplayDistanceType = "None"
		
		humanoid.Died:Connect(function()
			if player:GetAttribute("HasBanana") then turnIntoBanana(player) end

			if justCompletedObbys[player.UserId] or isInObby[player.UserId] then
			EVENTS_FOLDER:WaitForChild("BackToObby"):FireClient(player, true)
			end
			wait(2)
			if timeInObby[player.UserId] and timeInObby[player.UserId] > 2 then
			isInObby[player.UserId] = false
			end
		end)
	end)
end
local function OnPlayerRemoving(player) -- runs when player leaves the game.
	local Time = os.time()
	local totalTimePlayed = player:WaitForChild("Values"):WaitForChild("TotalTimePlayed")
	local lastPlayed = player:WaitForChild("Values"):WaitForChild("LastPlayed")

	lastPlayed.Value = Time

	--[[if not RUN_SERVICE:IsStudio() then
		if joinTimes[player.UserId] then
			totalTimePlayed.Value += (Time - joinTimes[player.UserId])
		end
	end--]]

	SaveData(player)
	playTimes[player.UserId] = nil
	playerJoinTimes[player.UserId] = nil
	activeRewardLoops[player.UserId] = nil
	playersSaving[player.UserId] = nil
	PlayerObbyDebounces[player.UserId] = nil
	isArea2Admin[player.UserId] = nil

	if isAdmins[player.UserId] then
		isAdmins[player.UserId] = nil -- safer than table.remove for dictionary-style tables
	end
 local suc, err = pcall(function()
	sendLeaveWebhook(player)
	end)
end


PLAYERS.PlayerAdded:Connect(OnPlayerAdded)
PLAYERS.PlayerRemoving:Connect(OnPlayerRemoving)

--// Secondary startup failsafe
--[[local triedPlayers = {}

task.spawn(function()
	while true do
		task.wait(2)

		for _, player in ipairs(PLAYERS:GetPlayers()) do
			local retries = triedPlayers[player.UserId] or 0
			local playTime = playTimes[player.UserId] or 0 -- make sure it's safe

			if not player:FindFirstChild("leaderstats") and retries < 3 then
				if playTime > 3 then
					triedPlayers[player.UserId] = retries + 1
					print("Retrying leaderstats for", player.Name)

					task.spawn(function()
						if not player:FindFirstChild("leaderstats") then
							OnPlayerAdded(player)
						end
					end)
				end
			end
		end
	end
end)--]]




game:BindToClose(function()
	print("CLOSING")
	for _, player in pairs(PLAYERS:GetChildren()) do
		OnPlayerRemoving(player)
	end
end)

--//Subscriptions
if not RUN_SERVICE:IsStudio() then
	-- Global100Studs
	MESSAGING_SERVICE:SubscribeAsync("Global100Studs", function(message)
		local playerName = message.Data.Name
		print(playerName)
		NOTIFICATION_MODULE.Notify("GlobalStuds", 100, nil, 15, playerName)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("money"))
		skyTween(5, SETTINGS_MODULE.EventColors.SPAWN)
		addToBlockQueue(100)
	end)

	-- GlobalAdmin
	MESSAGING_SERVICE:SubscribeAsync("GlobalAdmin", function(message)
		local blockAmount = message.Data.Studs
		local adminName = message.Data.Name
		if blockAmount >= 3001 then return end
		NOTIFICATION_MODULE.Notify("GlobalAdmin", blockAmount, nil, 15, adminName)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("money"))
		skyTween(5, SETTINGS_MODULE.EventColors.SPAWN)
		addToBlockQueue(blockAmount)
	end)
	
	--Set Multiplier
	MESSAGING_SERVICE:SubscribeAsync("GlobalMultiplier", function(message)
		local amount = message.Data.Amount
		SERVER_MULTIPLIER.Value = amount
		
		pcall(function()
			NOTIFICATION_MODULE.Notify("MultiplierChange", amount, nil, 5, nil)
		end)
	end)
	

	-- AdminDestroy
	MESSAGING_SERVICE:SubscribeAsync("AdminDestroy", function(message)
		local Name = message.Data.Name
		NOTIFICATION_MODULE.Notify("DestroyAdmin", nil, nil, 20, Name)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("Alarm"))
		skyTween(12, SETTINGS_MODULE.EventColors.Destroy)

		isGlobalRemoving = true
		DestroyAllBlocks()
		isGlobalRemoving = false
	end)

	-- GlobalDestroy
	MESSAGING_SERVICE:SubscribeAsync("GlobalDestroy", function(message)
		local name = message.Data.Name
		NOTIFICATION_MODULE.Notify("GlobalDestroy", nil, nil, 60, name)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("Alarm"))
		skyTween(12, SETTINGS_MODULE.EventColors.Destroy)

		isGlobalRemoving = true

		DestroyAllBlocks()

		-- ? Move this outside the loop
		isGlobalRemoving = false
	end)

	-- GlobalKill
	MESSAGING_SERVICE:SubscribeAsync("GlobalKill", function(message)
		local name = message.Data.Name
		NOTIFICATION_MODULE.Notify("GlobalKill", nil, nil, 10, name)
		SOUND_EVENT:FireAllClients(SOUNDS_FOLDER:WaitForChild("Death"))
		skyTween(12, SETTINGS_MODULE.EventColors.Kill)

		for _, player in pairs(PLAYERS:GetChildren()) do
			if checkIfImmunity(player) then useImmunity(player) continue end

			coroutine.wrap(function()
				killPlayer(player)
			end)()
		end
	end)

	-- Ban
	MESSAGING_SERVICE:SubscribeAsync("Ban", function(message)
		local playerName = message.Data.Name
		local userId = message.Data.UserId
		local player = PLAYERS:FindFirstChild(playerName)

		if player then
			player:Kick("You have been banned.")
			print("Found player in-game and banned "..playerName)
		end

		local suc, errorMsg = pcall(function()
			BAN_DATA:SetAsync("Player_"..userId, true)
		end)

		if not suc then
			warn("Failed to ban player: " .. errorMsg)
		else
			print("Banned "..playerName.."!")
		end
	end)

	-- AddParts
	MESSAGING_SERVICE:SubscribeAsync("AddParts", function(message)
		local Amount = message.Data.Amount
		local UserId = message.Data.UserId
		local Name = message.Data.Name

		-- If player is online
		local target = PLAYERS:FindFirstChild(Name)
		if target then
			local Parts = target:WaitForChild("leaderstats"):WaitForChild(SETTINGS_MODULE.PartsName)
			Parts.Value += Amount
			return
		end

		-- If player is offline, update DataStores
		local suc, data = pcall(function()
			return PARTS_STORE:GetAsync("Player_"..UserId)
		end)

		if suc and data then
			local suc2, errormsg = pcall(function()
				local newValue = data + tonumber(Amount)
				PARTS_STORE:SetAsync("Player_"..UserId, newValue)
				PARTS_LEADERBOARD_DATA_STORE:SetAsync(tostring(UserId), newValue) -- ordered data
			end)
			if suc2 then return end
		end

		-- If no data exists, initialize with Amount
		local suc3, errormsg = pcall(function()
			PARTS_STORE:SetAsync("Player_"..UserId, tonumber(Amount))
			PARTS_LEADERBOARD_DATA_STORE:SetAsync(tostring(UserId), tonumber(Amount))
		end)
	end)
	MESSAGING_SERVICE:SubscribeAsync("ResetParts", function(message)
		local userId = message.Data.UserId
		local name = message.Data.Name
		local player = PLAYERS:FindFirstChild(name)
		if player then
			player:WaitForChild("leaderstats"):WaitForChild(SETTINGS_MODULE.PartsName).Value = 0
			return
		end
		local success, data = pcall(function()
			return PARTS_STORE:GetAsync("Player_"..userId)
		end)
		if success and data then
			local success2, errormsg = pcall(function()
				PARTS_STORE:SetAsync("Player_"..userId, 0)
				PARTS_LEADERBOARD_DATA_STORE:SetAsync(tostring(userId), 0)
			end)
			if not success2 then
				warn("Failed to reset parts for "..name..": "..errormsg)
			end
		end
	end)
	
	MESSAGING_SERVICE:SubscribeAsync("ResetObbies", function(message)
		local userId = message.Data.UserId
		local name = message.Data.Name
		local player = PLAYERS:FindFirstChild(name)
		if player then
			player:WaitForChild("Values"):WaitForChild("ObbiesCompleted").Value = 0
			OBBIES_LEADERBOARD_DATA_STORE:SetAsync(tostring(userId), 0)
			OBBIES_STORE:SetAsync("Player_"..player.UserId, 0)
			return
		end
		OBBIES_LEADERBOARD_DATA_STORE:SetAsync(tostring(userId), 0)
		OBBIES_STORE:SetAsync("Player_"..player.UserId, 0)
		print("succ")

	end)
end
