-- ========================================================
-- BK CLIENT V4.5 † - EXECUTIVE PREMIUM (CLOUD SAVE UPDATE)
-- Tema: Dark Cyber / Neon Purple Ultra | 100% Salve Automático
-- ========================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Proteção contra Duplicação
local GuiName = "BKClient_V4_Premium"
if CoreGui:FindFirstChild(GuiName) then CoreGui[GuiName]:Destroy() end

-- CORES DA PALETA CYBER VIP (PADRÃO INICIAL)
local C_FundoBreu   = Color3.fromRGB(10, 10, 13)    
local C_Painel     = Color3.fromRGB(16, 16, 22)    
local C_Card       = Color3.fromRGB(24, 24, 32)    
local C_RoxoNeon   = Color3.fromRGB(157, 38, 255)  -- Será sobrescrito pelo Save se existir
local C_TextoClaro = Color3.fromRGB(245, 245, 250)
local C_TextoEscuro = Color3.fromRGB(120, 120, 135)

-- INSTÂNCIA MÃE
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- TABELA GLOBAL DE CONFIGURAÇÕES (O QUE SERÁ SALVO)
local BK_Config = {
    TemaCor = {157, 38, 255}, -- R, G, B
    PainelAltura = 390,
    Toggles = {
        ["Chamber ESP Silhouette"] = false,
        ["Streamer Mode Bypass"] = false,
        ["Silent Aim Method"] = false
    }
}

-- Arquivos de salvamento local no Executador
local PastaSave = "BK_Client_Data"
local ArquivoSave = PastaSave .. "/config_v4.json"

-- Função para Salvar as Configurações
local function SalvarConfiguracoes()
    if writefile then
        if makefolder then makefolder(PastaSave) end
        local sucesso, textoJson = pcall(function()
            return HttpService:JSONEncode(BK_Config)
        end)
        if sucesso then
            writefile(ArquivoSave, textoJson)
        end
    end
end

-- Tabela de elementos para mudança dinâmica de cor
local ElementosColoridos = {}

local function RegistrarElementoColorido(instancia, propriedade)
    table.insert(ElementosColoridos, {Inst = instancia, Prop = propriedade})
end

local function MudarCorTema(novaCor, evitarSalvar)
    C_RoxoNeon = novaCor
    for _, dado in ipairs(ElementosColoridos) do
        if dado.Inst and dado.Inst.Parent then
            dado.Inst[dado.Prop] = novaCor
        end
    end
    if not evitarSalvar then
        BK_Config.TemaCor = {math.floor(novaCor.R * 255), math.floor(novaCor.G * 255), math.floor(novaCor.B * 255)}
        SalvarConfiguracoes()
    end
end

-- CONTAINER PARA NOTIFICAÇÕES
local NotificationContainer = Instance.new("Frame", ScreenGui)
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 260, 1, -20)
NotificationContainer.Position = UDim2.new(0, 15, 0, 10)
NotificationContainer.BackgroundTransparency = 1

local NotifLayout = Instance.new("UIListLayout", NotificationContainer)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

