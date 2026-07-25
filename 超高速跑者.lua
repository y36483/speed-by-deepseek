--[[
    脚本名称: 超高速跑者 (WindUI 版)
    作者: DeepSeek AI
    描述: 使用 WindUI 库，通过循环调用 StepTaken 事件自动增加角色速度。
]]

-- 1. 加载 WindUI 库
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()[reference:2][reference:3]

-- 2. 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "⚡ 超高速跑者",
    Author = "DeepSeek AI",
    Folder = "SpeedRunner",
    Icon = "rocket", -- 图标名称参考 WindUI 文档
    Theme = "Dark", -- 主题可选 "Dark" 或 "Light"[reference:5]
})

-- 3. 创建主标签页
local MainTab = Window:Tab({
    Title = "控制面板",
    Icon = "gauge",
})

-- 4. 创建主设置区域
local MainSection = MainTab:Section({
    Title = "速度设置",
})

-- 5. 速度增量输入框
local SpeedInput = MainSection:Input({
    Title = "速度增量",
    Desc = "单次增加的速度值，数值越大效果越强",
    Value = "10000000",
    Type = "Input", -- 普通输入框[reference:6]
    Callback = function(value)
        -- 当用户输入时，可以在这里进行实时处理（可选）
    end
})

-- 6. 发送间隔输入框
local IntervalInput = MainSection:Input({
    Title = "发送间隔 (秒)",
    Desc = "建议 0.05 ~ 0.1 秒，过快可能被服务器限制",
    Value = "0.05",
    Type = "Input",
})

-- 7. 状态显示区域
local StatusSection = MainTab:Section({
    Title = "运行状态",
})

-- 状态标签（用于显示当前状态）
local StatusLabel = StatusSection:Label({
    Title = "状态: 就绪",
    Color = Color3.fromRGB(200, 200, 200),
})

-- 计数标签（用于显示发送次数）
local CountLabel = StatusSection:Label({
    Title = "发送次数: 0",
    Color = Color3.fromRGB(150, 200, 255),
})

-- 8. 按钮区域（开始/暂停）
local ButtonSection = MainTab:Section({
    Title = "控制",
})

local isRunning = false
local loopThread = nil
local sendCount = 0

-- 核心功能：发送 StepTaken 事件
local function fireStepTaken(value)
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.StepTaken:FireServer(value, false)
    end)
    return success, err
end

-- 更新状态显示
local function updateStatus(text, color)
    StatusLabel:SetText("状态: " .. text)
    StatusLabel:SetColor(color or Color3.fromRGB(200, 200, 200))
end

local function updateCount()
    CountLabel:SetText("发送次数: " .. sendCount)
end

-- 开始按钮
local StartButton = ButtonSection:Button({
    Title = "▶ 开始",
    Color = Color3.fromRGB(0, 180, 80),
    Callback = function()
        -- 检查输入是否有效
        local num = tonumber(SpeedInput:GetValue())
        if not num or num <= 0 then
            updateStatus("请输入有效的速度增量", Color3.fromRGB(255, 200, 0))
            return
        end
        
        local interval = tonumber(IntervalInput:GetValue())
        if not interval or interval <= 0 then
            updateStatus("请输入有效的间隔时间", Color3.fromRGB(255, 200, 0))
            return
        end
        
        if isRunning then
            return -- 如果已经在运行，忽略
        end
        
        isRunning = true
        sendCount = 0
        updateCount()
        updateStatus("运行中...", Color3.fromRGB(0, 255, 100))
        StartButton:SetTitle("⏳ 运行中")
        StartButton:SetColor(Color3.fromRGB(200, 180, 0))
        PauseButton:SetTitle("⏸ 暂停")
        PauseButton:SetColor(Color3.fromRGB(220, 100, 50))
        
        loopThread = coroutine.create(function()
            while isRunning do
                local success, err = fireStepTaken(num)
                if success then
                    sendCount = sendCount + 1
                    updateCount()
                else
                    updateStatus("错误: " .. err, Color3.fromRGB(255, 80, 80))
                    isRunning = false
                    break
                end
                task.wait(interval)
            end
            
            -- 循环结束后恢复按钮状态
            if not isRunning then
                StartButton:SetTitle("▶ 开始")
                StartButton:SetColor(Color3.fromRGB(0, 180, 80))
                PauseButton:SetTitle("⏸ 暂停")
                PauseButton:SetColor(Color3.fromRGB(220, 100, 50))
                if StatusLabel:GetText() ~= "已暂停" then
                    updateStatus("已停止", Color3.fromRGB(200, 200, 200))
                end
            end
        end)
        coroutine.resume(loopThread)
    end
})

-- 暂停按钮
local PauseButton = ButtonSection:Button({
    Title = "⏸ 暂停",
    Color = Color3.fromRGB(220, 100, 50),
    Callback = function()
        if isRunning then
            isRunning = false
            StartButton:SetTitle("▶ 继续")
            StartButton:SetColor(Color3.fromRGB(0, 180, 80))
            PauseButton:SetTitle("⏸ 已暂停")
            PauseButton:SetColor(Color3.fromRGB(150, 150, 150))
            updateStatus("已暂停", Color3.fromRGB(255, 200, 0))
        end
    end
})

-- 9. 提示信息
local InfoSection = MainTab:Section({
    Title = "提示",
})

InfoSection:Label({
    Title = "💡 点击右上角 ⚡ 按钮可随时隐藏/显示窗口",
    Color = Color3.fromRGB(150, 150, 180),
})

InfoSection:Label({
    Title = "💡 拖拽标题栏可移动窗口位置",
    Color = Color3.fromRGB(150, 150, 180),
})

-- 10. 窗口打开/关闭控制
-- WindUI 自带窗口开关按钮，无需额外实现
-- 窗口右上角有最小化/关闭按钮，点击即可隐藏/关闭

print("✅ 超高速跑者 (WindUI 版) 已加载")
print("本脚本由 DeepSeek AI 生成")
