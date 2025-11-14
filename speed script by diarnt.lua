-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.5, 0, 1, 0)
TitleText.Position = UDim2.new(0.25, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Speed Script GUI"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

-- Credit Button
local CreditButton = Instance.new("TextButton")
CreditButton.Name = "CreditButton"
CreditButton.Size = UDim2.new(0.24, 0, 1, 0)
CreditButton.Position = UDim2.new(0, 5, 0, 0)
CreditButton.BackgroundTransparency = 1
CreditButton.Text = "by DiarNT"
CreditButton.TextColor3 = Color3.fromRGB(150, 150, 255)
CreditButton.Font = Enum.Font.Gotham
CreditButton.TextSize = 12
CreditButton.TextXAlignment = Enum.TextXAlignment.Left
CreditButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.2, 0, 1, 0)
CloseButton.Position = UDim2.new(0.8, 0, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Speed Input Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Enter Walk Speed:"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = ContentFrame

-- Speed Input Box
local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.new(1, 0, 0, 40)
SpeedBox.Position = UDim2.new(0, 0, 0, 30)
SpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = "16" -- Default speed
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 16
SpeedBox.PlaceholderText = "Enter speed (16 is default)"
SpeedBox.Parent = ContentFrame

local SpeedBoxCorner = Instance.new("UICorner")
SpeedBoxCorner.CornerRadius = UDim.new(0, 8)
SpeedBoxCorner.Parent = SpeedBox

-- Enter Button
local EnterButton = Instance.new("TextButton")
EnterButton.Name = "EnterButton"
EnterButton.Size = UDim2.new(1, 0, 0, 40)
EnterButton.Position = UDim2.new(0, 0, 0, 80)
EnterButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
EnterButton.BorderSizePixel = 0
EnterButton.Text = "SET SPEED"
EnterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EnterButton.Font = Enum.Font.GothamBold
EnterButton.TextSize = 16
EnterButton.Parent = ContentFrame

local EnterButtonCorner = Instance.new("UICorner")
EnterButtonCorner.CornerRadius = UDim.new(0, 8)
EnterButtonCorner.Parent = EnterButton

-- Button hover effects
EnterButton.MouseEnter:Connect(function()
    EnterButton.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
end)

EnterButton.MouseLeave:Connect(function()
    EnterButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
end)

-- Minimized Icon
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Size = UDim2.new(0, 40, 0, 40)
MinimizedIcon.Position = UDim2.new(0, 20, 0.5, -20)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
MinimizedIcon.BorderSizePixel = 0
MinimizedIcon.Text = "S"
MinimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedIcon.Font = Enum.Font.GothamBold
MinimizedIcon.TextSize = 18
MinimizedIcon.Visible = false
MinimizedIcon.Parent = ScreenGui

local MinimizedIconCorner = Instance.new("UICorner")
MinimizedIconCorner.CornerRadius = UDim.new(0, 8)
MinimizedIconCorner.Parent = MinimizedIcon

-- Advanced Dragging Function (works with both mouse and touch)
local function makeDraggable(dragFrame, moveFrame)
    local dragging = false
    local dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        moveFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    -- For smooth touch dragging
    local lastPos
    RunService.Heartbeat:Connect(function()
        if dragging and UserInputService.TouchEnabled then
            local touch = UserInputService:GetTouchLocations()[1]
            if touch then
                if lastPos then
                    local delta = touch.Position - lastPos
                    moveFrame.Position = UDim2.new(
                        moveFrame.Position.X.Scale,
                        moveFrame.Position.X.Offset + delta.X,
                        moveFrame.Position.Y.Scale,
                        moveFrame.Position.Y.Offset + delta.Y
                    )
                end
                lastPos = touch.Position
            end
        else
            lastPos = nil
        end
    end)
end

-- Make both frames draggable
makeDraggable(TitleBar, MainFrame) -- Drag title bar to move main frame
makeDraggable(MinimizedIcon, MinimizedIcon) -- Drag icon to move itself

-- Close/Open functionality
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
end)

-- Touch support for buttons
local function addTouchButtonEffect(button)
    button.TouchTap:Connect(function()
        if button == EnterButton then
            setSpeed()
        elseif button == CloseButton then
            MainFrame.Visible = false
            MinimizedIcon.Visible = true
        elseif button == MinimizedIcon then
            MainFrame.Visible = true
            MinimizedIcon.Visible = false
        end
    end)
end

addTouchButtonEffect(EnterButton)
addTouchButtonEffect(CloseButton)
addTouchButtonEffect(MinimizedIcon)

-- Speed setting functionality
local function setSpeed()
    local speed = tonumber(SpeedBox.Text)
    if speed and character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
    end
end

EnterButton.MouseButton1Click:Connect(setSpeed)
SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        setSpeed()
    end
end)

-- Initialize with default speed
if character and character:FindFirstChild("Humanoid") then
    character.Humanoid.WalkSpeed = tonumber(SpeedBox.Text) or 16
end