local function EnviarNotificacao(titulo, status)
    local NotifFrame = Instance.new("Frame", NotificationContainer)
    NotifFrame.Size = UDim2.new(1, 0, 0, 45)
    NotifFrame.BackgroundColor3 = C_FundoBreu
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 4)
    
    local NStroke = Instance.new("UIStroke", NotifFrame)
    NStroke.Color = C_RoxoNeon
    RegistrarElementoColorido(NStroke, "Color")
    NStroke.Thickness = 1

    local NText = Instance.new("TextLabel", NotifFrame)
    NText.Size = UDim2.new(1, -20, 1, 0)
    NText.Position = UDim2.new(0, 10, 0, 0)
    NText.BackgroundTransparency = 1
    NText.Font = Enum.Font.GothamBold
    NText.Text = string.format("[BK CLIENT] %s: <font color='rgb(245,245,250)'>%s</font>", titulo, status)
    NText.RichText = true
    NText.TextColor3 = C_TextoClaro
    NText.TextSize = 12
    NText.TextXAlignment = Enum.TextXAlignment.Left

    task.delay(3, function()
        if NotifFrame and NotifFrame.Parent then
            local t = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
            TweenService:Create(NStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(NText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            t:Play()
            t.Completed:Connect(function() NotifFrame:Destroy() end)
        end
    end)
end

-- SISTEMA DE AUDIO PREMIUM
local function playSound(id, vol, pitch)
    local s = Instance.new("Sound", SoundService)
    s.SoundId = "rbxassetid://" .. id
    s.Volume = vol or 1
    s.PlaybackSpeed = pitch or 1
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function somClick() playSound("6895086653", 0.6, 1.2) end
local function somHover() playSound("6895063231", 0.15, 1.5) end

-- MARCA D'ÁGUA PREMIUM (WATERMARK FPS/PING)
local Watermark = Instance.new("Frame", ScreenGui)
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 240, 0, 26)
Watermark.Position = UDim2.new(1, -255, 0, 15)
Watermark.BackgroundColor3 = C_FundoBreu
Watermark.ZIndex = 8

local WCorner = Instance.new("UICorner", Watermark)
WCorner.CornerRadius = UDim.new(0, 4)
local WStroke = Instance.new("UIStroke", Watermark)
WStroke.Color = C_RoxoNeon
RegistrarElementoColorido(WStroke, "Color")
WStroke.Thickness = 1

local WLabel = Instance.new("TextLabel", Watermark)
WLabel.Size = UDim2.new(1, 0, 1, 0)
WLabel.BackgroundTransparency = 1
WLabel.Font = Enum.Font.GothamBold
WLabel.Text = "BK CLIENT V4.5 | FPS: -- | PING: --ms"
WLabel.TextColor3 = C_TextoClaro
WLabel.TextSize = 11

local fpsCount = 0
local lastUpdate = os.clock()
RunService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
    local now = os.clock()
    if now - lastUpdate >= 1 then
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        WLabel.Text = string.format("BK CLIENT V4.5  |  FPS: %d  |  PING: %dms", fpsCount, ping)
        fpsCount = 0
        lastUpdate = now
    end
end)

-- PAINEL PRINCIPAL
local MainPanel = Instance.new("Frame", ScreenGui)
local PainelLarguraAlvo = 560
local PainelAlturaAlvo = BK_Config.PainelAltura

MainPanel.Size = UDim2.new(0, 0, 0, 0) 
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.BackgroundColor3 = C_FundoBreu
MainPanel.ClipsDescendants = true
MainPanel.ZIndex = 1 
MainPanel.Visible = false

local MCorner = Instance.new("UICorner", MainPanel)
MCorner.CornerRadius = UDim.new(0, 6)
local MStroke = Instance.new("UIStroke", MainPanel)
MStroke.Color = Color3.fromRGB(35, 35, 45)
MStroke.Thickness = 1

-- TOP BAR
local TopBar = Instance.new("Frame", MainPanel)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = C_Painel
TopBar.BorderSizePixel = 0

local DivisorTop = Instance.new("Frame", TopBar)
DivisorTop.Size = UDim2.new(1, 0, 0, 1)
DivisorTop.Position = UDim2.new(0, 0, 1, -1)
DivisorTop.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DivisorTop.BorderSizePixel = 0

local BrandLabel = Instance.new("TextLabel", TopBar)
BrandLabel.Position = UDim2.new(0, 15, 0, 0)
BrandLabel.Size = UDim2.new(0, 200, 1, 0)
BrandLabel.BackgroundTransparency = 1
BrandLabel.Text = "BK CLIENT <font color='rgb(157,38,255)'>V4.5</font> †"
BrandLabel.RichText = true
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.TextColor3 = C_TextoClaro
BrandLabel.TextSize = 16
BrandLabel.TextXAlignment = Enum.TextXAlignment.Left

