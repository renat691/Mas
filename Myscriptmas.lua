-- Weight Control v204 | GitHub Loader Edition
local P=game:GetService("Players")
local U=game:GetService("UserInputService")
local T=game:GetService("TweenService")
local pl=P.LocalPlayer

local s={weight=100,menuOpen=false,topBarVisible=true,forceSpeed=true,speedValue=16,
accent=Color3.fromRGB(120,160,255),accent2=Color3.fromRGB(200,100,255),
bg=Color3.fromRGB(18,18,26),bg2=Color3.fromRGB(28,28,40),
text=Color3.fromRGB(240,240,255),subtext=Color3.fromRGB(160,160,200),
danger=Color3.fromRGB(255,80,80),success=Color3.fromRGB(80,220,130)}

local flags={autoJump=false,infJump=false,noclip=false,noGravity=false,
hover=false,highJump=false,moonJump=false,ghostMode=false,spin=false,
rainbowChar=false,autoHeal=false,antiAFK=false,fullBright=false,esp=false}

local function fw(n)
    if n==math.huge then return "∞" end
    if n>=1e12 then return string.format("%.2fT",n/1e12) end
    if n>=1e9 then return string.format("%.2fB",n/1e9) end
    if n>=1e6 then return string.format("%.2fM",n/1e6) end
    if n>=1e3 then return string.format("%.1fK",n/1e3) end
    return tostring(math.floor(n))
end

local function aw(v)
    local c=pl.Character if not c then return end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function() p.CustomPhysicalProperties=PhysicalProperties.new(math.min(v,100),.3,.5) end)
        end
    end
    s.weight=v
end

task.spawn(function()
    while true do
        if s.forceSpeed then
            local c=pl.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h then pcall(function() h.WalkSpeed=s.speedValue end) end
            end
        end
        task.wait(.1)
    end
end)

local sg=Instance.new("ScreenGui",game:GetService("CoreGui"))
sg.Name="W_"..math.random(1,99999)
sg.ResetOnSpawn=false
sg.IgnoreGuiInset=true
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

local tb=Instance.new("Frame",sg)
tb.Size=UDim2.new(0,320,0,44)
tb.Position=UDim2.new(.5,-160,0,12)
tb.BackgroundColor3=s.bg
tb.BackgroundTransparency=.1
tb.BorderSizePixel=0
tb.ZIndex=50
Instance.new("UICorner",tb).CornerRadius=UDim.new(0,14)
local tbs=Instance.new("UIStroke",tb)
tbs.Color=s.accent
tbs.Thickness=1.5
tbs.Transparency=.3

local tbt=Instance.new("TextLabel",tb)
tbt.Size=UDim2.new(1,-20,1,0)
tbt.Position=UDim2.new(0,15,0,0)
tbt.BackgroundTransparency=1
tbt.Text="⚖ ВЕС: "..fw(s.weight)
tbt.TextColor3=s.text
tbt.Font=Enum.Font.GothamBold
tbt.TextScaled=true
tbt.TextXAlignment=Enum.TextXAlignment.Left
tbt.ZIndex=51

local ob=Instance.new("TextButton",sg)
ob.Size=UDim2.new(0,60,0,60)
ob.Position=UDim2.new(0,20,0,100)
ob.BackgroundColor3=s.accent
ob.TextColor3=Color3.new(1,1,1)
ob.Font=Enum.Font.GothamBold
ob.TextScaled=true
ob.Text="⚖"
ob.ZIndex=10
ob.AutoButtonColor=false
Instance.new("UICorner",ob).CornerRadius=UDim.new(1,0)

local pn=Instance.new("Frame",sg)
pn.Size=UDim2.new(0,380,0,500)
pn.Position=UDim2.new(.5,-190,.5,-250)
pn.BackgroundColor3=s.bg
pn.BorderSizePixel=0
pn.Visible=false
pn.ZIndex=20
pn.ClipsDescendants=true
pn.Active=true
Instance.new("UICorner",pn).CornerRadius=UDim.new(0,16)
local pns=Instance.new("UIStroke",pn)
pns.Color=s.accent
pns.Thickness=1.5
pns.Transparency=.3

local hd=Instance.new("Frame",pn)
hd.Size=UDim2.new(1,0,0,45)
hd.BackgroundTransparency=1
hd.ZIndex=21

