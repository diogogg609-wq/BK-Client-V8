-- =============================================================================
-- BK CLIENT V2.0 † - HIGH-END UI DESIGN
-- =============================================================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

-- Evita duplicatas do menu na tela
if CoreGui:FindFirstChild("BK_Client_V2") then
    CoreGui:FindFirstChild("BK_Client_V2"):Destroy()
end

-- Criando a ScreenGui principal
local BK_Client_V2 = Instance.new("ScreenGui")
BK_Client_V2.Name = "BK_Client_V2"
BK_Client_V2.Parent = CoreGui
BK_Client_V2.ResetOnSpawn = false

-- Paleta de Cores (Roxo e Preto)
local Cores = {
    FundoPrincipal = Color3.fromRGB(15, 15, 15),
    FundoLateral = Color3.fromRGB(10, 10, 10),
    RoxoPrincipal = Color3.fromRGB(120, 40, 200),
    RoxoEscuro = Color3.fromRGB(60, 20, 100),
    TextoClaro = Color3.fromRGB(240, 240, 240),
    TextoEscuro = Color3.fromRGB(140, 140, 140),
    Borda = Color3.fromRGB(30, 30, 30),
    VerdeStatus = Color3.fromRGB(46, 204, 113)
}

-- Sons Satisfatórios Nativos do Roblox
local SomClique = Instance.new("Sound")
SomClique.SoundId = "rbxassetid://6895079853"
SomClique.Volume = 0.5
SomClique.Parent = BK_Client_V2

local SomAbrir = Instance.new("Sound")
SomAbrir.SoundId = "rbxassetid://9114223165"
SomAbrir.Volume = 0.4
SomAbrir.Parent = BK_Client_V2

-- Tabela global de configurações das funções
local Opcoes = {
    -- ABA MIRA
    Aimbot = {
        Ativo = false,
        Parte = "Head", -- "Head" ou "Torso"
        Forca = 5, -- Suavização do Aimbot (1 = Ultra Suave, 10 = Travamento Bruto)
        AtrasParede = false -- Se true, mira através das paredes (ignora Raycast)
    },
    FOV = {
        Ativo = false,
        Cor = Color3.fromRGB(120, 40, 200),
        Tamanho = 100
    },
    -- ABA VISUAL
    ESP_Box = {Ativo = false, Cor = Color3.fromRGB(120, 40, 200)},
    ESP_Line = {Ativo = false, Cor = Color3.fromRGB(240, 240, 240)},
    ESP_Skeleton = {Ativo = false, Cor = Color3.fromRGB(120, 40, 200)},
    ESP_Distance = {Ativo = false, Cor = Color3.fromRGB(240, 240, 240), MaxDist = 380},
    ESP_Name = {Ativo = false, CorPainel = Color3.fromRGB(120, 40, 200), CorTexto = Color3.fromRGB(240, 240, 240), RGB = false},
    ESP_Health = {Ativo = false}
}

-- Armazenamento das instâncias visuais para limpeza e atualização em tempo real
local ElementosVisuais = {}

-- Instância de Desenho do Círculo de FOV
local CirculoFOV = Drawing.new("Circle")
CirculoFOV.Thickness = 1.5
CirculoFOV.Filled = false
CirculoFOV.Visible = false

-- =============================================================================
-- SISTEMA DE NOTIFICAÇÕES (BK System Notify)
-- =============================================================================
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Parent = BK_Client_V2
NotificationContainer.Size = UDim2.new(0, 280, 1, 0)
NotificationContainer.Position = UDim2.new(1, -290, 0, 0)
NotificationContainer.BackgroundTransparency = 1

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Parent = NotificationContainer
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Padding = UDim.new(0, 10)