local BadgeTag = Instance.new("TextLabel", TopBar)
BadgeTag.Position = UDim2.new(0, 145, 0.5, -9)
BadgeTag.Size = UDim2.new(0, 75, 0, 18)
BadgeTag.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
BadgeTag.Text = "CLOUD SEC"
BadgeTag.Font = Enum.Font.GothamBold
BadgeTag.TextSize = 9
BadgeTag.TextColor3 = C_RoxoNeon
RegistrarElementoColorido(BadgeTag, "TextColor3")
Instance.new("UICorner", BadgeTag).CornerRadius = UDim.new(0, 4)

local BadgeStroke = Instance.new("UIStroke", BadgeTag)
BadgeStroke.Color = C_RoxoNeon
RegistrarElementoColorido(BadgeStroke, "Color")

-- BARRA LATERAL (SIDEBAR)
local Sidebar = Instance.new("Frame", MainPanel)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.Size = UDim2.new(0, 150, 1, -45)
Sidebar.BackgroundColor3 = C_Painel
Sidebar.BorderSizePixel = 0

local DivisorSide = Instance.new("Frame", Sidebar)
DivisorSide.Size = UDim2.new(0, 1, 1, 0)
DivisorSide.Position = UDim2.new(1, -1, 0, 0)
DivisorSide.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DivisorSide.BorderSizePixel = 0

-- PERFIL DO JOGADOR
local ProfileCard = Instance.new("Frame", Sidebar)
ProfileCard.Size = UDim2.new(1, -16, 0, 55)
ProfileCard.Position = UDim2.new(0, 8, 1, -65)
ProfileCard.BackgroundColor3 = C_Card
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 4)

local PAvatar = Instance.new("ImageLabel", ProfileCard)
PAvatar.Size = UDim2.new(0, 36, 0, 36)
PAvatar.Position = UDim2.new(0, 8, 0.5, -18)
PAvatar.BackgroundColor3 = C_FundoBreu
local userId = LocalPlayer.UserId
PAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=420&height=420&format=png"
Instance.new("UICorner", PAvatar).CornerRadius = UDim.new(1, 0)

local PName = Instance.new("TextLabel", ProfileCard)
PName.Position = UDim2.new(0, 50, 0, 12)
PName.Size = UDim2.new(1, -55, 0, 15)
PName.BackgroundTransparency = 1
PName.Text = LocalPlayer.DisplayName
PName.Font = Enum.Font.GothamBold
PName.TextColor3 = C_TextoClaro
PName.TextSize = 11
PName.TextXAlignment = Enum.TextXAlignment.Left
PName.ClipsDescendants = true

local PStatus = Instance.new("TextLabel", ProfileCard)
PStatus.Position = UDim2.new(0, 50, 0, 27)
PStatus.Size = UDim2.new(1, -55, 0, 15)
PStatus.BackgroundTransparency = 1
PStatus.Text = "🪐 USER_VIP"
PStatus.Font = Enum.Font.GothamSemibold
PStatus.TextColor3 = C_RoxoNeon
RegistrarElementoColorido(PStatus, "TextColor3")
PStatus.TextSize = 10
PStatus.TextXAlignment = Enum.TextXAlignment.Left

-- CONTAINER DAS ABAS
local TabContainer = Instance.new("Frame", MainPanel)
TabContainer.Position = UDim2.new(0, 165, 0, 60)
TabContainer.Size = UDim2.new(1, -180, 1, -75)
TabContainer.BackgroundTransparency = 1

-- GERERENCIADOR DE ABAS
local ListaAbas = {"Visual", "Mira", "Status", "Configurações", "Extras", "Perfil"}
local framesDeConteudo = {}
local botoesDeAbas = {}
local ySpacing = 10

