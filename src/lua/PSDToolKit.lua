local P = {}

local function print(obj, msg)
  obj.load("figure", "\148\119\140\105", 0, 1, 1)
  obj.alpha = 0.75
  obj.draw()
  obj.setfont("MS UI Gothic", 16, 0, "0xffffff", "0x000000")
  obj.load("text", "<s,,B>" .. msg)
  obj.draw()
  -- �e�L�X�g�̂ڂ₯�h�~
  obj.cx = obj.w % 2 == 1 and 0.5 or 0
  obj.cy = obj.h % 2 == 1 and 0.5 or 0
end

local function getpixeldata(obj, width, height)
  local maxw, maxh = obj.getinfo("image_max")
  if width > maxw then
    width = maxw
  end
  if height > maxh then
    height = maxh
  end
  obj.setoption("drawtarget", "tempbuffer", width, height)
  obj.copybuffer("obj", "tmp")
  return obj.getpixeldata()
end

local function fileexists(filepath)
  local f = io.open(filepath, "rb")
  if f ~= nil then
    f:close()
    return true
  end
  return false
end

local PSDState = {}

function PSDState.new(id)
  return setmetatable({
    id = id,
    file = "",
    layer = {},
    scale = 1,
    offsetx = 0,
    offsety = 0,
    rendered = false
  }, {__index = PSDState})
end

function PSDState:addstate(layer)
  table.insert(self.layer, layer)
end

function PSDState:render(obj)
  if self.rendered then
    error("already rendered")
  end
  if self.file == "" then
    error("no image")
  end
  self.rendered = true
  if #self.layer > 0 then
    local layer = {}
    for i, v in ipairs(self.layer) do
      local typ = type(v)
      if typ == "string" then
        table.insert(layer, v)
      elseif typ == "table" and type(v.getstate) == "function" then
        table.insert(layer, v:getstate(self, obj))
      end
    end
    self.layer = table.concat(layer, " ")
  end
  local PSDToolKitBridge = require("PSDToolKitBridge")
  local modified, width, height = PSDToolKitBridge.setprops(self.id, self.file, self)
  if not modified then
    local data, w, h = getpixeldata(obj, width, height)
    if pcall(PSDToolKitBridge.getcache, "cache:"..self.id.." "..self.file, data, w * 4 * h) then
      obj.putpixeldata(data)
      obj.cx = w % 2 == 1 and 0.5 or 0
      obj.cy = h % 2 == 1 and 0.5 or 0
      return
    end
  end
  local data, w, h = getpixeldata(obj, width, height)
  PSDToolKitBridge.draw(self.id, self.file, data, w, h)
  PSDToolKitBridge.putcache("cache:"..self.id.." "..self.file, data, w * 4 * h, false)
  obj.putpixeldata(data)
  obj.cx = w % 2 == 1 and 0.5 or 0
  obj.cy = h % 2 == 1 and 0.5 or 0
end

local Blinker = {}

