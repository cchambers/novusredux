using System;
using System.Collections.Generic;

namespace NosXmlParser
{
    public class MobileData
    {
        internal bool? noloot;

        public string FileName { get; set; }
        public double? ClientId { get; set; }
        public string Name { get; set; }
        public double? BodyOffset { get; set; }
        public double? BaseRunSpeed { get; set; }
        public string MobileType { get; set; }
        public double? BaseHealth { get; set; }
        public string MobileTeamType { get; set; }
        public string MobileKind { get; set; }
        public bool? AI_Leash { get; set; }
        public bool? AI_RandomizeScale { get; set; }
        public bool? AI_CanUseCombatAbilities { get; set; }
        public bool? ScaleToAge { get; set; }
        public bool? AI_CanFlee { get; set; }
        public bool? CanFlee { get; set; }
        public double? Armor { get; set; }
        public double? Attack { get; set; }
        public double? BardingDifficulty { get; set; }
        public bool? DoNotEquip { get; set; }
        public double? TamingDifficulty { get; set; }
        public double? PetSlots { get; set; }
        public string MountType { get; set; }
        public string AI_LuaModule { get; set; }
        public string Animal_Parts { get; set; }
        public AiData AiData { get; set; }
        public bool? DoesNotBleed { get; set; }
        public double? AI_AggroRange { get; set; }
        public double? AI_ChaseRange { get; set; }
        public string NaturalArmor { get; set; }
        public bool? AI_CanConverse { get; set; }
        public bool? ImportantNPC { get; set; }
        public double? AI_ChargeSpeed { get; set; }
        public double? AI_FleeSpeed { get; set; }
        public string NaturalWeaponName { get; set; }
        public string NaturalWeaponType { get; set; }
        public bool? AI_StationedLeash { get; set; }
        public double? AI_LeashDistance { get; set; }
        public double? Power { get; set; }
        public double? Karma { get; set; }
        public double? PrestigeXP { get; set; }
        public string AI_SpeechTable { get; set; }
        public string AI_WeaponType { get; set; }
        public string Color { get; set; }
        public bool? DoesNotNeedPath { get; set; }
        public double? EquipmentDamageOnDeathMultiplier { get; set; }
        public double? FameXP { get; set; }
        public double? HostileLevel { get; set; }
        public double? Hue { get; set; }
        public bool? IsGuard { get; set; }
        public double? WeaponRange { get; set; }
        public string MyPath { get; set; }
        public string MonsterAR { get; set; }
        public bool? NoDisrobe { get; set; }
        public double? ScaleModifier { get; set; }
        public bool? CanBeTamed { get; set; }
        public bool? CannotBeCaptured { get; set; }
        public double? DecayTime { get; set; }
        public string HomeRegion { get; set; }
        public bool? HasSkillCap { get; set; }
        public bool? AutoUnstable { get; set; }
        public string AutoDestroyVersion { get; set; }
        public bool? shouldPatrol { get; set; }
        public bool? VisibleToAll { get; set; }
        public bool? OnlyEquipWeapons { get; set; }
        public bool? IsNeutralGuard { get; set; }
        public bool? IsHellHound { get; set; }
        public bool? Invulnerable { get; set; }
        public bool? AI_EnableBank { get; set; }
        public bool? AI_EnableTax { get; set; }
        public bool? AI_EnableBuy { get; set; }
        public bool? AI_MerchantEnabled { get; set; }
        public double? NaturalMaxDamage { get; set; }
        public double? SpinAttackRange { get; set; }
        public double? NaturalMinDamage { get; set; }
        public string NaturalEnemy { get; set; }
        public double? Allegiance { get; set; }
        public double? BodyOffset2 { get; set; }
        public bool? AI_StartConversations { get; set; }

        public MobileData()
        {
            AiData = new AiData();
        }