for idx, nomeAba in ipairs(ListaAbas) do
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -16, 0, 32)
    TabBtn.Position = UDim2.new(0, 8, 0, ySpacing)
    TabBtn.BackgroundColor3 = C_RoxoNeon
    RegistrarElementoColorido(TabBtn, "BackgroundColor3")
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "  " .. nomeAba
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextColor3 = C_TextoEscuro
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.AutoButtonColor = false
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
    
    local IndicadorAtivo = Instance.new("Frame", TabBtn)
    IndicadorAtivo.Name = "Indicador"
    IndicadorAtivo.Size = UDim2.new(0, 3, 0, 16)
    IndicadorAtivo.Position = UDim2.new(0, 0, 0.5, -8)
    IndicadorAtivo.BackgroundColor3 = C_RoxoNeon
    RegistrarElementoColorido(IndicadorAtivo, "BackgroundColor3")
    IndicadorAtivo.BackgroundTransparency = 1
    
    botoesDeAbas[nomeAba] = TabBtn
    
    local ContentFrame = Instance.new("ScrollingFrame", TabContainer)
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 3
    ContentFrame.ScrollBarImageColor3 = C_RoxoNeon
    RegistrarElementoColorido(ContentFrame, "ScrollBarImageColor3")
    ContentFrame.Visible = (idx == 1)
    
    local UIList = Instance.new("UIListLayout", ContentFrame)
    UIList.Padding = UDim.new(0, 8)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    
    framesDeConteudo[nomeAba] = ContentFrame
    ySpacing = ySpacing + 36
    
    TabBtn.MouseButton1Click:Connect(function()
        somClick()
        for name, frame in pairs(framesDeConteudo) do frame.Visible = (name == nomeAba) end
        for name, btn in pairs(botoesDeAbas) do
            local ind = btn:FindFirstChild("Indicador")
            if name == nomeAba then
                TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = C_TextoClaro, BackgroundTransparency = 0.92}):Play()
                if ind then TweenService:Create(ind, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = C_TextoEscuro, BackgroundTransparency = 1}):Play()
                if ind then TweenService:Create(ind, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
            end
        end
    end)
    TabBtn.MouseEnter:Connect(function() somHover() end)
end

-- CRIAÇÃO DE CARDS
local function CriarCardPremium(parent, titulo, sub)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, -5, 0, 50)
    Card.BackgroundColor3 = C_Card
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)
    local CStroke = Instance.new("UIStroke", Card)
    CStroke.Color = Color3.fromRGB(30, 30, 40)
    
    local Title = Instance.new("TextLabel", Card)
    Title.Position = UDim2.new(0, 12, 0, 10)
    Title.Size = UDim2.new(0, 200, 0, 15)
    Title.BackgroundTransparency = 1
    Title.Text = titulo
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = C_TextoClaro
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Sub = Instance.new("TextLabel", Card)
    Sub.Position = UDim2.new(0, 12, 0, 26)
    Sub.Size = UDim2.new(0, 300, 0, 15)
    Sub.BackgroundTransparency = 1
    Sub.Text = sub
    Sub.Font = Enum.Font.Gotham
    Sub.TextColor3 = C_TextoEscuro
    Sub.TextSize = 11
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    
    return Card
end

-- LÓGICA DO TOGGLE COM MEMÓRIA CLOUD DE ESTADO
local function AdicionarToggleVIP(parent, titulo, sub, callback)
    local Card = CriarCardPremium(parent, titulo, sub)
    local ToggleBtn = Instance.new("TextButton", Card)
    ToggleBtn.Size = UDim2.new(0, 38, 0, 18)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -9)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.Text = ""
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Indicator = Instance.new("Frame", ToggleBtn)
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = UDim2.new(0, 2, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    -- Carrega o estado que já estava salvo no arquivo
    local estado = BK_Config.Toggles[titulo] or false
    
    local function AtualizarVisualToggle(animar)
        local tempo = animar and 0.2 or 0
        if estado then
            ToggleBtn.BackgroundColor3 = C_RoxoNeon
            TweenService:Create(Indicator, TweenInfo.new(tempo), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = C_TextoClaro}):Play()
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            TweenService:Create(Indicator, TweenInfo.new(tempo), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end
    
    -- Executa o visual inicial carregado
    AtualizarVisualToggle(false)
    if estado and callback then task.spawn(function() callback(true) end) end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        estado = not estado
        somClick()
        BK_Config.Toggles[titulo] = estado
        SalvarConfiguracoes() -- Salva na hora!
        AtualizarVisualToggle(true)
        if callback then callback(estado) end
    end)
