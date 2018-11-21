ParametersTest = {}
ParametersTest.IsOffline = true

if (ParametersTest.IsOffline) then
  require('incl_offline_requirements')
end

lu = require('luaunit')

-- Global
require('test_global_luaextensions')
require('test_global_luaextensions_email')
require('test_global_skill_system')
require('test_global_speech_helpers')

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
