TestGlobalLuaExtensionsEmail = {}
  -- SendEmail
  function TestGlobalLuaExtensionsEmail:test_SendEmail()
    if (ParametersTest.IsOffline) then
      lu.assertTrue(true) -- cannot be tested directly
    else
      lu.assertTrue(true) -- TODO: add online/server test
    end

  end
