
-- A1: Definição da Tabela Principal
local NomadLib = {}

-- A2: Definição de Serviços e Módulos
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- A3: Configurações e Tema
local Theme = {
    -- Cores de Fundo
    Sidebar = Color3.fromRGB(35, 35, 40),
    Content = Color3.fromRGB(30, 30, 35),
    Section = Color3.fromRGB(45, 45, 50),
    
    -- Cores de Destaque
    Accent = Color3.fromRGB(0, 115, 255),
    ActiveTab = Color3.fromRGB(40, 42, 48),
    
    -- Cores de Texto
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    
    -- Cores de Divisórias e Bordas
    Divider = Color3.fromRGB(50, 50, 55),
}

-- A4: Funções Utilitárias Internas
local function Create(instanceType, properties)
    local inst = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        inst[prop] = value
    end
    return inst
end

-- A5: Início da API Principal - Função CreateWindow
function NomadLib.CreateWindow(options)
    local windowOptions = options or {}
    local localPlayer = Players.LocalPlayer
    
    -- A6: Criação dos Elementos Gráficos Base (ScreenGui, WindowFrame, etc.)
   --[ Início do Bloco para A6 ]--
    local ScreenGui = Create("ScreenGui", { Name = "NomadLib_UI", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, Enabled = true })
    local WindowFrame = Create("Frame", { Name = "WindowFrame", Parent = ScreenGui, Size = windowOptions.Size or UDim2.fromOffset(600, 400), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Visible = true })
    local Corner = Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = WindowFrame })
    local SidebarFrame = Create("Frame", { Name = "Sidebar", Parent = WindowFrame, Size = UDim2.new(0, 180, 1, 0), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0 })
    local ContentFrame = Create("Frame", { Name = "Content", Parent = WindowFrame, Size = UDim2.new(1, -180, 1, 0), Position = UDim2.new(0, 180, 0, 0), BackgroundColor3 = Theme.Content, BorderSizePixel = 0, ClipsDescendants = true })
    local Divider = Create("Frame", { Name = "Divider", Parent = WindowFrame, Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0, 180, 0, 0), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 })
--[ Fim do Bloco para A6 ]-- 
    
    -- A7: Lógica de Arrastar a Janela (Drag)
--[ Início do Bloco para A7 ]--
    local dragging = false
    local dragStart, startPos
    WindowFrame.InputBegan:Connect(function(input)
        local mousePos = UserInputService:GetMouseLocation()
        local sidebarPos = SidebarFrame.AbsolutePosition
        local sidebarSize = SidebarFrame.AbsoluteSize
        if (mousePos.X >= sidebarPos.X and mousePos.X <= sidebarPos.X + sidebarSize.X and mousePos.Y >= sidebarPos.Y and mousePos.Y <= sidebarPos.Y + sidebarSize.Y) then
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = WindowFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            WindowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
--[ Fim do Bloco para A7 ]--
    
    -- A8: Criação do Cabeçalho e Rodapé da Sidebar
    --[ Início do Bloco para A8 ]--
    local SidebarHeader = Create("Frame", { Name = "Header", Parent = SidebarFrame, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1 })
    local TitleLabel = Create("TextLabel", { Name = "Title", Parent = SidebarHeader, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = windowOptions.Title or "NomadLib", TextColor3 = Theme.TextPrimary, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center })
    
    local SidebarFooter = Create("Frame", { Name = "Footer", Parent = SidebarFrame, Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 1, -50), BackgroundTransparency = 1 })
    local UserIcon = Create("ImageLabel", { Name = "UserIcon", Parent = SidebarFooter, Size = UDim2.fromOffset(30, 30), Position = UDim2.new(0, 20, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://15260341710" })
    local UserCorner = Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = UserIcon })
    local UserName = Create("TextLabel", { Name = "UserName", Parent = SidebarFooter, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 60, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = localPlayer.Name, TextColor3 = Theme.TextPrimary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center })
--[ Fim do Bloco para A8 ]--
    
    -- A9: Lógica do Atalho de Teclado (Keybind)
--[ Início do Bloco para A9 ]--
    local keybind = windowOptions.Keybind or Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keybind then
            WindowFrame.Visible = not WindowFrame.Visible
        end
    end)
