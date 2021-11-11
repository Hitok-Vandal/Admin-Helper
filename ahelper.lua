script_name("Admin-Helper")
script_authors("Alex_Benson")
script_version("0.1.0")

require "lib.sampfuncs"
require "lib.moonloader"
local bse, se               = pcall(require, "lib.samp.events")
local bInicfg, inicfg       = pcall(require, "inicfg")
local bImgui, imgui         = pcall(require, "imgui")
local bMemory, memory       = pcall(require, "memory")
local dlstatus = require("moonloader").download_status
local vkeys = require 'vkeys'
local encoding = require "encoding"
local ffi = require 'ffi'
local cast = ffi.cast
local draw_dist = cast('float *', 0x00B7C4F0)

cast('unsigned char *', 0x005609FF)[0] = 0xEB
cast('unsigned char *', 0x00561344)[0] = 0xEB

local data =
{
	Settings =
	{
		Time = 12,
		Weather = 1,
		Distance = 900.0,
		Static = true
	}
}
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local str_post = "�������������"
local mc, sc, wc = '{2090FF}', '{00AAFF}', '{FFFFFF}'
local tag = 'Admin-Helper � '..wc
local devmode = false
local mcx = 0x2090FF
local MsgDelay = 0.5
local sex = 1
local avtoUpdate = true
local sampfuncsNot = [[
 �� ��������� ���� SAMPFUNCS.asi � ����� ����, ���������� ����
������� �� ������� �����������.

		��� ������� ��������:
1. �������� ����;
2. ��������� ������������ ��������� ��� � �� ���������� ������� ����� ���� � ����������.
� ��������� ����������: 
�������� Windows, McAfree, Avast, 360 Total � ������.
� ��� ��� ������ � ���������� ����� �������������� ����������.
3. ����������� ��������� ��������� �������.

��� ������������� ������� ����������� � ��������� ������������:
		vk.me/nik446

���� ���� ��������, ������� ������ ���������� ������. 
]]

local errorText = [[
		  ��������! 
�� ���������� ��������� ������ ����� ��� ������ �������.
� ��������� ����, ������ �������� ��������.
	������ �������������� ������:
		%s

		��� ������� ��������:
1. �������� ����;
2. ��������� ������������ ��������� ��� � �� ���������� ������� ����� ���� � ����������.
� ��������� ����������: 
�������� Windows, McAfree, Avast, 360 Total � ������.
� ��� ��� ������ � ���������� ����� �������������� ����������.
3. ����������� ��������� ��������� �������.

��� ������������� ������� ����������� � ��������� ������������:
		vk.me/nik446

���� ���� ��������, ������� ������ ���������� ������. 
]]

