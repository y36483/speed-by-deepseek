local p=game.Players.LocalPlayer;local RS=game:GetService("RunService")
local function L(u) pcall(function() loadstring(game:HttpGet(u))() end) end
local W;pcall(function() W=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))() end)
if not W then pcall(function() W=loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))() end) end
if not W then return end

local win=W:CreateWindow({Title="麟麟七脚本中心",Icon="door-open",Size=UDim2.fromOffset(340,480),Theme="Dark",ToggleKey=Enum.KeyCode.RightShift})
local T1=win:Tab({Title="通用功能",Icon="settings"})
local T2=win:Tab({Title="更多脚本",Icon="code"})
local T3=win:Tab({Title="忍者传奇",Icon="swords"})

-- 穿墙
local nc=false;local hc
local function sc(s) local c=p.Character;if c then for _,o in ipairs(c:GetDescendants()) do if o:IsA("BasePart") then o.CanCollide=s end end end end
T1:Toggle({Title="穿墙",Default=false,Callback=function(v) nc=v;if v then if not hc then hc=RS.Heartbeat:Connect(function() sc(false) end) end else if hc then hc:Disconnect();hc=nil end;sc(true) end end})
p.CharacterAdded:Connect(function() if nc and not hc then hc=RS.Heartbeat:Connect(function() sc(false) end) end end)
p.CharacterRemoving:Connect(function() if hc then hc:Disconnect();hc=nil end end)

-- 速度
local sp=16
local function as(s) local c=p.Character;if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=s end end
p.CharacterAdded:Connect(function(c) if sp then (c:WaitForChild("Humanoid",5) or {}).WalkSpeed=sp end end)
T1:Button({Title="设置速度: "..sp,Callback=function()
    local g=Instance.new("ScreenGui",p.PlayerGui);local f=Instance.new("Frame",g)
    f.Size=UDim2.new(0,240,0,130);f.Position=UDim2.new(0.5,-120,0.5,-65);f.BackgroundColor3=Color3.fromRGB(40,40,50);f.ZIndex=10
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    local t=Instance.new("TextLabel",f);t.Size=UDim2.new(1,-20,0,25);t.Position=UDim2.new(0,10,0,5);t.BackgroundTransparency=1
    t.Text="输入速度";t.TextColor3=Color3.new(1,1,1);t.TextSize=14;t.ZIndex=11
    local b=Instance.new("TextBox",f);b.Size=UDim2.new(1,-40,0,32);b.Position=UDim2.new(0,20,0,35)
    b.Text=tostring(sp);b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(60,60,70);b.ZIndex=11
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
    local function cl() g:Destroy() end
    local o=Instance.new("TextButton",f);o.Size=UDim2.new(0,75,0,28);o.Position=UDim2.new(0.5,-85,0,90)
    o.BackgroundColor3=Color3.fromRGB(80,130,220);o.Text="确定";o.TextColor3=Color3.new(1,1,1);o.ZIndex=11
    Instance.new("UICorner",o).CornerRadius=UDim.new(0,4)
    local c=Instance.new("TextButton",f);c.Size=UDim2.new(0,75,0,28);c.Position=UDim2.new(0.5,10,0,90)
    c.BackgroundColor3=Color3.fromRGB(120,120,130);c.Text="取消";c.TextColor3=Color3.new(1,1,1);c.ZIndex=11
    Instance.new("UICorner",c).CornerRadius=UDim.new(0,4)
    o.MouseButton1Click:Connect(function() local n=tonumber(b.Text)
        if n then n=math.floor(n);if n<1 then n=1 elseif n>2147483647 then n=2147483647 end
        sp=n;as(n);W:CreateNotification({Title="速度",Content="已设为 "..n,Duration=2,Type="Success"}) end;cl() end)
    c.MouseButton1Click:Connect(cl)
end})

