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

//Self created
#include maps\mod_cabcon\_load_functions;
#include maps\mod_cabcon\_load_utilies;
#include maps\mod_cabcon\_load_settings;

clearMenuState()
{
    // Stop every menu loop/thread owned by this player before destroying its HUD.
    self notify("remove_mod_menu");
    self notify("cabcon_stop_thread");
    self notify("stop_top_right_hud");
    self notify("revolution_born_welcome_stop");

    self.playerSetting["hasMenu"] = false;
    self.playerSetting["isInMenu"] = false;
    self.playerSetting["verfication"] = "unverified";
    self.playerSetting["first_time_to_open"] = true;
    self.playerSetting["menu_gifted_cohost"] = false;

    // Destroy every HUD object that can belong to the menu, including
    // popup/dvar-editor elements that reuse the menu UI container.
    if( isDefined(self.menu) && isDefined(self.menu["ui"]) )
    {
        if( isDefined(self.menu["ui"]["background"]) )
            self.menu["ui"]["background"] destroy();
        if( isDefined(self.menu["ui"]["scroller"]) )
            self.menu["ui"]["scroller"] destroy();
        if( isDefined(self.menu["ui"]["barTop"]) )
            self.menu["ui"]["barTop"] destroy();
        if( isDefined(self.menu["ui"]["borderTop"]) )
            self.menu["ui"]["borderTop"] destroy();
        if( isDefined(self.menu["ui"]["borderBottom"]) )
            self.menu["ui"]["borderBottom"] destroy();
        if( isDefined(self.menu["ui"]["borderLeft"]) )
            self.menu["ui"]["borderLeft"] destroy();
        if( isDefined(self.menu["ui"]["borderRight"]) )
            self.menu["ui"]["borderRight"] destroy();
        if( isDefined(self.menu["ui"]["headerLine"]) )
            self.menu["ui"]["headerLine"] destroy();
        if( isDefined(self.menu["ui"]["title"]) )
            self.menu["ui"]["title"] destroy();
        if( isDefined(self.menu["ui"]["title_value"]) )
            self.menu["ui"]["title_value"] destroy();
        if( isDefined(self.menu["ui"]["subtitle"]) )
            self.menu["ui"]["subtitle"] destroy();
        if( isDefined(self.menu["ui"]["text"]) )
        {
            for( i = 0; i < self.menu["ui"]["text"].size; i++ )
            {
                if( isDefined(self.menu["ui"]["text"][i]) )
                    self.menu["ui"]["text"][i] destroy();
            }
        }
        self.menu["ui"] = undefined;
    }

    self destroyOpenMenuHint();
    self hideRevolutionRebornWelcome();

    // Wipe the per-player menu definition/cursor state so a later Give
    // starts from a completely fresh menu without duplicated entries.
    if( isDefined(self.menu) )
    {
        self.menu["items"] = [];
        self.menu["curs"] = [];
        self.menu["currentMenu"] = "";
        self.menu["isLocked"] = false;
    }

    if( isDefined(self.temp) && isDefined(self.temp["memory"]) && isDefined(self.temp["memory"]["menu"]) )
        self.temp["memory"]["menu"]["currentmenu"] = undefined;

    self.var["popup_active"] = false;
}

playerSetup()
{
    if( !isDefined(level.rainbow_initialized) )
    {
        level.rainbow_initialized = true;
        level thread createRainbowColor();
    }
    self defineVariables();
    self.playerSetting["hasMenu"] = false;
    self.playerSetting["verfication"] = "unverified";
    self.playerSetting["menu_gifted_cohost"] = false;

    if( self != get_players()[0] )
    {
        self clearMenuState();
        return;
    }

    if( !isDefined(self.threaded) )
    {
        self.playerSetting["hasMenu"] = true;
        self.playerSetting["verfication"] = "admin";
        self.threaded = true;
    }

    if( self.playerSetting["hasMenu"] )
    {
        self thread menuBase();
        self runMenuIndex();
        self createOpenMenuHint();
        self thread showRevolutionRebornWelcome();
    }
}

showRevolutionRebornWelcome()
{
    self notify("revolution_born_welcome_stop");
    self endon("revolution_born_welcome_stop");

    if( isDefined(self.revolutionRebornWelcome) )
    {
        self.revolutionRebornWelcome destroy();
        self.revolutionRebornWelcome = undefined;
    }

    self.revolutionRebornWelcome = self createFontString("objective", 1.7, self);
    self.revolutionRebornWelcome setPoint("CENTER", "TOP", 0, 110);
    self.revolutionRebornWelcome setText("^7You Using ^3Revolution Reborn^7 ^1BO1 1.0.1!^7^3github.com/a5x/BO1-Zombies-Mod-Menu-PS4/^7 for update");
    self.revolutionRebornWelcome.alpha = 1;
    self.revolutionRebornWelcome.hidewheninmenu = true;

    wait 10;
    self.revolutionRebornWelcome fadeOverTime(0.35);
    self.revolutionRebornWelcome.alpha = 0;
    wait 0.4;

    if( isDefined(self.revolutionRebornWelcome) )
    {
        self.revolutionRebornWelcome destroy();
        self.revolutionRebornWelcome = undefined;
    }
}