        public override string ToString()
        {
            return "FileName: " + FileName + Environment.NewLine +
                "ClientId: " + ClientId + Environment.NewLine +
                "Name: " + Name + Environment.NewLine +
                "BodyOffset: " + BodyOffset + Environment.NewLine +
                "BaseRunSpeed: " + BaseRunSpeed + Environment.NewLine +
                "MobileType: " + MobileType + Environment.NewLine +
                "BaseHealth: " + BaseHealth + Environment.NewLine +
                "MobileTeamType: " + MobileTeamType + Environment.NewLine +
                "MobileKind: " + MobileKind + Environment.NewLine +
                "AI_Leash: " + AI_Leash + Environment.NewLine +
                "AI_RandomizeScale: " + AI_RandomizeScale + Environment.NewLine +
                "AI_CanUseCombatAbilities: " + AI_CanUseCombatAbilities + Environment.NewLine +
                "ScaleToAge: " + ScaleToAge + Environment.NewLine +
                "CanFlee: " + AI_CanFlee + Environment.NewLine +
                "CanFlee: " + CanFlee + Environment.NewLine +
                "Armor: " + Armor + Environment.NewLine +
                "Attack: " + Attack + Environment.NewLine +
                "BardingDifficulty: " + BardingDifficulty + Environment.NewLine +
                "DoNotEquip: " + DoNotEquip + Environment.NewLine +
                "TamingDifficulty: " + TamingDifficulty + Environment.NewLine +
                "PetSlots: " + PetSlots + Environment.NewLine +
                "MountType: " + MountType + Environment.NewLine +
                "AI_LuaModule: " + AI_LuaModule + Environment.NewLine +
                "Animal_Parts: " + Animal_Parts + Environment.NewLine +
                "DoesNotBleed: " + DoesNotBleed + Environment.NewLine +
                "AI-AggroRange: " + AI_AggroRange + Environment.NewLine +
                "AI-Chaserange: " + AI_ChaseRange + Environment.NewLine +
                "NaturalArmor: " + NaturalArmor + Environment.NewLine +
                "AI-CanConverse: " + AI_CanConverse + Environment.NewLine +
                "ImportantNPC: " + ImportantNPC + Environment.NewLine +
                "AI-ChargeSpeed: " + AI_ChargeSpeed + Environment.NewLine +
                "AI-FleeSpeed: " + AI_FleeSpeed + Environment.NewLine +
                "NaturalWeaponName: " + NaturalWeaponName + Environment.NewLine +
                "NaturalWeaponType: " + NaturalWeaponType + Environment.NewLine +
                "AI-StationedLeash: " + AI_StationedLeash + Environment.NewLine +
                "AI-LeashDistance: " + AI_LeashDistance + Environment.NewLine +
                "Power: " + Power + Environment.NewLine +
                "Karma: " + Karma + Environment.NewLine +
                "PrestigeXP: " + PrestigeXP + Environment.NewLine +
                "AI-SpeechTable: " + AI_SpeechTable + Environment.NewLine +
                "AI-WeaponType: " + AI_WeaponType + Environment.NewLine +
                "Color: " + Color + Environment.NewLine +
                "DoesNotNeedPath: " + DoesNotNeedPath + Environment.NewLine +
                "EquipmentDamageOnDeathMultiplier: " + EquipmentDamageOnDeathMultiplier + Environment.NewLine +
                "FameXP: " + FameXP + Environment.NewLine +
                "HostileLevel: " + HostileLevel + Environment.NewLine +
                "Hue: " + Hue + Environment.NewLine +
                "IsGuard: " + IsGuard + Environment.NewLine +
                "WeaponRange: " + WeaponRange + Environment.NewLine +
                "MyPath: " + MyPath + Environment.NewLine +
                "MonsterAR: " + MonsterAR + Environment.NewLine +
                "NoDisrobe: " + NoDisrobe + Environment.NewLine +
                "ScaleModifier: " + ScaleModifier + Environment.NewLine +
                "CanBeTamed: " + CanBeTamed + Environment.NewLine +
                "CannotBeCaptured: " + CannotBeCaptured + Environment.NewLine +
                "DecayTime: " + DecayTime + Environment.NewLine +
                "HomeRegion: " + HomeRegion + Environment.NewLine +
                "HasSkillCap: " + HasSkillCap + Environment.NewLine +
                "AutoUnstable: " + AutoUnstable + Environment.NewLine +
                "AutoDestroyVersion: " + AutoDestroyVersion + Environment.NewLine +
                "shouldPatrol" + shouldPatrol + Environment.NewLine +
                "VisibleToAll" + VisibleToAll + Environment.NewLine +
                "OnlyEquipWeapons" + OnlyEquipWeapons + Environment.NewLine +
                "IsNeutralGuard" + IsNeutralGuard + Environment.NewLine +
                "IsHellHound" + IsHellHound + Environment.NewLine +
                "Invulnerable" + Invulnerable + Environment.NewLine +
                "AI_EnableBank" + AI_EnableBank + Environment.NewLine +
                "AI_EnableTax" + AI_EnableTax + Environment.NewLine +
                "AI_EnableBuy" + AI_EnableBuy + Environment.NewLine +
                "AI_MerchantEnabled" + AI_MerchantEnabled + Environment.NewLine +
                "NaturalMaxDamage" + NaturalMaxDamage + Environment.NewLine +
                "SpinAttackRange" + SpinAttackRange + Environment.NewLine +
                "NaturalMinDamage" + NaturalMinDamage + Environment.NewLine +
                "NaturalEnemy" + NaturalEnemy + Environment.NewLine +
                "Allegiance" + Allegiance + Environment.NewLine +
                "BodyOffset2" + BodyOffset2 + Environment.NewLine +
                "AI_StartConversations" + AI_StartConversations + Environment.NewLine +
                AiData.ToString() + Environment.NewLine +
                "";
        }

