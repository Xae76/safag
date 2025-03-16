optStruct()
{
    self iPrintln("Populating menu options");
    self.HeaderArray = strTok("emblem_bg_ben;emblem_bg_ghost;emblem_bg_roxann_soldier;emblem_bg_seasonpass", ";");
    self.fov_array = strTok("65;80;90;100;110;120", ";");
    self.prestiges = strTok("1;2;3;4;5;6;7;8;9;10;11;12;13;14;15", ";");
    i = 0;
    while(i < self.prestiges.size)
    {
        self.prestiges[i] = int(self.prestiges[i]);
        i++;
    }
    
    self.bool_true = 1;
    self.bool_false = 0;
    
    // Main Menu
    self addMenu("main", "Main Menu", "Exit");
    self addSubmenu("main", 0, "Self Menu", "Customize ^3" + self.name + "^7", ::_loadMenu, "menu_self");
    self addSubmenu("main", 1, "Game Menu", self isHost() ? "Modify game settings" : "^1You do not have access to this menu^7", ::_loadMenu, "menu_lobby");
    self addSubmenu("main", 2, "Afterhit Menu", "Afterhit settings", ::_loadMenu, "menu_afterhit");
    self addSubmenu("main", 3, "Akimbo Menu", "Akimbo glitch guns", ::_loadMenu, "menu_akimbo");
    self addSubmenu("main", 4, "Binds Menu", "Binds menu", ::_loadMenu, "menu_binds");
    self addSubmenu("main", 6, "Vision Menu", "Change game vision", ::_loadMenu, "menu_vision");
    self addSubmenu("main", 5, "Aimbot Menu", "Aimbot settings", ::_loadMenu, "menu_aimbot");
    self addSubmenu("main", 6, "Host Menu", "Host Settings", ::_loadMenu, "menu_host");
    self addSubmenu("main", 7, "^1Developer Menu^7", "Dev options", ::_loadMenu, "menu_dev");

    // Self Menu
    self addMenu("menu_self","Self Menu", "Self Menu", "main");
    self addOpt("menu_self", 0, "Set Spawn^3*^7", "Set your spawnpoint to where you are", ::spawn_set);
    self addOpt("menu_self", 1, "Load Spawn^3*^7", "Load your spawnpoint without dying", ::spawn_load);
    self addOpt("menu_self", 2, "Clear Spawn^3*^7", "Remove your spawnpoint", ::spawn_clear);
    self addOpt("menu_self", 3, "Give Single Bullet", "Set clip to have only one bullet", ::give_single_ammo);
    self addOpt("menu_self", 4, "Drop Current Weapon", "Drop weapon for canswap", ::drop_weapon);
    self addOpt("menu_self", 5, "Drop Random Weapon", "Drop random weapon for canswap", ::drop_random_weapon);
    self addOpt("menu_self", 6, "Suicide", "Kill yourself (in the game of course)", ::kill);
    self addBoolean("menu_self", 7, "Silent Shot", "Makes your gun silent for last trickshot", self.bool_false, ::silent_shot);
    self addOpt("menu_self", 8, "Infinite Equipment", "Toggle Infinite Equipment", ::toggleinfequipment);
    


    // Game Menu
    self addMenu("menu_lobby", "Game Menu", "main");
    self addOpt("menu_lobby", 0, "Add Bots", "Fill game with Bots", ::addtestclients);
    self addOpt("menu_lobby", 1, "Remove Bot", "Kick a Bot from the game", ::removetestclient);
    self addOpt("menu_lobby", 2, "No Clip", "Toggle No Clip", ::noclip);
   self addOpt("menu_self", 3, "Skulls", "Toggle Skulls", ::toggleskull);
    self addOpt("menu_lobby", 4, "Floater", "Floaters", ::disablefloaters);
    self addBoolean("menu_lobby", 5, "Smooth Animations", "Enable smooth animations", self.smooth_anims_enabled, ::smooth_anims);
    self addOpt("menu_lobby", 6, "Random Prestige", "Random Prestige Level 55", ::randomprestige);

    // Afterhit Menu
    self addMenu("menu_afterhit", "Afterhit Menu", "main");
    self addOpt("menu_afterhit", 0, "Remove Afterhit", "Remove Afterhit", ::set_afterhit, "none");
    self addSubmenu("menu_afterhit", 1, "Assault Rifles", "Assault Rifles submenu", ::_loadMenu, "ARsAH");
    self addSubmenu("menu_afterhit", 2, "Submachine Guns", "Submachine Guns submenu", ::_loadMenu, "SMGsAH");
    self addSubmenu("menu_afterhit", 3, "Shotguns", "Shotguns submenu", ::_loadMenu, "ShotgunsAH");
    self addSubmenu("menu_afterhit", 4, "Light Machine Guns", "Light Machine Guns submenu", ::_loadMenu, "LMGsAH");
    self addSubmenu("menu_afterhit", 5, "Sniper Rifles", "Sniper Rifles submenu", ::_loadMenu, "SnipersAH");
    self addSubmenu("menu_afterhit", 6, "Pistols", "Pistols submenu", ::_loadMenu, "PistolsAH");
    self addSubmenu("menu_afterhit", 7, "Launchers", "Launchers submenu", ::_loadMenu, "LaunchersAH");
    self addSubmenu("menu_afterhit", 8, "Specials", "Specials submenu", ::_loadMenu, "SpecialsAH");

    // Afterhit Submenus
    self addMenu("ARsAH", "Assault Rifles", "menu_afterhit");
    self addOpt("ARsAH", 0, "MTAR", "Set MTAR as afterhit", ::set_afterhit, "tar21_mp");
    self addOpt("ARsAH", 1, "Type 25", "Set Type 25 as afterhit", ::set_afterhit, "type95_mp");
    self addOpt("ARsAH", 2, "SWAT-556", "Set SWAT-556 as afterhit", ::set_afterhit, "sig556_mp");
    self addOpt("ARsAH", 3, "FAL OSW", "Set FAL OSW as afterhit", ::set_afterhit, "sa58_mp");
    self addOpt("ARsAH", 4, "M27", "Set M27 as afterhit", ::set_afterhit, "hk416_mp");
    self addOpt("ARsAH", 5, "SCAR-H", "Set SCAR-H as afterhit", ::set_afterhit, "scar_mp");
    self addOpt("ARsAH", 6, "SMR", "Set SMR as afterhit", ::set_afterhit, "saritch_mp");
    self addOpt("ARsAH", 7, "M8A1", "Set M8A1 as afterhit", ::set_afterhit, "xm8_mp");
    self addOpt("ARsAH", 8, "AN-94", "Set AN-94 as afterhit", ::set_afterhit, "an94_mp");

    self addMenu("SMGsAH", "Submachine Guns", "menu_afterhit");
    self addOpt("SMGsAH", 0, "MP7", "Set MP7 as afterhit", ::set_afterhit, "mp7_mp");
    self addOpt("SMGsAH", 1, "PDW-57", "Set PDW-57 as afterhit", ::set_afterhit, "pdw57_mp");
    self addOpt("SMGsAH", 2, "Vector K10", "Set Vector K10 as afterhit", ::set_afterhit, "vector_mp");
    self addOpt("SMGsAH", 3, "MSMC", "Set MSMC as afterhit", ::set_afterhit, "insas_mp");
    self addOpt("SMGsAH", 4, "Chicom CQB", "Set Chicom CQB as afterhit", ::set_afterhit, "qcw05_mp");
    self addOpt("SMGsAH", 5, "Skorpion EVO", "Set Skorpion EVO as afterhit", ::set_afterhit, "evoskorpion_mp");
    self addOpt("SMGsAH", 6, "Peacekeeper", "Set Peacekeeper as afterhit", ::set_afterhit, "peacekeeper_mp");

    self addMenu("ShotgunsAH", "Shotguns", "menu_afterhit");
    self addOpt("ShotgunsAH", 0, "R870 MCS", "Set R870 MCS as afterhit", ::set_afterhit, "870mcs_mp");
    self addOpt("ShotgunsAH", 1, "S12", "Set S12 as afterhit", ::set_afterhit, "saiga12_mp");
    self addOpt("ShotgunsAH", 2, "KSG", "Set KSG as afterhit", ::set_afterhit, "ksg_mp");
    self addOpt("ShotgunsAH", 3, "M1216", "Set M1216 as afterhit", ::set_afterhit, "srm1216_mp");

    self addMenu("LMGsAH", "Light Machine Guns", "menu_afterhit");
    self addOpt("LMGsAH", 0, "Mk 48", "Set Mk 48 as afterhit", ::set_afterhit, "mk48_mp");
    self addOpt("LMGsAH", 1, "QBB LSW", "Set QBB LSW as afterhit", ::set_afterhit, "qbb95_mp");
    self addOpt("LMGsAH", 2, "LSAT", "Set LSAT as afterhit", ::set_afterhit, "lsat_mp");
    self addOpt("LMGsAH", 3, "HAMR", "Set HAMR as afterhit", ::set_afterhit, "hamr_mp");

    self addMenu("SnipersAH", "Sniper Rifles", "menu_afterhit");
    self addOpt("SnipersAH", 0, "SVU-AS", "Set SVU-AS as afterhit", ::set_afterhit, "svu_mp");
    self addOpt("SnipersAH", 1, "DSR 50", "Set DSR 50 as afterhit", ::set_afterhit, "dsr50_mp");
    self addOpt("SnipersAH", 2, "Ballista", "Set Ballista as afterhit", ::set_afterhit, "ballista_mp");
    self addOpt("SnipersAH", 3, "XPR-50", "Set XPR-50 as afterhit", ::set_afterhit, "as50_mp");

    self addMenu("PistolsAH", "Pistols", "menu_afterhit");
    self addOpt("PistolsAH", 0, "Five-seven", "Set Five-seven as afterhit", ::set_afterhit, "fiveseven_mp");
    self addOpt("PistolsAH", 1, "Tac-45", "Set Tac-45 as afterhit", ::set_afterhit, "fnp45_mp");
    self addOpt("PistolsAH", 2, "B23R", "Set B23R as afterhit", ::set_afterhit, "beretta93r_mp");
    self addOpt("PistolsAH", 3, "Executioner", "Set Executioner as afterhit", ::set_afterhit, "judge_mp");
    self addOpt("PistolsAH", 4, "Kap-40", "Set Kap-40 as afterhit", ::set_afterhit, "kard_mp");

    self addMenu("LaunchersAH", "Launchers", "menu_afterhit");
    self addOpt("LaunchersAH", 0, "SMAW", "Set SMAW as afterhit", ::set_afterhit, "smaw_mp");
    self addOpt("LaunchersAH", 1, "FHJ-18 AA", "Set FHJ-18 AA as afterhit", ::set_afterhit, "fhj18_mp");
    self addOpt("LaunchersAH", 2, "RPG", "Set RPG as afterhit", ::set_afterhit, "usrpg_mp");

    self addMenu("SpecialsAH", "Specials", "menu_afterhit");
    self addOpt("SpecialsAH", 0, "Crossbow", "Set Crossbow as afterhit", ::set_afterhit, "crossbow_mp");
    self addOpt("SpecialsAH", 1, "Ballistic Knife", "Set Ballistic Knife as afterhit", ::set_afterhit, "knife_ballistic_mp");
    self addOpt("SpecialsAH", 2, "Assault Shield", "Set Assault Shield as afterhit", ::set_afterhit, "riotshield_mp");
    self addOpt("SpecialsAH", 3, "Bomb", "Set Bomb as afterhit", ::set_afterhit, "briefcase_bomb_mp");
    self addOpt("SpecialsAH", 4, "Knife", "Set Knife as afterhit", ::set_afterhit, "knife_held_mp");
    self addOpt("SpecialsAH", 5, "IPAD", "Set IPAD as afterhit", ::set_afterhit, "killstreak_remote_turret_mp");
    self addOpt("SpecialsAH", 6, "CSGO Knife", "Set CSGO Knife as afterhit", ::set_afterhit, "knife_mp");
    self addOpt("SpecialsAH", 7, "War Machine", "Set War Machine as afterhit", ::set_afterhit, "m32_mp");
    self addOpt("SpecialsAH", 8, "Death Machine", "Set Death Machine as afterhit", ::set_afterhit, "minigun_mp");
    self addOpt("SpecialsAH", 9, "Claymore Rmala", "Set Claymore Rmala as afterhit", ::set_afterhit, "claymore_mp");
    self addOpt("SpecialsAH", 10, "Black Hat Rmala", "Set Black Hat Rmala as afterhit", ::set_afterhit, "pda_hack_mp");
    self addBoolean("SpecialsAH", 11, "Prone Afterhit", "Auto prone after you hit", self.pers["PAfterhit"], ::pafterhit);

    // Akimbo Menu
    self addMenu("menu_akimbo", "Akimbo Menu", "main");
    self addOpt("menu_akimbo", 0, "Give Five Seven", "Give glitched akimbo Five Seven", ::give_akimbo_weapon, "fiveseven_lh_mp", "Five Seven Dual Wield");
    self addOpt("menu_akimbo", 1, "Give Tac-45", "Give glitched akimbo Tac-45", ::give_akimbo_weapon, "fnp45_lh_mp", "Tac-45 Dual Wield");
    self addOpt("menu_akimbo", 2, "Give B23R", "Give glitched akimbo B23R", ::give_akimbo_weapon, "beretta93r_lh_mp", "B23R Dual Wield");
    self addOpt("menu_akimbo", 3, "Give Executioner", "Give glitched akimbo Executioner", ::give_akimbo_weapon, "judge_lh_mp", "Executioner Dual Wield");
    self addOpt("menu_akimbo", 4, "Give KAP-40", "Give glitched akimbo KAP-40", ::give_akimbo_weapon, "kard_lh_mp", "KAP-40 Dual Wield");
    self addOpt("menu_akimbo", 5, "Make Current Pistol Glitched", "Glitch yo shit", ::MakePistolDualWeildG);

    // Binds Menu
    self addMenu("menu_binds", "Binds Menu", "main");
    self addSubmenu("menu_binds", 0, "[{+actionslot 1}] UP DPAD", "Up D-Pad binds", ::_loadMenu, "up_bind");
    self addSubmenu("menu_binds", 1, "[{+actionslot 2}] DOWN DPAD", "Down D-Pad binds", ::_loadMenu, "down_bind");
    self addSubmenu("menu_binds", 2, "[{+actionslot 3}] RIGHT DPAD", "Right D-Pad binds", ::_loadMenu, "right_bind");
    self addSubmenu("menu_binds", 3, "[{+actionslot 4}] LEFT DPAD", "Left D-Pad binds", ::_loadMenu, "left_bind");
    self addSubmenu("menu_binds", 4, "[{+smoke}] Tactical", "Tactical binds", ::_loadMenu, "tac_bind");
    self addSubmenu("menu_binds", 5, "[{+frag}] Lethal", "Lethal binds", ::_loadMenu, "leth_bind");

    self addMenu("up_bind", "[{+actionslot 1}] Up Dpad", "menu_binds");
    self addOpt("up_bind", 0, "REMOVE BIND", "Clear bind", ::set_bind, "Up", 0);
    self addOpt("up_bind", 1, "CLASS CHANGE", undefined, ::set_bind, "Up", 1);
    self addOpt("up_bind", 2, "THIRDEYE", undefined, ::set_bind, "Up", 2);
    self addOpt("up_bind", 3, "CLIP TO 1", undefined, ::set_bind, "Up", 3);
    self addOpt("up_bind", 4, "CANZOOM", undefined, ::set_bind, "Up", 4);
    self addOpt("up_bind", 5, "ZOOMLOAD", undefined, ::set_bind, "Up", 5);
    self addOpt("up_bind", 6, "CANSWAP", undefined, ::set_bind, "Up", 6);
    self addOpt("up_bind", 7, "EMPTYCLIP", undefined, ::set_bind, "Up", 7);
    self addOpt("up_bind", 8, "HITMARKER", undefined, ::set_bind, "Up", 8);

    self addMenu("down_bind", "[{+actionslot 2}] Down Dpad", "menu_binds");
    self addOpt("down_bind", 0, "REMOVE BIND", "Clear bind", ::set_bind, "Down", 0);
    self addOpt("down_bind", 1, "CLASS CHANGE", undefined, ::set_bind, "Down", 1);
    self addOpt("down_bind", 2, "THIRDEYE", undefined, ::set_bind, "Down", 2);
    self addOpt("down_bind", 3, "CLIP TO 1", undefined, ::set_bind, "Down", 3);
    self addOpt("down_bind", 4, "CANZOOM", undefined, ::set_bind, "Down", 4);
    self addOpt("down_bind", 5, "ZOOMLOAD", undefined, ::set_bind, "Down", 5);
    self addOpt("down_bind", 6, "CANSWAP", undefined, ::set_bind, "Down", 6);
    self addOpt("down_bind", 7, "EMPTYCLIP", undefined, ::set_bind, "Down", 7);
    self addOpt("down_bind", 8, "HITMARKER", undefined, ::set_bind, "Down", 8);

    self addMenu("right_bind", "[{+actionslot 3}] Right Dpad", "menu_binds");
    self addOpt("right_bind", 0, "REMOVE BIND", "Clear bind", ::set_bind, "Right", 0);
    self addOpt("right_bind", 1, "CLASS CHANGE", undefined, ::set_bind, "Right", 1);
    self addOpt("right_bind", 2, "THIRDEYE", undefined, ::set_bind, "Right", 2);
    self addOpt("right_bind", 3, "CLIP TO 1", undefined, ::set_bind, "Right", 3);
    self addOpt("right_bind", 4, "CANZOOM", undefined, ::set_bind, "Right", 4);
    self addOpt("right_bind", 5, "ZOOMLOAD", undefined, ::set_bind, "Right", 5);
    self addOpt("right_bind", 6, "CANSWAP", undefined, ::set_bind, "Right", 6);
    self addOpt("right_bind", 7, "EMPTYCLIP", undefined, ::set_bind, "Right", 7);
    self addOpt("right_bind", 8, "HITMARKER", undefined, ::set_bind, "Right", 8);

    self addMenu("left_bind", "[{+actionslot 4}] Left Dpad", "menu_binds");
    self addOpt("left_bind", 0, "REMOVE BIND", "Clear bind", ::set_bind, "Left", 0);
    self addOpt("left_bind", 1, "CLASS CHANGE", undefined, ::set_bind, "Left", 1);
    self addOpt("left_bind", 2, "THIRDEYE", undefined, ::set_bind, "Left", 2);
    self addOpt("left_bind", 3, "CLIP TO 1", undefined, ::set_bind, "Left", 3);
    self addOpt("left_bind", 4, "CANZOOM", undefined, ::set_bind, "Left", 4);
    self addOpt("left_bind", 5, "ZOOMLOAD", undefined, ::set_bind, "Left", 5);
    self addOpt("left_bind", 6, "CANSWAP", undefined, ::set_bind, "Left", 6);
    self addOpt("left_bind", 7, "EMPTYCLIP", undefined, ::set_bind, "Left", 7);
    self addOpt("left_bind", 8, "HITMARKER", undefined, ::set_bind, "Left", 8);

    self addMenu("tac_bind", "[{+smoke}] Tactical", "menu_binds");
    self addOpt("tac_bind", 0, "REMOVE BIND", undefined, ::set_bind, "Tac", 0);
    self addOpt("tac_bind", 1, "THIRDEYE", undefined, ::set_bind, "Tac", 1);
    self addOpt("tac_bind", 2, "CLIP TO 1", undefined, ::set_bind, "Tac", 2);
    self addOpt("tac_bind", 3, "CANZOOM", undefined, ::set_bind, "Tac", 3);
    self addOpt("tac_bind", 4, "ZOOMLOAD", undefined, ::set_bind, "Tac", 4);
    self addOpt("tac_bind", 5, "CANSWAP", undefined, ::set_bind, "Tac", 5);
    self addOpt("tac_bind", 6, "EMPTYCLIP", undefined, ::set_bind, "Tac", 6);
    self addOpt("tac_bind", 7, "HITMARKER", undefined, ::set_bind, "Tac", 7);

    self addMenu("leth_bind", "[{+frag}] Lethal", "menu_binds");
    self addOpt("leth_bind", 0, "REMOVE BIND", undefined, ::set_bind, "Leth", 0);
    self addOpt("leth_bind", 1, "THIRDEYE", undefined, ::set_bind, "Leth", 1);
    self addOpt("leth_bind", 2, "CLIP TO 1", undefined, ::set_bind, "Leth", 2);
    self addOpt("leth_bind", 3, "CANZOOM", undefined, ::set_bind, "Leth", 3);
    self addOpt("leth_bind", 4, "ZOOMLOAD", undefined, ::set_bind, "Leth", 4);
    self addOpt("leth_bind", 5, "CANSWAP", undefined, ::set_bind, "Leth", 5);
    self addOpt("leth_bind", 6, "EMPTYCLIP", undefined, ::set_bind, "Leth", 6);
    self addOpt("leth_bind", 7, "HITMARKER", undefined, ::set_bind, "Leth", 7);
/*
    // Vision Menu (uncommented and fixed)
    self addMenu("menu_vision", "Vision Menu", "main");
    self addOpt("menu_vision", 0, "Default Vision", "Reset to default vision", ::visionSetNaked, "default");
    self addOpt("menu_vision", 1, "Infrared Vision", "Enable infrared vision", ::visionSetNaked, "infrared");
    self addOpt("menu_vision", 2, "Black and White Vision", "Enable black and white vision", ::visionSetNaked, "mpoutro");
    self addOpt("menu_vision", 3, "High Contrast Vision", "Enable high contrast vision", ::visionSetNaked, "remote_mortar_enhanced");
    self addOpt("menu_vision", 4, "Blue Vision", "Enable blue-tinted vision", ::visionSetNaked, "tvguided_sp");

    // Aimbot Menu
     self addMenu("menu_aimbot", "Aimbot Menu", "main");
     self addOpt("menu_aimbot", 0, "Unfair Aimbot", "Unfair Aimbot", ::doUnfair);
     self addOpt("menu_aimbot", 1, "Activate EB", "Activate EB", ::doRadiusAimbot);
     self addOpt("menu_aimbot", 2, "Select EB Range", "Select EB Range", ::aimbotRadius);
     self addOpt("menu_aimbot", 3, "Select EB Delay", "Select EB Delay", ::aimbotDelay);
     self addOpt("menu_aimbot", 4, "Select EB Weapon", "Select EB Weapon", ::aimbotWeapon);
     self addOpt("menu_aimbot", 5,  "Activate Tag EB", "Activate Tag EB", ::HmAimbot);
     self addOpt("menu_aimbot", 6, "Select Tag EB Range", "Select Tag EB Range", ::HMaimbotRadius);
     self addOpt("menu_aimbot", 7, "Select Tag EB Delay", "Select Tag EB Delay", ::HMaimbotDelay);
     self addOpt("menu_aimbot", 8, "Select Tag EB Weapon", "Select Tag EB Weapon", ::HMaimbotWeapon);
*/
    // Host Menu
    self addMenu("menu_host", "Host Options", "main");
    self addBoolean("menu_host", 0, "Infinite Game", "Fast restarts after killcam instead of rotating", self.pers["infgame"], ::infgame);
    self addOpt("menu_host", 1, "Remove 2 Minutes", "Remove 2 Minutes from the timer", ::removetime);
    self addOpt("menu_host", 2, "Add 2 Minutes", "Add 2 Minutes to the timer", ::addtime);

    // Developer Menu
    self addMenu("menu_dev", "^1Developer Menu^7", "main");
    self addBoolean("menu_dev", 0, "God Mode", "Toggle Invulnerability", self.invulnerable, ::toggle_godmode_dev);
    self addOpt("menu_dev", 1, "Dump Location Info", "Print your current position info to remote console", ::dump_viewpos);
    self addOpt("menu_dev", 2, "Dump Weapon Info", "Print your weapon info to remote console", ::dump_weapon);
    self addStringSlider("menu_dev", 3, "Change Header", self.HeaderArray, "Cycle menu header shader", ::changeHeader);
    
}





