using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using System.Xml;

namespace NosXmlParser
{
    public partial class Form1 : Form
    {
        #region Class Variables
        private string _selectedPath;
        public string selectedPath { get { return _selectedPath; } set { _selectedPath = value; PopulateCheckboxList(); } }
        private string _selectedFile { get; set; }
        public string selectedFile { get { return _selectedFile; } set { _selectedFile = value; } }
        public string selectedFileName { get; set; }
        public List<string> output { get; set; }
        public List<string> UnfoundElements { get; set; }
        #endregion // Class Variables

        public Form1()
        {
            InitializeComponent();

            selectedPath = @"C:\Users\berycs_v2\Desktop\novusredux-master\Build\base\templates\mobiles";
            selectedFile = @"C:\Users\berycs_v2\Desktop\novusredux-master\Build\base\templates\mobiles\horse.xml";

            //selectedPath = @"C:\Users\berycs_v2\Desktop\novusredux-master\mods\NOS\templates\mobiles";
            //selectedFile = @"C:\Users\berycs_v2\Desktop\novusredux-master\mods\NOS\templates\mobiles\horse.xml";
            selectedFileName = @"horse.xml";
            output = new List<string>();
            UnfoundElements = new List<string>();
            tbChosenDirectory.DataBindings.Add("Text", selectedPath, "");
            tbChosenFile.DataBindings.Add("Text", selectedFile, "");
            //rtbOutput.DataBindings.Add("Text", output, "");

            btnParseChosenFile_Click(null, null);
        }

        private void btnChooseFolder_Click(object sender, EventArgs e)
        {
            if(folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                selectedPath = folderBrowserDialog1.SelectedPath;
            }
            else
            {
                selectedPath = "";
            }
        }

        private void btnParseChosenDirectory_Click(object sender, EventArgs e)
        {
            if(cblbDirectoryFiles.Items.Count == 0)
            {
                MessageBox.Show("There are no files selected to parse.");
                return;
            }

            output.Clear();
            UnfoundElements.Clear();

            var filesData = new List<string>();
            foreach(object item in cblbDirectoryFiles.CheckedItems)
            {
                MobileData Mobile = ParseFile(selectedPath + "/" + item, (string)item);
                filesData.Add(Mobile.ToCsv());
                //Debug.WriteLine(item);
            }


            //Debug.WriteLine(reader.Name + " => " + reader.Value);
            //output.Add(reader.Name); // + " => " + reader.Value);
            var stuff = new List<string>();
            stuff.AddRange(output.ToArray<string>());
            stuff.Add("======================================");
            stuff.AddRange(UnfoundElements.ToArray<string>());
            rtbOutput.Lines = stuff.ToArray<string>();

            stuff = new List<string>();
            stuff.Add(MobileData.GetCsvHeader());
            stuff.AddRange(filesData);
            rtbData.Lines = stuff.ToArray<string>();
            //Debug.WriteLine(Mobile);

            //MessageBox.Show("This has not been implemented yet.");
        }

        private void btnChooseFile_Click(object sender, EventArgs e)
        {
            if(openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                selectedFile = openFileDialog1.FileName;
            }
            else
            {
                selectedFile = "";
            }
        }

        private void btnParseChosenFile_Click(object sender, EventArgs e)
        {
            output.Clear();
            UnfoundElements.Clear();

            var Mobile = ParseFile(selectedFile, selectedFileName);

            //Debug.WriteLine(reader.Name + " => " + reader.Value);
            //output.Add(reader.Name); // + " => " + reader.Value);
            var stuff = new List<string>();
            stuff.AddRange(output.ToArray<string>());
            stuff.Add("======================================");
            stuff.AddRange(UnfoundElements.ToArray<string>());
            rtbOutput.Lines = stuff.ToArray<string>();

            rtbData.Text = Mobile.ToString();
            //Debug.WriteLine(Mobile);
        }

        private void btnCheckAll_Click(object sender, EventArgs e)
        {
            for(int i = 0; i < cblbDirectoryFiles.Items.Count; i++)
            {
                cblbDirectoryFiles.SetItemChecked(i, true);
            }
        }

        #region Methods
        private void PopulateCheckboxList()
        {
            if(string.IsNullOrEmpty(selectedPath) )
            {
                cblbDirectoryFiles.Items.Clear();
                return;
            }
            DirectoryInfo d = new DirectoryInfo(selectedPath);
            FileInfo[] Files = d.GetFiles("*.xml");

            foreach (FileInfo file in Files)
            {
                cblbDirectoryFiles.Items.Add(file.Name);
            }
        }

