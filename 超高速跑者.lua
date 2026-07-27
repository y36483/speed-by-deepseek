-- 麟麟七脚本中心（最终版：秘密杀手 + 全部功能）
local p=game.Players.LocalPlayer local RS=game:GetService("RunService")local UIS=game:GetService("UserInputService")local TS=game:GetService("TweenService")
local key="007牛逼"local verified=false local failCount=0
local rnb={Color3.new(1,0,0),Color3.new(1,0.5,0),Color3.new(1,1,0),Color3.new(0,1,0),Color3.new(0,1,1),Color3.new(0,0,1),Color3.new(0.55,0,1),Color3.new(1,0,1)}
local SOUND_ON="rbxassetid://9117502643"local SOUND_OFF="rbxassetid://9117502643"

-- 彩虹提示
local function showTip(m,isOn)
    local s=Instance.new("Sound",p:WaitForChild("PlayerGui"))s.SoundId=isOn and SOUND_ON or SOUND_OFF s.Volume=0.5 s:Play()game:GetService("Debris"):AddItem(s,2)
    local g=Instance.new("ScreenGui",p.PlayerGui)g.IgnoreGuiInset=true
    local f=Instance.new("Frame",g)f.Size=UDim2.new(0,200,0,36)f.Position=UDim2.new(1,10,1,-46)f.BackgroundColor3=Color3.new(1,1,1)f.BackgroundTransparency=1
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)local gg=Instance.new("UIGradient",f)
    local l=Instance.new("TextLabel",f)l.Size=UDim2.new(1,0,1,0)l.BackgroundTransparency=1 l.Text=m l.TextColor3=Color3.new(1,1,1)l.TextSize=14 l.Font=Enum.Font.GothamBold l.TextTransparency=1
    TS:Create(f,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(1,-210,1,-46)}):Play()
    TS:Create(f,TweenInfo.new(0.3),{BackgroundTransparency=0.7}):Play()
    TS:Create(l,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    local stop=false spawn(function()local off=0 while not stop do off=(off+0.02)%1 local c1=rnb[math.floor(off*8)%8+1]local c2=rnb[math.floor((off+0.5)*8)%8+1]gg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})gg.Rotation=off*360 l.TextColor3=rnb[math.floor(off*8)%8+1]task.wait(0.05)end end)
    task.wait(2)stop=true TS:Create(f,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(1,10,1,-46)}):Play()
    TS:Create(f,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()TS:Create(l,TweenInfo.new(0.3),{TextTransparency=1}):Play()task.wait(0.4)g:Destroy()
end

-- 卡密验证
local kg=Instance.new("ScreenGui",p.PlayerGui)kg.IgnoreGuiInset=true
local overlay=Instance.new("Frame",kg)overlay.Size=UDim2.new(1,0,1,0)overlay.BackgroundColor3=Color3.new(0,0,0)overlay.BackgroundTransparency=0.85
local mf=Instance.new("Frame",kg)mf.Size=UDim2.new(0,300,0,220)mf.Position=UDim2.new(0.5,-150,0.5,-110)mf.BackgroundColor3=Color3.fromRGB(20,20,30)mf.BackgroundTransparency=0.4
Instance.new("UICorner",mf).CornerRadius=UDim.new(0,14)
local glow=Instance.new("Frame",mf)glow.Size=UDim2.new(1,6,1,6)glow.Position=UDim2.new(0,-3,0,-3)glow.BackgroundTransparency=1 glow.BackgroundColor3=Color3.new(1,1,1)
Instance.new("UICorner",glow).CornerRadius=UDim.new(0,16)local glowGrad=Instance.new("UIGradient",glow)glowGrad.Rotation=90 glow.BackgroundTransparency=0.75
local tl=Instance.new("TextLabel",mf)tl.Size=UDim2.new(1,0,0,36)tl.Position=UDim2.new(0,0,0,10)tl.BackgroundTransparency=1 tl.Text="⚡ 麟 麟 七 · 验 证 ⚡"tl.TextSize=22 tl.Font=Enum.Font.GothamBlack
local tlGrad=Instance.new("UIGradient",tl)
local ib=Instance.new("Frame",mf)ib.Size=UDim2.new(1,-50,0,40)ib.Position=UDim2.new(0,25,0,80)ib.BackgroundColor3=Color3.fromRGB(255,255,255)ib.BackgroundTransparency=0.92
Instance.new("UICorner",ib).CornerRadius=UDim.new(0,8)
local ibr=Instance.new("Frame",ib)ibr.Size=UDim2.new(1,4,1,4)ibr.Position=UDim2.new(0,-2,0,-2)ibr.BackgroundTransparency=1 ibr.BackgroundColor3=Color3.new(1,1,1)
Instance.new("UICorner",ibr).CornerRadius=UDim.new(0,10)local ibrGrad=Instance.new("UIGradient",ibr)ibrGrad.Rotation=90 ibr.BackgroundTransparency=0.6
local ibx=Instance.new("TextBox",ib)ibx.Size=UDim2.new(1,-10,1,-10)ibx.Position=UDim2.new(0,5,0,5)ibx.BackgroundTransparency=1 ibx.PlaceholderText="🔑 输入卡密..."ibx.Text=""ibx.TextColor3=Color3.new(1,1,1)ibx.TextSize=16 ibx.Font=Enum.Font.Code ibx.ClearTextOnFocus=true
local hl=Instance.new("TextLabel",mf)hl.Size=UDim2.new(1,-40,0,18)hl.Position=UDim2.new(0,20,0,130)hl.BackgroundTransparency=1 hl.Text=""hl.TextColor3=Color3.fromRGB(1,0.4,0.4)hl.TextSize=12
local vb=Instance.new("TextButton",mf)vb.Size=UDim2.new(1,-50,0,48)vb.Position=UDim2.new(0,25,0,155)vb.BackgroundColor3=Color3.fromRGB(255,255,255)vb.Text="验  证"vb.TextColor3=Color3.new(1,1,1)vb.TextSize=24 vb.Font=Enum.Font.GothamBlack vb.BorderSizePixel=0 vb.TextStrokeTransparency=0.5
Instance.new("UICorner",vb).CornerRadius=UDim.new(0,10)local vbGrad=Instance.new("UIGradient",vb)vbGrad.Rotation=90

local function verify()
    if ibx.Text==key then vb.Text="✅ 通过"vbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,1,0.4)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0.8,0.4))})task.wait(0.5)verified=true kg:Destroy()
    else failCount=failCount+1
        if failCount>=3 then hl.Text="❌ 验证失败3次，即将退出..."vb.Text="⛔ 踢出"vbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(1,0,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0.5,0,0))})task.wait(1.5)p:Kick("验证失败次数过多")return end
        local r=3-failCount hl.Text="❌ 卡密错误（剩余"..r.."次）"vb.Text="⛔ 拒绝"vbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(1,0,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(1,0.3,0.3))})task.wait(0.6)vb.Text="验  证"vbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,rnb[1]),ColorSequenceKeypoint.new(0.5,rnb[4]),ColorSequenceKeypoint.new(1,rnb[7])})hl.Text=""ibx.Text=""
    end
