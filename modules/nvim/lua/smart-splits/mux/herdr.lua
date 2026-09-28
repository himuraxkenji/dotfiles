-- Custom smart-splits.nvim multiplexer backend for herdr (herdr.dev).
-- Upstream smart-splits.nvim only ships tmux/wezterm/kitty/zellij backends;
-- this module fills the gap by shelling out to `herdr pane` over its socket
-- API, so smart-splits' <C-h/j/k/l> falls through to herdr panes at the
-- edge of nvim's own splits, same as it does for tmux/zellij.
local Direction = require('smart-splits.types').Direction
local log = require('smart-splits.log')

local function herdr_exec(args)
  local cmd = vim.list_extend({ 'herdr', 'pane' }, args)
  local text, code = require('smart-splits.utils').system(cmd)
  return text, code
end

local function herdr_json(args)
  local text, code = herdr_exec(args)
  if code ~= 0 or not text or #text == 0 then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, text)
  if not ok then
    log.error('herdr mux: failed to decode JSON: ' .. tostring(decoded))
    return nil
  end

  return decoded.result
end

---@type SmartSplitsMultiplexer
local M = {} ---@diagnostic disable-line: missing-fields

M.type = 'herdr'

function M.is_in_session()
  return vim.env.HERDR_ENV ~= nil and vim.env.HERDR_PANE_ID ~= nil
end

---@return string|nil
function M.current_pane_id()
  if not M.is_in_session() then
    return nil
  end

  local result = herdr_json({ 'current', '--current' })
  if not result or not result.pane then
    return nil
  end

  return result.pane.pane_id
end

function M.current_pane_at_edge(direction)
  if not M.is_in_session() then
    return false
  end

  local result = herdr_json({ 'edges', '--current' })
  if not result or not result.edges then
    return false
  end

  return result.edges[direction] == true
end

function M.current_pane_is_zoomed()
  local result = herdr_json({ 'layout', '--current' })
  if not result or not result.layout then
    return false
  end

  return result.layout.zoomed == true
end

function M.next_pane(direction)
  if not M.is_in_session() then
    return false
  end

  local result = herdr_json({ 'focus', '--current', '--direction', direction })
  if not result or not result.focus then
    return false
  end

  return result.focus.changed == true
end

function M.resize_pane(direction, amount)
  if not M.is_in_session() then
    return false
  end

  local args = { 'resize', '--current', '--direction', direction }
  if amount then
    table.insert(args, '--amount')
    table.insert(args, tostring(amount))
  end
  local _, code = herdr_exec(args)
  return code == 0
end

function M.split_pane(direction, _size) ---@diagnostic disable-line: unused-local
  if not M.is_in_session() then
    return false
  end

  local split_direction = (direction == Direction.left or direction == Direction.right) and 'right' or 'down'
  local _, code = herdr_exec({ 'split', '--current', '--direction', split_direction })
  return code == 0
end

function M.update_mux_layout_details()
  -- Not needed: herdr's edges/neighbor queries always fetch fresh layout.
end

return M