        public static string GetCsvHeader()
        {
            return "FileName" + "," +
                "ClientId" + "," +
                "Name" + "," +
                "BodyOffset" + "," +
                "BaseRunSpeed" + "," +
                "MobileType" + "," +
                "BaseHealth" + "," +
                "MobileTeamType" + "," +
                "MobileKind" + "," +
                "AI-Leash" + "," +
                "AI-RandomizeScale" + "," +
                "AI-CanUseCombatAbilities" + "," +
                "ScaleToAge" + "," +
                "AI-CanFlee" + ", " +
                "CanFlee" + "," +
                "Armor" + "," +
                "Attack" + "," +
                "BardingDifficulty" + "," +
                "DoNotEquip" + "," +
                "TamingDifficulty" + "," +
                "PetSlots" + "," +
                "MountType" + "," +
                "AI-LuaModule" + "," +
                "DoesNotBleed" + "," +
                "AI-AggroRange" + "," +
                "AI-ChaseRange" + "," +
                "NaturalArmor" + "," +
                "AI-CanConverse" + "," +
                "ImportantNPC" + "," +
                "AI-ChargeSpeed" + "," +
                "AI-FleeSpeed" + "," +
                "NaturalWeaponName" + "," +
                "NaturalWeaponType" + "," +
                " AI-StationedLeash" + "," +
                "AI-LeashDistance" + "," +
                "Power" + "," +
                "Karma" + "," +
                "PrestigeXP" + "," +
                "AI-SpeechTable" + "," +
                "AI-WeaponType" + "," +
                "Color" + "," +
                "DoesNotNeedPath" + "," +
                "EquipmentDamageOnDeathMultiplier" + "," +
                "FameXP" + "," +
                "HostileLevel" + "," +
                "Hue" + "," +
                "IsGuard" + "," +
                "WeaponRange" + "," +
                "MyPath" + "," +
                "MonsterAR" + "," +
                "NoDisrobe" + "," +
                "ScaleModifier" + "," +
                "CanBeTamed" + "," +
                "CannotBeCaptured" + "," +
                "DecayTime" + "," +
                "HomeRegion" + "," +
                "HasSkillCap" + "," +
                "AutoUnstable" + "," +
                "AutoDestroyVersion" + "," +
                "shouldPatrol" + "," +
                "VisibleToAll" + "," +
                "OnlyEquipWeapons" + "," +
                "IsNeutralGuard" + "," +
                "IsHellHound" + "," +
                "Invulnerable" + "," +
                "AI_EnableBank" + "," +
                "AI_EnableTax" + "," +
                "AI_EnableBuy" + "," +
                "AI_MerchantEnabled" + "," +
                "NaturalMaxDamage" + "," +
                "SpinAttackRange" + "," +
                "NaturalMinDamage" + "," +
                "NaturalEnemy" + "," +
                "Allegiance" + "," +
                "BodyOffset2" + "," +
                "AI_StartConversations" + "," +
                AiData.GetCsvHeader();
        }

        public string ToCsv()
        {
            return FileName + "," +
                ClientId + "," +
                Name + "," +
                BodyOffset + "," +
                BaseRunSpeed + "," +
                MobileType + "," +
                BaseHealth + "," +
                MobileTeamType + "," +
                MobileKind + "," +
                AI_Leash + "," +
                AI_RandomizeScale + "," +
                AI_CanUseCombatAbilities + "," +
                ScaleToAge + "," +
                AI_CanFlee + "," +
                CanFlee + ", " +
                Armor + "," +
                Attack + "," +
                BardingDifficulty + "," +
                DoNotEquip + "," +
                TamingDifficulty + "," +
                PetSlots + "," +
                MountType + "," +
                AI_LuaModule + "," +
                DoesNotBleed + "," +
                AI_AggroRange + "," +
                AI_ChaseRange + "," +
                NaturalArmor + "," +
                AI_CanConverse + "," +
                ImportantNPC + "," +
                AI_ChargeSpeed + "," +
                AI_FleeSpeed + "," +
                NaturalWeaponName + "," +
                NaturalWeaponType + "," +
                AI_StationedLeash + "," +
                AI_LeashDistance + "," +
                Power + "," +
                Karma + "," +
                PrestigeXP + "," +
                AI_SpeechTable + "," +
                AI_WeaponType + "," +
                Color + "," +
                DoesNotNeedPath + "," +
                EquipmentDamageOnDeathMultiplier + "," +
                FameXP + "," +
                HostileLevel + "," +
                Hue + "," +
                IsGuard + "," +
                WeaponRange + "," +
                MyPath + "," +
                MonsterAR + "," +
                NoDisrobe + "," +
                ScaleModifier + "," +
                CanBeTamed + "," +
                CannotBeCaptured + "," + 
                DecayTime + "," +
                HomeRegion + "," +
                HasSkillCap + "," +
                AutoUnstable + "," +
                AutoDestroyVersion + "," +
                shouldPatrol + "," +
                VisibleToAll + "," +
                OnlyEquipWeapons + "," +
                IsNeutralGuard + "," +
                IsHellHound + "," +
                Invulnerable + "," +
                AI_EnableBank + "," +
                AI_EnableTax + "," +
                AI_EnableBuy + "," +
                AI_MerchantEnabled + "," +
                NaturalMaxDamage + "," +
                SpinAttackRange + "," +
                NaturalMinDamage + "," +
                NaturalEnemy + "," +
                Allegiance + "," +
                BodyOffset2 + "," +
                AI_StartConversations + "," +
                AiData.ToCsv();
            //"Animal_Parts: " + Animal_Parts;
        }
    }
}