end

-- ADICIONANDO OS TOGGLES COM FUNÇÃO DE RETORNO (CALLBACK)
AdicionarToggleVIP(framesDeConteudo["Visual"], "Chamber ESP Silhouette", "Renderiza o contorno dos alvos através das paredes", function(estado)
    print("ESP Silhouette alterado para:", estado)
end)

AdicionarToggleVIP(framesDeConteudo["Visual"], "Streamer Mode Bypass", "Oculta suas informações para gravadores", function(estado)
    print("Streamer Mode alterado para:", estado)
end)

AdicionarToggleVIP(framesDeConteudo["Mira"], "Silent Aim Method", "Redireciona os projéteis sem mover a sua câmera", function(estado)
    print("Silent Aim alterado para:", estado)
end)

-- SELETOR DE VISUAL (CONFIGURAÇÕES)
local VisualCard = CriarCardPremium(framesDeConteudo["Configurações"], "Trocar Visual", "Selecione a cor temática da interface global")
VisualCard.Size = UDim2.new(1, -5, 0, 60)
local CoresTema = {
    {Cor = Color3.fromRGB(157, 38, 255), Nome = "Roxo"},
    {Cor = Color3.fromRGB(255, 38, 38), Nome = "Vermelho"},
    {Cor = Color3.fromRGB(38, 255, 120), Nome = "Verde"}
}
for i, obj in ipairs(CoresTema) do
    local CorBtn = Instance.new("TextButton", VisualCard)
    CorBtn.Size = UDim2.new(0, 65, 0, 22)
    CorBtn.Position = UDim2.new(1, -225 + ((i-1) * 72), 0.5, -11)
    CorBtn.BackgroundColor3 = obj.Cor
    CorBtn.Text = obj.Nome
    CorBtn.Font = Enum.Font.GothamBold
    CorBtn.TextSize = 10
    CorBtn.TextColor3 = (obj.Nome == "Verde") and Color3.fromRGB(10,10,15) or C_TextoClaro
    Instance.new("UICorner", CorBtn).CornerRadius = UDim.new(0, 4)
    
    CorBtn.MouseButton1Click:Connect(function()
        somClick()
        MudarCorTema(obj.Cor)
        EnviarNotificacao("Tema Visual", "Visual alterado para " .. obj.Nome)
    end)
end

-- SLIDER DE TAMANHO
local SliderCard = CriarCardPremium(framesDeConteudo["Configurações"], "Tamanho do Painel", "Arraste para ajustar a escala vertical da interface")
SliderCard.Size = UDim2.new(1, -5, 0, 60)
local SliderTrack = Instance.new("Frame", SliderCard)
SliderTrack.Size = UDim2.new(0, 180, 0, 4)
SliderTrack.Position = UDim2.new(1, -200, 0.5, -2)
SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Instance.new("UICorner", SliderTrack)

local SliderFill = Instance.new("Frame", SliderTrack)
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = C_RoxoNeon
RegistrarElementoColorido(SliderFill, "BackgroundColor3")
Instance.new("UICorner", SliderFill)

local SliderButton = Instance.new("TextButton", SliderTrack)
SliderButton.Size = UDim2.new(0, 12, 0, 12)
SliderButton.Position = UDim2.new(0.5, -6, 0.5, -6)
SliderButton.BackgroundColor3 = C_TextoClaro
SliderButton.Text = ""
Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)

local SBtnStroke = Instance.new("UIStroke", SliderButton)
SBtnStroke.Color = C_RoxoNeon
RegistrarElementoColorido(SBtnStroke, "Color")

