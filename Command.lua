--中文库2.1
function ToStringEx(value)
    if type(value)=='table' then
       return TableToStr(value)
    elseif type(value)=='string' then
        return "\'"..value.."\'"
    else
       return tostring(value)
    end
end
function TableToStr(t)
    if t == nil then return "" end
    local retstr= "{"

    local i = 1
    for key,value in pairs(t) do
        local signal = ","
        if i==1 then
          signal = ""
        end

        if key == i then
            retstr = retstr..signal..ToStringEx(value)
        else
            if type(key)=='number' or type(key) == 'string' then
                retstr = retstr..signal..'['..ToStringEx(key).."]="..ToStringEx(value)
            else
                if type(key)=='userdata' then
                    retstr = retstr..signal.."*s"..TableToStr(getmetatable(key)).."*e".."="..ToStringEx(value)
                else
                    retstr = retstr..signal..key.."="..ToStringEx(value)
                end
            end
        end

        i = i+1
    end

     retstr = retstr.."}"
     return retstr
end
function QwordToBinStr(InNum)
    local SS = string.format("%016X",InNum)
    local S1 = string.sub(SS,15,16)
    local S2 = string.sub(SS,13,14)
    local S3 = string.sub(SS,11,12)
    local S4 = string.sub(SS,9,10)
    local S5 = string.sub(SS,7,8)
    local S6 = string.sub(SS,5,6)
    local S7 = string.sub(SS,3,4)
    local S8 = string.sub(SS,1,2)
    local S0 = S1..S2..S3..S4..S5..S6..S7..S8
    return S0
end
function DwordToBinStr(InNum)
    local SS = string.format("%08X",InNum)
    local S1 = string.sub(SS,7,8)
    local S2 = string.sub(SS,5,6)
    local S3 = string.sub(SS,3,4)
    local S4 = string.sub(SS,1,2)
    local S0 = S1..S2..S3..S4
    return S0
end
function WordToBinStr(InNum)
    local SS = string.format("%04X",InNum)
    local S3 = string.sub(SS,3,4)
    local S4 = string.sub(SS,1,2)
    local S0 = S3..S4
    return S0
end
function StrToBinStr(Com)
    local RetNR = ''
    for var=1, #Com, 1 do
        local one = string.byte(Com,var)
        RetNR = RetNR..string.format("%02X",one)
    end
    return RetNR
end
function Calc2Distance(ax, ay, bx, by)
	return math.sqrt((ax - bx) * (ax - bx) + (ay - by) * (ay - by))
end
function Calc3Distance(ax, ay, az, bx, by, bz)
	return math.sqrt((ax - bx) * (ax - bx) + (ay - by) * (ay - by) + (az - bz) * (az - bz))
end
function Sleep(Num)
    MySleep(Num)
end
--GameAbout
function GoToMap(MapIndex)
	SendData('0C0000005F000000' .. DwordToBinStr(MapIndex))
end
function GoToFeiTian()
	SendData('0D000000C10200000700000000')
end
function ReviveToFetTian()
    SendData('1100000079000000020000000000000000')
end
function RepairAll(NpcID)
    local Data = '1A0000005F010000' .. QwordToBinStr(NpcID) .. '00000000000000000003'
	SendData(Data)
end
function RepairOne(NpcID,ItemID)
    local Data = '1A0000005F010000' .. QwordToBinStr(NpcID) .. QwordToBinStr(ItemID)..'0101'
	SendData(Data)
end
function PutOnItem(ItemID,Index)
    local Data = '190000004300000000010100'..QwordToBinStr(ItemID)..DwordToBinStr(Index)..'00'
	SendData(Data)
end
function PutUpItem(ItemID,Index)
    local Data = '190000004300000001010100'..QwordToBinStr(ItemID)..DwordToBinStr(Index)..'00'
	SendData(Data)
end
function CaiJiBegin(ItemID)
    local Data = '1100000073000000'..QwordToBinStr(ItemID)..'01'
	SendData(Data)
