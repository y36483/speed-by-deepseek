--[[
    脚本名称: 超高速跑者 (WindUI Edition)
    作者: DeepSeek AI
    描述: 通过循环调用 StepTaken 事件，自动增加角色速度。
    界面风格: Windows 11 Fluent Design（毛玻璃、圆角、柔和阴影）
]]

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===== 状态变量 =====
local uiVisible = true
local isRunning = false
local loopThread = nil
local sendCount = 0

-- ===== UI 引用 =====
local mainFrame = nil
local statusLabel = nil
local startBtn = nil
local pauseBtn = nil
local valueBox = nil
local intervalBox = nil
local countLabel = nil
local floatingBtn = nil
local titleLabel = nil
local settingPanel = nil

-- ===== 配置参数（默认尺寸） =====
local uiWidth = 360
local uiHeight = 300

-- ===== 核心功能 =====
local function fireStepTaken(value)
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.StepTaken:FireServer(value, false)
    end)
    return success, err
end

-- ===== 辅助：创建毛玻璃效果（如果支持） =====
local function applyGlassEffect(instance)
    local blur = Instance.new("UIBlurEffect")
    blur.Enabled = true
    blur.Size = 20
    blur.Parent = instance
    return blur
end

-- ===== 创建浮动按钮（可拖动） =====
local function createFloatingButton()
    if floatingBtn then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingButtonGui"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    floatingBtn = Instance.new("TextButton")
    floatingBtn.Name = "FloatingToggle"
    floatingBtn.Size = UDim2.new(0, 54, 0, 54)
    floatingBtn.Position = UDim2.new(1, -78, 0, 60)
    floatingBtn.AnchorPoint = Vector2.new(0, 0)
    floatingBtn.Text = "⚡"
    floatingBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
    floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    floatingBtn.BorderSizePixel = 0
    floatingBtn.Font = Enum.Font.GothamBold
    floatingBtn.TextSize = 26
    floatingBtn.Parent = screenGui

    -- 圆角 + 阴影
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = floatingBtn

    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(200, 200, 210)
    shadow.Thickness = 2
    shadow.Parent = floatingBtn

    local shadowBlur = Instance.new("UIShadow")
    shadowBlur.Blur = 12
    shadowBlur.Offset = Vector2.new(0, 4)
    shadowBlur.Transparency = 0.2
    shadowBlur.Parent = floatingBtn

    -- 悬停
    floatingBtn.MouseEnter:Connect(function()
        floatingBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    end)
    floatingBtn.MouseLeave:Connect(function()
        floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end)

    -- 拖动
    local dragging = false
    local dragStart = nil
    local startPos = nil

    floatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatingBtn.Position
        end
    end)

    floatingBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            floatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- 点击切换（拖动时不触发）
    local isDragged = false
    floatingBtn.InputBegan:Connect(function() isDragged = false end)
    floatingBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then isDragged = true end
    end)

    floatingBtn.MouseButton1Click:Connect(function()
        if isDragged then return end
        uiVisible = not uiVisible
        if mainFrame then mainFrame.Visible = uiVisible end
    end)
end

