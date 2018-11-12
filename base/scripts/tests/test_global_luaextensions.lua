TestGlobalLuaExtensions = {}
  function TestGlobalLuaExtensions:setUp()
    self.type_string = 'abcdef';
    self.type_number = 123.456;
    self.type_bool = true;
    self.type_nil = nil;
    self.type_tableEmpty = {}
    self.type_tableSimple = { [0] = 0 }
    self.type_tableComplex = { [0] = { [0] = 0 } }
    self.readonlytable = readonlytable { [0] = 0 }
    self.sample_table = { [1] = 'a', [2] = 'b', [3] = 'c', [4] = 'd', [5] = 'e' }
    self.sample_table_readonly = readonlytable { [1] = 'a', [2] = 'b', [3] = 'c', [4] = 'd', [5] = 'e' }
    self.sample_table_complex = { ['a'] = { ['name'] = 'apple', ['pos'] = 1 },
                                  ['b'] = { ['name'] = 'banana', ['pos'] = 2 },
				  ['c'] = { ['name'] = 'cherry', ['pos'] = 3 } }
  end

  -- file_exists
  function TestGlobalLuaExtensions:test_file_exists()
    lu.assertFalse(file_exists('does_not_exist.txt'))
    lu.assertTrue(file_exists('luaunit.lua'))
  end

  -- readonlytable
  function TestGlobalLuaExtensions:test_readonlytable()
    lu.assertError(self.readonlytable.__index, 0, 1) -- should not allow assignment
  end

  -- DumpTable
  function TestGlobalLuaExtensions:test_DumpTable()
    lu.assertIs(DumpTable(nil), 'Invalid Table')
    lu.assertIs(DumpTable({ [0] = 0 }), " --> 0 : 0\n")
    lu.assertIs(DumpTable({ [0] = { ['a'] = 0 } }), " --> (table) 0\n   --> a : 0\n")

    -- try dumping complex table
    -- lu.assertNotNil(DumpTable(LoadExternalModule('mime'))) -- DISABLED: hangs
  end

  -- LoadExternalModule
  function TestGlobalLuaExtensions:test_LoadExternalModule()
    if (ParametersTest.IsOffline) then
      lu.assertNotNil(LoadExternalModule('mime'))
    else
      lu.assertTrue(true) -- TODO: add online/server test
    end
  end

  -- shallowCopy
  function TestGlobalLuaExtensions:test_shallowCopy()
    lu.assertEquals(shallowCopy(self.type_string), self.type_string) 
    lu.assertEquals(shallowCopy(self.type_number), self.type_number)
    lu.assertEquals(shallowCopy(self.type_bool), self.type_bool)
    lu.assertEquals(shallowCopy(self.type_tableEmpty), self.type_tableEmpty)
    lu.assertEquals(shallowCopy(self.type_tableSimple), self.type_tableSimple)
    lu.assertNotEquals(shallowCopy(self.type_tableComplex), self.type_tableComplex)
    lu.assertNotEquals(shallowCopy(LoadExternalModule('mime')), LoadExternalModule('mime'))
    lu.assertNotEquals(getmetatable(shallowCopy(LoadExternalModule('mime'))), getmetatable(LoadExternalModule('mime')))
  end

  -- indexOf
  function TestGlobalLuaExtensions:test_indexOf()
    lu.assertEquals(indexOf(self.sample_table, 'c'), 3)
    lu.assertEquals(indexOf(self.sample_table, 'z'), -1)
    lu.assertEquals(indexOf(self.sample_table_readonly, 'c'), 3)
    lu.assertEquals(indexOf(self.sample_table_readonly, 'z'), -1)
    -- TODO: add a test for compFunc once a comparison function is in use with indexOf
  end

  -- searchTable
  function TestGlobalLuaExtensions:test_searchTable()
    lu.assertEquals(searchTable(self.sample_table_complex, 'cherry'), nil)
    lu.assertEquals(searchTable(self.sample_table_complex, 'zebra', function(v, e) return v.name == e end), nil)
    lu.assertEquals(searchTable(self.sample_table_complex, 'cherry', function(v, e) return v.name == e end), { ['name'] = 'cherry', ['pos'] = 3 } )
  end

  -- objectComparison
  function TestGlobalLuaExtensions:test_objectComparison()
    lu.assertTrue(objectComparison(nil, nil))
    lu.assertFalse(objectComparison(nil, ''))
    lu.assertFalse(objectComparison({}, {}))
    lu.assertFalse(objectComparison({ [0] = 0 }, { [0] = 0 }))
    lu.assertTrue(objectComparison(self.sample_table, self.sample_table))
    lu.assertTrue(objectComparison(self.sample_table_readonly, self.sample_table_readonly))
    lu.assertTrue(objectComparison(self.sample_table_complex, self.sample_table_complex))
    lu.assertFalse(objectComparison(shallowCopy(self.sample_table), self.sample_table))
  end

  -- getTableKeys
  function TestGlobalLuaExtensions:test_getTableKeys()
    lu.assertEquals(getTableKeys(self.sample_table), { 2, 3, 1, 4, 5 }) -- key ordering not preserved
    lu.assertEquals(getTableKeys(self.sample_table_complex), { "a", "c", "b" })
  end

  -- StringSplit
  function TestGlobalLuaExtensions:test_StringSplit()
    lu.assertEquals(StringSplit(nil), nil)
    lu.assertEquals(StringSplit(''), {})
    lu.assertEquals(StringSplit('a b c'), { "a", "b", "c" })
    lu.assertEquals(StringSplit('a:b:c', ':'), { "a", "b", "c" } )
    lu.assertEquals(StringSplit("a\tb\tc", "\t"), { "a", "b", "c" })
    lu.assertEquals(StringSplit("a\tb\tc\t", "\t"), { "a", "b", "c" })
    lu.assertEquals(StringSplit("a\nb\tc\n", "\n"), { "a", "b\tc" })
  end

  -- CombineArgs
  function TestGlobalLuaExtensions:test_CombineArgs()
    lu.assertEquals(CombineArgs('a b', 1), 'a b 1')  
  end

  -- CombineString
  function TestGlobalLuaExtensions:test_CombineString()
    lu.assertEquals(CombineString({}, ' '), '')
    lu.assertEquals(CombineString(nil, ' '), '')
    lu.assertEquals(CombineString('', ' '), '')
    lu.assertEquals(CombineString({}, ' '), '')
    lu.assertEquals(CombineString({ 1, 2, 3 }, ' '), '1 2 3')
    lu.assertEquals(CombineString({ 1, 3, "\n", 'a' }, '\t'), "1\t3\t\n\ta")
  end

  -- StringTrim
  function TestGlobalLuaExtensions:test_StringTrim()
    lu.assertEquals(StringTrim(''), '')
    lu.assertEquals(StringTrim(nil), nil)
    lu.assertEquals(StringTrim("\n\t\raa\nThis is a match of"), "aa\nThis is a match of")
    lu.assertEquals(StringTrim("This is a match of   \t\tn\n"), "This is a match of   \t\tn")
    lu.assertEquals(StringTrim("\n\tThis is a match of   \t\t\n\r"), 'This is a match of')
  end

  -- StripTrailingNewline
  function TestGlobalLuaExtensions:test_StripTrailingNewline()
    lu.assertEquals(StripTrailingNewline("a b c\n"), 'a b c')
    lu.assertEquals(StripTrailingNewline("a b c\n\n"), 'a b c')
  end

  -- StripTrailingComma
  function TestGlobalLuaExtensions:test_StripTrailingComma()
    lu.assertEquals(StripTrailingComma('a b c,'), 'a b c')
    lu.assertEquals(StripTrailingComma('a b c, '), 'a b c')
    lu.assertEquals(StripTrailingComma('a b c,,'), 'a b c')
  end

  -- GetTableKeyFromIndex
  function TestGlobalLuaExtensions:test_GetTableKeyFromIndex()
    lu.assertEquals(GetTableKeyFromIndex({}, 2), nil)
    lu.assertEquals(GetTableKeyFromIndex(nil, 2), nil)
    lu.assertEquals(GetTableKeyFromIndex(self.sample_table_complex, 2), 'c')
    lu.assertEquals(GetTableKeyFromIndex(self.sample_table_complex, 100), nil)
  end

  -- TableConcat
  function TestGlobalLuaExtensions:test_TableConcat()
    lu.assertEquals(TableConcat({'a', 'b', 'c'}, { 'x', 'y', 'z' }), { 'a', 'b', 'c', 'x', 'y', 'z' })
    lu.assertEquals(TableConcat({}, { 'a' }), { 'a' })
    lu.assertEquals(TableConcat(nil, { 'a' }), { 'a' })
    lu.assertEquals(TableConcat({ 'a' }, nil), { 'a' })
  end

  -- RemoveFromArray
  function TestGlobalLuaExtensions:test_RemoveFromArray()
    local arr = { 'a', 'b', 'c' }
    RemoveFromArray(arr, 'b')
    RemoveFromArray(arr, 'z')

    lu.assertEquals(arr, { 'a', 'c' })

    local arr_empty = {}
    RemoveFromArray(arr, 0)

    lu.assertEquals(arr_empty, {})

    local arr_nil = nil
    RemoveFromArray(arr_nil, nil)
  end

  -- IsInTableArray
  function TestGlobalLuaExtensions:test_IsInTableArray()
    lu.assertTrue(IsInTableArray({ 'a', 'b', 'c' }, 'a'))
    lu.assertFalse(IsInTableArray({ 'a', 'b', 'c' }, 'z'))
    lu.assertFalse(IsInTableArray({}, 'z'))
    lu.assertFalse(IsInTableArray(nil, 'z'))
  end

  -- IndexOf
  function TestGlobalLuaExtensions:test_IndexOf()
    lu.assertEquals(IndexOf({ 'a', 'b', 'c' }, 'b'), 2)
    lu.assertEquals(IndexOf({ 'a', 'b', 'c' }, 'z'), nil)
    lu.assertEquals(IndexOf({}, 'z'), nil)
    lu.assertEquals(IndexOf(nil, 'z'), nil)
  end

  -- CountTable
  function TestGlobalLuaExtensions:test_CountTable()
    lu.assertEquals(CountTable(self.sample_table), 5)
    lu.assertEquals(CountTable(self.sample_table, 'c'), 1)
    lu.assertEquals(CountTable({}), 0)
    lu.assertEquals(CountTable(nil), 0)
  end

  -- IsTableEmpty
  function TestGlobalLuaExtensions:test_IsTableEmpty()
    lu.assertTrue(IsTableEmpty({}))
    lu.assertTrue(IsTableEmpty(nil))
    lu.assertTrue(IsTableEmpty({ [0] = 0 }))
  end

  -- BuildArray
  function TestGlobalLuaExtensions:test_BuildArray()
    local str = 'this is a test'
    lu.assertEquals(BuildArray(str:gmatch("%S+")), { 'this', 'is', 'a', 'test' } )
    lu.assertEquals(BuildArray(nil), nil)
  end

  -- GetValueType
  function TestGlobalLuaExtensions:test_GetValueType()
    lu.assertEquals(GetValueType(nil), '')

    if (ParametersTest.IsOffline) then
      lu.assertTrue(true) -- GetUserdataType is a stub class
    else
      lu.assertTrue(true) -- TODO: add online/server test
    end
  end

  -- uuid()
  function TestGlobalLuaExtensions:test_uuid()
    local tmp = uuid()
    lu.assertEquals(string.len(tmp), 36)
    lu.assertEquals(string.sub(tmp, 15, 15), '4')
    lu.assertNotEquals(uuid(), uuid())
  end

  -- UnixTimeToDateTime(unixTime)   
  function TestGlobalLuaExtensions:test_UnixTimeToDateTime()
    if (ParametersTest.IsOffline) then
      lu.assertTrue(true) -- DateTime is a stub class
    else
      lu.assertTrue(true) -- TODO: add online/server test
    end
  end
