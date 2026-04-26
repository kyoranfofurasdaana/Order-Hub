-- [[ CONFIGURAÇÕES DO SCRIPT ]]
_G.AutoFishing = false
local tempoReinicio = 2
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local camera = game.Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- [[ INTERFACE ESTILO AZTUP HUB ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Frame Principal (Design Escuro)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Fundo Aztup
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Active = true
MainFrame.Draggable = true

-- Barra de Título
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -10, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.Text = "Aztup Hub | v3.52.6"
TitleText.TextColor3 = Color3.fromRGB(180, 180, 180)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.Code
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1

-- Container de Conteúdo
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1

-- [[ COMPONENTES: BOTÕES ESTILO HUB ]]

-- Botão Auto Fishing
local FishBtn = Instance.new("TextButton", Container)
FishBtn.Size = UDim2.new(1, 0, 0, 30)
FishBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FishBtn.BorderSizePixel = 1
FishBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
FishBtn.Text = "  ■ Auto Fishing"
FishBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Começa Vermelho
FishBtn.TextSize = 14
FishBtn.Font = Enum.Font.Code
FishBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Teleport (Coordenadas da imagem)
local TPBtn = Instance.new("TextButton", Container)
TPBtn.Size = UDim2.new(1, 0, 0, 30)
TPBtn.Position = UDim2.new(0, 0, 0, 40)
TPBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TPBtn.BorderSizePixel = 1
TPBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
TPBtn.Text = "  ■ TP to Water Position"
TPBtn.TextColor3 = Color3.fromRGB(0, 255, 127) -- Verde Aztup
TPBtn.TextSize = 14
TPBtn.Font = Enum.Font.Code
TPBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Debug Label (Status)
local DebugLabel = Instance.new("TextLabel", Container)
DebugLabel.Size = UDim2.new(1, 0, 0, 20)
DebugLabel.Position = UDim2.new(0, 0, 1, -20)
DebugLabel.BackgroundTransparency = 1
DebugLabel.Text = "> Status: Idle"
DebugLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
DebugLabel.TextSize = 12
DebugTextXAlignment = Enum.TextXAlignment.Left
DebugLabel.Font = Enum.Font.Code

-- [[ QUADRADO DE PESCA (ZONA) ]]
local ZoneFrame = Instance.new("Frame", ScreenGui)
ZoneFrame.Size = UDim2.new(0, 250, 0, 180)
ZoneFrame.Position = UDim2.new(0.5, -125, 0.4, -90)
ZoneFrame.BackgroundTransparency = 1 
ZoneFrame.BorderSizePixel = 2
ZoneFrame.BorderColor3 = Color3.fromRGB(0, 255, 127) -- Verde no quadrado também
ZoneFrame.Visible = false

local DragHandle = Instance.new("TextButton", ZoneFrame)
DragHandle.Size = UDim2.new(1, 0, 0, 20)
DragHandle.Position = UDim2.new(0, 0, -0.12, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
DragHandle.Text = "DRAG TO WATER"
DragHandle.TextColor3 = Color3.new(0, 0, 0)
DragHandle.TextSize = 10
DragHandle.Font = Enum.Font.Code
DragHandle.Draggable = true

-- [[ ESP MELHORADO PARA ITENS COLETÁVEIS ]]
local ESP_Ativo = false
local itensESP = {
    {nome = "Metal Scrap", cor = Color3.fromRGB(0, 255, 0)}, -- Verde neon
    -- Adicione mais itens aqui: {nome = "ItemName", cor = Color3.fromRGB(r,g,b)}
}
local ESP_Connections = {}

local function criarESP(objeto, cor)
    if objeto:FindFirstChild("ESPHighlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Parent = objeto
    highlight.FillColor = cor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    highlight.Adornee = objeto
end

local function removerESP(objeto)
    local h = objeto:FindFirstChild("ESPHighlight")
    if h then h:Destroy() end
end

local function monitorarItensESP()
    -- Limpa conexões antigas
    for _, conn in ipairs(ESP_Connections) do pcall(function() conn:Disconnect() end) end
    table.clear(ESP_Connections)
    
    local collectables = game.Workspace:FindFirstChild("Collectables")
    if not collectables then return end
    
    -- Destaca os itens já existentes
    for _, pasta in ipairs(collectables:GetChildren()) do
        for _, config in ipairs(itensESP) do
            if pasta.Name == config.nome then
                for _, item in ipairs(pasta:GetChildren()) do
                    criarESP(item, config.cor)
                end
            end
        end
    end
    -- Monitora novos itens
    table.insert(ESP_Connections, collectables.DescendantAdded:Connect(function(descendant)
        task.wait(0.2)
        for _, config in ipairs(itensESP) do
            if descendant.Parent and descendant.Parent.Name == config.nome then
                criarESP(descendant, config.cor)
            end
        end
    end))
    -- Remove ESP se o item sumir
    table.insert(ESP_Connections, collectables.DescendantRemoving:Connect(function(descendant)
        removerESP(descendant)
    end))
end

local function ativarESP()
    ESP_Ativo = true
    monitorarItensESP()
end

local function desativarESP()
    ESP_Ativo = false
    for _, conn in ipairs(ESP_Connections) do pcall(function() conn:Disconnect() end) end
    table.clear(ESP_Connections)
    -- Remove highlights existentes
    local collectables = game.Workspace:FindFirstChild("Collectables")
    if collectables then
        for _, pasta in ipairs(collectables:GetChildren()) do
            for _, item in ipairs(pasta:GetChildren()) do
                removerESP(item)
            end
        end
    end
end

-- Botão no hub para ativar/desativar ESP
local ESPBtn = Instance.new("TextButton", Container)
ESPBtn.Size = UDim2.new(1, 0, 0, 30)
ESPBtn.Position = UDim2.new(0, 0, 0, 80)
ESPBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ESPBtn.BorderSizePixel = 1
ESPBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
ESPBtn.Text = "  ■ ESP Itens Coletáveis"
ESPBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
ESPBtn.TextSize = 14
ESPBtn.Font = Enum.Font.Code
ESPBtn.TextXAlignment = Enum.TextXAlignment.Left

ESPBtn.MouseButton1Click:Connect(function()
    if ESP_Ativo then
        desativarESP()
        ESPBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        ESPBtn.Text = "  ■ ESP Itens Coletáveis"
        DebugLabel.Text = "> Status: ESP Desativado"
    else
        ativarESP()
        ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ESPBtn.Text = "  ■ ESP Ativo!"
        DebugLabel.Text = "> Status: ESP Ativo"
    end
end)

-- Opcional: Ativar ESP automaticamente ao iniciar
-- ativarESP()

-- [[ LÓGICA DE FUNCIONAMENTO ]]

local function clicarNaZona()
    local centroX = ZoneFrame.AbsolutePosition.X + (ZoneFrame.AbsoluteSize.X / 2)
    local centroY = ZoneFrame.AbsolutePosition.Y + (ZoneFrame.AbsoluteSize.Y / 2)
    vim:SendMouseButtonEvent(centroX, centroY, 0, true, game, 0)
    task.wait(0.1)
    vim:SendMouseButtonEvent(centroX, centroY, 0, false, game, 0)
end

-- Toggle Pesca
FishBtn.MouseButton1Click:Connect(function()
    _G.AutoFishing = not _G.AutoFishing
    ZoneFrame.Visible = _G.AutoFishing
    if _G.AutoFishing then
        FishBtn.TextColor3 = Color3.fromRGB(0, 255, 127) -- Verde Neon
        DebugLabel.Text = "> Status: Fishing Active"
    else
        FishBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Vermelho
        DebugLabel.Text = "> Status: Stopped"
    end
end)

-- Lógica Teleporte (Tween atravessa paredes)
TPBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        DebugLabel.Text = "> Status: Traveling..."
        local destino = CFrame.new(-3122.65, 149.17, -1405.69)
        local tempo = (hrp.Position - destino.Position).Magnitude / 60
        local tween = TweenService:Create(hrp, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = destino})
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        tween:Play()
        tween.Completed:Connect(function() 
            bv:Destroy() 
            DebugLabel.Text = "> Status: Destination Reached"
        end)
    end
end)

-- Loop de Pesca (Seu sistema original corrigido)
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFishing then
            local char = player.Character
            if char and char:FindFirstChildOfClass("Tool") then
                clicarNaZona()
                task.wait(3.5)
                local mordeu = false
                while _G.AutoFishing and not mordeu do
                    for _, obj in ipairs(game.Workspace:GetChildren()) do
                        if obj:IsA("BasePart") or obj:FindFirstChildOfClass("ParticleEmitter") then
                            local screenPos, onScreen = camera:WorldToScreenPoint(obj.Position)
                            if onScreen then
                                local relX = screenPos.X - ZoneFrame.AbsolutePosition.X
                                local relY = screenPos.Y - ZoneFrame.AbsolutePosition.Y
                                if relX > 0 and relX < ZoneFrame.AbsoluteSize.X and relY > 0 and relY < ZoneFrame.AbsoluteSize.Y then
                                    if obj.Name:lower():find("effect") or obj.Name:lower():find("splash") or obj.Name:lower():find("ring") then
                                        mordeu = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
                if mordeu and _G.AutoFishing then
                    clicarNaZona()
                    task.wait(tempoReinicio)
                end
            end
        end
    end
end)