--[ Fim do Bloco para A9 ]--
    
    -- A10: Estrutura para Abas (Tabs) e Variáveis de Controle
    --[ Início do Bloco para A10 ]--
    local TabsContainer = Create("ScrollingFrame", { Name = "TabsContainer", Parent = SidebarFrame, Size = UDim2.new(1, 0, 1, -100), Position = UDim2.new(0, 0, 0, 50), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0) })
    local TabsLayout = Create("UIListLayout", { Parent = TabsContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })

    local createdTabs = {}
    local activeTab = nil
--[ Fim do Bloco para A10 ]--
    
    -- A11: Retorno da API da Janela e Definição da Função AddTab
    local WindowAPI = {}

    function WindowAPI:AddTab(tabOptions)
        local tabData = {}
        local TabAPI = {}

        -- A12: Criação dos Elementos Gráficos da Aba (Botão, Página de Conteúdo)
--[ Início do Bloco para A12 ]--
        local TabButton = Create("TextButton", { Name = tabOptions.Name, Parent = TabsContainer, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Sidebar, AutoButtonColor = false, Text = "" })
        local TabIcon = Create("ImageLabel", { Name = "Icon", Parent = TabButton, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(0, 20, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = tabOptions.Icon or "", ImageColor3 = Theme.TextSecondary })
        local TabName = Create("TextLabel", { Name = "Name", Parent = TabButton, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 50, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = tabOptions.Name or "Tab", TextColor3 = Theme.TextSecondary, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left })
        
        local ContentPage = Create("ScrollingFrame", { Name = tabOptions.Name .. "_Content", Parent = ContentFrame, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, Visible = false, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0) })
        local PageLayout = Create("UIListLayout", { Parent = ContentPage, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
        local PagePadding = Create("UIPadding", { Parent = ContentPage, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })

        tabData.Button, tabData.Page, tabData.Icon, tabData.Name = TabButton, ContentPage, TabIcon, TabName
        table.insert(createdTabs, tabData)
--[ Fim do Bloco para A12 ]--
        
        -- A13: Lógica para Ativar/Desativar Abas (Função SetActive)
--[ Início do Bloco para A13 ]--
        local function SetActive()
            if activeTab == tabData then return end

            -- Desativa a aba antiga (se houver uma)
            if activeTab then
                activeTab.Page.Visible = false
                TweenService:Create(activeTab.Button, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Sidebar }):Play()
                TweenService:Create(activeTab.Icon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextSecondary }):Play()
                TweenService:Create(activeTab.Name, TweenInfo.new(0.2), { TextColor3 = Theme.TextSecondary }):Play()
            end

            -- Ativa a nova aba
            tabData.Page.Visible = true
            TweenService:Create(tabData.Button, TweenInfo.new(0.2), { BackgroundColor3 = Theme.ActiveTab }):Play()
            TweenService:Create(tabData.Icon, TweenInfo.new(0.2), { ImageColor3 = Theme.Accent }):Play()
            TweenService:Create(tabData.Name, TweenInfo.new(0.2), { TextColor3 = Theme.TextPrimary }):Play()
            
            activeTab = tabData
        end
--[ Fim do Bloco para A13 ]--
        
        -- A14: Conexão do Evento de Clique e Ativação da Primeira Aba
--[ Início do Bloco para A14 ]--
        TabButton.MouseButton1Click:Connect(SetActive)

        -- Se for a primeira aba criada, ativa ela por padrão
        if #createdTabs == 1 then
            SetActive()
        end
