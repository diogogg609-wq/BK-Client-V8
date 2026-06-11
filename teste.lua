-- BK CLIENT V2 - FIX BOX & GHOST ESP
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Limpeza de versões anteriores
if CoreGui:FindFirstChild("BK_Client_V2") then CoreGui.BK_Client_V2:Destroy() end

-- VARIÁVEIS GLOBAIS
_G.ESP_Skeleton = false
_G.ESP_Box = false
_G.ESP_Line = false
_G.ESP_Distance = false
_G.ESP_Name = false
_G.ESP_Health = false
_G.Aimbot = false
_G.WallCheck = true
_G.FOV_Visible = false
_G.FOV_Size = 100
_G.AimOffset_X = 0
_G.Smoothness = 0.2

-- DESENHO DO FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- SISTEMA DE DESENHO COM LIMPEZA AUTOMÁTICA
local Drawings = {}

local function RemoveDrawings(p)
    if Drawings[p] then
        for _, v in pairs(Drawings[p]) do
            v.Visible = false
            v:Remove()
        end
        Drawings[p] = nil
    end
end

local function GetDrawings(p)
    if not Drawings[p] then
        Drawings[p] = {
            Head = Drawing.new("Circle"),
            Spine = Drawing.new("Line"), L_Arm = Drawing.new("Line"), R_Arm = Drawing.new("Line"), 
            L_Leg = Drawing.new("Line"), R_Leg = Drawing.new("Line"),
            Box = Drawing.new("Square"),
            Line = Drawing.new("Line"),
            Distance = Drawing.new("Text"),
            Name = Drawing.new("Text"),
            HealthBar = Drawing.new("Line"),
            HealthBarOutline = Drawing.new("Line")
        }
        -- Configuração Inicial (Evita Box Pintada)
        Drawings[p].Box.Filled = false
        Drawings[p].Box.Thickness = 1.5
        Drawings[p].Distance.Size = 14; Drawings[p].Distance.Center = true; Drawings[p].Distance.Outline = true
        Drawings[p].Name.Size = 14; Drawings[p].Name.Center = true; Drawings[p].Name.Outline = true
        Drawings[p].HealthBar.Thickness = 2
    end
    return Drawings[p]
end

-- UI PRINCIPAL (PRESERVADA)
local BK_UI = Instance.new("ScreenGui", CoreGui); BK_UI.Name = "BK_Client_V2"
local MainFrame = Instance.new("Frame", BK_UI); MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0); MainFrame.Size = UDim2.new(0, 380, 0, 40); MainFrame.ClipsDescendants = true; Instance.new("UICorner", MainFrame); Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60, 60, 60)
local TitleBar = Instance.new("TextButton", MainFrame); TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TitleBar.Text = "  BK CLIENT V2 😈"; TitleBar.TextColor3 = Color3.new(1,1,1); TitleBar.Font = "GothamBold"; TitleBar.TextSize = 15; TitleBar.TextXAlignment = "Left"
local Content = Instance.new("Frame", MainFrame); Content.Size = UDim2.new(1, 0, 1, -40); Content.Position = UDim2.new(0, 0, 0, 40); Content.BackgroundTransparency = 1
local Sidebar = Instance.new("Frame", Content); Sidebar.Size = UDim2.new(0, 90, 1, -30); Sidebar.Position = UDim2.new(1, -95, 0, 5); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
local Pages = Instance.new("Frame", Content); Pages.Size = UDim2.new(1, -110, 1, -10); Pages.Position = UDim2.new(0, 10, 0, 5); Pages.BackgroundTransparency = 1

local VisualPage = Instance.new("ScrollingFrame", Pages); VisualPage.Size = UDim2.new(1, 0, 1, 0); VisualPage.BackgroundTransparency = 1; VisualPage.ScrollBarThickness = 0; Instance.new("UIListLayout", VisualPage).Padding = UDim.new(0, 8)
local MiraPage = Instance.new("ScrollingFrame", Pages); MiraPage.Size = UDim2.new(1, 0, 1, 0); MiraPage.BackgroundTransparency = 1; MiraPage.Visible = false; MiraPage.ScrollBarThickness = 0; Instance.new("UIListLayout", MiraPage).Padding = UDim.new(0, 8)