hideRevolutionRebornWelcome()
{
    self notify("revolution_born_welcome_stop");
    if( isDefined(self.revolutionRebornWelcome) )
    {
        self.revolutionRebornWelcome destroy();
        self.revolutionRebornWelcome = undefined;
    }
}

createOpenMenuHint()
{
    if( isDefined(self.openMenuHint) )
        return;

    self.openMenuHint = self createFontString("default", 1.1, self);
    self.openMenuHint setPoint("LEFT", "BOTTOM", 18, -35);
    self.openMenuHint setText("^7Open Menu ^3[{+frag}]^7 + ^3[{+usereload}]^7");
    self.openMenuHint.color = (1, 1, 1);
    self.openMenuHint.alpha = 1;
    self.openMenuHint.hidewheninmenu = false;

    self.openMenuHintScroll = self createFontString("default", 1.1, self);
    self.openMenuHintScroll setPoint("LEFT", "BOTTOM", 18, -48);
    self.openMenuHintScroll setText("^7Scroll : ^3[{+speed_throw}]^7 / ^3[{+attack}]^7");
    self.openMenuHintScroll.color = (1, 1, 1);
    self.openMenuHintScroll.alpha = 1;
    self.openMenuHintScroll.hidewheninmenu = false;

    self.openMenuHintValidate = self createFontString("default", 1.1, self);
    self.openMenuHintValidate setPoint("LEFT", "BOTTOM", 18, -61);
    self.openMenuHintValidate setText("^7Validate : ^3[{+activate}]^7");
    self.openMenuHintValidate.color = (1, 1, 1);
    self.openMenuHintValidate.alpha = 1;
    self.openMenuHintValidate.hidewheninmenu = false;

    self.openMenuHintBack = self createFontString("default", 1.1, self);
    self.openMenuHintBack setPoint("LEFT", "BOTTOM", 18, -74);
    self.openMenuHintBack setText("^7Back : ^3[{+melee}]^7");
    self.openMenuHintBack.color = (1, 1, 1);
    self.openMenuHintBack.alpha = 1;
    self.openMenuHintBack.hidewheninmenu = false;

    self.topRightVersion = self createFontString("default", 1.1, self);
    self.topRightVersion setPoint("RIGHT", "TOP", 375, -15);
    self.topRightVersion setText("^7Version : ^31.0.1^7");
    self.topRightVersion.color = (1, 1, 1);
    self.topRightVersion.alpha = 0.75;
    self.topRightVersion.hidewheninmenu = false;

    self.topRightZombieCounter = self createFontString("default", 1.1, self);
    self.topRightZombieCounter setPoint("RIGHT", "TOP", 375, 5);
    self.topRightZombieCounter setText("^7Zombies : ^3" + get_current_zombie_count() + "^7");
    self.topRightZombieCounter.color = (1, 1, 1);
    self.topRightZombieCounter.alpha = 0.75;
    self.topRightZombieCounter.hidewheninmenu = false;

    self thread updateTopRightHud();
}

updateTopRightHud()
{
    self notify("stop_top_right_hud");
    self endon("stop_top_right_hud");
    self endon("disconnect");

    for( ;; )
    {
        if( isDefined(self.topRightZombieCounter) )
        {
            if( self getUserIn() )
            {
                self.topRightZombieCounter.alpha = 0;
            }
            else
            {
                self.topRightZombieCounter.alpha = 0.75;
                self.topRightZombieCounter setText("^7Zombies : ^3" + get_current_zombie_count() + "^7");
            }
        }
        wait 0.25;
    }
}