--[ Fim do Bloco para A14 ]--        
        
        -- A15: Definição da Função TabAPI:AddSection
        function TabAPI:AddSection(sectionOptions)
            local SectionAPI = {}

            -- A16: Criação dos Elementos Gráficos da Seção
            --[ Início do Bloco para A16 ]--
            local SectionFrame = Create("Frame", { Name = sectionOptions.Title or "Section", Parent = tabData.Page, Size = UDim2.new(1, 0, 0, 30), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
            local SectionLayout = Create("UIListLayout", { Parent = SectionFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
            local SectionTitle = Create("TextLabel", { Name = "Title", Parent = SectionFrame, Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = sectionOptions.Title or "Section", TextColor3 = Theme.TextPrimary, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left })
            local SectionDivider = Create("Frame", { Name = "Divider", Parent = SectionFrame, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 })
            
            SectionAPI.Container = SectionFrame
            SectionAPI.Page = tabData.Page
--[ Fim do Bloco para A16 ]--
            
            -- A17: Definição das Funções de Componentes (AddToggle, AddSlider, etc.)
            
--[ Início do Bloco para A17 ]--
            function SectionAPI:AddToggle(toggleOptions)
                local ToggleAPI = {}
                local currentValue = toggleOptions.Default or false

                local ToggleButton = Create("TextButton", {
                    Name = toggleOptions.Name or "Toggle",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                })

                local ToggleName = Create("TextLabel", {
                    Name = "Name",
                    Parent = ToggleButton,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.fromScale(0, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = toggleOptions.Name or "Toggle",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local Switch = Create("Frame", {
                    Name = "Switch",
                    Parent = ToggleButton,
                    Size = UDim2.fromOffset(40, 20),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                })

                local SwitchLayout = Create("UIListLayout", {
                    Parent = Switch,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4),
                })

                local Dot1 = Create("Frame", { Parent = Switch, Size = UDim2.fromOffset(4, 4), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 })
                local Dot2 = Create("Frame", { Parent = Switch, Size = UDim2.fromOffset(4, 4), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 })
                local Dot3 = Create("Frame", { Parent = Switch, Size = UDim2.fromOffset(4, 4), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 })
                Create("UICorner", { Parent = Dot1, CornerRadius = UDim.new(1,0) })
                Create("UICorner", { Parent = Dot2, CornerRadius = UDim.new(1,0) })
                Create("UICorner", { Parent = Dot3, CornerRadius = UDim.new(1,0) })
                
                local function SetState(state, playTween)
                    currentValue = state
                    local color = state and Theme.Accent or Theme.Divider
                    local duration = playTween and 0.2 or 0
                    
                    TweenService:Create(Dot1, TweenInfo.new(duration), { BackgroundColor3 = color }):Play()
                    TweenService:Create(Dot2, TweenInfo.new(duration), { BackgroundColor3 = color }):Play()
                    TweenService:Create(Dot3, TweenInfo.new(duration), { BackgroundColor3 = color }):Play()
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    SetState(not currentValue, true)
                    if toggleOptions.Callback then
                        task.spawn(toggleOptions.Callback, currentValue)
                    end
                end)
                
                SetState(currentValue, false) -- Define o estado inicial

                return ToggleAPI
            end

--[ Fim do Bloco para A17 ]--

--[ Início do Bloco para A17 - Slider ]--
            function SectionAPI:AddSlider(sliderOptions)
                local SliderAPI = {}
                local min, max, default = sliderOptions.Min or 0, sliderOptions.Max or 100, sliderOptions.Default or 0
                local callback = sliderOptions.Callback or function() end
                
                local dragging = false
                
                local SliderFrame = Create("Frame", {
                    Name = sliderOptions.Name or "Slider",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                })
                
                local SliderName = Create("TextLabel", {
                    Name = "Name",
                    Parent = SliderFrame,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = sliderOptions.Name or "Slider",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local ValueLabel = Create("TextLabel", {
                    Name = "ValueLabel",
                    Parent = SliderFrame,
                    Size = UDim2.new(0, 50, 1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold,
                    Text = default,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                local Track = Create("Frame", {
                    Name = "Track",
                    Parent = SliderFrame,
                    Size = UDim2.new(0.5, -60, 0, 4),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Theme.Divider,
                    BorderSizePixel = 0,
                })
                local TrackCorner = Create("UICorner", { Parent = Track, CornerRadius = UDim.new(1,0) })
                
                local Fill = Create("Frame", {
                    Name = "Fill",
                    Parent = Track,
                    Size = UDim2.fromScale(0, 1),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                })
                local FillCorner = Create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1,0) })
                
                local Thumb = Create("Frame", {
                    Name = "Thumb",
                    Parent = Track,
                    Size = UDim2.fromOffset(12, 12),
                    Position = UDim2.fromScale(0, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Theme.TextPrimary,
                    BorderSizePixel = 0,
                })
                local ThumbCorner = Create("UICorner", { Parent = Thumb, CornerRadius = UDim.new(1,0) })
                
                local Hitbox = Create("TextButton", {
                    Name = "Hitbox",
                    Parent = Track,
                    Size = UDim2.new(1, 0, 3, 0),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Text = "",
                })

                local function UpdateSlider(inputPosition)
                    local relativeX = inputPosition.X - Track.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percentage
                    
                    Fill.Size = UDim2.new(percentage, 0, 1, 0)
                    Thumb.Position = UDim2.new(percentage, 0, 0.5, 0)
                    ValueLabel.Text = string.format("%.0f", value)
                    
                    task.spawn(callback, value)
                end
                
                -- Set initial state
                local initialPercent = (default - min) / (max - min)
                Fill.Size = UDim2.new(initialPercent, 0, 1, 0)
                Thumb.Position = UDim2.new(initialPercent, 0, 0.5, 0)

                Hitbox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(input.Position)
                    end
                end)
                
                Hitbox.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input.Position)
                    end
                end)

                return SliderAPI
            end
--[ Fim do Bloco para A17 - Slider ]--
--[ Início do Bloco para A17 - Label ]--
            function SectionAPI:AddLabel(labelOptions)
                local LabelAPI = {}

                local TextLabel = Create("TextLabel", {
                    Name = labelOptions.Text or "Label",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 0), -- Altura será automática
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = labelOptions.Text or "My Label",
                    TextColor3 = labelOptions.Color or Theme.TextSecondary,
                    TextSize = 13,
                    TextWrapped = true, -- Permite que o texto quebre a linha
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                })

                local Padding = Create("UIPadding", {
                    Parent = TextLabel,
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                })

                -- API para permitir a atualização do texto posteriormente
                function LabelAPI:SetText(newText)
                    TextLabel.Text = newText
                end

                return LabelAPI
            end
--[ Fim do Bloco para A17 - Label ]--
--[ Início do Bloco para A17 - Button ]--
            function SectionAPI:AddButton(buttonOptions)
                local ButtonAPI = {}
                local callback = buttonOptions.Callback or function() end

                local Button = Create("TextButton", {
                    Name = buttonOptions.Name or "Button",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.Section, -- Usando a cor de fundo da seção
                    AutoButtonColor = false,
                    Text = buttonOptions.Name or "Button",
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 14,
                })

                local Corner = Create("UICorner", {
                    Parent = Button,
                    CornerRadius = UDim.new(0, 5),
                })
                
                local Stroke = Create("UIStroke", {
                    Parent = Button,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Divider,
                    Thickness = 1,
                })

                Button.MouseButton1Click:Connect(function()
                    task.spawn(callback)
                end)
                
                -- Animação de Feedback
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), { BackgroundColor3 = Theme.ActiveTab }):Play()
                end)
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Section }):Play()
                end)

                function ButtonAPI:SetText(newText)
                    Button.Text = newText
                end

                return ButtonAPI
            end
