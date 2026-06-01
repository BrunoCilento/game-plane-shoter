-- Bootstrap the global Class that StateMachine.lua expects at load time.
-- _G is explicit because busted sandboxes spec files in Lua 5.4.
_G.Class = require('lib.class')
require('src.StateMachine')

describe('StateMachine', function()
  -- Named fake so it can be reasoned about across tests.
  local function FakeState()
    local s = { calls = {}, entered_with = nil }
    function s:enter(params) self.calls[#self.calls + 1] = 'enter'; self.entered_with = params end
    function s:exit()        self.calls[#self.calls + 1] = 'exit' end
    function s:update(dt)    self.calls[#self.calls + 1] = 'update:' .. tostring(dt) end
    function s:render()      self.calls[#self.calls + 1] = 'render' end
    return s
  end

  local sm

  before_each(function()
    sm = StateMachine({
      foo = function() return FakeState() end,
      bar = function() return FakeState() end,
    })
  end)

  describe('init', function()
    it('starts in a no-op empty state that does not error', function()
      local fresh = StateMachine({})
      assert.has_no.errors(function() fresh:update(0) end)
      assert.has_no.errors(function() fresh:render() end)
    end)

    it('stores the provided state factories', function()
      assert.is_not_nil(sm.states['foo'])
      assert.is_not_nil(sm.states['bar'])
    end)
  end)

  describe('change', function()
    it('makes the named state the current state', function()
      sm:change('foo')
      assert.not_equal(sm.current, sm.empty)
    end)

    it('calls enter on the new state with the given params', function()
      sm:change('foo', { level = 3 })
      assert.are_same({ level = 3 }, sm.current.entered_with)
    end)

    it('calls exit on the previous state before entering the new one', function()
      sm:change('foo')
      local prev = sm.current   -- capture foo before transitioning away
      sm:change('bar')
      -- foo must have received enter then exit, in that order
      assert.are_equal('enter', prev.calls[1])
      assert.are_equal('exit',  prev.calls[2])
    end)

    it('errors when the state name is not registered', function()
      assert.has_error(function()
        sm:change('does_not_exist')
      end)
    end)
  end)

  describe('update', function()
    it('forwards dt to the current state', function()
      sm:change('foo')
      sm:update(0.016)
      assert.are_equal('update:0.016', sm.current.calls[#sm.current.calls])
    end)
  end)

  describe('render', function()
    it('delegates render to the current state', function()
      sm:change('foo')
      sm:render()
      assert.are_equal('render', sm.current.calls[#sm.current.calls])
    end)
  end)
end)