destroyOpenMenuHint()
{
    self notify("stop_top_right_hud");

    if( isDefined(self.openMenuHint) )
    {
        self.openMenuHint destroy();
        self.openMenuHint = undefined;
    }
    if( isDefined(self.openMenuHintScroll) )
    {
        self.openMenuHintScroll destroy();
        self.openMenuHintScroll = undefined;
    }
    if( isDefined(self.openMenuHintValidate) )
    {
        self.openMenuHintValidate destroy();
        self.openMenuHintValidate = undefined;
    }
    if( isDefined(self.openMenuHintBack) )
    {
        self.openMenuHintBack destroy();
        self.openMenuHintBack = undefined;
    }
    if( isDefined(self.topRightVersion) )
    {
        self.topRightVersion destroy();
        self.topRightVersion = undefined;
    }
    if( isDefined(self.topRightZombieCounter) )
    {
        self.topRightZombieCounter destroy();
        self.topRightZombieCounter = undefined;
    }
}
// func_popupMenu(iscontine,title,string_1,string_2,string_3,icon,icon_w,icon_h)
defineVariables()
{
	self.menu["version"] = "0.9";
    self.menu["currentMenu"] = "";
    self.menu["isLocked"] = false;
	
    self.playerSetting = [];
    self.playerSetting["verfication"] = "";
    self.playerSetting["isInMenu"] = false;
	self.playerSetting["first_time_to_open"] = true;
	
	self.menu_count = 1154;
	if(!isDefined(self.function_defaultSize))
		self.function_defaultSize = [];
	
	self.function_defaultSize["r_lightTweakSunLight"] = GetDvarFloat("r_lightTweakSunLight");
	self.function_defaultSize["r_lightTweakSunColor"] = GetDvar("r_lightTweakSunColor");
	
	self.var["trap_disabled"] = false;
	self.var["mes_flash"] = "";
	self.var["mes_functions"] = ::Sbold;
	self.var["popup_active"] = false;
	self.var["ZOMBIE_BOSS"] = false;
	self.var["aimbot_setting_unfair"] = false;
	self.var["aimbot_auto_shoot"] = false;
	
	GenerateValueSettings();
}
menuBase()
{
    self endon("remove_mod_menu");
    self endon("disconnect");

    if( !isDefined(self.playerSetting["hasMenu"]) )
        self.playerSetting["hasMenu"] = false;
    if( !self.playerSetting["hasMenu"] )
        return;

    while( true )
    {
        if( !self getLocked() || self getVerfication() > 0 )
        {
            if( !self getUserIn() )
            {
                if( self fragButtonPressed() && self useButtonPressed() && !self getLocked() )
                {
					if(self.playerSetting["first_time_to_open"])
					{
						self.playerSetting["first_time_to_open"] = false;
                        self controlMenu("open", "main");
					}
					else
						self controlMenu("open", "main");
						
					self func_sound_no_print("zmb_cha_ching");
                    wait 0.2;
                }
            }
            else
            {
                if( (self getMenuScrollDownPressed() || self getMenuScrollUpPressed()) && !self getLocked())
                {
					if(!self getLocked())
						self.menu["curs"][getCurrent()] += self getMenuScrollDownPressed();
                    if(!self getLocked())
						self.menu["curs"][getCurrent()] -= self getMenuScrollUpPressed();
                    if( self.menu["curs"][getCurrent()] > self.menu["items"][self getCurrent()].name.size-1 )
                        self.menu["curs"][getCurrent()] = 0;
                    if( self.menu["curs"][getCurrent()] < 0 )
                        self.menu["curs"][getCurrent()] = self.menu["items"][self getCurrent()].name.size-1;
				
					
                    self thread scrollMenu();
					self func_sound_no_print("zmb_perks_packa_ticktock");
                    wait 0.2;
                }
 
                if( self useButtonPressed() && !self getLocked() && self.menu["items"][self getCurrent()].func[self getCursor()] != ::headline)
                {
                        self.menu["ui"]["scroller"] scaleOverTime(.1, 105, 10);
						self thread [[self.menu["items"][self getCurrent()].func[self getCursor()]]] (
							self.menu["items"][self getCurrent()].input1[self getCursor()],
							self.menu["items"][self getCurrent()].input2[self getCursor()],
							self.menu["items"][self getCurrent()].input3[self getCursor()],
							self.menu["items"][self getCurrent()].input4[self getCursor()],
							self.menu["items"][self getCurrent()].input5[self getCursor()]
						);
						self func_sound_no_print("evt_perk_deny");
						wait 0.1;
                        self.menu["ui"]["scroller"] scaleOverTime(.1, 210, 20);
						wait 0.1;
                }
                if( self meleeButtonPressed() && !self getLocked() )
                {
                    if( isDefined(self.menu["items"][self getCurrent()].backParent) )
                        self controlMenu("newMenu", self.menu["items"][self getCurrent()].backParent);
                    else if( isDefined(self.menu["items"][self getCurrent()].parent) )
                        self controlMenu("newMenu", self.menu["items"][self getCurrent()].parent);
                    else
                        self controlMenu("close");
					self func_sound_no_print("uin_lobby_leave");
                    wait 0.2;
                }
            }
        }
        wait .05;
    }
}
scrollMenuText()
{
    self endon("remove_mod_menu");
    self endon("disconnect");

    if(!isDefined(self.menu["items"][self getCurrent()].name[self getCursor()-8]) || self.menu["items"][self getCurrent()].name.size <= 11)
    {
        for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[m]);
       	self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][self getCursor()].y);
    }
    else
    {
        if(isDefined(self.menu["items"][self getCurrent()].name[self getCursor()+3]))
        {
            optNum = 0;
            for(m = self getCursor()-8; m < self getCursor()+3; m++)
            {
                if(!isDefined(self.menu["items"][self getCurrent()].name[m]))
                    self.menu["ui"]["text"][optNum] setText("");
                else
                    self.menu["ui"]["text"][optNum] setText(self.menu["items"][self getCurrent()].name[m]);
                optNum++;
            }
            if( self.menu["ui"]["scroller"].y != self.menu["ui"]["text"][8].y )
                self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][8].y);
        }
        else
        {
            for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[self.menu["items"][self getCurrent()].name.size+(m-11)]);
	        	self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11)].y);
        }
    }
}