--[ Fim do Bloco para A17 - Button ]--
--[ Início do Bloco para A17 - Input ]--
            function SectionAPI:AddInput(inputOptions)
                local InputAPI = {}
                local callback = inputOptions.Callback or function() end

                local InputFrame = Create("Frame", {
                    Name = inputOptions.Name or "Input",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                })
                
                local InputName = Create("TextLabel", {
                    Name = "Name",
                    Parent = InputFrame,
                    Size = UDim2.new(0.5, -5, 1, 0), -- Ocupa metade do espaço menos uma margem
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = inputOptions.Name or "Input",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local TextBox = Create("TextBox", {
                    Name = "TextBox",
                    Parent = InputFrame,
                    Size = UDim2.new(0.5, -5, 1, 0),
                    Position = UDim2.fromScale(0.5, 0),
                    BackgroundColor3 = Theme.Sidebar, -- Cor mais escura
                    Font = Enum.Font.GothamBold,
                    Text = inputOptions.Default or "",
                    PlaceholderText = inputOptions.Placeholder or "...",
                    PlaceholderColor3 = Theme.Divider,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 14,
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local Corner = Create("UICorner", {
                    Parent = TextBox,
                    CornerRadius = UDim.new(0, 5),
                })
                
                local Padding = Create("UIPadding", {
                    Parent = TextBox,
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                })

                local Stroke = Create("UIStroke", {
                    Parent = TextBox,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Divider,
                    Thickness = 1,
                    Enabled = false, -- Começa desativado
                })
                
                -- Evento quando o usuário pressiona Enter ou clica fora
                TextBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        task.spawn(callback, TextBox.Text)
                    end
                end)
                
                -- Feedback visual ao focar
                TextBox.Focused:Connect(function()
                    Stroke.Enabled = true
                end)
                
                TextBox.FocusLost:Connect(function()
                    Stroke.Enabled = false
                end)

                function InputAPI:SetText(newText)
                    TextBox.Text = newText
                end

                function InputAPI:GetText()
                    return TextBox.Text
                end

                return InputAPI
            end
--[ Fim do Bloco para A17 - Input ]--
--[ Início do Bloco para A17 - Dropdown ]--
            function SectionAPI:AddDropdown(dropdownOptions)
                local DropdownAPI = {}
                local optionsList = dropdownOptions.Options or {}
                local callback = dropdownOptions.Callback or function() end
                local isOpen = false
                local selectedOption = dropdownOptions.Default or optionsList[1]
                
                -- Container principal que irá crescer quando o dropdown abrir
                local DropdownFrame = Create("Frame", {
                    Name = dropdownOptions.Name or "Dropdown",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 35), -- Altura inicial fechado
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                })
                
                -- O botão principal clicável
                local HeaderButton = Create("TextButton", {
                    Name = "HeaderButton",
                    Parent = DropdownFrame,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.Section,
                    Text = "",
                    AutoButtonColor = false,
                })
                local HeaderCorner = Create("UICorner", { Parent = HeaderButton, CornerRadius = UDim.new(0, 5) })
                
                local DropdownName = Create("TextLabel", {
                    Name = "Name",
                    Parent = HeaderButton,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = selectedOption,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local ArrowIcon = Create("ImageLabel", {
                    Name = "Arrow",
                    Parent = HeaderButton,
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -15, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "http://www.roblox.com/asset/?id=3926305904",
                    ImageRectOffset = Vector2.new(564, 284),
                    ImageRectSize = Vector2.new(36, 36),
                    ImageColor3 = Theme.TextSecondary,
                    BackgroundTransparency = 1,
                })
                
                -- O frame que contém as opções
                local OptionsContainer = Create("Frame", {
                    Name = "OptionsContainer",
                    Parent = DropdownFrame,
                    Position = UDim2.new(0, 0, 1, 0), -- Posicionado abaixo do header
                    Size = UDim2.new(1, 0, 0, 0), -- Altura cresce com UIListLayout
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Theme.Sidebar,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                })
                local OptionsLayout = Create("UIListLayout", { Parent = OptionsContainer, SortOrder = Enum.SortOrder.LayoutOrder })
                local OptionsPadding = Create("UIPadding", { Parent = OptionsContainer, Padding = UDim.new(0,5)})
                local OptionsCorner = Create("UICorner", {Parent = OptionsContainer, CornerRadius = UDim.new(0,5)})

                local function ToggleDropdown()
                    isOpen = not isOpen
                    local totalHeight = 35 + (#optionsList * 30) + 5 -- Header + (Opções * Altura) + Padding
                    local targetSize = isOpen and UDim2.new(1, 0, 0, totalHeight) or UDim2.new(1, 0, 0, 35)
                    local arrowRotation = isOpen and 180 or 0
                    
                    DropdownFrame:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.2), { Rotation = arrowRotation }):Play()
                end
                
                HeaderButton.MouseButton1Click:Connect(ToggleDropdown)

                for _, optionName in ipairs(optionsList) do
                    local OptionButton = Create("TextButton", {
                        Name = optionName,
                        Parent = OptionsContainer,
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Theme.Sidebar,
                        Text = "  " .. optionName,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.TextSecondary,
                        TextSize = 14,
                        AutoButtonColor = false,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    })

                    OptionButton.MouseEnter:Connect(function() OptionButton.BackgroundColor3 = Theme.ActiveTab end)
                    OptionButton.MouseLeave:Connect(function() OptionButton.BackgroundColor3 = Theme.Sidebar end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = optionName
                        DropdownName.Text = selectedOption
                        task.spawn(callback, selectedOption)
                        ToggleDropdown()
                    end)
                end
                
                return DropdownAPI
            end
--[ Fim do Bloco para A17 - Dropdown ]--
--[ Início do Bloco para A17 - Divider ]--
            function SectionAPI:AddDivider()
                local DividerAPI = {}

                local DividerFrame = Create("Frame", {
                    Name = "Divider",
                    Parent = SectionAPI.Container,
                    Size = UDim2.new(1, 0, 0, 10), -- Altura total do espaço
                    BackgroundTransparency = 1,
                })
                
                local Line = Create("Frame", {
                    Name = "Line",
                    Parent = DividerFrame,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Theme.Divider,
                    BorderSizePixel = 0,
                })

                return DividerAPI
            end
--[ Fim do Bloco para A17 - Divider ]--

            
            return SectionAPI
        end
        
        return TabAPI
    end

    return WindowAPI
end

-- A18: Finalização e Retorno da Biblioteca
return NomadLib
