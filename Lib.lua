local MyRobloxLib = {}

--// Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

--// Variables
local isStudio = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer

--// Functions
local function Tween(instance, tweeninfo, propertytable)
	return TweenService:Create(instance, tweeninfo, propertytable)
end

--// Library Functions
function MyRobloxLib:CreateWindow(Settings)
	local WindowFunctions = {}

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = Settings.Title or "MyRobloxLib"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 100
	screenGui.IgnoreGuiInset = true
	screenGui.ScreenInsets = Enum.ScreenInsets.None
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = (isStudio and LocalPlayer.PlayerGui) or game:GetService("CoreGui")

	local baseFrame = Instance.new("Frame")
	baseFrame.Name = "BaseFrame"
	baseFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	baseFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	baseFrame.BorderSizePixel = 0
	baseFrame.Position = UDim2.fromScale(0.5, 0.5)
	baseFrame.Size = Settings.Size or UDim2.fromOffset(600, 400)
	baseFrame.Parent = screenGui

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.CornerRadius = UDim.new(0, 5)
	baseUICorner.Parent = baseFrame

	-- Sidebar (similar to MacLib and Luxt1)
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	sidebar.BorderSizePixel = 0
	sidebar.Size = UDim2.new(0.25, 0, 1, 0) -- 25% width, full height
	sidebar.Parent = baseFrame

	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 5)
	sidebarCorner.Parent = sidebar

	-- Main content area
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "ContentFrame"
	contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	contentFrame.BorderSizePixel = 0
	contentFrame.Position = UDim2.new(0.25, 0, 0, 0) -- Starts after sidebar
	contentFrame.Size = UDim2.new(0.75, 0, 1, 0) -- Remaining 75% width, full height
	contentFrame.Parent = baseFrame

	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 5)
	contentCorner.Parent = contentFrame

	-- Add a title to the sidebar
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = sidebar
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, 0, 0, 30)
	titleLabel.Position = UDim2.new(0, 0, 0, 10)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = Settings.Title or "MyLib"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 20
	titleLabel.TextWrapped = true
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	-- Tab container in sidebar
	local tabContainer = Instance.new("ScrollingFrame")
	tabContainer.Name = "TabContainer"
	tabContainer.Parent = sidebar
	tabContainer.Active = true
	tabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabContainer.BackgroundTransparency = 1
	tabContainer.BorderSizePixel = 0
	tabContainer.Position = UDim2.new(0, 0, 0, 50)
	tabContainer.Size = UDim2.new(1, 0, 1, -50)
	tabContainer.ZIndex = 2
	tabContainer.ScrollBarThickness = 0

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.Parent = tabContainer
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0, 5)
	tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Page folder to hold different tab pages
	local pageFolder = Instance.new("Folder")
	pageFolder.Name = "PageFolder"
	pageFolder.Parent = contentFrame

	-- Minimize/Maximize keybind (from Luxt1 and lates-lib)
	local currentKeybind = Settings.MinimizeKeybind or Enum.KeyCode.RightControl
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent and input.KeyCode == currentKeybind then
			screenGui.Enabled = not screenGui.Enabled
		end
	end)

	-- Function to add a tab
	function WindowFunctions:AddTab(tabSettings)
		local tabButtonFrame = Instance.new("Frame")
		tabButtonFrame.Name = "TabButtonFrame"
		tabButtonFrame.Parent = tabContainer
		tabButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabButtonFrame.BackgroundTransparency = 1
		tabButtonFrame.Size = UDim2.new(1, -20, 0, 30) -- Adjust size for padding

		local tabButton = Instance.new("TextButton")
		tabButton.Name = "TabButton"
		tabButton.Parent = tabButtonFrame
		tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		tabButton.Size = UDim2.new(1, 0, 1, 0)
		tabButton.Font = Enum.Font.Gotham
		tabButton.Text = tabSettings.Title or "New Tab"
		tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		tabButton.TextSize = 14
		tabButton.TextXAlignment = Enum.TextXAlignment.Center
		tabButton.TextYAlignment = Enum.TextYAlignment.Center

		local tabButtonCorner = Instance.new("UICorner")
		tabButtonCorner.CornerRadius = UDim.new(0, 5)
		tabButtonCorner.Parent = tabButton

		local newPage = Instance.new("ScrollingFrame")
		newPage.Name = "Page_" .. (tabSettings.Title or "NewTab")
		newPage.Parent = pageFolder
		newPage.Active = true
		newPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		newPage.BackgroundTransparency = 1
		newPage.BorderSizePixel = 0
		newPage.Size = UDim2.new(1, 0, 1, 0)
		newPage.ZIndex = 2
		newPage.ScrollBarThickness = 0
		newPage.Visible = false

		local sectionListLayout = Instance.new("UIListLayout")
		sectionListLayout.Name = "SectionListLayout"
		sectionListLayout.Parent = newPage
		sectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		sectionListLayout.Padding = UDim.new(0, 5)
		sectionListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

		-- Function to update CanvasSize for scrolling
		local function UpdateCanvasSize()
			local contentSize = sectionListLayout.AbsoluteContentSize
			Tween(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
				CanvasSize = UDim2.new(0, contentSize.X, 0, contentSize.Y)
			}):Play()
		end
		newPage.ChildAdded:Connect(UpdateCanvasSize)
		newPage.ChildRemoved:Connect(UpdateCanvasSize)

		tabButton.MouseButton1Click:Connect(function()
			-- Hide all pages
			for _, page in pairs(pageFolder:GetChildren()) do
				page.Visible = false
			end
			-- Show current page
			newPage.Visible = true
			UpdateCanvasSize()

			-- Reset all tab button colors
			for _, btnFrame in pairs(tabContainer:GetChildren()) do
				if btnFrame:IsA("Frame") then
					local btn = btnFrame:FindFirstChild("TabButton")
					if btn then
						Tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
							BackgroundColor3 = Color3.fromRGB(40, 40, 40)
						}):Play()
					end
				end
			end
			-- Highlight selected tab button
			Tween(tabButton, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			}):Play()
		end)

		-- Return the page for adding sections/components
		return newPage
	end

	return WindowFunctions