scrollMenu()
{
    self endon("remove_mod_menu");
    self endon("disconnect");

    if(!isDefined(self.menu["items"][self getCurrent()].name[self getCursor()-8]) || self.menu["items"][self getCurrent()].name.size <= 11)
    {
        for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[m]);
        self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][self getCursor()].y);
 
        for( a = 0; a < 11; a ++ )
        {
            if( self.menu["items"][self getCurrent()].func[a] != ::headline )
                self menu_apply_option_style(self.menu["ui"]["text"][a], a == self getCursor());
            else if( isDefined(self.menu["ui"]["text"][a]) )
                self menu_apply_option_style(self.menu["ui"]["text"][a], false);
        }
    }
    else
    {
        if(isDefined(self.menu["items"][self getCurrent()].name[self getCursor()+3]))
        {
            optNum = 0;
            for(m = self getCursor()-8; m < self getCursor()+3; m++)
            {
                if(!isDefined(self.menu["items"][self getCurrent()].name[m]))
                    self.menu["ui"]["text"][optNum] setText("");
                else
                    self.menu["ui"]["text"][optNum] setText(self.menu["items"][self getCurrent()].name[m]);
                optNum++;
            }
            if( self.menu["ui"]["scroller"].y != self.menu["ui"]["text"][8].y )
                self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][8].y);
            for( a = 0; a < 11; a ++ )
            {
                if( self.menu["items"][self getCurrent()].func[a] != ::headline )
                    self menu_apply_option_style(self.menu["ui"]["text"][a], a == 8);
                else if( isDefined(self.menu["ui"]["text"][a]) )
                    self menu_apply_option_style(self.menu["ui"]["text"][a], false);
            }
        }
        else
        {
            for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[self.menu["items"][self getCurrent()].name.size+(m-11)]);
            self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11)].y);
            for( a = 0; a < 11; a ++ )
            {
                if( self.menu["items"][self getCurrent()].func[a] != ::headline )
                    self menu_apply_option_style(self.menu["ui"]["text"][a], a == ((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11));
                else if( isDefined(self.menu["ui"]["text"][a]) )
                    self menu_apply_option_style(self.menu["ui"]["text"][a], false);
            }
        }
    }
}
 
 _menu_handle_hud_effect()
 {
    if( isDefined(self.menu["ui"]["background"]) )
    {
        self.menu["ui"]["background"] affectElement("alpha", .2, getMenuSetting("alpha_background"));
        self.menu["ui"]["background"] scaleOverTime(.3, 210, 1000);
    }
	self.menu["ui"]["scroller"] scaleOverTime(.1, 210, 500);
	self.menu["ui"]["scroller"] affectElement("alpha", .2, getMenuSetting("alpha_scroller"));
    self.menu["ui"]["scroller"] scaleOverTime(.4, 210, 20);
    self.menu["ui"]["borderTop"] affectElement("alpha", .1, 1);
    self.menu["ui"]["borderBottom"] affectElement("alpha", .1, 1);
    if( !self menu_should_hide_ui() )
    {
        self.menu["ui"]["borderLeft"] affectElement("alpha", .1, 1);
        self.menu["ui"]["borderRight"] affectElement("alpha", .1, 1);
    }
    self.menu["ui"]["headerLine"] affectElement("alpha", .1, 1);
 }
 _menu_handle_hud_noneffect()
 {
    if( isDefined(self.menu["ui"]["background"]) )
    {
        self.menu["ui"]["background"] affectElement("alpha", .00001, getMenuSetting("alpha_background"));
        self.menu["ui"]["background"] scaleOverTime(.00001, 210, 1000);
    }
	self.menu["ui"]["scroller"] scaleOverTime(.00001, 210, 500);
	self.menu["ui"]["scroller"] affectElement("alpha", .00001, getMenuSetting("alpha_scroller"));
    self.menu["ui"]["scroller"] scaleOverTime(.00001, 210, 20);
    self.menu["ui"]["borderTop"] affectElement("alpha", .00001, 0);
    self.menu["ui"]["borderBottom"] affectElement("alpha", .00001, 0);
    if( !self menu_should_hide_ui() )
    {
        self.menu["ui"]["borderLeft"] affectElement("alpha", .00001, 0);
        self.menu["ui"]["borderRight"] affectElement("alpha", .00001, 0);
    }
    self.menu["ui"]["headerLine"] affectElement("alpha", .00001, 0);
 }
