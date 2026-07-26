-- 麟麟七脚本中心（最终完美版：炫酷验证 + 彩虹横版悬浮 + WindUI完整版）
local p = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ==================== 炫酷卡密验证 ====================
local key = "007牛逼"
local verified = false
local rainbowColors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(255,127,0), Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
    Color3.fromRGB(139,0,255), Color3.fromRGB(255,0,255)
}
local colorIndex = 1

local keyGui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
keyGui.IgnoreGuiInset = true

local bg = Instance.new("Frame", keyGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
bg.BackgroundTransparency = 0.5
bg.BorderSizePixel = 0

for i = 1, 3 do
    local line = Instance.new("Frame", bg)
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, i/4, 0)
    line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    line.BackgroundTransparency = 0.8
    line.BorderSizePixel = 0
    spawn(function()
        while not verified do
            for pos = 0, 1, 0.005 do
                line.Position = UDim2.new(0, 0, pos, 0)
                task.wait(0.02)
            end
        end
    end)
end

local mainFrame = Instance.new("Frame", bg)
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local borderGlow = Instance.new("Frame", mainFrame)
borderGlow.Size = UDim2.new(1, 4, 1, 4)
borderGlow.Position = UDim2.new(0, -2, 0, -2)
borderGlow.BackgroundTransparency = 1
borderGlow.BorderSizePixel = 0
local borderGradient = Instance.new("UIGradient", borderGlow)
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, rainbowColors[1]),
    ColorSequenceKeypoint.new(0.2, rainbowColors[3]),
    ColorSequenceKeypoint.new(0.4, rainbowColors[5]),
    ColorSequenceKeypoint.new(0.6, rainbowColors[7]),
    ColorSequenceKeypoint.new(0.8, rainbowColors[2]),
    ColorSequenceKeypoint.new(1, rainbowColors[1])
})
borderGlow.BackgroundColor3 = Color3.new(1,1,1)
borderGlow.BackgroundTransparency = 0.9

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ 麟 麟 七 · 验 证 ⚡"
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0.5

local subLabel = Instance.new("TextLabel", mainFrame)
subLabel.Size = UDim2.new(1, 0, 0, 20)
subLabel.Position = UDim2.new(0, 0, 0, 50)
subLabel.BackgroundTransparency = 1
subLabel.Text = ">>> ACCESS VERIFICATION <<<"
subLabel.TextSize = 11
subLabel.Font = Enum.Font.Code
subLabel.TextColor3 = Color3.fromRGB(0, 255, 200)

local inputBg = Instance.new("Frame", mainFrame)
inputBg.Size = UDim2.new(1, -40, 0, 40)
inputBg.Position = UDim2.new(0, 20, 0, 80)
inputBg.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
inputBg.BorderSizePixel = 0
Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 6)
local inputBorder = Instance.new("Frame", inputBg)
inputBorder.Size = UDim2.new(1, 2, 1, 2)
inputBorder.Position = UDim2.new(0, -1, 0, -1)
inputBorder.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
inputBorder.BackgroundTransparency = 0.6
inputBorder.BorderSizePixel = 0
Instance.new("UICorner", inputBorder).CornerRadius = UDim.new(0, 6)

local inputBox = Instance.new("TextBox", inputBg)
inputBox.Size = UDim2.new(1, -10, 1, -10)
inputBox.Position = UDim2.new(0, 5, 0, 5)
inputBox.BackgroundTransparency = 1
inputBox.PlaceholderText = "🔑 输入卡密..."
inputBox.Text = ""
inputBox.TextColor3 = Color3.new(0, 1, 1)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Code
inputBox.ClearTextOnFocus = true

local hintLabel = Instance.new("TextLabel", mainFrame)
hintLabel.Size = UDim2.new(1, -40, 0, 20)
hintLabel.Position = UDim2.new(0, 20, 0, 125)
hintLabel.BackgroundTransparency = 1
hintLabel.Text = ""
hintLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
hintLabel.TextSize = 12
hintLabel.Font = Enum.Font.Gotham

