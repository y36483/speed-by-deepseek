--[[
    脚本名称: 超高速跑者 (Speed Booster)
    作者: DeepSeek AI
    描述: 通过循环调用 StepTaken 事件，自动增加角色速度。
    功能: 自定义增量、间隔、开始/暂停、可拖动UI、尺寸调节、彩虹文字。
    版本: 最终版
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

-- 所有需要彩虹变色的文本控件
local rainbowTexts = {}

-- ===== 配置参数（默认尺寸） =====
local uiWidth = 340
local uiHeight = 280

-- ===== 核心功能 =====
local function fireStepTaken(value)
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.StepTaken:FireServer(value, false)
    end)
    return success, err
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
    floatingBtn.Size = UDim2.new(0, 50, 0, 50)
    floatingBtn.Position = UDim2.new(1, -70, 0, 50)
    floatingBtn.AnchorPoint = Vector2.new(0, 0)
    floatingBtn.Text = "⚡"
    floatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    floatingBtn.BorderSizePixel = 0
    floatingBtn.Font = Enum.Font.GothamBold
    floatingBtn.TextSize = 24
    floatingBtn.Parent = screenGui
    table.insert(rainbowTexts, floatingBtn)

    -- 圆角+阴影
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = floatingBtn

    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(100, 100, 120)
    shadow.Thickness = 2
    shadow.Parent = floatingBtn

    -- 悬停
    floatingBtn.MouseEnter:Connect(function()
        floatingBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    floatingBtn.MouseLeave:Connect(function()
        floatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
    settingPanel.Size = UDim2.new(0, 220, 0, 140)
    settingPanel.Position = UDim2.new(0.5, -110, 0.5, -70)
    settingPanel.AnchorPoint = Vector2.new(0, 0)
    settingPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    settingPanel.BackgroundTransparency = 0.1
    settingPanel.BorderSizePixel = 0
    settingPanel.Visible = false
    settingPanel.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = settingPanel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 90)
    stroke.Thickness = 1.5
    stroke.Parent = settingPanel

    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "⚙ 设置"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = settingPanel
    table.insert(rainbowTexts, title)

    -- 宽度
    local wLabel = Instance.new("TextLabel")
    wLabel.Size = UDim2.new(0.3, 0, 0, 25)
    wLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
    wLabel.Text = "宽度:"
    wLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    wLabel.BackgroundTransparency = 1
    wLabel.Font = Enum.Font.Gotham
    wLabel.TextSize = 13
    wLabel.Parent = settingPanel
    table.insert(rainbowTexts, wLabel)

    local wBox = Instance.new("TextBox")
    wBox.Size = UDim2.new(0.4, 0, 0, 25)
    wBox.Position = UDim2.new(0.5, 0, 0.3, 0)
    wBox.Text = tostring(uiWidth)
    wBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    wBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    wBox.BorderSizePixel = 0
    wBox.Font = Enum.Font.Gotham
    wBox.TextSize = 13
    wBox.Parent = settingPanel
    table.insert(rainbowTexts, wBox)

    local wCorner = Instance.new("UICorner")
    wCorner.CornerRadius = UDim.new(0, 5)
    wCorner.Parent = wBox

    -- 高度
    local hLabel = Instance.new("TextLabel")
    hLabel.Size = UDim2.new(0.3, 0, 0, 25)
    hLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
    hLabel.Text = "高度:"
    hLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    hLabel.BackgroundTransparency = 1
    hLabel.Font = Enum.Font.Gotham
    hLabel.TextSize = 13
    hLabel.Parent = settingPanel
    table.insert(rainbowTexts, hLabel)

    local hBox = Instance.new("TextBox")
    hBox.Size = UDim2.new(0.4, 0, 0, 25)
    hBox.Position = UDim2.new(0.5, 0, 0.55, 0)
    hBox.Text = tostring(uiHeight)
    hBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    hBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    hBox.BorderSizePixel = 0
    hBox.Font = Enum.Font.Gotham
    hBox.TextSize = 13
    hBox.Parent = settingPanel
    table.insert(rainbowTexts, hBox)

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 5)
    hCorner.Parent = hBox

    -- 应用按钮
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.4, 0, 0, 30)
    applyBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
    applyBtn.Text = "应用"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    applyBtn.BorderSizePixel = 0
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 14
    applyBtn.Parent = settingPanel
    table.insert(rainbowTexts, applyBtn)

    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 5)
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
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(70, 70, 90)
    mainStroke.Thickness = 1.5
    mainStroke.Parent = mainFrame

    -- 标题栏（可拖动）
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    -- 齿轮按钮（左上角）
    local gearBtn = Instance.new("TextButton")
    gearBtn.Size = UDim2.new(0, 30, 0, 30)
    gearBtn.Position = UDim2.new(0, 8, 0, 5)
    gearBtn.Text = "⚙"
    gearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    gearBtn.BorderSizePixel = 0
    gearBtn.Font = Enum.Font.GothamBold
    gearBtn.TextSize = 18
    gearBtn.Parent = titleBar
    table.insert(rainbowTexts, gearBtn)

    local gearCorner = Instance.new("UICorner")
    gearCorner.CornerRadius = UDim.new(0, 6)
    gearCorner.Parent = gearBtn

    gearBtn.MouseButton1Click:Connect(function()
        if settingPanel then
            settingPanel.Visible = not settingPanel.Visible
        end
    end)

    -- 标题文字（修改为 超高速跑者）
    titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 45, 0, 0)
    titleLabel.Text = "⚡ 超高速跑者"   -- 修改处
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    table.insert(rainbowTexts, titleLabel)

    -- 关闭按钮（右上角）
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -38, 0, 4)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    table.insert(rainbowTexts, closeBtn)

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
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    -- 辅助：创建带标签的输入框
    local function createLabeledInput(labelText, defaultText, yPos)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, 0, 0, 30)
        label.Position = UDim2.new(0.05, 0, yPos, 0)
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = content
        table.insert(rainbowTexts, label)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.5, 0, 0, 30)
        box.Position = UDim2.new(0.4, 0, yPos, 0)
        box.Text = defaultText
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        box.BorderSizePixel = 0
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = content
        table.insert(rainbowTexts, box)

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 6)
        boxCorner.Parent = box

        return box
    end

    valueBox = createLabeledInput("速度增量:", "10000000", 0.05)
    intervalBox = createLabeledInput("间隔(秒):", "0.05", 0.25)

    -- 状态和计数
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.9, 0, 0, 36)
    statusFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
    statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = content

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusFrame

    statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.6, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 0)
    statusLabel.Text = "状态: 就绪"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame
    table.insert(rainbowTexts, statusLabel)

    countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0.3, 0, 1, 0)
    countLabel.Position = UDim2.new(0.65, 0, 0, 0)
    countLabel.Text = "发送: 0"
    countLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    countLabel.BackgroundTransparency = 1
    countLabel.Font = Enum.Font.Gotham
    countLabel.TextSize = 13
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    countLabel.Parent = statusFrame
    table.insert(rainbowTexts, countLabel)

    -- 按钮容器
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0.9, 0, 0, 44)
    btnContainer.Position = UDim2.new(0.05, 0, 0.7, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = content

    -- 开始按钮
    startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.45, 0, 1, 0)
    startBtn.Position = UDim2.new(0, 0, 0, 0)
    startBtn.Text = "▶ 开始"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    startBtn.BorderSizePixel = 0
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 16
    startBtn.Parent = btnContainer
    table.insert(rainbowTexts, startBtn)

    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 8)
    startCorner.Parent = startBtn

    -- 暂停按钮
    pauseBtn = Instance.new("TextButton")
    pauseBtn.Size = UDim2.new(0.45, 0, 1, 0)
    pauseBtn.Position = UDim2.new(0.55, 0, 0, 0)
    pauseBtn.Text = "⏸ 暂停"
    pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pauseBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 50)
    pauseBtn.BorderSizePixel = 0
    pauseBtn.Font = Enum.Font.GothamBold
    pauseBtn.TextSize = 16
    pauseBtn.Parent = btnContainer
    table.insert(rainbowTexts, pauseBtn)

    local pauseCorner = Instance.new("UICorner")
    pauseCorner.CornerRadius = UDim.new(0, 8)
    pauseCorner.Parent = pauseBtn

    -- 悬停效果
    local function setupHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = hoverColor end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = normalColor end)
    end
    setupHover(startBtn, Color3.fromRGB(0, 180, 80), Color3.fromRGB(0, 210, 100))
    setupHover(pauseBtn, Color3.fromRGB(220, 100, 50), Color3.fromRGB(240, 120, 70))

    -- 按钮事件
    startBtn.MouseButton1Click:Connect(function()
        local num = tonumber(valueBox.Text)
        if not num then
            statusLabel.Text = "⚠️ 无效数字"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        local interval = tonumber(intervalBox.Text)
        if not interval or interval <= 0 then
            statusLabel.Text = "⚠️ 间隔需大于0"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end

        if isRunning then return end

        isRunning = true
        startBtn.Text = "⏳ 运行中"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 180, 0)
        pauseBtn.Text = "⏸ 暂停"
        pauseBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 50)
        statusLabel.Text = "状态: 运行中"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)

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
                    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                    isRunning = false
                    break
                end
                task.wait(interval)
            end
            if not isRunning then
                startBtn.Text = "▶ 开始"
                startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
                pauseBtn.Text = "⏸ 暂停"
                pauseBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 50)
                statusLabel.Text = "状态: 已停止"
                statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end)
        coroutine.resume(loopThread)
    end)

    pauseBtn.MouseButton1Click:Connect(function()
        if isRunning then
            isRunning = false
            startBtn.Text = "▶ 继续"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
            pauseBtn.Text = "⏸ 已暂停"
            pauseBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            statusLabel.Text = "状态: 已暂停"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end)

    -- 底部提示
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(0.9, 0, 0, 18)
    footer.Position = UDim2.new(0.05, 0, 0.9, 0)
    footer.Text = "点击⚡按钮可隐藏/显示 | 拖拽⚡移动 | ⚙调整尺寸"
    footer.TextColor3 = Color3.fromRGB(120, 120, 140)
    footer.BackgroundTransparency = 1
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 11
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = content
    table.insert(rainbowTexts, footer)

    -- 创建设置面板（作为主UI子对象）
    createSettingPanel()

    return mainFrame
end

-- ===== 彩虹文字循环 =====
local function startRainbowLoop()
    local hue = 0
    while true do
        hue = (hue + 0.005) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        for _, textObj in ipairs(rainbowTexts) do
            if textObj and textObj.Parent then
                if textObj:IsA("TextLabel") or textObj:IsA("TextButton") or textObj:IsA("TextBox") then
                    textObj.TextColor3 = color
                end
            end
        end
        task.wait(0.05)
    end
end

-- ===== 初始化 =====
wait(0.5)
createFloatingButton()
createMainUI()
coroutine.wrap(startRainbowLoop)()

print("✅ 超高速跑者 已加载")
print("⚡ 拖动浮动按钮 | ⚙ 左上角齿轮调节尺寸")
print("本脚本由 DeepSeek AI 生成")