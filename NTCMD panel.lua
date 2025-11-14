-- nothing here lol

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
local humanoid = character:WaitForChild("Humanoid", 5)
local camera = game.Workspace.CurrentCamera or game.Workspace:WaitForChild("Camera", 5)

-- Fly variables
local flying = false
local noclipping = false
local godmode = false
local boosting = false
local baseSpeed = 50
local boostMultiplier = 2
local maxSpeed = 200
local minSpeed = 10
local bodyVelocity
local bodyGyro
local verticalInput = 0 -- Tracks UP/DOWN button input for vertical movement
local forwardInput = 0 -- Tracks Forward/Backward button input
local sideInput = 0 -- Tracks Left/Right button input
local healthConnection -- For invulnerability

-- Roblox notification on execution
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "NTCMD Script Loaded",
        Text = "BY DiarNT",
        Duration = 3
    })
end)

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalFlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui", 5)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Create main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 560) -- Increased height for new buttons
frame.Position = UDim2.new(0.5, -125, 0.5, -280)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Add size constraints (adjusted for mobile usability)
local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(200, 450) -- Adjusted min height for new buttons
sizeConstraint.MaxSize = Vector2.new(400, 750)
sizeConstraint.Parent = frame

-- Add gradient to frame
local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
}
frameGradient.Parent = frame

-- Create title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "NTCMD Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Create X close button
local xCloseButton = Instance.new("TextButton")
xCloseButton.Size = UDim2.new(0, 30, 0, 30)
xCloseButton.Position = UDim2.new(1, -35, 0, 5)
xCloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
xCloseButton.Text = "X"
xCloseButton.TextColor3 = Color3.fromRGB(200, 50, 50)
xCloseButton.TextSize = 16
xCloseButton.Font = Enum.Font.SourceSansBold
xCloseButton.Parent = frame
local xCloseGradient = Instance.new("UIGradient")
xCloseGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
xCloseGradient.Parent = xCloseButton

-- Create toggle fly button
local toggleFlyButton = Instance.new("TextButton")
toggleFlyButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleFlyButton.Position = UDim2.new(0.05, 0, 0, 50)
toggleFlyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleFlyButton.Text = "Fly: OFF"
toggleFlyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleFlyButton.TextSize = 16
toggleFlyButton.Font = Enum.Font.SourceSans
toggleFlyButton.Parent = frame

-- Add gradient to fly button
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
buttonGradient.Parent = toggleFlyButton

-- Create toggle noclip button
local toggleNoclipButton = Instance.new("TextButton")
toggleNoclipButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleNoclipButton.Position = UDim2.new(0.05, 0, 0, 100)
toggleNoclipButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleNoclipButton.Text = "Noclip: OFF"
toggleNoclipButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleNoclipButton.TextSize = 16
toggleNoclipButton.Font = Enum.Font.SourceSans
toggleNoclipButton.Parent = frame
buttonGradient:Clone().Parent = toggleNoclipButton

-- Create toggle godmode button
local toggleGodmodeButton = Instance.new("TextButton")
toggleGodmodeButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleGodmodeButton.Position = UDim2.new(0.05, 0, 0, 150)
toggleGodmodeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleGodmodeButton.Text = "Godmode: OFF"
toggleGodmodeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleGodmodeButton.TextSize = 16
toggleGodmodeButton.Font = Enum.Font.SourceSans
toggleGodmodeButton.Parent = frame
buttonGradient:Clone().Parent = toggleGodmodeButton

-- Create heal button
local healButton = Instance.new("TextButton")
healButton.Size = UDim2.new(0.9, 0, 0, 40)
healButton.Position = UDim2.new(0.05, 0, 0, 200)
healButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
healButton.Text = "Heal"
healButton.TextColor3 = Color3.fromRGB(0, 0, 0)
healButton.TextSize = 16
healButton.Font = Enum.Font.SourceSans
healButton.Parent = frame
buttonGradient:Clone().Parent = healButton

-- Create execute touch fling button
local executeFlingButton = Instance.new("TextButton")
executeFlingButton.Size = UDim2.new(0.9, 0, 0, 40)
executeFlingButton.Position = UDim2.new(0.05, 0, 0, 250)
executeFlingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
executeFlingButton.Text = "Execute Touch Fling"
executeFlingButton.TextColor3 = Color3.fromRGB(0, 0, 0)
executeFlingButton.TextSize = 16
executeFlingButton.Font = Enum.Font.SourceSans
executeFlingButton.Parent = frame
buttonGradient:Clone().Parent = executeFlingButton