end
vb.MouseButton1Click:Connect(verify)ibx.FocusLost:Connect(function(ep)if ep then verify()end end)
spawn(function()local off=0 while not verified do off=(off+0.008)%1 local c1=rnb[math.floor(off*8)%8+1]local c2=rnb[math.floor((off+0.3)*8)%8+1]local c3=rnb[math.floor((off+0.6)*8)%8+1]tlGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})glowGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(0.5,c3),ColorSequenceKeypoint.new(1,c2)})glowGrad.Rotation=off*360 ibrGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})if vb.Text=="验  证" then vbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(0.5,c2),ColorSequenceKeypoint.new(1,c3)})vbGrad.Rotation=off*360 end task.wait(0.04)end end)
repeat task.wait()until verified

-- WindUI
local W
pcall(function()W=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()end)
if not W then pcall(function()W=loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()end)end
if not W then return end

local win=W:CreateWindow({Title="麟麟七脚本中心",ToggleKey=Enum.KeyCode.RightShift})
local T0=win:Tab({Title="公告",Icon="info"})local T1=win:Tab({Title="通用功能",Icon="settings"})local T2=win:Tab({Title="更多脚本",Icon="code"})local T3=win:Tab({Title="忍者传奇",Icon="swords"})local T4=win:Tab({Title="秘密杀手",Icon="users"})
local function L(u)pcall(function()loadstring(game:HttpGet(u))()end)end