-- 扩展按钮
local ext={{"IY指令","https://rawscripts.net/raw/Universal-Script-IY-mobile-136050"},{"无敌少侠","https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%97%A0%E6%95%8C%E5%B0%91%E4%BE%A0%E9%A3%9E%E8%A1%8Cr6.txt"},{"隐身1","https://pastebin.com/raw/3Rnd9rHf"},{"隐身2","https://pastebin.com/raw/vP6CrQJj"},{"防甩飞","https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"},{"甩飞所有人","https://pastebin.com/raw/zqyDSUWX"},{"管理员权限","https://pastebin.com/raw/sZpgTVas"},{"玩家进入提示","https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"},{"死亡笔记","https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"},{"铁拳","https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"}}
for _,x in ipairs(ext) do T1:Button({Title=x[1],Callback=function() L(x[2]) end}) end
T1:Button({Title="自杀",Callback=function() local c=p.Character;if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health=0 end end})

-- 更多脚本
local scr={{"皮脚本",function() getgenv().XiaoPi="皮脚本QQ群1002100032" L("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua") end},{"剑客V7",function() getgenv().Sword_Guest_V7="欢迎使用剑客V7" L("https://raw.githubusercontent.com/Zer0neK/Hello/refs/heads/main/SG-V7") end},{"落叶中心",function() getgenv().LS="落叶中心" L("https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt") end},{"秋脚本",function() L("https://pastebin.com/raw/8f2LcqqP") L("https://raw.githubusercontent.com/WS857960/-/main/%E7%A7%8B%E8%87%AA%E5%88%B6%E8%84%9A%E6%9C%AC.txt") end},{"挽脚本",function() L("https://raw.githubusercontent.com/mtaskhh/script/refs/heads/main/Protected_9892402027124653.lua") end},{"黑白脚本",function() L("https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器") end},{"叶脚本",function() L("https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/ROBLOX-CNVIP-XIAOYE.lua") end},{"羽脚本",function() L("https://raw.githubusercontent.com/JY6812/-/refs/heads/main/%E7%BE%BD%E8%84%9A%E6%9C%ACv2.lua") end},{"新乌托邦",function() L("https://pastefy.app/M1Ns2Ggo/raw") end},{"忍脚本",function() L("https://raw.githubusercontent.com/renlua/shallow/main/Script_Hub.lua") end},{"情云脚本",function() L("https://raw.githubusercontent.com/ChinaQY/-/main/%E6%83%85%E4%BA%91") end},{"Apt脚本",function() L("https://raw.githubusercontent.com/nainshu/no/main/APT.lua") end},{"禁漫中心",function() getgenv().LS="禁漫中心" L("https://raw.githubusercontent.com/dingding123hhh/anlushanjinchangantangwanle/main/jmghjkknsbdbskkakwbebnfshdhhcyvtbrvrshwbshhshshsgsvsb.lua") end}}
for _,x in ipairs(scr) do T2:Button({Title=x[1],Callback=x[2]}) end