-- Create speed label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0, 300)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. baseSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = frame

-- Create speed slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 340)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sliderFrame.Parent = frame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBar.Parent = sliderFrame

local sliderHandle = Instance.new("Frame")
sliderHandle.Size = UDim2.new(0, 10, 1, 10)
sliderHandle.Position = UDim2.new((baseSpeed - minSpeed) / (maxSpeed - minSpeed), -5, -0.25, 0)
sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderHandle.Parent = sliderFrame

local uiCornerHandle = Instance.new("UICorner")
uiCornerHandle.CornerRadius = UDim.new(0, 5)
uiCornerHandle.Parent = sliderHandle

-- Create fly up button
local flyUpButton = Instance.new("TextButton")
flyUpButton.Size = UDim2.new(0.45, -5, 0, 40)
flyUpButton.Position = UDim2.new(0.05, 0, 0, 370)
flyUpButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flyUpButton.Text = "UP"
flyUpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
flyUpButton.TextSize = 16
flyUpButton.Font = Enum.Font.SourceSans
flyUpButton.Parent = frame
buttonGradient:Clone().Parent = flyUpButton

-- Create fly down button
local flyDownButton = Instance.new("TextButton")
flyDownButton.Size = UDim2.new(0.45, -5, 0, 40)
flyDownButton.Position = UDim2.new(0.5, 5, 0, 370)
flyDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flyDownButton.Text = "DOWN"
flyDownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
flyDownButton.TextSize = 16
flyDownButton.Font = Enum.Font.SourceSans
flyDownButton.Parent = frame
buttonGradient:Clone().Parent = flyDownButton

-- Create forward button
local forwardButton = Instance.new("TextButton")
forwardButton.Size = UDim2.new(0.45, -5, 0, 40)
forwardButton.Position = UDim2.new(0.05, 0, 0, 420)
forwardButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
forwardButton.Text = "Forward"
forwardButton.TextColor3 = Color3.fromRGB(0, 0, 0)
forwardButton.TextSize = 16
forwardButton.Font = Enum.Font.SourceSans
forwardButton.Parent = frame
buttonGradient:Clone().Parent = forwardButton

-- Create backward button
local backwardButton = Instance.new("TextButton")
backwardButton.Size = UDim2.new(0.45, -5, 0, 40)
backwardButton.Position = UDim2.new(0.5, 5, 0, 420)
backwardButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
backwardButton.Text = "Backward"
backwardButton.TextColor3 = Color3.fromRGB(0, 0, 0)
backwardButton.TextSize = 16
backwardButton.Font = Enum.Font.SourceSans
backwardButton.Parent = frame
buttonGradient:Clone().Parent = backwardButton

-- Create left button
local leftButton = Instance.new("TextButton")
leftButton.Size = UDim2.new(0.45, -5, 0, 40)
leftButton.Position = UDim2.new(0.05, 0, 0, 470)
leftButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leftButton.Text = "Left"
leftButton.TextColor3 = Color3.fromRGB(0, 0, 0)
leftButton.TextSize = 16
leftButton.Font = Enum.Font.SourceSans
leftButton.Parent = frame
buttonGradient:Clone().Parent = leftButton

-- Create right button
local rightButton = Instance.new("TextButton")
rightButton.Size = UDim2.new(0.45, -5, 0, 40)
rightButton.Position = UDim2.new(0.5, 5, 0, 470)
rightButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rightButton.Text = "Right"
rightButton.TextColor3 = Color3.fromRGB(0, 0, 0)
rightButton.TextSize = 16
rightButton.Font = Enum.Font.SourceSans
rightButton.Parent = frame
buttonGradient:Clone().Parent = rightButton

-- Create boost toggle button
local toggleBoostButton = Instance.new("TextButton")
toggleBoostButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleBoostButton.Position = UDim2.new(0.05, 0, 0, 520)
toggleBoostButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBoostButton.Text = "Boost: OFF"
toggleBoostButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleBoostButton.TextSize = 16
toggleBoostButton.Font = Enum.Font.SourceSans
toggleBoostButton.Parent = frame
buttonGradient:Clone().Parent = toggleBoostButton

-- Create boost label (replaced with note about button)
local boostLabel = Instance.new("TextLabel")
boostLabel.Size = UDim2.new(0.9, 0, 0, 30)
boostLabel.Position = UDim2.new(0.05, 0, 0, 520)
boostLabel.BackgroundTransparency = 1
boostLabel.Text = "Boost Button for x" .. boostMultiplier .. " Speed"
boostLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
boostLabel.TextSize = 14
boostLabel.Font = Enum.Font.SourceSans
boostLabel.Parent = frame