end

return MyRobloxLib




function WindowFunctions:AddSection(sectionSettings)
	local sectionFrame = Instance.new("Frame")
	sectionFrame.Name = "Section_" .. (sectionSettings.Name or "NewSection")
	sectionFrame.Parent = self -- self refers to the current page (newPage)
	sectionFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	sectionFrame.Size = UDim2.new(1, 0, 0, 36) -- Initial size, will expand
	sectionFrame.ZIndex = 2
	sectionFrame.ClipsDescendants = true

	local sectionCorner = Instance.new("UICorner")
	sectionCorner.CornerRadius = UDim.new(0, 5)
	sectionCorner.Parent = sectionFrame

	local mainSectionHead = Instance.new("Frame")
	mainSectionHead.Name = "MainSectionHead"
	mainSectionHead.Parent = sectionFrame
	mainSectionHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mainSectionHead.BackgroundTransparency = 1
	mainSectionHead.BorderSizePixel = 0
	mainSectionHead.Size = UDim2.new(1, 0, 0, 36)

	local sectionName = Instance.new("TextLabel")
	sectionName.Name = "SectionName"
	sectionName.Parent = mainSectionHead
	sectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sectionName.BackgroundTransparency = 1
	sectionName.Position = UDim2.new(0.02, 0, 0, 0)
	sectionName.Size = UDim2.new(0.8, 0, 1, 0)
	sectionName.Font = Enum.Font.GothamSemibold
	sectionName.Text = sectionSettings.Name or "Section"
	sectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
	sectionName.TextSize = 14
	sectionName.TextXAlignment = Enum.TextXAlignment.Left

	local sectionExpandButton = Instance.new("ImageButton")
	sectionExpandButton.Name = "SectionExpandButton"
	sectionExpandButton.Parent = mainSectionHead
	sectionExpandButton.BackgroundTransparency = 1
	sectionExpandButton.Position = UDim2.new(0.9, 0, 0.13, 0)
	sectionExpandButton.Size = UDim2.new(0, 25, 0, 25)
	sectionExpandButton.ZIndex = 2
	sectionExpandButton.Image = "rbxassetid://3926305904" -- Example expand icon
	sectionExpandButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	sectionExpandButton.ImageRectOffset = Vector2.new(564, 284)
	sectionExpandButton.ImageRectSize = Vector2.new(36, 36)

	local sectionInnerList = Instance.new("UIListLayout")
	sectionInnerList.Name = "SectionInnerList"
	sectionInnerList.Parent = sectionFrame
	sectionInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sectionInnerList.SortOrder = Enum.SortOrder.LayoutOrder
	sectionInnerList.Padding = UDim.new(0, 3)

	local isDropped = false

	sectionExpandButton.MouseButton1Click:Connect(function()
		if isDropped then
			isDropped = false
			Tween(sectionFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, 36)
			}):Play()
			Tween(sectionExpandButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Rotation = 0
			}):Play()
		else
			isDropped = true
			local targetHeight = sectionInnerList.AbsoluteContentSize.Y + mainSectionHead.AbsoluteSize.Y + sectionInnerList.Padding.Offset * ( #sectionFrame:GetChildren() - 2) -- Adjust for padding and header
			Tween(sectionFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, targetHeight)
			}):Play()
			Tween(sectionExpandButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Rotation = 180
			}):Play()
		end
	end)

	-- Return the section frame for adding components
	return sectionFrame
