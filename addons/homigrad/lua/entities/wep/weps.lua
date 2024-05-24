if engine.ActiveGamemode() == "homigrad" then
Guns = {
"weapon_glock18",
"weapon_p220",
"weapon_mp5",
"weapon_ar15",
"weapon_ak74",
"weapon_akm",
"weapon_fiveseven",
"weapon_hk_usp",
"weapon_deagle",
"weapon_beretta",
"weapon_ak74u",
"weapon_l1a1",
"weapon_fal",
"weapon_galil",
"weapon_galilsar",
"weapon_m14",
"weapon_m1a1",
"weapon_mk18",
"weapon_m249",
"weapon_m4a1",
"weapon_minu14",
"weapon_mp40",
"weapon_rpk",
"weapon_ump",
"weapon_hk_usps",
"weapon_m3super",
"weapon_glock",
"weapon_mp7",
"weapon_remington870",
"weapon_xm1014",
"bandage",
"morphine",
"medkit",
"painkiller",
"weapon_physgun",
"weapon_kabar",
"weapon_bat",
"weapon_gurkha",
"weapon_jmoddynamite",
"weapon_jmodflash",
"weapon_jmodnade",
"weapon_taser",
"weapon_t",
"weapon_knife",
"weapon_pipe",
"weapon_sar2",
"weapon_civil_famas",
"weapon_vector",
"weapon_xm8_lmg",
"weapon_hk_arbalet",
"weapon_doublebarrel",
"weapon_doublebarrel_dulo",
"weapon_spas12"
}
GunsModel = {
["weapon_glock18"]="models/pwb2/weapons/w_fiveseven.mdl",
["weapon_p220"]="models/pwb/weapons/w_cz75.mdl",
["weapon_mp5"]="models/pwb2/weapons/w_mp5a3.mdl",
["weapon_ar15"]="models/pwb2/weapons/w_m4a1.mdl",
["weapon_ak74"]="models/pwb/weapons/w_m134.mdl",
["weapon_akm"]="models/pwb/weapons/w_akm.mdl",
["weapon_fiveseven"]="models/pwb/weapons/w_p99.mdl",
["weapon_hk_usp"]="models/pwb2/weapons/w_usptactical.mdl",
["weapon_deagle"]="models/pwb2/weapons/w_matebahomeprotection.mdl",
["weapon_beretta"]="models/pwb/weapons/w_m9.mdl",
["weapon_ak74u"]="models/pwb/weapons/w_aks74u.mdl",
["weapon_l1a1"]="models/pwb/weapons/w_tar21.mdl",
["weapon_fal"]="models/pwb/weapons/w_l85a1.mdl",
["weapon_galil"]="models/pwb2/weapons/w_ace23.mdl",
["weapon_galilsar"]="models/pwb2/weapons/w_asval.mdl",
["weapon_m14"]="models/weapons/insurgency/w_m14.mdl",
["weapon_m1a1"]="models/pwb/weapons/w_vz61.mdl",
["weapon_mk18"]="models/pwb/weapons/w_hk416.mdl",
["weapon_m249"]="models/pwb2/weapons/w_m249paratrooper.mdl",
["weapon_m4a1"]="models/pwb2/weapons/w_m4a1.mdl",
["weapon_minu14"]="models/weapons/insurgency/w_mini14.mdl",
["weapon_mp40"]="models/pwb/weapons/w_p90.mdl",
["weapon_rpk"]="models/pwb2/weapons/w_rpk.mdl",
["weapon_ump"]="models/pwb/weapons/w_uzi.mdl",
["weapon_hk_usps"]="models/weapons/w_pist_usp_silencer.mdl",
["weapon_m3super"]="models/pwb2/weapons/w_m4super90.mdl",
["weapon_glock"]="models/pwb/weapons/w_glock17.mdl",
["weapon_mp7"]="models/pwb2/weapons/w_mp7.mdl",
["weapon_remington870"]="models/pwb/weapons/w_remington_870.mdl",
["weapon_xm1014"]="models/pwb/weapons/w_xm1014.mdl",
["bandage"]="models/props/cs_office/Paper_towels.mdl",
["food_fishcan"]="models/jordfood/atun.mdl",
["food_lays"]="models/foodnhouseholditems/chipslays5.mdl",
["food_spongebob_home"]="models/jordfood/can.mdl",
["food_monster"]="models/jorddrink/mongcan1a.mdl",
["morphine"]="models/bloocobalt/l4d/items/w_eq_adrenaline.mdl",
["medkit"]="models/w_models/weapons/w_eq_medkit.mdl",
["painkiller"]="models/w_models/weapons/w_eq_painpills.mdl",
["weapon_physgun"]="models/weapons/w_physics.mdl",
["weapon_kabar"]="models/weapons/insurgency/w_marinebayonet.mdl",
["weapon_bat"]="models/weapons/w_knije_t.mdl",
["weapon_gurkha"]="models/weapons/insurgency/w_gurkha.mdl",
["weapon_jmoddynamite"]="models/props_junk/flare.mdl",
["weapon_jmodflash"]="models/jmod/explosives/grenades/flashbang/flashbang.mdl",
["weapon_jmodnade"]="models/jmod/explosives/grenades/fragnade/w_fragjade.mdl",
["weapon_handcuffs"]="models/freeman/flexcuffs.mdl",
["weapon_taser"]="models/realistic_police/taser/w_taser.mdl" ,
["weapon_t"]="models/pwb/weapons/w_tomahawk.mdl",
["weapon_knife"]="models/pwb/weapons/w_knife.mdl",
["weapon_pipe"]="models/props_canal/mattpipe.mdl",
["weapon_sar2"]="models/weapons/arccw/w_irifle.mdl",
["weapon_civil_famas"]="models/pwb2/weapons/w_famasg2.mdl",
["weapon_spas12"] = "models/pwb/weapons/w_spas_12.mdl",
["weapon_vector"] = "models/pwb2/weapons/w_vectorsmg.mdl",
["weapon_xm8_lmg"] = "models/pwb2/weapons/w_xm8lmg.mdl", 
["weapon_hk_arbalet"] = "models/weapons/w_jmod_crossbow.mdl",
["weapon_awp"]="models/weapons/salatbase/w_snip_awp.mdl",
["weapon_doublebarrel_dulo"]="models/weapons/tfa_ins2/w_doublebarrel_sawnoff.mdl",
["weapon_doublebarrel_dulo"]="models/weapons/tfa_ins2/w_doublebarrel.mdl",
}