-- Corner rounding for other elements
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame
uiCorner:Clone().Parent = toggleFlyButton
uiCorner:Clone().Parent = toggleNoclipButton
uiCorner:Clone().Parent = toggleGodmodeButton
uiCorner:Clone().Parent = healButton
uiCorner:Clone().Parent = executeFlingButton
uiCorner:Clone().Parent = xCloseButton
uiCorner:Clone().Parent = flyUpButton
uiCorner:Clone().Parent = flyDownButton
uiCorner:Clone().Parent = forwardButton
uiCorner:Clone().Parent = backwardButton
uiCorner:Clone().Parent = leftButton
uiCorner:Clone().Parent = rightButton
uiCorner:Clone().Parent = toggleBoostButton
uiCorner:Clone().Parent = sliderFrame
uiCorner:Clone().Parent = sliderBar

-- Resize logic
local resizing = false
resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 15, 0, 15)
resizeHandle.Position = UDim2.new(1, -15, 1, -15)
resizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
resizeHandle.Parent = frame
local resizeCorner = Instance.new("UICorner")
resizeCorner.CornerRadius = UDim.new(0, 5)
resizeCorner.Parent = resizeHandle
buttonGradient:Clone().Parent = resizeHandle

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        frame.Active = false
        frame.Draggable = false
    end
end)

resizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
        frame.Active = true
        frame.Draggable = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position
        local framePos = frame.AbsolutePosition
        local newWidth = math.clamp(mousePos.X - framePos.X, sizeConstraint.MinSize.X, sizeConstraint.MaxSize.X)
        local newHeight = math.clamp(mousePos.Y - framePos.Y, sizeConstraint.MinSize.Y, sizeConstraint.MaxSize.Y)
        frame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Slider logic with drag locking
local dragging = false
sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        frame.Active = false
        frame.Draggable = false
    end
end)

sliderHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        frame.Active = true
        frame.Draggable = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local sliderPos = sliderFrame.AbsolutePosition.X
        local sliderSize = sliderFrame.AbsoluteSize.X
        local inputX = input.Position.X
        if sliderPos and sliderSize and inputX then
            local relativeX = math.clamp((inputX - sliderPos) / sliderSize, 0, 1)
            sliderHandle.Position = UDim2.new(relativeX, -5, -0.25, 0)
            baseSpeed = math.round(minSpeed + relativeX * (maxSpeed - minSpeed))
            speedLabel.Text = "Speed: " .. baseSpeed
        end
    end
end)

-- Movement button logic
flyUpButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        verticalInput = 1
    end
end)

flyUpButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        verticalInput = verticalInput == 1 and 0 or verticalInput
    end
end)

flyDownButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        verticalInput = -1
    end
end)

flyDownButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        verticalInput = verticalInput == -1 and 0 or verticalInput
    end
end)

forwardButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        forwardInput = 1
    end
end)

forwardButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        forwardInput = forwardInput == 1 and 0 or forwardInput
    end
end)

backwardButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        forwardInput = -1
    end
end)

backwardButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        forwardInput = forwardInput == -1 and 0 or forwardInput
    end
end)

leftButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sideInput = -1
    end
end)

leftButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sideInput = sideInput == -1 and 0 or sideInput
    end
end)

rightButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sideInput = 1
    end
end)

rightButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sideInput = sideInput == 1 and 0 or sideInput
    end
end)

-- Boost toggle button logic
toggleBoostButton.MouseButton1Click:Connect(function()
    boosting = not boosting
    toggleBoostButton.Text = boosting and "Boost: ON" or "Boost: OFF"
    toggleBoostButton.BackgroundColor3 = boosting and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(255, 255, 255)
    local gradient = toggleBoostButton.UIGradient
    gradient.Color = boosting and ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 200))
    } or ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
end)

-- Heal functionality
local function healPlayer()
    if not humanoid then return end
    pcall(function()
        humanoid.Health = humanoid.MaxHealth
    end)
end

-- Execute Touch Fling functionality
local function executeTouchFling()
    pcall(function()
        loadstring(game:HttpGet("https://pastebin.com/raw/LgZwZ7ZB", true))()
    end)
end

-- Fly functionality
local function startFlying()
    if not humanoidRootPart or not humanoid then return end
    flying = true
    toggleFlyButton.Text = "Fly: ON"
    toggleFlyButton.BackgroundColor3 = Color3.fromRGB(200, 255, 200)
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 255, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 200, 150))
    }
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart
    
    humanoid.PlatformStand = true
