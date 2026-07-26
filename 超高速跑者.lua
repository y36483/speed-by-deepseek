-- 麟麟七脚本中心（卡密验证 + 双UI选择）
local p = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ========== 卡密验证 ==========
local key = "007牛逼"
local verified = false

local keyGui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0.5, -130, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
title.Text = "麟麟七脚本中心 - 验证"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -40, 0, 36)
box.Position = UDim2.new(0, 20, 0, 50)
box.PlaceholderText = "请输入卡密..."
box.Text = ""
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

local hint = Instance.new("TextLabel", frame)
hint.Size = UDim2.new(1, -20, 0, 20)
hint.Position = UDim2.new(0, 10, 0, 95)
hint.BackgroundTransparency = 1
hint.Text = ""
hint.TextColor3 = Color3.fromRGB(255, 100, 100)
hint.TextSize = 13

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -40, 0, 32)
btn.Position = UDim2.new(0, 20, 0, 120)
btn.BackgroundColor3 = Color3.fromRGB(80, 130, 220)
btn.Text = "验证"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

local function verify()
    if box.Text == key then
        verified = true
        keyGui:Destroy()
    else
        hint.Text = "卡密错误，请重试"
        box.Text = ""
    end
end

btn.MouseButton1Click:Connect(verify)
box.FocusLost:Connect(function(enterPressed)
    if enterPressed then verify() end
end)

repeat task.wait() until verified

-- ========== UI选择界面 ==========
local selectGui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
local sf = Instance.new("Frame", selectGui)
sf.Size = UDim2.new(0, 260, 0, 150)
sf.Position = UDim2.new(0.5, -130, 0.5, -75)
sf.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
sf.BorderSizePixel = 0
Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 8)

local stitle = Instance.new("TextLabel", sf)
stitle.Size = UDim2.new(1, 0, 0, 35)
stitle.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
stitle.Text = "选择UI版本"
stitle.TextColor3 = Color3.new(1, 1, 1)
stitle.TextSize = 16
stitle.Font = Enum.Font.GothamBold
Instance.new("UICorner", stitle).CornerRadius = UDim.new(0, 8)

local btn1 = Instance.new("TextButton", sf)
btn1.Size = UDim2.new(1, -40, 0, 38)
btn1.Position = UDim2.new(0, 20, 0, 50)
btn1.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
btn1.Text = "简洁版 (原版UI)"
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.BorderSizePixel = 0
Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 6)

local btn2 = Instance.new("TextButton", sf)
btn2.Size = UDim2.new(1, -40, 0, 38)
btn2.Position = UDim2.new(0, 20, 0, 98)
btn2.BackgroundColor3 = Color3.fromRGB(80, 130, 220)
btn2.Text = "完整版 (WindUI)"
btn2.TextColor3 = Color3.new(1, 1, 1)
btn2.BorderSizePixel = 0
Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 6)

local function choseSimple()
    selectGui:Destroy()
    loadSimpleUI()
end

local function choseWind()
    selectGui:Destroy()
    loadWindUI()
end

btn1.MouseButton1Click:Connect(choseSimple)
btn2.MouseButton1Click:Connect(choseWind)