end
function CaiJiEnd(ItemID)
    local Data = '1100000073000000'..QwordToBinStr(ItemID)..'02'
	SendData(Data)
end
--LogicMini
function GetMapID()
    local Ret = {}
    local LocalPlayer = 玩家数据()
    Ret = LocalPlayer.MapID
    return Ret
end
function IsOpenAutoCaiJi()
    local Ret = {}
    local LocalPlayer = 玩家数据()
    Ret = LocalPlayer.IsOpenAutoCaiJi
    return Ret
end
function IsDie()
    local LocalPlayer = 玩家数据()
    if LocalPlayer.HP == 0 then
        return true
    end
    return false
end
function GetOjb_XYZ(ObjName, X, Y, FanWei)
    local Ret = {}
	local 环境 = 环境数据()
	for i, v in ipairs(环境) do
        if v.ObjName == ObjName then
            local Dis = Calc2Distance(X,Y,v.X,v.Y)
            if Dis < FanWei then
                Ret = v
                break
            end
        end
	end
    return Ret
end
function GetEquipChiJiu(In_Index)
    local Ret = {}
    local 装备 = 装备数据()
    for i, v in ipairs(装备) do
        if v.Index == In_Index then
            Ret = v.ChiJiu
            break
        end
    end
    return Ret
end
function MapNameToMapID(MapName)
    local DataInfo = {
        ['银杏村'] = 101,
        ['银杏村野外'] = 102,
        ['飞天'] = 103,
        ['飞天郊外'] = 104,
        ['红名村'] = 111,
        ['沃玛洞穴一层'] = 211,
        ['飞天密谷一层'] = 1211,
        ['飞天密谷二层'] = 1212,
        ['飞天密谷三层'] = 1213,
        ['飞天密谷四层'] = 1214,
    }
    local GetData = DataInfo[MapName]
    if GetData == nil then return 0 end
    return GetData
end
function IsInMap(MapName)
    local DataInfo = {
        ['银杏村'] = 101,
        ['银杏村野外'] = 102,
        ['飞天'] = 103,
        ['飞天郊外'] = 104,
        ['红名村'] = 111,
        ['沃玛洞穴一层'] = 211,
        ['飞天密谷一层'] = 1211,
        ['飞天密谷二层'] = 1212,
        ['飞天密谷三层'] = 1213,
        ['飞天密谷四层'] = 1214,
    }

    local GetData = DataInfo[MapName]
    if GetData == nil then return false end
    if GetData ~= GetMapID() then return false end
    return true
end

function 获取距离目标距离(MX, MY, MZ)
	local 玩家 = 玩家数据()
	return Calc3Distance(玩家.X,玩家.Y,玩家.Z,MX,MY,MZ)
end

function 寻路_直到目标(MX, MY, MZ,超时)
    超时 = 超时 or 20
    local BeginTimer = os.time()
	MovToXYZ(MX, MY, MZ)
	while true do
        if IsDie() == true then break end
        if 获取距离目标距离(MX,MY,MZ) < 150 then return end
        if os.time() - BeginTimer > 超时 then return end
		Sleep(500)
	end
end

function 判断是否是锄头(v)
    if next(v) == nil then return false end
    if v.Type == 29521 then return true end
    if v.Type == 29522 then return true end
    if v.Type == 29523 then return true end
    return false
end

function 飞天修理包裹锄头()
    local Npc = GetOjb_XYZ('NPC_BP_C',17278,18281,1000)
    if next(Npc) ~= nil then return end
    local 包裹 = 包裹数据()
    for i, v in ipairs(包裹) do
        if 判断是否是锄头(v) == true then
            if v.ChiJiu < 120 then
                RepairOne(Npc.ID_NPC,v.ID)
                Sleep(500)
            end
        end
    end
end

function 飞天修理全身装备_包裹锄头()
    local Npc = GetOjb_XYZ('NPC_BP_C',17278,18281,1000)
    if next(Npc) ~= nil then
        RepairAll(Npc.ID_NPC)
    end
    飞天修理包裹锄头()
