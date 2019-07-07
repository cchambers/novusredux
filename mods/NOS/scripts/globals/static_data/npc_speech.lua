-- NOTE: THESE ARE GLOBAL STATIC TABLES. Do not edit them inside an AI module 
-- If you want custom speech, create your own speech table in AI.CustomSpeech and use
-- these as the FallbackSpeechTable table

--When NPC's speak this, then they will be transliterated in base_ai_conversation
NPCLanguages = {
    Barbarian = {
    A={""},
    B={""},
    C={""},
    D={""},
    E={""},
    F={""},
    G={""},
    H={""},
    I={""},
    J={""},
    K={""},
    L={""},
    M={""},
    N={""},
    O={""},
    P={""},
    Q={""},
    R={""},
    S={""},
    T={""},
    U={""},
    V={""},
    W={""},
    X={""},
    Y={""},
    Z={""},
    },
    Nomad = {
    A={"i"},
    B={"s"},
    C={"k"},
    D={"jid"},
    E={"'ju"},
    F={"f"},
    G={"k"},
    H={"h"},
    I={"i"},
    J={"ki"},
    K={"j"},
    L={"'e"},
    M={"n"},
    N={"n"},
    O={"'u"},
    P={"f"},
    Q={"q"},
    R={"r"},
    S={"q"},
    T={"as"},
    U={"u"},
    V={"w"},
    W={"id"},
    X={"x"},
    Y={"y"},
    Z={"s"},
    },
}