controlMenu( type, par1 )
{
    if( !isDefined(self.playerSetting["hasMenu"]) || !self.playerSetting["hasMenu"] )
        return;

    if( type == "open" || type == "open_withoutanimation")
    {
		self destroyOpenMenuHint();
            if( !self menu_should_hide_ui() )
                self.menu["ui"]["background"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), 0, 210, 0, getMenuSetting("color_background"), 1, 0, getMenuSetting("shader_background")); //MENU ELEMENT
        self.menu["ui"]["scroller"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), -145, 0, 20, getMenuSetting("color_scroller"), 2, 0, getMenuSetting("shader_scroller")); //MENU ELEMENT
        self.menu["ui"]["borderTop"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), -250, 210, 3, getMenuSetting("color_scroller"), 4, 0, "white");
        self.menu["ui"]["borderBottom"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), 250, 210, 3, getMenuSetting("color_scroller"), 4, 0, "white");
        self.menu["ui"]["headerLine"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), -153, 210, 3, getMenuSetting("color_scroller"), 4, 0, "white");
        if( !self menu_should_hide_ui() )
        {
            self.menu["ui"]["borderLeft"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x") - 105, 0, 3, 500, getMenuSetting("color_scroller"), 4, 0, "white");
            self.menu["ui"]["borderRight"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x") + 105, 0, 3, 500, getMenuSetting("color_scroller"), 4, 0, "white");
        }
        if( self menu_should_hide_ui() )
        {
            self.menu["ui"]["scroller"].alpha = 0;
            self.menu["ui"]["borderTop"].alpha = 0;
            self.menu["ui"]["borderBottom"].alpha = 0;
            self.menu["ui"]["headerLine"].alpha = 0;
        }
		if(!self._var_menu["animations"] || type == "open_withoutanimation")
		{
			_menu_handle_hud_noneffect();
			if( !self getUserIn() )
				self buildTextOptions(par1);
		}
		else
		{
			_menu_handle_hud_effect();
			wait .2;
			self buildTextOptions(par1);
		}
        self.playerSetting["isInMenu"] = true;
        self hideRevolutionRebornWelcome();
    }
    if( type == "close" )
    {
        self.menu["isLocked"] = true;
        self controlMenu("close_animation");
        //self.menu["ui"]["background"] scaleOverTime(.3, 210, 0);
        //self.menu["ui"]["scroller"] scaleOverTime(.3, 0, 20);
        //ait .2;
        if( isDefined(self.menu["ui"]["background"]) )
            self.menu["ui"]["background"] affectElement("alpha", .05, .1);
        self.menu["ui"]["scroller"] affectElement("alpha", .05, .1);
        wait .05;
        if( isDefined(self.menu["ui"]["background"]) )
            self.menu["ui"]["background"] destroy();
        self.menu["ui"]["scroller"] destroy();
        self.menu["ui"]["borderTop"] destroy();
        self.menu["ui"]["borderBottom"] destroy();
        self.menu["ui"]["borderLeft"] destroy();
        self.menu["ui"]["borderRight"] destroy();
        self.menu["ui"]["headerLine"] destroy();
        self createOpenMenuHint();
        self.menu["isLocked"] = false;
        self.playerSetting["isInMenu"] = false;
    }
    if( type == "newMenu")
    {
		if(!self.menu["items"][par1].name.size <= 0 || isDefined(self.menu["items"][par1]))
    		{
    			self.menu["isLocked"] = true;
        		self controlMenu("close_animation");
				self buildTextOptions(par1);
				self.menu["isLocked"] = false;
				L("^1ID: "+getCurrent()+" SIZE:"+self.menu["items"][self getCurrent()].name.size+" MEMORY:"+getCursor()+"");
        	}
        else
        	{
        		L("^1The "+getOptionName()+" can not use ! DEVELOPER_ERROR_CODE: 604");
        	}
    }
    if( type == "lock" )
    {
        self controlMenu("close");
        self.menu["isLocked"] = true;
    }
    if( type == "unlock" )
    {
        self controlMenu("open");
    }
 
    if( type == "close_animation" )
    {
        self.menu["ui"]["title"] affectElement("alpha", .05, 0);
        for( a = 10; a >= 0; a-- )
        {
            self.menu["ui"]["text"][a] affectElement("alpha", .05, 0);
            //wait .05;      
        }
        for( a = 10; a >= 0; a-- )
            self.menu["ui"]["text"][a] destroy();
        self.menu["ui"]["title"] destroy();
        if( isDefined(self.menu["ui"]["subtitle"]) )
            self.menu["ui"]["subtitle"] destroy();
    }
}

createRainbowColor()
{
    y = 0;
    r = 0;
    g = 0;
    b = 0;
    level.rainbowColour = (1, 0, 0);

    while( true )
    {
        if( y < 255 )
        {
            r = 255;
            g = 0;
            b = y;
        }
        else if( y < 510 )
        {
            r = 255 - (y - 255);
            g = 0;
            b = 255;
        }
        else if( y < 765 )
        {
            r = 0;
            g = y - 510;
            b = 255;
        }
        else if( y < 1020 )
        {
            r = 0;
            g = 255;
            b = 255 - (y - 765);
        }
        else if( y < 1275 )
        {
            r = y - 1020;
            g = 255;
            b = 0;
        }
        else
        {
            r = 255;
            g = 255 - (y - 1275);
            b = 0;
        }

        level.rainbowColour = (r / 255, g / 255, b / 255);
        y += 5;
        if( y >= 1530 )
            y = 0;
        wait .05;
    }
}

doRainbow()
{
    self endon("remove_mod_menu");
    self endon("disconnect");

    while( isDefined(self) )
    {
        self.color = level.rainbowColour;
        wait .05;
    }
}
 
buildTextOptions(menu)
{
    if( !isDefined(self.playerSetting["hasMenu"]) || !self.playerSetting["hasMenu"] )
        return;

    self.menu["currentMenu"] = menu;
	if(!isDefined(self.menu["curs"][getCurrent()]))
			self.menu["curs"][getCurrent()] = 0;
    self.menu["ui"]["title"] = self createText(getMenuSetting("font_title"),1.5, 5, self.menu["items"][menu].title, "CENTER", "CENTER", getMenuSetting("pos_x"), -190, 0,"rainbow"); //MENU ELEMENT
    self.menu["ui"]["title"] thread doRainbow();
    if( menu == "main" )
    {
        self.menu["ui"]["subtitle"] = self createText(getMenuSetting("font_options"),1, 5, "^3By ZERTY^7", "CENTER", "CENTER", getMenuSetting("pos_x"), -170, 0,(1,1,1));
        self.menu["ui"]["subtitle"] affectElement("alpha", .2, 1);
    }
    if(getCurrent() == "main")
		self.menu["ui"]["title"] affectElement("alpha", .2, 1);
	else
		self.menu["ui"]["title"] affectElement("alpha", .05, 1);
	self thread scrollMenuText();
    for( a = 0; a < 11; a ++ )
    {
        if( menu == "main" || self.menu["items"][menu].func[a] == ::headline )
            self.menu["ui"]["text"][a] = self createText(getMenuSetting("font_options"),1.4, 5, self.menu["items"][menu].name[a], "CENTER", "CENTER", getMenuSetting("pos_x"), -145+(a*20), 1,(1,1,1)); //MENU ELEMENT
        else
        {
            self.menu["ui"]["text"][a] = self createText(getMenuSetting("font_options"),1.2, 5, self.menu["items"][menu].name[a], "CENTER", "CENTER", getMenuSetting("pos_x"), -145+(a*20), 1,(1,1,1)); //MENU ELEMENT
        }
        //wait .05;
    }
    self.menu["ui"]["text"][0] affectElement("alpha", .2, 1);
    self thread scrollMenu();
    self thread scrollMenu();
}

