-- =======================================================
-- BK CLIENT V8.0 - SCRIPT DE TESTE (NUVEM)
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Evita duplicar o menu na tela se executar duas vezes
if CoreGui:FindFirstChild("BK_Teste_UI") then
    CoreGui:FindFirstChild("BK_Teste_UI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Teste_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Criando o Botão Flutuante de Teste
local Botao = Instance.new("TextButton")
Botao.Name = "BotaoTeste"
Botao.Size = UDim2.new(0, 150, 0, 50)
Botao.Position = UDim2.new(0.5, -75, 0.3, 0)
Botao.BackgroundColor3 = Color3.fromRGB(120, 0, 255) -- Nosso roxo padrão
Botao.Text = "BK V8.0: CLIQUE"
Botao.TextColor3 = Color3.fromRGB(255, 255, 255)
Botao.TextSize = 14
Botao.Font = Enum.Font.GothamBold
Botao.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Botao

-- Arrastar o botão na tela (Mobile/PC)
local dragging = false
local dragStart, startPos
Botao.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Botao.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Botao.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Botao.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Ação ao clicar no botão
Botao.MouseButton1Click:Connect(function()
    Botao.Text = "CARREGADO! 🔥"
    Botao.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- Verde de sucesso
    
    -- Notificação nativa do Roblox para confirmar o funcionamento
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BK Client V8.0",
        Text = "O sistema de Loadstring está funcionando perfeitamente!",
        Duration = 5
    })
    
    task.wait(2)
    Botao.Text = "BK V8.0: CLIQUE"
    Botao.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
end)