T0:Button({Title="2026/7/26第一次更新",Callback=function()W:CreateNotification({Title="更新",Content="新增11个脚本",Duration=3,Type="Info"})end})

-- 透视
local esp=false local ec=Color3.new(1,1,1)local hl={}local lt=0 local cm={["白色"]=Color3.new(1,1,1),["红色"]=Color3.new(1,0,0),["绿色"]=Color3.new(0,1,0),["蓝色"]=Color3.new(0,0.6,1),["黄色"]=Color3.new(1,1,0),["紫色"]=Color3.new(0.7,0,1),["青色"]=Color3.new(0,1,1),["粉色"]=Color3.new(1,0.4,0.7),["橙色"]=Color3.new(1,0.65,0)}local cn={"白色","红色","绿色","蓝色","黄色","紫色","青色","粉色","橙色"}
local function ah(t)if t and not t:FindFirstChild("E")then local h=Instance.new("Highlight")h.Name="E"h.FillTransparency=1 h.OutlineColor=ec h.Parent=t table.insert(hl,h)end end
local function cl()for _,h in ipairs(hl)do if h then h:Destroy()end end hl={}end
local function sc()for _,pl in ipairs(game.Players:GetPlayers())do if pl~=p and pl.Character then ah(pl.Character)end end end
local function st(n)if cm[n]then ec=cm[n]for _,h in ipairs(hl)do if h then h.OutlineColor=ec end end end end
local lc
T1:Toggle({Title="玩家透视",Default=false,Callback=function(v)esp=v if v then sc()if not lc then lc=RS.Heartbeat:Connect(function()if not esp then return end local n=tick()if n-lt<0.5 then return end lt=n sc()end)end else if lc then lc:Disconnect()lc=nil end cl()end showTip(v and "已开启 玩家透视" or "已关闭 玩家透视", v) end})
T1:Dropdown({Title="透视颜色",Items=cn,Default="白色",Callback=function(v)st(v)end})

-- 穿墙
local nc=false local hc
function sf(s)local c=p.Character if c then for _,o in ipairs(c:GetDescendants())do if o:IsA("BasePart")then o.CanCollide=s end end end end
T1:Toggle({Title="穿墙",Default=false,Callback=function(v)nc=v if v then if not hc then hc=RS.Heartbeat:Connect(function()sf(false)end)end else if hc then hc:Disconnect()hc=nil end sf(true)end showTip(v and "已开启 穿墙" or "已关闭 穿墙", v) end})
p.CharacterAdded:Connect(function()if nc and not hc then hc=RS.Heartbeat:Connect(function()sf(false)end)end end)