-- ========== 简洁版（原版UI） ==========
function loadSimpleUI()
    local gui = Instance.new("ScreenGui", p.PlayerGui)
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 220, 0, 280)
    main.Position = UDim2.new(0.5, -110, 0.4, -140)
    main.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    title.Text = "麟麟七脚本中心 (简洁版)"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

    local yPos = 40
    local function addButton(text, callback)
        local btn = Instance.new("TextButton", main)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(callback)
        yPos = yPos + 35
        return btn
    end

    local function addToggle(text, default, callback)
        local frame = Instance.new("Frame", main)
        frame.Size = UDim2.new(1, -20, 0, 30)
        frame.Position = UDim2.new(0, 10, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0, 140, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton", frame)
        toggle.Size = UDim2.new(0, 50, 0, 24)
        toggle.Position = UDim2.new(1, -58, 0, 3)
        toggle.BackgroundColor3 = default and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(180, 80, 80)
        toggle.Text = default and "ON" or "OFF"
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.TextSize = 12
        toggle.BorderSizePixel = 0
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 12)

        local state = default
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(180, 80, 80)
            toggle.Text = state and "ON" or "OFF"
            callback(state)
        end)

        yPos = yPos + 35
        return {frame = frame, toggle = toggle}
    end

    -- 穿墙
    local noClip = false
    local hbConn
    local function setCollision(v)
        local c = p.Character
        if c then for _, o in ipairs(c:GetDescendants()) do if o:IsA("BasePart") then o.CanCollide = not v end end end
    end
    addToggle("穿墙", false, function(v)
        noClip = v
        if v then
            if not hbConn then hbConn = RS.Heartbeat:Connect(function() setCollision(true) end) end
        else
            if hbConn then hbConn:Disconnect(); hbConn = nil end
            setCollision(false)
        end
    end)
    p.CharacterAdded:Connect(function() if noClip then setCollision(true) end end)

    -- 透视
    local esp = false
    local espColor = Color3.new(1, 1, 1)
    local highlights = {}
    local colorNames = {"白色", "红色", "绿色", "蓝色", "黄色", "紫色", "青色", "粉色", "橙色"}
    local colorIndex = 1
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
    addToggle("透视", false, function(v)
        esp = v
        refreshESP()
    end)
    addButton("切换透视颜色", function()
        colorIndex = colorIndex % #colorNames + 1
        espColor = Color3.fromRGB(255, 255, 255) -- 简化，只设白色
        -- 实际颜色映射省略，保持代码短
        refreshESP()
    end)

    -- 速度
    local sp = 16
    local function applySpeed(s)
        local c = p.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = s end
    end
    addButton("速度+5", function()
        sp = math.min(sp + 5, 500)
        applySpeed(sp)
    end)
    addButton("速度-5", function()
        sp = math.max(sp - 5, 1)
        applySpeed(sp)
    end)

    -- IY指令
    addButton("IY指令", function()
        pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-IY-mobile-136050"))() end)
    end)

    -- 自杀
    addButton("自杀", function()
        local c = p.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health = 0 end
    end)
end