-- 忍者传奇-无限金币
T3:Button({Title="无限金币",Callback=function()
    local r=game:GetService("ReplicatedStorage"):WaitForChild("rEvents")
    local ze=r:WaitForChild("zenMasterEvent");local ee=r:WaitForChild("elementMasteryEvent")
    local function C(c,p) local o=Instance.new(c);for k,v in pairs(p or{})do o[k]=v end;o.Parent=p and p.Parent;return o end
    local g=C("ScreenGui",p.PlayerGui);local m=C("Frame",g,{Size=UDim2.new(0,180,0,170),Position=UDim2.new(0.05,0,0.05,0),BackgroundColor3=Color3.fromRGB(50,50,50),Active=true,Draggable=true})
    C("TextLabel",m,{Size=UDim2.new(1,0,0,18),BackgroundColor3=Color3.fromRGB(30,30,30),Text="Ninja Legends GUI",TextColor3=Color3.new(1,1,1),TextSize=10})
    local function B(t,y,cb) local b=C("TextButton",m,{Size=UDim2.new(1,-10,0,20),Position=UDim2.new(0,5,0,y),BackgroundColor3=Color3.fromRGB(100,100,100),Text=t,TextColor3=Color3.new(1,1,1),TextSize=10});if cb then b.MouseButton1Click:Connect(cb) end;return b end
    B("Start",55,function() ze:FireServer("convertGems",-9e999) end)
    local e=C("TextBox",m,{Size=UDim2.new(1,-20,0,25),Position=UDim2.new(0,10,0,80),BackgroundColor3=Color3.fromRGB(80,80,80),Text="数字",TextColor3=Color3.new(1,1,1),TextSize=10,ClearTextOnFocus=true})
    B("Submit",110,function() local n=tonumber(e.Text);if n and n>0 and n<=1e100 then ze:FireServer("convertGems",n) else e.Text="太大!" end end)
    local d=B("Discord",135);d.BackgroundColor3=Color3.fromRGB(60,60,200);d.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/notexttospeech") end)
    local mg=C("ScreenGui",p.PlayerGui,{Enabled=false});local mf=C("Frame",mg,{Size=UDim2.new(0,250,0,400),Position=UDim2.new(0.2,0,0.2,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Active=true,Draggable=true})
    C("TextLabel",mf,{Size=UDim2.new(1,0,0,30),BackgroundColor3=Color3.new(0,0,0),Text="大师元素",TextColor3=Color3.new(1,1,1),TextSize=14})
    local sf=C("ScrollingFrame",mf,{Size=UDim2.new(1,0,1,-30),Position=UDim2.new(0,0,0,30),CanvasSize=UDim2.new(0,0,0,400),ScrollBarThickness=5,BackgroundTransparency=1})
    local el={"Shadow Charge","Electral Chaos","Blazing Entity","Shadowfire","Lightning","Masterful Wrath","Inferno","Eternity Storm","Frost"}
    for i,e in ipairs(el) do local b=C("TextButton",sf,{Size=UDim2.new(1,-20,0,30),Position=UDim2.new(0,10,0,(i-1)*35),BackgroundColor3=Color3.fromRGB(100,100,100),Text="Master "..e,TextColor3=Color3.new(1,1,1),TextSize=10});b.MouseButton1Click:Connect(function() ee:FireServer(e) end) end
    local tb=B("切换大师元素",30);tb.MouseButton1Click:Connect(function() mg.Enabled=not mg.Enabled end)
end})

-- 忍者传奇-宠物商店
T3:Button({Title="宠物商店",Callback=function()
    local pt={"Dark Vampy","Green Vampy","Purple Angel","Silver Dog","Purple Birdie","Blue Hedgehog","Phantom Soul Seeker","Hypersonic Pegasus","Shadows Edge Kitty","Eternity Legends Bunny","Divine Prophecy Dragon","Azure Wonder Kitty","Rising Abyss Birdie","Pink Stardust Dog","Ruby Midnight Wyvern","Destiny Heroes Golem","Ultra Chaos Fusion Dragon","Cybernetic Emerald Dragon","Ancient Millenium Bunny","Energized Skyraider Cerberus","Ultra Dimensions Bunny","Eternity Heroes Kitty","Phantom Genesis Dragon","Starstrike Overdrive Dragon","Royal Cosmo Pegasus","Winter Legends Polar Bear","Ultranova Firecaster","Frostwave Pegasus","Master Guardian Manticore","Dual Destiny Shadow Dragon","Ultimate Supernova Pegasus","Winter Wonder Kitty","Mini Chaos Legend","Christmas Sensei Reindeer","Twilight Magical Kitty","Cosmic Hunter Dragon","Dual Starlight Eclipse Dragon","Frostwave Legends Penguin","Sub-Zero Frost Hydra","Dark Lunar Leviathan","Ancient Inferno Kitty","Mini Vortex Legend","Unleashed Sub-Zero Dragon","Golden Sun Pegasus","Golden Strike Dragon","Gold Storm Manticore","Golden Sparks Dog","Master Underworld Phantom","Mystical Power Manticore","Underworld Duo Dragon","Golden Dawn Bunny","Teal Shadow Dragon","Dual Eternal Charge Dragon","Inner Focus Penguin","Darkstorm Elemental Hydra","Soul Focus Phantom","Masterful Strike Leviathan","Inner Peace Cerberus","Heatwave Shadow Penguin","Cybernetic Strike Leviathan","Zen Master Leviathan","Eternity Shadow Kitty","Lightning Bolt Bunny","Teal Thunderstorm Dragon","DRAGON: Nebula Skystorm","Mystic Shadows Dragon","Unlimited Secrets Master Dragon","Corrupted Elements Hydra","Dark Vortex Manticore","Cybernetic Showdown Dragon","Rising Millenium Hydra","Secret Shadows Leviathan","Shadow Eclipse Leviathan","Azure Series Omega Pegasus","Darkstar Eternal Kitty","CYBER: Ancient Master Wraith","Lightning Strike Phantom","Rising Dawn Midnight Wyvern","GLITCH: Awakened Nighthunter","Inner Darkness Hydra","Dark Blizzard Master Penguin","Cybernetic Sleigh Rider","Dual Warp Drive Dragon"}
    local function bp(n) pcall(function() local r=game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopRemote");local f=game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopFolder");if r and f then local pet=f:FindFirstChild(n);if pet then r:InvokeServer(pet) end end end) end
    local g=Instance.new("ScreenGui",p.PlayerGui);local m=Instance.new("Frame",g);m.Size=UDim2.new(0,280,0,400);m.Position=UDim2.new(0.3,0,0.2,0);m.BackgroundColor3=Color3.fromRGB(40,40,50);m.Active=true;m.Draggable=true
    Instance.new("UICorner",m).CornerRadius=UDim.new(0,8)
    local t=Instance.new("TextLabel",m);t.Size=UDim2.new(1,0,0,35);t.BackgroundColor3=Color3.fromRGB(60,60,80);t.Text="宠物商店 ("..#pt.."只)";t.TextColor3=Color3.new(1,1,1);t.TextSize=18
    Instance.new("UICorner",t).CornerRadius=UDim.new(0,8)
    local x=Instance.new("TextButton",m);x.Size=UDim2.new(0,24,0,24);x.Position=UDim2.new(1,-28,0,5);x.BackgroundColor3=Color3.fromRGB(200,60,60);x.Text="X";x.TextColor3=Color3.new(1,1,1);x.TextSize=14
    Instance.new("UICorner",x).CornerRadius=UDim.new(0,12);x.MouseButton1Click:Connect(function() g:Destroy() end)
    local ba=Instance.new("TextButton",m);ba.Size=UDim2.new(1,-20,0,30);ba.Position=UDim2.new(0,10,0,45);ba.BackgroundColor3=Color3.fromRGB(80,160,80);ba.Text="一键购买全部";ba.TextColor3=Color3.new(1,1,1);ba.TextSize=14
    Instance.new("UICorner",ba).CornerRadius=UDim.new(0,6);ba.MouseButton1Click:Connect(function() for _,v in ipairs(pt) do bp(v);task.wait(0.3) end end)
    local s=Instance.new("ScrollingFrame",m);s.Size=UDim2.new(1,-10,1,-85);s.Position=UDim2.new(0,5,0,80);s.CanvasSize=UDim2.new(0,0,0,#pt*32);s.ScrollBarThickness=6;s.BackgroundTransparency=1
    local ll=Instance.new("UIListLayout",s);ll.Padding=UDim.new(0,4);ll.SortOrder=Enum.SortOrder.LayoutOrder
    for i,v in ipairs(pt) do local b=Instance.new("TextButton",s);b.Size=UDim2.new(1,-4,0,28);b.LayoutOrder=i;b.BackgroundColor3=Color3.fromRGB(70,70,90);b.Text="购买 "..v;b.TextColor3=Color3.new(1,1,1);b.TextSize=13
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,4);b.MouseButton1Click:Connect(function() bp(v) end) end
end})

-- 忍者传奇-自动训练
local tr
T3:Toggle({Title="自动训练",Default=false,Callback=function(v)
    if v then
        local function ef() local c=p.Character;if not c then return end;local t=nil;local bp=p:FindFirstChild("Backpack");if bp then for _,o in ipairs(bp:GetChildren()) do if o:IsA("Tool") then t=o;break end end end;if not t then for _,o in ipairs(c:GetChildren()) do if o:IsA("Tool") then t=o;break end end end;if t and c:FindFirstChild("Humanoid") then c.Humanoid:EquipTool(t) end end
        ef();tr=RS.Stepped:Connect(function() ef();local ne=p:FindFirstChild("ninjaEvent");if ne then ne:FireServer("swingKatana") end end)
    else if tr then tr:Disconnect();tr=nil end end
end})

if W.Init then W:Init() end