function main()
	if autoUpdate == true then
	autoupdate("��� ������ �� ��� json", "��� ������ �� ��� ����/url ������ ������� �� ������ (���� ���, �������� ��� � json)")
	end
	log(script.this.name .. ' v' .. script.this.version)
	log('�����: ' .. table.concat(script.this.authors, ', '))
	local values = inicfg.load(data, "Admin-Helper.ini")
	inicfg.save(values, "Admin-Helper.ini")
	lockPlayerControl(false)
		sampfuncsRegisterConsoleCommand("arep", function(bool) 
			if tonumber(bool) == 1 then 
				arep = true 
				print("Rep: On")
			else 
				arep = false 
			end 
		end)
		-- ������
		sampRegisterChatCommand("psettime", setTime)
		sampRegisterChatCommand("psetweather", setWeather)
		sampRegisterChatCommand("psetd", setDistance)
		-- ������� ��� �������������� � ��������
		sampRegisterChatCommand("shelp", funCMD.help)
		sampRegisterChatCommand("dev", funCMD.dev)
		sampRegisterChatCommand("setpost", funCMD.setpost)
		sampRegisterChatCommand("slitcar", funCMD.cargos)
		sampRegisterChatCommand("sellcar", funCMD.comblock)
		sampRegisterChatCommand("about", funCMD.about)
		-- ������� ��� ����
		sampRegisterChatCommand("faminv", funCMD.finvrp)
		sampRegisterChatCommand("finv", funCMD.finvnonrp)
		sampRegisterChatCommand("fm", funCMD.fammenu)
		-- ������� ��� ������
		sampRegisterChatCommand("noveh", funCMD.noveh)
		sampRegisterChatCommand("noflip", funCMD.noflip)
		sampRegisterChatCommand("noname", funCMD.noname)
		sampRegisterChatCommand("nouval", funCMD.nouval)
		sampRegisterChatCommand("nosp", funCMD.nosp)
		-- ������� ��� �������� �� 9 � 10
		sampRegisterChatCommand("inv", funCMD.inv)
		sampRegisterChatCommand("unv", funCMD.unv)
		sampRegisterChatCommand("gr", funCMD.giverank)
		sampRegisterChatCommand("cjp", funCMD.cjp)
		sampRegisterChatCommand("jobp", funCMD.jobp)
		sampRegisterChatCommand("mb", funCMD.members)
		sampRegisterChatCommand("orgmb", funCMD.orgmb)
		-- ������� ������ ��� �������
		sampRegisterChatCommand("cj", funCMD.cj)
		sampRegisterChatCommand("bug", funCMD.bug)
		sampRegisterChatCommand("flip", funCMD.flip)
		sampRegisterChatCommand("ghcar", funCMD.getherecar)
		sampRegisterChatCommand("delops", funCMD.delops)
		sampRegisterChatCommand("getcar", funCMD.getherecar)
		sampRegisterChatCommand("hl", funCMD.heal)
		sampRegisterChatCommand("kill", funCMD.kill)
		sampRegisterChatCommand("slap", funCMD.slap)
		sampRegisterChatCommand("spawn", funCMD.spawn)
		cout('������ ������� ��������.')
		if sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) == 'Alex_Benson' then
		cout('�� ����� ��� �����������!')
		devmode = true
	end
	while true do
		wait(0)
		local values = inicfg.load(data, "Admin-Helper.ini")
		if values.Settings.Static then
			if values.Settings.Time ~= memory.read(0xB70153, 1, false) then memory.write(0xB70153, values.Settings.Time, 1, false) end
			if values.Settings.Weather ~= memory.read(0xC81320, 2, false) then memory.write(0xC81320, values.Settings.Weather, 2, false) end
			if values.Settings.Distance ~= memory.read(0x00B7C4F0, 4, false) then weatmain(values.Settings.Distance) end
		end
	end
end

function cout(message)
	message = message:gsub('{M}', mc)
	message = message:gsub('{W}', wc)
	message = message:gsub('{S}', sc)
	sampAddChatMessage(tag .. message, mcx)
end