end




function WindowFunctions:AddButton(buttonSettings)
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "Button_" .. (buttonSettings.Title or "NewButton")
	buttonFrame.Parent = buttonSettings.Tab -- Parent is the section frame
	buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Size = UDim2.new(1, 0, 0, 30)

	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.Parent = buttonFrame
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.Size = UDim2.new(1, -10, 1, -10) -- Adjust for padding
	button.Position = UDim2.new(0, 5, 0, 5)
	button.Font = Enum.Font.Gotham
	button.Text = buttonSettings.Title or "Button"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.TextXAlignment = Enum.TextXAlignment.Center
	button.TextYAlignment = Enum.TextYAlignment.Center

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 5)
	buttonCorner.Parent = button

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = buttonFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, 0, 0, 15)
	descriptionLabel.Position = UDim2.new(0, 0, 0, 30)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = buttonSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Center
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	button.MouseButton1Click:Connect(function()
		if buttonSettings.Callback then
			buttonSettings.Callback()
		end
	end)

	return button
end




function WindowFunctions:AddToggle(toggleSettings)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = "Toggle_" .. (toggleSettings.Title or "NewToggle")
	toggleFrame.Parent = toggleSettings.Tab -- Parent is the section frame
	toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleFrame.BackgroundTransparency = 1
	toggleFrame.Size = UDim2.new(1, 0, 0, 30)

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Parent = toggleFrame
	toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	toggleButton.Size = UDim2.new(0, 40, 0, 20)
	toggleButton.Position = UDim2.new(1, -45, 0, 5)
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleButton

	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "ToggleIndicator"
	toggleIndicator.Parent = toggleButton
	toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
	
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(1, 0)
	indicatorCorner.Parent = toggleIndicator

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = toggleFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -50, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.Text = toggleSettings.Title or "Toggle"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = toggleFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, -50, 0, 15)
	descriptionLabel.Position = UDim2.new(0, 5, 0, 25)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = toggleSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local isOn = toggleSettings.Default or false

	local function updateToggleState()
		if isOn then
			Tween(toggleButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(119, 174, 94)
			}):Play()
			Tween(toggleIndicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -18, 0, 2)
			}):Play()
		else
			Tween(toggleButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			}):Play()
			Tween(toggleIndicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, 2, 0, 2)
			}):Play()
		end
	end

	toggleButton.MouseButton1Click:Connect(function()
		isOn = not isOn
		updateToggleState()
		if toggleSettings.Callback then
			toggleSettings.Callback(isOn)
		end
	end)

	updateToggleState()

	return toggleFrame
end




function WindowFunctions:AddSlider(sliderSettings)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = "Slider_" .. (sliderSettings.Title or "NewSlider")
	sliderFrame.Parent = sliderSettings.Tab -- Parent is the section frame
	sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Size = UDim2.new(1, 0, 0, 50)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = sliderFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.Text = sliderSettings.Title or "Slider"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = sliderFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, -10, 0, 15)
	descriptionLabel.Position = UDim2.new(0, 5, 0, 25)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = sliderSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local sliderBackground = Instance.new("Frame")
	sliderBackground.Name = "SliderBackground"
	sliderBackground.Parent = sliderFrame
	sliderBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	sliderBackground.Size = UDim2.new(1, -10, 0, 5)
	sliderBackground.Position = UDim2.new(0, 5, 0, 45)

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "SliderFill"
	sliderFill.Parent = sliderBackground
	sliderFill.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	sliderFill.Size = UDim2.new(0, 0, 1, 0)

	local sliderHandle = Instance.new("ImageLabel")
	sliderHandle.Name = "SliderHandle"
	sliderHandle.Parent = sliderBackground
	sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderHandle.BackgroundTransparency = 0
	sliderHandle.Size = UDim2.new(0, 10, 0, 10)
	sliderHandle.Image = "rbxassetid://2737769970" -- Example circle image

	local sliderValueLabel = Instance.new("TextLabel")
	sliderValueLabel.Name = "SliderValueLabel"
	sliderValueLabel.Parent = sliderFrame
	sliderValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderValueLabel.BackgroundTransparency = 1
	sliderValueLabel.Size = UDim2.new(0, 50, 0, 20)
	sliderValueLabel.Position = UDim2.new(1, -55, 0, 5)
	sliderValueLabel.Font = Enum.Font.Gotham
	sliderValueLabel.Text = "0"
	sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	sliderValueLabel.TextSize = 14
	sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	sliderValueLabel.TextYAlignment = Enum.TextYAlignment.Center

	local isDragging = false
	local maxValue = sliderSettings.MaxValue or 100
	local minValue = sliderSettings.MinValue or 0
	local currentValue = sliderSettings.Default or minValue

	local function updateSlider(input)
		local mouseX = input.Position.X - sliderBackground.AbsolutePosition.X
		local percentage = math.clamp(mouseX / sliderBackground.AbsoluteSize.X, 0, 1)
		currentValue = minValue + (maxValue - minValue) * percentage

		if not sliderSettings.AllowDecimals then
			currentValue = math.floor(currentValue)
		end

		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		sliderHandle.Position = UDim2.new(percentage, -sliderHandle.Size.X.Offset / 2, 0, -2.5)
		sliderValueLabel.Text = tostring(currentValue)

		if sliderSettings.Callback then
			sliderSettings.Callback(currentValue)
		end
	end

	sliderBackground.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
			updateSlider(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)

	-- Set initial value
	local initialPercentage = (currentValue - minValue) / (maxValue - minValue)
	sliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
	sliderHandle.Position = UDim2.new(initialPercentage, -sliderHandle.Size.X.Offset / 2, 0, -2.5)
	sliderValueLabel.Text = tostring(currentValue)

	return sliderFrame
