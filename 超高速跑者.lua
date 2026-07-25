-- 加载 WindUI 库（带错误处理）
local WindUI
local success, err = pcall(function()
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("WindUI加载失败: " .. tostring(err))
    warn("尝试使用备用加载方式...")
    
    success, err = pcall(function()
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()
    end)
end

if not WindUI then
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Parent = player:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = gui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "麟麟七脚本加载失败\n请检查网络连接或稍后再试"
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    return
end

-- 用于记录用户是否点击了"继续"按钮
local Confirmed = false

-- 创建欢迎弹窗
WindUI:Popup({
    Title = "🦊 麟麟七脚本",
    Icon = "rocket",
    Content = "通过 StepTaken 事件自动增加角色速度\n\n速度增量数值越大，单次增加越多\n发送间隔建议 0.05 ~ 0.1 秒",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "开始使用",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                WindUI:Notification({
                    Title = "提示",
                    Content = "麟麟七脚本已启动！",
                    Duration = 3,
                    Type = "success",
                })
            end,
            Variant = "Primary",
        }
    }
})

-- 等待用户点击"继续"后再继续执行
repeat task.wait() until Confirmed

-- 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "🦊 麟麟七脚本",
    Icon = "rocket",
    Author = "DeepSeek AI",
    Folder = "LinLinQi",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() print("点击了用户按钮") end,
        Anonymous = false
    },
    SideBarWidth = 200,
    Background = "rbxassetid://8732036547",
    HasOutline = true,
})

-- 设置背景图片
Window:SetBackgroundImage("rbxassetid://8732036547")

-- ============ 让背景变透明的代码 ============
spawn(function()
    task.wait(1)
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    for _, screenGui in ipairs(playerGui:GetChildren()) do
        if screenGui:IsA("ScreenGui") then
            for _, descendant in ipairs(screenGui:GetDescendants()) do
                if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and descendant.Image == "rbxassetid://8732036547" then
                    descendant.ImageTransparency = 0.5
                end
            end
        end
    end
    
    for _, descendant in ipairs(playerGui:GetDescendants()) do
        if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and descendant.Image == "rbxassetid://8732036547" then
            descendant.ImageTransparency = 0.5
        end
    end
end)

-- ============ 修改UI字体颜色为灰色 ============
spawn(function()
    task.wait(0.5)
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local grayColor = Color3.fromRGB(128, 128, 128)
    
    for _, screenGui in ipairs(playerGui:GetChildren()) do
        if screenGui:IsA("ScreenGui") then
            for _, descendant in ipairs(screenGui:GetDescendants()) do
                if descendant:IsA("TextLabel") then
                    if not descendant.Text:find("错误") and not descendant.Text:find("失败") then
                        descendant.TextColor3 = grayColor
                    end
                end
                if descendant:IsA("TextButton") then
                    descendant.TextColor3 = grayColor
                end
                if descendant:IsA("TextBox") then
                    descendant.TextColor3 = grayColor
                end
            end
        end
    end
end)

-- 自定义"打开界面"按钮的样式
Window:EditOpenButton({
    Title = "打开麟麟七脚本",
    Icon = "rocket",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    Draggable = true,
})

-- ============= 控制面板标签页 =============
local MainTab = Window:Tab({
    Title = "控制面板",
    Icon = "gauge",
})

-- ============= 速度设置区域 =============
local SettingsSection = MainTab:Section({
    Title = "速度设置",
})

-- 速度增量输入框
local SpeedInput = SettingsSection:Input({
    Title = "速度增量",
    Desc = "单次增加的速度值，数值越大效果越强",
    Value = "10000000",
    Type = "Input",
})

-- 发送间隔输入框
local IntervalInput = SettingsSection:Input({
    Title = "发送间隔 (秒)",
    Desc = "建议 0.05 ~ 0.1 秒，过快可能被限制",
    Value = "0.05",
    Type = "Input",
})

-- ============= 运行状态区域 =============
local StatusSection = MainTab:Section({
    Title = "运行状态",
})

-- 状态标签
local StatusLabel = StatusSection:Label({
    Title = "状态: 已停止",
    Color = Color3.fromRGB(200, 200, 200),
})

-- 计数标签
local CountLabel = StatusSection:Label({
    Title = "发送次数: 0",
    Color = Color3.fromRGB(150, 200, 255),
})

-- ============= 控制区域 =============
local ControlSection = MainTab:Section({
    Title = "控制",
})

-- 核心变量
local isRunning = false
local loopThread = nil
local sendCount = 0