local ht=Instance.new("TextLabel",hd)
ht.Size=UDim2.new(1,-100,1,0)
ht.Position=UDim2.new(0,20,0,0)
ht.BackgroundTransparency=1
ht.Text="⚖ WEIGHT CONTROL"
ht.TextColor3=s.text
ht.Font=Enum.Font.GothamBold
ht.TextScaled=true
ht.TextXAlignment=Enum.TextXAlignment.Left
ht.ZIndex=22

local cb=Instance.new("TextButton",hd)
cb.Size=UDim2.new(0,32,0,32)
cb.Position=UDim2.new(1,-42,.5,-16)
cb.BackgroundColor3=s.danger
cb.TextColor3=Color3.new(1,1,1)
cb.Font=Enum.Font.GothamBold
cb.TextScaled=true
cb.Text="✕"
cb.ZIndex=22
cb.AutoButtonColor=false
Instance.new("UICorner",cb).CornerRadius=UDim.new(1,0)

local tf=Instance.new("Frame",pn)
tf.Size=UDim2.new(1,-20,0,34)
tf.Position=UDim2.new(0,10,0,48)
tf.BackgroundColor3=s.bg2
tf.BorderSizePixel=0
tf.ZIndex=21
Instance.new("UICorner",tf).CornerRadius=UDim.new(0,8)

local tl=Instance.new("UIListLayout",tf)
tl.FillDirection=Enum.FillDirection.Horizontal
tl.HorizontalAlignment=Enum.HorizontalAlignment.Center
tl.VerticalAlignment=Enum.VerticalAlignment.Center
tl.Padding=UDim.new(0,3)

local tabs={}
local contents={}
local function ct(n,lb,o)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(0,85,0,26)
    b.BackgroundColor3=s.bg2
    b.TextColor3=s.subtext
    b.Font=Enum.Font.GothamBold
    b.TextScaled=true
    b.Text=lb
    b.ZIndex=22
    b.AutoButtonColor=false
    b.LayoutOrder=o
    b.Parent=tf
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        for k,v in pairs(tabs) do
            v.BackgroundColor3=k==n and s.accent or s.bg2
            v.TextColor3=k==n and Color3.new(1,1,1) or s.subtext
        end
        for k,v in pairs(contents) do v.Visible=k==n end
    end)
    tabs[n]=b
end
local function cc(n)
    local f=Instance.new("Frame",pn)
    f.Size=UDim2.new(1,-20,1,-150)
    f.Position=UDim2.new(0,10,0,88)
    f.BackgroundTransparency=1
    f.Visible=false
    f.ZIndex=21
    contents[n]=f
    return f
end

ct("main","ВЕС",1)
ct("speed","СКОРОСТЬ",2)
ct("player","ИГРОК",3)
ct("extra","ФИШКИ",4)

local mc=cc("main")
local sc=cc("speed")
local pc=cc("player")
local ec=cc("extra")

tabs["main"].BackgroundColor3=s.accent
tabs["main"].TextColor3=Color3.new(1,1,1)
mc.Visible=true

-- ВЕС
local card=Instance.new("Frame",mc)
card.Size=UDim2.new(1,0,0,80)
card.Position=UDim2.new(0,0,0,5)
card.BackgroundColor3=s.bg2
card.BorderSizePixel=0
card.ZIndex=22
Instance.new("UICorner",card).CornerRadius=UDim.new(0,12)

local bv=Instance.new("TextLabel",card)
bv.Size=UDim2.new(1,-20,0,50)
bv.Position=UDim2.new(0,10,0,5)
bv.BackgroundTransparency=1
bv.Text=fw(s.weight)
bv.TextColor3=s.accent
bv.Font=Enum.Font.GothamBold
bv.TextScaled=true
bv.ZIndex=23

local sl=Instance.new("Frame",mc)
sl.Size=UDim2.new(1,0,0,14)
sl.Position=UDim2.new(0,0,0,100)
sl.BackgroundColor3=Color3.fromRGB(45,45,60)
sl.BorderSizePixel=0
sl.ZIndex=22
Instance.new("UICorner",sl).CornerRadius=UDim.new(1,0)

