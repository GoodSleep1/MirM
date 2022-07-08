--���Ŀ�2.1
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
    local LocalPlayer = �������()
    Ret = LocalPlayer.MapID
    return Ret
end
function IsOpenAutoCaiJi()
    local Ret = {}
    local LocalPlayer = �������()
    Ret = LocalPlayer.IsOpenAutoCaiJi
    return Ret
end
function IsDie()
    local LocalPlayer = �������()
    if LocalPlayer.HP == 0 then
        return true
    end
    return false
end
function GetOjb_XYZ(ObjName, X, Y, FanWei)
    local Ret = {}
	local ���� = ��������()
	for i, v in ipairs(����) do
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
    local װ�� = װ������()
    for i, v in ipairs(װ��) do
        if v.Index == In_Index then
            Ret = v.ChiJiu
            break
        end
    end
    return Ret
end
function MapNameToMapID(MapName)
    local DataInfo = {
        ['���Ӵ�'] = 101,
        ['���Ӵ�Ұ��'] = 102,
        ['����'] = 103,
        ['���콼��'] = 104,
        ['������'] = 111,
        ['���궴Ѩһ��'] = 211,
        ['�����ܹ�һ��'] = 1211,
        ['�����ܹȶ���'] = 1212,
        ['�����ܹ�����'] = 1213,
        ['�����ܹ��Ĳ�'] = 1214,
    }
    local GetData = DataInfo[MapName]
    if GetData == nil then return 0 end
    return GetData
end
function IsInMap(MapName)
    local DataInfo = {
        ['���Ӵ�'] = 101,
        ['���Ӵ�Ұ��'] = 102,
        ['����'] = 103,
        ['���콼��'] = 104,
        ['������'] = 111,
        ['���궴Ѩһ��'] = 211,
        ['�����ܹ�һ��'] = 1211,
        ['�����ܹȶ���'] = 1212,
        ['�����ܹ�����'] = 1213,
        ['�����ܹ��Ĳ�'] = 1214,
    }

    local GetData = DataInfo[MapName]
    if GetData == nil then return false end
    if GetData ~= GetMapID() then return false end
    return true
end

function ��ȡ����Ŀ�����(MX, MY, MZ)
	local ��� = �������()
	return Calc3Distance(���.X,���.Y,���.Z,MX,MY,MZ)
end

function Ѱ·_ֱ��Ŀ��(MX, MY, MZ,��ʱ)
    ��ʱ = ��ʱ or 20
    local BeginTimer = os.time()
	MovToXYZ(MX, MY, MZ)
	while true do
        if IsDie() == true then break end
        if ��ȡ����Ŀ�����(MX,MY,MZ) < 150 then return end
        if os.time() - BeginTimer > ��ʱ then return end
		Sleep(500)
	end
end

function �ж��Ƿ��ǳ�ͷ(v)
    if next(v) == nil then return false end
    if v.Type == 29521 then return true end
    if v.Type == 29522 then return true end
    if v.Type == 29523 then return true end
    return false
end

function �������������ͷ()
    local Npc = GetOjb_XYZ('NPC_BP_C',17278,18281,1000)
    if next(Npc) == nil then return end
    local ���� = ��������()
    for i, v in ipairs(����) do
        if �ж��Ƿ��ǳ�ͷ(v) == true then
            if v.ChiJiu < 120 then
                RepairOne(Npc.ID_NPC,v.ID)
                Sleep(500)
            end
        end
    end
end

function ��������ȫ��װ��_������ͷ()
    local Npc = GetOjb_XYZ('NPC_BP_C',17278,18281,1000)
    if next(Npc) ~= nil then
        RepairAll(Npc.ID_NPC)
    end
    �������������ͷ()
end

function �Ƿ�����ڿ�(v,X,Y,FanWei)
    if v.ObjName ~= 'Collect_BP_C' then return false end
    if v.IsCanWaKuang == 0 then return false end
    local Dis = Calc2Distance(X,Y,v.X,v.Y)
    if Dis > FanWei then return false end
    return true
end

function ������귶Χ���ڶ���(X, Y, FanWei)
    local Ret = {}
	local ���� = ��������()
	for i, v in ipairs(����) do
        if �Ƿ�����ڿ�(v,X,Y,FanWei) == true then
            Ret = v
            break
        end
	end
    return Ret
end

function �Ƿ���Ҫ�سǲ���()
    if GetEquipChiJiu(12) > 0 then return false end
    local ���� = ��������()--������˵������û�־���
    for i, v in ipairs(����) do
        if �ж��Ƿ��ǳ�ͷ(v) == true then
            if v.ChiJiu > 0 then
                PutOnItem(v.ID,12)--��װ��
                return false
            end
        end
    end
    return true
end

function �ڿ���Χ��û��(��Χ,��ʱ)
    local BeginTimer = os.time()
    local �ڿ�ʱ�� = 0
    while true do
        if os.time() - BeginTimer > ��ʱ then break end
        if �Ƿ���Ҫ�سǲ���() == true then return end
        if IsDie() == true then break end
        local LocalPlayer =  �������()
        local kuang = ������귶Χ���ڶ���(LocalPlayer.X,LocalPlayer.Y,��Χ)
        if next(kuang) == nil then break end
        --�������(TableToStr(kuang))
        if �ڿ�ʱ�� == 0 then
            CaiJiBegin(kuang.ID)
            �ڿ�ʱ�� = os.time()
        else
            if os.time() - �ڿ�ʱ�� > 10 then
                CaiJiEnd(kuang.ID)
                �ڿ�ʱ�� = 0
            end
        end
        --�ڿ�(kuang.ID)
        Sleep(2000)
    end
end

function ˲�ƾ��ͼ(��ͼ,��λ)
    local ALL = {
        ['�����ܹ�һ��'] = {
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
        ['�����ܹȶ���'] = {},
        ['�����ܹ�����'] = {},
        ['�����ܹ��Ĳ�'] = {},
    }
    local Data = ALL[��ͼ][��λ]
	SendData(Data)
end

function ��ͼ�ڿ�(��ͼ,���)
    if �Ƿ���Ҫ�سǲ���() == true then return end
    if IsDie() == true then return end
    if IsInMap(��ͼ) == false then
        ˲�ƾ��ͼ(��ͼ,���)
        Sleep(10000)
    end
    if IsOpenAutoCaiJi() == 0 then
        �ȼ��Զ��ڿ�()
    end
end

function ���س�()
    if �Ƿ���Ҫ�سǲ���() == false then return end
    �������('<<<<�س�����>>>>')
    GoToFeiTian()
    Sleep(10000)
    Ѱ·_ֱ��Ŀ��(16580,17560,5651)
    ��������ȫ��װ��_������ͷ()
    Sleep(1000)
end

function �������()
    if IsDie() == false then return end
    �������('<<<<����س�>>>>')
    ReviveToFetTian()
    Sleep(10000)
end

function �Զ��ڿ�(��ͼ,���)
    �������('<<<<�Զ��ڿ�ʼ>>>>')
    local BeginTimer = os.time()
    while true do

        if os.time() - BeginTimer > 300 then break end

        ���س�()

        �������()

        ��ͼ�ڿ�(��ͼ,���)

        Sleep(500)
    end

end

function Զ���ڿ�(��ʱ)
    �ڿ���Χ��û��(800,��ʱ)
end