local function Notificar(mensagem, duracao)
    duracao = duracao or 3.5
    task.spawn(function()
        pcall(function()
            SomAbrir:Play()
        end)
    end)

    local Card = Instance.new("Frame")
    local CardCorner = Instance.new("UICorner")
    local CardStroke = Instance.new("UIStroke")
    local Texto = Instance.new("TextLabel")
    local BarraProgresso = Instance.new("Frame")

    Card.Name = "Notif"
    Card.Size = UDim2.new(1, 0, 0, 50)
    Card.BackgroundColor3 = Cores.FundoLateral
    Card.BorderSizePixel = 0
    Card.BackgroundTransparency = 1
    Card.ClipsDescendants = true
    Card.Parent = NotificationContainer

    CardCorner.CornerRadius = UDim.new(0, 6)
    CardCorner.Parent = Card

    CardStroke.Thickness = 1.2
    CardStroke.Color = Cores.RoxoPrincipal
    CardStroke.Transparency = 1
    CardStroke.Parent = Card

    Texto.Parent = Card
    Texto.Size = UDim2.new(1, -20, 1, -6)
    Texto.Position = UDim2.new(0, 10, 0, 0)
    Texto.BackgroundTransparency = 1
    Texto.Text = "[BK CLIENT] " .. mensagem
    Texto.TextColor3 = Cores.TextoClaro
    Texto.Font = Enum.Font.Code
    Texto.TextSize = 11
    Texto.TextXAlignment = Enum.TextXAlignment.Left
    Texto.TextWrapped = true
    Texto.TextTransparency = 1

    BarraProgresso.Parent = Card
    BarraProgresso.Size = UDim2.new(1, 0, 0, 3)
    BarraProgresso.Position = UDim2.new(0, 0, 1, -3)
    BarraProgresso.BackgroundColor3 = Cores.RoxoPrincipal
    BarraProgresso.BorderSizePixel = 0
    BarraProgresso.BackgroundTransparency = 1

    TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.35), {Transparency = 0}):Play()
    TweenService:Create(Texto, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
    TweenService:Create(BarraProgresso, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()

    local animTime = TweenService:Create(BarraProgresso, TweenInfo.new(duracao, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)})
    animTime:Play()

    task.delay(duracao, function()
        local sumir = TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
        TweenService:Create(CardStroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
        TweenService:Create(Texto, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TweenService:Create(BarraProgresso, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        sumir:Play()
        sumir.Completed:Wait()
        Card:Destroy()
    end)
end

-- =============================================================================
-- SISTEMA DE DRAG (Arrastar Elementos)
-- =============================================================================
local function HabilitarArrastar(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- =============================================================================
-- CÁPSULA FLUTUANTE (Botão de Ativação) - 100% MÓVEL
-- =============================================================================
local Capsula = Instance.new("Frame")
local CapsulaCorner = Instance.new("UICorner")
local CapsulaStroke = Instance.new("UIStroke")
local CapsulaBotao = Instance.new("TextButton")

Capsula.Name = "Capsula"
Capsula.Parent = BK_Client_V2
Capsula.Size = UDim2.new(0, 170, 0, 38)
Capsula.Position = UDim2.new(0.1, 0, 0.1, 0)
Capsula.BackgroundColor3 = Cores.FundoPrincipal
Capsula.BorderSizePixel = 0
Capsula.ClipsDescendants = true
HabilitarArrastar(Capsula)

CapsulaCorner.CornerRadius = UDim.new(0.5, 0)
CapsulaCorner.Parent = Capsula

CapsulaStroke.Color = Cores.RoxoPrincipal
CapsulaStroke.Thickness = 1.5
CapsulaStroke.Parent = Capsula

CapsulaBotao.Name = "Botao"
CapsulaBotao.Parent = Capsula
CapsulaBotao.Size = UDim2.new(1, 0, 1, 0)
CapsulaBotao.BackgroundTransparency = 1
CapsulaBotao.Text = "BK CLIENT V2.0 †"
CapsulaBotao.TextColor3 = Cores.TextoClaro
CapsulaBotao.Font = Enum.Font.Code
CapsulaBotao.TextSize = 13
CapsulaBotao.Active = true

-- =============================================================================
-- PAINEL PRINCIPAL (Estilo PC Cheat)
-- =============================================================================
local Painel = Instance.new("Frame")
local PainelCorner = Instance.new("UICorner")
local PainelStroke = Instance.new("UIStroke")
local BarraLateral = Instance.new("Frame")
local LateralCorner = Instance.new("UICorner")
local AreaConteudo = Instance.new("Frame")

Painel.Name = "Painel"
Painel.Parent = BK_Client_V2
Painel.Size = UDim2.new(0, 580, 0, 360)
Painel.Position = UDim2.new(0.5, -290, 0.5, -180)
Painel.BackgroundColor3 = Cores.FundoPrincipal
Painel.BorderSizePixel = 0
Painel.Visible = false
Painel.ClipsDescendants = false
HabilitarArrastar(Painel)

PainelCorner.CornerRadius = UDim.new(0, 10)
PainelCorner.Parent = Painel

PainelStroke.Color = Cores.Borda
PainelStroke.Thickness = 1.2
PainelStroke.Parent = Painel

-- Barra Lateral (Menu Esquerdo)
BarraLateral.Name = "BarraLateral"
BarraLateral.Parent = Painel
BarraLateral.Size = UDim2.new(0, 160, 1, 0)
BarraLateral.BackgroundColor3 = Cores.FundoLateral
BarraLateral.BorderSizePixel = 0

LateralCorner.CornerRadius = UDim.new(0, 10)
LateralCorner.Parent = BarraLateral

local FlatPatch = Instance.new("Frame")
FlatPatch.Size = UDim2.new(0, 10, 1, 0)
FlatPatch.Position = UDim2.new(1, -10, 0, 0)
FlatPatch.BackgroundColor3 = Cores.FundoLateral
FlatPatch.BorderSizePixel = 0
FlatPatch.Parent = BarraLateral

local DivisorVertical = Instance.new("Frame")
DivisorVertical.Size = UDim2.new(0, 1, 1, 0)
DivisorVertical.Position = UDim2.new(1, 0, 0, 0)
DivisorVertical.BackgroundColor3 = Cores.Borda
DivisorVertical.BorderSizePixel = 0
DivisorVertical.Parent = BarraLateral

-- Painel de Conteúdo (Direita)
AreaConteudo.Name = "AreaConteudo"
AreaConteudo.Parent = Painel
AreaConteudo.Size = UDim2.new(1, -160, 1, 0)
AreaConteudo.Position = UDim2.new(0, 160, 0, 0)
AreaConteudo.BackgroundTransparency = 1

-- =============================================================================
-- PERFIL DO JOGADOR
-- =============================================================================
local ContainerPerfil = Instance.new("Frame")
local FotoPerfil = Instance.new("ImageLabel")
local FotoCorner = Instance.new("UICorner")
local InfoPerfil = Instance.new("Frame")
local NomeJogador = Instance.new("TextLabel")
local MarcaStatus = Instance.new("TextLabel")

ContainerPerfil.Name = "ContainerPerfil"
ContainerPerfil.Parent = BarraLateral
ContainerPerfil.Size = UDim2.new(1, 0, 0, 60)
ContainerPerfil.Position = UDim2.new(0, 0, 0, 15)
ContainerPerfil.BackgroundTransparency = 1

FotoPerfil.Name = "FotoPerfil"
FotoPerfil.Parent = ContainerPerfil
FotoPerfil.Size = UDim2.new(0, 36, 0, 36)
FotoPerfil.Position = UDim2.new(0, 15, 0.5, -18)
FotoPerfil.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
FotoPerfil.BackgroundColor3 = Cores.FundoPrincipal

FotoCorner.CornerRadius = UDim.new(1, 0)
FotoCorner.Parent = FotoPerfil

InfoPerfil.Name = "Info"
InfoPerfil.Parent = ContainerPerfil
InfoPerfil.Size = UDim2.new(1, -65, 1, 0)
InfoPerfil.Position = UDim2.new(0, 60, 0, 0)
InfoPerfil.BackgroundTransparency = 1

NomeJogador.Name = "Nome"
NomeJogador.Parent = InfoPerfil
NomeJogador.Size = UDim2.new(1, 0, 0.5, 0)
NomeJogador.Position = UDim2.new(0, 0, 0.1, 0)
NomeJogador.BackgroundTransparency = 1
NomeJogador.Text = string.upper(LocalPlayer.Name)
NomeJogador.TextColor3 = Cores.TextoClaro
NomeJogador.Font = Enum.Font.Code
NomeJogador.TextSize = 12
NomeJogador.TextXAlignment = Enum.TextXAlignment.Left

MarcaStatus.Name = "Marca"
MarcaStatus.Parent = InfoPerfil
MarcaStatus.Size = UDim2.new(1, 0, 0.5, 0)
MarcaStatus.Position = UDim2.new(0, 0, 0.5, 0)
MarcaStatus.BackgroundTransparency = 1
MarcaStatus.Text = "BK SYSTEM MEMBER"
MarcaStatus.TextColor3 = Cores.RoxoPrincipal
MarcaStatus.Font = Enum.Font.Code
MarcaStatus.TextSize = 9
MarcaStatus.TextXAlignment = Enum.TextXAlignment.Left

local SeparadorPerfil = Instance.new("Frame")
SeparadorPerfil.Size = UDim2.new(1, -30, 0, 1)
SeparadorPerfil.Position = UDim2.new(0, 15, 0, 85)
SeparadorPerfil.BackgroundColor3 = Cores.Borda
SeparadorPerfil.BorderSizePixel = 0
SeparadorPerfil.Parent = BarraLateral

-- =============================================================================
-- ESTRUTURA DE ABAS
-- =============================================================================
local ContainerBotoes = Instance.new("Frame")
local LayoutBotoes = Instance.new("UIListLayout")

ContainerBotoes.Name = "ContainerBotoes"
ContainerBotoes.Parent = BarraLateral
ContainerBotoes.Size = UDim2.new(1, -20, 1, -110)
ContainerBotoes.Position = UDim2.new(0, 10, 0, 100)
ContainerBotoes.BackgroundTransparency = 1

LayoutBotoes.Parent = ContainerBotoes
LayoutBotoes.SortOrder = Enum.SortOrder.LayoutOrder
LayoutBotoes.Padding = UDim.new(0, 6)

local AbasDefinidas = {"Mira", "Configurações", "Status", "Visual", "Extras"}
local ElementosAbas = {}
local PaginasInstanciadas = {}

for _, nomeAba in ipairs(AbasDefinidas) do
    local Pagina = Instance.new("Frame")
    Pagina.Name = "Pagina_" .. nomeAba
    Pagina.Parent = AreaConteudo
    Pagina.Size = UDim2.new(1, 0, 1, 0)
    Pagina.BackgroundTransparency = 1
    Pagina.Visible = false
    
    local TituloPagina = Instance.new("TextLabel")
    TituloPagina.Parent = Pagina
    TituloPagina.Size = UDim2.new(1, -30, 0, 40)
    TituloPagina.Position = UDim2.new(0, 20, 0, 20)
    TituloPagina.BackgroundTransparency = 1
    TituloPagina.Text = string.upper(nomeAba)
    TituloPagina.TextColor3 = Cores.TextoClaro
    TituloPagina.Font = Enum.Font.Code
    TituloPagina.TextSize = 16
    TituloPagina.TextXAlignment = Enum.TextXAlignment.Left
    
    local Sublinha = Instance.new("Frame")
    Sublinha.Size = UDim2.new(0, 30, 0, 2)
    Sublinha.Position = UDim2.new(0, 20, 0, 55)
    Sublinha.BackgroundColor3 = Cores.RoxoPrincipal
    Sublinha.BorderSizePixel = 0
    Sublinha.Parent = Pagina

    PaginasInstanciadas[nomeAba] = Pagina
end

-- =============================================================================
-- INTERFACE DA ABA "STATUS"
-- =============================================================================
local PaginaStatus = PaginasInstanciadas["Status"]
local StatusContent = Instance.new("Frame")
StatusContent.Name = "StatusContent"
StatusContent.Parent = PaginaStatus
StatusContent.Size = UDim2.new(1, -40, 1, -80)
StatusContent.Position = UDim2.new(0, 20, 0, 70)
StatusContent.BackgroundTransparency = 1

local StatusLayout = Instance.new("UIListLayout")
StatusLayout.Parent = StatusContent
StatusLayout.SortOrder = Enum.SortOrder.LayoutOrder
StatusLayout.Padding = UDim.new(0, 8)

local function CriarLinhaStatus(nome, valorInicial, layoutOrder)
    local Linha = Instance.new("Frame")
    local LinhaCorner = Instance.new("UICorner")
    local LinhaStroke = Instance.new("UIStroke")
    local TituloStatus = Instance.new("TextLabel")
    local ValorStatus = Instance.new("TextLabel")

    Linha.Name = "Status_" .. nome
    Linha.Size = UDim2.new(1, 0, 0, 36)
    Linha.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Linha.BorderSizePixel = 0
    Linha.LayoutOrder = layoutOrder
    Linha.Parent = StatusContent

    LinhaCorner.CornerRadius = UDim.new(0, 6)
    LinhaCorner.Parent = Linha

    LinhaStroke.Thickness = 1
    LinhaStroke.Color = Cores.Borda
    LinhaStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    LinhaStroke.Parent = Linha

    TituloStatus.Parent = Linha
    TituloStatus.Size = UDim2.new(0.5, -15, 1, 0)
    TituloStatus.Position = UDim2.new(0, 15, 0, 0)
    TituloStatus.BackgroundTransparency = 1
    TituloStatus.Text = string.upper(nome)
    TituloStatus.TextColor3 = Cores.TextoEscuro
    TituloStatus.Font = Enum.Font.Code
    TituloStatus.TextSize = 11
    TituloStatus.TextXAlignment = Enum.TextXAlignment.Left

    ValorStatus.Name = "Valor"
    ValorStatus.Parent = Linha
    ValorStatus.Size = UDim2.new(0.5, -15, 1, 0)
    ValorStatus.Position = UDim2.new(0.5, 0, 0, 0)
    ValorStatus.BackgroundTransparency = 1
    ValorStatus.Text = valorInicial
    ValorStatus.TextColor3 = Cores.TextoClaro
    ValorStatus.Font = Enum.Font.Code
    ValorStatus.TextSize = 11
    ValorStatus.TextXAlignment = Enum.TextXAlignment.Right

    return ValorStatus
end

local ValorFPS = CriarLinhaStatus("Taxa de Quadros (FPS)", "Calculando...", 1)
local ValorPing = CriarLinhaStatus("Latência de Rede (Ping)", "Calculando...", 2)
local ValorPlayers = CriarLinhaStatus("Jogadores no Servidor", "0/0", 3)
local ValorVersao = CriarLinhaStatus("Status do Cliente", "ATIVO / LICENCIADO", 4)
ValorVersao.TextColor3 = Cores.VerdeStatus

task.spawn(function()
    local LastIteration = os.clock()
    local FrameHistory = {}
    local FrameIndex = 1
    local UpdateInterval = 0.5
    local LastUIUpdate = 0

    while true do
        local CurrentTime = os.clock()
        local TimeDelta = CurrentTime - LastIteration
        LastIteration = CurrentTime

        FrameHistory[FrameIndex] = TimeDelta
        FrameIndex = (FrameIndex % 60) + 1

        if CurrentTime - LastUIUpdate >= UpdateInterval then
            LastUIUpdate = CurrentTime
            
            local TotalTime = 0
            local Count = 0
            for i = 1, #FrameHistory do
                if FrameHistory[i] then
                    TotalTime = TotalTime + FrameHistory[i]
                    Count = Count + 1
                end
            end
            local FPS = Count > 0 and math.round(Count / TotalTime) or 60
            ValorFPS.Text = tostring(FPS) .. " FPS"

            local Ping = math.round(Stats:GetNetworkStats().Ping)
            ValorPing.Text = tostring(Ping) .. " ms"

            local PlayerCount = #Players:GetPlayers()
            local MaxPlayers = Players.MaxPlayers
            ValorPlayers.Text = tostring(PlayerCount) .. " / " .. tostring(MaxPlayers)
        end
        RunService.RenderStepped:Wait()
    end
end)

-- =============================================================================
-- INTERFACE DO MENU DE CUSTOMIZAÇÃO RÁPIDA (Três Risquinhos '≡')
-- =============================================================================
local function CriarPainelConfiguracao(titulo, salvarCallback, extraComponentesCallback)
    local MiniPainel = Instance.new("Frame")
    local Corner = Instance.new("UICorner")
    local Stroke = Instance.new("UIStroke")
    local Header = Instance.new("TextLabel")
    local Fechar = Instance.new("TextButton")
    local Container = Instance.new("Frame")
    local Layout = Instance.new("UIListLayout")
    local BotaoSalvar = Instance.new("TextButton")
    local SalvarCorner = Instance.new("UICorner")

    MiniPainel.Name = "Config_" .. titulo
    MiniPainel.Size = UDim2.new(0, 220, 0, 180)
    MiniPainel.Position = UDim2.new(1, 10, 0, 20)
    MiniPainel.BackgroundColor3 = Cores.FundoPrincipal
    MiniPainel.BorderSizePixel = 0
    MiniPainel.Visible = false
    MiniPainel.Parent = Painel
    HabilitarArrastar(MiniPainel)

    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MiniPainel

    Stroke.Thickness = 1.2
    Stroke.Color = Cores.RoxoPrincipal
    Stroke.Parent = MiniPainel

    Header.Size = UDim2.new(1, -30, 0, 30)
    Header.Position = UDim2.new(0, 10, 0, 0)
    Header.BackgroundTransparency = 1
    Header.Text = string.upper(titulo)
    Header.TextColor3 = Cores.TextoClaro
    Header.Font = Enum.Font.Code
    Header.TextSize = 11
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = MiniPainel

    Fechar.Size = UDim2.new(0, 24, 0, 24)
    Fechar.Position = UDim2.new(1, -26, 0, 3)
    Fechar.BackgroundTransparency = 1
    Fechar.Text = "×"
    Fechar.TextColor3 = Cores.TextoEscuro
    Fechar.Font = Enum.Font.Code
    Fechar.TextSize = 16
    Fechar.Parent = MiniPainel
    Fechar.MouseButton1Click:Connect(function()
        MiniPainel.Visible = false
    end)

    Container.Size = UDim2.new(1, -20, 1, -75)
    Container.Position = UDim2.new(0, 10, 0, 35)
    Container.BackgroundTransparency = 1
    Container.Parent = MiniPainel

    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)

    BotaoSalvar.Size = UDim2.new(1, 0, 0, 28)
    BotaoSalvar.Position = UDim2.new(0, 10, 1, -38)
    BotaoSalvar.BackgroundColor3 = Cores.RoxoEscuro
    BotaoSalvar.BorderSizePixel = 0
    BotaoSalvar.Text = "SALVAR CONFIG"
    BotaoSalvar.TextColor3 = Cores.TextoClaro
    BotaoSalvar.Font = Enum.Font.Code
    BotaoSalvar.TextSize = 11
    BotaoSalvar.Parent = MiniPainel

    SalvarCorner.CornerRadius = UDim.new(0, 4)
    SalvarCorner.Parent = BotaoSalvar

    BotaoSalvar.MouseButton1Click:Connect(function()
        SomClique:Play()
        if salvarCallback then salvarCallback() end
        MiniPainel.Visible = false
        Notificar("Configurações salvas e aplicadas!", 2)
    end)

    if extraComponentesCallback then
        extraComponentesCallback(Container)
    end

    return MiniPainel
end

-- =============================================================================
-- GERADOR DE CORES INTERATIVAS (Componentes para Mini Painéis)
-- =============================================================================
local function AdicionarSeletorCores(parent, labelText, getCor, setCor)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Cores.TextoEscuro
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    local ContainerPaleta = Instance.new("Frame")
    ContainerPaleta.Size = UDim2.new(1, 0, 0, 24)
    ContainerPaleta.BackgroundTransparency = 1
    ContainerPaleta.Parent = parent

    local LayoutPaleta = Instance.new("UIListLayout")
    LayoutPaleta.FillDirection = Enum.FillDirection.Horizontal
    LayoutPaleta.SortOrder = Enum.SortOrder.LayoutOrder
    LayoutPaleta.Padding = UDim.new(0, 4)
    LayoutPaleta.Parent = ContainerPaleta

    local CoresSeletor = {
        Color3.fromRGB(120, 40, 200), -- Roxo BK
        Color3.fromRGB(231, 76, 60),   -- Vermelho
        Color3.fromRGB(46, 204, 113),  -- Verde
        Color3.fromRGB(52, 152, 219),  -- Azul
        Color3.fromRGB(241, 196, 15),  -- Amarelo
        Color3.fromRGB(255, 255, 255)  -- Branco
    }

    for i, cor in ipairs(CoresSeletor) do
        local BotaoCor = Instance.new("TextButton")
        local BotaoCorner = Instance.new("UICorner")
        local BotaoStroke = Instance.new("UIStroke")

        BotaoCor.Size = UDim2.new(0, 22, 1, 0)
        BotaoCor.BackgroundColor3 = cor
        BotaoCor.BorderSizePixel = 0
        BotaoCor.Text = ""
        BotaoCor.Parent = ContainerPaleta

        BotaoCorner.CornerRadius = UDim.new(0, 4)
        BotaoCorner.Parent = BotaoCor

        BotaoStroke.Thickness = 1
        BotaoStroke.Color = Cores.Borda
        BotaoStroke.Parent = BotaoCor

        BotaoCor.MouseButton1Click:Connect(function()
            setCor(cor)
            Notificar("Cor selecionada!", 1)
        end)
    end
end

-- =============================================================================
-- GERADOR DE SLIDER DINÂMICO
-- =============================================================================
local function AdicionarSlider(parent, labelText, min, max, defaultVal, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = labelText .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Cores.TextoEscuro
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    local SliderFrame = Instance.new("Frame")
    local Bar = Instance.new("Frame")
    local Fill = Instance.new("Frame")
    local Trigger = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")

    SliderFrame.Size = UDim2.new(1, 0, 0, 18)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0.5, -3)
    Bar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Bar.BorderSizePixel = 0
    Bar.Parent = SliderFrame

    Corner.CornerRadius = UDim.new(0.5, 0)
    Corner.Parent = Bar

    Fill.Size = UDim2.new((defaultVal - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Cores.RoxoPrincipal
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    Trigger.Size = UDim2.new(1, 0, 1, 0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""
    Trigger.Parent = SliderFrame

    local function UpdateVal(input)
        local scale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(scale, 0, 1, 0)
        local val = math.round(min + (scale * (max - min)))
        Label.Text = labelText .. ": " .. tostring(val)
        callback(val)
    end

    local segurando = false
    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            segurando = true
            UpdateVal(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if segurando and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateVal(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            segurando = false
        end
    end)
end

-- =============================================================================
-- GERADOR DE ENTRADA DO MÓDULO (Toggle Switch)
-- =============================================================================
local function CriarLinhaModulo(parent, titulo, configRef, layoutOrder, temConfig, customConfigCallback)
    local Frame = Instance.new("Frame")
    local Corner = Instance.new("UICorner")
    local Stroke = Instance.new("UIStroke")
    local Label = Instance.new("TextLabel")
    local ControlGroup = Instance.new("Frame")

    Frame.Name = "Mod_" .. titulo
    Frame.Size = UDim2.new(1, -10, 0, 44)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Frame.BorderSizePixel = 0
    Frame.LayoutOrder = layoutOrder
    Frame.Parent = parent

    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    Stroke.Thickness = 1
    Stroke.Color = Cores.Borda
    Stroke.Parent = Frame

    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = string.upper(titulo)
    Label.TextColor3 = Cores.TextoClaro
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    ControlGroup.Size = UDim2.new(0.5, -15, 1, 0)
    ControlGroup.Position = UDim2.new(0.5, 0, 0, 0)
    ControlGroup.BackgroundTransparency = 1
    ControlGroup.Parent = Frame

    local LayoutControle = Instance.new("UIListLayout")
    LayoutControle.FillDirection = Enum.FillDirection.Horizontal
    LayoutControle.HorizontalAlignment = Enum.HorizontalAlignment.Right
    LayoutControle.VerticalAlignment = Enum.VerticalAlignment.Center
    LayoutControle.Padding = UDim.new(0, 8)
    LayoutControle.Parent = ControlGroup

    local Switch = Instance.new("TextButton")
    local SwitchCorner = Instance.new("UICorner")
    local SwitchStroke = Instance.new("UIStroke")
    local Knob = Instance.new("Frame")
    local KnobCorner = Instance.new("UICorner")

    Switch.Size = UDim2.new(0, 42, 0, 22)
    Switch.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Switch.BorderSizePixel = 0
    Switch.Text = ""
    Switch.Parent = ControlGroup

    SwitchCorner.CornerRadius = UDim.new(0.5, 0)
    SwitchCorner.Parent = Switch

    SwitchStroke.Thickness = 1
    SwitchStroke.Color = Cores.Borda
    SwitchStroke.Parent = Switch

    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Cores.TextoEscuro
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch

    KnobCorner.CornerRadius = UDim.new(0.5, 0)
    KnobCorner.Parent = Knob

    local function RenderSwitch(anim)
        local targetPos = configRef.Ativo and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = configRef.Ativo and Cores.RoxoPrincipal or Color3.fromRGB(24, 24, 24)
        local targetKnob = configRef.Ativo and Cores.TextoClaro or Cores.TextoEscuro

        if anim then
            TweenService:Create(Knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos, BackgroundColor3 = targetKnob}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
        else
            Knob.Position = targetPos
            Knob.BackgroundColor3 = targetKnob
            Switch.BackgroundColor3 = targetColor
        end
    end

    Switch.MouseButton1Click:Connect(function()
        SomClique:Play()
        configRef.Ativo = not configRef.Ativo
        RenderSwitch(true)
        Notificar(titulo .. " " .. (configRef.Ativo and "Habilitado" or "Desabilitado"), 2)
    end)

    RenderSwitch(false)

    if temConfig and customConfigCallback then
        local ConfigBtn = Instance.new("TextButton")
        local ConfigCorner = Instance.new("UICorner")
        local ConfigStroke = Instance.new("UIStroke")

        ConfigBtn.Size = UDim2.new(0, 26, 0, 26)
        ConfigBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        ConfigBtn.BorderSizePixel = 0
        ConfigBtn.Text = "≡"
        ConfigBtn.TextColor3 = Cores.TextoClaro
        ConfigBtn.Font = Enum.Font.Code
        ConfigBtn.TextSize = 13
        ConfigBtn.Parent = ControlGroup

        ConfigCorner.CornerRadius = UDim.new(0, 4)
        ConfigCorner.Parent = ConfigBtn

        ConfigStroke.Thickness = 1
        ConfigStroke.Color = Cores.Borda
        ConfigStroke.Parent = ConfigBtn

        local PainelCustom = customConfigCallback()

        ConfigBtn.MouseButton1Click:Connect(function()
            SomClique:Play()
            PainelCustom.Visible = not PainelCustom.Visible
        end)
    end
end

-- =============================================================================
-- INTERFACE DA ABA "MIRA" (Aimbot & FOV Dinâmico)
-- =============================================================================
local PaginaMira = PaginasInstanciadas["Mira"]

local MiraScroll = Instance.new("ScrollingFrame")
MiraScroll.Size = UDim2.new(1, -20, 1, -80)
MiraScroll.Position = UDim2.new(0, 10, 0, 70)
MiraScroll.BackgroundTransparency = 1
MiraScroll.BorderSizePixel = 0
MiraScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
MiraScroll.ScrollBarThickness = 3
MiraScroll.ScrollBarImageColor3 = Cores.RoxoPrincipal
MiraScroll.Parent = PaginaMira

local MiraLayout = Instance.new("UIListLayout")
MiraLayout.SortOrder = Enum.SortOrder.LayoutOrder
MiraLayout.Padding = UDim.new(0, 8)
MiraLayout.Parent = MiraScroll

-- 1. Mini Painel do Aimbot (Seletor Head/Torso, Força)
local PainelAimbot = CriarPainelConfiguracao("Aimbot Config", nil, function(parent)
    -- Botão para Alternar Parte do Corpo
    local BtnParte = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")
    BtnParte.Size = UDim2.new(1, 0, 0, 24)
    BtnParte.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    BtnParte.Text = "ALVO: CABEÇA"
    BtnParte.TextColor3 = Cores.TextoClaro
    BtnParte.Font = Enum.Font.Code
    BtnParte.TextSize = 10
    BtnParte.Parent = parent
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = BtnParte

    BtnParte.MouseButton1Click:Connect(function()
        SomClique:Play()
        if Opcoes.Aimbot.Parte == "Head" then
            Opcoes.Aimbot.Parte = "Torso"
            BtnParte.Text = "ALVO: PEITO (TORSO)"
        else
            Opcoes.Aimbot.Parte = "Head"
            BtnParte.Text = "ALVO: CABEÇA"
        end
    end)

    -- Slider para regular a Suavização (Força do Imã)
    AdicionarSlider(parent, "Suavização (Força)", 1, 10, Opcoes.Aimbot.Forca, function(val)
        Opcoes.Aimbot.Forca = val
    end)
end)

-- Linha do Aimbot
CriarLinhaModulo(MiraScroll, "Aimbot Principal", Opcoes.Aimbot, 1, true, function() return PainelAimbot end)

-- Linha do Wallcheck (Atras da Parede)
CriarLinhaModulo(MiraScroll, "Mirar Atraves da Parede", {
    Ativo = Opcoes.AtrasParede,
    set = function(val) Opcoes.Aimbot.AtrasParede = val end
}, 2, false)
-- Ajuste dinâmico do toggle do Wallcheck diretamente nas configurações globais
local LinhaWall = MiraScroll:FindFirstChild("Mod_Mirar Atraves da Parede")
if LinhaWall then
    local SwitchBtn = LinhaWall:FindFirstChildOfClass("Frame"):FindFirstChildOfClass("TextButton")
    if SwitchBtn then
        SwitchBtn.MouseButton1Click:Connect(function()
            Opcoes.Aimbot.AtrasParede = not Opcoes.Aimbot.AtrasParede
            Notificar("Atras da Parede: " .. (Opcoes.Aimbot.AtrasParede and "ATIVADO" or "DESATIVADO"), 2)
        end)
    end
end

-- 2. Mini Painel do FOV
local PainelFOV = CriarPainelConfiguracao("FOV Config", nil, function(parent)
    AdicionarSeletorCores(parent, "Cor do Circulo", function() return Opcoes.FOV.Cor end, function(cor) Opcoes.FOV.Cor = cor end)
    AdicionarSlider(parent, "Tamanho (Raio)", 30, 300, Opcoes.FOV.Tamanho, function(val)
        Opcoes.FOV.Tamanho = val
    end)
end)

-- Linha do FOV
CriarLinhaModulo(MiraScroll, "Circulo FOV Visual", Opcoes.FOV, 3, true, function() return PainelFOV end)


-- =============================================================================
-- INTERFACE DA ABA "VISUAL"
-- =============================================================================
local PaginaVisual = PaginasInstanciadas["Visual"]

local VisualScroll = Instance.new("ScrollingFrame")
VisualScroll.Size = UDim2.new(1, -20, 1, -80)
VisualScroll.Position = UDim2.new(0, 10, 0, 70)
VisualScroll.BackgroundTransparency = 1
VisualScroll.BorderSizePixel = 0
VisualScroll.CanvasSize = UDim2.new(0, 0, 0, 450)
VisualScroll.ScrollBarThickness = 3
VisualScroll.ScrollBarImageColor3 = Cores.RoxoPrincipal
VisualScroll.Parent = PaginaVisual

local VisualLayout = Instance.new("UIListLayout")
VisualLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisualLayout.Padding = UDim.new(0, 8)
VisualLayout.Parent = VisualScroll

-- 1. ESP BOX
local PainelBox = CriarPainelConfiguracao("Box Config", nil, function(parent)
    AdicionarSeletorCores(parent, "Cor da Caixa", function() return Opcoes.ESP_Box.Cor end, function(cor) Opcoes.ESP_Box.Cor = cor end)
end)
CriarLinhaModulo(VisualScroll, "ESP Box", Opcoes.ESP_Box, 1, true, function() return PainelBox end)

-- 2. ESP LINE
CriarLinhaModulo(VisualScroll, "ESP Line", Opcoes.ESP_Line, 2, false)

-- 3. ESP SKELETON
local PainelSkel = CriarPainelConfiguracao("Skeleton Config", nil, function(parent)
    AdicionarSeletorCores(parent, "Cor das Articulações", function() return Opcoes.ESP_Skeleton.Cor end, function(cor) Opcoes.ESP_Skeleton.Cor = cor end)
end)
CriarLinhaModulo(VisualScroll, "ESP Esqueleto", Opcoes.ESP_Skeleton, 3, true, function() return PainelSkel end)

-- 4. ESP DISTANCE
local PainelDist = CriarPainelConfiguracao("Distance Config", nil, function(parent)
    AdicionarSeletorCores(parent, "Cor do Texto", function() return Opcoes.ESP_Distance.Cor end, function(cor) Opcoes.ESP_Distance.Cor = cor end)
    AdicionarSlider(parent, "Alcance Máximo (m)", 50, 380, Opcoes.ESP_Distance.MaxDist, function(val)
        Opcoes.ESP_Distance.MaxDist = val
    end)
end)
CriarLinhaModulo(VisualScroll, "ESP Distancia", Opcoes.ESP_Distance, 4, true, function() return PainelDist end)

-- 5. ESP NAME (Nome)
local PainelNome = CriarPainelConfiguracao("Name Config", nil, function(parent)
    AdicionarSeletorCores(parent, "Cor do Painel", function() return Opcoes.ESP_Name.CorPainel end, function(cor) Opcoes.ESP_Name.CorPainel = cor end)
    AdicionarSeletorCores(parent, "Cor do Texto", function() return Opcoes.ESP_Name.CorTexto end, function(cor) Opcoes.ESP_Name.CorTexto = cor end)
    
    local BtnRGB = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")
    BtnRGB.Size = UDim2.new(1, 0, 0, 24)
    BtnRGB.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    BtnRGB.Text = "EFEITO RGB: INATIVO"
    BtnRGB.TextColor3 = Cores.TextoEscuro
    BtnRGB.Font = Enum.Font.Code
    BtnRGB.TextSize = 10
    BtnRGB.Parent = parent
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = BtnRGB

    BtnRGB.MouseButton1Click:Connect(function()
        Opcoes.ESP_Name.RGB = not Opcoes.ESP_Name.RGB
        BtnRGB.Text = "EFEITO RGB: " .. (Opcoes.ESP_Name.RGB and "ATIVO" or "INATIVO")
        BtnRGB.TextColor3 = Opcoes.ESP_Name.RGB and Cores.RoxoPrincipal or Cores.TextoEscuro
    end)
end)
CriarLinhaModulo(VisualScroll, "ESP Nome", Opcoes.ESP_Name, 5, true, function() return PainelNome end)

-- 6. ESP HEALTH (Vida)
CriarLinhaModulo(VisualScroll, "ESP Vida", Opcoes.ESP_Health, 6, false)


-- =============================================================================
-- ENGINE DE DESENHO ESP E SISTEMA DE AIMBOT (MOBILE & PC)
-- =============================================================================
local Camera = workspace.CurrentCamera

local function CriarEsqueletoDesenho()
    local Linhas = {}
    for i = 1, 15 do
        local Linha = Drawing.new("Line")
        Linha.Thickness = 1.5
        Linha.Visible = false
        Linhas[i] = Linha
    end
    return Linhas
end

local function LimparJogador(player)
    if ElementosVisuais[player] then
        for _, obj in pairs(ElementosVisuais[player]) do
            if typeof(obj) == "table" then
                for _, subObj in pairs(obj) do subObj:Destroy() end
            else
                obj:Destroy()
            end
        end
        ElementosVisuais[player] = nil
    end
end

-- Verifica se há algum obstáculo entre a câmera e o alvo (Wallcheck)
local function EstaVisivel(personagem, parte)
    if Opcoes.Aimbot.AtrasParede then return true end
    if not personagem or not personagem:FindFirstChild(parte) then return false end
    
    local pontoOrigem = Camera.CFrame.Position
    local pontoDestino = personagem[parte].Position
    local direcao = (pontoDestino - pontoOrigem).Unit * (pontoDestino - pontoOrigem).Magnitude

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.IgnoreWater = true

    local resultado = workspace:Raycast(pontoOrigem, direcao, params)

    if resultado then
        return resultado.Instance:IsDescendantOf(personagem)
    end
    return true
end

-- Busca o jogador mais próximo da mira do jogador (Mobile & PC)
local function ObterJogadorMaisProximo()
    local menorDistancia = math.huge
    local jogadorAlvo = nil

    local centroTela = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                
                -- Detecta o alvo dinâmico (Cabeça ou Peito)
                local nomeParteAlvo = "Head"
                if Opcoes.Aimbot.Parte == "Torso" then
                    nomeParteAlvo = char:FindFirstChild("UpperTorso") and "UpperTorso" or "Torso"
                end

                local parteAlvo = char:FindFirstChild(nomeParteAlvo)
                if parteAlvo then
                    local pos, naTela = Camera:WorldToViewportPoint(parteAlvo.Position)

                    if naTela then
                        local distanciaFov = (Vector2.new(pos.X, pos.Y) - centroTela).Magnitude

                        -- Verifica se está dentro do limite do FOV e se respeita o Wallcheck
                        if distanciaFov <= Opcoes.FOV.Tamanho and distanciaFov < menorDistancia then
                            if EstaVisivel(char, nomeParteAlvo) then
                                menorDistancia = distanciaFov
                                jogadorAlvo = parteAlvo
                            end
                        end
                    end
                end
            end
        end
    end

    return jogadorAlvo
end

-- Loop de renderização contínua de todo o sistema
RunService.RenderStepped:Connect(function()
    
    -- 1. ATUALIZAÇÃO DO CÍRCULO DO FOV
    if Opcoes.FOV.Ativo then
        CirculoFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        CirculoFOV.Radius = Opcoes.FOV.Tamanho
        CirculoFOV.Color = Opcoes.FOV.Cor
        CirculoFOV.Visible = true
    else
        CirculoFOV.Visible = false
    end

    -- 2. ENGENHARIA DE TRAVAMENTO DO AIMBOT (MOBILE & PC)
    if Opcoes.Aimbot.Ativo then
        local alvo = ObterJogadorMaisProximo()
        if alvo then
            -- Suavização calculada de acordo com o Slider
            local smoothValue = math.clamp((11 - Opcoes.Aimbot.Forca) * 0.05, 0.01, 1)
            local posAlvo = Camera:WorldToViewportPoint(alvo.Position)
            local centroTela = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            -- Move a câmera suavemente em direção ao alvo
            local moverPara = (Vector2.new(posAlvo.X, posAlvo.Y) - centroTela) * smoothValue
            
            -- Função nativa de simulação de movimento de mouse/touch
            mousemoverel(moverPara.X, moverPara.Y)
        end
    end

    -- 3. RENDERIZADOR COMPLETO DA SUÍTE DE ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local root = char.HumanoidRootPart
                local hum = char.Humanoid
                local pos, visivel = Camera:WorldToViewportPoint(root.Position)

                if visivel then
                    local distanciaMetros = math.round((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) or 0)
                    
                    if not ElementosVisuais[player] then
                        ElementosVisuais[player] = {
                            Box = Drawing.new("Square"),
                            Line = Drawing.new("Line"),
                            Skeleton = CriarEsqueletoDesenho(),
                            Billboard = Instance.new("BillboardGui"),
                            BillboardFrame = Instance.new("Frame"),
                            BillboardLabel = Instance.new("TextLabel"),
                            HealthBar = Instance.new("Frame")
                        }
                        
                        local visual = ElementosVisuais[player]
                        visual.Billboard.Adornee = root
                        visual.Billboard.Size = UDim2.new(0, 110, 0, 45)
                        visual.Billboard.AlwaysOnTop = true
                        visual.Billboard.Parent = BK_Client_V2
                        
                        visual.BillboardFrame.Size = UDim2.new(1, 0, 0, 24)
                        visual.BillboardFrame.BackgroundColor3 = Opcoes.ESP_Name.CorPainel
                        visual.BillboardFrame.BorderSizePixel = 0
                        visual.BillboardFrame.Parent = visual.Billboard
                        local bCorner = Instance.new("UICorner")
                        bCorner.CornerRadius = UDim.new(0, 4)
                        bCorner.Parent = visual.BillboardFrame

                        visual.BillboardLabel.Size = UDim2.new(1, 0, 1, 0)
                        visual.BillboardLabel.BackgroundTransparency = 1
                        visual.BillboardLabel.Font = Enum.Font.Code
                        visual.BillboardLabel.TextColor3 = Opcoes.ESP_Name.CorTexto
                        visual.BillboardLabel.TextSize = 10
                        visual.BillboardLabel.Parent = visual.BillboardFrame

                        visual.HealthBar.Size = UDim2.new(1, 0, 0, 4)
                        visual.HealthBar.Position = UDim2.new(0, 0, 1, 3)
                        visual.HealthBar.BorderSizePixel = 0
                        visual.HealthBar.Parent = visual.BillboardFrame
                        local hCorner = Instance.new("UICorner")
                        hCorner.CornerRadius = UDim.new(0, 2)
                        hCorner.Parent = visual.HealthBar
                    end

                    local visual = ElementosVisuais[player]
                    local boxSize = Vector2.new(3000 / pos.Z, 4500 / pos.Z)
                    local boxPos = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)

                    -- Render da Caixa
                    if Opcoes.ESP_Box.Ativo then
                        visual.Box.Size = boxSize
                        visual.Box.Position = boxPos
                        visual.Box.Color = Opcoes.ESP_Box.Cor
                        visual.Box.Thickness = 1.2
                        visual.Box.Filled = false
                        visual.Box.Visible = true
                    else
                        visual.Box.Visible = false
                    end

                    -- Render da Linha
                    if Opcoes.ESP_Line.Ativo then
                        visual.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        visual.Line.To = Vector2.new(pos.X, pos.Y)
                        visual.Line.Color = Opcoes.ESP_Line.Cor
                        visual.Line.Thickness = 1
                        visual.Line.Visible = true
                    else
                        visual.Line.Visible = false
                    end

                    -- Render da Distância
                    if Opcoes.ESP_Distance.Ativo and distanciaMetros <= Opcoes.ESP_Distance.MaxDist then
                        visual.Billboard.Enabled = true
                        visual.Billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
                        
                        if not Opcoes.ESP_Name.Ativo then
                            visual.BillboardFrame.BackgroundTransparency = 1
                            visual.BillboardLabel.Text = "[" .. tostring(distanciaMetros) .. "m]"
                            visual.BillboardLabel.TextColor3 = Opcoes.ESP_Distance.Cor
                        else
                            visual.BillboardFrame.BackgroundTransparency = 0
                        end
                    end

                    -- Render do Nome e da Barra de Vida
                    if Opcoes.ESP_Name.Ativo then
                        visual.Billboard.Enabled = true
                        visual.BillboardFrame.BackgroundTransparency = 0
                        
                        if Opcoes.ESP_Name.RGB then
                            local hue = (tick() % 4) / 4
                            visual.BillboardFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.8)
                        else
                            visual.BillboardFrame.BackgroundColor3 = Opcoes.ESP_Name.CorPainel
                        end

                        visual.BillboardLabel.TextColor3 = Opcoes.ESP_Name.CorTexto
                        
                        local textoExibir = string.upper(player.Name)
                        if Opcoes.ESP_Distance.Ativo then
                            textoExibir = textoExibir .. " (" .. tostring(distanciaMetros) .. "m)"
                        end
                        visual.BillboardLabel.Text = textoExibir

                        if Opcoes.ESP_Health.Ativo then
                            visual.HealthBar.Visible = true
                            local percent = hum.Health / hum.MaxHealth
                            visual.HealthBar.Size = UDim2.new(percent, 0, 0, 4)
                            
                            if percent > 0.5 then
                                visual.HealthBar.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                            elseif percent > 0.2 then
                                visual.HealthBar.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
                            else
                                visual.HealthBar.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
                            end
                        else
                            visual.HealthBar.Visible = false
                        end
                    else
                        if not Opcoes.ESP_Distance.Ativo then
                            visual.Billboard.Enabled = false
                        end
                    end

                    -- Render do Esqueleto (R6 e R15)
                    if Opcoes.ESP_Skeleton.Ativo then
                        local parts = {}
                        local skeletonCor = Opcoes.ESP_Skeleton.Cor
                        local connections = {}

                        if hum.RigType == Enum.HumanoidRigType.R15 then
                            parts = {
                                Head = char:FindFirstChild("Head"),
                                UpperTorso = char:FindFirstChild("UpperTorso"),
                                LowerTorso = char:FindFirstChild("LowerTorso"),
                                LeftUpperArm = char:FindFirstChild("LeftUpperArm"),
                                LeftLowerArm = char:FindFirstChild("LeftLowerArm"),
                                RightUpperArm = char:FindFirstChild("RightUpperArm"),
                                RightLowerArm = char:FindFirstChild("RightLowerArm"),
                                LeftUpperLeg = char:FindFirstChild("LeftUpperLeg"),
                                LeftLowerLeg = char:FindFirstChild("LeftLowerLeg"),
                                RightUpperLeg = char:FindFirstChild("RightUpperLeg"),
                                RightLowerLeg = char:FindFirstChild("RightLowerLeg")
                            }

                            connections = {
                                {parts.Head, parts.UpperTorso},
                                {parts.UpperTorso, parts.LowerTorso},
                                {parts.UpperTorso, parts.LeftUpperArm},
                                {parts.LeftUpperArm, parts.LeftLowerArm},
                                {parts.UpperTorso, parts.RightUpperArm},
                                {parts.RightUpperArm, parts.RightLowerArm},
                                {parts.LowerTorso, parts.LeftUpperLeg},
                                {parts.LeftUpperLeg, parts.LeftLowerLeg},
                                {parts.LowerTorso, parts.RightUpperLeg},
                                {parts.RightUpperLeg, parts.RightLowerLeg}
                            }
                        else
                            parts = {
                                Head = char:FindFirstChild("Head"),
                                Torso = char:FindFirstChild("Torso"),
                                LeftArm = char:FindFirstChild("Left Arm"),
                                RightArm = char:FindFirstChild("Right Arm"),
                                LeftLeg = char:FindFirstChild("Left Leg"),
                                RightLeg = char:FindFirstChild("Right Leg")
                            }

                            connections = {
                                {parts.Head, parts.Torso},
                                {parts.Torso, parts.LeftArm},
                                {parts.Torso, parts.RightArm},
                                {parts.Torso, parts.LeftLeg},
                                {parts.Torso, parts.RightLeg}
                            }
                        end

                        local lineIdx = 1
                        for _, conn in ipairs(connections) do
                            local p1, p2 = conn[1], conn[2]
                            if p1 and p2 then
                                local v1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                                local v2, vis2 = Camera:WorldToViewportPoint(p2.Position)

                                if vis1 and vis2 then
                                    local lDraw = visual.Skeleton[lineIdx]
                                    if lDraw then
                                        lDraw.From = Vector2.new(v1.X, v1.Y)
                                        lDraw.To = Vector2.new(v2.X, v2.Y)
                                        lDraw.Color = skeletonCor
                                        lDraw.Visible = true
                                        lineIdx = lineIdx + 1
                                    end
                                end
                            end
                        end

                        for i = lineIdx, #visual.Skeleton do
                            visual.Skeleton[i].Visible = false
                        end
                    else
                        for _, lDraw in ipairs(visual.Skeleton) do lDraw.Visible = false end
                    end

                else
                    LimparJogador(player)
                end
            else
                LimparJogador(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(LimparJogador)

-- =============================================================================
-- LOGICA DE ALTERNAR ABAS
-- =============================================================================
local function AlternarAba(nomeSelecionado)
    SomClique:Play()
    for nomeAba, botao in pairs(ElementosAbas) do
        local animTime = 0.2
        if nomeAba == nomeSelecionado then
            TweenService:Create(botao, TweenInfo.new(animTime), {TextColor3 = Cores.TextoClaro, BackgroundColor3 = Color3.fromRGB(22, 17, 30)}):Play()
            TweenService:Create(botao:FindFirstChildOfClass("UIStroke"), TweenInfo.new(animTime), {Color = Cores.RoxoPrincipal}):Play()
            PaginasInstanciadas[nomeAba].Visible = true
        else
            TweenService:Create(botao, TweenInfo.new(animTime), {TextColor3 = Cores.TextoEscuro, BackgroundColor3 = Color3.fromRGB(12, 12, 12)}):Play()
            TweenService:Create(botao:FindFirstChildOfClass("UIStroke"), TweenInfo.new(animTime), {Color = Color3.fromRGB(18, 18, 18)}):Play()
            PaginasInstanciadas[nomeAba].Visible = false
        end
    end
end

-- Geração dos botões das abas laterais
for i, nomeAba in ipairs(AbasDefinidas) do
    local BotaoAba = Instance.new("TextButton")
    local BotaoCorner = Instance.new("UICorner")
    local BotaoStroke = Instance.new("UIStroke")

    BotaoAba.Name = "Botao_" .. nomeAba
    BotaoAba.Parent = ContainerBotoes
    BotaoAba.Size = UDim2.new(1, 0, 0, 32)
    BotaoAba.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    BotaoAba.BorderSizePixel = 0
    BotaoAba.Text = "  " .. string.upper(nomeAba)
    BotaoAba.TextColor3 = Cores.TextoEscuro
    BotaoAba.Font = Enum.Font.Code
    BotaoAba.TextSize = 11
    BotaoAba.TextXAlignment = Enum.TextXAlignment.Left
    BotaoAba.LayoutOrder = i

    BotaoCorner.CornerRadius = UDim.new(0, 6)
    BotaoCorner.Parent = BotaoAba

    BotaoStroke.Thickness = 1
    BotaoStroke.Color = Color3.fromRGB(18, 18, 18)
    BotaoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BotaoStroke.Parent = BotaoAba

    ElementosAbas[nomeAba] = BotaoAba

    BotaoAba.MouseButton1Click:Connect(function()
        AlternarAba(nomeAba)
    end)
end

AlternarAba("Mira")

-- =============================================================================
-- LOGICA DE TRANSIÇÃO E ANIMAÇÃO DO PAINEL PRINCIPAL
-- =============================================================================
local PainelAberto = false
local EmAnimacao = false

local function AlternarPainel()
    if EmAnimacao then return end
    EmAnimacao = true

    if not PainelAberto then
        SomAbrir:Play()
        local tweenCapsula = TweenService:Create(Capsula, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 38),
            BackgroundTransparency = 1
        })
        tweenCapsula:Play()
        tweenCapsula.Completed:Wait()
        Capsula.Visible = false

        Painel.Size = UDim2.new(0, 520, 0, 320)
        Painel.BackgroundTransparency = 1
        Painel.Visible = true

        local tweenPainel = TweenService:Create(Painel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 580, 0, 360),
            BackgroundTransparency = 0
        })
        tweenPainel:Play()
        tweenPainel.Completed:Wait()

        PainelAberto = true
    else
        SomAbrir:Play()
        local tweenPainel = TweenService:Create(Painel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 520, 0, 320),
            BackgroundTransparency = 1
        })
        tweenPainel:Play()
        tweenPainel.Completed:Wait()
        Painel.Visible = false

        Capsula.Size = UDim2.new(0, 0, 0, 38)
        Capsula.BackgroundTransparency = 1
        Capsula.Visible = true

        local tweenCapsula = TweenService:Create(Capsula, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 170, 0, 38),
            BackgroundTransparency = 0
        })
        tweenCapsula:Play()
        tweenCapsula.Completed:Wait()

        PainelAberto = false
    end

    EmAnimacao = false