-- �u���A�j���[�^�[
-- patterns - {'��', '�قڕ�', '���J��', '�قڊJ��', '�J��'} �̃p�^�[�����������z��i�قڕ��A���ځA�قڊJ���͏ȗ��j
-- interval - �A�j���[�V�����Ԋu
-- speed - �A�j���[�V�������x
-- offset - �A�j���[�V�����J�n�ʒu
function Blinker.new(patterns, interval, speed, offset)
  if #patterns > 3 then
    -- 3�R�}�ȏ゠��Ȃ�擪�Ɂu�قڊJ���v�����̂��̂�}������
    -- �J�����قڊJ���������قڕ������ځ��قڊJ�����J���@�̂悤��
    -- ���n�߂�A�j���[�V�����̒���A���Ɉڍs����悤�ɂ���
    table.insert(patterns, 1, patterns[#patterns-1])
  end
  return setmetatable({
    patterns = patterns,
    interval = interval,
    speed = speed,
    offset = offset
  }, {__index = Blinker})
end

function Blinker:getstate(psd, obj)
  local basetime = obj.frame + self.interval + self.offset
  local blink = basetime % self.interval
  local blink2 = (basetime + self.speed*#self.patterns*2) % (self.interval * 5)
  for i, v in ipairs(self.patterns) do
    local l = self.speed*i
    local r = l + self.speed
    if (l <= blink and blink < r)or(l <= blink2 and blink2 < r) then
      return v
    end
  end
  return self.patterns[#self.patterns]
end

local LipSyncSimple = {}

-- ���p�N�i�J�̂݁j
-- patterns - {'��', '�قڕ�', '���J��', '�قڊJ��', '�J��'} �̃p�^�[�����������z��i�قڕ��A���ځA�قڊJ���͏ȗ��j
-- speed - �A�j���[�V�������x
-- layerindex - �A�j���[�V�����Ώۂ̏������C���[�ԍ�
function LipSyncSimple.new(patterns, speed, layerindex)
  return setmetatable({
    patterns = patterns,
    speed = speed,
    layerindex = layerindex,
    talkstates = P.talk
  }, {__index = LipSyncSimple})
end

LipSyncSimple.states = {}

function LipSyncSimple:getstate(psd, obj)
  local volume = 0
  local ts = self.talkstates:get(self.layerindex)
  if ts ~= nil and not ts.used then
    volume = ts.volume
    ts.used = true
  end

  local stat = LipSyncSimple.states[self.layerindex] or {frame = obj.frame-1, n = 0}
  if stat.frame >= obj.frame or stat.frame + obj.framerate < obj.frame then
    -- �����߂��Ă�����A���܂�ɐ�ɐi��ł���悤�Ȃ�A�j���[�V�����̓��Z�b�g����
    -- �v���r���[�ŃR�}��т���ꍇ�͐����������������Ȃ��̂ŁA1�b�̗P�\����������
    stat.n = 0
  end
  if volume >= 1.0 then
    stat.n = stat.n + 1
    if stat.n > #self.patterns * self.speed - 1 then
      stat.n = #self.patterns * self.speed - 1
    end
  else
    stat.n = stat.n - 1
    if stat.n < 0 then
      stat.n = 0
    end
  end
  stat.frame = obj.frame
  LipSyncSimple.states[self.layerindex] = stat
  return self.patterns[math.floor(stat.n / self.speed) + 1]
end

local LipSyncLab = {}

-- ���p�N�i�����������j
-- patterns - {'a'='��', 'e'='��', 'i'='��', 'o'='��','u'='��', 'N'='��'}
-- mode - �q���̏������[�h
-- layerindex - �A�j���[�V�����Ώۂ̏������C���[�ԍ�
function LipSyncLab.new(patterns, mode, layerindex)
  if patterns.A == nil then patterns.A = patterns.a end
  if patterns.E == nil then patterns.E = patterns.e end
  if patterns.I == nil then patterns.I = patterns.i end
  if patterns.O == nil then patterns.O = patterns.o end
  if patterns.U == nil then patterns.U = patterns.u end
  return setmetatable({
    patterns = patterns,
    mode = mode,
    layerindex = layerindex,
    talkstates = P.talk
  }, {__index = LipSyncLab})
end

function LipSyncLab:getstate(psd, obj)
  local pat = self.patterns
  local ts = self.talkstates:get(self.layerindex)
  if ts == nil or ts.used then
    -- �f�[�^��������Ȃ�������g�p�ς݃f�[�^�������ꍇ�͕���Ԃɂ���
    return pat.N
  end
  ts.used = true

  if ts.cur == "" then
    -- ���f��񂪂Ȃ����͉��ʂɉ����āu���v�̌`���g��
    -- �ilab �t�@�C�����g�킸�Ɂu���p�N�@�����������v���g���Ă���ꍇ�̑[�u�j
    if ts.volume >= 1.0 then
      return pat.a
    end
    return pat.N
  end

  if ts:curisvowel() ~= 0 then
    -- �ꉹ�͐ݒ肳�ꂽ�`�����̂܂܎g��
    return pat[ts.cur]
  end

  if self.mode == 0 then
    -- �q�������^�C�v0 -> �S�āu��v
    return pat.N
  elseif self.mode == 1 then
    -- �q�������^�C�v1 -> �������q���ȊO�͑O��̕ꉹ�̌`�������p��
    if ts.cur == "pau" or ts.cur == "N" or ts.cur == "m" or ts.cur == "p" or ts.cur == "b" or ts.cur == "v" then
      -- pau / �� / �q���i�܁E�ρE�΁E���s�j
      return pat.N
    end
    -- ��������Ȃ������S�Ă̎q���̃f�t�H���g����
    -- �אڂ���O��̕ꉹ�̌`�������p��
    if ts.progress < 0.5 then
      -- �O���͑O�̕ꉹ�������p��
      if ts:previsvowel() ~= 0 and ts.prev_end == ts.cur_start then
        return pat[ts.prev]
      end
    else
      -- �㔼�͌��̕ꉹ���s������
      if ts:nextisvowel() ~= 0 and ts.next_start == ts.cur_end then
        return pat[ts.next]
      end
    end
    return pat.N
  elseif self.mode == 2 then
    -- �q�������^�C�v2 -> �������q���ȊO�͑O��̕ꉹ�̌`��菬�������̂ŕ��
    if ts.cur == "pau" or ts.cur == "N" or ts.cur == "m" or ts.cur == "p" or ts.cur == "b" or ts.cur == "v" then
      -- pau / �� / �q���i�܁E�ρE�΁E���s�j
      return pat.N
    end
    if ts.cur == "cl" then
      -- �����i���j
      if ts.progress < 0.5 then
        -- �ЂƂO���ꉹ�ŁA���A�������ꏊ�ɑ��݂��Ă���Ȃ�O���͂��̕ꉹ�̌`�������p��
        if ts:previsvowel() ~= 0 and ts.prev_end == ts.cur_start then
          return pat[ts.prev]
        end
        return pat.N
      else
        -- �㔼�́u���v�̌`�ň����p��
        return pat.u
      end
    end
    -- ��������Ȃ������S�Ă̎q���̃f�t�H���g����
    -- �אڂ���O��̕ꉹ�Ɉˑ����Č`�����肷��
    if ts.progress < 0.5 then
      -- �O���͑O�̕ꉹ�������p��
      if ts:previsvowel() ~= 0 and ts.prev_end == ts.cur_start then
        -- �O�̕ꉹ���Ȃ�ׂ��������J�����ɂȂ�悤��
        if ts.prev == "a" or ts.prev == "A" then
          return pat.o
        elseif ts.prev == "i" or ts.prev == "I" then
          return pat.i
        else
          return pat.u
        end
      end
      return pat.N
    else
      -- �㔼�͌��̕ꉹ���s������
      if ts:nextisvowel() ~= 0 and ts.next_start == ts.cur_end then
        -- �O�̕ꉹ���Ȃ�ׂ��������J�����ɂȂ�悤��
        if ts.next == "a" or ts.next == "A" then
          return pat.o
        elseif ts.next == "i" or ts.next == "I" then
          return pat.i
        else
          return pat.u
        end
      end
      return pat.N
    end
  end
  error("unexpected consonant processing mode")
end

local TalkState = {}

function TalkState.isvowel(p)
  if p == "a" or p == "e" or p == "i" or p == "o" or p == "u" then
    return 1
  end
  if p == "A" or p == "E" or p == "I" or p == "O" or p == "U" then
    return -1
  end
  return 0
end

function TalkState.new(frame, time, totalframe, totaltime)
  return setmetatable({
    used = false,
    frame = frame,
    time = time,
    totalframe = totalframe,
    totaltime = totaltime,
    volume = 0,
    threshold = 1,
    progress = 0,
    cur = "",
    cur_start = 0,
    cur_end = 0,
    prev = "",
    prev_start = 0,
    prev_end = 0,
    next = "",
    next_start = 0,
    next_end = 0
  }, {__index = TalkState})
end

function TalkState:curisvowel()
  return TalkState.isvowel(self.cur)
end

function TalkState:previsvowel()
  return TalkState.isvowel(self.prev)
end

function TalkState:nextisvowel()
  return TalkState.isvowel(self.next)
end

function TalkState:setvolume(buf, samplerate, locut, hicut, threshold)
  if threshold == 0 then
    self.volume = 0
    self.threshold = 1
    return
  end
  local buflen = #buf
  local hzstep = samplerate / 2 / 1024
  local v, d, hz = 0, 0, 0
  for i in ipairs(buf) do
    hz = math.pow(2, 10 * ((i - 1) / buflen)) * hzstep
    if locut < hz then
      if hz > hicut then
        break
      end
      v = v + buf[i]
      d = d + 1
    end
  end
  if d > 0 then
    v = v / d
  end
  self.volume = v / threshold
  self.threshold = threshold
end

function TalkState:setphoneme(labfile, time)
  time = time * 10000000
  local line
  local f = io.open(labfile, "r")
  if f == nil then
    error("file not found: " .. labfile)
  end
  for line in f:lines() do
    local st, ed, p = string.match(line, "(%d+) (%d+) (%a+)")
    if st == nil then
      return nil -- unexpected format
    end
    st = st + 0
    ed = ed + 0
    if st <= time then
      if time < ed then
        if self.cur == "" then
          self.progress = (time - st)/(ed - st)
          self.cur = p
          self.cur_start = st
          self.cur_end = ed
        end
      else
        self.prev = p
        self.prev_start = st
        self.prev_end = ed
      end
    else
      self.next = p
      self.next_start = st
      self.next_end = ed
      f:close()
      return
    end
  end
  f:close()
end

local TalkStates = {}

function TalkStates.new()
  return setmetatable({
    states = {}
  }, {__index = TalkStates})
end

function TalkStates:set(obj, srcfile, locut, hicut, threshold)
  local ext = srcfile:sub(-4):lower()
  if ext ~= ".wav" and ext ~= ".lab" then
    self.states[obj.layer] = t
    error("unsupported file: " .. srcfile)
  end

  local t = TalkState.new(obj.frame, obj.time, obj.totalframe, obj.totaltime)
  local wavfile = string.sub(srcfile, 1, #srcfile - 3) .. "wav"
  if ext == ".wav" or fileexists(wavfile) then
    local n, samplerate, buf = obj.getaudio(nil, wavfile, "spectrum", 32)
    t:setvolume(buf, samplerate, locut, hicut, threshold)
  end
  local labfile = string.sub(srcfile, 1, #srcfile - 3) .. "lab"
  if ext == ".lab" or fileexists(labfile) then
    t:setphoneme(labfile, obj.time)
  end
  self.states[obj.layer] = t
end

function TalkStates:setphoneme(obj, phonemestr)
  local t = TalkState.new(obj.frame, obj.time, obj.totalframe, obj.totaltime)
  t.progress = obj.time / obj.totaltime
  t.cur = phonemestr
  t.cur_start = 1
  t.cur_end = obj.totaltime + 1
  self.states[obj.layer] = t
end

function TalkStates:get(index)
  return self.states[index]
end

local SubtitleState = {}

function SubtitleState.new(text, frame, time, totalframe, totaltime, unescape)
  if unescape then
    text = text:gsub("([\128-\160\224-\255]\092)\092", "%1")
  end
  return setmetatable({
    used = false,
    text = text,
    frame = frame,
    time = time,
    totalframe = totalframe,
    totaltime = totaltime
  }, {__index = SubtitleState})
end

local SubtitleStates = {}

function SubtitleStates.new()
  return setmetatable({
    states = {}
  }, {__index = SubtitleStates})
end

function SubtitleStates:set(text, obj, unescape)
  self.states[obj.layer] = SubtitleState.new(
    text,
    obj.frame,
    obj.time,
    obj.totalframe,
    obj.totaltime,
    unescape
  )
end

function SubtitleStates:get(index)
  return self.states[index]
end

function SubtitleStates:mes(obj, index)
  local s = self:get(index)
  if s == nil or s.used then
    return
  end
  s.used = true
  obj.mes(s.text)
end

function SubtitleStates:messtep(obj, index, opt)
  local s = self:get(index)
  if s == nil or s.used then
    return
  end
  s.used = true
  obj.setfont(opt.fontname, opt.fontsize, opt.fontdecoration, opt.fontcolor, opt.fontdecorationcolor)
  obj.load("text", s.text, opt.speed, s.time)
  if opt.halign == 0 then
    obj.cx = -obj.w*0.5
  elseif opt.halign == 1 then
    -- �����񂹂͊�̎��Ƀ{�P�Ă��܂��̂� 0.5px ���炷
    if obj.w % 2 == 1 then
      obj.cx = obj.cx + 0.5
    end
  elseif opt.halign == 2 then
    obj.cx = obj.w*0.5
  end
  if opt.valign == 0 then
    obj.cy = -obj.h*0.5
  elseif opt.valign == 1 then
    -- �����񂹂͊�̎��Ƀ{�P�Ă��܂��̂� 0.5px ���炷
    if obj.h % 2 == 1 then
      obj.cy = obj.cy + 0.5
    end
  elseif opt.valign == 2 then
    obj.cy = obj.h*0.5
  end
end

P.talk = TalkStates.new()
P.subtitle = SubtitleStates.new()

P.print = print
P.PSDState = PSDState
P.Blinker = Blinker
P.LipSyncSimple = LipSyncSimple
P.LipSyncLab = LipSyncLab
return P
