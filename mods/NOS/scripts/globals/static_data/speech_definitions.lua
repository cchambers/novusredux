-- NOTE: THESE ARE GLOBAL CONSTANTS AND STATIC TABLES: DO NOT EDIT IN SCRIPTS
--
-- Speech Definitions
-- 
-- A list of all lookups to create natural speech based on numerics or code

SPEECH_CARDINAL_MAX = 1000000000

StaticSpeechCardinals = {
	[0] = "zero",
	[1] = "one",
	[2] = "two",
	[3] = "three",
	[4] = "four",
	[5] = "five",
	[6] = "six",
	[7] = "seven",
	[8] = "eight",
	[9] = "nine",
	[10] = "ten",
	[11] = "eleven",
	[12] = "twelve",
	[13] = "thirteen",
	[14] = "fourteen",
	[15] = "fifteen",
	[16] = "sixteen",
	[17] = "seventeen",
	[18] = "eighteen",
	[19] = "nineteen",
	[20] = "twenty",
	[30] = "thirty",
	[40] = "forty",
	[50] = "fifty",
	[60] = "sixty",
	[70] = "seventy",
	[80] = "eighty",
	[90] = "ninety",
	[100] = "hundred",
	[1000] = "thousand",
	[1000000] = "million",
	[1000000000] = "billion"
}