TestGlobalSkillSystem = {}
  -- GetSkillPotency
  function TestGlobalSkillSystem:test_GetSkillPotency()
    lu.assertEquals(GetSkillPotency(0), 0)
    lu.assertAlmostEquals(GetSkillPotency(10), 28.634834815699, 0.1)
    lu.assertAlmostEquals(GetSkillPotency(100), 514.76644756808, 0.1)
    lu.assertEquals(GetSkillPotency(-10), 0)
    lu.assertEquals(GetSkillPotency(nil), 0)
  end

  -- GetSkillPctPotency
  function TestGlobalSkillSystem:test_GetSkillPctPotency()
    lu.assertEquals(GetSkillPctPotency(0), 0)
    lu.assertAlmostEquals(GetSkillPctPotency(10), 0.055626847769466, 0.001)
    lu.assertAlmostEquals(GetSkillPctPotency(50), 0.4027117321411, 0.001)
    lu.assertAlmostEquals(GetSkillPctPotency(100), 1.0, 0.001)
    lu.assertEquals(GetSkillPctPotency(-10), 0)
    lu.assertEquals(GetSkillPctPotency(nil), 0)
  end

  -- GetSkillPct
  function TestGlobalSkillSystem:test_GetSkillPct()
  end

  -- GetSpecificSkillPctPotency
  function TestGlobalSkillSystem:test_GetSpecificSkillPctPotency()
  end

  -- GetSkillSumLevel
  function TestGlobalSkillSystem:test_GetSkillSumLevel()
  end

  -- HasSkill
  function TestGlobalSkillSystem:test_HasSkill()
  end

  -- IsDirectUsableSkill
  function TestGlobalSkillSystem:test_IsDirectUsableSkill()
  end

  -- GetSkillDisplayName
  function TestGlobalSkillSystem:test_GetSkillDisplayName()
  end

  -- GetSkillDescription
  function TestGlobalSkillSystem:test_GetSkillDescription()
  end

  -- IsCombatSkill
  function TestGlobalSkillSystem:test_IsCombatSkill()
  end

  -- IsCombatSupportSkill
  function TestGlobalSkillSystem:test_IsCombatSupportSkill()
  end

  -- GetSkillClass
  function TestGlobalSkillSystem:test_GetSkillClass()
  end

  -- GetSkillTotal
  function TestGlobalSkillSystem:test_GetSkillTotal()
  end

  -- GetCombatSkillTotal
  function TestGlobalSkillSystem:test_GetCombatSkillTotal()
  end

  -- GetCombatSupportSkillTotal
  function TestGlobalSkillSystem:test_GetCombatSupportSkillTotal()
  end