-- 速度
local sp=16 function as(s)local c=p.Character if c and c:FindFirstChild("Humanoid")then c.Humanoid.WalkSpeed=s end end
p.CharacterAdded:Connect(function(c)if sp then(c:WaitForChild("Humanoid",5)or{}).WalkSpeed=sp end end)
T1:Button({Title="设置速度:"..sp,Callback=function()
    local g=Instance.new("ScreenGui",p.PlayerGui)local f=Instance.new("Frame",g)f.Size=UDim2.new(0,240,0,130)f.Position=UDim2.new(0.5,-120,0.5,-65)f.BackgroundColor3=Color3.fromRGB(40,40,50)
    local t=Instance.new("TextLabel",f)t.Size=UDim2.new(1,-20,0,25)t.Position=UDim2.new(0,10,0,5)t.BackgroundTransparency=1 t.Text="输入速度"t.TextColor3=Color3.new(1,1,1)t.TextSize=14
    local b=Instance.new("TextBox",f)b.Size=UDim2.new(1,-40,0,32)b.Position=UDim2.new(0,20,0,35)b.Text=tostring(sp)b.TextColor3=Color3.new(1,1,1)b.BackgroundColor3=Color3.fromRGB(60,60,70)
    local o=Instance.new("TextButton",f)o.Size=UDim2.new(0,75,0,28)o.Position=UDim2.new(0.5,-85,0,90)o.BackgroundColor3=Color3.fromRGB(80,130,220)o.Text="确定"o.TextColor3=Color3.new(1,1,1)
    local c=Instance.new("TextButton",f)c.Size=UDim2.new(0,75,0,28)c.Position=UDim2.new(0.5,10,0,90)c.BackgroundColor3=Color3.fromRGB(120,120,130)c.Text="取消"c.TextColor3=Color3.new(1,1,1)
    o.MouseButton1Click:Connect(function()local n=tonumber(b.Text)if n then n=math.floor(n)if n<1 then n=1 elseif n>2147483647 then n=2147483647 end sp=n as(n)end g:Destroy()end)c.MouseButton1Click:Connect(function()g:Destroy()end)
end})

-- 扩展功能
local ex={{"IY指令","https://rawscripts.net/raw/Universal-Script-IY-mobile-136050"},{"无敌少侠","https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%97%A0%E6%95%8C%E5%B0%91%E4%BE%A0%E9%A3%9E%E8%A1%8Cr6.txt"},{"隐身1","https://pastebin.com/raw/3Rnd9rHf"},{"隐身2","https://pastebin.com/raw/vP6CrQJj"},{"防甩飞","https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"},{"甩飞所有人","https://pastebin.com/raw/zqyDSUWX"},{"管理员权限","https://pastebin.com/raw/sZpgTVas"},{"玩家进入提示","https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"},{"死亡笔记","https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"},{"铁拳","https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"},{"飞行","https://pastefy.app/z1mFBr9I/raw"},{"飞檐走壁","https://pastebin.com/raw/zXk4Rq2r"},{"旋转","https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%97%8B%E8%BD%AC.lua"},{"阿尔宙斯自瞄","https://raw.githubusercontent.com/dingding123hhh/sgbs/main/%E4%B8%81%E4%B8%81%20%E6%B1%89%E5%8C%96%E8%87%AA%E7%9E%84.txt"},{"替身","https://raw.githubusercontent.com/SkrillexMe/SkrillexLoader/main/SkrillexLoadMain"},{"工具挂","https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"},{"飞车","https://raw.githubusercontent.com/dingding123hhh/vb/main/%E9%A3%9E%E8%BD%A6.lua"},{"踏空行走","https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"},{"飞车2","https://pastebin.com/raw/G3GnBCyC"},{"反挂机","https://pastebin.com/raw/9fFu43FF"},{"撸管(r6)","https://pastefy.app/wa3v2Vgm/raw"},{"撸管(r15)","https://pastefy.app/YZoglOyJ/raw"},{"解锁通行证","https://raw.githubusercontent.com/LX318/LX/main/%E8%A7%A3%E9%94%81%E6%B8%B8%E6%88%8F%E9%80%9A%E8%A1%8C%E8%AF%81%202.lua"},{"骂人无违规","rbxassetid://1262435912"},{"人物悬空","https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"},{"c00likidd","rbxassetid://11801763945"}}
for _,x in ipairs(ex)do T1:Button({Title=x[1],Callback=function()if x[2]:find("rbxassetid://")then pcall(function()local obj=game:GetObjects(x[2])if obj and obj[1]then loadstring(obj[1].Source)()end end)else L(x[2])end end})end
T1:Button({Title="自杀",Callback=function()local c=p.Character if c and c:FindFirstChild("Humanoid")then c.Humanoid.Health=0 end end})

