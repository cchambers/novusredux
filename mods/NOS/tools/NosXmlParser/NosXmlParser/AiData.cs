using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NosXmlParser
{
    public class AiData
    {
        public StatsData _Stats;
        public StatsData Stats { get; set; }
        public SkillsData Skills { get; set; }
        public LootTablesData LootTables { get; set; }

        public AiData()
        {
            Stats = new StatsData();
            Skills = new SkillsData();
            LootTables = new LootTablesData();
        }

        public override string ToString()
        {
            return "  AiData : " + Environment.NewLine +
                Stats.ToString() + Environment.NewLine +
                Skills.ToString() + Environment.NewLine +
                LootTables.ToString() + Environment.NewLine;
        }

        public string ToCsv()
        {
            return Stats.ToCsv();
            //return Stats.ToCsv() + "," +
            //    Skills.ToCsv() + "," +
            //    LootTables() + "," +
            //    ;
        }

        public static string GetCsvHeader()
        {
            return StatsData.GetCsvHeader();
        }
    }
}