//Menu utilities
addMenu(menu, title, parent)
{
    if( !isDefined(self.menu["items"][menu]) )
    {
        self.menu["items"][menu] = spawnstruct();
        self.menu["items"][menu].name = [];
        self.menu["items"][menu].func = [];
        self.menu["items"][menu].input1 = [];
        self.menu["items"][menu].input2 = [];
        self.menu["items"][menu].input3 = [];
        self.menu["items"][menu].input4 = [];
		self.menu["items"][menu].input5 = [];
		
        self.menu["items"][menu].title = title;
 
        if( isDefined( parent ) )
            self.menu["items"][menu].parent = parent;
        else
            self.menu["items"][menu].parent = undefined;
    }
 
    self.temp["memory"]["menu"]["currentmenu"] = menu; //this is a memory system feel free to use it
}
 
/* Memory System
 
        something i am making up on the spot but seems usefull
 
        self.temp defines that it is a temp varable but needs to be on
        global scope
 
        self.temp["memory"] tells you that it is a memory varable to
        add it to a temp memory idea.
 
        self.temp["memory"]["menu"] means that it is for the menu
 
        self.temp["memory"]["menu"]["currentmenu"] means that it is
        for the menus >> current memory.
 
        so the use of this is
        self.temp[use][type][type for]
 
        enjoy :)
 
*/
 
//Par = paramatars < but i can not spell that so fuck it
addHeadline(name)
{
	//self.menu_count++;
    menu = self.temp["memory"]["menu"]["currentmenu"];
    count = self.menu["items"][menu].name.size;
    self.menu["items"][menu].name[count] = "--- "+name+" ---";
    self.menu["items"][menu].func[count] = ::headline;
}
addMenuPar(name, func, input1, input2, input3, input4, input5)
{
	//self.menu_count++;
    menu = self.temp["memory"]["menu"]["currentmenu"];
    count = self.menu["items"][menu].name.size;
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    if( isDefined(input1) )
        self.menu["items"][menu].input1[count] = input1;
    if( isDefined(input2) )
        self.menu["items"][menu].input2[count] = input2;
    if( isDefined(input3) )
        self.menu["items"][menu].input3[count] = input3;
	if( isDefined(input4) )
        self.menu["items"][menu].input4[count] = input4;
	if( isDefined(input5) )
        self.menu["items"][menu].input5[count] = input5;
}
 addMenuPar_withDef(menu, name, func, input1, input2, input3, input4, input5)
{
	//self.menu_count++;
    count = self.menu["items"][menu].name.size;
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    if( isDefined(input1) )
        self.menu["items"][menu].input1[count] = input1;
    if( isDefined(input2) )
        self.menu["items"][menu].input2[count] = input2;
    if( isDefined(input3) )
        self.menu["items"][menu].input3[count] = input3;
	if( isDefined(input4) )
        self.menu["items"][menu].input4[count] = input4;
	if( isDefined(input5) )
        self.menu["items"][menu].input5[count] = input5;
}
/*
        This function should only ever be used when you
        are using addmenu out side of a loop and inside
        that loop you are using addmenu. You will see this
        in the verification.
*/
addAbnormalMenu(menu, title, parent, name, func, input1, input2, input3, input4)
{
    if( !isDefined(self.menu["items"][menu]) )
            self addMenu(menu, title, parent); //title will never be changed after first menu is added.
   
    count = self.menu["items"][menu].name.size;
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    if( isDefined(input1) )
        self.menu["items"][menu].input1[count] = input1;
    if( isDefined(input2) )
        self.menu["items"][menu].input2[count] = input2;
    if( isDefined(input3) )
        self.menu["items"][menu].input3[count] = input3;
	 if( isDefined(input4) )
        self.menu["items"][menu].input4[count] = input4;
} 
 
verificationOptions(par1, par2, par3)
{
    player = get_players()[par1];
    if( par2 == "changeVerification" )
    {
        if( par1 == 0 )
             return self iprintln( "You can not modify the host");
        player setVerification(par3);
        self iPrintLn(getNameNotClan( player )+"'s verification has been changed to "+par3);
        player iPrintLn("Your verification has been changed to "+par3);
    }
}
 
setVerification( type )
{
    self.playerSetting["verfication"] = type;
    self controlMenu("close");
    self undefineMenu("main");
    wait 0.2;
    self runMenuIndex( true ); //this will only redefine the main menu
    wait 0.2;
    if( type != "unverified" )
            self controlMenu("open", "main");
}
 