funCMD = {} 
function funCMD.help()
	sampShowDialog(1999, "��� ������� �������:", string.format([[
{FF7F7F}������� ��� �������������� � ��������:
{2090FF}/shelp {FFFFFF}- ������ � �������
{2090FF}/dev {FFFFFF}- ��������/��������� ����� �������
{2090FF}/setpost [���������]{FFFFFF}- ��������/��������� ����� �������
{2090FF}/slitcar{FFFFFF}- ������� ������ � ����
{2090FF}/about{FFFFFF}- ���������� � �������

{FF7F7F}������� ��� ���� ���������������:
{2090FF}/kill [ID]{FFFFFF}- ����� ������
{2090FF}/hl [ID]{FFFFFF}- �������� ������
{2090FF}/getcar [ID]{FFFFFF}- �� ��������� � ����
{2090FF}/ghcar [ID]{FFFFFF}- �� ��������� � ����
{2090FF}/delops [ID] [PayDay] [reason]{FFFFFF}- ������� �������� ������
{2090FF}/flip [ID]{FFFFFF}- �������� ������
{2090FF}/spawn [ID]{FFFFFF}- ���������� ������
{2090FF}/slap [ID] [1/2]{FFFFFF}- ���������� ������
{2090FF}/cj [ID]{FFFFFF}- ����� � �� ������� ������
{2090FF}/bug [ID]{FFFFFF}- �������� ������ � �������� � ������� �������
{2090FF}/noname [ID]{FFFFFF}- ��������� ������� ����� ���

{FF7F7F}������� ��� ������ �������:
{2090FF}/noveh{FFFFFF}- �� ������ ����������
{2090FF}/nosp{FFFFFF}- �� �������
{2090FF}/nouval{FFFFFF}- �� ���������
{2090FF}/noflip{FFFFFF}- �� �������

{FF7F7F}���������� ������� � ��������:
{2090FF}/psettime [�� 0 �� 24]{FFFFFF}- �������� �������� �����
{2090FF}/psetweather [�� 0 �� 45] {FFFFFF}- �������� �������� ������
{2090FF}/psetd [�� 101 �� 3600]{FFFFFF}- �������� ��������� ����������

{FF7F7F}������� ��� �������� �� �����������:
{2090FF}/inv [ID]{FFFFFF}- �������� ������� /invite
{2090FF}/unv [ID] [reason]{FFFFFF}- �������� ������� /uninvite
{2090FF}/gr [ID] [rank]{FFFFFF}- �������� ������� /giverank
{2090FF}/mb{FFFFFF}- �������� ������� /members
{2090FF}/orgmb [ID]{FFFFFF}- �������� ������� /orgmembers
{2090FF}/jobp{FFFFFF}- �������� ������� /jobprogress
{2090FF}/cjp [ID]{FFFFFF}- �������� ������� /checkjobprogress

{FF7F7F}������� ��� �������������� � �����:
{2090FF}/fm{FFFFFF}- ���� �����
{2090FF}/finv [ID]{FFFFFF}- ���������� � ���� ��� ��
{2090FF}/faminv [ID]{FFFFFF}- ���������� � ���� � ��]]),"�������")
end

function funCMD.about()
	sampShowDialog(1949, "���������� � �������", string.format([[
{FF7F7F}Admin-Helper:
{2090FF}������ �������:{FFFFFF} 0.1.0 beta
{2090FF}������� �����������:{FFFFFF} Alex_Benson

{FFFFFF}������ ������ ��� ������ ������������� � ������ 
{FF7F7F}�� ����� ������ �� ������������� ���� ������ ��� ������ Admin Tools
{FF7F7F}���� ������ � ����� � ��� �� ����� �� ������ ��������� ���

{FFFFFF}���� �������� �������������{2090FF} ������� ��������
{FFFFFF}�� ������ � ������� ������ lua ��������

{FFFFFF}��� ����� � ������������ �����������:
{FF7F7F}���������: {2090FF}vk.com/nik446
{FF7F7F}Telegram: {2090FF}t.me/hit_vandal]]),"�������")
end

