TestGlobalSpeechHelpers = {}
  -- numberToSpeechCardinal
  function TestGlobalSpeechHelpers:test_numberToSpeechCardinal()
    lu.assertEquals(numberToSpeechCardinal(0), 'zero')
    lu.assertEquals(numberToSpeechCardinal(-0), 'zero')
    lu.assertEquals(numberToSpeechCardinal(101), 'one hundred one')
    lu.assertEquals(numberToSpeechCardinal(-532), 'five hundred thirty-two')
    lu.assertEquals(numberToSpeechCardinal(1000000001), '1000000001')
    lu.assertEquals(numberToSpeechCardinal(nil), 'nil')
  end