local verifyBtn = Instance.new("TextButton", mainFrame)
verifyBtn.Size = UDim2.new(1, -40, 0, 45)
verifyBtn.Position = UDim2.new(0, 20, 0, 155)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyBtn.Text = "验  证"
verifyBtn.TextColor3 = Color3.new(1, 1, 1)
verifyBtn.TextSize = 20
verifyBtn.Font = Enum.Font.GothamBlack
verifyBtn.BorderSizePixel = 0
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)
local btnGrad = Instance.new("UIGradient", verifyBtn)
btnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
})

local btnTween
verifyBtn.MouseButton1Down:Connect(function()
    btnTween = TweenService:Create(verifyBtn, TweenInfo.new(0.1), {Size = UDim2.new(1, -30, 0, 40)})
    btnTween:Play()
end)
verifyBtn.MouseButton1Up:Connect(function()
    if btnTween then btnTween:Cancel() end
    TweenService:Create(verifyBtn, TweenInfo.new(0.2), {Size = UDim2.new(1, -40, 0, 45)}):Play()
end)

spawn(function()
    while not verified do
        local col = rainbowColors[colorIndex]
        titleLabel.TextColor3 = col
        borderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rainbowColors[colorIndex]),
            ColorSequenceKeypoint.new(0.5, rainbowColors[(colorIndex+3)%8+1]),
            ColorSequenceKeypoint.new(1, rainbowColors[colorIndex])
        })
        inputBorder.BackgroundColor3 = col
        btnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, col),
            ColorSequenceKeypoint.new(1, rainbowColors[(colorIndex+4)%8+1])
        })
        colorIndex = (colorIndex % 8) + 1
        task.wait(0.3)
    end
end)

local function verify()
    if inputBox.Text == key then
        verifyBtn.Text = "✅ 验证通过"
        verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.5)
        verified = true
        keyGui:Destroy()
    else
        hintLabel.Text = "❌ 卡密错误，请重试"
        verifyBtn.Text = "⛔ 拒绝访问"
        verifyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        TweenService:Create(mainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = UDim2.new(0.5, -155, 0.5, -110)}):Play()
        task.wait(0.05)
        TweenService:Create(mainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = UDim2.new(0.5, -165, 0.5, -110)}):Play()
        task.wait(0.05)
        TweenService:Create(mainFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -160, 0.5, -110)}):Play()
        task.wait(0.5)
        verifyBtn.Text = "验  证"
        verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        hintLabel.Text = ""
        inputBox.Text = ""
    end
end

verifyBtn.MouseButton1Click:Connect(verify)
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then verify() end
end)

repeat task.wait() until verified

-- ==================== UI选择界面 ====================
local selectGui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
local sf = Instance.new("Frame", selectGui)
sf.Size = UDim2.new(0, 300, 0, 180)
sf.Position = UDim2.new(0.5, -150, 0.5, -90)
sf.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
sf.BackgroundTransparency = 0.3
sf.BorderSizePixel = 0
Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 12)

local stitle = Instance.new("TextLabel", sf)
stitle.Size = UDim2.new(1, 0, 0, 35)
stitle.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
stitle.Text = "选 择 UI 版 本"
stitle.TextColor3 = Color3.new(1, 1, 1)
stitle.TextSize = 18
stitle.Font = Enum.Font.GothamBold
Instance.new("UICorner", stitle).CornerRadius = UDim.new(0, 8)

local btn1 = Instance.new("TextButton", sf)
btn1.Size = UDim2.new(1, -40, 0, 42)
btn1.Position = UDim2.new(0, 20, 0, 55)
btn1.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
btn1.Text = "炫 酷 版 ( 横 版 悬 浮 )"
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.TextSize = 16
btn1.Font = Enum.Font.GothamBold
btn1.BorderSizePixel = 0
Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 8)