local function NewTab(name, page)
    local t = Instance.new("TextButton", Sidebar); t.Size = UDim2.new(1, 0, 0, 35); t.BackgroundColor3 = Color3.fromRGB(25, 25, 25); t.Text = name; t.TextColor3 = Color3.fromRGB(150, 150, 150); t.Font = "GothamBold"; Instance.new("UICorner", t)
    t.MouseButton1Click:Connect(function()
        VisualPage.Visible = false; MiraPage.Visible = false; page.Visible = true
        for _,v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150,150,150) end end
        t.TextColor3 = Color3.new(1,1,1)
    end)
end
NewTab("VISUAL", VisualPage); NewTab("MIRA", MiraPage)

local function CreateCard(txt, parent, callback)
    local Card = Instance.new("Frame", parent); Card.Size = UDim2.new(1, 0, 0, 45); Card.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Card)
    local L = Instance.new("TextLabel", Card); L.Size = UDim2.new(0.6, 0, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.Text = txt; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
    local B = Instance.new("TextButton", Card); B.Size = UDim2.new(0, 40, 0, 20); B.Position = UDim2.new(1, -50, 0.5, -10); B.BackgroundColor3 = Color3.fromRGB(40, 40, 40); B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local C = Instance.new("Frame", B); C.Size = UDim2.new(0, 16, 0, 16); C.Position = UDim2.new(0, 2, 0.5, -8); C.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", C).CornerRadius = UDim.new(1, 0)
    local on = false; B.MouseButton1Click:Connect(function() on = not on; TweenService:Create(C, TweenInfo.new(0.2), {Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play(); TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = on and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)}):Play(); callback(on) end)
end

local function CreateSlider(txt, parent, min, max, callback)
    local Card = Instance.new("Frame", parent); Card.Size = UDim2.new(1, 0, 0, 55); Card.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Card)
    local L = Instance.new("TextLabel", Card); L.Text = txt .. ": " .. max; L.Size = UDim2.new(1, -20, 0, 20); L.Position = UDim2.new(0, 10, 0, 5); L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
    local S = Instance.new("TextButton", Card); S.Size = UDim2.new(1, -20, 0, 6); S.Position = UDim2.new(0, 10, 0, 35); S.BackgroundColor3 = Color3.fromRGB(45, 45, 45); S.Text = ""; Instance.new("UICorner", S)
    local F = Instance.new("Frame", S); F.Size = UDim2.new(0.5, 0, 1, 0); F.BackgroundColor3 = Color3.fromRGB(0, 200, 100); Instance.new("UICorner", F)
    local active = false; local function up() local r = math.clamp((UserInputService:GetMouseLocation().X - S.AbsolutePosition.X) / S.AbsoluteSize.X, 0, 1); F.Size = UDim2.new(r, 0, 1, 0); local v = math.floor(min + (max - min) * r); L.Text = txt .. ": " .. v; callback(v) end
    S.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then active = true up() end end); UserInputService.InputChanged:Connect(function(i) if active then up() end end); UserInputService.InputEnded:Connect(function() active = false end)
end

-- ABA VISUAL
CreateCard("ESP Esqueleto", VisualPage, function(v) _G.ESP_Skeleton = v end)
CreateCard("ESP Box (Bordas)", VisualPage, function(v) _G.ESP_Box = v end)
CreateCard("ESP Nome", VisualPage, function(v) _G.ESP_Name = v end)
CreateCard("ESP Distancia", VisualPage, function(v) _G.ESP_Distance = v end)
CreateCard("ESP Vida", VisualPage, function(v) _G.ESP_Health = v end)
CreateCard("ESP Linhas", VisualPage, function(v) _G.ESP_Line = v end)

-- MIRA
CreateCard("Aimbot Master", MiraPage, function(v) _G.Aimbot = v end)
CreateCard("Check Wall", MiraPage, function(v) _G.WallCheck = v end)
CreateCard("Exibir ROV", MiraPage, function(v) _G.FOV_Visible = v end)
CreateSlider("Ajuste X (Mira)", MiraPage, -50, 50, function(v) _G.AimOffset_X = v end)
CreateSlider("Tamanho ROV", MiraPage, 30, 600, function(v) _G.FOV_Size = v end)