local fl=Instance.new("Frame",sl)
fl.Size=UDim2.new(0,0,1,0)
fl.BackgroundColor3=s.accent
fl.BorderSizePixel=0
fl.ZIndex=23
Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)

local kn=Instance.new("Frame",sl)
kn.Size=UDim2.new(0,26,0,26)
kn.Position=UDim2.new(0,-13,.5,-13)
kn.BackgroundColor3=Color3.new(1,1,1)
kn.BorderSizePixel=0
kn.ZIndex=24
Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)

local qf=Instance.new("Frame",mc)
qf.Size=UDim2.new(1,0,0,100)
qf.Position=UDim2.new(0,0,0,130)
qf.BackgroundTransparency=1
qf.ZIndex=25

local BW=78 BH=42 GX=8 GY=10
local ssfw

local function qb(t,w,c,r)
    local b=Instance.new("TextButton",qf)
    b.Size=UDim2.new(0,BW,0,BH)
    b.Position=UDim2.new(0,c*(BW+GX),0,r*(BH+GY))
    b.BackgroundColor3=s.bg2
    b.TextColor3=s.text
    b.Font=Enum.Font.GothamBold
    b.TextScaled=true
    b.Text=t
    b.ZIndex=30
    b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.MouseButton1Click:Connect(function() if ssfw then ssfw(w) end end)
end
qb("1",1,0,0) qb("10",10,1,0) qb("100",100,2,0) qb("1K",1000,3,0)
qb("10K",1e4,0,1) qb("100K",1e5,1,1) qb("1M",1e6,2,1) qb("∞",math.huge,3,1)

-- СКОРОСТЬ
local sv=Instance.new("TextLabel",sc)
sv.Size=UDim2.new(1,0,0,40)
sv.Position=UDim2.new(0,0,0,40)
sv.BackgroundTransparency=1
sv.Text=tostring(s.speedValue)
sv.TextColor3=s.success
sv.Font=Enum.Font.GothamBold
sv.TextScaled=true
sv.ZIndex=22

local ssl=Instance.new("Frame",sc)
ssl.Size=UDim2.new(1,0,0,14)
ssl.Position=UDim2.new(0,0,0,90)
ssl.BackgroundColor3=Color3.fromRGB(45,45,60)
ssl.BorderSizePixel=0
ssl.ZIndex=22
Instance.new("UICorner",ssl).CornerRadius=UDim.new(1,0)

local sfl=Instance.new("Frame",ssl)
sfl.Size=UDim2.new(.03,0,1,0)
sfl.BackgroundColor3=s.success
sfl.BorderSizePixel=0
sfl.ZIndex=23
Instance.new("UICorner",sfl).CornerRadius=UDim.new(1,0)

local skn=Instance.new("Frame",ssl)
skn.Size=UDim2.new(0,26,0,26)
skn.Position=UDim2.new(.03,-13,.5,-13)
skn.BackgroundColor3=Color3.new(1,1,1)
skn.BorderSizePixel=0
skn.ZIndex=24
Instance.new("UICorner",skn).CornerRadius=UDim.new(1,0)

local usv
local sq=Instance.new("Frame",sc)
sq.Size=UDim2.new(1,0,0,90)
sq.Position=UDim2.new(0,0,0,130)
sq.BackgroundTransparency=1
sq.ZIndex=25

for i,v in ipairs({16,50,100,200}) do
    local b=Instance.new("TextButton",sq)
    b.Size=UDim2.new(0,88,0,40)
    b.Position=UDim2.new(0,(i-1)*92,0,0)
    b.BackgroundColor3=s.bg2
    b.TextColor3=s.text
    b.Font=Enum.Font.GothamBold
    b.TextScaled=true
    b.Text=tostring(v)
    b.ZIndex=30
    b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.MouseButton1Click:Connect(function() usv(v) end)
end

usv=function(v)
    s.speedValue=v
    sv.Text=tostring(v)
    local p=math.clamp((v-10)/190,0,1)
    sfl.Size=UDim2.new(p,0,1,0)
    skn.Position=UDim2.new(p,-13,.5,-13)
end

-- ИГРОК
local ps=Instance.new("ScrollingFrame",pc)
ps.Size=UDim2.new(1,0,1,0)
ps.BackgroundTransparency=1
ps.BorderSizePixel=0
ps.ScrollBarThickness=4
ps.ScrollBarImageColor3=s.accent
ps.CanvasSize=UDim2.new(0,0,0,1400)
ps.ZIndex=25