end




function WindowFunctions:AddInput(inputSettings)
	local inputFrame = Instance.new("Frame")
	inputFrame.Name = "Input_" .. (inputSettings.Title or "NewInput")
	inputFrame.Parent = inputSettings.Tab -- Parent is the section frame
	inputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	inputFrame.BackgroundTransparency = 1
	inputFrame.Size = UDim2.new(1, 0, 0, 50)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = inputFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.Text = inputSettings.Title or "Input"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = inputFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, -10, 0, 15)
	descriptionLabel.Position = UDim2.new(0, 5, 0, 25)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = inputSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local inputTextBox = Instance.new("TextBox")
	inputTextBox.Name = "InputTextBox"
	inputTextBox.Parent = inputFrame
	inputTextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	inputTextBox.Size = UDim2.new(1, -10, 0, 25)
	inputTextBox.Position = UDim2.new(0, 5, 0, 45)
	inputTextBox.Font = Enum.Font.Gotham
	inputTextBox.Text = inputSettings.Default or ""
	inputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputTextBox.TextSize = 14
	inputTextBox.TextXAlignment = Enum.TextXAlignment.Left
	inputTextBox.TextYAlignment = Enum.TextYAlignment.Center
	inputTextBox.ClearTextOnFocus = false

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 5)
	inputCorner.Parent = inputTextBox

	inputTextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			if inputSettings.Callback then
				inputSettings.Callback(inputTextBox.Text)
			end
		end
	end)

	return inputFrame
end




