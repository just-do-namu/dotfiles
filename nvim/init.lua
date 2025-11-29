-- ~/.config/nvim/init.lua

-- 기본 옵션들
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"

-- 스크롤 빠르게
vim.keymap.set('n', '<C-E>', '5<C-E>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Y>', '5<C-Y>', { noremap = true, silent = true })

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 플러그인 설치 목록
require("lazy").setup({
  { "tpope/vim-surround" },
})


local function get_ime()
  -- 현재 IME ID (뒤에 붙는 개행 제거)
  return vim.fn.trim(vim.fn.system("im-select"))
end

local function ime_to(id)
  if id and id ~= "" then
    vim.fn.system("im-select " .. id)
  end
end

-- 사용 중인 IME ID
local IME_EN = "com.apple.keylayout.ABC"
-- 한글은 굳이 상수로 안 써도 되지만 참고용
local IME_KR = "com.apple.inputmethod.Korean.2SetKorean"

-- 마지막으로 사용하던 IME 상태 기억용
-- 처음엔 지금 OS 상의 IME를 그대로 가져와서 저장
local last_ime = get_ime()

-- 1) Insert 계열(i, ic, R 등) → 다른 모드로 나갈 때
--    - 나가기 직전 IME를 last_ime에 저장
--    - Normal/Visual/Command 등에서는 영어로 강제
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:*",
  callback = function()
    -- Insert에서 빠져나가는 시점의 IME 저장
    last_ime = get_ime()
    -- Normal 쪽 들어왔으니 영어로
    ime_to(IME_EN)
  end,
})

-- 1-1) Command-line 모드(c) → 다른 모드로 나갈 때 (검색/명령 줄 끝낼 때)
--      - 나가기 직전 IME를 last_ime에 저장
--      - Normal 등으로 나가면 영어로 강제
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "c:*",
  callback = function()
    -- 검색창/명령줄에서 쓰고 있던 IME 기억 (보통 한글)
    last_ime = get_ime()
    -- Normal/Visual 쪽으로 나갔으니 영어로 전환
    ime_to(IME_EN)
  end,
})


-- 2) VSCode/Neovim으로 포커스가 다시 돌아올 때
--    - 그 순간 OS IME 상태를 먼저 last_ime에 저장
--    - 그리고 현재 모드가 Normal/Visual/Command라면 영어로 바꾸기
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    -- 다른 앱에서 쓰고 있던 IME 상태(한글/영어)를 먼저 기억
    local cur = get_ime()
    last_ime = cur

    -- 현재 모드 확인
    local m = vim.fn.mode()

    -- Insert/Replace 계열(i, ic, R 등)이 아니면 → Normal/Visual/Command니까 영어 강제
    if not m:match("^[iR]") then
      ime_to(IME_EN)
    end
  end,
})

-- 3) Insert 모드로 들어갈 때
--    - last_ime에 저장해 둔 상태(한글/영어)로 복구
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    ime_to(last_ime)
  end,
})

-- 4) VSCode/Neovim 포커스가 빠질 때 (GPT 등으로 나감)
--    - 나가기 직전에 last_ime 기준으로 IME를 맞춰줌
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    local m = vim.fn.mode()
    -- 만약 Insert 상태라면, 지금 IME를 한 번 더 갱신해두기
    if m:match("^i") then
      last_ime = get_ime()
    end
    -- VSCode를 떠날 때는 last_ime(보통 한글)로 전환
    ime_to(last_ime)
  end,
})

-- 검색(/, ?) 시작 시, 원래 쓰던 입력수단으로 복귀
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "/,?",
  callback = function()
    -- Insert에서 쓰던 IME(마지막 IME)로 변경
    ime_to(last_ime)
  end,
})