local pl2=Instance.new("UIListLayout",ps)
pl2.Padding=UDim.new(0,8)

local function pb(t,cb2)
    local b=Instance.new("TextButton",ps)
    b.Size=UDim2.new(1,-8,0,42)
    b.BackgroundColor3=s.bg2
    b.TextColor3=s.text
    b.Font=Enum.Font.GothamBold
    b.TextScaled=true
    b.Text=t
    b.ZIndex=30
    b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.MouseButton1Click:Connect(function() cb2(b) end)
    return b
end

pb("👻 Noclip: ВЫКЛ",function(b) flags.noclip=not flags.noclip b.Text=flags.noclip and"👻 Noclip: ВКЛ"or"👻 Noclip: ВЫКЛ" b.BackgroundColor3=flags.noclip and s.success or s.bg2 end)
pb("🌌 Нулевая гравитация: ВЫКЛ",function(b) flags.noGravity=not flags.noGravity b.Text=flags.noGravity and"🌌 Гравитация: ВКЛ"or"🌌 Нулевая гравитация: ВЫКЛ" b.BackgroundColor3=flags.noGravity and s.success or s.bg2 end)
pb("🛸 Hover: ВЫКЛ",function(b) flags.hover=not flags.hover b.Text=flags.hover and"🛸 Hover: ВКЛ"or"🛸 Hover: ВЫКЛ" b.BackgroundColor3=flags.hover and s.success or s.bg2 end)
pb("🦅 Бесконечный прыжок: ВЫКЛ",function(b) flags.infJump=not flags.infJump b.Text=flags.infJump and"🦅 Прыжок: ВКЛ"or"🦅 Бесконечный прыжок: ВЫКЛ" b.BackgroundColor3=flags.infJump and s.success or s.bg2 end)
pb("🦘 Автопрыжок: ВЫКЛ",function(b) flags.autoJump=not flags.autoJump b.Text=flags.autoJump and"🦘 Автопрыжок: ВКЛ"or"🦘 Автопрыжок: ВЫКЛ" b.BackgroundColor3=flags.autoJump and s.success or s.bg2 end)
pb("🚀 Высокий прыжок: ВЫКЛ",function(b) flags.highJump=not flags.highJump b.Text=flags.highJump and"🚀 Прыжок: ВКЛ"or"🚀 Высокий прыжок: ВЫКЛ" b.BackgroundColor3=flags.highJump and s.success or s.bg2 end)
pb("🌙 Лунный прыжок: ВЫКЛ",function(b) flags.moonJump=not flags.moonJump b.Text=flags.moonJump and"🌙 Лунный: ВКЛ"or"🌙 Лунный прыжок: ВЫКЛ" b.BackgroundColor3=flags.moonJump and s.success or s.bg2 end)
pb("👤 Полупрозрачность: ВЫКЛ",function(b) flags.ghostMode=not flags.ghostMode b.Text=flags.ghostMode and"👤 Призрак: ВКЛ"or"👤 Полупрозрачность: ВЫКЛ" b.BackgroundColor3=flags.ghostMode and s.success or s.bg2 local c=pl.Character if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.Transparency=flags.ghostMode and .5 or 0 end) end end end end)
pb("🌀 Вращение: ВЫКЛ",function(b) flags.spin=not flags.spin b.Text=flags.spin and"🌀 Вращение: ВКЛ"or"🌀 Вращение: ВЫКЛ" b.BackgroundColor3=flags.spin and s.success or s.bg2 end)
pb("🌈 Радужный: ВЫКЛ",function(b) flags.rainbowChar=not flags.rainbowChar b.Text=flags.rainbowChar and"🌈 Радужный: ВКЛ"or"🌈 Радужный: ВЫКЛ" b.BackgroundColor3=flags.rainbowChar and s.success or s.bg2 end)
pb("❤ Авто-хил: ВЫКЛ",function(b) flags.autoHeal=not flags.autoHeal b.Text=flags.autoHeal and"❤ Авто-хил: ВКЛ"or"❤ Авто-хил: ВЫКЛ" b.BackgroundColor3=flags.autoHeal and s.success or s.bg2 end)
pb("🛡 Anti-AFK: ВЫКЛ",function(b) flags.antiAFK=not flags.antiAFK b.Text=flags.antiAFK and"🛡 Anti-AFK: ВКЛ"or"🛡 Anti-AFK: ВЫКЛ" b.BackgroundColor3=flags.antiAFK and s.success or s.bg2 end)
pb("💡 Fullbright: ВЫКЛ",function(b) flags.fullBright=not flags.fullBright b.Text=flags.fullBright and"💡 Fullbright: ВКЛ"or"💡 Fullbright: ВЫКЛ" b.BackgroundColor3=flags.fullBright and s.success or s.bg2 local l=game:GetService("Lighting") l.Ambient=flags.fullBright and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70) l.OutdoorAmbient=flags.fullBright and Color3.fromRGB(255,255,255) or Color3.fromRGB(128,128,128) end)
pb("⬆ Телепорт +50",function() local c=pl.Character if c then local h=c:FindFirstChild("HumanoidRootPart") if h then h.CFrame=h.CFrame+Vector3.new(0,50,0) end end end)
pb("🏠 На спавн",function() local c=pl.Character if c then local h=c:FindFirstChild("HumanoidRootPart") local sp=workspace:FindFirstChildOfClass("SpawnLocation") if h and sp then h.CFrame=sp.CFrame+Vector3.new(0,5,0) end end end)