end

function 是否可以挖矿(v,X,Y,FanWei)
    if v.ObjName ~= 'Collect_BP_C' then return false end
    if v.IsCanWaKuang == 0 then return false end
    local Dis = Calc2Distance(X,Y,v.X,v.Y)
    if Dis > FanWei then return false end
    return true
end

function 获得坐标范围可挖对象(X, Y, FanWei)
    local Ret = {}
	local 环境 = 环境数据()
	for i, v in ipairs(环境) do
        if 是否可以挖矿(v,X,Y,FanWei) == true then
            Ret = v
            break
        end
	end
    return Ret
end

function 挖矿周围到没矿(范围,超时)
    local BeginTimer = os.time()
    local 挖矿时间 = 0
    while true do
        if os.time() - BeginTimer > 超时 then break end
        if IsDie() == true then break end
        local LocalPlayer =  玩家数据()
        local kuang = 获得坐标范围可挖对象(LocalPlayer.X,LocalPlayer.Y,范围)
        if next(kuang) == nil then break end
        --调试输出(TableToStr(kuang))
        if 挖矿时间 == 0 then
            CaiJiBegin(kuang.ID)
            挖矿时间 = os.time()
        else
            if os.time() - 挖矿时间 > 10 then
                CaiJiEnd(kuang.ID)
                挖矿时间 = 0
            end
        end
        --挖矿(kuang.ID)
        Sleep(2000)
    end
end

function 是否需要回城补充()
    if GetEquipChiJiu(12) > 0 then return false end
    local 包裹 = 包裹数据()--到这里说明手中没持久了
    for i, v in ipairs(包裹) do
        if 判断是否是锄头(v) == true then
            if v.ChiJiu > 0 then
                PutOnItem(v.ID,12)--穿装备
                return false
            end
        end
    end
    return true
end

function 瞬移卷进图(地图,点位)
    local ALL = {
        ['飞天密谷一层'] = {
            ['1']='0D0000007B0000000E7C120001',
            ['2']='0D0000007B0000000B7C120001',
            ['3']='0D0000007B000000107C120001',
            ['4']='0D0000007B0000000D7C120001',
            ['5']='0D0000007B000000117C120001',
            ['6']='0D0000007B0000000C7C120001',
            ['7']='0D0000007B0000000F7C120001',
            ['8']='0D0000007B000000127C120001',
            ['9']='0D0000007B000000097C120001',
            ['10']='0D0000007B0000000A7C120001',
        },
        ['飞天密谷二层'] = {},
        ['飞天密谷三层'] = {},
        ['飞天密谷四层'] = {},
    }
    local Data = ALL[地图][点位]
	SendData(Data)
end

function 进图挖矿(地图,矿点)
    if 是否需要回城补充() == true then return end
    if IsDie() == true then return end
    if IsInMap(地图) == false then
        瞬移卷进图(地图,矿点)
        Sleep(10000)
    end
    if IsOpenAutoCaiJi() == 0 then
        热键自动挖矿()
    end
end

function 检测回城()
    if 是否需要回城补充() == false then return end
    调试输出('<<<<回城修理>>>>')
    GoToFeiTian()
    Sleep(10000)
    寻路_直到目标(16580,17560,5651)
    飞天修理全身装备_包裹锄头()
    Sleep(1000)
end

function 检测死亡()
    if IsDie() == false then return end
    调试输出('<<<<复活回城>>>>')
    ReviveToFetTian()
    Sleep(10000)
end

function 自动挖矿(地图,矿点)
    调试输出('<<<<自动挖矿开始>>>>')
    local BeginTimer = os.time()
    while true do

        if os.time() - BeginTimer > 300 then break end

        检测回城()

        检测死亡()

        进图挖矿(地图,矿点)

        Sleep(500)
    end

end

function 远程挖矿(超时)
    挖矿周围到没矿(600,超时)
end