end

local function stopFlying()
    flying = false
    toggleFlyButton.Text = "Fly: OFF"
    toggleFlyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    
    if bodyVelocity then pcall(function() bodyVelocity:Destroy() end) end
    if bodyGyro then pcall(function() bodyGyro:Destroy() end) end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- Godmode functionality
local function startGodmode()
    if not humanoid then return end
    godmode = true
    toggleGodmodeButton.Text = "Godmode: ON"
    toggleGodmodeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
    local gradient = toggleGodmodeButton.UIGradient
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 150))
    }
    
    pcall(function()
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        healthConnection = humanoid.HealthChanged:Connect(function(health)
            if godmode and health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end)
end

local function stopGodmode()
    if not humanoid then return end
    godmode = false
    toggleGodmodeButton.Text = "Godmode: OFF"
    toggleGodmodeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local gradient = toggleGodmodeButton.UIGradient
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    
    if healthConnection then pcall(function() healthConnection:Disconnect() end) end
    
    pcall(function()
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end)
end

-- Noclip functionality
local function startNoclip()
    if not character then return end
    noclipping = true
    toggleNoclipButton.Text = "Noclip: OFF"
    toggleNoclipButton.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
    local gradient = toggleNoclipButton.UIGradient
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 200))
    }
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.CanCollide = false end)
        end
    end
end

local function stopNoclip()
    if not character then return end
    noclipping = false
    toggleNoclipButton.Text = "Noclip: OFF"
    toggleNoclipButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local gradient = toggleNoclipButton.UIGradient
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.CanCollide = true end)
        end
    end
end

-- Update fly movement
local function updateFly(delta)
    if not flying or not humanoidRootPart or not camera then return end
    local direction = Vector3.new(0, 0, 0)
    
    -- Keyboard inputs for PC
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end
    
    -- Button inputs for mobile and PC
    direction += camera.CFrame.LookVector * forwardInput
    direction += camera.CFrame.RightVector * sideInput
    direction += Vector3.new(0, verticalInput, 0)
    
    if direction.Magnitude > 0 then
        direction = direction.Unit
    end
    
    local currentSpeed = boosting and baseSpeed * boostMultiplier or baseSpeed
    if bodyVelocity then
        bodyVelocity.Velocity = direction * currentSpeed
    end
    if bodyGyro then
        bodyGyro.CFrame = camera.CFrame
    end
end

-- Boost handling for PC (Shift key)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        boosting = true
        toggleBoostButton.Text = "Boost: ON"
        toggleBoostButton.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
        local gradient = toggleBoostButton.UIGradient
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 200))
        }
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        boosting = false
        toggleBoostButton.Text = "Boost: OFF"
        toggleBoostButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local gradient = toggleBoostButton.UIGradient
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        }
    end
end)

-- Button connections
toggleFlyButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

toggleNoclipButton.MouseButton1Click:Connect(function()
    if noclipping then stopNoclip() else startNoclip() end
end)

toggleGodmodeButton.MouseButton1Click:Connect(function()
    if godmode then stopGodmode() else startGodmode() end
end)

healButton.MouseButton1Click:Connect(function()
    healPlayer()
end)

executeFlingButton.MouseButton1Click:Connect(function()
    executeTouchFling()
end)

-- Update loop
RunService.RenderStepped:Connect(function(delta)
    pcall(updateFly, delta)
end)

-- Handle character reset
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:WaitForChild("Humanoid", 5)
    if flying then
        pcall(startFlying)
    end
    if noclipping then
        pcall(startNoclip)
    end
    if godmode then
        pcall(startGodmode)
    end
end)

-- Add hover effect to buttons
local function addHoverEffect(button, baseColor, hoverColor)
    button.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
    end)
    button.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = baseColor}):Play()
        end)
    end)
end

addHoverEffect(toggleFlyButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(toggleNoclipButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(toggleGodmodeButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(healButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(executeFlingButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(flyUpButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(flyDownButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(forwardButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(backwardButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(leftButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(rightButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(toggleBoostButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(xCloseButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))
addHoverEffect(resizeHandle, Color3.fromRGB(255, 255, 255), Color3.fromRGB(230, 230, 230))

-- Animate GUI appearance
frame.Position = UDim2.new(0.5, -125, 0.5, 280)
pcall(function()
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0.5, -280)}):Play()
end)