getVerfication()
{
    if( self.playerSetting["verfication"] == "admin" )
        return 3;
    if( self.playerSetting["verfication"] == "co-host" )
        return 2;
    if( self.playerSetting["verfication"] == "verified" )
        return 1;
    if( self.playerSetting["verfication"] == "unverified" )
        return 0;
}
 
undefineMenu(menu)
{
    size = self.menu["items"][menu].name.size;
    for( a = 0; a < size; a++ )
    {
        self.menu["items"][menu].name[a] = undefined;
        self.menu["items"][menu].func[a] = undefined;
        self.menu["items"][menu].input1[a] = undefined;
        self.menu["items"][menu].input2[a] = undefined;
        self.menu["items"][menu].input3[a] = undefined;        
        self.menu["items"][menu].input4[a] = undefined;        
        self.menu["items"][menu].input5[a] = undefined;        
    }
}
 
getCurrent()
{
    return self.menu["currentMenu"];
}

getMenuScrollUpPressed()
{
    return self adsButtonPressed();
}

getMenuScrollDownPressed()
{
    return self attackButtonPressed();
}
 
getLocked()
{
    return self.menu["isLocked"];
}
 
getUserIn()
{
    return self.playerSetting["isInMenu"];
}
menu_should_hide_ui()
{
    return isDefined(self.playerSetting["menu_gifted_cohost"]) && self.playerSetting["menu_gifted_cohost"];
}
menu_should_highlight_option()
{
    return isDefined(self.playerSetting["menu_gifted_cohost"]) && self.playerSetting["menu_gifted_cohost"];
}
menu_apply_option_style( optionText, isCurrent )
{
    if( !isDefined(optionText) )
        return;

    if( !self menu_should_highlight_option() )
    {
        optionText.alpha = 1;
        optionText.color = (1, 1, 1);
        optionText scaleOverTime(0.12, 1, 1);
        optionText pulse(false);
        return;
    }

    if( isCurrent )
    {
        optionText.alpha = 1;
        optionText.color = (0.2, 1, 0.45);
        optionText scaleOverTime(0.12, 1.2, 1.2);
        optionText pulse(true);
    }
    else
    {
        optionText.alpha = 0.75;
        optionText.color = (1, 1, 1);
        optionText scaleOverTime(0.12, 1, 1);
        optionText pulse(false);
    }
}
getCursor()
{
    return self.menu["curs"][getCurrent()];
}
 
//UI utilities
createText(font,fontSize, sorts, text, align, relative, x, y, alpha, color)
{
    // IMPORTANT: pass the owning player explicitly.
    // Without the player argument, the fontstring can be created as a shared HUD element
    // and become visible to other clients. The menu must be client-local.
    uiElement = self createfontstring(font, fontSize, self);
    uiElement setPoint(align, relative, x, y);
    uiElement settext(text);
    uiElement.sort = sorts;
    uiElement.hidewheninmenu = true;
    if( isDefined(alpha) )
        uiElement.alpha = alpha;
    if( isDefined(color) )
        uiElement.color = color;
    return uiElement;
}
 
createValueElement(font, fontSize, sorts, value, align, relative, x, y, alpha, color)
{
    // Keep value text client-local for the same reason as createText().
    uiElement = self createfontstring(font, fontSize, self);
    uiElement setPoint(align, relative, x, y);
    uiElement setvalue(value);
    uiElement.sort = sorts;
    uiElement.hidewheninmenu = true;
    if( isDefined(alpha) )
        uiElement.alpha = alpha;
    if( isDefined(color) )
        uiElement.color = color;
    return uiElement;
}
createRectangle(align, relative, x, y, width, height, color, sort, alpha, shader)
{
    uiElement = newClientHudElem( self );
    uiElement.elemType = "bar";
    uiElement.width = width;
    uiElement.height = height;
    uiElement.align = align;
    uiElement.relative = relative;
    uiElement.xOffset = 0;
    uiElement.yOffset = 0;
    uiElement.hidewheninmenu = true;
    uiElement.children = [];
    uiElement.sort = sort;
    uiElement.color = color;
    uiElement.alpha = alpha;
    uiElement setParent( level.uiParent );
    uiElement setShader( shader, width , height );
    uiElement.hidden = false;
    uiElement setPoint(align,relative,x,y);
    return uiElement;
}
/*
drawBar(color, width, height, align, relative, x, y)
{
    bar = createBar(color, width, height, self);
    bar setPoint(align, relative, x, y);
    bar.hideWhenInMenu = true;
    return bar;
}*/

spawnTrig(origin, width, height, cursorHint, string)
{
	trig = spawn("trigger_radius", origin, 1, width, height);
	trig setCursorHint(cursorHint);
	trig setHintString(string);
	return trig;
}

affectElement(type, time, value)
{
    if( type == "x" || type == "y" )
        self moveOverTime( time );
    else
        self fadeOverTime( time );
 
    if( type == "x" )
        self.x = value;
    if( type == "y" )
        self.y = value;
    if( type == "alpha" )
        self.alpha = value;
    if( type == "color" )
        self.color = value;
}  
getNameNotClan( player )
{
	if( !isDefined( player ) )
		return "Unknown Player";

	if( isDefined( player.playername ) && player.playername != "" && player.playername != " " && player.playername != "<undefined>" )
		return player.playername;

	if( isDefined( player.name ) && player.name != "" && player.name != " " && player.name != "<undefined>" )
		return player.name;

	return "Unknown Player";
}