function se.onSendChat(msg)
	if msg:find('{my_id}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		msg = msg:gsub('{my_id}', tostring(id))
		return { msg }
	end
	
	if msg:find('{script_name}') then
		local name = script_name
		msg = msg:gsub('{script_name}', tostring(id))
		return { msg }
	end
	
	if msg:find('{script_authors}') then
		local name = script_authors
		msg = msg:gsub('{script_authors}', tostring(id))
		return { msg }
	end
	
	if msg:find('{script_version}') then
		local name = script_version
		msg = msg:gsub('{script_version}', tostring(id))
		return { msg }
	end

	if msg:find('{my_name}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		msg = msg:gsub('{my_name}', rpNick(id))
		return { msg }
	end
	
	if msg:find('{sex:%A+|%A+}') then
        local male, female = msg:match('{sex:(%A+)|(%A+)}')
        if cfg.main.sex == 1 then
        	local returnMsg = msg:gsub('{sex:%A+|%A+}', male, 1)
        	sampSendChat(tostring(returnMsg))
        	return false
        else
        	local returnMsg = msg:gsub('{sex:%A+|%A+}', female, 1)
        	sampSendChat(tostring(returnMsg))
        	return false
        end
    end
end

function se.onSendCommand(cmd)
	if cmd:find('{my_id}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		cmd = cmd:gsub('{my_id}', tostring(id))
		return { cmd }
	end
	
	if cmd:find('{script_name}') then
		local id = script_name
		cmd = cmd:gsub('{script_name}', tostring(id))
		return { cmd }
	end
	
	if cmd:find('{script_authors}') then
		local id = script_authors
		cmd = cmd:gsub('{script_authors}', tostring(id))
		return { cmd }
	end
	
	if cmd:find('{script_version}') then
		local id = script_version
		cmd = cmd:gsub('{script_version}', tostring(id))
		return { cmd }
	end

	if cmd:find('{my_name}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		cmd = cmd:gsub('{my_name}', rpNick(id))
		return { cmd }
	end

	if cmd:find('{sex:%A+|%A+}') then
        local male, female = cmd:match('{sex:(%A+)|(%A+)}')
        if cfg.main.sex == 1 then
        	local returnMsg = cmd:gsub('{sex:%A+|%A+}', male, 1)
        	sampSendChat(tostring(returnMsg))
        	return false
        else
        	local returnMsg = cmd:gsub('{sex:%A+|%A+}', female, 1)
        	sampSendChat(tostring(returnMsg))
        	return false
        end
    end
end

function log(text)
	sampfuncsLog(mc..'Admin-Helper: '..wc..text)
end

function play_message(delay, text_array)
	SPEAKING = lua_thread.create(function()
		for i, line in ipairs(text_array) do
			sampSendChat(string.format(line[1], table.unpack(line, 2)))
			if i ~= #text_array then
				wait(delay * 1000)
			elseif screen == true then
				wait(1000)
			end
		end
		SPEAKING = nil
	end)
	return true
end

function setTime(time)
	local time = tonumber(time)
	if time < 0 or time > 23 then cout('���������� ����: {2090FF}/psettime [0-23]') else
		cout('����� ����������� �� {2090FF}'..time)
		local values = inicfg.load(data, "Admin-Helper.ini")
		if values.Settings.Static then
			values.Settings.Time = time
			inicfg.save(values, "Admin-Helper.ini")
		else memory.write(0xB70153, time, 1, false)
		end
	end
end

function setDistance(param)
	param = tonumber(param)
	if param > 3600.0 or param < 101.0 then cout('���������� ����: {2090FF}/psetd [101-3600]') return false end
	weatmain(param)
	cout('��������� ���������� ����������� �� {2090FF}'..param)
end

function weatmain(dist)
	local values = inicfg.load(data, "Admin-Helper.ini")
	draw_dist[0] = dist
	values.Settings.Distance = dist
	inicfg.save(values, "Admin-Helper.ini")
end

function setWeather(weather)
	local weather = tonumber(weather)
	if weather < 0 or weather > 45 then cout('���������� ����: {2090FF}/psetweather [0-45]') else
		if message then
			cout('������ ����������� �� {2090FF}'..weather)
		end
		local values = inicfg.load(data, "Admin-Helper.ini")
		if values.Settings.Static then
			memory.write(0xC81320, weather, 2, false)
			memory.write(0xC81318, weather, 2, false)
			values.Settings.Weather = weather
			inicfg.save(values, "Admin-Helper.ini")
		else
			memory.write(0xC81320, weather, 2, false)
		end
	end
end

function setStatic(static)
	if static == "true" then
		cout('Static state: {2090FF}true')
		local values = inicfg.load(data, "Admin-Helper.ini")
		values.Settings.Static = true
		inicfg.save(values, "Admin-Helper.ini")
	elseif static == "false" then
		cout('Static state: {2090FF}false')
		local values = inicfg.load(data, "Admin-Helper.ini")
		values.Settings.Static = false
		inicfg.save(values, "Admin-Helper.ini")
	end
end

function funCMD.cj(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/spplayer %s", id },
				{ "/gethere %s", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	cout('���������: /cj [ID]')
	return
end

function funCMD.setpost(text)
	if #text > 0 then
		cout(string.format('�� �������� �������� ����� ���������: {M}%s{W} -> {M}%s{W} ', str_post, text))
		str_post = text
	else
	cout('��������� /setpost [���������]')
	end
end

function funCMD.finvnonrp(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/faminvite %s", id }
			})
		end
		cout('������ ������ ��� � ����!')
		return
	end
	cout('���������: /finv [id]')
	return
end
	
function funCMD.finvrp(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/me ������ ������� � ������ ���� ������ �����" },
				{ "/me ������� � ������ ������������ � ���� ���� ���������� ����������� %s", rpNick(id) },
				{ "/me ������� ����������� ����� �����" },
				{ "/faminvite %s", id }
			})
		end
		cout('������ ������ ��� � ����!')
		return
	end
	cout('���������: /finv [id]')
	return
end
	
function funCMD.spawn(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/spplayer %s", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	play_message(MsgDelay, {
				{ "/spawn"}
			})
	return
end
	
function funCMD.flip(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/flip %s", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	play_message(MsgDelay, {
				{ "/flip {my_id}"}
			})
	return
end
	
function funCMD.inv(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/invite %s", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	cout('���������: /inv [id]')
	return
end
	
function funCMD.giverank(args)
	local id, rank = args:match('^%s*(%d+) (%d+)')
	if id ~= nil and rank ~= nil then
		id, rank = tonumber(id), tonumber(rank)
		local result, dist = getDistBetweenPlayers(id)
		if result and dist < 5 then
			if rank >= 1 and rank <= 9 then
				play_message(MsgDelay, {
					{ "/giverank %s %s", id, rank }
				})
				return
			end
			cout('������� ��������� �� 1 �� 9!')
			return
		end
		cout('�� ������ �� ����� ����������!')
		return
	end
	cout('���������: /gr [id] [����]')
	return
end

function funCMD.unv(args)
	local id, reason = args:match('^%s*(%d+) (.+)')
	if id ~= nil and reason ~= nil then
		id = tonumber(id)
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/uninvite %s %s", id, reason }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	cout('���������: /unv [id] [�������]')
end
	
function funCMD.orgmb(id)
	local id = tonumber(id)
	if id ~= nil then
		play_message(MsgDelay, {
			{ "/orgmembers %s", id }
		})
		return
	end
	play_message(MsgDelay, {
				{ "/orgmembers"}
			})
	return
end
	
function funCMD.slap(text)
	if #text > 0 then
		sampSendChat('/slap '..text..' 1')
	else
		play_message(MsgDelay, {
			{ "/slap {my_id} 1"}
		})
	end
end
	
function funCMD.heal(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/sethp %s 100", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	play_message(MsgDelay, {
			{ "/sethp {my_id} 100"}
		})
	return
end
	
function funCMD.kill(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/sethp %s 0", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	play_message(MsgDelay, {
		{ "/sethp {my_id} 0"}
	})
	return
end
	
function funCMD.bug(id)
	local id = tonumber(id)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			play_message(MsgDelay, {
				{ "/jail %s 5 ���", id },
				{ "/unjail %s ���", id },
				{ "/gethere %s", id }
			})
			return
		end
		cout('������ ������ ��� � ����!')
		return
	end
	cout('���������: /bug [id]')
	return
end
	
function funCMD.getherecar(id)
	play_message(MsgDelay, {
		{ "/getherecar %s", id }
	})
end
	
function funCMD.cjp(id)
	play_message(MsgDelay, {
		{ "/checkjobprogress %s", id }
	})
end
	
function funCMD.delops(id)
	play_message(MsgDelay, {
		{ "/adeldesc %s", id }
	})
end
	
function funCMD.noflip(id)
	play_message(MsgDelay, {
		{ "/pm %s 0 �� �����/�������������� ������� �� ������� ��.", id },
		{ "/pm %s 0 �� �����/�������������� �������� ������ �� ������ ��...", id },
		{ "/pm %s 0 ...���� ������ ���� 700.", id },
		{ "/pm %s 0 �� ���� ��������� ������� �� �� ������� ������� �� ����� ������.", id }
	})
end

function funCMD.nouval(id)
	play_message(MsgDelay, {
		{ "/pm %s 0 �� ��������� ������ � ��� ������...", id },
		{ "/pm %s 0 ...����� ����� �� �������� ���� ������ � �����������", id },
		{ "/pm %s 0 �� ���� ��������� ������� �� �� ������� ������� �� ����� ������.", id },
		{ "/pm %s 0 � ����� �� ����������� ���� ����� �� �� �� � ����", id },
		{ "/pm %s 0 ��� ��� �� ��� �� ����� �������. �������� ������", id }
	})
end
	
function funCMD.noname(id)
	play_message(MsgDelay, {
		{ "/pm %s 0 �� ���� ��������������� �� ������� ���� ��� � ��� ����� ���", id },
		{ "/pm %s 0 �� ����� ������� ��������� ������ � ����� �����", id },
		{ "/pm %s 0 ���� �� ������ ���������� ���� �� ������� �� �������� ���� �� ���", id },
		{ "/pm %s 0 ������ ���� ������ ���� \"���_�������\"", id },
		{ "/pm %s 0 ��������: Alex_Benson ��� Cristopher_Dills", id }
	})
end
	
function funCMD.nosp(id)
	play_message(MsgDelay, {	
		{ "/pm %s 0 ��� ��������� �������� ���� �� �������� � ������� ������ �� ����.", id },
		{ "/pm %s 0 ���� �� ���������� ��� �� ���� ����� � ����.", id },
		{ "/pm %s 0 �� ���� ��������� ������� �� �� ������� �� ����� ������.", id }
	})
end
	
function funCMD.noveh(id)
	play_message(MsgDelay, {	
		{ "/pm %s 0 �� ����� ������ ��������� ��� ������� ���� 700 �������", id },
		{ "/pm %s 0 ��� ������� ��� ����� ���������� � ������ ����� ����� � ����� ���� �����.", id },
		{ "/pm %s 0 �� ���� ��������� ������� �� �� ������ ��������� ������� �� ����� ������.", id }
	})
end

function funCMD.comblock(id)
	cout('�� �����! ����������� /sellcarto(���� ������ ����� � ���� �� /slitcar)')
end

function funCMD.cargos(id)
	play_message(MsgDelay, {
		{ "/sellcar" }
	})
end

function funCMD.members(id)
	play_message(MsgDelay, {{ "/members" } })
end
	
function funCMD.fammenu(id)
	play_message(MsgDelay, {{ "/fammenu" } })
end

function funCMD.jobp(id)
	play_message(MsgDelay, {
		{ "/jobprogress %s", id }
	})
end

function funCMD.dev(id)
	if devmode == false then
		cout('{FF7F7F}�������� �� ������������ ����� �������!')
		cout('{FF7F7F}��� �������� ������� ������� ���� �������� ��� ������ �����������!')
		cout('{FF7F7F}����������� �� ����������� ��������� ������ ������� � ������ �������!')
		cout('��� ���������� � ����/������������ �������� ����� ������� �����������!')
		cout('��� ���������� ����������� /dev ��������')
		devmode = true
	elseif devmode then
		cout('�� ��������� ����� �������!')
		devmode = false
	end
end

function autoupdate(json_url, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                cout('���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      cout('���������� ���������!')
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        cout('���������� ������ ��������. �������� ���������� ������..')
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end