-- ===== 创建设置面板 =====
local function createSettingPanel()
    if settingPanel then return end

    settingPanel = Instance.new("Frame")
    settingPanel.Size = UDim2.new(0, 240, 0, 150)
    settingPanel.Position = UDim2.new(0.5, -120, 0.5, -75)
    settingPanel.AnchorPoint = Vector2.new(0, 0)
    settingPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    settingPanel.BackgroundTransparency = 0.15
    settingPanel.BorderSizePixel = 0
    settingPanel.Visible = false
    settingPanel.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = settingPanel

    local shadow = Instance.new("UIShadow")
    shadow.Blur = 16
    shadow.Offset = Vector2.new(0, 6)
    shadow.Transparency = 0.3
    shadow.Parent = settingPanel

    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 32)
    title.Text = "⚙ 调整尺寸"
    title.TextColor3 = Color3.fromRGB(30, 30, 30)
    title.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = settingPanel

    -- 宽度
    local wLabel = Instance.new("TextLabel")
    wLabel.Size = UDim2.new(0.3, 0, 0, 25)
    wLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
    wLabel.Text = "宽度:"
    wLabel.TextColor3 = Color3.fromRGB(60, 60, 70)
    wLabel.BackgroundTransparency = 1
    wLabel.Font = Enum.Font.Gotham
    wLabel.TextSize = 13
    wLabel.Parent = settingPanel

    local wBox = Instance.new("TextBox")
    wBox.Size = UDim2.new(0.4, 0, 0, 25)
    wBox.Position = UDim2.new(0.5, 0, 0.3, 0)
    wBox.Text = tostring(uiWidth)
    wBox.TextColor3 = Color3.fromRGB(30, 30, 30)
    wBox.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    wBox.BorderSizePixel = 1
    wBox.BorderColor3 = Color3.fromRGB(200, 200, 210)
    wBox.Font = Enum.Font.Gotham
    wBox.TextSize = 13
    wBox.Parent = settingPanel

    local wCorner = Instance.new("UICorner")
    wCorner.CornerRadius = UDim.new(0, 6)
    wCorner.Parent = wBox

    -- 高度
    local hLabel = Instance.new("TextLabel")
    hLabel.Size = UDim2.new(0.3, 0, 0, 25)
    hLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
    hLabel.Text = "高度:"
    hLabel.TextColor3 = Color3.fromRGB(60, 60, 70)
    hLabel.BackgroundTransparency = 1
    hLabel.Font = Enum.Font.Gotham
    hLabel.TextSize = 13
    hLabel.Parent = settingPanel

    local hBox = Instance.new("TextBox")
    hBox.Size = UDim2.new(0.4, 0, 0, 25)
    hBox.Position = UDim2.new(0.5, 0, 0.55, 0)
    hBox.Text = tostring(uiHeight)
    hBox.TextColor3 = Color3.fromRGB(30, 30, 30)
    hBox.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    hBox.BorderSizePixel = 1
    hBox.BorderColor3 = Color3.fromRGB(200, 200, 210)
    hBox.Font = Enum.Font.Gotham
    hBox.TextSize = 13
    hBox.Parent = settingPanel

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 6)
    hCorner.Parent = hBox

    -- 应用按钮
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.4, 0, 0, 32)
    applyBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
    applyBtn.Text = "应用"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
    applyBtn.BorderSizePixel = 0
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 14
    applyBtn.Parent = settingPanel

    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 6)
    applyCorner.Parent = applyBtn

    applyBtn.MouseButton1Click:Connect(function()
        local newW = tonumber(wBox.Text)
        local newH = tonumber(hBox.Text)
        if newW and newW >= 200 and newW <= 600 then uiWidth = newW end
        if newH and newH >= 150 and newH <= 500 then uiHeight = newH end
        if mainFrame then
            mainFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
        end
        settingPanel.Visible = false
    end)

    return settingPanel
end