-- 发送事件函数
local function fireStepTaken(value)
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.StepTaken:FireServer(value, false)
    end)
    return success, err
end

-- 更新状态
local function updateStatus(text, color)
    StatusLabel:SetText("状态: " .. text)
    if color then StatusLabel:SetColor(color) end
end

local function updateCount()
    CountLabel:SetText("发送次数: " .. sendCount)
end

-- 启动循环
local function startLoop()
    if isRunning then
        WindUI:Notification({
            Title = "提示",
            Content = "加速已在运行中",
            Duration = 2,
            Type = "info",
        })
        return
    end

    local num = tonumber(SpeedInput:GetValue())
    if not num or num <= 0 then
        WindUI:Popup({
            Title = "错误",
            Content = "请输入有效的速度增量",
            Icon = "x-circle",
            Buttons = {{Title = "确定", Variant = "Primary"}}
        })
        return
    end

    local interval = tonumber(IntervalInput:GetValue())
    if not interval or interval <= 0 then
        WindUI:Popup({
            Title = "错误",
            Content = "请输入有效的间隔时间",
            Icon = "x-circle",
            Buttons = {{Title = "确定", Variant = "Primary"}}
        })
        return
    end

    isRunning = true
    sendCount = 0
    updateCount()
    updateStatus("运行中...", Color3.fromRGB(0, 255, 100))
    
    StartButton:SetTitle("⏳ 运行中")
    StopButton:SetTitle("⏹ 停止")
    
    WindUI:Notification({
        Title = "加速已启动",
        Content = string.format("速度增量: %d, 间隔: %.2fs", num, interval),
        Duration = 2,
        Type = "success",
    })

    loopThread = coroutine.create(function()
        while isRunning do
            local success, err = fireStepTaken(num)
            if success then
                sendCount = sendCount + 1
                updateCount()
            else
                updateStatus("错误: " .. err, Color3.fromRGB(255, 80, 80))
                isRunning = false
                StartButton:SetTitle("▶ 开始")
                StopButton:SetTitle("⏹ 停止")
                WindUI:Popup({
                    Title = "错误",
                    Content = "发送失败: " .. err,
                    Icon = "x-circle",
                    Buttons = {{Title = "确定", Variant = "Primary"}}
                })
                break
            end
            task.wait(interval)
        end
        if not isRunning then
            updateStatus("已停止", Color3.fromRGB(200, 200, 200))
            StartButton:SetTitle("▶ 开始")
            StopButton:SetTitle("⏹ 停止")
        end
    end)
    coroutine.resume(loopThread)
end

-- 停止循环
local function stopLoop()
    if isRunning then
        isRunning = false
        updateStatus("已暂停", Color3.fromRGB(255, 200, 0))
        StartButton:SetTitle("▶ 继续")
        WindUI:Notification({
            Title = "加速已暂停",
            Content = string.format("共发送 %d 次", sendCount),
            Duration = 2,
            Type = "info",
        })
    else
        WindUI:Notification({
            Title = "提示",
            Content = "加速未在运行",
            Duration = 2,
            Type = "info",
        })
    end
end

-- 开始按钮
local StartButton = ControlSection:Button({
    Title = "▶ 开始",
    Description = "开始循环发送速度增量",
    Callback = startLoop,
})

-- 停止按钮
local StopButton = ControlSection:Button({
    Title = "⏹ 停止",
    Description = "停止循环发送",
    Callback = stopLoop,
    Variant = "Secondary",
})

-- ============= 提示标签页 =============
local InfoTab = Window:Tab({
    Title = "提示",
    Icon = "info",
})

local InfoSection = InfoTab:Section({
    Title = "使用说明",
})

InfoSection:Label({
    Title = "💡 点击右上角 ⚡ 按钮可随时隐藏/显示窗口",
    Color = Color3.fromRGB(150, 150, 180),
})

InfoSection:Label({
    Title = "💡 拖拽标题栏可移动窗口位置",
    Color = Color3.fromRGB(150, 150, 180),
})

InfoSection:Label({
    Title = "💡 速度增量越大，单次增加的速度越多",
    Color = Color3.fromRGB(150, 150, 180),
})

InfoSection:Label({
    Title = "💡 发送间隔建议 0.05 ~ 0.1 秒",
    Color = Color3.fromRGB(150, 150, 180),
})

InfoSection:Label({
    Title = "🦊 麟麟七脚本 - 助你成为最强跑者！",
    Color = Color3.fromRGB(255, 200, 100),
})

print("✅ 麟麟七脚本 已加载")
print("本脚本由 DeepSeek AI 生成")