////////////////////////////////////////////////////////
//////////////////////DVAR_EDITOR/////BY_CABCON/////////
////////////////////////////////////////////////////////
dvar_test_developeemtn()//TODO :field of view editor
{
self EditorDvarCabCon(160,0,"cg_fov",1,65);
}
EditorDvarCabCon(max,min,dvar,value_add,value_default)
{
		self notify( "cabcon_stop_thread" );
		self endon( "cabcon_stop_thread" );
		self endon( "disconnect" );
		self.dvareditormax = max;
		self.menu["isLocked"] = true;
		self controlMenu("close_animation");
		self S("Press ^3[{+frag}]^7 to set Dvar default");
		self S("Press ^3[{+melee}] ^7to close Dvar Editor");
		self S("Press ^3[{+attack}]^7/^3[{+speed_throw}]^7 to Change Dvar");
		self.dvareditor = GetDvarInt( dvar );
        if( dvar == "g_speed" )
        {
            self.var["cabcon_speed_scale"] = self.dvareditor / 190.0;
            if( !isDefined(self.var["cabcon_speed_thread"]) )
            {
                self.var["cabcon_speed_thread"] = true;
                self thread cabcon_apply_player_speed();
            }
        }
        else if( dvar == "jump_height" )
        {
            self.var["cabcon_jump_height"] = self.dvareditor;
            if( !isDefined(self.var["cabcon_jump_thread"]) )
            {
                self.var["cabcon_jump_thread"] = true;
                self thread cabcon_apply_player_jump();
            }
        }
		self.menu["ui"]["scroller"] scaleOverTime(.1, 210, 10);
        self.menu["ui"]["scroller"] affectElement("y", .5, 220);
        self.menu["ui"]["title"] = self createText(getMenuSetting("font_title"),1.5, 5, "Var Slider ^2"+dvar+"^7", "CENTER", "CENTER", getMenuSetting("pos_x"), -180, 0,"rainbow"); //MENU ELEMENT
		self.menu["ui"]["title_value"] = self createValueElement(getMenuSetting("font_options"),1, 5, self.dvareditor, "CENTER", "CENTER", getMenuSetting("pos_x"), 220, 0,getMenuSetting("color_text")); //MENU ELEMENT
		self.menu["ui"]["title"] affectElement("alpha", .5, 1);
		self.menu["ui"]["title_value"] affectElement("alpha", .5, 1);
		for( ;; )
		{      
				if(self AttackButtonPressed())
				{
					self.dvareditor +=value_add;
				}
				if(self AdsButtonPressed())
				{
					self.dvareditor -=value_add;
				}
				if (self.dvareditor < min )
				{
				self.dvareditor = self.dvareditormax;
				}
				if (self.dvareditor > self.dvareditormax)
				{
				self.dvareditor = min;
				}
				wait 0.001;
				height = ( self.dvareditor / self.dvareditormax ) * 350;
				height = int( max( height, 1 ) );
				self.menu["ui"]["scroller"] affectElement("y", .0001, 220-height);
				self.menu["ui"]["title_value"] affectElement("y", .0001, 220-height);
				self.menu["ui"]["title_value"] setValue(self.dvareditor);
				//self.menu["ui"]["scroller"] scaleOverTime(.1, 210, height);
				//self.hud_cabcon_string setvalue( self.dvareditor );
                if( dvar == "g_speed" || dvar == "jump_height" )
                {
                    SetDvar(dvar, self.dvareditor);
                    self setClientDvar(dvar, self.dvareditor);
                    if( dvar == "g_speed" )
                        self.var["cabcon_speed_scale"] = self.dvareditor / 190.0;
                    else
                        self.var["cabcon_jump_height"] = self.dvareditor;
                }
                else
                    self setClientDvar(dvar,self.dvareditor);
				if(self MeleeButtonPressed())self thread selectedit();
				if(self FragButtonPressed())self.dvareditor = value_default;
       }
}

cabcon_apply_player_speed()
{
    self endon("disconnect");
    while( isDefined(self.var["cabcon_speed_thread"]) )
    {
        if( isDefined(self.var["cabcon_speed_scale"]) )
            self setmovespeedscale(self.var["cabcon_speed_scale"]);
        wait 0.05;
    }
}

cabcon_apply_player_jump()
{
    self endon("disconnect");
    self notify("cabcon_jump_stop");
    self endon("cabcon_jump_stop");

    for( ;; )
    {
        if( self JumpButtonPressed() && isDefined(self.var["cabcon_jump_height"]) && self.var["cabcon_jump_height"] > 39 )
        {
            for( i = 0; i < 10; i++ )
            {
                self setVelocity(self getVelocity() + (0, 0, self.var["cabcon_jump_height"]));
                wait 0.05;
            }
        }
        wait 0.05;
    }
}

selectedit()
{
	self notify( "cabcon_stop_thread" );
    self.menu["ui"]["scroller"] scaleOverTime(.4, 210, 14);
	self.menu["ui"]["title"] destroy();
	self.menu["ui"]["title_value"] destroy();
	self buildTextOptions(getCurrent());
	wait .2;
	self.menu["isLocked"] = false;
}