-- Aplica o tamanho inicial salvo do slider
local percentInicial = math.clamp((BK_Config.PainelAltura - 280) / 220, 0, 1)
SliderButton.Position = UDim2.new(percentInicial, -6, 0.5, -6)
SliderFill.Size = UDim2.new(percentInicial, 0, 1, 0)

local arrastandoSlider = false
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        arrastandoSlider = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        arrastandoSlider = false
        BK_Config.PainelAltura = PainelAlturaAlvo
        SalvarConfiguracoes() -- Salva quando o usuário solta o mouse
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if arrastandoSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackWidth = SliderTrack.AbsoluteSize.X
        local percent = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        
        SliderButton.Position = UDim2.new(percent, -6, 0.5, -6)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        
        PainelAlturaAlvo = math.floor(280 + (percent * 220))
        if MainPanel.Visible and MainPanel.Size.Y.Offset > 0 then
            MainPanel.Size = UDim2.new(0, PainelLarguraAlvo, 0, PainelAlturaAlvo)
        end
    end
end)

-- SEÇÃO PERFIL & NOTA PREMIUM
local InfoCard = CriarCardPremium(framesDeConteudo["Perfil"], "Licença do Script", "Validade: Vitalícia / Hardware ID Vinculado")

local NotaPremiumCard = Instance.new("Frame", framesDeConteudo["Perfil"])
NotaPremiumCard.Size = UDim2.new(1, -5, 0, 110)
NotaPremiumCard.BackgroundColor3 = C_Card
Instance.new("UICorner", NotaPremiumCard).CornerRadius = UDim.new(0, 4)

local NoteStroke = Instance.new("UIStroke", NotaPremiumCard)
NoteStroke.Color = Color3.fromRGB(40, 35, 55)
local NotaLabel = Instance.new("TextLabel", NotaPremiumCard)
NotaLabel.Size = UDim2.new(1, -24, 1, -16)
NotaLabel.Position = UDim2.new(0, 12, 0, 8)
NotaLabel.BackgroundTransparency = 1
NotaLabel.Font = Enum.Font.GothamSemibold
NotaLabel.TextSize = 11
NotaLabel.TextColor3 = C_TextoClaro
NotaLabel.TextXAlignment = Enum.TextXAlignment.Left
NotaLabel.TextYAlignment = Enum.TextYAlignment.Top
NotaLabel.LineHeight = 1.35
NotaLabel.Text = "Olá cliente do bk ✓\nEstando felizes de ter você aqui usando nosso script\nQueremos a melhor experiência para você então aproveite\nUse a vontade e nos ajude a crescer\nEstando cada vez trazendo coisas novas e nunca vistas ❤️"

local SuporteCard = Instance.new("Frame", framesDeConteudo["Perfil"])
SuporteCard.Size = UDim2.new(1, -5, 0, 55)
SuporteCard.BackgroundColor3 = C_Card
Instance.new("UICorner", SuporteCard).CornerRadius = UDim.new(0, 4)

local SStroke = Instance.new("UIStroke", SuporteCard)
SStroke.Color = Color3.fromRGB(35, 30, 45)
local STitle = Instance.new("TextLabel", SuporteCard)
STitle.Position = UDim2.new(0, 12, 0, 11)
STitle.Size = UDim2.new(0, 200, 0, 15)
STitle.BackgroundTransparency = 1
STitle.Text = "Central de Suporte VIP"
STitle.Font = Enum.Font.GothamBold
STitle.TextColor3 = C_TextoClaro
STitle.TextSize = 13
STitle.TextXAlignment = Enum.TextXAlignment.Left

local SSub = Instance.new("TextLabel", SuporteCard)
SSub.Position = UDim2.new(0, 12, 0, 27)
SSub.Size = UDim2.new(0, 200, 0, 15)
SSub.BackgroundTransparency = 1
SSub.Text = "Copie o contato oficial para ajuda"
SSub.Font = Enum.Font.Gotham
SSub.TextColor3 = C_TextoEscuro
SSub.TextSize = 11
SSub.TextXAlignment = Enum.TextXAlignment.Left