ShootWait = {
["weapon_glock18"]=0.08,
["weapon_p220"]=0.08,
["weapon_mp5"]=0.06,
["weapon_ar15"]=0.08,
["weapon_ak74"]=0.02,
["weapon_akm"]=0.1,
["weapon_fiveseven"]=0.08,
["weapon_hk_usp"]=0.08,
["weapon_deagle"]=0.15,
["weapon_beretta"]=0.08,
["weapon_ak74u"]=0.075,
["weapon_l1a1"]=0.1,
["weapon_fal"]=0.1,
["weapon_galil"]=0.09,
["weapon_galilsar"]=0.065,
["weapon_m14"]=0.06,
["weapon_m1a1"]=0.06,
["weapon_mk18"]=0.07,
["weapon_m249"]=0.075,
["weapon_m4a1"]=0.07,
["weapon_minu14"]=0.15,
["weapon_mp40"]=0.05,
["weapon_rpk"]=0.1,
["weapon_ump"]=0.05,
["weapon_hk_usps"]=0.08,
["weapon_m3super"]=0.4,
["weapon_glock"]=0.08,
["weapon_mp7"]=0.06,
["weapon_remington870"]=0.5,
["weapon_xm1014"]=0.2,
["bandage"]=0,
["weapon_sar2"]=0.1,
["weapon_civil_famas"]=0.01,
["weapon_spas12"] = 0.15,
["weapon_vector"] = 0.06,
["weapon_xm8_lmg"] = 0.085,
["weapon_awp"]=0.8,
["weapon_hk_arbalet"]=0,
["weapon_doublebarrel_dulo"]=0.1,
["weapon_doublebarrel"]=0.1,
}

