-- Speech Helper Functions

-- convert a number to a written (speech) cardinal form
function numberToSpeechCardinal(n)
    local decimal = (n >= 0) and math.floor(n) or -math.floor(n)
  
    -- out of bounds? don't try to cardinalize large numbers
    if decimal > SPEECH_CARDINAL_MAX then
        return string.format("%d", decimal)
    end
    
    -- special case: one billion
    if (decimal == 1000000000) then
        return "one billion"
    end
    
    -- general cases: less than a billion
    local cardinalized = ""
    
    -- millions
    if (decimal >= 1000000) then
        local millions = math.floor(decimal / 1000000)
        cardinalized = cardinalized .. numberToSpeechCardinal(millions)
        cardinalized = cardinalized .. " million "
        decimal = decimal - (millions * 1000000)
    end
    
    -- thousands
    if (decimal >= 1000) then
        local thousands = math.floor(decimal / 1000)
        cardinalized = cardinalized .. numberToSpeechCardinal(thousands)
        cardinalized = cardinalized .. " thousand "
        decimal = decimal - (thousands * 1000)
    end
    
    -- hundreds
    if (decimal >= 100) then
        local hundreds = math.floor(decimal / 100)
        cardinalized = cardinalized .. numberToSpeechCardinal(hundreds)
        cardinalized = cardinalized .. " hundred "
        decimal = decimal - (hundreds * 100)
    end
    
    -- twenties to nineties
    if (decimal >= 20) then
        local tens = math.floor(decimal / 10)
        cardinalized = cardinalized .. StaticSpeechCardinals[tens * 10]
        decimal = decimal - (tens * 10)
        
        -- don't show a "zero", add hyphen when necessary
        if (decimal > 0) then
            cardinalized = cardinalized .. "-" .. StaticSpeechCardinals[decimal]
        end
    -- unique cardinal words
    else
        cardinalized = cardinalized .. StaticSpeechCardinals[decimal]
    end
    
    return cardinalized
end 
