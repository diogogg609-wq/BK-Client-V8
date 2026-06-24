--====================================================================
-- 🩸 BK SCRIPTS - ALL-IN-ONE (VERSÃO FINAL) 🩸
--====================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- 1. ESTRUTURA DE OTIMIZAÇÃO (FPS BOOST)
local function BoostFPS()
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 999999
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("Texture") or obj:IsA("Decal") then
            obj:Destroy()
        end
    end
end

-- 2. CRIAÇÃO DA GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Scripts_Engine"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = game:CoreGui

-- EFEITO DE ABERTURA
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(1,0,1,0)
SplashFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
local SplashText = Instance.new("TextLabel", SplashFrame)
SplashText.Size = UDim2.new(1,0,1,0)
SplashText.Font = Enum.Font.Code
SplashText.TextSize = 40
SplashText.TextColor3 = Color3.fromRGB(255, 0, 51)
SplashText.Text = "BK SCRIPTS 🩸"

task.wait(2)
TweenService:Create(SplashFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(SplashText, TweenInfo.new(1), {TextTransparency = 1}):Play()
task.wait(1)
SplashFrame:Destroy()

-- MENU PRINCIPAL
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Botão de Otimização
local Btn = Instance.new("TextButton", MainFrame)
Btn.Size = UDim2.new(0, 260, 0, 50)
Btn.Position = UDim2.new(0, 20, 0, 75)
Btn.Text = "ATIVAR OTIMIZAÇÃO FPS"
Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 51)
Btn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", Btn)

Btn.MouseButton1Click:Connect(function()
    BoostFPS()
    Btn.Text = "OTIMIZADO!"
    task.wait(2)
    Btn.Text = "ATIVAR OTIMIZAÇÃO FPS"
end)

-- WIDGET FPS (GEFORCE STYLE)
local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.new(0, 100, 0, 30)
FpsLabel.Position = UDim2.new(0.5, -50, 0, 10)
FpsLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
FpsLabel.Text = "FPS: --"

RunService.RenderStepped:Connect(function()
    FpsLabel.Text = "FPS: ".. math.floor(1/RunService.RenderStepped:Wait())
end)

print("BK SCRIPTS 🩸 CARREGADA COM SUCESSO")