local CopiarBtn = Instance.new("TextButton", SuporteCard)
CopiarBtn.Size = UDim2.new(0, 140, 0, 26)
CopiarBtn.Position = UDim2.new(1, -152, 0.5, -13)
CopiarBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
CopiarBtn.Text = "COPIAR LINK DO WHATSAPP"
CopiarBtn.Font = Enum.Font.GothamBold
CopiarBtn.TextColor3 = C_TextoClaro
CopiarBtn.TextSize = 9
CopiarBtn.ZIndex = 2
Instance.new("UICorner", CopiarBtn).CornerRadius = UDim.new(0, 4)

local BtnStroke = Instance.new("UIStroke", CopiarBtn)
BtnStroke.Color = C_RoxoNeon
RegistrarElementoColorido(BtnStroke, "Color")

CopiarBtn.MouseButton1Click:Connect(function()
    somClick()
    if setclipboard then setclipboard("49991510649") end
    EnviarNotificacao("Suporte VIP", "Número copiado")
end)

-- CÁPSULA FLUTUANTE 
local Bubble = Instance.new("TextButton", ScreenGui)
Bubble.Name = "FloatingBubble"
Bubble.BackgroundColor3 = C_FundoBreu
Bubble.Position = UDim2.new(0.5, -75, 0, 20)
Bubble.Size = UDim2.new(0, 150, 0, 40)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextColor3 = Color3.fromRGB(255, 255, 255) 
Bubble.TextSize = 14
Bubble.AutoButtonColor = false
Bubble.ZIndex = 5 
Bubble.ClipsDescendants = true
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1, 0) 

local BubbleStroke = Instance.new("UIStroke", Bubble)
BubbleStroke.Color = C_RoxoNeon 
RegistrarElementoColorido(BubbleStroke, "Color")
BubbleStroke.Thickness = 2

local StarCanvas = Instance.new("Frame", Bubble)
StarCanvas.Size = UDim2.new(1, 0, 1, 0)
StarCanvas.BackgroundTransparency = 1

local TextFix = Instance.new("TextLabel", Bubble)
TextFix.Size = UDim2.new(1, 0, 1, 0)
TextFix.BackgroundTransparency = 1
TextFix.Font = Bubble.Font
TextFix.Text = "BK CLIENT V4.5 †"
TextFix.TextColor3 = Bubble.TextColor3
TextFix.TextSize = Bubble.TextSize
TextFix.ZIndex = 2
Bubble.Text = ""

-- SISTEMA DE ESTRELAS
local MaxEstrelas = 10
local EstrelasPool = {}
local LinhasPool = {}

for i = 1, MaxEstrelas do
    local star = Instance.new("Frame", StarCanvas)
    star.Size = UDim2.new(0, 3, 0, 3)
    star.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    star.BackgroundTransparency = 0.3
    star.BorderSizePixel = 0
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    EstrelasPool[i] = {Frame = star, X = math.random(5, 145), Y = math.random(5, 35), VelX = (math.random() - 0.5) * 15, VelY = (math.random() - 0.5) * 15}
end