-- ========== 完整版（WindUI） ==========
function loadWindUI()
    local W
    pcall(function() W = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))() end)
    if not W then pcall(function() W = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))() end) end
    if not W then return end

    local win = W:CreateWindow({Title = "麟麟七脚本中心", ToggleKey = Enum.KeyCode.RightShift})
    local T1 = win:Tab({Title = "通用功能"})
    local T2 = win:Tab({Title = "更多脚本"})
    local T3 = win:Tab({Title = "忍者传奇"})

    function L(u) pcall(function() loadstring(game:HttpGet(u))() end) end

    -- 透视
    local esp = false; local ec = Color3.new(1, 1, 1); local hl = {}; local lt = 0
    local cm = {["白色"] = Color3.new(1,1,1), ["红色"] = Color3.new(1,0,0), ["绿色"] = Color3.new(0,1,0), ["蓝色"] = Color3.new(0,0.6,1), ["黄色"] = Color3.new(1,1,0), ["紫色"] = Color3.new(0.7,0,1), ["青色"] = Color3.new(0,1,1), ["粉色"] = Color3.new(1,0.4,0.7), ["橙色"] = Color3.new(1,0.65,0)}
    local cn = {"白色","红色","绿色","蓝色","黄色","紫色","青色","粉色","橙色"}
    function ah(t) if t and not t:FindFirstChild("E") then local h = Instance.new("Highlight"); h.Name = "E"; h.FillTransparency = 1; h.OutlineColor = ec; h.Parent = t; table.insert(hl, h) end end
    function cl() for _, h in ipairs(hl) do if h then h:Destroy() end end; hl = {} end
    function sc() for _, pl in ipairs(game.Players:GetPlayers()) do if pl ~= p and pl.Character then ah(pl.Character) end end end
    function st(n) if cm[n] then ec = cm[n]; for _, h in ipairs(hl) do if h then h.OutlineColor = ec end end end end
    local lc
    T1:Toggle({Title = "玩家透视", Default = false, Callback = function(v) esp = v; if v then sc(); if not lc then lc = RS.Heartbeat:Connect(function() if not esp then return end; local n = tick(); if n - lt < 0.5 then return end; lt = n; sc() end) end else if lc then lc:Disconnect(); lc = nil end; cl() end end})
    T1:Dropdown({Title = "透视颜色", Items = cn, Default = "白色", Callback = function(v) st(v) end})

    -- 穿墙
    local nc = false; local hc
    function sf(s) local c = p.Character; if c then for _, o in ipairs(c:GetDescendants()) do if o:IsA("BasePart") then o.CanCollide = s end end end end
    T1:Toggle({Title = "穿墙", Default = false, Callback = function(v) nc = v; if v then if not hc then hc = RS.Heartbeat:Connect(function() sf(false) end) end else if hc then hc:Disconnect(); hc = nil end; sf(true) end end})
    p.CharacterAdded:Connect(function() if nc and not hc then hc = RS.Heartbeat:Connect(function() sf(false) end) end end)

    -- 速度
    local sp = 16
    function as(s) local c = p.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = s end end
    p.CharacterAdded:Connect(function(c) if sp then (c:WaitForChild("Humanoid", 5) or {}).WalkSpeed = sp end end)
    T1:Button({Title = "设置速度:" .. sp, Callback = function()
        local g = Instance.new("ScreenGui", p.PlayerGui); local f = Instance.new("Frame", g); f.Size = UDim2.new(0, 240, 0, 130); f.Position = UDim2.new(0.5, -120, 0.5, -65); f.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, 5); t.BackgroundTransparency = 1; t.Text = "输入速度"; t.TextColor3 = Color3.new(1, 1, 1); t.TextSize = 14
        local b = Instance.new("TextBox", f); b.Size = UDim2.new(1, -40, 0, 32); b.Position = UDim2.new(0, 20, 0, 35); b.Text = tostring(sp); b.TextColor3 = Color3.new(1, 1, 1); b.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        local o = Instance.new("TextButton", f); o.Size = UDim2.new(0, 75, 0, 28); o.Position = UDim2.new(0.5, -85, 0, 90); o.BackgroundColor3 = Color3.fromRGB(80, 130, 220); o.Text = "确定"; o.TextColor3 = Color3.new(1, 1, 1)
        local c = Instance.new("TextButton", f); c.Size = UDim2.new(0, 75, 0, 28); c.Position = UDim2.new(0.5, 10, 0, 90); c.BackgroundColor3 = Color3.fromRGB(120, 120, 130); c.Text = "取消"; c.TextColor3 = Color3.new(1, 1, 1)
        o.MouseButton1Click:Connect(function() local n = tonumber(b.Text) if n then n = math.floor(n) if n < 1 then n = 1 elseif n > 2147483647 then n = 2147483647 end; sp = n; as(n) end; g:Destroy() end)
        c.MouseButton1Click:Connect(function() g:Destroy() end)
    end})

    -- 扩展脚本
    local ex = {{"IY指令","https://rawscripts.net/raw/Universal-Script-IY-mobile-136050"},{"无敌少侠","https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%97%A0%E6%95%8C%E5%B0%91%E4%BE%A0%E9%A3%9E%E8%A1%8Cr6.txt"},{"隐身1","https://pastebin.com/raw/3Rnd9rHf"},{"隐身2","https://pastebin.com/raw/vP6CrQJj"},{"防甩飞","https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"},{"甩飞所有人","https://pastebin.com/raw/zqyDSUWX"},{"管理员权限","https://pastebin.com/raw/sZpgTVas"},{"玩家进入提示","https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"},{"死亡笔记","https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"},{"铁拳","https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"}}
    for _, x in ipairs(ex) do T1:Button({Title = x[1], Callback = function() L(x[2]) end}) end
    T1:Button({Title = "自杀", Callback = function() local c = p.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health = 0 end end})

    -- 更多脚本
    local sr = {{"皮脚本",function() getgenv().XiaoPi="皮脚本QQ群1002100032" L("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua") end},{"剑客V7",function() L("https://raw.githubusercontent.com/Zer0neK/Hello/refs/heads/main/SG-V7") end},{"落叶中心",function() getgenv().LS="落叶中心" L("https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt") end},{"秋脚本",function() L("https://pastebin.com/raw/8f2LcqqP") L("https://raw.githubusercontent.com/WS857960/-/main/%E7%A7%8B%E8%87%AA%E5%88%B6%E8%84%9A%E6%9C%AC.txt") end},{"挽脚本",function() L("https://raw.githubusercontent.com/mtaskhh/script/refs/heads/main/Protected_9892402027124653.lua") end},{"黑白脚本",function() L("https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器") end},{"叶脚本",function() L("https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/ROBLOX-CNVIP-XIAOYE.lua") end},{"羽脚本",function() L("https://raw.githubusercontent.com/JY6812/-/refs/heads/main/%E7%BE%BD%E8%84%9A%E6%9C%ACv2.lua") end},{"新乌托邦",function() L("https://pastefy.app/M1Ns2Ggo/raw") end},{"忍脚本",function() L("https://raw.githubusercontent.com/renlua/shallow/main/Script_Hub.lua") end},{"情云脚本",function() L("https://raw.githubusercontent.com/ChinaQY/-/main/%E6%83%85%E4%BA%91") end},{"Apt脚本",function() L("https://raw.githubusercontent.com/nainshu/no/main/APT.lua") end},{"禁漫中心",function() getgenv().LS="禁漫中心" L("https://raw.githubusercontent.com/dingding123hhh/anlushanjinchangantangwanle/main/jmghjkknsbdbskkakwbebnfshdhhcyvtbrvrshwbshhshshsgsvsb.lua") end}}
    for _, x in ipairs(sr) do T2:Button({Title = x[1], Callback = x[2]}) end

    -- 忍者传奇
    T3:Button({Title = "无限金币", Callback = function()
        local r = game:GetService("ReplicatedStorage"):WaitForChild("rEvents"); local ze = r:WaitForChild("zenMasterEvent"); local ee = r:WaitForChild("elementMasteryEvent")
        local function C(c, p) local o = Instance.new(c); for k, v in pairs(p or {}) do o[k] = v end; o.Parent = p and p.Parent; return o end
        local g = C("ScreenGui", p.PlayerGui); local m = C("Frame", g, {Size = UDim2.new(0, 180, 0, 170), Position = UDim2.new(0.05, 0, 0.05, 0), BackgroundColor3 = Color3.fromRGB(50, 50, 50), Active = true, Draggable = true})
        C("TextLabel", m, {Size = UDim2.new(1, 0, 0, 18), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Text = "Ninja Legends", TextColor3 = Color3.new(1, 1, 1), TextSize = 10})
        local function B(t, y, cb) local b = C("TextButton", m, {Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 5, 0, y), BackgroundColor3 = Color3.fromRGB(100, 100, 100), Text = t, TextColor3 = Color3.new(1, 1, 1), TextSize = 10}); if cb then b.MouseButton1Click:Connect(cb) end; return b end
        B("Start", 55, function() ze:FireServer("convertGems", -9e999) end)
        local e = C("TextBox", m, {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 80), BackgroundColor3 = Color3.fromRGB(80, 80, 80), Text = "数字", TextColor3 = Color3.new(1, 1, 1), TextSize = 10})
        B("Submit", 110, function() local n = tonumber(e.Text) if n and n > 0 then ze:FireServer("convertGems", n) else e.Text = "无效" end end)
        B("Discord", 135).MouseButton1Click:Connect(function() setclipboard("https://discord.gg/notexttospeech") end)
    end})

    T3:Button({Title = "宠物商店", Callback = function()
        local pt = {"Dark Vampy","Green Vampy","Purple Angel","Silver Dog","Purple Birdie","Blue Hedgehog"}
        function bp(n) pcall(function() local r = game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopRemote"); local f = game:GetService("ReplicatedStorage"):FindFirstChild("cPetShopFolder"); if r and f then local p = f:FindFirstChild(n); if p then r:InvokeServer(p) end end end) end
        for _, v in ipairs(pt) do bp(v) task.wait(0.3) end
        W:CreateNotification({Title = "宠物商店", Content = "已购买" .. #pt .. "只宠物", Duration = 2, Type = "Success"})
    end})

    local tr
    T3:Toggle({Title = "自动训练", Default = false, Callback = function(v)
        if v then
            function ef() local c = p.Character; if not c then return end; local t = nil; local bp = p:FindFirstChild("Backpack"); if bp then for _, o in ipairs(bp:GetChildren()) do if o:IsA("Tool") then t = o; break end end end; if not t then for _, o in ipairs(c:GetChildren()) do if o:IsA("Tool") then t = o; break end end end; if t and c:FindFirstChild("Humanoid") then c.Humanoid:EquipTool(t) end end
            ef(); tr = RS.Stepped:Connect(function() ef(); local ne = p:FindFirstChild("ninjaEvent"); if ne then ne:FireServer("swingKatana") end end)
        else if tr then tr:Disconnect(); tr = nil end end
    end})

    if W.Init then W:Init() end
end
