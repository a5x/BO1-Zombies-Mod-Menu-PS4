/*
??????????????? ???????????? ??????????????? ???????????? ??????????????? ????????? ?????????????????? ???????????? 
??????????????? ???????????? ??????????????? ???????????? ??????????????? ????????? ?????????????????? ???????????? 
??????????????? ???????????? ??????????????? ???????????? ??????????????? ????????? ?????????????????? ????????????

This is created by cabconmodding.com!

Please just edit it with permission!

*/



#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_load_common;
#include maps\_zombiemode_utility;

//mod includes

#include maps\mod_cabcon\_load_menubase;
#include maps\mod_cabcon\_load_functions;
#include maps\mod_cabcon\_load_utilies;

precachemod()//called when player inits
{
	//Shaders
	
	precacheshader("scorebar_zom_3");
	precacheshader("scorebar_zom_4");
	precacheshader("scorebar_zom_2");
	precacheshader("scorebar_zom_1");
	precacheshader("hud_chalk_1");
	precacheshader("zom_icon_community_pot");
	precacheshader("zom_icon_community_pot_strip");
	precacheshader("zom_icon_player_life");
	precacheshader("scorebar_zom_long_4");
	precacheshader("scorebar_zom_long_3");
	precacheshader("scorebar_zom_long_2");
	precacheshader("scorebar_zom_long_1");
	precacheshader("specialty_juggernaut_zombies_pro");
	precacheshader("minimap_icon_juggernog");
	precacheshader("minimap_icon_revive");
	precacheshader("minimap_icon_reload");
	precacheshader("specialty_doublepoints_zombies");
	precacheshader("line_horizontal_scorebar");
	precacheshader("menu_white_line_faded");
	precacheshader("line_horizontal");
	precacheshader("zom_icon_bonfire");
	precacheshader("zom_medals_skull_full");
	precacheshader("zombie_stopwatch");
	precacheshader("menu_white_line_faded_big");
	precacheshader("hud_dpad_lines_fade");
	precacheshader("gradient");
	precacheshader("ui_cursor");
	precacheshader("logo_cod2");
	precacheshader("ui_slider2");
	precacheshader("loadscreen_zombie_moon");
	precacheshader("loadscreen_zombie_temple");
	precacheshader("loadscreen_zombie_coast");
	precacheshader("loadscreen_zombie_theater");
	precacheshader("loadscreen_zombie_pentagon");
	precacheshader("ui_perforation");
	precacheshader("zom_icon_player_life");
	precacheshader("zom_icon_theater_reel");
	precacheshader("zom_medals_skull_face"); 
	precacheshader("menu_zombie_lobby_frame_outer_ingame");
	precacheshader("menu_sp_lobby_frame_outer_ingame");
	precacheshader("menu_background_press_start");
	precacheshader("menu_button_backing");
	precacheshader("menu_mp_bar_shadow");
	precacheshader("zom_medals_skull_full");
	precacheshader("zom_medals_skull_ribbon");
	precacheshader("ui_host");
	precacheshader("overlay_low_health");
	precacheshader("white");
	precacheshader("overlay_low_health_compass");	
	
	precacheshader( "loadscreen_"+GetDvar( "mapname" ) );
	
	///*******************************************************************************************************************************///
	/// Entitys                                                 																	  ///
	///*******************************************************************************************************************************///
	
	addCostumModel("zombie_skull");
	//addCostumModel("test_sphere_silver");
	addCostumModel("defaultactor");
	addCostumModel("zombie_vending_jugg");
	addCostumModel("zombie_vending_doubletap");
	addCostumModel("zombie_vending_sleight");
	addCostumModel("zombie_vending_marathon");
	addCostumModel("zombie_vending_revive");
	addCostumModel("zombie_teddybear");
	addCostumModel("zombie_z_money_icon");
	addCostumModel("zombie_revive");
	addCostumModel("zombie_vending_three_gun");
	addCostumModel("zombie_vending_packapunch");
	addCostumModel("t5_weapon_mpl_world");
	addCostumModel("t5_weapon_ak74u_world");
	addCostumModel("t5_weapon_pm63_world");
	addCostumModel("t5_weapon_beretta682_world");
	addCostumModel("t5_weapon_m16a1_world");
	addCostumModel("zombie_bomb");
	addCostumModel("zombie_x2_icon");
	addCostumModel("zombie_ammocan");
	addCostumModel("zombie_carpenter");
	addCostumModel("zombie_firesale");
	addCostumModel("zombie_pickup_bonfire");
	addCostumModel("zombie_pickup_minigun");
	addCostumModel("zombie_pickup_perk_bottle");

	level.zombie_init_done = ::func_applySelectedZombieModel;
	if( !isDefined(level.zombie_model_death_callback_registered) )
	{
		maps\_zombiemode_spawner::register_zombie_death_event_callback(::func_cleanupZombieModel);
		level.zombie_model_death_callback_registered = true;
	}
	
	//Var
	setDvar("sv_cheats",0);
}

mod_main(player)
{	
	//player connected // This function will call from the Host when he connects
	player mod_onPlayerSawned();
	
}

mod_onPlayerSawned()
{
	self endon( "disconnect" ); 
	for( ;; )
	{
		self waittill( "spawned_player" ); 
		self setClientDvar("sv_cheats",0);
		if( isDefined(self.player_selected_model) )
			self func_applyPlayerModel(self.player_selected_model);
		self mod_startup();
		self func_enableSpawnOptions();
	}
}

mod_startup()
{
	//self create_message("^1EnCoReV8 - Zombie Edition","^1By CabCon");
	if( !self.stopThreading )
    {
        self playerSetup();
		self maps\_zombiemode_score::add_to_player_score(99999999);
		self.var["starting_score_given"] = true;
        self.stopThreading = true;
    }
}