pl2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ps.CanvasSize=UDim2.new(0,0,0,pl2.AbsoluteContentSize.Y+10)
end)

-- ФИШКИ
local es=Instance.new("ScrollingFrame",ec)
es.Size=UDim2.new(1,0,1,0)
es.BackgroundTransparency=1
es.BorderSizePixel=0
es.ScrollBarThickness=4
es.ScrollBarImageColor3=s.accent
es.CanvasSize=UDim2.new(0,0,0,300)
es.ZIndex=25

local el=Instance.new("UIListLayout",es)
el.Padding=UDim.new(0,8)

local function eb(t,cb2)
    local b=Instance.new("TextButton",es)
    b.Size=UDim2.new(1,-8,0,42)
    b.BackgroundColor3=s.bg2
    b.TextColor3=s.text
    b.Font=Enum.Font.GothamBold
    b.TextScaled=true
    b.Text=t
    b.ZIndex=30
    b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.MouseButton1Click:Connect(function() cb2(b) end)
end

eb("👁 ESP игроков: ВЫКЛ",function(b) flags.esp=not flags.esp b.Text=flags.esp and"👁 ESP: ВКЛ"or"👁 ESP игроков: ВЫКЛ" b.BackgroundColor3=flags.esp and s.success or s.bg2 end)

el:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    es.CanvasSize=UDim2.new(0,0,0,el.AbsoluteContentSize.Y+10)
end)

-- Ползунки
local function ptow(p) if p>=.999 then return math.huge end return 1+(p*p*p*1e12) end
ssfw=function(w)
    local p=w==math.huge and 1 or math.clamp(((w-1)/1e12)^(1/3),0,1)
    fl.Size=UDim2.new(p,0,1,0)
    kn.Position=UDim2.new(p,-13,.5,-13)
    bv.Text=fw(w)
    if s.topBarVisible then tbt.Text="⚖ ВЕС: "..fw(w) end
    aw(w)
end

local drag=nil
local function gx(x,sl2) return (x-sl2.AbsolutePosition.X)/sl2.AbsoluteSize.X end

local function bind(sl2,kn2,cb2)
    sl2.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag={sl=sl2,cb=cb2} cb2(gx(i.Position.X,sl2))
        end
    end)
    kn2.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag={sl=sl2,cb=cb2}
        end
    end)
end

bind(sl,kn,function(p)
    p=math.clamp(p,0,1) local v=ptow(p)
    fl.Size=UDim2.new(p,0,1,0)
    kn.Position=UDim2.new(p,-13,.5,-13)
    bv.Text=fw(v)
    if s.topBarVisible then tbt.Text="⚖ ВЕС: "..fw(v) end
    aw(v)
end)

bind(ssl,skn,function(p)
    p=math.clamp(p,0,1) local v=math.floor(10+p*190)
    sfl.Size=UDim2.new(p,0,1,0)
    skn.Position=UDim2.new(p,-13,.5,-13)
    usv(v)
end)