local btn2 = Instance.new("TextButton", sf)
btn2.Size = UDim2.new(1, -40, 0, 42)
btn2.Position = UDim2.new(0, 20, 0, 110)
btn2.BackgroundColor3 = Color3.fromRGB(80, 130, 220)
btn2.Text = "完 整 版 ( WindUI )"
btn2.TextColor3 = Color3.new(1, 1, 1)
btn2.TextSize = 16
btn2.Font = Enum.Font.GothamBold
btn2.BorderSizePixel = 0
Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 8)

local function choseCool()
    selectGui:Destroy()
    loadCoolUI()
end

local function choseWind()
    selectGui:Destroy()
    loadWindUI()
end

btn1.MouseButton1Click:Connect(choseCool)
btn2.MouseButton1Click:Connect(choseWind)

-- ==================== 炫酷横版悬浮UI（修复彩虹版） ====================
function loadCoolUI()
    local gui = Instance.new("ScreenGui", p.PlayerGui)
    gui.IgnoreGuiInset = true

    -- 功能变量
    local esp = false
    local espColor = Color3.new(1, 1, 1)
    local highlights = {}
    local colorNames = {"白色","红色","绿色","蓝色","黄色","紫色","青色","粉色","橙色"}
    local colorIndex2 = 1
    local function refreshESP()
        for _, h in ipairs(highlights) do if h then h:Destroy() end end
        highlights = {}
        if not esp then return end
        for _, pl in ipairs(game.Players:GetPlayers()) do
            if pl ~= p and pl.Character then
                local h = Instance.new("Highlight")
                h.FillTransparency = 1
                h.OutlineColor = espColor
                h.Parent = pl.Character
                table.insert(highlights, h)
            end
        end
    end

    local noClip = false
    local hbConn
    local sp = 16
    local function applySpeed(s)
        local c = p.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = s end
    end
    local function L(u) pcall(function() loadstring(game:HttpGet(u))() end) end

    local ext = {
        {"IY指令","https://rawscripts.net/raw/Universal-Script-IY-mobile-136050"},
        {"无敌少侠","https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%97%A0%E6%95%8C%E5%B0%91%E4%BE%A0%E9%A3%9E%E8%A1%8Cr6.txt"},
        {"隐身1","https://pastebin.com/raw/3Rnd9rHf"},
        {"隐身2","https://pastebin.com/raw/vP6CrQJj"},
        {"防甩飞","https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"},
        {"甩飞所有人","https://pastebin.com/raw/zqyDSUWX"},
        {"管理员权限","https://pastebin.com/raw/sZpgTVas"},
        {"玩家进入提示","https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"},
        {"死亡笔记","https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"},
        {"铁拳","https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"},
    }
    local sr = {
        {"皮脚本",function() getgenv().XiaoPi="皮脚本QQ群1002100032" L("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua") end},
        {"剑客V7",function() L("https://raw.githubusercontent.com/Zer0neK/Hello/refs/heads/main/SG-V7") end},
        {"落叶中心",function() getgenv().LS="落叶中心" L("https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt") end},
        {"秋脚本",function() L("https://pastebin.com/raw/8f2LcqqP") L("https://raw.githubusercontent.com/WS857960/-/main/%E7%A7%8B%E8%87%AA%E5%88%B6%E8%84%9A%E6%9C%AC.txt") end},
        {"挽脚本",function() L("https://raw.githubusercontent.com/mtaskhh/script/refs/heads/main/Protected_9892402027124653.lua") end},
        {"黑白脚本",function() L("https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器") end},
        {"叶脚本",function() L("https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/ROBLOX-CNVIP-XIAOYE.lua") end},
        {"羽脚本",function() L("https://raw.githubusercontent.com/JY6812/-/refs/heads/main/%E7%BE%BD%E8%84%9A%E6%9C%ACv2.lua") end},
        {"新乌托邦",function() L("https://pastefy.app/M1Ns2Ggo/raw") end},
        {"忍脚本",function() L("https://raw.githubusercontent.com/renlua/shallow/main/Script_Hub.lua") end},
        {"情云脚本",function() L("https://raw.githubusercontent.com/ChinaQY/-/main/%E6%83%85%E4%BA%91") end},
        {"Apt脚本",function() L("https://raw.githubusercontent.com/nainshu/no/main/APT.lua") end},
        {"禁漫中心",function() getgenv().LS="禁漫中心" L("https://raw.githubusercontent.com/dingding123hhh/anlushanjinchangantangwanle/main/jmghjkknsbdbskkakwbebnfshdhhcyvtbrvrshwbshhshshsgsvsb.lua") end},
        {"灰云脚本",function() _G.Clouduilib="白灰脚作者小云，加载出十几秒" L("https://raw.githubusercontent.com/CloudX-ScriptsWane/White-ash-script/main/%E7%99%BD%E7%81%B0%E8%84%9A%E6%9C%ACbeta.lua") end},
        {"导管中心",function() loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\117\115\101\114\97\110\101\119\114\102\102\47\114\111\98\108\111\120\45\47\109\97\105\110\47\37\69\54\37\57\68\37\65\49\37\69\54\37\65\67\37\66\69\37\69\53\37\56\68\37\56\70\37\69\56\37\65\69\37\65\69\34\41\41\40\41\10")() end},
        {"北约脚本",function() L("https://raw.githubusercontent.com/USA868/114514-55-646-114514-88-61518-618-840-1018-634-10-4949-3457578401-615/main/Protected-36.lua") end},
        {"云脚本",function() L("https://raw.githubusercontent.com/XiaoYunCN/UWU/main/XiaoYun_currentedition_beta.lua") end},
        {"忍脚本2",function() L("https://pastebin.com/raw/1k7RAfQJ") end},
        {"bs轻量版",function() L("https://raw.githubusercontent.com/vbxfhcd/BS/refs/heads/main/BS-loves_you.txt") end},
        {"tubers93",function() L("https://raw.githubusercontent.com/Wbw1470619303-ctrl/w-/refs/heads/main/%E5%8F%AF%E4%BB%A5%E7%94%A8%E7%9A%84%E4%B8%BB%E8%84%9A%E6%9C%AC%E6%B7%B7%E6%B7%86%E5%90%8E%E7%9A%84.lua") end},
        {"北极脚本",function() L("https://pastebin.com/raw/KwARpDxV") end},
        {"syn脚本",function() L("https://pastebin.com/raw/tWGxhNq0") end},
        {"SA脚本",function() L("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua") end},
        {"月抛脚本",function() L("https://pastefy.app/2uwPck6l/raw") end},
    }
    local train = nil

    -- 主栏
    local mainBar = Instance.new("Frame", gui)
    mainBar.Size = UDim2.new(0, 620, 0, 48)
    mainBar.Position = UDim2.new(0.5, -310, 0.02, 0)
    mainBar.BackgroundColor3 = Color3.fromRGB(8, 8, 22)
    mainBar.BackgroundTransparency = 0.15
    mainBar.BorderSizePixel = 0
    mainBar.ClipsDescendants = true
    Instance.new("UICorner", mainBar).CornerRadius = UDim.new(0, 14)

    local barGlow = Instance.new("Frame", mainBar)
    barGlow.Size = UDim2.new(1, 4, 1, 4)
    barGlow.Position = UDim2.new(0, -2, 0, -2)
    barGlow.BackgroundColor3 = Color3.new(1,1,1)
    barGlow.BackgroundTransparency = 0.85
    barGlow.BorderSizePixel = 0
    Instance.new("UICorner", barGlow).CornerRadius = UDim.new(0, 14)
    local barGrad = Instance.new("UIGradient", barGlow)

    local dragging = false
    local dragStartPos, barStartPos
    local currentPanel = nil
    local function updatePanelPos()
        if currentPanel then
            currentPanel.Position = UDim2.new(mainBar.Position.X.Scale, mainBar.Position.X.Offset, mainBar.Position.Y.Scale, mainBar.Position.Y.Offset + 52)
        end
    end
    mainBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = input.Position
            barStartPos = mainBar.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            mainBar.Position = UDim2.new(
                barStartPos.X.Scale, barStartPos.X.Offset + delta.X,
                barStartPos.Y.Scale, barStartPos.Y.Offset + delta.Y
            )
            updatePanelPos()
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local title = Instance.new("TextLabel", mainBar)
    title.Size = UDim2.new(0, 130, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡麟麟七"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 18

    local categories = {
        {name = "👁 透视", funcs = {
            {"透视开关", "toggle", function(v) esp = v; refreshESP() end},
            {"切换颜色", "button", function()
                colorIndex2 = colorIndex2 % #colorNames + 1
                local cm = {["白色"]=Color3.new(1,1,1),["红色"]=Color3.new(1,0,0),["绿色"]=Color3.new(0,1,0),["蓝色"]=Color3.new(0,0.6,1),["黄色"]=Color3.new(1,1,0),["紫色"]=Color3.new(0.7,0,1),["青色"]=Color3.new(0,1,1),["粉色"]=Color3.new(1,0.4,0.7),["橙色"]=Color3.new(1,0.65,0)}
                espColor = cm[colorNames[colorIndex2]]
                refreshESP()
            end}
        }},
        {name = "🚀 穿墙", funcs = {
            {"穿墙开关", "toggle", function(v)
                noClip = v
                if v then
                    if not hbConn then hbConn = RS.Heartbeat:Connect(function()
                        local c = p.Character
                        if c then for _, o in ipairs(c:GetDescendants()) do if o:IsA("BasePart") then o.CanCollide = false end end end
                    end) end
                else
                    if hbConn then hbConn:Disconnect(); hbConn = nil end
                    local c = p.Character
                    if c then for _, o in ipairs(c:GetDescendants()) do if o:IsA("BasePart") then o.CanCollide = true end end end
                end
            end}
        }},
        {name = "🏃 速度", funcs = {
            {"+5", "button", function() sp = math.min(sp+5,500); applySpeed(sp) end},
            {"-5", "button", function() sp = math.max(sp-5,1); applySpeed(sp) end}
        }},
        {name = "⚔ 扩展", funcs = ext},
        {name = "📜 脚本", funcs = sr},
        {name = "🥷 忍者", funcs = {
            {"无限金币", "button", function()
                local r = game:GetService("ReplicatedStorage"):WaitForChild("rEvents")
                r:WaitForChild("zenMasterEvent"):FireServer("convertGems", -9e999)
            end},
            {"宠物商店", "button", function()
                local pt = {"Dark Vampy","Green Vampy","Purple Angel","Silver Dog","Purple Birdie","Blue Hedgehog"}
                for _, v in ipairs(pt) do
                    pcall(function()
                        local r = game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopRemote")
                        local f = game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopFolder")
                        if r and f then local pet=f:FindFirstChild(v); if pet then r:InvokeServer(pet) end end
                    end)
                    task.wait(0.3)
                end
            end},
            {"自动训练", "toggle", function(v)
                if v then
                    local function equip()
                        local c = p.Character
                        if c and c:FindFirstChild("Humanoid") then
                            local t = nil
                            local bp = p:FindFirstChild("Backpack")
                            if bp then for _, o in ipairs(bp:GetChildren()) do if o:IsA("Tool") then t=o; break end end end
                            if not t then for _, o in ipairs(c:GetChildren()) do if o:IsA("Tool") then t=o; break end end end
        