-- ===== 创建主UI =====
local function createMainUI()
    if mainFrame then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainUIGui"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
    mainFrame.Position = UDim2.new(0.5, -uiWidth/2, 0.5, -uiHeight/2)
    mainFrame.AnchorPoint = Vector2.new(0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- 毛玻璃效果（模糊背景）
    local blur = Instance.new("UIBlurEffect")
    blur.Enabled = true
    blur.Size = 20
    blur.Parent = mainFrame

    -- 圆角 + 阴影
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame

    local mainShadow = Instance.new("UIShadow")
    mainShadow.Blur = 20
    mainShadow.Offset = Vector2.new(0, 8)
    mainShadow.Transparency = 0.3
    mainShadow.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(220, 220, 230)
    mainStroke.Thickness = 1.5
    mainStroke.Parent = mainFrame

    -- 标题栏（可拖动）
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar

    -- 齿轮按钮（左上角）
    local gearBtn = Instance.new("TextButton")
    gearBtn.Size = UDim2.new(0, 32, 0, 32)
    gearBtn.Position = UDim2.new(0, 8, 0, 6)
    gearBtn.Text = "⚙"
    gearBtn.TextColor3 = Color3.fromRGB(60, 60, 70)
    gearBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
    gearBtn.BorderSizePixel = 0
    gearBtn.Font = Enum.Font.GothamBold
    gearBtn.TextSize = 18
    gearBtn.Parent = titleBar

    local gearCorner = Instance.new("UICorner")
    gearCorner.CornerRadius = UDim.new(0, 6)
    gearCorner.Parent = gearBtn

    gearBtn.MouseButton1Click:Connect(function()
        if settingPanel then
            settingPanel.Visible = not settingPanel.Visible
        end
    end)

    -- 标题文字
    titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 48, 0, 0)
    titleLabel.Text = "⚡ 超高速跑者"
    titleLabel.TextColor3 = Color3.fromRGB(30, 30, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- 关闭按钮（右上角）
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -40, 0, 6)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(60, 60, 70)
    closeBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        uiVisible = false
        mainFrame.Visible = false
        if isRunning then isRunning = false end
    end)

    -- 拖动标题栏
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- 内容区域
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -44)
    content.Position = UDim2.new(0, 0, 0, 44)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    -- 辅助：创建带标签的输入框（WindUI 风格）
    local function createLabeledInput(labelText, defaultText, yPos)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, 0, 0, 30)
        label.Position = UDim2.new(0.05, 0, yPos, 0)
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(40, 40, 50)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = content

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.5, 0, 0, 30)
        box.Position = UDim2.new(0.4, 0, yPos, 0)
        box.Text = defaultText
        box.TextColor3 = Color3.fromRGB(30, 30, 30)
        box.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        box.BorderSizePixel = 1
        box.BorderColor3 = Color3.fromRGB(210, 210, 220)
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = content

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 6)
        boxCorner.Parent = box

        return box
    end

    valueBox = createLabeledInput("速度增量:", "10000000", 0.05)
    intervalBox = createLabeledInput("间隔(秒):", "0.05", 0.25)

    -- 状态和计数
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.9, 0, 0, 40)
    statusFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
    statusFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    statusFrame.BorderSizePixel = 1
    statusFrame.BorderColor3 = Color3.fromRGB(220, 220, 230)
    statusFrame.Parent = content

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusFrame

    statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.6, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 0)
    statusLabel.Text = "状态: 就绪"
    statusLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame

    countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0.3, 0, 1, 0)
    countLabel.Position = UDim2.new(0.65, 0, 0, 0)
    countLabel.Text = "发送: 0"
    countLabel.TextColor3 = Color3.fromRGB(0, 120, 212)
    countLabel.BackgroundTransparency = 1
    countLabel.Font = Enum.Font.Gotham
    countLabel.TextSize = 14
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    countLabel.Parent = statusFrame

    -- 按钮容器
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0.9, 0, 0, 46)
    btnContainer.Position = UDim2.new(0.05, 0, 0.7, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = content

    -- 开始按钮
    startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.45, 0, 1, 0)
    startBtn.Position = UDim2.new(0, 0, 0, 0)
    startBtn.Text = "▶ 开始"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
    startBtn.BorderSizePixel = 0
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 16
    startBtn.Parent = btnContainer

    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 8)
    startCorner.Parent = startBtn

    -- 暂停按钮
    pauseBtn = Instance.new("TextButton")
    pauseBtn.Size = UDim2.new(0.45, 0, 1, 0)
    pauseBtn.Position = UDim2.new(0.55, 0, 0, 0)
    pauseBtn.Text = "⏸ 暂停"
    pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pauseBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
    pauseBtn.BorderSizePixel = 0
    pauseBtn.Font = Enum.Font.GothamBold
    pauseBtn.TextSize = 16
    pauseBtn.Parent = btnContainer

    local pauseCorner = Instance.new("UICorner")
    pauseCorner.CornerRadius = UDim.new(0, 8)
    pauseCorner.Parent = pauseBtn

    -- 悬停效果
    local function setupHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = hoverColor end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = normalColor end)
    end
    setupHover(startBtn, Color3.fromRGB(0, 120, 212), Color3.fromRGB(0, 140, 230))
    setupHover(pauseBtn, Color3.fromRGB(200, 80, 60), Color3.fromRGB(220, 100, 80))

    -- 按钮事件
    startBtn.MouseButton1Click:Connect(function()
        local num = tonumber(valueBox.Text)
        if not num then
            statusLabel.Text = "⚠️ 无效数字"
            statusLabel.TextColor3 = Color3.fromRGB(200, 120, 0)
            return
        end
        local interval = tonumber(intervalBox.Text)
        if not interval or interval <= 0 then
            statusLabel.Text = "⚠️ 间隔需大于0"
            statusLabel.TextColor3 = Color3.fromRGB(200, 120, 0)
            return
        end

        if isRunning then return end

        isRunning = true
        startBtn.Text = "⏳ 运行中"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 180, 0)
        pauseBtn.Text = "⏸ 暂停"
        pauseBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
        statusLabel.Text = "状态: 运行中"
        statusLabel.TextColor3 = Color3.fromRGB(0, 150, 80)

        sendCount = 0
        countLabel.Text = "发送: 0"

        loopThread = coroutine.create(function()
            while isRunning do
                local success, err = fireStepTaken(num)
                if success then
                    sendCount = sendCount + 1
                    countLabel.Text = "发送: " .. sendCount
                else
                    statusLabel.Text = "❌ " .. err
                    statusLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
                    isRunning = false
                    break
                end
                task.wait(interval)
            end
            if not isRunning then
                startBtn.Text = "▶ 开始"
                startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
                pauseBtn.Text = "⏸ 暂停"
                pauseBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
                statusLabel.Text = "状态: 已停止"
                statusLabel.TextColor3 = Color3.fromRGB(40, 40, 50)
            end
        end)
        coroutine.resume(loopThread)
    end)

    pauseBtn.MouseButton1Click:Connect(function()
        if isRunning then
            isRunning = false
            startBtn.Text = "▶ 继续"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
            pauseBtn.Text = "⏸ 已暂停"
            pauseBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
            statusLabel.Text = "状态: 已暂停"
            statusLabel.TextColor3 = Color3.fromRGB(200, 120, 0)
        end
    end)

    -- 底部提示
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(0.9, 0, 0, 20)
    footer.Position = UDim2.new(0.05, 0, 0.9, 0)
    footer.Text = "⚡拖动按钮 | 点击⚙调整尺寸"
    footer.TextColor3 = Color3.fromRGB(120, 120, 140)
    footer.BackgroundTransparency = 1
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 11
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = content

  
