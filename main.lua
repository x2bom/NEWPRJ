

local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/x2bom/NEWPRJ/refs/heads/main/ui.lua'))()
local Window = UILib.new("ASTDX", game.Players.LocalPlayer.UserId, "Buyer")
local Category1 = Window:Category("Main", "http://www.roblox.com/asset/?id=8395621517")
local SubButton1 = Category1:Button("Modes", "http://www.roblox.com/asset/?id=8395747586")
local Section1 = SubButton1:Section("Section", "Left")
local plr = game.Players.LocalPlayer
local Name = "ASTDX-"..plr.Name..".json"
local DefaultSettings = {
	record={}
}
if not isfile("hub o lan "..Name) then 
    print("zo")
    writefile("hub o lan "..Name, game:GetService("HttpService"):JSONEncode(DefaultSettings)) 
    writefile("hub o lan "..Name.."Backup",game:GetService("HttpService"):JSONEncode(DefaultSettings))
end
task.wait(0.1)
pcall(function()
    getgenv().Settings = game:GetService("HttpService"):JSONDecode(readfile("hub o lan "..Name))
end)
function Save()
    writefile("hub o lan "..Name,game:GetService("HttpService"):JSONEncode(getgenv().Settings))
    writefile("hub o lan "..Name.."Backup",game:GetService("HttpService"):JSONEncode(getgenv().Settings))
end
for i,v in next, DefaultSettings do
    if getgenv().Settings[i] == nil then
        getgenv().Settings[i] = DefaultSettings[i]
        task.wait()
        writefile("hub o lan "..Name,game:GetService("HttpService"):JSONEncode(getgenv().Settings))
        writefile("hub o lan "..Name"Backup",game:GetService("HttpService"):JSONEncode(getgenv().Settings))
    end
end
local abc1234,xyz1234 = pcall(function()
    getgenv().Settings = game:GetService("HttpService"):JSONDecode(readfile("hub o lan "..Name))
end)
if not abc1234 then
    local abc12345,xyz12345 = pcall(function()
        getgenv().Settings = game:GetService("HttpService"):JSONDecode(readfile("hub o lan "..Name.."Backup"))
    end)
    if not abc12345 then
        getgenv().Settings = DefaultSettings
    end
end
local plr = game.Players.LocalPlayer

local chosen
local max=math.huge
for i,v in next, plr.PlayerGui.GU.MenuFrame.ExpandFrame.SideFrame.MoveFrame:GetChildren() do
    if v.Name=="MainTitle" then
        if v.AbsolutePosition.Y<max then
            chosen=v.Text
            max=v.AbsolutePosition.Y
        end
    elseif v.Name=="GameMode" then
        chosen="Lobby olan"
    end
end
getgenv().currentmode=string.split(chosen," ")[1]
local time = 0
task.spawn(function()
	repeat task.wait() until plr.PlayerGui.GU.MenuFrame.TopFrame.Start:FindFirstChild("SkipFrame")
    while task.wait() do
        task.wait(1)
        time=time+1
    end
end)
Section1:Keybind({
    Title = "Keybind",
    Description = "",
    Default = Enum.KeyCode.LeftControl,
    }, function(value)
    game.CoreGui.HD.Window.Visible=not game.CoreGui.HD.Window.Visible
end)
Section1:Toggle({
    Title = "Start farm",
    Description = "",
    Default = false
    }, function(value)
    getgenv().autofarm=value
end)
Section1:Toggle({
    Title = "Auto replay",
    Description = "Optional Description here",
    Default = false
    }, function(value)
    getgenv().replay=value
end)
Section1:Dropdown({
	Options={
		["Story"]=false,
		["Challenges"]=false,
		["Infinite"]=false,
		["Trial"]=false
	},
	Multi=false,
    Title="mocha",
    Default=true
	}, function(value)
	getgenv().mode=value
end)
if currentmode ~= "Lobby" then
    function findunit(coord,name)
        local max=math.huge
        local unit
        for i,v in next, workspace.UnitFolder:GetChildren() do
            if v.Name==name then
                if (v.HumanoidRootPart.Position-Vector3.new(coord)).Magnitude< max then
                    max=(v.HumanoidRootPart.Position-Vector3.new(coord)).Magnitude
                    unit=v
                end
            end
        end
        return unit
    end
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == 'FireServer' or method == "InvokeServer" then
            if self.Name == "SetEvent" then
                table.insert(Settings.record,[time]={
                    [1]=args[1],
                    [2]=args[2],
                    [3]=args[3],
                    type="summon"
                    --["unitfile"]=findunit(args[3],args[2])
                    Save()
                })
                return old(self, unpack(args))
            elseif self.Name=="GetFunction" then
                if args[1]=="Upgrade" then
                    table.insert(Settings.record,[time]={
                        ["unit"]=args[2],
                        type="upgrade"
                    })
                    Save()
                elseif args[1] =="SpecialMove" then
                    table.insert(Settings.record,[time]={
                        ["unitcf"]=args[2].HumanoidRootPart.CFrame,
                        type="teamup"
                    })
                    Save()
                return old(self, unpack(args))
            end
        end
        
        return old(self, ...)
    end);
    spawn(function()
        while task.wait() do
            if not game:GetService("Workspace").Bases["1"]:FindFirstChild("TowerBillBoard") then
                if replay then
                    repeat task.wait(2) until plr.PlayerGui.MainUI.ResultFrame.Result.Visible==true
                    local ohTable1 = {
                        ["Mode"] = "Reward",
                        ["Index"] = "Replay",
                        ["Type"] = "Game"
                    }
                    game:GetService("ReplicatedStorage").Remotes.GetFunction:InvokeServer(ohTable1)
                    until game:GetService("Workspace").Bases["1"]:FindFirstChild("TowerBillBoard")
                end
            end
        end
    end)
end