StaticNPCSpeech = {
    Default = {
        IdleResponseNeutral={
            {"Heh.",    ""},
            {"Hmm...",  ""},
            {"Indeed.", ""},
            {"Ok.",     ""},
            {"Right?",  ""},
        },

        IdleResponsePositive={
            {"Yep.",    "Yes"},
            {"Yeah.",   "Yes"},
            { "Yes.",    "Yes"},
            { "Definitely.",          "Yes"},
        },

        IdleResponseNegative={
            {"No.",     "No"},
            {"Nope.",   "No"},
            {"Right...","No"},
            {"Yeah right.",          "No"},
            {"Don't think so.",      "No"},
            {"Doubt it.",            "No"},
            {"Doubtful.",            "No"},
        },

        IdleResponseAngry={
            {"Shutup!", "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shut the hell up!",    "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Shutup!", "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shut the hell up!",    "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
        },

        IdleSpeech=
        {
            {"Lovely weather we're having, eh?",  "Weather"},
            {"I'm so bored. Yourself?",           "Bored"},
            {"Did you enjoy that meal?",          "LastMeal"},
            {"Busy today?",          "Busy"},
        },

        IdleSpeechQuestion = {
           {"Say, would you happen to have the time?",         "Time"},
           { "Hey, do you know where I can find a good meal?", "Food"},
           {"Do you know what time it is?",       "Time"},
           { "Do you have some grain to spare?",  "Food"},
           { "[$2703]", "PriceOfSword"},
           { "Is the surrounding area safe for travellers?",   "SafeForTravelers"},
           { "Do you know how far the nearest town is?",       "NearestTown"},
           { "Do you know if it's going to be cold tomorrow?", "Weather"},
        },

        IdleSpeechConcern={
            {"Are you alright?",     "AreYouHurt"},    
            {"Are you hurt?",        "AreYouHurt"},   
            {"What happened? Are you ok?",        "AreYouHurt"},   
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"Give me some of your money you owe me.",         "DemandMoney"},
            {"I want some of that food.",         "Demand"},
            {"You should give me some of that loot!",          "Demand"},
            {"I want that weapon, may I have it?","Demand"},
        },

        StatementSpeech =  {
            {"[$2704]",  "Statement"},
            {"[$2705]",        "Statement"},
            {"I think that trade is going to pick up soon.",   "Trade"},
            {"[$2706]",        "Bored"},
            {"[$2707]",    "Bored"},
        },

        BoastSpeech = {
            {"I have $" .. math.random(10,20) .. " in my bag!","Brag"},
            {"I could fight off any animal!",     "Brag"},
            {"I could fight any monster!",        "Brag"},
            {"I could eat a whole roast ham!",    "Brag"},
            {"I can walk "  .. math.random(2,10) .. "miles a day!",         "Brag"},
            {"[$2708]",  "Brag"},
        },

        ThreatSpeech = {
            {"Shut your trap or I'll have your throat cut.",   "Threat"},
            {"I'll cut your tounge out for those words!",      "Threat"},
            {"You wouldn't want me to rend your limbs!",       "Threat"},
            {"I'll beat you to a pulp if you don't shutup.",   "Threat"},
            {"Why shouldn't I stomp you like an ant!",         "Threat"},
            {"Why shouldn't I turn your face into mush!",      "Threat"},
        },

        JokeSpeech = {
            {"[$2709]",   "Joke"},
            {"So a guy walks into a bar. Ouch.",   "Joke"},
            {"Remember, beauty is in the eye of the beer holder",            "Joke"},
        },

        InsultSpeech = {
            {"Your mother was a wench!",           "Insult"},
            {"You bathe in dung, you bastard!",    "Insult"},
            {"Go away, you unsavoury bottomfeeder!",            "Insult"},
            {"You smell like a rotting corpse!",   "Insult"},
            {"You look like a bar hag!",           "Insult"},
            {"Your mother was a wench!",           "WhateverMan"},
            {"You bathe in dung, you bastard!",    "WhateverMan"},
            {"Go away, you unsavoury bottomfeeder!",            "WhateverMan"},
            {"You smell like a rotting corpse!",   "WhateverMan"},
            {"You look like a bar hag!",           "WhateverMan"},

        },

        AcceptItemSpeech = {
            {"Thank you.",            "Thanks"},
            {"I'll take that.",       "Thanks"},
            {"That's nice of you.",   "Thanks"},
            {"Thanks",   "Thanks"},
        },

        RejectItemSpeech = {
            {"I don't want that.",    "NoThanks"},
            {"No thank you.",         "NoThanks"},
            {"Thanks, but no.",       "NoThanks"},
            {"No way I'm taking that from you.",   "NoThanks"},
        },

        GreetingSpeech =
        {
            {"Hello.",   "Hello"},      
        },

        FarewellSpeech =
        {
            {"See ya later.",         "Goodbye"}, 
            {"Goodbye.",  "Goodbye"}, 
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!", ""},
            {"Time for you to be put down!",  ""},
            {"Wretched creature!",  ""},
            {"Meat's back on the menu boys!",  ""},
            {"Die, you wretched beast!",  ""},
        },

        CombatSpeech = {
            {"I'll eat you like a ham sandwich!", ""},
            {"I'll show you!",  ""},
            --"I'll drink your blood!",
            {"You got nothing on me!",  ""},
            {"You're going to be sorry, fool!", ""},
            --"I'll dance on your corpse!",
            --"Screw you!",
            --"The Gods laugh at you, scum!",
            {"Where's your pride? Fight me!",  ""},
            {"I will wreck you!",  ""},
            {"I'm going to destroy you!",  ""},
            --"@!$%# You!!!"
        },

        LastMeal = {
            {"Yeah it was pretty good.",""},
            {"No it was awful.","Sorry"},
        },

        CombatSpeechAngry = {
            {"Prepare to die!",  ""},
            {"Prepare to be slaughtered!",  ""},
            {"You'll be begging for mercy soon enough!",  ""},
            {"You smell like horses!",   ""},
            {"Go mate with a dog!",  ""},
            {"Shut your smelly mouth!",  ""},
            {"Coward!",            ""},
            {"You insignificant wretch!",  ""},
            {"I'll crush your skull!",  ""},
            {"Die!",  ""},
        },

        TauntSpeech = {
            {"Come back! Come back!", ""},
            {"Run! Run! Hah!", ""},
            {"You better run!", ""},
            --"Screw you!",
            {"That the best you have?", ""},
            {"You're nothing fool!",  ""},
            {"Run away you coward!",  ""},
            {"Yeah, you better run!", ""},
            {"That's what I thought!", ""},
        },

        FleeSpeech = {
            {"By the gods, help me!", ""},
            {"Help!",            ""},
            {"Ahhh!",            ""},
            {"Screw this!",       ""},
            {"I'm outta here!",  ""},
            {"Gah!",            ""},
            --"@!$%#&!!!",
        },

        TargetDissapearedSpeech = {
            {"Where did he go?",  ""},
            {"Where is he?",            ""},
            {"What? He just disappeared!", ""},
        },     

        TargetPursueSpeech = {
            {"Follow him!",            ""},
            {"Don't let him get away!", ""},
            {"AFTER HIM!!!",            ""},
        },           

        BadJoke = {
            {"That's not funny.","InsultSpeech"},
            {"That's not funny.","Sorry"},
            {"Erm...",""},
            {"Erm...",""},
            {"What...",""},
            {"What...",""},
        },

        Yes = {
            {"Oh OK.",""},
            {"Alright then.",""},
            {"Okay.",""},
        },

        IDontKnow = {
            {"I wouldn't be able to tell you.",""},
            {"I don't know.",""},
            {"Sorry but I can't help you.",""},
        },

        No = {
            {"Oh... OK.",""},
            {"Oh...",""},
            {"Alright then.",""},
        },

        Confused = {
            {"What?",""},
            {"What the?",""},
            {"Uh, what?",""},
            {"...What.",""},
        },

        Neutral = {
            {"Oh OK.",""},
            {"Great thanks.",""},
            {"Okay.",""},
            {"Alright then.",""},
        },

        Food = {
            {"I don't know. Go buy some food somewhere!","No"},
            {"All I know is I don't have any food.","No"},
            {"I'm not hungry myself, sorry.","No"},
        },

        Cook = {
            {"Do I look like a chef?","Sorry"},
        },

        Cute = {
            {"Um, thanks.","Joke"},
        },

        Hungry = {
            {"Go find some food then.","No"},
        },

        Weather = {
            {"I think the weather's going to be nice.","Neutral"},
            {"I'm not sure, can't read the wind.","Neutral"},
            {"It probablly won't be cold..","Neutral"},
        },

        Bored = {
            {"If you're bored, go find something to do!","No"},
            {"I'm bored as well honestly.",""},
        },

        DemandMoney = {
            {"I don't have your money, I'm sorry.","Neutral"},
            {"I'm not paying you. Go bugger off!","Insult"},
            {"I'm not paying you. Go bugger off!","WhateverMan"},
            {"Stop asking me that! I'll pay you when I get it!","Neutral"},
        },

        Sorry = {
            {"Oh, sorry.","Neutral"},
            {"Sorry then.","Neutral"},
            {"Alright then, I'm sorry.","Neutral"},
            {"What's your problem?","Insult"},
            {"What's your problem?","WhateverMan"},
        },

        Time = {
            {"I don't have the time, sorry.","No"},
            {"I don't know the time, sorry.","No"},
            {"I don't have a clock, sorry.","No"},
            {"I don't know what time it is.","No"},
            {"Do I look like a damned clock?","Insult"},
            {"Do I look like a damned clock?","WhateverMan"},
            {"Do I look like a damned clock?","Sorry"},
        },

        Thanks = {
            {"Thanks","NoProblem"},
            {"Thank you","NoProblem"},
            {"Awesome, thanks.","NoProblem"},
            {"Great! Thank you!","NoProblem"},
        },

        NoProblem = {
            {"You're welcome.",""},
            {"No problem.",""},
            {"Anytime",""},
        },

        OhReally = {
            {"Oh really?","Yes"},
        },

        Wow = {
            {"Wow that's crazy!","Yes"},
            {"Wow, really?","Yes"},
            {"Woah!","Yes"},
        },

        Help = {
            {"Sorry, I can't help you.","No"},
            {"I'm not in a position to help you, sorry.",""},
        },

        Answer = {
            {"What do you want exactly?","Sorry"},
            {"I'm answering you! What do you want exactly?","Sorry"},
        },

        Said = {
            {"I gave you an answer. Stop bothering me!","Sorry"},
            {"I know what you said. Stop bothering me!","Sorry"},
        },

        Really = {
            {"Yeah. Really.",""},
        },

        WhateverMan = {
            {"Whatever...",""},
            {"Whatever man.",""},
            {"Whatever.",""},
            {"...Whatever!",""},
        },

        Shutup = {
            {"No - YOU shutup!","Insult"},
            {"No - YOU shutup!","WhateverMan"},
        },
    },

    Villager = {
        IdleResponseNeutral={
            {"Huh.",   ""},
            {"Hmm...", ""},
            {"Yep.",   ""},
            {"Right?", ""},
            {"Heh.",   ""},
            {"Hmm...", ""},
            {"Indeed.",""},
            {"Ok.",    ""},
            {"Right?", ""},
        },

        IdleResponsePositive={
            {"Yeah.",   "Yes"},
            {"Yes.",    "Yes"},
            {"Sure thing.",          "Yes"},
            {"Yep.",    "Yes"},
            {"Yeah.",   "Yes"},
            {"Yes.",    "Yes"},
            {"Definitely.",          "Yes"},
        },

        IdleResponseNegative={
            {"Nope.",  "No"},
            {"Right...",            "No"},
            {"Doubt it.",           "No"},
            {"Doubtful.",           "No"},
            {"No.",    "No"},
            {"Nope.",  "No"},
            {"Right...","No"},
            {"Yeah right.",          "No"},
            {"Don't think so.",      "No"},
            {"Doubt it.",            "No"},
            {"Doubtful.",            "No"},
        },

        IdleResponseAngry={
            {"Quiet you!",           "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shutup!", "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Shutup!", "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shut the hell up!",    "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Quiet you!",           "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shutup!", "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
            {"Shutup!", "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shut the hell up!",    "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
        },

        Mayor = {
            {"I think he's in the market.","Thanks"},
        },
        Rufus = {
            {"He's out at the guard tower near the south gate!","Thanks"},
        },
        DeadGate = {
            {"It's to the north near the river! I have seen it!","OhReally"},
        },

        Dead =  {
            {"Don't speak of the dead!","Sorry"},
            {"They come in the night! Watch out!","No"},
        },
        LastMeal = {
            {"Yeah it was pretty good.",""},
            {"No it was awful.","Sorry"},
        },
        Book = {
            {"Cool. Must have been a good read",""},
        },

        IdleSpeech = { 
            {"Lovely weather we are having.",     "Weather"},
            {"Have you seen the Mayor? I must speak with him!","Mayor"},
            {"[$2710]","Rufus"},
            {"Have you seen the dead gate?",      "DeadGate"},
            {"I hear the dead are stirring in their graves." , "Dead"},
            {"Lovely weather we're having, eh?",  "Weather"},
            {"I'm so bored. Yourself?",           "Bored"},
            {"Did you enjoy that meal?",          "LastMeal"},
            {"Busy today?",          "Bored"},
            {"I just read a skill-book today.",   "Book"},
            {"You look nice!",   "Thanks"},
        },
        Bandits = {
            {"I hear they're organized.","OhReally"},
            {"I heard someone got robbed the other day!","Wow"},
            {"They're all over town, and the Outlands.","OhReally"},
        },
        Cultists = {
            {"Yeah... they enslaved my cousin last week.","Sorry"},
            {"I hear they're planning another raid...","Wow"},
            {"I hear they breed like rabbits...","Wow"},
        },
        PriceOfSword = {
            {"Depends on the sword","Neutral"},
        },
        SafeForTravelers = {
            {"Depends on where you're going.","Neutral"},
            {"It's not really safe past the river...","Neutral"},
            {"I'm not leaving the town. That should say enough.","Wow"},
        },
        NearestTown = {
            {"There are no other towns. This is it.","Neutral"},
        },
        Selling = {
            {"No I'm not selling it.","Sorry"},
        },
        Trade = {
            {"Trade isn't doing well since the Imprisoning.","Yes"},
            {"I'm having a hard time getting work as it is.","Wow"},
        },
        IdleSpeechQuestion = {
            {"Say, would you happen to have the time?",        "Time"},
            {"Is the Golden Lion serving the special today?",  "Food"},
            {"Do you know what time it is?",      "Time"},
            {"Do you have some spare bread?",     "Food"},
            {"[$2711]", "PriceOfSword"},
            {"Have any bandits been sighted near town?",       "Bandits"},
            {"Have any cultists been sighted lately?",         "Cultists"},
            {"Do you know if it's going to be cold tomorrow?", "Weather"},
            {"Say, would you happen to have the time?",        "Time"},
            {"Hey, do you know where I can find a good meal?", "Food"},
            {"Do you know what time it is?",      "Time"},
            {"Do you have some grain to spare?",  "Food"},
            {"[$2712]", "PriceOfSword"},
            {"Is the surrounding area safe for travellers?",   "SafeForTravelers"},
            {"Do you know how far the nearest town is?",       "NearestTown"},
            {"Do you know if it's going to be cold tomorrow?", "Weather"},
        },

        IdleSpeechConcern={
            {"Are you alright?",     "AreYouHurt"},    
            {"Are you hurt?",        "AreYouHurt"},   
            {"What happened? Are you ok?",        "AreYouHurt"},   
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"I hate to ask this but do you have my money?",       "DemandMoney"},
            {"[$2713]",  "Demand"},
            {"[$2714]",           "Demand"},
            {"Are you selling that there?",           "Selling"},
        },

        MerchantBuyerSpeech = {
            {"How much for this?",       "Purchase"}, 
            {"How much for this?",       "Purchase"},       
            {"How much for this?",       "Purchase"},
            {"Do you have these in stock?",           "Purchase"},
            {"When are you getting more of these?",   "Purchase"},
            {"I think this price is too high, I'll pay half.",     "Purchase"},
        },

        MerchantSeller = {
            {"What you see is what you get.",         ""},
            {"Prices are final. Sorry.", "No"},
            {"The price is right there.",""},
        },

        StatementSpeech =  {
            {"[$2715]",      "Dead"},
            {"The guards seem to protect the village decently.", "Dead"},
            {"I think that trade is going to pick up soon.",     "Trade"},
            {"I wish there was more money going around...",      "Trade"},
            {"[$2716]",        "Statement"},
            {"[$2717]",          "Statement"},
            {"I think that trade is going to pick up soon.",     "Statement"},
            {"[$2718]",          "Bored"},
            {"[$2719]",      "Bored"},
        },

        BoastSpeech = {
            {"I saw the guards kill a bandit the other day!", "Brag"},
            {"I just read a skill-book today.", "Brag"},
            {"I just got my weapon fixed!", "Brag"},
            {"I'm the best!", "Brag"},
            {"I fought bandits last week and won!", "Brag"},
            {"I just bought new shoes!", "Brag"},
        },

        ThreatSpeech = {
            {"Shut your trap or I'll wreck you.", "Threat"},
            {"I'll beat you up!", "Threat"},
            {"You don't want a broken arm do you!", "Threat"},
            {"I'll beat you to a pulp if you don't shutup.", "Threat"},
            {"Why shouldn't I bust your face!", "Threat"},
            {"Why shouldn't I kill you?", "Threat"},
        },

        JokeSpeech = {
            {"When the Gods give you lemons, you find a new God!","Joke"},
            {"An ale a day keeps the doctor away!","Joke"},
            {"[$2720]","Joke"},
            {"So a guy walks into a bar. Ouch.","Joke"},
            {"Remember, beauty is in the eye of the beer holder","Joke"},
        },

        InsultSpeech = {
            {"Your a complete coward!","Insult"},
            {"You have no dignity!","Insult"},
            {"Why don't you go eat sand!","Insult"},
            {"You smell awful!","Insult"},
            {"You're an idiot!","Insult"},
            {"Get lost!","Insult"},
            {"Your a complete coward!","WhateverMan"},
            {"You have no dignity!","WhateverMan"},
            {"Why don't you go eat sand!","WhateverMan"},
            {"You smell awful!","WhateverMan"},
            {"You're an idiot!","WhateverMan"},
            {"Get lost!","WhateverMan"},
        },

        GreetingSpeech =
        {
            {"Hello.","Hello"},
            {"Greetings.","Hello"},
            {"Good day.","Hello"},
            {"Hey there.","Hello"},
            {"What's going on?","Hello"},
        },

        FarewellSpeech =
        {
            {"See ya later.","Goodbye"},
            {"Goodbye.","Goodbye"},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Wretched creature!",""},
            {"Meat's back on the menu boys!",""},
            {"Die, you wretched beast!",""},
        },

        CombatSpeech = {
            {"I'll eat you like a ham sandwich!",""},
            {"I'll show you!",""},
            --"I'll drink your blood!",
            {"You got nothing on me!",""},
            {"You're going to be sorry, fool!",""},
            --"I'll dance on your corpse!",
            --"Screw you!",
            --"The Gods laugh at you, scum!",
            {"Where's your pride? Fight me!",""},
            {"I will wreck you!",""},
            {"I'm going to destroy you!",""},
            --"@!$%# You!!!"
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be killed!",""},
            {"You'll be begging for mercy soon enough!",""},
            {"You smell like horses!",""},
            {"Go mate with a dog!",""},
            {"Shut your smelly mouth!",""},
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I'll crush your skull!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Come back! Come back!",""},
            {"Run! Run! Hah!",""},
            {"You better run!",""},
            --"Screw you!",
            {"That the best you have?",""},
            {"You're nothing fool!",""},
            {"Run away you coward!",""},
            {"Yeah, you better run!",""},
            {"That's what I thought!",""},
        },

        FleeSpeech = {
            {"By the gods, help me!",""},
            {"Help!",""},
            {"Ahhh!",""},
            {"Screw this!",""},
            {"I'm outta here!",""},
            {"Gah!",""},
            --"@!$%#&!!!",
        },
    },

    Cultist =
    {
        CombatSpeech = {
            --"I'll eat you like a ham sandwich!",
            {"Like a lamb to the slaughter!",""},
            {"Prepare to die you foul heathen!",""},
            {"Prepare to be slaughtered!",""},
            {"I'll boil your blood!",""},
            {"I will drink your blood you fool!",""},
            {"You got nothing on me heathen!",""},
            {"Die you foul creature!",""},
            {"I'll crush your skull!",""},
            {"You will regret this day, heathen!",""},
            {"I'll dance on your corpse!",""},
            --"Screw you!",
            {"Death to the unbelievers!",""},
            {"The Gods laugh at you, scum!",""},
            {"Where's your pride?",""},
            {"Die you filthy animal!",""},
            {"You'll be begging for mercy soon enough!",""},
            --"It's difficult for me not to kill you.",
            {"Chaos for the Chaos Gods!",""},
            {"Sacrifices for the Gods of Chaos!",""},
            {"Prepare to be sacrficed you wretch!",""},
            {"Shut your smelly mouth!",""},
            {"Chaos! Chaos!",""},
            {"I'll make a sacrifice out of you!",""},
            {"Shun the non-believer!",""},
            {"Pain for you, unbeliever!",""},
            --"Stop embaressing yourself!",
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I will wreck you!",""},
            {"I'm going to destroy you!",""},
            --"@!$%# You!!!"
        },

        Hmph={
            {"Hmph...",""},
        },

        IdleResponseNeutral={
            {"Thou indeed.",""},
            {"Hmph...",""},
            {"Indeed.",""},
        },

        Yes = {
            {"Indeed",""},
            {"Yes.",""},
            {"Thou indeed.",""},
            {"Thine will be done.",""},
            {"Thine will be done. Thy Desolation come.",""},
        },

        IdleResponsePositive={
            {"Doth true.","Yes"},
            {"Art so.","Yes"},
            {"Yes.","Yes"},
            {"Truely.","Yes"},
            {"It is so.","Yes"},
        },

        IdleResponseNegative={
            {"No.","No"},
            {"Naught so.","No"},
            {"I disagree.","No"},
        },

        IdleResponseAngry={
            {"Silence your heresy!","Insult"},
            {"%&$#@ you!","Insult"},
            {"Shut the hell up!","Insult"},
            {"Damn you!","Insult"},
            {"Go to hell!","Insult"},
            {"Silence your heresy!","WhateverMan"},
            {"%&$#@ you!","WhateverMan"},
            {"Shut the hell up!","WhateverMan"},
            {"Damn you!","WhateverMan"},
            {"Go to hell!","WhateverMan"},
        },
        ElderGods = {
            {"Thine will be done. Thine Desolation come...","Yes"},
            {"The Elder Gods are the True Gods.","Yes"},
            {"I praise the Chaos Gods for their guidance.","Yes"},
            {"Praise be to the Chaos Gods.","Yes"},
            {"I pray for the guidance of the Elder Gods","Yes"},
            {"Yihosiglok the Star Dweller be thanked...","Yes"},
        },
        Cannibalism = {
            {"I do have the flesh of the man.","Yes"},
            {"The flesh of the human is the only true food.","Yes"},
            {"I have the True Flesh as declared by Elacatha","Yes"},
        },
        Slaves = {
            {"My captives are in good discipline, yes.","Yes"},
        },
        Ritual = {
            {"Khutnartash has indeed shown me the light.","Yes"},
            {"I have done the ritual, as Yihosiglok decreed.","Yes"},
            {"Dare I say it, the Xor are indeed pleased.","Yes"},
        }, 
        BadJoke = {
            {"Hah hah hah!","Yes"},
        },
        Omen = {
            {"The snake hath spoken.","Yes"},
            {"[$2721]","Yes"},
            {"I have read the Book Of Khutnartash.","Yes"},
        },
        Raid = {
            {"Only our Leader knows our True Path.","Yes"},
            {"[$2722]","Yes"},
        },
        IdleSpeech=
        {
            {"[$2723]","ElderGods"},
            {"By the gods, what does the latest omen say?","Omen"},
            {"How was thy last blood ritual?","Cannibalism"},
            {"The Ritual of Sarkassishth is near.","Ritual"},
            {"[$2724]","Pray"},
        },
        DemandRitual = {
            {"Are you calling me a heretic?","Insult"},
            {"I have done the ritual.","Yes"},
        },
        Pray = {
            {"Let us pray to the Gods of Chaos.","Yes"},
        },
        IdleSpeechQuestion = {
            {"Have you any man-flesh for sale?","Cannibalism"},
            {"[$2725]","Cannibalism"},
            {"Have you prayed today?","Ritual"},
            {"Would you like to trade for your meat?","Cannibalism"},
            {"Does the sacred blacksmith make your weapon?","GoodSword"},
            {"[$2726]","ElderGods"},
            {"When is thy next raid?","Raid"},
            {"Do you have any of your captives for sale?","Slaves"},
            {"Did you feed your slaves?","Slaves"},
            {"Have you read the Ancient Word today?","Omen"},
            {"Have the Snake spoken to you?","Ritual"},
        },

        IdleSpeechConcern={
            {"Art thou injured?","Concern"},
            {"Are you hurt?","Concern"},
            {"Your ichor spills! What happened?","Concern"},
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"Haven't you done your daily rituals?","DemandRitual"},
            {"You must commit your sacrifice tomorrow.","DemandRitual"},
            {"I demand you make an offering. It must be so.","DemandRitual"},
            {"You should give me some of thine loot!","Demand"},
            {"[$2727]","DemandRitual"},
            {"Where is the blood I was promised? Do you have it?","Cannibalism"},
            {"You must commit the Ritual of Harrkoth.","DemandRitual"},
            {"[$2728]","Joke"},
        },

        StatementSpeech =  {
            {"[$2729]","ElderGods"},
            {"Tethys has gone. The Elder Gods will triumph.","Statement"},
            {"[$2730]","Statement"},
            {"[$2731]","ElderGods"},
            {"When will decay touch me! I beg for it.",""},
            {"I must commit my daily sacrifices.","DemandRitual"},
            {"[$2732]"},
            {"Our Gods are better than their Gods.","ElderGods"},
            {"The will of the elder gods be done.","ElderGods"},
            {"[$2733]","ElderGods"},
            {"I must commit my daily offerings.","Goodbye"},
            {"[$2734]","Ritual"},
            {"Thine will be done. Thine desolation come.","ElderGods"},
            {"I should sing the Hymm of Huthaukar.",""},
        },

        BoastSpeech = {
            {"I killed " .. math.random(2,15) .. " men in my day!","Brag"},
            {"I roasted a man alive once!","Brag"},
            {"I have tasted the blood of a unbeliever myself!","Brag"},
            {"I offered more times than you!","Brag"},
            {"I eat nothing but human-flesh! What of you!","Brag"},
            {"I have defeated "..math.random(2,12).." men at a time in combat in my day!","Brag"},
        },

        ThreatSpeech = {
            {"I'll turn you into a sacrifice!","Threat"},
            {"You wouldn't want me to rend your limbs!","Threat"},
            {"Do you want to be food? Answer me!","Threat"},
            {"I'll turn you into my next meal","Threat"},
            {"I'll mash your face into mush!","Threat"},
            {"I'll make you into an offering!","Threat"},
        },

        JokeSpeech = {
            {"[$2735]","BadJoke"},
            {"[$2736]","BadJoke"},
            {"[$2737]","BadJoke"},
            {"The louder they scream, the better the offering!","BadJoke"},
            {"[$2738]","BadJoke"},
            {"[$2739]","BadJoke"},
            {"[$2740]","BadJoke"},
            {"[$2741]","BadJoke"},
        },

        InsultSpeech = {
            {"You speak heresy! You speak heresy!","Insult"},
            --"Your mother was a whore!",
            {"You words are heresy!","Insult"},
            {"You speak naught but lies and blasphemies!","Insult"},
            {"You smell like a rotting corpse!","Insult"},
            {"You blasphemies are countless!","Insult"},
            {"You wail like a crying woman!","Insult"},
            {"You talk like a dog!","Insult"},
            {"You are a failure to the Elder Gods!","Insult"},
            {"Damn you, your offerings are worthless!","Hmph"},
            {"You broke the ritual! You broke the faith!","Hmph"},
            {"The Gods laugh at your sacrifices!","Insult"},
            {"Enough talk, fight me!","Hmph"},
        },

        GreetingSpeech =
        {
            {"Hau-Kohmen, bretheren.","Hello"},
        },
        PriceOfSword = {
            {"[$2742]","Yes"},
        },

        FarewellSpeech =
        {
            {"Till we meet again.","Hello"},
            {"May the Snake guide you.","Hello"},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Wretched creature!",""},
            {"Meat's back on the menu boys!",""},
            {"Die, you wretched beast!",""},
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be slaughtered!",""},
            {"You'll be begging for mercy soon enough!",""},
            {"You smell like horses!",""},
            {"Go mate with a dog!",""},
            {"Shut your smelly mouth!",""},
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I'll crush your skull!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Come back! Come back!",""},
            {"Run! Run! Hah!",""},
            {"You better run! Hah!",""},
            --"Screw you!",
            {"That the best you have?",""},
            {"You're nothing fool!",""},
            {"Run away you coward!",""},
            {"You better run heathen!",""},
            {"Come back, I want to make you an offering!",""},
        },

        FleeSpeech = {
            {"By the gods, help me!",""},
            {"Aaagh!",""},
            {"Ahhh!",""},
            {"By the Gods!",""},
            {"Flee!!",""},
            {"Desolation preserve us!",""},
            --"@!$%#&!!!",
        },
    },

    Pirate =
    {
        CombatSpeech = {
            --"I'll eat you like a ham sandwich!",
            {"Ye ain't be leaving ere!",""},
            {"The plank ye be walking!",""},
            {"Ye won't be needing that leg!",""},
            {"Gar!",""},
            {"Tonight, we'll drink to your bones!",""},
            {"Yar yar fiddle dee!",""},
            {"I smell Doubloons!",""},
            {"To the depths with you!",""},
            {"Gut ye like a fish I will!",""},
            {"Where's the rum gone?",""},
            --"Screw you!",
            {"Death to the unbelievers!",""},
            {"The Gods laugh at you, scum!",""},
            {"Where's your pride?",""},
            {"Die you filthy animal!",""},
            {"You'll be begging for mercy soon enough!",""},
            --"It's difficult for me not to kill you.",
            {"Chaos for the Chaos Gods!",""},
            {"Sacrifices for the Gods of Chaos!",""},
            {"Prepare to be sacrficed you wretch!",""},
            {"Shut your smelly mouth!",""},
            {"Chaos! Chaos!",""},
            {"I'll make a sacrifice out of you!",""},
            {"Shun the non-believer!",""},
            {"Pain for you, unbeliever!",""},
            --"Stop embaressing yourself!",
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I will wreck you!",""},
            {"I'm going to destroy you!",""},
            --"@!$%# You!!!"
        },

        Hmph={
            {"Hmph...",""},
        },

        IdleResponseNeutral={
            {"But where's the rum gone?.",""},
            {"Hmph...",""},
            {"Yar.",""},
        },

        Yes = {
            {"Ofcourse",""},
            {"Yar.",""},
            {"Gar.",""},
        },

        IdleResponsePositive={
            {"Right on.","Yes"},
            {"Gar.","Yes"},
            {"Yar.","Yes"},
            {"Uhuh.","Yes"},
        },

        IdleResponseNegative={
            {"Nar.","No"},
            {"Rubbish.","No"},
            {"No.","No"},
        },

        IdleResponseAngry={
            {"Silence ye herring!","Insult"},
            {"%&$#@ ye!","Insult"},
            {"Shut ye trap!","Insult"},
            {"Damn ye!","Insult"},
            {"To the depths!","Insult"},
            {"Silence your heresy!","WhateverMan"},
            {"%&$#@ you!","WhateverMan"},
            {"Shut the hell up!","WhateverMan"},
            {"Damn you!","WhateverMan"},
            {"Go to hell!","WhateverMan"},
        },
        ElderGods = {
            {"Thine will be done. Thine Desolation come...","Yes"},
            {"The Elder Gods are the True Gods.","Yes"},
            {"I praise the Chaos Gods for their guidance.","Yes"},
            {"Praise be to the Chaos Gods.","Yes"},
            {"I pray for the guidance of the Elder Gods","Yes"},
            {"Yihosiglok the Star Dweller be thanked...","Yes"},
        },
        Cannibalism = {
            {"I do have the flesh of the man.","Yes"},
            {"The flesh of the human is the only true food.","Yes"},
            {"I have the True Flesh as declared by Elacatha","Yes"},
        },
        Slaves = {
            {"My captives are in good discipline, yes.","Yes"},
        },
        Ritual = {
            {"Khutnartash has indeed shown me the light.","Yes"},
            {"I have done the ritual, as Yihosiglok decreed.","Yes"},
            {"Dare I say it, the Xor are indeed pleased.","Yes"},
        }, 
        BadJoke = {
            {"Hah hah hah!","Yes"},
        },
        Omen = {
            {"The snake hath spoken.","Yes"},
            {"[$2721]","Yes"},
            {"I have read the Book Of Khutnartash.","Yes"},
        },
        Raid = {
            {"Only our Leader knows our True Path.","Yes"},
            {"[$2722]","Yes"},
        },
        IdleSpeech=
        {
            {"[$2723]","ElderGods"},
            {"By the gods, what does the latest omen say?","Omen"},
            {"How was thy last blood ritual?","Cannibalism"},
            {"The Ritual of Sarkassishth is near.","Ritual"},
            {"[$2724]","Pray"},
        },
        DemandRitual = {
            {"Are you calling me a heretic?","Insult"},
            {"I have done the ritual.","Yes"},
        },
        Pray = {
            {"Let us pray to the Gods of Chaos.","Yes"},
        },
        IdleSpeechQuestion = {
            {"Have you any man-flesh for sale?","Cannibalism"},
            {"[$2725]","Cannibalism"},
            {"Have you prayed today?","Ritual"},
            {"Would you like to trade for your meat?","Cannibalism"},
            {"Does the sacred blacksmith make your weapon?","GoodSword"},
            {"[$2726]","ElderGods"},
            {"When is thy next raid?","Raid"},
            {"Do you have any of your captives for sale?","Slaves"},
            {"Did you feed your slaves?","Slaves"},
            {"Have you read the Ancient Word today?","Omen"},
            {"Have the Snake spoken to you?","Ritual"},
        },

        IdleSpeechConcern={
            {"Art thou injured?","Concern"},
            {"Are you hurt?","Concern"},
            {"Your ichor spills! What happened?","Concern"},
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"Haven't you done your daily rituals?","DemandRitual"},
            {"You must commit your sacrifice tomorrow.","DemandRitual"},
            {"I demand you make an offering. It must be so.","DemandRitual"},
            {"You should give me some of thine loot!","Demand"},
            {"[$2727]","DemandRitual"},
            {"Where is the blood I was promised? Do you have it?","Cannibalism"},
            {"You must commit the Ritual of Harrkoth.","DemandRitual"},
            {"[$2728]","Joke"},
        },

        StatementSpeech =  {
            {"[$2729]","ElderGods"},
            {"Tethys has gone. The Elder Gods will triumph.","Statement"},
            {"[$2730]","Statement"},
            {"[$2731]","ElderGods"},
            {"When will decay touch me! I beg for it.",""},
            {"I must commit my daily sacrifices.","DemandRitual"},
            {"[$2732]"},
            {"Our Gods are better than their Gods.","ElderGods"},
            {"The will of the elder gods be done.","ElderGods"},
            {"[$2733]","ElderGods"},
            {"I must commit my daily offerings.","Goodbye"},
            {"[$2734]","Ritual"},
            {"Thine will be done. Thine desolation come.","ElderGods"},
            {"I should sing the Hymm of Huthaukar.",""},
        },

        BoastSpeech = {
            {"I killed " .. math.random(2,15) .. " men in my day!","Brag"},
            {"I roasted a man alive once!","Brag"},
            {"I have tasted the blood of a unbeliever myself!","Brag"},
            {"I offered more times than you!","Brag"},
            {"I eat nothing but human-flesh! What of you!","Brag"},
            {"I have defeated "..math.random(2,12).." men at a time in combat in my day!","Brag"},
        },

        ThreatSpeech = {
            {"I'll turn you into a sacrifice!","Threat"},
            {"You wouldn't want me to rend your limbs!","Threat"},
            {"Do you want to be food? Answer me!","Threat"},
            {"I'll turn you into my next meal","Threat"},
            {"I'll mash your face into mush!","Threat"},
            {"I'll make you into an offering!","Threat"},
        },

        JokeSpeech = {
            {"[$2735]","BadJoke"},
            {"[$2736]","BadJoke"},
            {"[$2737]","BadJoke"},
            {"The louder they scream, the better the offering!","BadJoke"},
            {"[$2738]","BadJoke"},
            {"[$2739]","BadJoke"},
            {"[$2740]","BadJoke"},
            {"[$2741]","BadJoke"},
        },

        InsultSpeech = {
            {"You speak heresy! You speak heresy!","Insult"},
            --"Your mother was a whore!",
            {"You words are heresy!","Insult"},
            {"You speak naught but lies and blasphemies!","Insult"},
            {"You smell like a rotting corpse!","Insult"},
            {"You blasphemies are countless!","Insult"},
            {"You wail like a crying woman!","Insult"},
            {"You talk like a dog!","Insult"},
            {"You are a failure to the Elder Gods!","Insult"},
            {"Damn you, your offerings are worthless!","Hmph"},
            {"You broke the ritual! You broke the faith!","Hmph"},
            {"The Gods laugh at your sacrifices!","Insult"},
            {"Enough talk, fight me!","Hmph"},
        },

        GreetingSpeech =
        {
            {"Hau-Kohmen, bretheren.","Hello"},
        },
        PriceOfSword = {
            {"[$2742]","Yes"},
        },

        FarewellSpeech =
        {
            {"Till we meet again.","Hello"},
            {"May the Snake guide you.","Hello"},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Wretched creature!",""},
            {"Meat's back on the menu boys!",""},
            {"Die, you wretched beast!",""},
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be slaughtered!",""},
            {"You'll be begging for mercy soon enough!",""},
            {"You smell like horses!",""},
            {"Go mate with a dog!",""},
            {"Shut your smelly mouth!",""},
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I'll crush your skull!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Get back here matey!",""},
            {"Run! Run! Hah!",""},
            {"You better run! Gahah!",""},
            --"Screw you!",
            {"That the best ye got?",""},
            {"Run away ye coward!",""},
            {"Where ye going landlubber!",""},
        },

        FleeSpeech = {
            {"Raise the anchor!",""},
            {"Flee mateys!",""},
            {"You cheated!",""},
            {"You'll not have me plunder!",""},
            --"@!$%#&!!!",
        },
    },

    Nomad = {
        IdleResponseNeutral={
            {"Huh.",   ""},
            {"Hmm...", ""},
            {"Yep.",   ""},
            {"Right?", ""},
            {"Heh.",   ""},
            {"Hmm...", ""},
            {"Indeed.",""},
            {"Ok.",    ""},
            {"Right?", ""},
        },

        IdleResponsePositive={
            {"Yeah.",   "Yes"},
            {"Yes.",    "Yes"},
            {"Sure thing.",          "Yes"},
            {"Yep.",    "Yes"},
            {"Yeah.",   "Yes"},
            {"Yes.",    "Yes"},
            {"Definitely.",          "Yes"},
        },

        IdleResponseNegative={
            {"Nope.",  "No"},
            {"Right...",            "No"},
            {"Doubt it.",           "No"},
            {"Doubtful.",           "No"},
            {"No.",    "No"},
            {"Nope.",  "No"},
            {"Right...","No"},
            {"Yeah right.",          "No"},
            {"Don't think so.",      "No"},
            {"Doubt it.",            "No"},
            {"Doubtful.",            "No"},
        },

        IdleResponseAngry={
            {"Quiet you!",           "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shutup!", "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Shutup!", "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shut the hell up!",    "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Quiet you!",           "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shutup!", "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
            {"Shutup!", "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shut the hell up!",    "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
        },

        Dead =  {
            {"Only the God of the Void knows!","Sorry"},
        },
        LastMeal = {
            {"Yeah it was pretty good.",""},
            {"No it was awful.","Sorry"},
        },
        Book = {
            {"Excellent. Must have been a good read",""},
        },

        IdleSpeech = { 
            {"Lovely weather we are having.",     "Weather"},
            {"Have you seen the dead gate?",      "DeadGate"},
            {"I hear the dead are stirring in their graves." , "Dead"},
            {"Lovely weather we're having, eh?",  "Weather"},
            {"I'm so bored. Yourself?",           "Bored"},
            {"Did you enjoy that meal?",          "LastMeal"},
            {"Busy today?",          "Bored"},
            {"I just read a skill-book today.",   "Book"},
            {"You look nice!",   "Thanks"},
        },
        Bandits = {
            {"I hear they're organized.","OhReally"},
            {"I heard someone got robbed the other day!","Wow"},
            {"The intruders are EVERYWHERE these days.","OhReally"},
        },
        Cultists = {
            {"Yeah... they enslaved my clansman last week.","Sorry"},
            {"I hear they're planning another raid...","Wow"},
            {"I hear they breed like rabbits...","Wow"},
        },
        PriceOfSword = {
            {"Depends on the sword","Neutral"},
        },
        SafeForTravelers = {
            {"The desert consumes all who visit it. If not there, then in their hearts.","Neutral"},
        },
        NearestTown = {
            {"Ask the Intruders.","Neutral"},
        },
        Selling = {
            {"No I'm not selling it.","Sorry"},
        },
        Trade = {
            {"I met a man who found success at the outpost.","Yes"},
            {"I'm having a hard time selling my stuff as it is.","Wow"},
        },
        IdleSpeechQuestion = {
            {"Would you happen to have the time?",        "Time"},
            {"Do you know what time it is?",      "Time"},
            {"Do you have some spare hummus?",     "Food"},
            {"[$2711]", "PriceOfSword"},
            {"Have any Intruders been sighted near?",       "Bandits"},
            {"Have any cultists been sighted lately?",         "Cultists"},
            {"Do you know if it's going to be dry this season?", "Weather"},
            {"Say, would you happen to have the time?",        "Time"},
            {"Hey, where have the rabbits gone. We need food?", "Food"},
            {"Do you know what time it is?",      "Time"},
            {"Do you have some hummus to spare?",  "Food"},
            {"[$2712]", "PriceOfSword"},
            {"Is that part of the Wastes safe?",   "SafeForTravelers"},
            {"Where can I sell these wares?",       "NearestTown"},
        },

        IdleSpeechConcern={
            {"Are you alright?",     "AreYouHurt"},    
            {"Are you hurt?",        "AreYouHurt"},   
            {"What happened? Are you ok?",        "AreYouHurt"},   
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"I hate to ask this but do you have my Kafish?",       "DemandMoney"},
            {"Are you selling that there?",           "Selling"},
        },

        MerchantBuyerSpeech = {
            {"How much for this?",       "Purchase"}, 
            {"How much for this?",       "Purchase"},       
            {"How much for this?",       "Purchase"},
            {"Do you have these in stock?",           "Purchase"},
            {"When are you getting more of these?",   "Purchase"},
            {"I think this price is too high, I'll pay half.",     "Purchase"},
        },

        MerchantSeller = {
            {"What you see is what you get.",         ""},
            {"Prices are final. Sorry.", "No"},
            {"The price is right there.",""},
        },

        StatementSpeech =  {
            {"[$2715]",      "Dead"},
            {"The guards seem to protect the village decently.", "Dead"},
            {"I think that trade is going to pick up soon.",     "Trade"},
            {"I wish there was more money going around...",      "Trade"},
            {"[$2716]",        "Statement"},
            {"[$2717]",          "Statement"},
            {"I think that trade is going to pick up soon.",     "Statement"},
            {"[$2718]",          "Bored"},
            {"[$2719]",      "Bored"},
        },

        BoastSpeech = {
            {"I have more Kafish than you!", "Brag"},
            {"I don't have time for this!", ""},
            {"You probablly follow the Strangers!", "Brag"},
            {"Take that back!", "Brag"},
            {"I have more skill in the sword than you!", "Brag"},
            {"My business is none of your concern!", "Brag"},
        },

        ThreatSpeech = {
            {"Your corpse, will be thrown to the Wargs...", "Threat"},
            {"You're nothing. NOTHING!!!", "Threat"},
            {"You do not believe in the Elements! You deserve DEATH!!", "Threat"},
            {"I'll turn you into Safish", "Threat"},
            {"Why shouldn't I bust your face for this tresspass!", "Threat"},
            {"Why shouldn't I kill you now?", "Threat"},
        },

        JokeSpeech = {
            {"When the Gods give you lemons, you find a new God!","Joke"},
            {"An ale a day keeps the doctor away!","Joke"},
            {"[$2720]","Joke"},
            {"So a guy walks into a bar. Ouch.","Joke"},
            {"Remember, beauty is in the eye of the beer holder","Joke"},
        },

        InsultSpeech = {
            {"Your a complete coward!","Insult"},
            {"You have no dignity!","Insult"},
            {"Why don't you go eat sand!","Insult"},
            {"You smell awful!","Insult"},
            {"You're an idiot!","Insult"},
            {"Get lost!","Insult"},
            {"Your a complete coward!","WhateverMan"},
            {"You have no dignity!","WhateverMan"},
            {"Why don't you go eat sand!","WhateverMan"},
            {"You smell awful!","WhateverMan"},
            {"You're an idiot!","WhateverMan"},
            {"Get lost!","WhateverMan"},
        },

        GreetingSpeech =
        {
            {"In all good tidings.","Hello"},
            {"In the name of the Elements, I greet you.","Hello"},
            {"In Peace brings us.","Hello"},
        },

        FarewellSpeech =
        {
            {"In time.","Goodbye"},
            {"Goodbye.","Goodbye"},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Wretched creature!",""},
            {"Meat's back on the menu boys!",""},
            {"Die, you wretched beast!",""},
        },

        CombatSpeech = {
            {"I'll eat you like a ham sandwich!",""},
            {"I'll show you!",""},
            --"I'll drink your blood!",
            {"You got nothing on me!",""},
            {"You're going to be sorry, fool!",""},
            --"I'll dance on your corpse!",
            --"Screw you!",
            --"The Gods laugh at you, scum!",
            {"Where's your pride? Fight me!",""},
            {"I will wreck you!",""},
            {"I'm going to destroy you!",""},
            --"@!$%# You!!!"
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be killed!",""},
            {"You'll be begging for mercy soon enough!",""},
            {"You smell like camels!",""},
            {"Go mate with a Warg!",""},
            {"Shut your smelly mouth!",""},
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I'll crush your skull!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Come back! Come back!",""},
            {"Run! Run! Hah!",""},
            {"You better run!",""},
            --"Screw you!",
            {"That the best you have?",""},
            {"You're nothing fool!",""},
            {"Run away you coward!",""},
            {"Yeah, you better run!",""},
            {"That's what I thought!",""},
        },

        FleeSpeech = {
            {"By the Elements, help me!",""},
            {"Help!",""},
            {"Ahhh!",""},
            {"Screw this!",""},
            {"I'm outta here!",""},
            {"Gah!",""},
            --"@!$%#&!!!",
        },
    },

    Rebel = {  
        IdleResponseNeutral={
            {"Huh.",   ""},
            {"Hmm...", ""},
            {"Yep.",   ""},
            {"Right?", ""},
            {"Heh.",   ""},
            {"Hmm...", ""},
            {"Indeed.",""},
            {"Ok.",    ""},
            {"Right?", ""},
        },

        IdleResponsePositive={
            {"Yeah.",   "Yes"},
            {"Yes.",    "Yes"},
            {"Sure thing.",          "Yes"},
            {"Yep.",    "Yes"},
            {"Yeah.",   "Yes"},
            {"Yes.",    "Yes"},
            {"Definitely.",          "Yes"},
        },

        IdleResponseNegative={
            {"Nope.",  "No"},
            {"Right...",            "No"},
            {"I disagree.",         "No"},
            {"Doubt it.",           "No"},
            {"Doubtful.",           "No"},
            {"No.",    "No"},
            {"Nope.",  "No"},
            {"Right...","No"},
            {"Yeah right.",          "No"},
            {"Don't think so.",      "No"},
            {"Doubt it.",            "No"},
            {"Doubtful.",            "No"},
        },
        
        IdleResponseAngry={
            {"Quiet you!",           "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shutup!", "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Shutup!", "Insult"},
            {"%&$#@ you!",           "Insult"},
            {"Shut the hell up!",    "Insult"},
            {"Screw you!",           "Insult"},
            {"Go to hell!",          "Insult"},
            {"Quiet you!",           "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shutup!", "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
            {"Shutup!", "WhateverMan"},
            {"%&$#@ you!",           "WhateverMan"},
            {"Shut the hell up!",    "WhateverMan"},
            {"Screw you!",           "WhateverMan"},
            {"Go to hell!",          "WhateverMan"},
        },

        Spies = {
            {"No word from them for some time.","Wow"},
            {"We haven't heard from them in some time...",""},
            {"I only hear bad things. Let's not talk about it.","Wow"},
        },

        Dragon = {
            {"[$2743]","Wow"},
            {"[$2744]","Sorry"},
        },

        AttackVillage = {
            {"That was some time ago.","Neutral"},
            {"That was some time ago. I hope my family is fine.","Sorry"},
            {"I haven't heard anything...","Neutral"},
            {"[$2745]","Neutral"},
        },

        Raid = {
            {"[$2746]","Wow"},
            {"That's suicide.","OhReally"},
            {"We lost a number of people last time. Good men.","OhReally"},
        },

        Cultists = {
            {"Gods know how they get past the wall.","Yes"},
            {"They're all over the place.","OhReally"},
        },

        PriceOfSword = {
            {"I'll trade you some food for it.","OhReally"},
            {"It's not as much as a good meal.","OhReally"},
            {"I'll trade you for some more berries...","No"},
        },

        IdleSpeech = { 
            {"Lovely weather we are having.", "Weather"},
            {"[$2747]", "Cultists"},
            {"Has anyone heard word from the spies?", "Spies"},
            {"I hear there was an attack on the village." , "AttackVillage"},
            {"Lovely weather we're having, eh?", "Weather"},
            {"I'm so bored. Yourself?", "Bored"},
            {"Did you enjoy that rabbit stew?", "LastMeal"},
            {"Busy today?", "Bored"},
            {"I found bones burnt from the dragon.", "Dragon"},
        },

        IdleSpeechQuestion = {
            {"Do you know how long it's been since they left?","Spies"},
            {"Someone have any more berries?","Food"},
            {"Do you know what time it is?", "Time"},
            {"Do you have some spare food?","Food"},
            {"Do you know who's selling a sword?","PriceOfSword"},
            {"Have any guards been spotted?", "Guards"},
            {"Have any cultists been sighted lately?","Cultists"},
            {"Do you know if it's going to be cold tomorrow?","Weather"},
            {"Say, would you happen to have the time?","Time"},
            {"Any sight of the dragon?","Dragon"},
            {"Do you know what time it is?","Time"},
            {"Do you have some meat to spare?","Food"},
            {"Any word from the spies beyond the wall?","Spies"},
            {"Do you know why it's always fall here?","No"},
        },

        IdleSpeechConcern={
            {"Are you alright?","Concern"},
            {"Are you hurt?","Concern"},
            {"What happened? Are you ok?","Concern"},
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"I hate to ask this but do you have my payment?","DemandMoney"},
            {"I say we do a raid on the wall. What about you?","Raid"},
            {"[$2748]","Demand"},
            {"Are you selling that there?","Purchase"},
        },

        MerchantBuyerSpeech = {
            {"How much for this?","Purchase"},
            {"How much for this?","Purchase"},
            {"How much for this?","Purchase"},
            {"Do you have these in stock?","Purchase"},
            {"When are you getting more of these?","Purchase"},
            {"I think this price is too high, I'll pay half.","Purchase"},
        },

        MerchantSeller = {
            {"What you see is what you get.","No"},
            {"Prices are final. Sorry.","No"},
            {"The price is right there.","No"},
        },

        StatementSpeech =  {
            {"[$2749]","Cultists"},
            {"The guards are fools for following the council.","Guards"},
            {"We should find a guild to join...","Cultists"},
            {"I wish there was more food going around...","Cultists"},
            {"[$2750]","Statement"},
            {"[$2751]","Bored"},
            {"I'm expecting a raid soon.","Raid"},
            {"[$2752]","Bored"},
            {"[$2753]","Bored"},
        },

        BoastSpeech = {
            {"[$2754]","Guards"},
            {"I just got my weapon fixed!","Brag"},
            {"I've killed a guard!","Guards"},
            {"I fought the Guardian Order last week and won!","Brag"},
            {"I just bought new shoes!","Brag"},
        },

        ThreatSpeech = {
            {"Shut your trap or I'll wreck you.","Threat"},
            {"I'll beat you up!","Threat"},
            {"You don't want a broken arm do you!","Threat"},
            {"I'll beat you to a pulp if you don't shutup.","Threat"},
            {"Why shouldn't I bust your face!","Threat"},
            {"Why shouldn't I kill you?","Threat"},
        },

        JokeSpeech = {
            {"When the gods give you lemons, you find a new god!","Joke"},
            {"An ale a day keeps the doctor away!","Joke"},
            {"[$2755]","Joke"},
            {"So a guy walks into a bar. Ouch.","Joke"},
            {"Remember, beauty is in the eye of the beer holder","Joke"},
        },

        InsultSpeech = {
            {"Your a complete coward!","Insult"},
            {"You have no dignity!","Insult"},
            {"Why don't you go eat sand!","Insult"},
            {"You smell awful!","Insult"},
            {"You're an idiot!","Insult"},
            {"Get lost!","Insult"},
            {"Your a complete coward!","WhateverMan"},
            {"You have no dignity!","WhateverMan"},
            {"Why don't you go eat sand!","WhateverMan"},
            {"You smell awful!","WhateverMan"},
            {"You're an idiot!","WhateverMan"},
            {"Get lost!","WhateverMan"},
        },

        GreetingSpeech =
        {
            {"Hello.","Hello"},
            {"Greetings.","Hello"},
            {"Good day.","Hello"},
            {"Hey there.","Hello"},
            {"What's going on?","Hello"},
        },

        FarewellSpeech =
        {
            {"See ya later.","Goodbye"},
            {"Goodbye.","Goodbye"},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Wretched creature!",""},
            {"Meat's back on the menu boys!",""},
            {"Die, you wretched beast!",""},
        },

        CombatSpeech = {
            {"I'll eat you like a ham sandwich!",""},
            {"I'll show you!",""},
            --"I'll drink your blood!",
            {"You got nothing on me!",""},
            {"You're going to be sorry, fool!",""},
            --"I'll dance on your corpse!",
            --"Screw you!",
            --"The Gods laugh at you, scum!",
            {"Where's your pride? Fight me!",""},
            {"I will wreck you!",""},
            {"I'm going to destroy you!",""},
            --"@!$%# You!!!"
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be killed!",""},
            {"You'll be begging for mercy soon enough!",""},
            {"You smell like horses!",""},
            {"Go mate with a dog!",""},
            {"Shut your smelly mouth!",""},
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I'll crush your skull!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Come back! Come back!",""},
            {"Run! Run! Hah!",""},
            {"You better run!",""},
            --"Screw you!",
            {"That the best you have?",""},
            {"You're nothing fool!",""},
            {"Run away you coward!",""},
            {"Yeah, you better run!",""},
            {"That's what I thought!",""},
        },

        FleeSpeech = {
            {"By the gods, help me!",""},
            {"Help!",""},
            {"Ahhh!",""},
            {"Screw this!",""},
            {"I'm outta here!",""},
            {"Gah!",""},
            --"@!$%#&!!!",
        },
    },

    --DFB TODO: Convert this to another language.
    Barbarian = {  

        CombatSpeech = {
            "By the WILL of Lilith, Prepare to be SMASHED",
            "TO WAR BOYS!!!",
            "Fuck them up!",
            "Turn them into rubbish piles!",
            "Send their souls to the next world!",
            "Forsaker of the Goddesses!!!",
            "Plunder, Loot, Smash!",
            "Smash them to bits!",
            "Crush them in the name of Lilith!",
            "RAARRRRRRGGGHH",
            "Attack! Attack!",
            "Chop them into bits!",
            "Skin the meat from their bones!",
            "Slay them in Lilith's name!",
            "Bash their heads in!",
            "CRUSH THEM",
            "DIE... FORSAKER!!!",
        },

        AttackVillage = {
            {"That was some time ago.","Neutral"},
            {"That was some time ago. We crushed them like rats.","Sorry"},
            {"I haven't heard anything...","Neutral"},
            {"[$2745]","Neutral"},
        },

        Raid = {
            {"It would be worth it, I say, for Lilith and Eve.","Wow"},
            {"That's a great idea!!!.","OhReally"},
            {"We figured it would be a good idea.","OhReally"},
        },

        Cultists = {
            {"Only Lilith and Eve can guide the Forsaken.","Yes"},
            {"They're all over the place.","OhReally"},
        },

        PriceOfSword = {
            {"I'll trade you some food for it.","OhReally"},
            {"It's not as much as a good bunch of mead.","OhReally"},
            {"I'll trade you for some more meat...","Yes"},
        },

        IdleSpeech = { 
            {"Lovely weather we are having.", "Weather"},
            {"I have not seen the cult in many years.", "Cultists"},
            {"Has anyone heard word from the settlers?", "Settlers"},
            {"I hear there was an attack on the village." , "AttackVillage"},
            {"Lovely weather we're having, eh?", "Weather"},
            {"I'm so bored. Yourself?", "Bored"},
            {"Did you enjoy that bear stew?", "LastMeal"},
            {"Busy today?", "Bored"},
            {"The gods have spoken to me.", "OhReally"},
        },

        IdleSpeechQuestion = {
            {"Do you know how long it's been since they left?","Spies"},
            {"Someone have any more mead?","Food"},
            {"Do you know what time it is?", "Time"},
            {"Do you have some spare food?","Food"},
            {"Do you know who's selling a sword?","PriceOfSword"},
            {"Have any of the Southerners been seen?", "Guards"},
            {"Have any cultists been sighted lately?","Cultists"},
            {"Do you know if it's going to be cold tomorrow?","Weather"},
            {"Say, would you happen to have the time?","Time"},
            {"Any sight of the Ancient Bear?","Dragon"},
            {"Do you know what time it is?","Time"},
            {"Do you have some food to spare?","Food"},
            {"Any word from the Settlers?","Settlers"},
            {"Do you know why it's always fall here?","No"},
        },

        IdleSpeechConcern={
            {"Are you alright?","Concern"},
            {"Are you hurt?","Concern"},
            {"What happened? Are you ok?","Concern"},
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"I hate to ask this but do you have my payment?","DemandMoney"},
            {"I say we do a-viking on the Southerners. What about you?","Raid"},
            {"Are you selling that there?","Purchase"},
        },

        MerchantBuyerSpeech = {
            {"How much for this?","Purchase"},
            {"How much for this?","Purchase"},
            {"How much for this?","Purchase"},
            {"Do you have these in stock?","Purchase"},
            {"When are you getting more of these?","Purchase"},
            {"I think this price is too high, I'll pay half.","Purchase"},
        },

        MerchantSeller = {
            {"What you see is what you get.","No"},
            {"Prices are final. Sorry.","No"},
            {"The price is right there.","No"},
        },

        StatementSpeech =  {
            {"The Southerners are fools for following the Elemental Gods.","Guards"},
            {"We should find a guild to join...","Cultists"},
            {"I wish there was more food going around...","Cultists"},
            {"I'm expecting a raid soon.","Raid"},
        },

        BoastSpeech = {
            {"I just got my weapon fixed!","Brag"},
            {"I've killed a guard!","Guards"},
            {"I killed 12 Cultists!","Brag"},
            {"I slew 12 Southeners!","Brag"},
            {"I just bought new shoes!","Brag"},
        },

        ThreatSpeech = {
            {"Shut your trap or I'll smash you to the next world.","Threat"},
            {"My axe seems to like your head!","Threat"},
            {"You don't want to be my thrall, do you","Threat"},
            {"You smell like an old woman, boy.","Threat"},
            {"Why shouldn't I kill you?","Threat"},
        },

        JokeSpeech = {
            {"When the Godesses are favorable, so is the wind!","Joke"},
            {"A mead a day keeps the doctor away!","Joke"},
            {"So a guy walks into a bear. This time, the bear wears him!","Joke"},
            {"Remember, beauty is in the eye of the beer holder","Joke"},
        },

        InsultSpeech = {
            {"Your a complete coward!","Insult"},
            {"You have no dignity!","Insult"},
            {"Why don't you go eat sand!","Insult"},
            {"You smell awful!","Insult"},
            {"You're an idiot!","Insult"},
            {"Get lost!","Insult"},
            {"Your a complete coward!","WhateverMan"},
            {"You have no dignity!","WhateverMan"},
            {"Why don't you go eat sand!","WhateverMan"},
            {"You smell awful!","WhateverMan"},
            {"You're an idiot!","WhateverMan"},
            {"Get lost!","WhateverMan"},
        },

        GreetingSpeech =
        {
            {"Hello.","Hello"},
            {"Greetings.","Hello"},
            {"Good day.","Hello"},
            {"Hey there.","Hello"},
            {"What's going on?","Hello"},
        },

        FarewellSpeech =
        {
            {"See ya later.","Goodbye"},
            {"Goodbye.","Goodbye"},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Wretched creature!",""},
            {"Meat's back on the menu boys!",""},
            {"Die, you wretched beast!",""},
        },

        CombatSpeech = {
            {"I'll eat you like a ham sandwich!",""},
            {"I'll show you!",""},
            --"I'll drink your blood!",
            {"You got nothing on me!",""},
            {"You're going to be sorry, fool!",""},
            --"I'll dance on your corpse!",
            --"Screw you!",
            --"The Gods laugh at you, scum!",
            {"Where's your pride? Fight me!",""},
            {"I will wreck you!",""},
            {"I'm going to destroy you!",""},
            --"@!$%# You!!!"
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be killed!",""},
            {"You'll be begging for mercy soon enough!",""},
            {"You smell like horses!",""},
            {"Go mate with a dog!",""},
            {"Shut your smelly mouth!",""},
            {"Coward!",""},
            {"You insignificant wretch!",""},
            {"I'll crush your skull!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Come back! Come back!",""},
            {"Run! Run! Hah!",""},
            {"You better run!",""},
            --"Screw you!",
            {"That the best you have?",""},
            {"You're nothing fool!",""},
            {"Run away you coward!",""},
            {"Yeah, you better run!",""},
            {"That's what I thought!",""},
        },

        FleeSpeech = {
            {"RUN FOR YOUR LIVES!",""},
            --"@!$%#&!!!",
        },
    },
    Guard = {
        IdleResponseNeutral={
            {"Hmph.",""},
            {"Hmm.",""},
            {"Indeed.",""},
            {"Hmm...",""},
        },

        IdleResponsePositive={
            {"Yes.","Yes"},
            {"Definitely.","Yes"},
        },

        IdleResponseNegative={
            {"No.","No"},
            {"Doubt it.","No"},
            {"Doubtful.","No"},
            {"Yeah right.","No"},
            {"Don't think so.","No"},
            {"Doubt it.","No"},
        },

        IdleResponseAngry={
            {"Quiet you!","Insult"},
            {"Shutup!","Insult"},
            {"Shutup!","Insult"},
            {"Shut the hell up!","Insult"},
            {"Quiet you!","WhateverMan"},
            {"Shutup!","WhateverMan"},
            {"Shutup!","WhateverMan"},
            {"Shut the hell up!","WhateverMan"},
        },

        IdleSpeech = { 
            {"Spoke to the Captain the other day.", "News"},
            {"Rufus issued new orders.","News"},
            {"No sighting of cultists.","Cultists"},
            {"No sight of the undead yet." ,"Dead"},
            {"I could enjoy a good feast.","Food"},
            {"[$2756]",""},
            {"There's news.","News"},
            {"Slaughtered a criminal the other day.",""},
            {"I am the law.",""},
        },

        IdleSpeechQuestion = {
            {"Any news?",""},
            {"Anything of interest?",""},
            {"Anything that concerns the Guardian Order?",""},
            {"What are the orders?",""},
        },

        IdleSpeechConcern={
            {"What happened!","Concern"},
            {"Are you hurt?","Concern"},
            {"Who attacked you!?","Concern"},
        },

        DemandSpeech = {
            {"Do you have the time for a few questions?","GuardDemand"},
            {"I need to file a report. Stay here.","GuardDemand"},
            {"[$2757]","GuardDemand"},
        },

        MerchantBuyerSpeech = {
            {"Are you paying your taxes for this?","Purchase"},
            {"How much for this?","Purchase"},
            {"Are you distributing your rations?","Purchase"},
            {"The price exceeds the recommended rate.","Purchase"},
        },

        StatementSpeech =  {
            {"We repelled the last attack by the Undead.","Dead"},
            {"[$2758]","Rebels"},
            {"We're gonna need more enchanted armor.",""},
            {"No rebels have been sighted as of late.","Rebels"},
            {"No cultists have been sighted as of late.","Cultists"},
            {"No bandits have been sighted as of late.","Bandits"},
            {"No undead have been sighted as of late.","Dead"},
            {"I'll speak to the commander.",""},
            {"After all, we are the law.","Statement"},
            {"I heard the rumor.","Statement"},
            {"Not sure I understand what you're saying.","Statement"},
            {"Nothing new to report.","Statement"},
            --"Those donuts I had the other day were pretty good.",
            --"Man I could go for some donuts right now."
        },

        BoastSpeech = {
            {"I've prosecuted "..math.random(1,50).." criminals in my career.","Brag"},
            {"I beaten "..math.random(1,50).." undead in my career.","Brag"},
            {"I slew "..math.random(1,50).." cultists in my career.","Brag"},
            {"I just got promoted.","Brag"},
        },

        ThreatSpeech = {
            {"Shut your mouth.","Threat"},
            {"I'll show YOU excessive use of force.","Threat"},
            {"Do you want to be prosecuted?","Threat"},
            {"[$2759]","Threat"},
            {"Obedience is required from you, scum!","Threat"},
            {"Quiet you, or I'll have you arrested!","Threat"},
            {"Quiet you!","Threat"},
        },

        JokeSpeech = {
            {"[$2760]","BadJoke"},
            --"Donuts are good, aren't they?",
            {"[$2761]","BadJoke"},
            {"[$2762]","BadJoke"},
            {"[$2763]","BadJoke"},
        },

        InsultSpeech = {
            {"You deserve a good beating!","Insult"},
            {"Speak your mind or prepare for a beating!","Insult"},
            {"I've killed bigger criminals than YOU!","Insult"},
            {"Do you want the sword, scum?!","Insult"},
            {"Get in line!","Insult"},
            {"Get lost!","Insult"},
            {"You deserve a good beating!","Sorry"},
            {"Speak your mind or prepare for a beating!","Sorry"},
            {"I've killed bigger criminals than YOU!","Sorry"},
            {"Do you want the sword, scum?!","Sorry"},
            {"Get in line!","Sorry"},
            {"Get lost!","Sorry"},
        },

        GreetingSpeech =
        {
            {"Good evening.","Hello"},
            {"Good day.","Hello"},
        },

        FarewellSpeech =
        {
            {"Until next time.",},
            {"Goodbye."},
        },

        CombatSpeechAnimal = {
            {"Die you filthy animal!",""},
            {"Time for you to be put down!",""},
            {"Stupid animal!",""},
            {"Prepare to be killed beast!",""},
        },

        CombatSpeech = {
           -- "I'll show you the MEANING of excessive force!",
            {"Time for you to be prosecuted!",""},
            {"You're under arrest!",""},
            {"Time for a good beating!",""},
            {"You deserve to be flogged!",""},
            {"I'll cut you into pieces!",""},
            {"I AM THE LAW, SCUM!!!",""},
            {"Time for your sentence!",""},
            {"I'll discipline you, scum!",""},
            --"I'll show you how to be a good citizen!",
            {"You're gonna hurt when I'm done with you!",""},
            {"[$2764]",""},
            {"Stop right there!",""},
            {"I order you to STOP!",""},
            {"Freeze!",""},
        },

        CombatSpeechAngry = {
            {"You're gonna hurt when I'm done with you!",""},
            {"I'm gonna murder you!",""},
            {"Come back here or I'll make it slow!",""},
            {"Get over here criminal!",""},
        },

        TauntSpeech = {
            {"You better run!",""},
        },

        FleeSpeech = {
            {"@!$%#&!!!",""},
        },

        ProsecuteMessages =
        {
            {"[$2765]","Prosecute"},
            {"[$2766]","Prosecute"},
            {"[$2767]","Prosecute"},
            {"[$2768]","Prosecute"},
            {"[$2769]","Prosecute"},
            {"[$2770]","Prosecute"},
            {"[$2771]","Prosecute"},
            {"[$2772]","Prosecute"},
            {"[$2773]","Prosecute"},
        },

        DelayMessages = {
          {"I'm waiting...",""},
          {"Hurry up!", ""},
        },
    },  

    Berserker = {
        CombatSpeech = {
            {"GARHAGARH!!!!",""},
            {"NARRRAHAHHH!!!!",""},
            {"RRRGGHHHH!!!",""},
            --"@!$%# You!!!"
        },

        IdleResponseNeutral={
            {"RARGH!!!",""},
            {"GRRRRR!!!",""},
        },

        IdleResponsePositive={
            {"RARGH!!",""},
            {"YARGH!!!",""},
        },

        IdleResponseNegative={
            {"REGARAHAH!!!.",""},
            {"RARRRGH!!!!",""},
        },

        IdleResponseAngry={
            {"GRAAAHHHHHH!!!!",""},
            {"RAARRRRRRGGGHH!!",""},
        },

        IdleSpeech=
        {
            {"RARGH!!",""},
        },

        IdleSpeechQuestion = {
            {"GRRRRRARRGH!!",""},
            {"RARGHARGARRG!!",""},
        },

        IdleSpeechConcern={
            {"GRAGH!!",""},
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"RARRGHH!!!",""},
        },

        StatementSpeech =  {
            {"RARGHH RAGRHA!!!.",""},
        },

        BoastSpeech = {
            {"RARHRGRAHAH!!!",""},
            {"GARRAGHRAH!!!",""},
        },

        ThreatSpeech = {
            {"GRRRRRRRRRRRRAGAH!!!",""},
        },

        JokeSpeech = {
            {"GARGRAHRAGRHA!",""},
            {"RARGRARRARGARGA!!!",""},
        },

        InsultSpeech = {
            {"GARRGHARAHHH!!!",""},
        },

        GreetingSpeech =
        {
            {"RARG!!!",""},
        },

        FarewellSpeech =
        {
            {"RARGA!!!",""},
        },

        CombatSpeechAnimal = {
            {"GARHAGARH!!!!",""},
            {"NARRRAHAHHH!!!!",""},
            {"RRRGGHHHH!!!",""},
            --"@!$%# You!!!"
        },

        CombatSpeechAngry = {
            {"GARHAGARH!!!!",""},
            {"NARRRAHAHHH!!!!",""},
            {"RRRGGHHHH!!!",""},
            --"@!$%# You!!!"
        },

        TauntSpeech = {
            {"GRARRRGH!!",""},
        },

        FleeSpeech = {
            {"YARRRGH!!!!",""},
            --"@!$%#&!!!",
        },
    },

    VoidWorshipper = {
        CombatSpeech = {
            {"Sacrifice him for Kho!",""},
            {"Prepare for eternal torment, sinner!",""},
            {"The Void God will FEAST on your SOULS!",""},
            {"I will drink your soul!",""},
            --"We shall TORTURE you ETERNALLY!",
            {"You will be fodder for the damned!",""},
            {"In the name of Kho, prepare to SUFFER!!!",""},
            --"The depths of space and time know no end!",
            {"Be damned to the HELLS you scum!",""},
            {"I'll SWALLOW your SOUL!!!",""},
            {"You will BURN forever in the HELLS!",""},
            {"Your soul will be feasted upon!",""},
            {"FEAST on his SOUL!!!",""},
            {"Death will not be your end!",""},
            {"KILL!!! KILL!!! KILL!!!",""},
            {"All those who oppose the Void God shall suffer!",""},
            {"You will be cast into the Void!",""},
            {"Eternal damnation awaits you!",""},
            {"You'll know fear in HELL!!!",""},
            {"The Void God will enjoy you!!!",""},
            {"Kho will FEAST on your SOUL!",""},
            {"Your death will be sweet, your soul RIPE!",""},
            {"I will send you to the Void!",""},
            {"Your essence... will be CONSUMED!",""},
            {"Feast on the product of his sins!!!",""},
            {"Prepare to suffer for your SINS!!!",""},
            {"DELIVER HIM STRAIGHT TO THE VOID!!!",""},
            {"Send him to the Void!",""},
            {"Make him suffer!!!",  ""},
            {"Send him to THE HELLS!!!",""},
            {"Cast him out!",""},
            {"Sacrifice him!",""},
            {"Sacrifice him, for KHO!!!",""},
            {"Pain for you!!! ETERNAL PAIN!",""},
            {"Sacrifice him to the Void!",""},
            {"In the name of hell, take this one!!!",""},
            {"Corrupt him accordingly!",""},
            {"Your corruption is at hand!!!",""},
            {"Swallow his soul!",""},
            {"By all that is unholy, prepare to suffer!",""},
            {"Feast on his pride!",""},
            {"Feast on the fruit of his sins!",""},
            {"Your soul is mine!",""},
            {"Prepare to die a slow death!",""},
            {"Eternal hellfire for YOU!!!",""},
            {"I will destroy you!",""},
            {"I'm going to destroy you!",""},
            {"The voices are telling me to KILL YOU!!!",""},
            {"DAMN YOU!!!",""},
            {"Damn you to HELL!!!",""},
            {"Break him!!!",""},
            {"Take his faith away!",""},
            {"I'll make your death painful!!!",""},
            {"Death will not be your end to TORMENT!!!",""},
            {"Your soul will burn in the HELLS FOREVER!!!",""},
            --{"No time for life! Time for the KNIFE!!!",""},
            --"@!$%# You!!!"
        },

        IdleResponseNeutral={
            {"Hmph.",""},
        },
        Neutral={
            {"Hmph.",""},
        },

        IdleResponsePositive={
            {"It is the case...","Yes"},
            {"It sounds so.","Yes"},
            {"Exactly.","Yes"},
            {"Correct.","Yes"},
            {"It is so.","Yes"},
            {"Yes my liege.",""},
            {"So shall it be done.",""},
            {"That... is the way to HELL.",""},
            {"That is the way to the Void.",""},
            {"It is so.",""},
            {"Precisely.",""},
        },
        Good = {
            {"So shall it be done.",""},
            {"That... is the way to HELL.",""},
            {"That is the way to the Void.",""},
            {"Excellent!",""},
        },
        Yes = {
            {"Precisely...",""},
            {"That... is the way to HELL.",""},
            {"Indeed.",""},
            {"Exactly.",""},
            {"Correct.",""},
            {"So shall it be done.",""},
            {"Yes my liege.",""},
            {"So shall it be done.",""},
            {"That... is the way to HELL.",""},
            {"That is the way to the Void.",""},
            {"It is so.",""},
        },

        BadJoke = {
            {"HAH HAH HAH!!!",""},
        },

        IdleResponseNegative={
            {"No.","No"},
            {"I disagree.","No"},
        },
        No = {
            {"No.",""},
            {"I disagree.",""},
        },

        IdleResponseAngry={
            {"You will believe soon enough!","Insult"},
            {"%&$#@ you!","Insult"},
            {"Curse you!","Insult"},
            {"Damn you!","Insult"},
            {"Go to the Void!","Insult"},
            {"You will believe soon enough!","WhateverMan"},
            {"%&$#@ you!","WhateverMan"},
            {"Curse you!","WhateverMan"},
            {"Damn you!","WhateverMan"},
            {"Go to the Void!","WhateverMan"},
        },
        Kho = {
            {"Kho is indeed the Prince of Darkness.","Yes"},
            {"Praise be to the Dark Lord.","Yes"},
            {"Praise be to the Lord of the Shadow.","Yes"},
        },
        KhoBook = {
            {"I have read the chapters.","Good"},
            {"The Black Book is the way to the Void.","Yes"},
        },
        KhoWill = {
            {"Kho's Will will be made manifest.","Good"},
            {"The Void God will prevail.","Yes"},
        },
        Demon = {
            {"We shall summon them from the hells together.","Good"},
            {"This being of evil has been known to me.","Good"},
            {"The Evil Ones are indeed present...","Good"},
            {"Creatures of Darkness, CONSUME US!!!","Good"},
        },
        Dead = {
            {"The Dead are all playthings for the Hell God.","Good"},
        },
        Good = {
            {"Good",""},
            {"Indeed",""},
        },
        Ritual = {
            {"I will be there, at the ritual.","Good"},
            {"The ritual was successful.","Good"},
        },
        DeadRaise = {
            {"We shall summon them from the hells together.","Good"},
            {"The Damned are indeed raised...","Good"},
        },
        Conquer = {
            {"[$2774]","Good"},
            {"The Dead swelled into our ranks.","Good"},
        },
        Voices = {
            {"Indeed. The demons are speaking",""},
        },
        Death = {
            {"[$2775]","Yes"},
            {"The God of Death is pleased.","Good"},
        },
        Necromancy = {
            {"We shall meet again then.","Yes"},
            {"Indeed, death is but the beginning.","Yes"},
            {"Death is Kho's Will made manifest.","Yes"},
            {"The Passing is known to all...","Yes"},
        },

        IdleSpeech=
        {
            {"Kho has shown us the nature of His corruption.","Kho"},
            {"Have you heard His word?","KhoBook"},
            {"The Prince of the Damned knows all power.","Kho"},
            {"Did the Master reveal his will?","KhoWill"},
            {"Only the Cursed and the Damned know the true path.","Dead"},
            {"I worry not about death. Death is the beginning.","Death"},
        },

        IdleSpeechQuestion = {
            {"Have you done what was asked...","Ritual"},
            {"Whom will you sacrifice now?","Ritual"},
            {"Have you given yourself to the Void today?","KhoWill"},
            {"Has you read the Black Book?","KhoBook"},
            {"Did the enemies of Kho know your sword?","Death"},
            {"What have the voices said to you?","Dead"},
            --{"Have you heard of the next campaign?","Conquer"},
            {"Have you spoken to the Conclave about this?","KhoWill"},
            {"Was the ritual... successful?","Ritual"},
            {"Did you find the daemon you seek?","Demon"},
            {"Have the Damned been raised?","Dead"},
            {"Has the ritual... been consecrated?","Ritual"},
            {"Has you sewn the seeds of corruption?","KhoWill"},
        },

        IdleSpeechConcern={
            {"Are you injured?","Concern"},
            {"Are you hurt?","Concern"},
            {"Your blood has been spilled? What happened?","Concern"},
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"Have you not given yourself to Kho today?","Kho"},
            {"Did you do as I have asked...","Kho"},
            {"You need to make an offering this night...","Ritual"},
            {"Give me your weapon, as I have sinners to torment.","KhoWill"},
            {"We must do a seance, now.","Ritual"},
            {"We need to pray to Him now, must we not?","Yes"},
            {"We must swallow his soul, help me.","Demon"},
            {"Summon this demon with me.","Demon"},
            {"I need your help raising more dead.","Dead"},
        },

        StatementSpeech =  {
            {"Death is the answer! The Void is the ANSWER!","Death"},
            --{"[$2776]","Conquer"},
            {"[$2777]","KhoWill"},
            {"[$2778]","KhoWill"},
            {"[$2779]","Conquer"},
           -- {"The next campaign is near, prepare your wrath.","Conquer"},
            {"[$2780]","Conquer"},
            {"[$2781]","KhoWill"},
            {"Kho is the only true God.","Kho"},
            {"[$2782]","Kho"},
            {"Kho's Sword knows no bounds.",""},
            {"I must make an offering.","Ritual"},
            {"[$2783]","KhoWill"},
            {"It is a glorious thing, death. I wait for it.","Death"},
            {"[$2784]","Voices"},
            {"[$2785]","Kho"},
            {"I shall come back from the dead when I so please.","Necromancy"},
            {"He too, shall be possessed.","Demon"},
            {"[$2786]","Necromancy"},
            {"Perhaps my corpse too will be your servant.","Necromancy"},
            {"[$2787]","Necromancy"},
            {"Let his Evil be known, let His cruelty be known.","KhoWill"},
            {"[$2788]","KhoWill"},
            {"PRAISE BE THE DARK LORD!!!!","Kho"},
            {"It is time for the summoning!!!","Ritual"},
        },

        BoastSpeech = {
            {"I have swallowed many souls!","Brag"},
            {"I have devoted myself to the Prince of the Damned!","Brag"},
            {"I know more of the Void than you!","Brag"},
            {"The Void is clearer to me than you!","Brag"},
            {"[$2789]","Brag"},
            {"I have seen the Void, and been nothing!","Brag"},
            {"I have been dead many times!","Brag"},
        },

        ThreatSpeech = {
            {"I will swallow your soul!","Threat"},
            {"I will raise your bones!","Threat"},
            {"Kho show this one the darkness!","Threat"},
            {"You will be cast into the Void!","Threat"},
            {"I will slay you!","Threat"},
            {"You will die! Then you see the Hells!","Threat"},
        },

        JokeSpeech = {
            {"[$2790]","BadJoke"},
            {"[$2791]","BadJoke"},
            {"[$2792]","BadJoke"},
            {"[$2793]","BadJoke"},
            {"[$2794]","BadJoke"},
            {"A shame the last soul I met knew not of Kho!","KhoWill"},
            {"[$2795]","BadJoke"},
        },

        InsultSpeech = {
            {"Kho laughs at your stupidity!","Insult"},
            {"You'll regret your death!","Insult"},
            {"You earned the right to a painful death!","Insult"},
            {"Eternal torment is what you deserve!!!","Insult"},
            {"You treason against the God of Darkness!","Insult"},
            {"The Dark One hates you!","Insult"},
            {"You blasphemies are countless!","Insult"},
            {"[$2796]","Insult"},
            {"You talk like a wretch!","Insult"},
            {"Damn you, your faith is weak!","Insult"},
            {"You insult Kho!!!","Insult"},
            {"I'll use your bones as a table set!","Insult"},
            {"Your corpse has more value than you!","Insult"},
            {"Kho laughs at your stupidity!","Hmph"},
            {"You'll regret your death!","Hmph"},
            {"You earned the right to a painful death!","Hmph"},
            {"Eternal torment is what you deserve!!!","Hmph"},
            {"You treason against the God of Darkness!","Hmph"},
            {"The Dark One hates you!","Hmph"},
            {"You blasphemies are countless!","Hmph"},
            {"[$2797]","Hmph"},
            {"You talk like a wretch!","Hmph"},
            {"Damn you, your faith is weak!","Hmph"},
            {"You insult Kho!!!","Hmph"},
            {"I'll use your bones as a table set!","Hmph"},
            {"Your corpse has more value than you!","Hmph"},
        },

        GreetingSpeech =
        {
            {"Hello my friend.","Hello"},
        },

        FarewellSpeech =
        {
            {"Till we meet again.","Goodbye"}
        },

        CombatSpeechAngry = {
            {"Prepare to die!",""},
            {"Prepare to be slaughtered!",""},
            {"[$2798]",""},
            {"You will become nothing!",""},
            {"I'll feast on your soul ingrade!",""},
            {"Death will not be your end fool!",""},
            {"I will be the death and rebirth of you!",""},
            {"You insignificant wretch!",""},
            {"I'll harvest your corpse!",""},
            {"You shall learn the true meaning of PAIN!",""},
            {"Die!",""},
        },

        TauntSpeech = {
            {"Don't run! I want your corpse!",""},
            {"You must learn the Will of Kho!",""},
            {"Stop running, you'll ruin your bones!",""},
            --"Screw you!",
            {"I need your soul, fool!",""},
            {"Run, fool!",""},
            {"A glorious victory for the Damned!",""},
        },

        FleeSpeech = {
            {"By Kho, help me!",""},
            {"Aaagh!",""},
            {"Ahhh!",""},
            {"Flee!!",""},
            --"@!$%#&!!!",
        },
    },

    StrangerWorshipper = {
        PraySpeech = {
            {"...Amen","Pray"},
            {"...Prase the Wayun!","Pray"},
            {"...Bless us Wayun...","Pray"},
            {"...Show us the Way...","Pray"},
        },

        InteractSpeech = {
            {"...",""},
        },

        InteractFactionSpeech = {
            {"May the Wayun have you prosper.",""},
            {"Blesses onto you.",""},
            {"Fear no evil, seek no evil.",""},
            {"Know only the stars, not the dead.",""},
            {"Protect yourself from the evils!",""},
            {"Our fate has been foretold.",""},
            {"Our suffering gives us faith.",""},
            {"We await our true fate here.",""},
        },
    },

    OrcSpeech = {
        CombatSpeech = {
            {"Thauea Ukia Uris, Tnutn Ukin Gouuk!"},--THEY DEY ARE, SMASH DEM GOOD
            {"Druutn En' Tuhonp Ukin!"}, --CRUSH AN' STOMP DEM
            {"Rep 'Ukin Upurtha"},--RIP THEM APART
            {"Grishs Vuk Vangul!"},--SMASH DEM GOOD(?)
            {"Wuuz Uku Urrdt, Aouu Et Motha!"},--WEEZ THE ORCS, YOU IS NOT
            {"Litha Ni Utha 'In!"}, --LET ME AT EM
            {"Dnop 'I'n Uup Luukt!"}, --CHOP EM UP LADS
            {"Aouuzi Gunmu Githa Kiutha Ukowm!"},--YOUS GONNA GET BEAT DOWN
            {"Aouu Et Motkn Ta Uku Nukrr!"},--YOU IS NOTHING TO DA MAKER
            {"Aouu Louk Leki Aouu Nuuk Ta Iutha Nuunei!!"},--GREENSKINS, ATTACK
            {"Tnutn 'In Tnutn 'In TNUUUTN 'UKIN!!"},--STOMP EM STOMP EM STOMPEM
            {"Oe Aouu Githa Risuuka Ta Ki Tuhonpuk!!"},--OI YOU, get ready to be stomped
            {"Doni Nrri To E Den Druutn Au Tkuulu!!"},--Come Here so I can crush your skull
            {"Nuurra Uup Enuk Ukei!!"},--Hurry up and die
            {"Ukei Aouu Wiuk Kutuhuruk!!"},--Die you weak bastard
            {"Druutn Thauen!!!"},--Crush them
            --{"No time for life! Time for the KNIFE!!!",""},
            --"@!$%# You!!!"
        },

        IdleResponsePositive={
            {"Ukuthat Wnutha E Wut Tknknga.","Yes"},--DATS WHAT I WAS FINKING
            {"Fegnta Luuk.","Yes"},--RIGHTO LAD
            {"Oe Tkutha Touudt Regntha.","Yes"},--Oi that sounds right
            {"E'z Ugruu.","Yes"},
        },
        Good = {
            {"Ukutha Youudt Gouuk Ta Ni.",""},--Dat sounds good to me
        },

        IdleResponseNeutral={
            {"Nnnn.",   ""}, --Hmmm
            {"Nnnn...", ""},--Hmmm
            {"Regntha.",   ""},--Right
            {"Ukutha Regntha?", ""},--Dat right?
        },

        IdleResponsePositive={
            {"Ukuthat Regntha Luuk.",   "Yes"},--DATS RIGHT LAD
            {"Et Tkutha Regntha?",    "Yes"},--IS DAT RIGHT
            {"Et Ukutha To?",          "Yes"},--Is that so?
        },
        Yes={
            {"Urk.",   "OhOkay"}, --Jibberish, means yes
            {"Uruk...", "OhOkay"}, --Ditto
            {"Urrk.",   "OhOkay"}, --Ditto
        },

        No={
            {"Narak.",   "OhOkay"},--Jibberish, means No
            {"Nurk.",    "OhOkay"},--ditto
        },

        IdleResponseNegative={
            {"E Ukun'tha Fink To.",  "No"},--I don't think so
            {"Nurk Wuu...",            "No"},--NO
        },
        
        IdleResponseAngry={
            {"Oe! Wno Uko Uouu Fink Uouu Uris?","Insult"},--OI! WHO DO YOU FINK YOU ARE?
            {"Wnoz Thaue Keggrr Onu Nrri?","Insult"},--WHOZ THE BIGGER ONE HERE
            {"Wnuutha Ukeuk Uouu Yuu?","Insult"},--WHUT DID YOU SAY
            {"Wnutha? Uouu Wristhadn?","Insult"},--WHAT? YOU WRETCH
            {"Wnutha uko uouu fnk tuhuupeuk?","Insult"},--WHAT DO YOU FINK STUPID
            {"Oe tuhuupeuk, githa u dluui?","Insult"},--OI STUPID, GET A CLUE
        },

        IdleSpeech = { 
            {"Eus gotha ni toni nuunei niutha","Food"},--IYES GOT ME SOME HUMIE MEAT
            {"E fouud toni nuutnrount ourr ukrr","Food"},--I FOUND SOME MUSHROOMS OVER DER
            {"Wnan wi ukonga thaue tuhonpn","Stomping"},--WHEN WE DOING THE STOMPIN
            {"Uket ukuur thautuhs leki grus","Food"},--DIS DEER TASTES LIKE GRASS
            {"Uku nukrr et thaue keggstha kos of ukin ulu","Maker"},--DA MAKER IS THE BIGGEST BOSS OF DEM ALL
            {"Errs uku kos utha","Boss"},--WERES DA BOSS AT
            {"Ukeuk uku kos tuu to","Boss"},--DID DA BOSS SAY SO
            {"W fouud ni toni gouuk uouuk","Food"},--I FOUND ME SOME GOOD FOOD
            {"Wnan wiz gunmu tuu uku nukrr ugun?","Maker"},--WHEN WEZ GONNA SEE DA MAKER AGAIN?
            {"Wnan et thaue nuxtha rueuk","Stomping"},--WHEN IS THE NEXT RAID
            {"Wnan wi gunmu tnutn nurri nuunes?","Stomping"},--WHEN WE GONNA SMASH MORE HUMIES?
            {"Wnrri et uku nuurku nuunes","Stomping"},--WHERE IS DA NEARBY HUMIES
        },

        Food = {
            {"Wnrri et uku nuurku nuunes","Stomping"},--WHERE IS DA NEARBY HUMIES

        },

        Stomping= {
            {"TUHONP, DNOP, DRUUTN, UKSRROU!!!","Stomping"},
            {"Druutn uku nuunes, tuhonp uku goklnt, wepi ouutha uku duulthaetuht!!!","Stomping"},
            {"Tuhonp ukin enuk wepi ukin ouutha!","Stomping"},

        },

        Maker = {
            {"Uku nukrr kmowt kstha","Yes"},--The maker knows best
            {"Ue welu risthauurm, tuut thaue propuedu","Yes"},--He will return, says the prophecy
            {"Uku nukrr et thaue unlu gouuk nuunei","Yes"},--The only good human is the maker
        },

        Boss = {
            {"Yku kos et regntha ourr tkrri uu kmow","OhOkay"},--WHERE IS DA NEARBY HUMIES
        },

        OhOkay = {
            {"On tkutha't regntha",""},
        },

        IdleSpeechQuestion = {
            {"E nrruk thaue kos et gunmu nuki uut novk dunp?","Yes"},--I HERD THE BOSS IS GONNA MAKE US MOVE CAMP??
            {"Et etha rruui uouur u nengu getha?","IdleResponseAngry"},--IS IT TRUE YOUR A MANGY GIT??
            {"Gruum et kstha, untha etha?","Yes"},--GREEN IS BEST, AINT IT??
            {"Wnutha uko uouu wentha, inn?","IdleResponseAngry"},--WHAT DO YOU WANT, EHH??
            {"E gothat ni toni rukketha niutha, wentha toni?","Yes"},--I GOTS ME SOME RABBIT MEAT, WANT SOME??
            {"Wnu ukun'tha uouu go fnuk uut toni wouuk?","No"},--WHY DON'T YOU GO FIND US SOME WOOD??
        },

        IdleSpeechConcern={
            {"Loukt leki tonionu tuhonpuk uouu!","Insult"}, --LOOK WHAT HAPPENED TO YOU
            {"Wnutha uppuumuk ta uouu?","Insult"}, --WHAT HAPPENED TO YOU?
        },
        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"Gevk ni uouur tuhuuf, puumu kou","Insult"},--Give me your stuff, puny boy
            {"Uouu ruust, gevk ni ukutha ukrri","Insult"},--You runt, give me dat dere
            {"E wentha urr loutha fron ukutha nuunei","Insult"},--I want yer loot from dat humie
            {"Genni uu tuhuuf uu guloutha","Insult"},--Gimme ya stuff ya galoot
        },

        StatementSpeech =  {
            {"Tuklut ni uouu kmow wnutha thaeni etha et","No"},--Tells me you know what time it is
            {"Gruum, et thaue kstha",""},--Green is the best
            {"Nuuk uku kstha fouuk tket nurrmnga",""},--Had the best food this morning.
            {"Wnutha uris uu gunmu uko furr tuuppu? Tuni oluk?","Yes"},--What are you going to have for supper, same thing?
            {"Uouu risuuku ta tuhonp enuk druutn?","Yes"},--you ready to stomp and crush
            {"E'n gonga ta ki thaue nuxtha keg kos",""},--I'm goin the be the next big boss
        },

        BoastSpeech = {
            {"E'n keggrr ukan uouu!","Brag"}, --I'm bigger than you
            {"E'n tuhrunmgrr ukan uouu muuk","Brag"},--I'm tougher than you 
            {"Uouu louutu ruust, uouu'ris puumu","Insult"},--You lousy runt, you is puny
        },

        ThreatSpeech = {
            {"E'n gunmu dnop uouu gouuk!","Insult"},
            {"e'n gunmu thauurm uu thau nuutn!","Insult"},
            {"Uouu'ris gunmu ki tlop!","Insult"},
            {"uouu'ris gunmu ki fouuk tanurrrow!","Insult"},
            {"Gunmu tnutn enuk druutn uouu!","Insult"},
            {"E'n gunmu dnop uouu gouuk!","Insult"},
        },

        JokeSpeech = {
            {"Wentha ta ueur u joki? Nuunes.","Joke"},
        },

        InsultSpeech = {
        --[[I'm gonna chop you good
            I'm gonna turn ya ta mush
            You're gonna be slop
            You're gonna be food tomorrow
            Gonna smash and crush you]]
            {"E'n gunmu dnop uouu gouuk!","Insult"},
            {"e'n gunmu thauurm uu thau nuutn!","Insult"},
            {"Uouu'ris gunmu ki tlop!","Insult"},
            {"uouu'ris gunmu ki fouuk tanurrrow!","Insult"},
            {"Gunmu tnutn enuk druutn uouu!","Insult"},
            {"E'n gunmu dnop uouu gouuk!","Insult"},
        },

        GreetingSpeech =
        {
            {"Wnutha't uup uu getha.","Hello"},--What's up ya git
            {"Uluow luuk...","Hello"},--Allow lad
        },

        FarewellSpeech =
        {
            {"Kui usnoli!","Goodbye"},--Bye asshole!
        },

        CombatSpeechAnimal = {
            {"Ukei uu feltku kiutuh",""},
            {"Gunmu dnop enuk iutha uu",""},
            {"Uket tuhuupeuk fnga et gunmu ki iuthaan",""},
            {"Gunmu dnop uket tknga!",""},
        },

        Hmph={
            {"Grrrugkh...",""},
        },

        CombatSpeechAngry = {
            {"Ukei uu ruust!!!",""},
            {"Welu uket fnga ukei ulrisuuku!",""},
            {"GAHHHH!!! Ukei!",""},
        },

        TauntSpeech = {
            {"HAH HAHAHAHAHAH!!!!",""},
        },

        FleeSpeech = {
            {"Wi gothat ta go!",""},--We gots to go
            {"Wdk Ruum!",""},
            {"RUUM!",""},
            --"@!$%#&!!!",
        },
    },

    StrangerWorshipper = {
        PraySpeech = {
            {"...Amen","Pray"},
            {"...Prase the Wayun!","Pray"},
            {"...Bless us Wayun...","Pray"},
            {"...Show us the Way...","Pray"},
        },

        InteractSpeech = {
            {"...",""},
        },

        InteractFactionSpeech = {
            {"May the Wayun have you prosper.",""},
            {"Blesses onto you.",""},
            {"Fear no evil, seek no evil.",""},
            {"Know only the stars, not the dead.",""},
            {"Protect yourself from the evils!",""},
            {"Our fate has been foretold.",""},
            {"Our suffering gives us faith.",""},
            {"We await our true fate here.",""},
        },
    },
    Dancer = {
        IdleSpeech = { 
            {"This club is legit.", "Statement"},
            {"I wonder what they'll play next!","Statement"},
            {"Let's boogie!","Statement"},
        },

        IdleSpeechQuestion = {
            {"You wanna dance?","Dance"},
        },

        --IdleSpeechResponse=
        --{}

        DemandSpeech = {
            {"Do you have any sacred cactus?","Demand"},
        },

        StatementSpeech =  {
            {"This club is legit!","Statement"},
            {"This is awesome!","Statement"},
            {"I gotta come here again!","Statement"},
            {"Woo-hoo!","Statement"},
        },

        BoastSpeech = {
            {"I got more swag than you!","Brag"},
            {"I just bought new shoes!","Brag"},
        },

        GreetingSpeech =
        {
            {"Yo whaddup!","Goodbye"},
            {"Sup dawg!","Goodbye"},
        },
        FarewellSpeech =
        {
            {"Peace.","Goodbye"},
        },
    },    
}