-- LIMPEZA DE JOGADORES QUE SAEM
Players.PlayerRemoving:Connect(RemoveDrawings)

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Visible = _G.FOV_Visible; FOVCircle.Radius = _G.FOV_Size; FOVCircle.Position = center

    local targetHead = nil; local minMag = _G.FOV_Size

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local d = GetDrawings(p)
        local char = p.Character
        
        -- Verifica se o player morreu ou sumiu
        if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local head = char.Head; local hum = char.Humanoid
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local visible = #Camera:GetPartsObscuringTarget({head.Position}, {LocalPlayer.Character, char}) == 0
            local dist = (Camera.CFrame.Position - head.Position).Magnitude

            -- AIMBOT
            if onScreen and _G.Aimbot then
                local mag = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if mag < minMag then
                    if _G.WallCheck and visible then targetHead = head; minMag = mag
                    elseif not _G.WallCheck then targetHead = head; minMag = mag end
                end
            end

            -- VISUAIS
            if onScreen then
                local sizeX, sizeY = 2000 / pos.Z, 3000 / pos.Z
                local boxPos = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2)

                d.Box.Visible = _G.ESP_Box; d.Box.Size = Vector2.new(sizeX, sizeY); d.Box.Position = boxPos
                d.Box.Color = visible and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                
                d.Line.Visible = _G.ESP_Line; d.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); d.Line.To = Vector2.new(pos.X, pos.Y)
                d.Name.Visible = _G.ESP_Name; d.Name.Position = Vector2.new(pos.X, boxPos.Y - 15); d.Name.Text = p.Name
                d.Distance.Visible = _G.ESP_Distance; d.Distance.Position = Vector2.new(pos.X, boxPos.Y + sizeY + 5); d.Distance.Text = math.floor(dist) .. "m"

                if _G.ESP_Health then
                    local hPct = hum.Health / hum.MaxHealth
                    d.HealthBarOutline.Visible = true; d.HealthBarOutline.From = Vector2.new(boxPos.X - 5, boxPos.Y + sizeY); d.HealthBarOutline.To = Vector2.new(boxPos.X - 5, boxPos.Y)
                    d.HealthBar.Visible = true; d.HealthBar.From = Vector2.new(boxPos.X - 5, boxPos.Y + sizeY); d.HealthBar.To = Vector2.new(boxPos.X - 5, boxPos.Y + sizeY - (sizeY * hPct))
                    d.HealthBar.Color = hPct > 0.6 and Color3.new(0,1,0) or (hPct > 0.3 and Color3.new(1,1,0) or Color3.new(1,0,0))
                else d.HealthBar.Visible = false; d.HealthBarOutline.Visible = false end

                if _G.ESP_Skeleton then
                    local function v2(part) local pPart = char:FindFirstChild(part); if not pPart then return nil end; local pV, o = Camera:WorldToViewportPoint(pPart.Position); return o and Vector2.new(pV.X, pV.Y) or nil end
                    local h, t = v2("Head"), v2("UpperTorso") or v2("Torso")
                    local la, ra = v2("Left Arm") or v2("LeftUpperArm"), v2("Right Arm") or v2("RightUpperArm")
                    local ll, rl = v2("Left Leg") or v2("LeftUpperLeg"), v2("Right Leg") or v2("RightUpperLeg")
                    if h and t then
                        d.Head.Visible = true; d.Head.Position = h; d.Head.Radius = math.clamp(100/pos.Z, 3, 12)
                        d.Spine.Visible = true; d.Spine.From = h; d.Spine.To = t
                        if la then d.L_Arm.Visible = true; d.L_Arm.From = t; d.L_Arm.To = la end
                        if ra then d.R_Arm.Visible = true; d.R_Arm.From = t; d.R_Arm.To = ra end
                        if ll then d.L_Leg.Visible = true; d.L_Leg.From = t; d.L_Leg.To = ll end
                        if rl then d.R_Leg.Visible = true; d.R_Leg.From = t; d.R_Leg.To = rl end
                    end
                else d.Head.Visible = false; d.Spine.Visible = false; d.L_Arm.Visible = false; d.R_Arm.Visible = false; d.L_Leg.Visible = false; d.R_Leg.Visible = false end
            else
                for _, v in pairs(d) do v.Visible = false end
            end
        else
            for _, v in pairs(d) do v.Visible = false end
        end
    end

    if targetHead then
        local tPos = targetHead.Position + Vector3.new(_G.AimOffset_X/10, 0, 0)
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tPos), _G.Smoothness)
    end
end)

-- SISTEMA DE ABRIR E DRAG
local isOpen = false; local lastS = UDim2.new(0, 380, 0, 310)
TitleBar.MouseButton1Click:Connect(function() isOpen = not isOpen; TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = isOpen and lastS or UDim2.new(0, MainFrame.Size.X.Offset, 0, 40)}):Play() end)
local d, dp, sp; TitleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; dp = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d then MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position - dp).X, sp.Y.Scale, sp.Y.Offset + (i.Position - dp).Y) end end)
UserInputService.InputEnded:Connect(function() d = false end)