-- 更多脚本
local sr={{"皮脚本",function()getgenv().XiaoPi="皮脚本QQ群1002100032"L("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua")end},{"剑客V7",function()L("https://raw.githubusercontent.com/Zer0neK/Hello/refs/heads/main/SG-V7")end},{"落叶中心",function()getgenv().LS="落叶中心"L("https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt")end},{"秋脚本",function()L("https://pastebin.com/raw/8f2LcqqP")L("https://raw.githubusercontent.com/WS857960/-/main/%E7%A7%8B%E8%87%AA%E5%88%B6%E8%84%9A%E6%9C%AC.txt")end},{"挽脚本",function()L("https://raw.githubusercontent.com/mtaskhh/script/refs/heads/main/Protected_9892402027124653.lua")end},{"黑白脚本",function()L("https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器")end},{"叶脚本",function()L("https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/ROBLOX-CNVIP-XIAOYE.lua")end},{"羽脚本",function()L("https://raw.githubusercontent.com/JY6812/-/refs/heads/main/%E7%BE%BD%E8%84%9A%E6%9C%ACv2.lua")end},{"新乌托邦",function()L("https://pastefy.app/M1Ns2Ggo/raw")end},{"忍脚本",function()L("https://raw.githubusercontent.com/renlua/shallow/main/Script_Hub.lua")end},{"情云脚本",function()L("https://raw.githubusercontent.com/ChinaQY/-/main/%E6%83%85%E4%BA%91")end},{"Apt脚本",function()L("https://raw.githubusercontent.com/nainshu/no/main/APT.lua")end},{"禁漫中心",function()getgenv().LS="禁漫中心"L("https://raw.githubusercontent.com/dingding123hhh/anlushanjinchangantangwanle/main/jmghjkknsbdbskkakwbebnfshdhhcyvtbrvrshwbshhshshsgsvsb.lua")end},{"灰云脚本",function()_G.Clouduilib="白灰脚作者小云"L("https://raw.githubusercontent.com/CloudX-ScriptsWane/White-ash-script/main/%E7%99%BD%E7%81%B0%E8%84%9A%E6%9C%ACbeta.lua")end},{"导管中心",function()loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\117\115\101\114\97\110\101\119\114\102\102\47\114\111\98\108\111\120\45\47\109\97\105\110\47\37\69\54\37\57\68\37\65\49\37\69\54\37\65\67\37\66\69\37\69\53\37\56\68\37\56\70\37\69\56\37\65\69\37\65\69\34\41\41\40\41\10")()end},{"北约脚本",function()L("https://raw.githubusercontent.com/USA868/114514-55-646-114514-88-61518-618-840-1018-634-10-4949-3457578401-615/main/Protected-36.lua")end},{"云脚本",function()L("https://raw.githubusercontent.com/XiaoYunCN/UWU/main/XiaoYun_currentedition_beta.lua")end},{"忍脚本2",function()L("https://pastebin.com/raw/1k7RAfQJ")end},{"bs轻量版",function()L("https://raw.githubusercontent.com/vbxfhcd/BS/refs/heads/main/BS-loves_you.txt")end},{"tubers93",function()L("https://raw.githubusercontent.com/Wbw1470619303-ctrl/w-/refs/heads/main/%E5%8F%AF%E4%BB%A5%E7%94%A8%E7%9A%84%E4%B8%BB%E8%84%9A%E6%9C%AC%E6%B7%B7%E6%B7%86%E5%90%8E%E7%9A%84.lua")end},{"北极脚本",function()L("https://pastebin.com/raw/KwARpDxV")end},{"syn脚本",function()L("https://pastebin.com/raw/tWGxhNq0")end},{"SA脚本",function()L("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua")end},{"月抛脚本",function()L("https://pastefy.app/2uwPck6l/raw")end}}
for _,x in ipairs(sr)do T2:Button({Title=x[1],Callback=x[2]})end

-- 忍者传奇
T3:Button({Title="无限金币",Callback=function()pcall(function()game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems",-9e999)end)end})
T3:Button({Title="宠物商店",Callback=function()local pt={"Dark Vampy","Green Vampy","Purple Angel","Silver Dog","Purple Birdie","Blue Hedgehog"}for _,v in ipairs(pt)do pcall(function()local r=game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopRemote")local f=game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopFolder")if r and f then local p=f:FindFirstChild(v)if p then r:InvokeServer(p)end end end)task.wait(0.3)end end})
local tr
T3:Toggle({Title="自动训练",Default=false,Callback=function(v)if v then local function eq()local c=p.Character if c and c:FindFirstChild("Humanoid")then local t=nil local bp=p:FindFirstChild("Backpack")if bp then for _,o in ipairs(bp:GetChildren())do if o:IsA("Tool")then t=o break end end end if not t then for _,o in ipairs(c:GetChildren())do if o:IsA("Tool")then t=o break end end end if t then c.Humanoid:EquipTool(t)end end end eq()tr=RS.Stepped:Connect(function()eq()local ne=p:FindFirstChild("ninjaEvent")if ne then ne:FireServer("swingKatana")end end)else if tr then tr:Disconnect()tr=nil end end showTip(v and "已开启 自动训练" or "已关闭 自动训练", v) end})

-- 秘密杀手（身份显示）
local gunKeys={"gun","枪","revolver","pistol","rifle","shotgun","deagle","和平","手枪","步枪","sheriff","警长"}
local monsterKeys={"claws","爪子","monster","怪物","变身","感染","beast","demon","恶魔","claw"}
local idESP=false local idHighlights={}

local function getTools(plr)local t={}local function s(p)for _,o in ipairs(p:GetChildren())do if o:IsA("Tool")then table.insert(t,o)end end end s(plr:FindFirstChild("Backpack")or{})if plr.Character then s(plr.Character)end return t end
local function hasK(tools,keys)for _,t in ipairs(tools)do local n=t.Name:lower()for _,k in ipairs(keys)do if n:find(k:lower())then return true end end end return false end
local function updateIdESP()
    for _,h in ipairs(idHighlights)do if h then h:Destroy()end end idHighlights={}if not idESP then return end
    for _,plr in ipairs(game.Players:GetPlayers())do if plr~=p and plr.Character then
        local tools=getTools(plr)local color=Color3.fromRGB(0,255,0)
        if #tools>=1 then if hasK(tools,gunKeys)then color=Color3.fromRGB(0,150,255)elseif #tools>=2 or hasK(tools,monsterKeys)then color=Color3.fromRGB(255,0,0)end end
        local hl=Instance.new("Highlight")hl.FillTransparency=1 hl.OutlineColor=color hl.OutlineTransparency=0 hl.Parent=plr.Character table.insert(idHighlights,hl)
    end end
end
local idHB
T4:Toggle({Title="身份显示",Description="绿=平民 | 蓝=警长 | 红=怪物",Default=false,Callback=function(v)
    idESP=v
    if v then updateIdESP()idHB=RS.Heartbeat:Connect(function()updateIdESP()end)showTip("已开启 身份显示",true)
    else if idHB then idHB:Disconnect()end for _,h in ipairs(idHighlights)do if h then h:Destroy()end end idHighlights={}showTip("已关闭 身份显示",false)end
end})

if W.Init then W:Init()end