        private bool? ConvertBoolValue(string boolValue)
        {
            if(boolValue == "False" || boolValue == "false")
            {
                return false;
            }
            else if(boolValue == "True" || boolValue == "true")
            {
                return true;
            }
            else
            {
                return null;
            }
        }

        private MobileData ParseFile(string file, string fileName)
        {
            if (!File.Exists(file))
            {
                Debug.WriteLine("There is no Xml document to parse.");
                MessageBox.Show("Either the file selected does not exist, or there is no file selected.  Regardless, it is impossible to parse.");
                return null;
            }

            Debug.WriteLine("Reading Xml document: " + file);


            //XmlDocument doc = new XmlDocument();
            //doc.Load(file);

            //XmlNodeList 

            var Mobile = new MobileData();
            Mobile.FileName = fileName;

            using (XmlReader reader = XmlReader.Create(file))
            {
                while (reader.Read())
                {
                    //XElement x = XElement.Load(reader);
                    //Debug.WriteLine(x);
                    try
                    {


                        if (reader.IsStartElement())
                        {
                            if (reader.NodeType == XmlNodeType.Whitespace)
                            {
                                continue;
                            }

                            switch (reader.Name)
                            {
                                case "ObjectTemplate":
                                    //output.Add(reader.Name);
                                    break;
                                case "ClientId":
                                    //output.Add(reader.Name);
                                    Mobile.ClientId = reader.ReadElementContentAsDouble();
                                    break;
                                case "Color":
                                    Mobile.Color = reader.ReadElementContentAsString();
                                    break;
                                case "Hue":
                                    Mobile.Hue = reader.ReadElementContentAsDouble();
                                    break;
                                case "Name":
                                    //output.Add(reader.Name);
                                    Mobile.Name = reader.ReadElementContentAsString();
                                    break;
                                case "ScaleModifier":
                                    Mobile.ScaleModifier = reader.ReadElementContentAsDouble();
                                    break;
                                case "SharedStateEntry":
                                    //output.Add(reader.Name);

                                    // TODO come back to this.
                                    // BodyOffset
                                    // IsBoss
                                    // Variation

                                    // This is a bundle of grossness

                                    break;
                                case "MobileComponent":
                                    //output.Add(reader.Name);
                                    // Just worried about the innards of this one.
                                    break;
                                case "BaseRunSpeed":
                                    //output.Add(reader.Name);
                                    Mobile.BaseRunSpeed = reader.ReadElementContentAsDouble();
                                    break;
                                case "MobileType":
                                    //output.Add(reader.Name);
                                    Mobile.MobileType = reader.ReadElementContentAsString();
                                    break;
                                case "ObjectVariableComponent":
                                    //output.Add(reader.Name);
                                    // Just worried about the innards of this one.
                                    break;
                                case "StringVariable":
                                    //output.Add(reader.Name);

                                    switch (reader.GetAttribute("Name"))
                                    {
                                        case "MobileTeamType": Mobile.MobileTeamType = reader.ReadElementContentAsString(); break;
                                        case "MobileKind": Mobile.MobileKind = reader.ReadElementContentAsString(); break;
                                        case "MountType": Mobile.MountType = reader.ReadElementContentAsString(); break;
                                        case "AI-WeaponType": Mobile.AI_WeaponType = reader.ReadElementContentAsString(); break;
                                        case "NaturalWeaponType": Mobile.NaturalWeaponType = reader.ReadElementContentAsString(); break;
                                        case "NaturalWeaponName": Mobile.NaturalWeaponName = reader.ReadElementContentAsString(); break;
                                        case "NaturalArmor": Mobile.NaturalArmor = reader.ReadElementContentAsString(); break;
                                        case "AI-SpeechTable": Mobile.AI_SpeechTable = reader.ReadElementContentAsString(); break;
                                        case "MyPath": Mobile.MyPath = reader.ReadElementContentAsString(); break;
                                        case "MonsterAR": Mobile.MonsterAR = reader.ReadElementContentAsString(); break;
                                        case "HomeRegion": Mobile.HomeRegion = reader.ReadElementContentAsString(); break;
                                        case "AutoDestroyVersion": Mobile.AutoDestroyVersion = reader.ReadElementContentAsString(); break;
                                        case "NaturalEnemy": Mobile.NaturalEnemy = reader.ReadElementContentAsString(); break;

                                        default:
                                            UnfoundElements.Add(fileName + ": " + reader.GetAttribute("Name"));
                                            break;
                                    }
                                    break;
                                case "DoubleVariable":
                                    //output.Add(reader.Name);

                                    switch (reader.GetAttribute("Name"))
                                    {
                                        case "BaseHealth": Mobile.BaseHealth = reader.ReadElementContentAsDouble(); break;
                                        case "HostileLevel": Mobile.HostileLevel = reader.ReadElementContentAsDouble(); break;
                                        case "Armor": Mobile.Armor = reader.ReadElementContentAsDouble(); break;
                                        case "Attack": Mobile.Attack = reader.ReadElementContentAsDouble(); break;
                                        case "Power": Mobile.Power = reader.ReadElementContentAsDouble(); break;
                                        case "Karma": Mobile.Karma = reader.ReadElementContentAsDouble(); break;
                                        case "PrestigeXP": Mobile.PrestigeXP = reader.ReadElementContentAsDouble(); break;
                                        case "BardingDifficulty": Mobile.BardingDifficulty = reader.ReadElementContentAsDouble(); break;
                                        case "TamingDifficulty": Mobile.TamingDifficulty = reader.ReadElementContentAsDouble(); break;
                                        case "PetSlots": Mobile.PetSlots = reader.ReadElementContentAsDouble(); break;
                                        case "AI-ChaseRange": Mobile.AI_ChaseRange = reader.ReadElementContentAsDouble(); break;
                                        case "AI-AggroRange": Mobile.AI_AggroRange = reader.ReadElementContentAsDouble(); break;
                                        case "AI-ChargeSpeed": Mobile.AI_ChargeSpeed = reader.ReadElementContentAsDouble(); break;
                                        case "AI-FleeSpeed": Mobile.AI_FleeSpeed = reader.ReadElementContentAsDouble(); break;
                                        case "AI-LeashDistance": Mobile.AI_LeashDistance = reader.ReadElementContentAsDouble(); break;
                                        case "EquipmentDamageOnDeathMultiplier": Mobile.EquipmentDamageOnDeathMultiplier = reader.ReadElementContentAsDouble(); break;
                                        case "FameXP": Mobile.FameXP = reader.ReadElementContentAsDouble(); break;
                                        case "WeaponRange": Mobile.WeaponRange = reader.ReadElementContentAsDouble(); break;
                                        case "DecayTime": Mobile.DecayTime = reader.ReadElementContentAsDouble(); break;
                                        case "NaturalMinDamage": Mobile.NaturalMinDamage = reader.ReadElementContentAsDouble(); break;
                                        case "NaturalMaxDamage": Mobile.NaturalMaxDamage = reader.ReadElementContentAsDouble(); break;
                                        case "SpinAttackRange": Mobile.SpinAttackRange = reader.ReadElementContentAsDouble(); break;
                                        case "Allegiance": Mobile.Allegiance = reader.ReadElementContentAsDouble(); break;
                                        case "BodyOffset": Mobile.BodyOffset2 = reader.ReadElementContentAsDouble(); break;
                                        default:
                                            UnfoundElements.Add(fileName + ": " + reader.GetAttribute("Name"));
                                            break;
                                    }
                                    break;
                                case "BoolVariable":
                                    //output.Add(reader.Name);

                                    switch (reader.GetAttribute("Name"))
                                    {
                                        case "AI-Leash": Mobile.AI_Leash = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-StationedLeash": Mobile.AI_StationedLeash = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-RandomizeScale": Mobile.AI_RandomizeScale = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-CanUseCombatAbilities": Mobile.AI_CanUseCombatAbilities = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-ScaleToAge": Mobile.ScaleToAge = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-CanFlee": Mobile.AI_CanFlee = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "CanFlee": Mobile.CanFlee = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "DoNotEquip": Mobile.DoNotEquip = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "DoesNotBleed": Mobile.DoesNotBleed = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-CanConverse": Mobile.AI_CanConverse = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "noloot": Mobile.noloot = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "ImportantNPC": Mobile.ImportantNPC = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "DoesNotNeedPath": Mobile.DoesNotNeedPath = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "IsGuard": Mobile.IsGuard = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "NoDisrobe": Mobile.NoDisrobe = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "CanBeTamed": Mobile.CanBeTamed = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "CannotBeCaptured": Mobile.CannotBeCaptured = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "HasSkillCap": Mobile.HasSkillCap = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AutoUnstable": Mobile.AutoUnstable = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "shouldPatrol": Mobile.shouldPatrol = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "VisibleToAll": Mobile.VisibleToAll = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "OnlyEquipWeapons": Mobile.OnlyEquipWeapons = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "IsNeutralGuard": Mobile.IsNeutralGuard = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "IsHellHound": Mobile.IsHellHound = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "Invulnerable": Mobile.Invulnerable = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-EnableBank": Mobile.AI_EnableBank = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-EnableTax": Mobile.AI_EnableTax = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-EnableBuy": Mobile.AI_EnableBuy = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-MerchantEnabled": Mobile.AI_MerchantEnabled = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        case "AI-StartConversations": Mobile.AI_StartConversations = ConvertBoolValue(reader.ReadElementContentAsString()); break;
                                        default:
                                            UnfoundElements.Add(fileName + ": " + reader.GetAttribute("Name"));
                                            break;
                                    }
                                    break;
                                case "ScriptEngineComponent":
                                    //output.Add(reader.Name);
                                    // ????????
                                    break;
                                case "LuaModule":
                                    //output.Add(reader.Name);
                                    if (reader.GetAttribute("Name") == "animal_parts")
                                    {
                                        Mobile.Animal_Parts = "exists";
                                        //Debug.WriteLine("animal_parts");
                                        //Debug.WriteLine(reader.ReadElementContentAsString());
                                    }
                                    else if (reader.GetAttribute("Name").Contains("ai_"))
                                    {
                                        Mobile.AI_LuaModule = reader.GetAttribute("Name");
                                        //Debug.WriteLine("ai object");

                                        //Debug.WriteLine(reader.ReadElementContentAsString());
                                    }
                                    else
                                    {
                                        UnfoundElements.Add("LuaModule: " + reader.GetAttribute("Name"));
                                    }
                                    break;
                                case "Initializer":
                                    //output.Add(reader.Name);
                                    var luaTable = reader.ReadElementContentAsString();
                                    var pattern = "[ \t]+";
                                    Debug.WriteLine("==============   1   ===========");
                                    var test = Regex.Replace(luaTable, pattern, "");
                                    pattern = "(\r\n|\r|\n)";
                                    test = Regex.Replace(test, pattern, "");
                                    pattern = @"Stats={(...=(\d|\.)+(,)*)*}";
                                    var stats = Regex.Match(test, pattern);
                                    Debug.WriteLine(stats);
                                    Debug.WriteLine("================================");

                                    if (stats.Success)
                                    {
                                        //Debug.WriteLine(row);
                                        var statsWork = stats.Value.Replace("Stats={", "").Replace("}", "");
                                        var statsWorks = statsWork.Split(',');
                                        foreach (string stat in statsWorks.ToList<string>())
                                        {
                                            var split = stat.Trim().Split('=');
                                            if (split.Count() == 2)
                                            {
                                                //Debug.WriteLine(split[1]);
                                                var value = (double?)double.Parse(split[1].Trim());
                                                //Debug.WriteLine(value);
                                                switch (split[0].Trim())
                                                {
                                                    case "Str": Mobile.AiData.Stats.Str = value; break;
                                                    case "Agi": Mobile.AiData.Stats.Agi = value; break;
                                                    case "Int": Mobile.AiData.Stats.Int = value; break;
                                                    case "Con": Mobile.AiData.Stats.Con = value; break;
                                                    case "Wis": Mobile.AiData.Stats.Wis = value; break;
                                                    case "Wil": Mobile.AiData.Stats.Wil = value; break;
                                                    default:
                                                        UnfoundElements.Add("AI _ STATS _ " + stat);
                                                        break;
                                                }
                                            }
                                        }
                                    }

                                    break;
                                default:
                                    UnfoundElements.Add(fileName + ": " + reader.Name);
                                    break;
                            }



                            //Debug.WriteLine(reader.Name + " => " + reader.Value);
                            //output.Add(reader.Name); // + " => " + reader.Value);
                            //var stuff = new List<string>();
                            //stuff.AddRange(output.ToArray<string>());
                            //stuff.Add("======================================");
                            //stuff.AddRange(UnfoundElements.ToArray<string>());
                            //rtbOutput.Lines = stuff.ToArray<string>();
                        }
                        //Debug.WriteLine(reader.Name + " => " + reader.Value);
                        //Debug.WriteLine(reader.Name);
                    }
                    catch(Exception ex)
                    {
                        UnfoundElements.Add("ERROR: " + fileName);
                        // silently grabe them for now.
                        //Debug.WriteLine(ex);
                    }
                }
            }

            return Mobile;
        }
        #endregion //Methods
    }
}