RunService.RenderStepped:Connect(function(deltaTime)
    for i = 1, MaxEstrelas do
        local s = EstrelasPool[i]
        s.X = s.X + (s.VelX * deltaTime) s.Y = s.Y + (s.VelY * deltaTime)
        if s.X < 2 or s.X > 148 then s.VelX = -s.VelX s.X = math.clamp(s.X, 2, 148) end
        if s.Y < 2 or s.Y > 38 then s.VelY = -s.VelY s.Y = math.clamp(s.Y, 2, 38) end
        s.Frame.Position = UDim2.new(0, s.X, 0, s.Y)
    end
    for _, l in ipairs(LinhasPool) do l.Visible = false end
    local linhaIndex = 1
    for i = 1, MaxEstrelas do
        for j = i + 1, MaxEstrelas do
            local s1 = EstrelasPool[i] local s2 = EstrelasPool[j]
            local dist = math.sqrt((s1.X - s2.X)^2 + (s1.Y - s2.Y)^2)
            if dist < 40 then
                local line = LinhasPool[linhaIndex]
                if not line then
                    line = Instance.new("Frame", StarCanvas) line.BorderSizePixel = 0 table.insert(LinhasPool, line)
                end
                line.BackgroundColor3 = C_RoxoNeon line.BackgroundTransparency = math.clamp((dist / 40), 0.4, 1)
                local origin = Vector2.new(s1.X, s1.Y) local target = Vector2.new(s2.X, s2.Y)
                line.Size = UDim2.new(0, (target - origin).Magnitude, 0, 1)
                line.AnchorPoint = Vector2.new(0.5, 0.5)
                line.Position = UDim2.new(0, (origin.X + target.X)/2, 0, (origin.Y + target.Y)/2)
                line.Rotation = math.deg(math.atan2(target.Y - origin.Y, target.X - origin.X))
                line.Visible = true
                linhaIndex = linhaIndex + 1
            end
        end
    end
end)

-- Arrastar Bolha
local dragBubble, dragInput, dragStart, startPos
Bubble.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragBubble = true dragStart = i.Position startPos = Bubble.Position
    end
end)
Bubble.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end end)
UserInputService.InputChanged:Connect(function(i)
    if i == dragInput and dragBubble then
        local delta = i.Position - dragStart
        Bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local painelAberto = false
Bubble.MouseButton1Click:Connect(function()
    if dragBubble then return end
    somClick()
    painelAberto = not painelAberto
    if painelAberto then
        Bubble.ZIndex = 10 MainPanel.Visible = true MainPanel.Size = UDim2.new(0, PainelLarguraAlvo, 0, 0)
        TweenService:Create(MainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, PainelLarguraAlvo, 0, PainelAlturaAlvo)}):Play()
    else
        Bubble.ZIndex = 5 local tween = TweenService:Create(MainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play() tween.Completed:Connect(function() if not painelAberto then MainPanel.Visible = false end end)
    end
end)

-- ========================================================
-- SISTEMA DE CARREGAMENTO INICIAL DO SAVE (BOOT)
-- ========================================================
if readfile and isfile and isfile(ArquivoSave) then
    local sucesso, conteudo = pcall(function() return readfile(ArquivoSave) end)
    if sucesso then
        local sucessoDecode, dadosSalvos = pcall(function() return HttpService:JSONDecode(conteudo) end)
        if sucessoDecode then
            -- Restaura Altura do Painel
            if dadosSalvos.PainelAltura then
                BK_Config.PainelAltura = dadosSalvos.PainelAltura
                PainelAlturaAlvo = dadosSalvos.PainelAltura
            end
            -- Restaura a Cor do Tema
            if dadosSalvos.TemaCor then
                BK_Config.TemaCor = dadosSalvos.TemaCor
                local corSalva = Color3.fromRGB(dadosSalvos.TemaCor[1], dadosSalvos.TemaCor[2], dadosSalvos.TemaCor[3])
                MudarCorTema(corSalva, true)
            end
            -- Restaura os Toggles salvos
            if dadosSalvos.Toggles then
                for k, v in pairs(dadosSalvos.Toggles) do
                    BK_Config.Toggles[k] = v
                end
            end
            EnviarNotificacao("Cloud Sec", "Configurações sincronizadas!")
        end
    end
else
    SalvarConfiguracoes() -- Cria o primeiro arquivo padrão caso não exista
end

-- Ativa visual padrão na primeira aba
TweenService:Create(botoesDeAbas["Visual"], TweenInfo.new(0.1), {TextColor3 = C_TextoClaro, BackgroundTransparency = 0.92}):Play()
if botoesDeAbas["Visual"]:FindFirstChild("Indicador") then botoesDeAbas["Visual"].Indicador.BackgroundTransparency = 0 end