U.InputChanged:Connect(function(i)
    if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        drag.cb(gx(i.Position.X,drag.sl))
    end
end)
U.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=nil end
end)

-- Открытие
local function om()
    s.menuOpen=true pn.Visible=true
    pn.Size=UDim2.new(0,360,0,490)
    pn.BackgroundTransparency=1
    T:Create(pn,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(0,380,0,500),BackgroundTransparency=.1}):Play()
    ob.Text="✕" ob.BackgroundColor3=s.danger
end
local function cm()
    s.menuOpen=false
    local t=T:Create(pn,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Size=UDim2.new(0,360,0,490),BackgroundTransparency=1})
    t:Play() t.Completed:Connect(function() pn.Visible=false end)
    ob.Text="⚖" ob.BackgroundColor3=s.accent
end
ob.MouseButton1Click:Connect(function() if s.menuOpen then cm() else om() end end)
cb.MouseButton1Click:Connect(cm)

-- Перетаскивание
local ds,sp
hd.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        ds=i.Position sp=pn.Position
    end
end)
U.InputChanged:Connect(function(i)
    if ds and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-ds
        pn.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
    end
end)
U.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ds=nil end
end)

-- Циклы фишек
task.spawn(function() while true do if flags.noclip then local c=pl.Character if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide=false end) end end end end task.wait(.2) end end)
task.spawn(function() while true do if flags.noGravity then local c=pl.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.Gravity=0 end) end end end task.wait(.2) end end)
task.spawn(function() while true do if flags.autoJump then local c=pl.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.Jump=true end) end end end task.wait(.1) end end)
task.spawn(function() while true do if flags.highJump then local c=pl.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.UseJumpPower=true h.JumpPower=150 end) end end end task.wait(.3) end end)
task.spawn(function() while true do if flags.moonJump then local c=pl.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.UseJumpPower=true h.JumpPower=200 h.Gravity=50 end) end end end task.wait(.3) end end)
task.spawn(function() while true do if flags.autoHeal then local c=pl.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h and h.Health<h.MaxHealth then pcall(function() h.Health=h.MaxHealth end) end end end task.wait(.5) end end)
task.spawn(function() while true do if flags.antiAFK then local v=game:GetService("VirtualUser") pcall(function() v:CaptureController() v:ClickButton2(Vector2.new()) end) end task.wait(60) end end)
task.spawn(function() while true do if flags.spin then local c=pl.Character if c then local h=c:FindFirstChild("HumanoidRootPart") if h then pcall(function() h.CFrame=h.CFrame*CFrame.Angles(0,math.rad(15),0) end) end end end task.wait(.03) end end)
task.spawn(function() local hue=0 while true do if flags.rainbowChar then local c=pl.Character if c then hue=(hue+.02)%1 local col=Color3.fromHSV(hue,1,1) for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.Color=col end) end end end end task.wait(.05) end end)
task.spawn(function() while true do if flags.hover then local c=pl.Character if c then local h=c:FindFirstChild("HumanoidRootPart") if h then local b=h:FindFirstChild("HF") if not b then b=Instance.new("BodyForce",h) b.Name="HF" end b.Force=Vector3.new(0,workspace.Gravity*h:GetMass(),0) end end end task.wait(.2) end end)
task.spawn(function() while true do if flags.esp then for _,p in ipairs(P:GetPlayers()) do if p~=pl and p.Character then local h=p.Character:FindFirstChildOfClass("Highlight") if not h then h=Instance.new("Highlight",p.Character) h.FillColor=Color3.fromRGB(255,0,0) h.OutlineColor=Color3.new(1,1,1) h.FillTransparency=.5 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop end end end else for _,p in ipairs(P:GetPlayers()) do if p.Character then local h=p.Character:FindFirstChildOfClass("Highlight") if h then h:Destroy() end end end end task.wait(1) end end)

U.JumpRequest:Connect(function() if flags.infJump then local c=pl.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end end end end)

P.CharacterAdded:Connect(function() task.wait(1) aw(s.weight) end)

ssfw(100)
usv(16)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{Title="⚖ Weight Control",Text="Загружено с GitHub",Duration=3})
end)