end

CapsulaBotao.MouseButton1Click:Connect(AlternarPainel)

-- Botão de Minimizar interno dentro do Painel (Canto superior direito)
local BotaoMinimizar = Instance.new("TextButton")
BotaoMinimizar.Parent = Painel
BotaoMinimizar.Size = UDim2.new(0, 24, 0, 24)
BotaoMinimizar.Position = UDim2.new(1, -34, 0, 10)
BotaoMinimizar.BackgroundTransparency = 1
BotaoMinimizar.Text = "—"
BotaoMinimizar.TextColor3 = Cores.TextoEscuro
BotaoMinimizar.Font = Enum.Font.Code
BotaoMinimizar.TextSize = 14

BotaoMinimizar.MouseEnter:Connect(function()
    TweenService:Create(BotaoMinimizar, TweenInfo.new(0.15), {TextColor3 = Cores.RoxoPrincipal}):Play()
end)

BotaoMinimizar.MouseLeave:Connect(function()
    TweenService:Create(BotaoMinimizar, TweenInfo.new(0.15), {TextColor3 = Cores.TextoEscuro}):Play()
end)

BotaoMinimizar.MouseButton1Click:Connect(AlternarPainel)

-- Boas-vindas inicial estético
task.spawn(function()
    task.wait(1)
    Notificar("BK CLIENT V2.0 Carregado!", 3)
end)