function WindowFunctions:AddDropdown(dropdownSettings)
	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = "Dropdown_" .. (dropdownSettings.Title or "NewDropdown")
	dropdownFrame.Parent = dropdownSettings.Tab -- Parent is the section frame
	dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dropdownFrame.BackgroundTransparency = 1
	dropdownFrame.Size = UDim2.new(1, 0, 0, 50)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = dropdownFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.Text = dropdownSettings.Title or "Dropdown"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = dropdownFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, -10, 0, 15)
	descriptionLabel.Position = UDim2.new(0, 5, 0, 25)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = dropdownSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Parent = dropdownFrame
	dropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	dropdownButton.Size = UDim2.new(1, -10, 0, 25)
	dropdownButton.Position = UDim2.new(0, 5, 0, 45)
	dropdownButton.Font = Enum.Font.Gotham
	dropdownButton.Text = "Select an option"
	dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	dropdownButton.TextSize = 14
	dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
	dropdownButton.TextYAlignment = Enum.TextYAlignment.Center

	local dropdownCorner = Instance.new("UICorner")
	dropdownCorner.CornerRadius = UDim.new(0, 5)
	dropdownCorner.Parent = dropdownButton

	local optionsFrame = Instance.new("Frame")
	optionsFrame.Name = "OptionsFrame"
	optionsFrame.Parent = dropdownFrame
	optionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	optionsFrame.Size = UDim2.new(1, -10, 0, 0) -- Will expand dynamically
	optionsFrame.Position = UDim2.new(0, 5, 0, 75)
	optionsFrame.Visible = false

	local optionsListLayout = Instance.new("UIListLayout")
	optionsListLayout.Name = "OptionsListLayout"
	optionsListLayout.Parent = optionsFrame
	optionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	optionsListLayout.Padding = UDim.new(0, 2)

	local isExpanded = false

	dropdownButton.MouseButton1Click:Connect(function()
		isExpanded = not isExpanded
		optionsFrame.Visible = isExpanded
		if isExpanded then
			local totalHeight = #dropdownSettings.Options * 20 + (#dropdownSettings.Options - 1) * optionsListLayout.Padding.Offset
			Tween(optionsFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -10, 0, totalHeight)
			}):Play()
		else
			Tween(optionsFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -10, 0, 0)
			}):Play()
		end
	end)

	for optionText, optionValue in pairs(dropdownSettings.Options) do
		local optionButton = Instance.new("TextButton")
		optionButton.Name = "Option_" .. optionText
		optionButton.Parent = optionsFrame
		optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		optionButton.Size = UDim2.new(1, 0, 0, 20)
		optionButton.Font = Enum.Font.Gotham
		optionButton.Text = optionText
		optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionButton.TextSize = 12
		optionButton.TextXAlignment = Enum.TextXAlignment.Left
		optionButton.TextYAlignment = Enum.TextYAlignment.Center

		optionButton.MouseButton1Click:Connect(function()
			dropdownButton.Text = optionText
			isExpanded = false
			optionsFrame.Visible = false
			Tween(optionsFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -10, 0, 0)
			}):Play()
			if dropdownSettings.Callback then
				dropdownSettings.Callback(optionValue)
			end
		end)
	end

	return dropdownFrame
end




function WindowFunctions:AddKeybind(keybindSettings)
	local keybindFrame = Instance.new("Frame")
	keybindFrame.Name = "Keybind_" .. (keybindSettings.Title or "NewKeybind")
	keybindFrame.Parent = keybindSettings.Tab -- Parent is the section frame
	keybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	keybindFrame.BackgroundTransparency = 1
	keybindFrame.Size = UDim2.new(1, 0, 0, 50)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = keybindFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.Text = keybindSettings.Title or "Keybind"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = keybindFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, -10, 0, 15)
	descriptionLabel.Position = UDim2.new(0, 5, 0, 25)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = keybindSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	local keybindButton = Instance.new("TextButton")
	keybindButton.Name = "KeybindButton"
	keybindButton.Parent = keybindFrame
	keybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	keybindButton.Size = UDim2.new(0, 100, 0, 25)
	keybindButton.Position = UDim2.new(0, 5, 0, 45)
	keybindButton.Font = Enum.Font.Gotham
	keybindButton.Text = "NONE"
	keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	keybindButton.TextSize = 14
	keybindButton.TextXAlignment = Enum.TextXAlignment.Center
	keybindButton.TextYAlignment = Enum.TextYAlignment.Center

	local keybindCorner = Instance.new("UICorner")
	keybindCorner.CornerRadius = UDim.new(0, 5)
	keybindCorner.Parent = keybindButton

	local listening = false

	keybindButton.MouseButton1Click:Connect(function()
		if not listening then
			listening = true
			keybindButton.Text = "..."
			local inputConnection
			inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
				if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
					keybindButton.Text = input.KeyCode.Name
					listening = false
					inputConnection:Disconnect()
					if keybindSettings.Callback then
						keybindSettings.Callback(input.KeyCode)
					end
				end
			end)
		end
	end)

	return keybindFrame
end




function WindowFunctions:AddParagraph(paragraphSettings)
	local paragraphFrame = Instance.new("Frame")
	paragraphFrame.Name = "Paragraph_" .. (paragraphSettings.Title or "NewParagraph")
	paragraphFrame.Parent = paragraphSettings.Tab -- Parent is the section frame
	paragraphFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paragraphFrame.BackgroundTransparency = 1
	paragraphFrame.Size = UDim2.new(1, 0, 0, 50)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Parent = paragraphFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = paragraphSettings.Title or "Paragraph Title"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Name = "DescriptionLabel"
	descriptionLabel.Parent = paragraphFrame
	descriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	descriptionLabel.BackgroundTransparency = 1
	descriptionLabel.Size = UDim2.new(1, -10, 0, 30)
	descriptionLabel.Position = UDim2.new(0, 5, 0, 25)
	descriptionLabel.Font = Enum.Font.Gotham
	descriptionLabel.Text = paragraphSettings.Description or ""
	descriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	descriptionLabel.TextSize = 10
	descriptionLabel.TextWrapped = true
	descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

	return paragraphFrame
end