ReloadTime = {
["weapon_glock18"]=2,
["weapon_p220"]=2,
["weapon_mp5"]=2,
["weapon_ar15"]=2,
["weapon_ak74"]=2,
["weapon_akm"]=2,
["weapon_fiveseven"]=2,
["weapon_hk_usp"]=2,
["weapon_deagle"]=2,
["weapon_beretta"]=2,
["weapon_ak74u"]=2,
["weapon_l1a1"]=2,
["weapon_fal"]=2,
["weapon_galil"]=2,
["weapon_galilsar"]=2,
["weapon_m14"]=2,
["weapon_m1a1"]=2,
["weapon_mk18"]=2,
["weapon_m249"]=4,
["weapon_m4a1"]=2,
["weapon_minu14"]=2,
["weapon_mp40"]=2,
["weapon_rpk"]=4,
["weapon_ump"]=2,
["weapon_hk_usps"]=2,
["weapon_m3super"]=2,
["weapon_glock"]=2,
["weapon_mp7"]=2,
["weapon_remington870"]=2,
["weapon_xm1014"]=2,
["bandage"]=0,
["weapon_sar2"]=2,
["weapon_civil_famas"]=2,
["weapon_spas12"]=2,
["weapon_vector"]=2,
["weapon_xm8_lmg"]=2,
["weapon_hk_arbalet"]=2,
["weapon_doublebarrel"]=2,
["weapon_doublebarrel_dulo"]=2,
}


TwoHandedOrNo = {
["weapon_glock18"]=false,
["weapon_p220"]=false,
["weapon_mp5"]=true,
["weapon_ar15"]=true,
["weapon_ak74"]=true,
["weapon_akm"]=true,
["weapon_fiveseven"]=false,
["weapon_hk_usp"]=false,
["weapon_deagle"]=false,
["weapon_beretta"]=false,
["weapon_ak74u"]=true,
["weapon_l1a1"]=true,
["weapon_fal"]=true,
["weapon_galil"]=true,
["weapon_galilsar"]=true,
["weapon_m14"]=true,
["weapon_m1a1"]=false,
["weapon_mk18"]=true,
["weapon_m249"]=true,
["weapon_m4a1"]=true,
["weapon_minu14"]=true,
["weapon_mp40"]=true,
["weapon_rpk"]=true,
["weapon_ump"]=false,
["weapon_hk_usps"]=false,
["weapon_m3super"]=true,
["weapon_glock"]=false,
["weapon_mp7"]=true,
["weapon_remington870"]=true,
["weapon_xm1014"]=true,
["bandage"]=false,
["weapon_sar2"]=true,
["weapon_civil_famas"]=true,
["weapon_spas12"]=true,
["weapon_vector"]=true,
["weapon_xm8_lmg"]=true,
["weapon_hk_arbalet"]=true,
["weapon_doublebarrel"]=true,
["weapon_doublebarrel_dulo"]=true,
}

Automatic = {
["weapon_glock18"]=false,
["weapon_p220"]=true,
["weapon_mp5"]=true,
["weapon_ar15"]=false,
["weapon_ak74"]=true,
["weapon_akm"]=true,
["weapon_fiveseven"]=false,
["weapon_hk_usp"]=false,
["weapon_deagle"]=false,
["weapon_beretta"]=false,
["weapon_ak74u"]=true,
["weapon_l1a1"]=true,
["weapon_fal"]=true,
["weapon_galil"]=true,
["weapon_galilsar"]=true,
["weapon_m14"]=true,
["weapon_m1a1"]=true,
["weapon_mk18"]=true,
["weapon_m249"]=true,
["weapon_m4a1"]=true,
["weapon_minu14"]=true,
["weapon_mp40"]=true,
["weapon_rpk"]=true,
["weapon_ump"]=true,
["weapon_hk_usps"]=false,
["weapon_m3super"]=true,
["weapon_glock"]=false,
["weapon_mp7"]=true,
["weapon_remington870"]=false,
["weapon_xm1014"]=false,
["bandage"]=false,
["weapon_sar2"]=true,
["weapon_civil_famas"]=false,
["weapon_spas12"]=true,
["weapon_vector"]=true,
["weapon_xm8_lmg"]=true,
["weapon_hk_arbalet"]=false,
["weapon_doublebarrel"]=false,
["weapon_doublebarrel_dulo"]=false,
}

end