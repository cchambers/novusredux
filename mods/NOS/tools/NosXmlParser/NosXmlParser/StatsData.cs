using System;

namespace NosXmlParser
{
    public class StatsData
    {
        public double? Str { get; set; }
        public double? Agi { get; set; }
        public double? Int { get; set; }
        public double? Con { get; set; }
        public double? Wis { get; set; }
        public double? Wil { get; set; }

        public override string ToString()
        {
            return "    Stats: Str: " + Str.ToString() + Environment.NewLine +
                "    Stats: Agi: " + Agi.ToString() + Environment.NewLine +
                "    Stats: Int: " + Int.ToString() + Environment.NewLine +
                "    Stats: Con: " + Con.ToString() + Environment.NewLine +
                "    Stats: Wis: " + Wis.ToString() + Environment.NewLine +
                "    Stats: Wil: " + Wil.ToString() + Environment.NewLine;
        }

        public string ToCsv()
        {
            return Str + "," +
                Agi + "," +
                Int + "," +
                Con + "," +
                Wis + "," +
                Wil;
        }

        public static string GetCsvHeader()
        {
            return "Str" + "," +
                "Agi" + "," +
                "Int" + "," +
                "Con" + "," +
                "Wis" + "," +
                "Wil";
        }
    }
}