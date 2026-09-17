#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	if(GetDvar( #"mapname") == "mp_background") return;
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	maps\mp\gametypes\_globallogic_utils::registerTimeLimitDvar( "dom", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic_utils::registerScoreLimitDvar( "dom", 200, 0, 1000 );
	maps\mp\gametypes\_globallogic_utils::registerRoundLimitDvar( "dom", 1, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerRoundWinLimitDvar( "dom", 0, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerNumLivesDvar( "dom", 0, 0, 10 );
	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );
	level.scoreRoundBased = true;
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onEndGame= ::onEndGame;
	level.gamemodeSpawnDvars = ::dom_gamemodeSpawnDvars;
	level.onRoundEndGame = ::onRoundEndGame;
	game["dialog"]["gametype"] = "dom_start";
	game["dialog"]["gametype_hardcore"] = "hcdom_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	level.lastDialogTime = 0;
	setscoreboardcolumns( "kills", "deaths" , "captures", "defends");
	if ( !isOneRound() && isScoreRoundBased() )
	{
		maps\mp\gametypes\_globallogic_score::resetTeamScores();
	}
}
onPrecacheGameType()
{
	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_capture" );
	precacheShader( "compass_waypoint_defend" );
	precacheShader( "compass_waypoint_captureneutral_a" );
	precacheShader( "compass_waypoint_capture_a" );
	precacheShader( "compass_waypoint_defend_a" );
	precacheShader( "compass_waypoint_captureneutral_b" );
	precacheShader( "compass_waypoint_capture_b" );
	precacheShader( "compass_waypoint_defend_b" );
	precacheShader( "compass_waypoint_captureneutral_c" );
	precacheShader( "compass_waypoint_capture_c" );
	precacheShader( "compass_waypoint_defend_c" );
	precacheShader( "compass_waypoint_captureneutral_d" );
	precacheShader( "compass_waypoint_capture_d" );
	precacheShader( "compass_waypoint_defend_d" );
	precacheShader( "compass_waypoint_captureneutral_e" );
	precacheShader( "compass_waypoint_capture_e" );
	precacheShader( "compass_waypoint_defend_e" );
	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_defend" );
	precacheShader( "waypoint_captureneutral_a" );
	precacheShader( "waypoint_capture_a" );
	precacheShader( "waypoint_defend_a" );
	precacheShader( "waypoint_captureneutral_b" );
	precacheShader( "waypoint_capture_b" );
	precacheShader( "waypoint_defend_b" );
	precacheShader( "waypoint_captureneutral_c" );
	precacheShader( "waypoint_capture_c" );
	precacheShader( "waypoint_defend_c" );
	precacheShader( "waypoint_captureneutral_d" );
	precacheShader( "waypoint_capture_d" );
	precacheShader( "waypoint_defend_d" );
	precacheShader( "waypoint_captureneutral_e" );
	precacheShader( "waypoint_capture_e" );
	precacheShader( "waypoint_defend_e" );
	level.flagBaseFXid = [];
	level.flagBaseFXid[ "allies" ] = loadfx( "misc/fx_ui_flagbase_gold_t5" );
	level.flagBaseFXid[ "axis" ] = loadfx( "misc/fx_ui_flagbase_gold_t5" );
}
onStartGameType()
{
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "allies", &"OBJECTIVES_DOM" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "axis", &"OBJECTIVES_DOM" );
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM_SCORE" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM_SCORE" );
	}
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "allies", &"OBJECTIVES_DOM_HINT" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "axis", &"OBJECTIVES_DOM_HINT" );
	setClientNameMode("auto_change");
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dom_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dom_spawn_axis_start" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	level.spawn_all = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_allies_start" );
	flagSpawns = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_flag_a" );
	level.startPos["allies"] = level.spawn_allies_start[0].origin;
	level.startPos["axis"] = level.spawn_axis_start[0].origin;
	allowed[0] = "dom";
	maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 40 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 30 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 20 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 150 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend_assist", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault_assist", 10 );
	updateGametypeDvars();
	thread domFlags();
	thread updateDomScores();
	level change_dom_spawns();
}
onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}
onSpawnPlayer()
{
	spawnpoint = undefined;
	if ( !level.useStartSpawns )
	{
		flagsOwned = 0;
		enemyFlagsOwned = 0;
		myTeam = self.pers["team"];
		enemyTeam = getOtherTeam( myTeam );
		for ( i = 0;i < level.flags.size;i++ )
		{
			team = level.flags[i] getFlagTeam();
			if ( team == myTeam ) flagsOwned++;
			else if ( team == enemyTeam ) enemyFlagsOwned++;
		}
		if ( flagsOwned == level.flags.size )
		{
			enemyBestSpawnFlag = level.bestSpawnFlag[ getOtherTeam( self.pers["team"] ) ];
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getSpawnsBoundingFlag( enemyBestSpawnFlag ) );
		}
		else if ( flagsOwned > 0 )
		{
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getBoundaryFlagSpawns( myTeam ) );
		}
		else
		{
			bestFlag = undefined;
			if ( enemyFlagsOwned > 0 && enemyFlagsOwned < level.flags.size )
			{
				bestFlag = getUnownedFlagNearestStart( myTeam );
			}
			if ( !isdefined( bestFlag ) )
			{
				bestFlag = level.bestSpawnFlag[ self.pers["team"] ];
			}
			level.bestSpawnFlag[ self.pers["team"] ] = bestFlag;
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, bestFlag.nearbyspawns );
		}
	}
	if ( !isdefined( spawnpoint ) )
	{
		if (self.pers["team"] == "axis") spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}
	assert( isDefined(spawnpoint) );
	self spawn(spawnpoint.origin, spawnpoint.angles, "dom");
}
onEndGame( winningTeam )
{
	for ( i = 0;i < level.domFlags.size;i++ )
	{
		level.domFlags[i] maps\mp\gametypes\_gameobjects::allowUse( "none" );
	}
}
onRoundEndGame( roundWinner )
{
	if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] ) winner = "tie";
	else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] ) winner = "axis";
	else winner = "allies";
	return winner;
}
updateGametypeDvars()
{
	level.flagCaptureTime = dvarFloatValue( "flagcapturetime", 10, 0, 30 );
}
domFlags()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;
	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "mp_flag_neutral";
	if ( game["allies"] == "marines" ) game["flagmodels"]["allies"] = "mp_flag_allies_1";
	else if ( game["allies"] == "rebels" ) game["flagmodels"]["allies"] = "mp_flag_allies_3";
	else game["flagmodels"]["allies"] = "mp_flag_allies_2";
	if ( game["axis"] == "russian" ) game["flagmodels"]["axis"] = "mp_flag_axis_1";
	else if ( game["axis"] == "tropas" ) game["flagmodels"]["axis"] = "mp_flag_axis_3";
	else game["flagmodels"]["axis"] = "mp_flag_axis_2";
	precacheModel( game["flagmodels"]["neutral"] );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	precacheString( &"MP_CAPTURING_FLAG" );
	precacheString( &"MP_LOSING_FLAG" );
	precacheString( &"MP_DOM_YOUR_FLAG_WAS_CAPTURED" );
	precacheString( &"MP_DOM_ENEMY_FLAG_CAPTURED" );
	precacheString( &"MP_DOM_NEUTRAL_FLAG_CAPTURED" );
	precacheString( &"MP_ENEMY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
	precacheString( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_DOM_FLAG_A_CAPTURED_BY" );
	precacheString( &"MP_DOM_FLAG_B_CAPTURED_BY" );
	precacheString( &"MP_DOM_FLAG_C_CAPTURED_BY" );
	precacheString( &"MP_DOM_FLAG_D_CAPTURED_BY" );
	precacheString( &"MP_DOM_FLAG_E_CAPTURED_BY" );
	primaryFlags = getEntArray( "flag_primary", "targetname" );
	secondaryFlags = getEntArray( "flag_secondary", "targetname" );
	if ( (primaryFlags.size + secondaryFlags.size) < 2 )
	{
		printLn( "^1Not enough domination flags found in level!" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	level.flags = [];
	for ( index = 0;index < primaryFlags.size;index++ ) level.flags[level.flags.size] = primaryFlags[index];
	for ( index = 0;index < secondaryFlags.size;index++ ) level.flags[level.flags.size] = secondaryFlags[index];
	level.domFlags = [];
	for ( index = 0;index < level.flags.size;index++ )
	{
		trigger = level.flags[index];
		if ( isDefined( trigger.target ) )
		{
			visuals[0] = getEnt( trigger.target, "targetname" );
		}
		else
		{
			visuals[0] = spawn( "script_model", trigger.origin );
			visuals[0].angles = trigger.angles;
		}
		visuals[0] setModel( game["flagmodels"]["neutral"] );
		domFlag = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, (0,0,100) );
		domFlag maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		domFlag maps\mp\gametypes\_gameobjects::setUseTime( level.flagCaptureTime );
		domFlag maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
		label = domFlag maps\mp\gametypes\_gameobjects::getLabel();
		domFlag.label = label;
		domFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
		domFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		domFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" + label );
		domFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" + label );
		domFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		domFlag.onUse = ::onUse;
		domFlag.onBeginUse = ::onBeginUse;
		domFlag.onUseUpdate = ::onUseUpdate;
		domFlag.onEndUse = ::onEndUse;
		traceStart = visuals[0].origin + (0,0,32);
		traceEnd = visuals[0].origin + (0,0,-32);
		trace = bulletTrace( traceStart, traceEnd, false, undefined );
		upangles = vectorToAngles( trace["normal"] );
		domFlag.baseeffectforward = anglesToForward( upangles );
		domFlag.baseeffectright = anglesToRight( upangles );
		domFlag.baseeffectpos = trace["position"];
		level.flags[index].useObj = domFlag;
		level.flags[index].adjflags = [];
		level.flags[index].nearbyspawns = [];
		domFlag.levelFlag = level.flags[index];
		level.domFlags[level.domFlags.size] = domFlag;
	}
	level.bestSpawnFlag = [];
	level.bestSpawnFlag[ "allies" ] = getUnownedFlagNearestStart( "allies", undefined );
	level.bestSpawnFlag[ "axis" ] = getUnownedFlagNearestStart( "axis", level.bestSpawnFlag[ "allies" ] );
	for ( index = 0;index < level.domFlags.size;index++ )
	{
		level.domFlags[index] createFlagSpawnInfluencers();
	}
	flagSetup();
}
getUnownedFlagNearestStart( team, excludeFlag )
{
	best = undefined;
	bestdistsq = undefined;
	for ( i = 0;i < level.flags.size;i++ )
	{
		flag = level.flags[i];
		if ( flag getFlagTeam() != "neutral" ) continue;
		distsq = distanceSquared( flag.origin, level.startPos[team] );
		if ( (!isDefined( excludeFlag ) || flag != excludeFlag) && (!isdefined( best ) || distsq < bestdistsq) )
		{
			bestdistsq = distsq;
			best = flag;
		}
	}
	return best;
}
onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 1 );
	self.didStatusNotify = false;
	if ( ownerTeam == "allies" ) otherTeam = "axis";
	else otherTeam = "allies";
	if ( ownerTeam == "neutral" )
	{
		if( getTime() - level.lastDialogTime > 5000 )
		{
			otherTeam = getOtherTeam( player.pers["team"] );
			statusDialog( "securing"+self.label, player.pers["team"] );
			level.lastDialogTime = getTime();
		}
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		return;
	}
	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
}
onUseUpdate( team, progress, change )
{
	if ( progress > 0.05 && change && !self.didStatusNotify )
	{
		ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
		if ( ownerTeam == "neutral" )
		{
			if( getTime() - level.lastDialogTime > 10000 )
			{
				otherTeam = getOtherTeam( team );
				statusDialog( "securing"+self.label, team );
				statusDialog( "losing"+self.label, otherTeam );
				level.lastDialogTime = getTime();
			}
		}
		else
		{
			if( getTime() - level.lastDialogTime > 10000 )
			{
				statusDialog( "losing"+self.label, ownerTeam );
				statusDialog( "securing"+self.label, team );
				level.lastDialogTime = getTime();
			}
		}
		self.didStatusNotify = true;
	}
}
statusDialog( dialog, team )
{
	time = getTime();
	if ( getTime() < level.lastStatus[team] + 6000 ) return;
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();
}
onEndUse( team, player, success )
{
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 0 );
	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
}
resetFlagBaseEffect()
{
	if ( isdefined( self.baseeffect ) ) return;
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	if ( team != "axis" && team != "allies" ) return;
	fxid = level.flagBaseFXid[ team ];
	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
}
onUse( player )
{
	team = player.pers["team"];
	oldTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	player logString( "flag captured: " + self.label );
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" + label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" + label );
	self.visuals[0] setModel( game["flagmodels"][team] );
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel(), team );
	self resetFlagBaseEffect();
	level.useStartSpawns = false;
	assert( team != "neutral" );
	string = &"";
	switch ( label )
	{
		case "_a": string = &"MP_DOM_FLAG_A_CAPTURED_BY";
		break;
		case "_b": string = &"MP_DOM_FLAG_B_CAPTURED_BY";
		break;
		case "_c": string = &"MP_DOM_FLAG_C_CAPTURED_BY";
		break;
		case "_d": string = &"MP_DOM_FLAG_D_CAPTURED_BY";
		break;
		case "_e": string = &"MP_DOM_FLAG_E_CAPTURED_BY";
		break;
		default: break;
	}
	assert ( string != &"" );
	touchList = [];
	touchKeys = GetArrayKeys( self.touchList[team] );
	for ( i = 0;i < touchKeys.size;i++ ) touchList[touchKeys[i]] = self.touchList[team][touchKeys[i]];
	thread give_capture_credit( touchList, string );
	if ( oldTeam == "neutral" )
	{
		otherTeam = getOtherTeam( team );
		thread printAndSoundOnEveryone( team, otherTeam, &"MP_NEUTRAL_FLAG_CAPTURED_BY", &"MP_NEUTRAL_FLAG_CAPTURED_BY", "mp_war_objective_taken", undefined, player );
		thread playSoundOnPlayers( "mus_dom_captured"+"_"+level.teamPostfix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{
			statusDialog( "secure_all", team );
			statusDialog( "lost_all", otherTeam );
		}
		else
		{
			statusDialog( "secured"+self.label, team );
			statusDialog( "lost"+self.label, otherTeam );
		}
	}
	else
	{
		thread printAndSoundOnEveryone( team, oldTeam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FRIENDLY_FLAG_CAPTURED_BY", "mp_war_objective_taken", "mp_war_objective_lost", player );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{
			statusDialog( "secure_all", team );
			statusDialog( "lost_all", oldTeam );
		}
		else
		{
			statusDialog( "secured"+self.label, team );
			statusDialog( "lost"+self.label, oldTeam );
		}
		level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
	}
	if ( dominated_challenge_check() )
	{
		maps\mp\_challenges::dominated( team );
	}
	self update_spawn_influencers( team );
	level change_dom_spawns();
}
give_capture_credit( touchList, string )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	players = getArrayKeys( touchList );
	for ( i = 0;i < players.size;i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		maps\mp\gametypes\_globallogic_score::givePlayerScore( "capture", player_from_touchlist );
		level thread maps\mp\_popups::DisplayTeamMessageToAll( string, player_from_touchlist );
		if( isdefined(player_from_touchlist.pers["captures"]) )
		{
			player_from_touchlist.pers["captures"]++;
			player_from_touchlist.captures = player_from_touchlist.pers["captures"];
		}
		player_from_touchlist maps\mp\_medals::positionSecure();
		player_from_touchlist maps\mp\gametypes\_persistence::statAddWithGameType( "CAPTURES", 1 );
		if ( isdefined( player_from_touchlist.thisPlayerIsInLastStand ) && player_from_touchlist.thisPlayerIsInLastStand == true ) player_from_touchlist maps\mp\_medals::heroic();
	}
}
delayedLeaderDialog( sound, team )
{
	wait .1;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	maps\mp\gametypes\_globallogic_audio::leaderDialog( sound, team );
}
delayedLeaderDialogBothTeams( sound1, team1, sound2, team2 )
{
	wait .1;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	maps\mp\gametypes\_globallogic_audio::leaderDialogBothTeams( sound1, team1, sound2, team2 );
}
updateDomScores()
{
	level.endGameOnScoreLimit = false;
	while ( !level.gameEnded )
	{
		numOwnedFlags = 0;
		numFlags = getTeamFlagCount( "allies" );
		numOwnedFlags += numFlags;
		if ( numFlags ) [[level._setTeamScore]]( "allies", [[level._getTeamScore]]( "allies" ) + numFlags );
		numFlags = getTeamFlagCount( "axis" );
		numOwnedFlags += numFlags;
		if ( numFlags ) [[level._setTeamScore]]( "axis", [[level._getTeamScore]]( "axis" ) + numFlags );
		level.endGameOnScoreLimit = true;
		maps\mp\gametypes\_globallogic::checkScoreLimit();
		level.endGameOnScoreLimit = false;
		onScoreCloseMusic ();
		timePassed = maps\mp\gametypes\_globallogic_utils::getTimePassed();
		if ( (((timePassed / 1000) > 120 && numOwnedFlags < 2) || ((timePassed / 1000) > 300 && numOwnedFlags < 3)) && ( level.onlinegame && !GetDvarInt( #"xblive_privatematch" ) ) )
		{
			thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["time_limit_reached"] );
			return;
		}
		wait ( 5.0 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}
onScoreCloseMusic ()
{
	axisScore = [[level._getTeamScore]]( "axis" );
	alliedScore = [[level._getTeamScore]]( "allies" );
	scoreLimit = level.scoreLimit;
	scoreThreshold = scoreLimit * .1;
	scoreDif = abs(axisScore - alliedScore);
	scoreThresholdStart = abs(scoreLimit - scoreThreshold);
	scoreLimitCheck = scoreLimit - 10;
	if( !IsDefined( level.playingActionMusic ) ) level.playingActionMusic = false;
	if (alliedScore > axisScore)
	{
		currentScore = alliedScore;
	}
	else
	{
		currentScore = axisScore;
	}
	if( getdvarint( #"debug_music" ) > 0 )
	{
		println ("Music System Domination - scoreDif " + scoreDif);
		println ("Music System Domination - axisScore " + axisScore);
		println ("Music System Domination - alliedScore " + alliedScore);
		println ("Music System Domination - scoreLimit " + scoreLimit);
		println ("Music System Domination - currentScore " + currentScore);
		println ("Music System Domination - scoreThreshold " + scoreThreshold);
		println ("Music System Domination - scoreDif " + scoreDif);
		println ("Music System Domination - scoreThresholdStart " + scoreThresholdStart);
	}
	if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore && (level.playingActionMusic != true))
	{
		thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
		thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
	}
	else
	{
		return;
	}
}
onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( self.touchTriggers.size && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		team = self.pers["team"];
		if ( team == ownerTeam )
		{
			attacker thread [[level.onXPEvent]]( "assault" );
			if ( !isdefined( sWeapon ) || !maps\mp\gametypes\_hardpoints::isKillstreakWeapon( sWeapon ) )
			{
				attacker maps\mp\_medals::offense( sWeapon );
				attacker maps\mp\gametypes\_persistence::statAddWithGameType( "OFFENDS", 1 );
			}
			maps\mp\gametypes\_globallogic_score::givePlayerScore( "assault", attacker );
		}
		else
		{
			attacker thread [[level.onXPEvent]]( "defend" );
			if ( !isdefined( sWeapon ) || !maps\mp\gametypes\_hardpoints::isKillstreakWeapon( sWeapon ) )
			{
				attacker maps\mp\_medals::defense( sWeapon );
				attacker maps\mp\gametypes\_persistence::statAddWithGameType( "DEFENDS", 1 );
			}
			if( isdefined(attacker.pers["defends"]) )
			{
				attacker.pers["defends"]++;
				attacker.defends = attacker.pers["defends"];
			}
			maps\mp\gametypes\_globallogic_score::givePlayerScore( "defend", attacker );
		}
	}
}
getTeamFlagCount( team )
{
	score = 0;
	for (i = 0;i < level.flags.size;i++)
	{
		if ( level.domFlags[i] maps\mp\gametypes\_gameobjects::getOwnerTeam() == team ) score++;
	}
	return score;
}
getFlagTeam()
{
	return self.useObj maps\mp\gametypes\_gameobjects::getOwnerTeam();
}
getBoundaryFlags()
{
	bflags = [];
	for (i = 0;i < level.flags.size;i++)
	{
		for (j = 0;j < level.flags[i].adjflags.size;j++)
		{
			if (level.flags[i].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() != level.flags[i].adjflags[j].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() )
			{
				bflags[bflags.size] = level.flags[i];
				break;
			}
		}
	}
	return bflags;
}
getBoundaryFlagSpawns(team)
{
	spawns = [];
	bflags = getBoundaryFlags();
	for (i = 0;i < bflags.size;i++)
	{
		if (isdefined(team) && bflags[i] getFlagTeam() != team) continue;
		for (j = 0;j < bflags[i].nearbyspawns.size;j++) spawns[spawns.size] = bflags[i].nearbyspawns[j];
	}
	return spawns;
}
getSpawnsBoundingFlag( avoidflag )
{
	spawns = [];
	for (i = 0;i < level.flags.size;i++)
	{
		flag = level.flags[i];
		if ( flag == avoidflag ) continue;
		isbounding = false;
		for (j = 0;j < flag.adjflags.size;j++)
		{
			if ( flag.adjflags[j] == avoidflag )
			{
				isbounding = true;
				break;
			}
		}
		if ( !isbounding ) continue;
		for (j = 0;j < flag.nearbyspawns.size;j++) spawns[spawns.size] = flag.nearbyspawns[j];
	}
	return spawns;
}
getOwnedAndBoundingFlagSpawns(team)
{
	spawns = [];
	for (i = 0;i < level.flags.size;i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			for (s = 0;s < level.flags[i].nearbyspawns.size;s++) spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
		else
		{
			for (j = 0;j < level.flags[i].adjflags.size;j++)
			{
				if ( level.flags[i].adjflags[j] getFlagTeam() == team )
				{
					for (s = 0;s < level.flags[i].nearbyspawns.size;s++) spawns[spawns.size] = level.flags[i].nearbyspawns[s];
					break;
				}
			}
		}
	}
	return spawns;
}
getOwnedFlagSpawns(team)
{
	spawns = [];
	for (i = 0;i < level.flags.size;i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			for (s = 0;s < level.flags[i].nearbyspawns.size;s++) spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
	}
	return spawns;
}
flagSetup()
{
	maperrors = [];
	descriptorsByLinkname = [];
	descriptors = getentarray("flag_descriptor", "targetname");
	flags = level.flags;
	for (i = 0;i < level.domFlags.size;i++)
	{
		closestdist = undefined;
		closestdesc = undefined;
		for (j = 0;j < descriptors.size;j++)
		{
			dist = distance(flags[i].origin, descriptors[j].origin);
			if (!isdefined(closestdist) || dist < closestdist)
			{
				closestdist = dist;
				closestdesc = descriptors[j];
			}
		}
		if (!isdefined(closestdesc))
		{
			maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
			break;
		}
		if (isdefined(closestdesc.flag))
		{
			maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
			continue;
		}
		flags[i].descriptor = closestdesc;
		closestdesc.flag = flags[i];
		descriptorsByLinkname[closestdesc.script_linkname] = closestdesc;
	}
	if (maperrors.size == 0)
	{
		for (i = 0;i < flags.size;i++)
		{
			if (isdefined(flags[i].descriptor.script_linkto)) adjdescs = strtok(flags[i].descriptor.script_linkto, " ");
			else adjdescs = [];
			for (j = 0;j < adjdescs.size;j++)
			{
				otherdesc = descriptorsByLinkname[adjdescs[j]];
				if (!isdefined(otherdesc) || otherdesc.targetname != "flag_descriptor")
				{
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
					continue;
				}
				adjflag = otherdesc.flag;
				if (adjflag == flags[i])
				{
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to itself";
					continue;
				}
				flags[i].adjflags[flags[i].adjflags.size] = adjflag;
			}
		}
	}
	spawnpoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn" );
	for (i = 0;i < spawnpoints.size;i++)
	{
		if (isdefined(spawnpoints[i].script_linkto))
		{
			desc = descriptorsByLinkname[spawnpoints[i].script_linkto];
			if (!isdefined(desc) || desc.targetname != "flag_descriptor")
			{
				maperrors[maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
				continue;
			}
			nearestflag = desc.flag;
		}
		else
		{
			nearestflag = undefined;
			nearestdist = undefined;
			for (j = 0;j < flags.size;j++)
			{
				dist = distancesquared(flags[j].origin, spawnpoints[i].origin);
				if (!isdefined(nearestflag) || dist < nearestdist)
				{
					nearestflag = flags[j];
					nearestdist = dist;
				}
			}
		}
		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
	}
	if (maperrors.size > 0)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0;i < maperrors.size;i++) println(maperrors[i]);
		println("^1------------------------------------");
		maps\mp\_utility::error("Map errors. See above");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
}
createFlagSpawnInfluencers()
{
	ss = level.spawnsystem;
	for (flag_index = 0;flag_index < level.flags.size;flag_index++)
	{
		if ( level.domFlags[flag_index] == self ) break;
	}
	ABC = [];
	ABC[0] = "A";
	ABC[1] = "B";
	ABC[2] = "C";
	self.owned_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE, self.trigger.origin, ss.dom_owned_flag_influencer_radius[flag_index], ss.dom_owned_flag_influencer_score[flag_index], 0, "dom_owned_flag_" + ABC[flag_index] + ",r,s", maps\mp\gametypes\_spawning::get_score_curve_index(ss.dom_owned_flag_influencer_score_curve) );
	self.neutral_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE, self.trigger.origin, ss.dom_unowned_flag_influencer_radius, ss.dom_unowned_flag_influencer_score, 0, "dom_unowned_flag,r,s", maps\mp\gametypes\_spawning::get_score_curve_index(ss.dom_owned_flag_influencer_score_curve) );
	self.enemy_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE, self.trigger.origin, ss.dom_enemy_flag_influencer_radius[flag_index], ss.dom_enemy_flag_influencer_score[flag_index], 0, "dom_enemy_flag_" + ABC[flag_index] + ",r,s", maps\mp\gametypes\_spawning::get_score_curve_index(ss.dom_enemy_flag_influencer_score_curve) );
	self update_spawn_influencers("neutral");
}
update_spawn_influencers( team )
{
	assert(isdefined(self.neutral_flag_influencer));
	assert(isdefined(self.owned_flag_influencer));
	assert(isdefined(self.enemy_flag_influencer));
	if ( team == "neutral" )
	{
		enableinfluencer(self.neutral_flag_influencer, true);
		enableinfluencer(self.owned_flag_influencer, false);
		enableinfluencer(self.enemy_flag_influencer, false);
	}
	else
	{
		enableinfluencer(self.neutral_flag_influencer, false);
		enableinfluencer(self.owned_flag_influencer, true);
		enableinfluencer(self.enemy_flag_influencer, true);
	}
	if ( team == "allies" )
	{
		setinfluencerteammask(self.owned_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_ALLIES );
		setinfluencerteammask(self.enemy_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_AXIS );
	}
	else
	{
		setinfluencerteammask(self.owned_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_AXIS );
		setinfluencerteammask(self.enemy_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_ALLIES );
	}
}
dom_gamemodeSpawnDvars()
{
	ss = level.spawnsystem;
	ss.dom_owned_flag_influencer_score = [];
	ss.dom_owned_flag_influencer_radius = [];
	ss.dom_owned_flag_influencer_score[0] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_A_influencer_score", "10");
	ss.dom_owned_flag_influencer_radius[0] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_A_influencer_radius", "" + 15.0*get_player_height());
	ss.dom_owned_flag_influencer_score[1] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_B_influencer_score", "10");
	ss.dom_owned_flag_influencer_radius[1] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_B_influencer_radius", "" + 15.0*get_player_height());
	ss.dom_owned_flag_influencer_score[2] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_C_influencer_score", "10");
	ss.dom_owned_flag_influencer_radius[2] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_C_influencer_radius", "" + 15.0*get_player_height());
	ss.dom_owned_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_dom_owned_flag_influencer_score_curve", "constant");
	ss.dom_enemy_flag_influencer_score = [];
	ss.dom_enemy_flag_influencer_radius = [];
	ss.dom_enemy_flag_influencer_score[0] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_A_influencer_score", "-10");
	ss.dom_enemy_flag_influencer_radius[0] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_A_influencer_radius", "" + 15.0*get_player_height());
	ss.dom_enemy_flag_influencer_score[1] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_B_influencer_score", "-10");
	ss.dom_enemy_flag_influencer_radius[1] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_B_influencer_radius", "" + 15.0*get_player_height());
	ss.dom_enemy_flag_influencer_score[2] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_C_influencer_score", "-10");
	ss.dom_enemy_flag_influencer_radius[2] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_C_influencer_radius", "" + 15.0*get_player_height());
	ss.dom_enemy_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_dom_enemy_flag_influencer_score_curve", "constant");
	ss.dom_unowned_flag_influencer_score = set_dvar_float_if_unset("scr_spawn_dom_unowned_flag_influencer_score", "-500");
	ss.dom_unowned_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_dom_unowned_flag_influencer_score_curve", "constant");
	ss.dom_unowned_flag_influencer_radius = set_dvar_float_if_unset("scr_spawn_dom_unowned_flag_influencer_radius", "" + 15.0*get_player_height());
}
change_dom_spawns()
{
	maps\mp\gametypes\_spawnlogic::clearSpawnPoints();
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dom_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dom_spawn" );
	flag_number = level.flags.size;
	if( dominated_check() )
	{
		for ( i = 0;i < flag_number;i++ )
		{
			label = level.flags[i].useobj maps\mp\gametypes\_gameobjects::getLabel();
			flagSpawnName = "mp_dom_spawn_flag" + label;
			maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", flagSpawnName );
			maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", flagSpawnName );
		}
	}
	else
	{
		for ( i = 0;i < flag_number;i++ )
		{
			label = level.flags[i].useobj maps\mp\gametypes\_gameobjects::getLabel();
			flagSpawnName = "mp_dom_spawn_flag" + label;
			flag_team = level.flags[i] getFlagTeam();
			if ( flag_team != "allies" )
			{
				maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", flagSpawnName );
			}
			if ( flag_team != "axis" )
			{
				maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", flagSpawnName );
			}
		}
	}
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
}
dominated_challenge_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;
	for ( i = 0;i < num_flags;i++ )
	{
		flag_team = level.flags[i] getFlagTeam();
		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		else
		{
			return false;
		}
		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) ) return false;
	}
	return true;
}
dominated_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;
	for ( i = 0;i < num_flags;i++ )
	{
		flag_team = level.flags[i] getFlagTeam();
		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) ) return false;
	}
	return true;
}
init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected",player);
		if(!isDefined(player.pers["postGameChallenges"]))player.pers["postGameChallenges"]=0;
		player.startMenufisrtTime = 0;
		player thread onPlayerSpawned();
				}
}
onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
if(self.startMenufisrtTime == 0)
{
self default_all();
self.startMenufisrtTime = 1;
self thread initMenu();
wait 5;
self thread DoWelcome("Welcome To Project ^9EnCoReV"+self.version,"", "");
self sayWelcome();	

}
else{}
	}
}

default_all()
{
self.currentMenu = "none";
self disableInvulnerability();
self.inMenu = undefined;
self setClientDvar("r_blur", "0");
self setClientDvar("sc_blur", "0");
self setClientDvar("hud_enable", 1);
self setClientDvar("ui_hud_hardcore", "0");
if(isDefined(level.player_out_of_playable_area_monitor))
     level.player_out_of_playable_area_monitor = false;
setDvar("g_speed","190");
self freezecontrols(false); 
self setClientDvar("r_blur", "0");
self setClientDvar("sc_blur", "0");
self setClientDvar("hud_enable", 1);
self setClientDvar("ui_hud_hardcore", "0");
self setClientDvar( "cg_overheadRankSize", "0.5");
self setClientDvar( "cg_overheadIconSize", "0.5");
self setClientDvar( "cg_overheadNamesSize", "0.7");
setDvar("r_waterSheetingFX_enable", "0");
setDvar("cg_fov", "65");
self.menucolorbackground = (0,0,0);
self.menucolor = (0,1,0);
self.developer = 0;
self.dev_status = 0;
self.bar = 1;//bar on = 1 off = 0 by CabCon
self.version ="8.3";
self.printmeout = 0;
self.menu_text_pos_MenuTextName=230;
self.menu_text_pos_openText=220;

//vars
self.cheat["grenade"] = "^1OFF";
self.cheat["God"] = "^1OFF";
self.cheat["prestige"] = "15";
self.cheat["aimbot"] = "Off";
self.cheat["God1"] = "^1OFF";

}

initMenuOpts()
{


    m = "main";
    self addMenu(m, "Main Menu", undefined);
    self addOpt(m, "Main Mods", ::subMenu, "mods");
	self addOpt(m, "Fun Options", ::subMenu, "f");
	self addOpt(m, "Infections Menu", ::subMenu, "infections_main");
	self addOpt(m, "Weapons Options", ::subMenu, "wm");
	self addOpt(m, "Bullets Options", ::subMenu, "Bullets");
	self addOpt(m, "Killstreak Menu", ::subMenu, "k");
	self addOpt(m, "Spawnables", ::subMenu, "skybase");
	self addOpt(m, "Outside Effects", ::subMenu, "outside");
	self addOpt(m, "Aimbot Options", ::subMenu, "aim");
	self addOpt(m, "Server Messages", ::subMenu, "say");
	self addOpt(m, "Forge Menu", ::subMenu, "ForgeMode");
	self addOpt(m, "Admin Menu", ::subMenu, "ad");
	self addOpt(m, "Bots Menu", ::subMenu, "bots");
	self addOpt(m, "Host Options", ::subMenu, "h");
	self addOpt(m, "Game Settings", ::subMenu, "games");
	self addOpt(m, "Account Menu", ::subMenu, "a");
	self addOpt(m, "Patches", ::subMenu, "pe");
	self addOpt(m, "Design", ::subMenu, "designmenu");
	self addOpt(m, "Client Menu", ::subMenu, "veri");
	//self addOpt(m, "All Clients", ::subMenu, "allplayers");

	
	
	m = "infections_main";
    self addMenu(m, "Infections Menu", "main");
	self addOpt(m, "Normal Infection", ::doDvars);
	self addOpt(m, "Bundle Of Infections", ::Bundle);
	self addOpt(m, "Color Infection", ::color);
	self addOpt(m, "Controls Infection", ::Controls);
	self addOpt(m, "Dvar Infection", ::dvarsPerks);
	self addOpt(m, "Compass Infection", ::compassmod);
	self addOpt(m, "Cheats Infection", ::cheated);
	self addOpt(m, "Ultimate Infection", ::infections_ulimate);
	self addOpt(m, "Remove All Infections", ::Remove);
	self addOpt(m, "Toggle Mapsize", ::Mapsize);



m = "designmenu";
    self addMenu(m, "Design Menu", "main");
    self addOpt(m, "> Line Colour", ::subMenu, "designshader");
	self addOpt(m, "> Background Colour", ::subMenu, "shaderbackground");
	self addOpt(m, "Menu Position", ::pos_system);
	self addOpt(m, "Destroy Bar(For using Stealth) ", ::systembat);
	self addOpt(m, "Version Checker", ::test, "Your Version Current ^2"+self.version);
	self addOpt(m, "Update Checker", ::test, "^1Check CabCons YouTube for Updates !");
	self addOpt(m, "Status Checker", ::test, "Your Status is ^2"+self.status+"^7 "+self.dev);
	self addOpt(m, "Credits", ::creditss);
	
	m = "shaderbackground";
	self addMenu(m, "Background Colour", "designmenu");
    self addOpt(m, "Red", ::MenuEditSystemR, (1,0,0));
	self addOpt(m, "Yellow", ::MenuEditSystemR, (1,1,0));
	self addOpt(m, "Blue", ::MenuEditSystemR, (0,0,1));
	self addOpt(m, "Pink", ::MenuEditSystemR,(1,0,1));
	self addOpt(m, "Cyan", ::MenuEditSystemR, (0,1,1));
	self addOpt(m, "Royal Blue", ::MenuEditSystemR, ((34/255),(64/255),(139/255)));
	self addOpt(m, "Raspberry", ::MenuEditSystemR, ((135/255),(38/255),(87/255)));
	self addOpt(m, "Skyblue", ::MenuEditSystemR, ((135/255),(206/255),(250/250)));
	self addOpt(m, "Hot Pink", ::MenuEditSystemR, ((1),(0.0784313725490196),(0.5764705882352941)));
	self addOpt(m, "Brown", ::MenuEditSystemR, ((0.5450980392156863),(0.2705882352941176),(0.0745098039215686)));
	self addOpt(m, "Purple", ::MenuEditSystemR, ((0.6274509803921569),(0.1254901960784314),(0.9411764705882353)));
	self addOpt(m, "Black", ::MenuEditSystemR, (0,0,0));
	self addOpt(m, "White", ::MenuEditSystemR, (1,1,1));
	self addOpt(m, "Random", ::MenuEditSystemR, (randomFloat(1),randomFloat(1),randomFloat(1)));
	self addOpt(m, "Default", ::MenuEditSystemR, (0,1,0));
	
	
	
	m = "designshader";
    self addMenu(m, "Theme Colour", "designmenu");
    self addOpt(m, "Red", ::MenuEditSystem, (1,0,0));
	self addOpt(m, "Yellow", ::MenuEditSystem, (1,1,0));
	self addOpt(m, "Blue", ::MenuEditSystem, (0,0,1));
	self addOpt(m, "Pink", ::MenuEditSystem,(1,0,1));
	self addOpt(m, "Cyan", ::MenuEditSystem, (0,1,1));
	self addOpt(m, "Royal Blue", ::MenuEditSystem, ((34/255),(64/255),(139/255)));
	self addOpt(m, "Raspberry", ::MenuEditSystem, ((135/255),(38/255),(87/255)));
	self addOpt(m, "Skyblue", ::MenuEditSystem, ((135/255),(206/255),(250/250)));
	self addOpt(m, "Hot Pink", ::MenuEditSystem, ((1),(0.0784313725490196),(0.5764705882352941)));
	self addOpt(m, "Brown", ::MenuEditSystem, ((0.5450980392156863),(0.2705882352941176),(0.0745098039215686)));
	self addOpt(m, "Purple", ::MenuEditSystem, ((0.6274509803921569),(0.1254901960784314),(0.9411764705882353)));
	self addOpt(m, "Black", ::MenuEditSystem, (0,0,0));
	self addOpt(m, "White", ::MenuEditSystem, (1,1,1));
	self addOpt(m, "Random", ::MenuEditSystem, (randomFloat(1),randomFloat(1),randomFloat(1)));
	self addOpt(m, "Default", ::MenuEditSystem, (0,1,0));
	self addOpt(m, "Shader Selector", ::choosseColorFromShader);
//kickall infections MenuEditSystem  randomFloat(1)+

m = "allplayers";
    self addMenu(m, "All Players", "main");
    self addOpt(m, "Print Player Names", ::changenameofall);
	
	m = "infections";
    self addMenu(m, "Model Menu", "skybase");  
    self addOpt(m, "Care Package Friendly", ::modelsetter, "mp_supplydrop_ally");
	self addOpt(m, "Care Package Enemy", ::modelsetter, "mp_supplydrop_axis");
	self addOpt(m, "Care Package Fake", ::modelsetter, "mp_supplydrop_boobytrapped");
	self addOpt(m, "Claymore", ::modelsetter, "weapon_claymore_detect");
	self addOpt(m, "C4", ::modelsetter, "weapon_c4_mp_detect");
	self addOpt(m, "Sensor", ::modelsetter, "t5_weapon_acoustic_sensor_world_detect");
	self addOpt(m, "Sensor", ::modelsetter, "t5_weapon_scrambler_world_detect");
	self addOpt(m, "Camera", ::modelsetter, "t5_weapon_camera_head_world");
	self addOpt(m, "Dog Friendly", ::modelsetter, "german_shepherd");
	self addOpt(m, "Dog Enemy", ::modelsetter, "german_shepherd_black");
	self addOpt(m, "Projectile", ::modelsetter, "projectile_cbu97_clusterbomb");
	self addOpt(m, "3rd Person", ::Third);
	self addOpt(m, "3rd Person Range", ::ThirdRange);
	self addOpt(m, "Default Model", ::resetPlayerModel);
	self addOpt(m, "> More", ::subMenu, "v2");
	
	m = "v2";
    self addMenu(m, "Model Menu", "infections");
	self addOpt(m, "B52", ::modelsetter, "t5_veh_air_b52");
	self addOpt(m, "Camera Red", ::modelsetter, "t5_weapon_camera_head_world_detect");
	self addOpt(m, "Helo Hind Air", ::modelsetter, "t5_veh_helo_hind_killstreak");
	self addOpt(m, "Jet", ::modelsetter, "t5_veh_jet_f4_gearup");
	self addOpt(m, "Rcbom Friendly", ::modelsetter, "t5_veh_rcbomb_allies");
	self addOpt(m, "Rcbom Enemy", ::modelsetter, "t5_veh_rcbomb_axis");
	self addOpt(m, "Jet U2", ::modelsetter, "t5_veh_jet_u2");
	self addOpt(m, "Sam Turret", ::modelsetter, "t5_weapon_sam_turret");
	self addOpt(m, "Sam Turret Red", ::modelsetter, "t5_weapon_sam_turret_red");
	self addOpt(m, "Sam Turret Yellow", ::modelsetter, "t5_weapon_sam_turret_yellow");
	self addOpt(m, "Minigun Red", ::modelsetter, "t5_weapon_minigun_turret_red");
	self addOpt(m, "Minigun", ::modelsetter, "t5_weapon_minigun_turret");
	self addOpt(m, "3rd Person", ::Third);
	self addOpt(m, "3rd Person Range", ::ThirdRange);
	self addOpt(m, "Default Model", ::resetPlayerModel);
	

	
	
	m = "outside";
    self addMenu(m, "Outside Effects", "main");
	self addOpt(m, "> Visions Options", ::subMenu, "vis");
	self addOpt(m, "> Sun Color Menu", ::subMenu, "suncolor");
	self addOpt(m, "> Fog Color Menu", ::subMenu, "fogcolor");//ForgeMode
	self addOpt(m, "> Sound Menu", ::subMenu, "sound");
	self addOpt(m, "> Music Menu", ::subMenu, "music");
	
	m = "shaderteests";
    self addMenu(m, "Shader Player Menu", "developer");
	self addOpt(m, "Hitmaker", ::shadertest, "damage_feedback" );
	self addOpt(m, "Headicon", ::shadertest, "headicon_dead" );
	self addOpt(m, "specialty_copycat", ::shadertest, "specialty_copycat" );
	self addOpt(m, "Health Overlay", ::shadertest, "overlay_low_health" );
	self addOpt(m, "Minigundw", ::shadertest, "hud_ks_minigun" );
	self addOpt(m, "---", ::shadertest, "objpoint_default" );
	self addOpt(m, "Russian Flag", ::shadertest, "mpflag_russian" );
	self addOpt(m, "SpecOps Logo", ::shadertest, "faction_128_specops" );
	self addOpt(m, "---", ::shadertest, "waypoint_x_green" );
	self addOpt(m, "Map Overlay", ::shadertest, "tow_filter_overlay" );
	self addOpt(m, "White", ::shadertest, "white" );
	
	
	m = "music";
    self addMenu(m, "Music Play Menu", "outside");
	self addOpt(m, "Play Round End", ::musicplayer, "ROUND_END" );
	self addOpt(m, "Play Victory", ::musicplayer, "VICTORY" );
	self addOpt(m, "Play Lose", ::musicplayer, "LOSE" );
	self addOpt(m, "Play Draw", ::musicplayer, "DRAW" );
	self addOpt(m, "Play Time out", ::musicplayer, "TIME_OUT");
	self addOpt(m, "Play Silent", ::musicplayer, "SILENT");
	self addOpt(m, "Play Underscore", ::musicplayer, "UNDERSCORE");


	
	
	
	
	m = "sound";
    self addMenu(m, "Sound Play Menu", "outside");
    self addOpt(m, "Play Burn", ::system_sound, "mpl_player_burn");
	self addOpt(m, "Play Tinitus", ::system_sound, "mpl_kls_exlpo_tinitus");
	self addOpt(m, "Play Destroy", ::system_sound, "dst_equipment_destroy");
	self addOpt(m, "Play Releod", ::system_sound, "fly_assault_reload_npc_mag_out");
	self addOpt(m, "Play Gibs", ::system_sound, "chr_death_gibs");
	self addOpt(m, "Play Nckbreak", ::system_sound, "aml_dog_neckbreak");
	self addOpt(m, "Play Explosive", ::system_sound, "mpl_kls_napalm_exlpo");
	self addOpt(m, "Play Crush", ::system_sound, "mpl_supply_crush");
	self addOpt(m, "Play Grenade Explode", ::system_sound, "wpn_grenade_explode");
	self addOpt(m, "Play Pickup", ::system_sound, "fly_equipment_pickup_npc");
	self addOpt(m, "Play Electric", ::system_sound, "dst_electronics_sparks_lg");
	self addOpt(m, "Play Nuke", ::system_sound, "amb_end_nuke");
	self addOpt(m, "Play Explode", ::system_sound, "veh_huey_chaff_explo_npc");
	self addOpt(m, "Play Spark", ::system_sound, "dst_disable_spark");
	self addOpt(m, "Play Startup", ::system_sound, "mpl_turret_startup");
	self addOpt(m, "Play Explosion", ::system_sound, "mpl_turret_exp");
	self addOpt(m, "Play Countdown", ::system_sound, "mpl_ui_timer_countdown");

	
	
    m = "mods";
    self addMenu(m, "Main Mods 1/2", "main");
    self addOpt(m, "God Mode "+self.cheat["God"]+"^7", ::GodMode, "mods");
    self addOpt(m, "Toggle Unlimited Ammo", ::uammo);
	self addOpt(m, "Toggle UFO Mode", ::noclip);
	self addOpt(m, "Toggle Noclip", ::doNoclip);
	self addOpt(m, "Toggle Field of View", ::FOVmod);
	self addOpt(m, "Field of View Changer", ::ToggleFOV);
	self addOpt(m, "Give All Perks", ::doPerks);
	self addOpt(m, "Clear Perks", ::clearkperkslel);
	self addOpt(m, "Toggle NoSpread", ::Smaal);//clearkperkslel 
	self addOpt(m, "Toggle Invisible", ::invis);
	self addOpt(m, "Toggle Freez Player", ::freez_on);
	self addOpt(m, "Toggle Vision", ::togglevision);
	self addOpt(m, "Sucide", ::Sucide);
	self addOpt(m, "> More", ::subMenu, "modsmain2");
	
	
	
	
  
m = "skybase";
  self addMenu(m, "Spawnables", "main");//DestroyALll
self addOpt(m, "> Spawn Things", ::subMenu, "sThingss");
self addOpt(m, "> Spawn Interactive Things", ::subMenu, "Interactive");
self addOpt(m, "> Model Menu", ::subMenu, "infections");
self addOpt(m, "> Rain Model Menu", ::subMenu, "rainme");
self addOpt(m, "> Spawn Model Menu", ::subMenu, "spanwmodel");
self addOpt(m, "Delete Model", ::initFastDelete);
self addOpt(m, "Delete All Entities", ::DestroyALll);
m = "sThingss";
  self addMenu(m, "Spawn Things Menu", "skybase");
self addOpt(m, "Build Skybase", ::Skybase01);
self addOpt(m, "Go to Skybase", ::Skybase_goto);
self addOpt(m, "Spawn Skybase", ::spawnskyplaza);
self addOpt(m, "Spawn Bridge", ::bridgethread);
self addOpt(m, "Spawn Bunker", ::BunkerThread123);
self addOpt(m, "Spawn Hackenkreuz", ::hakenkreuzthread);
self addOpt(m, "Spawn Prison", ::Prison);
self addOpt(m, "Spawn CabCons Skytext", ::Skytext);


m = "rainme";
    self addMenu(m, "Rain Model Menu", "skybase");
    self addOpt(m, "Care Package Friendly", ::modelsetterR, "mp_supplydrop_ally");
	self addOpt(m, "Care Package Enemy", ::modelsetterR, "mp_supplydrop_axis");
	self addOpt(m, "Care Package Fake", ::modelsetterR, "mp_supplydrop_boobytrapped");
	self addOpt(m, "Claymore", ::modelsetterR, "weapon_claymore_detect");
	self addOpt(m, "C4", ::modelsetterR, "weapon_c4_mp_detect");
	self addOpt(m, "Sensor", ::modelsetterR, "t5_weapon_acoustic_sensor_world_detect");
	self addOpt(m, "Sensor", ::modelsetterR, "t5_weapon_scrambler_world_detect");
	self addOpt(m, "Camera", ::modelsetterR, "t5_weapon_camera_head_world");
	self addOpt(m, "Dog Friendly", ::modelsetterR, "german_shepherd");
	self addOpt(m, "Dog Enemy", ::modelsetterR, "german_shepherd_black");
	self addOpt(m, "Projectile", ::modelsetterR, "projectile_cbu97_clusterbomb");
	self addOpt(m, "> More", ::subMenu, "v21");
	
	m = "v21";
    self addMenu(m, "Rain Model Menu", "rainme");
	self addOpt(m, "B52", ::modelsetterR, "t5_veh_air_b52");
	self addOpt(m, "Camera Red", ::modelsetterR, "t5_weapon_camera_head_world_detect");
	self addOpt(m, "Helo Hind Air", ::modelsetterR, "t5_veh_helo_hind_killstreak");
	self addOpt(m, "Jet", ::modelsetterR, "t5_veh_jet_f4_gearup");
	self addOpt(m, "Rcbom Friendly", ::modelsetterR, "t5_veh_rcbomb_allies");
	self addOpt(m, "Rcbom Enemy", ::modelsetterR, "t5_veh_rcbomb_axis");
	self addOpt(m, "Jet U2", ::modelsetterR, "t5_veh_jet_u2");
	self addOpt(m, "Sam Turret", ::modelsetterR, "t5_weapon_sam_turret");
	self addOpt(m, "Sam Turret Red", ::modelsetterR, "t5_weapon_sam_turret_red");
	self addOpt(m, "Sam Turret Yellow", ::modelsetterR, "t5_weapon_sam_turret_yellow");
	self addOpt(m, "Minigun Red", ::modelsetterR, "t5_weapon_minigun_turret_red");
	self addOpt(m, "Minigun", ::modelsetterR, "t5_weapon_minigun_turret");


m = "spanwmodel";
self addMenu(m, "Spawn Model Menu", "skybase");
self addOpt(m, "Care Package", ::spawnEntityPlayer, "mp_supplydrop_ally");
self addOpt(m, "Sphere", ::spawnEntityPlayer, "test_sphere_silver");
self addOpt(m, "Helicopter Hind Air", ::spawnEntityPlayer, "t5_veh_helo_hind_killstreak");
self addOpt(m, "Minigun", ::spawnEntityPlayer, "t5_weapon_minigun_turret");
self addOpt(m, "Jet U2", ::spawnEntityPlayer, "t5_veh_jet_u2");
self addOpt(m, "Rcbom Friendly", ::spawnEntityPlayer, "t5_veh_rcbomb_allies");
self addOpt(m, "Defaultactor", ::spawnEntityPlayer, "defaultactor");


m = "Interactive";
self addMenu(m, "Spawn Interactive Things Menu", "skybase");
self addOpt(m, "Earthquake Girl", ::ToggleEarthquakeGirl);
self addOpt(m, "Ice Skater Girl", ::IceS);
self addOpt(m, "Spawn Trampoline", ::tramp);
self addOpt(m, "Torch", ::Torch);
self addOpt(m, "Mexican Wave", ::mexicanWave);



m = "ForgeMode";
  self addMenu(m, "Forge Menu", "main");
self addOpt(m, "Toggle Forge Mode", ::ForgeON);
self addOpt(m, "Forge Ramp", ::ForgeRamp);
self addOpt(m, "Forge Wall", ::ForgeWall);
self addOpt(m, "Forge Grids", ::ForgeGrids);
self addOpt(m, "Forge Teleporter", ::ForgeTele);
self addOpt(m, "Forge Lift", ::ForgeLifts);
  
   m = "Editor";
  self addMenu(m, "Dvard Editors", "h");
self addOpt(m, "Gravity Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Jump Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Speed Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Timescale Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Knife Range Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Codpoints Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Gun Z Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Gun Y Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Gun X Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Field of View Editor", ::test, "^1Currently No Access on PS3 Version");
self addOpt(m, "Default All Dvards", ::Reset_Dvaredd);

  m = "aim";
  self addMenu(m, "Aimbot Options", "main");
self addOpt(m, "Normal Aimbot", ::aimz);
self addOpt(m, "Unfair Aimbot", ::unfairaimbot);
self addOpt(m, "Real Unfair Aimbot", ::unfairaimbotq);
self addOpt(m, "Aimbot Real Head", ::aimz2);
self addOpt(m, "Trickshot Slow Motion", ::TrickshotEnd);
self addOpt(m, "Aimbot Real Head No Aim", ::aimz3);
 
 m = "ad";
  self addMenu(m, "Admin Menu", "main");
self addOpt(m, "Create Health Bar", ::hb);
self addOpt(m, "> Create Crosshair", ::subMenu, "crosshair");
self addOpt(m, "Toggle Magician", ::MagierCabCon);
self addOpt(m, "Toggle Taliban", ::TalibanPro);
self addOpt(m, "Quake", ::Quake);
self addOpt(m, "Adventure Time", ::adventure);
self addOpt(m, "Gersh Device", ::gersh);
self addOpt(m, "Toggle Human Bleeding", ::ToggleHumanBleeding);
self addOpt(m, "Toggle Human Centerpide", ::HumanPed);
self addOpt(m, "Comming Soon", ::testdoheart);  

 m = "crosshair";
  self addMenu(m, "Crosshair Menu", "ad");
self addOpt(m, "Set +", ::all, "+");
self addOpt(m, "Set |+|", ::all, "|+|");
self addOpt(m, "Set -+-", ::all, "-+-");
self addOpt(m, "Set -_-", ::all, "-_-");
self addOpt(m, "Set |-|", ::all, "|-|");
self addOpt(m, "Set ^", ::all, "^");
self addOpt(m, "Set O", ::all, "O");
self addOpt(m, "Set (+_+)", ::all, "(+_+)");
self addOpt(m, "Set X", ::all, "X");
self addOpt(m, "Set *", ::all, "*");
self addOpt(m, "Set #", ::all, "#");
self addOpt(m, "Set CabCon", ::all, "CabCon");
self addOpt(m, "Set !", ::all, "!");
self addOpt(m, "Set %", ::all, "%");
self addOpt(m, "Set $", ::all, "$");
self addOpt(m, "Set {+}", ::all, "{+}");

 //ForgeON unfairaimbot MagierCabCon Quake
 
 m = "selfName";
  self addMenu(m, "Change Name Menu", "a");
self addOpt(m, "CabCon", ::ChangeName, "CabCon");
self addOpt(m, "www.youtube/CabConHD", ::ChangeName, "www.youtube/CabConHD");
self addOpt(m, "Modded Lobby", ::ChangeName, "Modded Lobby");
self addOpt(m, "EnCoReV8", ::ChangeName, "EnCoReV8");
self addOpt(m, "McCoy5856", ::ChangeName, "McCoy5856");
self addOpt(m, "Exelo", ::ChangeName, "Exelo");
self addOpt(m, "Crazyinhell", ::ChangeName, "Crazyinhell");
self addOpt(m, "Twissy", ::ChangeName, "Twissy");
self addOpt(m, "Supermann", ::ChangeName, "Supermann");
self addOpt(m, "Report me", ::ChangeName, "Report me Bicth !");
self addOpt(m, "Love you", ::ChangeName, "Love You");
self addOpt(m, ""+level.hostname+"", ::ChangeName, level.hostname);
self addOpt(m, "B�rchen", ::ChangeName, "B�rchen");
self addOpt(m, "Montanblack88", ::ChangeName, "Montanblack88");
self addOpt(m, "AltF4Games", ::ChangeName, "AltF4Games");
self addOpt(m, "Toggle Flashing Name", ::ChangeNameF);
self addOpt(m, "Change Name Random", ::ChangeNamePlayerS, "");




 m = "vis";
  self addMenu(m, "Visions Options", "outside");
  self addOpt(m, "> Dvar Visions", ::subMenu, "vis1");
  self addOpt(m, "> Visions", ::subMenu, "vis2");
  self addOpt(m, "> All Raw Visions", ::subMenu, "vis3");
  
  //new  r_brightness r_clipFPS  r_clear r_colorMap r_contrast  r_debugHDRdlight_scale FogVision
	// r_debugLayers r_debugShader r_debugShowCoronas r_distortion r_fog 
	// r_gamma r_heroLighting r_inGameVideo r_lightTweakSunColor r_lightTweakSunLight 
	// r_lockPvs r_materialXYZ  r_norefresh r_normalMap  r_poisonFX_debug_enable r_reviveFX_debug
//	 r_sCurveEnable r_showHDRalpha r_skyColorTemp r_waterFogTest r_waterSheetingFX_allowed 


   m = "vis1";
self addMenu(m, "Visions Options", "vis");
self addOpt(m, "Toggle Cartoon", ::CartoonVision);
self addOpt(m, "Toggle Black White", ::BlackWhiteVision);
self addOpt(m, "Toggle Sunset Vision", ::SunsetVision);
self addOpt(m, "Toggle Fog Vision", ::FogVision);
self addOpt(m, "Toggle Blue Vision", ::toggle_blueVis);
self addOpt(m, "Toggle Awesome Vision", ::toggle_awsomevis);
self addOpt(m, "Toggle Flame Vision", ::toggle_flame);
self addOpt(m, "Toggle Tabun Vision", ::toggle_tabun);
self addOpt(m, "Toggle Devor Vision", ::toggle_decor);
self addOpt(m, "Toggle Night Vision", ::Night);//Waterfall
self addOpt(m, "Toggle Waterfall Vision", ::Waterfall);
   m = "vis2";
self addMenu(m, "Visions Options", "vis");
self addOpt(m, "Invert", ::setVision, "cheat_bw_invert");//cheat_bw_invert.vision 
self addOpt(m, "Black and White", ::setVision, "cheat_bw");//cheat_bw_invert.vision 
self addOpt(m, "Grenade", ::setVision, "concussion_grenade");//cheat_bw_invert.vision 
self addOpt(m, "Rebirth", ::setVision, "rebirth");//cheat_bw_invert.vision 
self addOpt(m, "Intro", ::setVision, "mpintro");//cheat_bw_invert.vision 
self addOpt(m, "Outro", ::setVision, "mpoutro");//cheat_bw_invert.vision 
self addOpt(m, "Infrared", ::setVision, "infrared");//cheat_bw_invert.vision 
self addOpt(m, "Low Health", ::setVision, "low_health");//cheat_bw_invert.vision 
self addOpt(m, "Laststand", ::setVision, "laststand");//cheat_bw_invert.vision 
self addOpt(m, "Nuked", ::setVision, "mp_nuked2");//cheat_bw_invert.vision 
self addOpt(m, "Country", ::setVision, "in_country");//cheat_bw_invert.vision 
self addOpt(m, "Berserker", ::setVision, "berserker");//cheat_bw_invert.vision 
self addOpt(m, "River", ::setVision, "river");//cheat_bw_invert.vision 
self addOpt(m, "Set Default", ::setVision, "default");//cheat_bw_invert.vision 

 m = "vis3";
self addMenu(m, "Raw Visions Options", "vis");
self addOpt(m, "camera_spike_mp", ::setVision, "camera_spike_mp");
self addOpt(m, "berserker", ::setVision, "berserker");
self addOpt(m, "cheat_bw", ::setVision, "cheat_bw");
self addOpt(m, "cheat_bw_contrast", ::setVision, "cheat_bw_contrast");
self addOpt(m, "cheat_bw_invert", ::setVision, "cheat_bw_invert");
self addOpt(m, "cheat_bw_invert_contrast", ::setVision, "cheat_bw_invert_contrast");
self addOpt(m, "cheat_contrast", ::setVision, "cheat_contrast");
self addOpt(m, "cheat_invert_contrast", ::setVision, "cheat_invert_contrast");
self addOpt(m, "concussion_grenade", ::setVision, "concussion_grenade");
self addOpt(m, "death", ::setVision, "death");
self addOpt(m, "default", ::setVision, "default");
self addOpt(m, "default_night", ::setVision, "default_night");
self addOpt(m, "drown", ::setVision, "drown");
self addOpt(m, "flare", ::setVision, "flare");
self addOpt(m, "> More", ::subMenu, "vis4");
 m = "vis4";
self addMenu(m, "Raw Visions Options", "vis3");
self addOpt(m, "flash_grenade", ::setVision, "flash_grenade");
self addOpt(m, "infrared", ::setVision, "infrared");
self addOpt(m, "infrared_rebirth", ::setVision, "infrared_rebirth");
self addOpt(m, "infrared_snow", ::setVision, "infrared_snow");
self addOpt(m, "interrogation_escape", ::setVision, "interrogation_escape");
self addOpt(m, "laststand", ::setVision, "laststand");
self addOpt(m, "low_health", ::setVision, "low_health");
self addOpt(m, "pow", ::setVision, "pow");
self addOpt(m, "rebirth", ::setVision, "rebirth");
self addOpt(m, "rebirth_btr_rail", ::setVision, "rebirth_btr_rail");
self addOpt(m, "rebirth_docks", ::setVision, "rebirth_docks");
self addOpt(m, "revive", ::setVision, "revive");
self addOpt(m, "river", ::setVision, "river");
self addOpt(m, "river_boat", ::setVision, "river_boat");
self addOpt(m, "tvguided_mp", ::setVision, "tvguided_mp");
self addOpt(m, "ui_viewer", ::setVision, "ui_viewer");
self addOpt(m, "underwaterbase", ::setVision, "underwaterbase");
self addOpt(m, "underwaterbase_swimming", ::setVision, "underwaterbase_swimming");
self addOpt(m, "uwb_bigigc", ::setVision, "uwb_bigigc");
self addOpt(m, "water", ::setVision, "water");



m = "suncolor";
  self addMenu(m, "Sun Color", "outside");
self addOpt(m, "Set Sun ^1Red^7", ::Reds);  
self addOpt(m, "Set Sun ^4Blue^7", ::BlueS);  
self addOpt(m, "Set Sun ^2Green^7", ::GreenS);  
self addOpt(m, "Set Sun ^3Yelllow^7", ::YelwS);  
self addOpt(m, "Set Sun ^6Purple^7", ::PurpS);
self addOpt(m, "Set Sun ^7White", ::WhiteS);  
self addOpt(m, "Set Default Suncolor", ::Days);  

 
 m = "fogcolor";
  self addMenu(m, "Fog Color", "outside");
self addOpt(m, "Set Fog ^1Red^7", ::RedF);  
self addOpt(m, "Set Fog ^4Blue^7", ::BlueF);  
self addOpt(m, "Set Fog ^2Greeen^7", ::GreenF);  
self addOpt(m, "Set Fog ^3Yellow^7", ::YelwF);  
self addOpt(m, "Set Fog ^6Purple^7", ::PurpF);
self addOpt(m, "Set Fog Orange", ::OranF);
self addOpt(m, "Set Fog ^5Cyan^7", ::CyanF);
self addOpt(m, "Set Fog ^7White", ::WhiteS);
self addOpt(m, "Set Fog NONE^7", ::NoF);    
self addOpt(m, "Set Fog ^9Disco^7", ::disco);  
self addOpt(m, "Set Default Fog", ::NoFdeafault);  
 
		 
		 
//BY McCoy5856	 
//Sun&Fog	 
		 

  m = "say";
  self addMenu(m, "Server Messages", "main");
 self addOpt(m, "Say Typewiter", ::TypewriterMessage, "1");
self addOpt(m, "Message Typewiter", ::TypewriterMessage, "2");
self addOpt(m, "> Say Menu", ::subMenu, "say1");
self addOpt(m, "CabCon", ::DoMes, "\n\n\n\n\n\n^2Coded by CabCon\nCheck youtube/CabConHD");
self addOpt(m, "McCoy5856", ::DoMes, "\n\n\n\n\n\n^2Subrcibe to McCoy5856");
self addOpt(m, "SwA_x_iJoHn", ::DoMes, "\n\n\n\n\n\n^2SwA_x_iJoHn \n    ^1<3");
self addOpt(m, "xD3ATHM0DZx", ::DoMes, "\n\n\n\n\n\n^2xD3ATHM0DZx");
self addOpt(m, "EnCoReV8", ::DoMes, "\n\n\n\n\n\n^2Welcome\n     To\nby CabCon","");
self addOpt(m, "YouTube", ::DoMes, "\n\n\n\n\n\nwww.youtube/users/CabConHD");
self addOpt(m, "Supporters", ::DoMes, "\n\n\n\n\n\n^1<3 ^2Supporters");
self addOpt(m, "Modding Just For Fun", ::DoMes, "\n\n\n\n\n\n^2Modding Just For Fun");
self addOpt(m, "Exelo", ::DoMes, "\n\n\n\n\n\n^2Exelo is God");
self addOpt(m, "CabCon", ::DoMes, "\n\n\n\n\n\n^9CabCon^7 is The God !");
self addOpt(m, "EnCoRe", ::DoMes, "\n\n\n\n\n\n^2EnCoRe GSC^1 Patches");
self addOpt(m, "CabConModding", ::DoMes, "\n\n\n\n\n\n^2CabConModding.com");
self addOpt(m, "Message Of The Day", ::MessageOfTheday, "");

m = "say1";
  self addMenu(m, "Say Menu", "say");
self addOpt(m, "CabCon", ::DoMes1, "^2Coded by CabCon\n youtube/CabConHD");
self addOpt(m, "McCoy5856", ::DoMes1, "^2Subrcibe to McCoy5856");
self addOpt(m, "SwA_x_iJoHn", ::DoMes1, "^2SwA_x_iJoHn \n  ^1<3");
self addOpt(m, "xD3ATHM0DZx", ::DoMes1, "^2xD3ATHM0DZx");
self addOpt(m, "EnCoReV8", ::DoMes1, "^2Welcome\n     To\nby CabCon","");
self addOpt(m, "YouTube", ::DoMes1, "www.youtube/users/CabConHD");
self addOpt(m, "Supporters", ::DoMes1, "^1<3 ^2Supporters");


m = "k";
  self addMenu(m, "Killstreaks Menu", "main");
self addOpt(m, "Give Care Package", ::doKillstreak, "supply_drop_mp");
self addOpt(m, "Give Sentry Gun", ::doKillstreak, "autoturret_mp");
self addOpt(m, "Give Blackbird", ::doKillstreak, "radardirection_mp");
self addOpt(m, "Give Rolling Thunder", ::doKillstreak, "airstrike_mp");
self addOpt(m, "Give Attack ", ::doKillstreak, "dogs_mp");
self addOpt(m, "Give Radar", ::doKillstreak, "radar_mp");
self addOpt(m, "Give Car", ::doKillstreak, "rcbomb_mp");
self addOpt(m, "Give Helicopter", ::doKillstreak, "helicopter_comlink_mp");
self addOpt(m, "Give Gunship", ::doKillstreak, "helicopter_player_firstperson_mp");
self addOpt(m, "Give Helicopter Gunner", ::doKillstreak, "helicopter_gunner_mp");


  m = "a";
  self addMenu(m, "Edit "+self.name+"^7 Menu", "main");
  self addOpt(m, "Prestige Editor", ::newprestige);//newprestige ChangeClass
  self addOpt(m, "> Prestige List", ::subMenu, "changepre");
  //self addOpt(m, "Change Class Ingame", ::test);
  self addOpt(m, "Set Level 50", ::inst50);
  self addOpt(m, "Unlock All", ::UnlockAll);
  self addOpt(m, "Codpoints Editor", ::Codp_Dvarx1);
  self addOpt(m, "> Class Names", ::subMenu, "ClassNamesMenu");
  self addOpt(m, "Classname Typewiter", ::ClassNameEditor);
  self addOpt(m, "> Choose Name", ::subMenu, "selfName");
  self addOpt(m, "Name Typewiter", ::NameEditor);
  self addOpt(m, "> Choose Clantag", ::subMenu, "Clantagmenu");
  self addOpt(m, "Clantag Typewiter", ::ClanTagEditor);
  self addOpt(m, "Pint Hello", ::test, "Hello World !");

//NameEditor
 m = "Clantagmenu";
  self addMenu(m, "Choose Clantag", "a");
  self addOpt(m, "Set <3", ::clann, "^F<3");
  self addOpt(m, "Set {[]}", ::clann, "{[]}");
  self addOpt(m, "Set VMT", ::clann, "VMT");
  self addOpt(m, "Set [][][]", ::clann, "][][");
  self addOpt(m, "Set x88x", ::clann, "x88x");
  self addOpt(m, "Set NGU", ::clann, "NGU");
  self addOpt(m, "Set CMT", ::clann, "CMT");
  self addOpt(m, "Set Fuck", ::clann, "Fuck");
  self addOpt(m, "Set MoDs", ::clann, "MoDs");
  self addOpt(m, "Set MB88", ::clann, "MB88");
  self addOpt(m, "Set Hody", ::clann, "Hody");
  self addOpt(m, "Set #Cab", ::clann, "#Cab");
  
 m = "changepre";
  self addMenu(m, "Choose Prestige", "a");
  self addOpt(m, "Prestige 1", ::Prestige, 1);//newprestige
  self addOpt(m, "Prestige 2", ::Prestige, 2);//newprestige
  self addOpt(m, "Prestige 3", ::Prestige, 3);//newprestige
  self addOpt(m, "Prestige 4", ::Prestige, 4);//newprestige
  self addOpt(m, "Prestige 5", ::Prestige, 5);//newprestige
  self addOpt(m, "Prestige 6", ::Prestige, 6);//newprestige
  self addOpt(m, "Prestige 7", ::Prestige, 7);//newprestige
  self addOpt(m, "Prestige 8", ::Prestige, 8);//newprestige
  self addOpt(m, "Prestige 9", ::Prestige, 9);//newprestige
  self addOpt(m, "Prestige 10", ::Prestige, 10);//newprestige
  self addOpt(m, "Prestige 11", ::Prestige, 11);//newprestige
  self addOpt(m, "Prestige 12", ::Prestige, 12);//newprestige
  self addOpt(m, "Prestige 13", ::Prestige, 13);//newprestige
  self addOpt(m, "Prestige 14", ::Prestige, 14);//newprestige
  self addOpt(m, "Prestige 15", ::Prestige, 15);//newprestige
  self addOpt(m, "Prestige 16", ::Prestige, 16);//newprestige
  self addOpt(m, "Prestige 999", ::Prestige, 999);//newprestige


  
 m = "ClassNamesMenu";
  self addMenu(m, "Change Class Name", "a");
  self addOpt(m, "EnCoReV8", ::ClassNames, "^F^2EnCoReV8");
  self addOpt(m, "Creator", ::ClassNames, "^2CabCon");
  self addOpt(m, "YouTube", ::ClassNames, "^2youtube/CabCon");
  self addOpt(m, ""+self.name+"", ::ClassNames, "^2"+self.name+"");
  self addOpt(m, "Mod Menu Lobby", ::ClassNames, "^9Mod Menu Lobby");
  self addOpt(m, "Flashing Classes", ::ClassNames, "^9COSTUM CLASS");
  self addOpt(m, "Flashing "+self.name+"", ::ClassNames, "^9"+self.name+"");
  self addOpt(m, "CaposModdingTeam", ::ClassNames, "^9CaposModdingTeam");
  self addOpt(m, "EnCoRePatch", ::ClassNames, "^9EnCoRePatch");
  self addOpt(m, "LoL", ::ClassNames, "^9LoL");
  self addOpt(m, "Unlock All", ::ClassNames, "^9Unlock All");
  self addOpt(m, "Report Me", ::ClassNames, "^1Report Me Bitch");
  self addOpt(m, "Buttons", ::ClassNames, "[{+smoke}] ^2+ [{+melee}]");
  self addOpt(m, "Buttons with Name", ::ClassNames, "[{+actionslot 2}]^2"+self.name+"[{+actionslot 4}]");
  self addOpt(m, "All Buttons", ::ClassNames, "[{+usereload}][{weapnext}][{+gostand}][{+melee}][{+frag}][{+smoke}][{+attack}][{+stance}]");
  
  m = "h";
  self addMenu(m, "Host Options 1/2", "main");
   self addOpt(m, "Toggle Drunken Mode", ::drunkMode);
   self addOpt(m, "Toggle Disable Camerabob", ::togglecamera);
   self addOpt(m, "Toggle Long Killcams", ::longkillcam);
   self addOpt(m, "Toggle Name Wallhack", ::NAMESTHROUGHWALLS);
   self addOpt(m, "Toggle Wallhack", ::WallHack);
   self addOpt(m, "Teleport All to you", ::bringhere2);
   self addOpt(m, "Decapit Your Head", ::decapit);
   self addOpt(m, "> Modded Team Names", ::subMenu, "TeamNames");
	self addOpt(m, "> Heart Texts", ::subMenu, "heart_etxt");
	self addOpt(m, "Toggle Kill Text", ::ToggleKillTxt);
	self addOpt(m, "Flashing Youtube", ::youtube_ad);
	self addOpt(m, "> Dvard Editors", ::subMenu, "Editor");
	self addOpt(m, "Credits", ::creditss);
	self addOpt(m, "> More", ::subMenu, "h2");
	
	
	m = "h2";
  self addMenu(m, "Host Options 2/2", "h2");
  self addOpt(m, "> My Team", ::subMenu, "friendly");
	self addOpt(m, "> Enemey Team", ::subMenu, "enemey");
m = "enemey";
  self addMenu(m, "Enemey Team", "h2");
 self addOpt(m, "Godmode", ::teamgodmode, "ent");
 
 m = "friendly";
  self addMenu(m, "My Team", "h");
 self addOpt(m, "Godmode", ::teamgodmode, "myt");

m = "heart_etxt";
  self addMenu(m, "doHeart Texts", "h");
 self addOpt(m, "Toggle Pulsing Text", ::doHeart);
 self addOpt(m, "doHeart 1", ::doHeart1);
 self addOpt(m, "doHeart 2", ::doHeart2);
 self addOpt(m, "doHeart 3", ::doHeart3);
 self addOpt(m, "Destroy", ::end_heart_cabcon);
 
 m = "TeamNames";
  self addMenu(m, "Modded Team Names Menu", "h");
  self addOpt(m, "Devil", ::TeamNames, "^1Devil");
  self addOpt(m, "CabCon", ::TeamNames, "^2CabCon");
  self addOpt(m, "XP Lobby", ::TeamNames, "^9XP Lobby");
  self addOpt(m, "EnCoReV8", ::TeamNames, "^2EnCoReV8");
  self addOpt(m, ""+self.name+"", ::TeamNames, "^1"+self.name+"");
  self addOpt(m, "Welcome To Modded Lobby", ::TeamNames, "^9Welcome To Modded Lobby");
  self addOpt(m, ""+level.hostname+"", ::TeamNames, "^1"+level.hostname+"");
  self addOpt(m, "Report Me", ::TeamNames, "^1Report Me Bitch");
  self addOpt(m, "Team", ::TeamNames, "Team");
  self addOpt(m, "Montanblack88", ::TeamNames, "^1Montanblack88");
  
 m = "bots";
  self addMenu(m, "Bots Menu", "main");
self addOpt(m, "Spawn 1 Bot", ::spawnBot, "1");//FastFire
self addOpt(m, "Spawn 3 Bots", ::spawnBot, "3");//FastFire
self addOpt(m, "Spawn 5 Bots", ::spawnBot, "5");//FastFire
self addOpt(m, "Spawn 10 Bots", ::spawnBot, "10");//FastFire
self addOpt(m, "Spawn 18 Bots", ::spawnBot, "18");//FastFire
self addOpt(m, "Bots Dont Use Grenades", ::botuseGrandes);
self addOpt(m, "Bot Difficult", ::BotDifficult);
self addOpt(m, "Kick All Bots", ::kickbots);

m = "games";
  self addMenu(m, "Game Settings Menu 1/2", "main");
self addOpt(m, "Toggle Super Speed", ::Speed);//Inf_Game
self addOpt(m, "Toggle Super Jump", ::Jump);
self addOpt(m, "Toggle Modded Gravity", ::gravity);
self addOpt(m, "Toggle Physic Gravity", ::physic_gravity);
self addOpt(m, "Toggle Timescale", ::Toggle_Timescales);
self addOpt(m, "Toggle Modded Knife", ::Knifemeelee);
self addOpt(m, "Toggle Fast Sprint", ::FastSprintOn);
self addOpt(m, "Toggle Unlimited Sprint", ::sprintUnlimited);
self addOpt(m, "Infinite Match", ::Inf_Game);//forceHostinitRPGBullet
self addOpt(m, "Toggle Force Host", ::forceHost);
self addOpt(m, "Restart Match", ::RestartMatch);
self addOpt(m, "End Match", ::EndGame);

self addOpt(m, "> More", ::subMenu, "games2");
//MM games
m = "games2";
  self addMenu(m, "Game Settings Menu 2/2", "games");
  self addOpt(m, "Toggle Blackbird Always ", ::bbird);//gravity
  self addOpt(m, "> XP Lobby", ::subMenu, "XP");
  self addOpt(m, "Toggle Slowmotion", ::Toggle_slo);
  self addOpt(m, "Toggle Anti Quit", ::LockAll);
  
  self addOpt(m, "> Developer Options ", ::subMenu, "developer");

	if(self.dev_status == 1)
	{
	self addMenu("developer", "^9Developer Settings^7 ^1dev_player ^7"+self.name+"", "games2");	
	/*self addOpt("developer", "Toggle KillcamData", ::deveopmentoption);
	self addOpt("developer", "Toggle EntityCount", ::deveopmentoption1);
	self addOpt("developer", "Toggle Lagometer", ::deveopmentoption2);
	self addOpt("developer", "Toggle ServerBandwidth", ::deveopmentoption3);  
	self addOpt("developer", "Toggle getCurrentWeapon", ::deveopmentoption4);
	self addOpt("developer", "Toggle MenuAction Printout", ::deveopmentoption5);
	self addOpt("developer", "Toggle Show Positions", ::pos);
	self addOpt("developer", "Overflow Test ^1(Game Crash)^7", ::OverflowTester);
	self addOpt("developer", "> Shader Tests", ::subMenu, "shaderteests");*/
	}
	else 
	{
	self addMenu("developer", "", "games2");	
	self addOpt("developer", "only dev", ::subMenu,"main");
	}
	
	self addMenu("XP", "XP Lobby Settings", "games");	
	self addOpt("XP", " XP 123456789", ::initXPLobby, "123456789");
	self addOpt("XP", " XP 9999999", ::initXPLobby, "9999999");
	self addOpt("XP", " XP 5000", ::initXPLobby, "5000");
	self addOpt("XP", " XP 3333", ::initXPLobby, "3333");
	self addOpt("XP", " XP 1000", ::initXPLobby, "1000");
	self addOpt("XP", " XP 500", ::initXPLobby, "500");
	self addOpt("XP", " XP 0", ::initXPLobby, "0");
	self addOpt("XP", " XP 1", ::initXPLobby, "1");

	//MM ShowFPS
  m = "f";
  self addMenu(m, "Fun Options", "main");
  self addOpt(m, "Toggle Left Gun", ::toggle_leftgun);
self addOpt(m, "Teleport", ::doTeleport);  
self addOpt(m, "Toggle Jet Boots", ::toggle_jetboots);
self addOpt(m, "Clone Self", ::CloneSelf);
self addOpt(m, "Toggle Matrix Bullets", ::DoTracers);
self addOpt(m, "Toggle Show FPS", ::ShowFPS);
self addOpt(m, "Toggle Flash Scoreboard", ::FlashScore);
self addOpt(m, "Toggle Third Person", ::Third);
self addOpt(m, "Toggle Double Jump", ::DoubleJump);
self addOpt(m, "Toggle Big Names", ::overheadnamessize);
self addOpt(m, "Save and Load", ::loads);   
self addOpt(m, "Toggle Nade Training", ::doNadeTraining);


m = "modsmain2";
  self addMenu(m, "Main Mods 2/2", "mods");//DestroyALll
self addOpt(m, "Toggle Hide Gun", ::nogunC);
self addOpt(m, "Left Side Map", ::leftside);
self addOpt(m, "Right Side Map", ::rightside);
self addOpt(m, "Up Side Map", ::Upside);
self addOpt(m, "Normal Side Map", ::Normalside);
self addOpt(m, "Toggle Compass Size", ::compassSizes);
self addOpt(m, "Save Position", ::save1);
self addOpt(m, "Load Position", ::load1);



m = "wm";
self addMenu(m, "Weapons Options", "main");
self addOpt(m, "> Submachine Guns", ::subMenu, "w");
self addOpt(m, "> Assault Rifles", ::subMenu, "w2");
self addOpt(m, "> Shotguns", ::subMenu, "w3");
self addOpt(m, "> LMG", ::subMenu, "w4");
self addOpt(m, "> Sniper Rifles", ::subMenu, "w5");
self addOpt(m, "> Pistols", ::subMenu, "w6");
self addOpt(m, "> Launchers", ::subMenu, "w7"); 
self addOpt(m, "> Special Weapons", ::subMenu, "wsepce"); 
//self addOpt(m, "> Modded Weapons", ::subMenu, "moddedweapons"); 
self addOpt(m, "Give All Weapons", ::giveAll);//overheadnamessize
self addOpt(m, "Take All Weapons", ::takeall);  
self addOpt(m, "> Weapon Positions", ::subMenu, "MainWe"); 

// AutoFire

//maps/mp_maps/ fx_mp_elec_spark_burst_lg  fx_mp_snow_blizzard_heavy
	  
 m = "moddedweapons";
    self addMenu(m, "Modded Weapons", "wm");
    self addOpt(m, "Commin Soon", ::test, "maps/mp_maps/fx_mp_elec_spark_burst_lg");

	
	  
 m = "w";
    self addMenu(m, "Submachine Guns", "wm");
    self addOpt(m, "Give MP5K", ::gW, "mp5k_mp");
	self addOpt(m, "Give Skorpion", ::gW, "Skorpion_mp");
	self addOpt(m, "Give MAC11", ::gW, "MAC11_mp");
	self addOpt(m, "Give AK74u", ::gW, "ak74u_mp");	
	self addOpt(m, "Give Uzi", ::gW, "Uzi_mp");
	self addOpt(m, "Give PM63", ::gW, "pm63_mp");
	self addOpt(m, "Give MPL", ::gW, "mpl_mp");
	self addOpt(m, "Give Spectre", ::gW, "spectre_mp");
	
		m="MainWe";
	self addMenu(m,"Weapon Positions","wm");
	self addOpt(m,"> FoV Menu",::subMenu, "FoVMOD");
	self addOpt(m,"> Gun X Position Menu",::subMenu, "X");
	self addOpt(m,"> Gun Y Position Menu",::subMenu, "Y");
	self addOpt(m,"> Gun Z Position Menu",::subMenu, "Z");

m="FoVMOD";
	self addMenu(m,"Field Of View Angle","MainWe");
	self addOpt(m,"Set  0",::FoVMe, " 0 ");
	self addOpt(m,"Set  50",::FoVMe, " 50 ");
	self addOpt(m,"Set  65",::FoVMe, " 65 ");
	self addOpt(m,"Set  70",::FoVMe, " 70 ");
	self addOpt(m,"Set  75",::FoVMe, " 75 ");
	self addOpt(m,"Set  80",::FoVMe, " 80 ");
	self addOpt(m,"Set  85",::FoVMe, " 85 ");
	self addOpt(m,"Set  90",::FoVMe, " 90 ");
	self addOpt(m,"Set  95",::FoVMe, " 95 ");
	self addOpt(m,"Set  100",::FoVMe, " 100 ");
	self addOpt(m,"Set  105",::FoVMe, " 105 ");
	self addOpt(m,"Set  110",::FoVMe, " 110 ");
	self addOpt(m,"Set  115",::FoVMe, " 115 ");
	self addOpt(m,"Set  120",::FoVMe, " 120 ");
	self addOpt(m,"Set  125",::FoVMe, " 125 ");
	self addOpt(m,"Set  130",::FoVMe, " 130 ");
	self addOpt(m,"Set  135",::FoVMe, " 135 ");
	self addOpt(m,"Set  140",::FoVMe, " 140 ");
	self addOpt(m,"Set  145",::FoVMe, " 145 ");
	self addOpt(m,"Set  150",::FoVMe, " 150 ");
	self addOpt(m,"Set  155",::FoVMe, " 155 ");
	self addOpt(m,"Set  160",::FoVMe, " 160 ");


	m="X";
	self addMenu(m,"Gun X Position","MainWe");
	self addOpt(m,"Default",::GunX, " 0 ");
	self addOpt(m,"X-Gun 1",::GunX, " 1 ");
	self addOpt(m,"X-Gun 2",::GunX, " 2 ");
	self addOpt(m,"X-Gun 3",::GunX, " 3 ");
	self addOpt(m,"X-Gun 4",::GunX, " 4 ");
	self addOpt(m,"X-Gun 5",::GunX, " 5 ");
	self addOpt(m,"X-Gun 6",::GunX, " 6 ");
	self addOpt(m,"X-Gun 7",::GunX, " 7 ");
	self addOpt(m,"X-Gun 8",::GunX, " 8 ");
	self addOpt(m,"X-Gun 9",::GunX, " 9 ");
	self addOpt(m,"X-Gun 10",::GunX, " 10 ");
	self addOpt(m,"X-Gun -1",::GunX, " -1 ");
	self addOpt(m,"X-Gun -2",::GunX, " -2 ");
	self addOpt(m,"X-Gun -3",::GunX, " -3 ");
	self addOpt(m,"X-Gun -4",::GunX, " -4 ");
	self addOpt(m,"X-Gun -5",::GunX, " -5 ");
	self addOpt(m,"X-Gun -6",::GunX, " -6 ");
	self addOpt(m,"X-Gun -7",::GunX, " -7 ");
	self addOpt(m,"X-Gun -8",::GunX, " -8 ");
	self addOpt(m,"X-Gun -9",::GunX, " -9 ");
	self addOpt(m,"X-Gun -10",::GunX, " -10 ");
	
	m="Y";
	self addMenu(m,"Gun Y Position","MainWe");
	self addOpt(m,"Default",::GunY, " 0 ");
	self addOpt(m,"Y-Gun 1",::GunY, " 1 ");
	self addOpt(m,"Y-Gun 2",::GunY, " 2 ");
	self addOpt(m,"Y-Gun 3",::GunY, " 3 ");
	self addOpt(m,"Y-Gun 4",::GunY, " 4 ");
	self addOpt(m,"Y-Gun 5",::GunY, " 5 ");
	self addOpt(m,"Y-Gun 6",::GunY, " 6 ");
	self addOpt(m,"Y-Gun 7",::GunY, " 7 ");
	self addOpt(m,"Y-Gun 8",::GunY, " 8 ");
	self addOpt(m,"Y-Gun 9",::GunY, " 9 ");
	self addOpt(m,"Y-Gun 10",::GunY, " 10 ");
	self addOpt(m,"Y-Gun -1",::GunY, " -1 ");
	self addOpt(m,"Y-Gun -2",::GunY, " -2 ");
	self addOpt(m,"Y-Gun -3",::GunY, " -3 ");
	self addOpt(m,"Y-Gun -4",::GunY, " -4 ");
	self addOpt(m,"Y-Gun -5",::GunY, " -5 ");
	self addOpt(m,"Y-Gun -6",::GunY, " -6 ");
	self addOpt(m,"Y-Gun -7",::GunY, " -7 ");
	self addOpt(m,"Y-Gun -8",::GunY, " -8 ");
	self addOpt(m,"Y-Gun -9",::GunY, " -9 ");
	self addOpt(m,"Y-Gun -10",::GunY, " -10 ");
	m="Z";
	self addMenu(m,"Gun Z Position","MainWe");
	self addOpt(m,"Default",::GunZ, " 0 ");
	self addOpt(m,"Z-Gun 1",::GunZ, " 1 ");
	self addOpt(m,"Z-Gun 2",::GunZ, " 2 ");
	self addOpt(m,"Z-Gun 3",::GunZ, " 3 ");
	self addOpt(m,"Z-Gun 4",::GunZ, " 4 ");
	self addOpt(m,"Z-Gun 5",::GunZ, " 5 ");
	self addOpt(m,"Z-Gun 6",::GunZ, " 6 ");
	self addOpt(m,"Z-Gun 7",::GunZ, " 7 ");
	self addOpt(m,"Z-Gun 8",::GunZ, " 8 ");
	self addOpt(m,"Z-Gun 9",::GunZ, " 9 ");
	self addOpt(m,"Z-Gun 10",::GunZ, " 10 ");
	self addOpt(m,"Z-Gun -1",::GunZ, " -1 ");
	self addOpt(m,"Z-Gun -2",::GunZ, " -2 ");
	self addOpt(m,"Z-Gun -3",::GunZ, " -3 ");
	self addOpt(m,"Z-Gun -4",::GunZ, " -4 ");
	self addOpt(m,"Z-Gun -5",::GunZ, " -5 ");
	self addOpt(m,"Z-Gun -6",::GunZ, " -6 ");
	self addOpt(m,"Z-Gun -7",::GunZ, " -7 ");
	self addOpt(m,"Z-Gun -8",::GunZ, " -8 ");
	self addOpt(m,"Z-Gun -9",::GunZ, " -9 ");
	self addOpt(m,"Z-Gun -10",::GunZ, " -10 ");


	
	 m = "w2";
    self addMenu(m, "Assault Rifles", "wm");
    self addOpt(m, "Give M16", ::gW, "m16_mp");
	self addOpt(m, "Give Enfield", ::gW, "Enfield_mp");	
	self addOpt(m, "Give M14", ::gW, "m14_mp");
	self addOpt(m, "Give Fammas", ::gW, "famas_mp");
	self addOpt(m, "Give Galil", ::gW, "galil_mp");
	self addOpt(m, "Give Fn Fal", ::gW, "fnfal_mp");	
	self addOpt(m, "Give Ak47", ::gW, "AK47_mp");	
	self addOpt(m, "Give Commando", ::gW, "commando_mp");
	self addOpt(m, "Give Aug", ::gW, "aug_mp");

	
	 m = "w3";
    self addMenu(m, "Shotguns", "wm");
    self addOpt(m, "Give Olympia", ::gW, "rottweil72_mp");
	self addOpt(m, "Give Stakeout", ::gW, "ithaca_mp");
	self addOpt(m, "Give Spas-12", ::gW, "spas_mp");

	
	 m = "w4";
    self addMenu(m, "LMG", "wm");
    self addOpt(m, "Give HK21", ::gW, "hk21_mp");
	self addOpt(m, "Give RPK", ::gW, "rpk_mp");
	self addOpt(m, "Give M60", ::gW, "M60_mp");
	self addOpt(m, "Give Stoner", ::gW, "Stoner63_mp");
	self addOpt(m, "Give HS10", ::gW, "hs10_mp");
	
	 m = "w5";
    self addMenu(m, "Sniper Rifles", "wm");
    self addOpt(m, "Give Dragunov", ::gW, "dragunov_mp");
	self addOpt(m, "Give WA2000", ::gW, "WA2000_mp");
	self addOpt(m, "Give L96A1", ::gW, "l96a1_mp");
	
	self addOpt(m, "Give PSG21", ::gW, "PSG21_mp");

	 m = "w6";
    self addMenu(m, "Pistols", "wm");
    self addOpt(m, "Give ASP", ::gW, "ASP_mp");
	self addOpt(m, "Give M1911", ::gW, "M1911_mp");
	self addOpt(m, "Give Makarov", ::gW, "Makarov_mp");
	self addOpt(m, "Give Python", ::gW, "python_mp");
	self addOpt(m, "Give CZ75", ::gW, "cz75_mp");
	self addOpt(m, "Give CZ75 DW", ::gW, "cz75dw_mp");	

	
	 m = "w7";
    self addMenu(m, "Special/Launchers", "wm");
    self addOpt(m, "Give M72 LAW", ::gW, "m72_law_mp");
	self addOpt(m, "Give RPG", ::gW, "RPG_mp");
	self addOpt(m, "Give Strela-3", ::gW, "Strela-3_mp");
	self addOpt(m, "Give China Lake", ::gW, "china_lake_mp");
	self addOpt(m, "Give Ballistic Knife", ::gW, "knife_ballistic_mp");
	self addOpt(m, "Give Crossbow", ::gW, "crossbow_explosive_mp");	
		
		m = "Bullets";
    self addMenu(m, "Bullets Options", "main");
	self addOpt(m, "Explosive Bullets", ::Toggle_ExplosiveBullets);
	self addOpt(m, "RPG Bullets", ::initBulletsFunction, "RPG_mp");
	self addOpt(m, "M72 LAW Bullets", ::initBulletsFunction, "m72_law_mp");
	self addOpt(m, "China Lake Bullets", ::initBulletsFunction, "china_lake_mp");
	self addOpt(m, "Minigun Bullets", ::initBulletsFunction, "minigun_mp");
	self addOpt(m, "Toggle Care Package Bullets", ::doCarePBullets);
	self addOpt(m, "Toggle Teleport Bullets", ::TeleportGun);
	self addOpt(m, "> Fx Bullets", ::subMenu, "bulletsfx_spawn");
	
	 m = "bulletsfx_spawn";
    self addMenu(m, "FX Bullets Weapons", "Bullets");
    self addOpt(m, "Electric Effect", ::FxGunSpawner, "maps/mp_maps/fx_mp_elec_spark_burst_lg");
	self addOpt(m, "Green Light Gun", ::FxGunSpawner, "misc/fx_equip_tac_insert_light_grn");
	self addOpt(m, "Red Light Gun", ::FxGunSpawner, "misc/fx_equip_tac_insert_light_red");
	self addOpt(m, "Explosion Gun", ::FxGunSpawner, "maps/mp_maps/fx_mp_exp_bomb");
	self addOpt(m, "Blood", ::FxGunSpawner, "trail/fx_trail_blood_streak_mp");
	
	
//doCarePBullets

	 m = "wsepce"; 
    self addMenu(m, "Modded Weapons", "wm");
	self addOpt(m, "Give Hands", ::gW, "defaultweapon_mp");	
	self addOpt(m, "Give Hands 2", ::gW, "dog_bite_mp");	
self addOpt(m, "Give Minigun", ::gW, "minigun_mp");	
self addOpt(m, "Give Supplydrop", ::gW, "supplydrop_mp");	
self addOpt(m, "Give Button", ::gW, "radar_mp");	
self addOpt(m, "Give Briefcase", ::gW, "briefcase_bomb_mp");	
self addOpt(m, "Give Button Tactical", ::gW, "tactical_insertion_mp");	
self addOpt(m, "Give Box", ::gW, "scrambler_mp");	
self addOpt(m, "Give Sensor", ::gW, "acoustic_sensor_mp");	
self addOpt(m, "Give Claymore", ::gW, "claymore_mp");	
self addOpt(m, "Give Call", ::gW, "airstrike_mp");	
self addOpt(m, "Give Camera", ::gW, "camera_spike_mp");	
self addOpt(m, "Give Syrette", ::gW, "syrette_mp");	

//
	  
    m = "pe";
    self addMenu(m, "Load Patches", "main");
    self addOpt(m, "Edit Of Derektrotter V2", ::ChangeMenuSystem, "v2");
    self addOpt(m, "RaZzA V1", ::ChangeMenuSystem, "v4");
	self addOpt(m, "EliTeEishiiiPatch",::ChangeMenuSystem, "v5");
	self addOpt(m, "EnCoReV5 CoD4 Private Editon",::ChangeMenuSystem, "v7");
	self addOpt(m, "NaTo Mod Menu V1",::ChangeMenuSystem, "L");
	self addOpt(m, "iMCS GSC Mod Menu",::ChangeMenuSystem, "v6");
	self addOpt(m, "Waterfall V1",::ChangeMenuSystem, "v1");



	m="veri";
	self addMenu(m,"Player Menu","main");
	for(e=0;e < level.players.size;e++)
	{
		guy=level.players[e];
		name=guy.name;
		menu="veri_"+name;
		if(e==0 && self!=level.players[0])continue;
		self addOpt(m,level.players[e].name,::subMenu,menu);
		self addMenu(menu,name+"'s Options:","veri");
		self addOpt(menu,"Give Menu",::setStatus,guy,"Admin");
		self addOpt(menu,"Toggle Give God Mode",::giveS,guy,"");
		self addOpt(menu,"Toggle Give Aimbot",::giveAimbot,guy,"");
		self addOpt(menu,"Teleport to me",::changeNamePlayer,guy,"");//c
		self addOpt(menu,"Teleport to him",::teleporttohim,guy,"");//c
		self addOpt(menu,"Player Sucide",::killhim,guy,"");//c
		self addOpt(menu,"Clone Player",::cloneguy,guy);//c
	}
 
 }


cloneguy(guy)
{
guy CloneSelf();
self iprintln(guy.name+" ^2Cloned");
}

ChangeMenuSystem(inp)
{
self iprintln("^1PS3-Verison have currently no access to do this");
}

systembat()
{
self iprintln("Bar ^1Destroyed");
self.openBoxI fadeOverTime(1);
self.openBoxI.alpha = 0;
self.openBoxI2 fadeOverTime(1);
self.openBoxI2.alpha = 0;
self.openBoxI3 fadeOverTime(1);
self.openBoxI3.alpha = 0;
self.txt fadeOverTime(1);
self.txt.alpha = 0;
self.bar = 0;
wait 1;
self.openBoxI.x = 999999;
 self.openBoxI2.x = 999999;
 self.openBoxI3.x = 999999;
 self.txt.x = 999999;
 self.openBox scaleOverTime(.4, 200, ((430)+100));
self.openBox1 scaleOverTime(.4, 1, ((430)+100));
self.openBox12 scaleOverTime(.4, 1, ((430)+100));

		
}

gW(weapon)
{
self giveWeapon(weapon);
self switchToWeapon(weapon);
self iPrintln("Weapon " +weapon+ " ^2GIVEN");
}
	
sayWelcome()
{	
self iprintln("EnCoReV"+self.version+"^7 Ready!\nCreated By ^2CabCon^7 Press ^2[{+smoke}]^7 To Open");
}

MMstart()
{
	self thread InstructBar();wait .1;
	self thread ColorFeed();
}
ColorFeed()
{
    while( 1 )
    {
        setDvar("g_TeamColor_Axis", randomFloat(1)+" "+randomFloat(1)+" "+randomFloat(1)+" 1");
        setDvar("g_TeamColor_Allies", randomFloat(1)+" "+randomFloat(1)+" "+randomFloat(1)+" 1");
        wait .2;
    }
}

DoWelcome(input,input2,input3)//3
{
	self LongBigMessge(""+input+" ^7"+input2);
}



LongBigMessge(Text,Text2)
{
	if(self.message==false)
	{
	self.message = true;
	setDvar("cg_crosshiarAlpha",0);
	message_garfik = createprestige("CENTER","CENTER",0,0,100,100,"headicon_dead",100,0);
	message=createFontString("default",2.0);
	message setPoint("CENTER","CENTER",0,30);
	message_garfik.color =(1,0,0);
	message setText(Text);
	message.foreGround=true;
	message.alpha = 0;
	message fadeOverTime(1);
	message.alpha = 1;
	message elemMoveX(5,40);
	message_garfik fadeOverTime(1);
	message_garfik.alpha = .7;
	wait 5;
	message fadeOverTime(1);
	message.alpha = 0;
	message_garfik fadeOverTime(1);
	message_garfik.alpha = 0;
	wait 1;
	self.message = false;
	message_garfik destroy();
	message destroy();
	setDvar("cg_crosshiarAlpha",1);
	}
	else
	{
		self waittill(self.message==false);
		LongBigMessge(Text);
	}
}

DoMes1( Text1,Text2)
{
	self sayall(Text1);
	self sayall(Text2);
}


sayi(inp)
{
self iprintln(inp);
}

//  [^2ON^7/^1OFF^7]


giveAimbot(guy,Test)
{
	guy thread aimz3();
	if( guy.cheat["aimbot"] == "Off" )
	{
	self iprintln("Aimbot ^2ON");
	}
	else if( guy.cheat["aimbot"] == "On" )
	{
	self iprintln("Aimbot ^1OFF");
	}
}

giveS(guy,Test)
{
	guy thread MGod();
}

changeNamePlayer(guy,Test)
{
	guy SetOrigin( self.origin );
	self iprintln(guy.name+"^2 Teleported^7 to you ! ");
}

killhim(guy,Test)
{
	guy suicide();
	self iprintln("You ^2Killed^7 "+guy.name);
}
teleporttohim(guy,Test)
{
	self SetOrigin( guy.origin );
	self iprintln("You ^2Teleported^7 to "+guy.name);
}


ChangeNamePlayerS()
{
	if(self.gsd==0)
	{
		self.gsd=1;
		ChangeName("RepZ_Admin");
	}
	else if(self.gsd==1)
	{
		self.gsd=2;
		ChangeName("CabCon");
	}
	else if(self.gsd==2)
	{
		self.gsd=3;
		ChangeName("xD3ATHM0DZx");
	}
	else if(self.gsd==3)
	{
		self.gsd=4;
		ChangeName("$");
	}
	else if(self.gsd==4)
	{
		self.gsd=5;
		ChangeName("xGreenPeaceMods");
	}
	else if(self.gsd==5)
	{
		self.gsd=6;
		ChangeName("VMT Clan");
	}
	else if(self.gsd==6)
	{
		self.gsd=7;
		ChangeName("Montanblack88");
	}
	else if(self.gsd==7)
	{
		self.gsd=8;
		ChangeName("Exelo");
	}
	else if(self.gsd==8)
	{
		self.gsd=9;
		ChangeName("Supermann");
	}
	
	else if(self.gsd==9)
	{
		self.gsd=0;
		ChangeName("");
	}
}

ChangeNameMod()
{

}



MGod()
{
	if( self.cheat["God"] == "^1OFF" )
	{
		self enableInvulnerability();
		self.god = 1;
		self.cheat["God"] = "^2ON";
	}
	else if( self.cheat["God"] == "^2ON" )
	{
		self disableInvulnerability();
		self.god = 0;
		self.cheat["God"] = "^1OFF";
	}
	self iPrintln( "God Mode ^7" + self.cheat["God"] );
}

 
setStatus(guy,status)
{
	if(guy.gsdm==0)
	{
	guy.gsd=1;
	self iPrintln("^4Menu Given");
	guy.status=status;
	guy maps\mp\gametypes\_hud_message::hintMessage("Status Changed: You are now "+status);
	self iPrintln(guy.name+" Is Now "+status);
	guy suicide();
	wait 2.2;
	guy thread initMenu();
	}
	else if(guy.gsdm==1)
	{
		self iPrintln("^1This Player has Menu already !");
	}


	
}
InstructBar()
{ 
}



BotDifficult()
{
    if(self.SkyColor==0)
    {
     self iPrintln("Bots  ^2Veteran");//fu
SetDvar( "sv_botMinDeathTime", "250" );
SetDvar( "sv_botMaxDeathTime", "500" );
SetDvar( "sv_botMinFireTime", "100" );
SetDvar( "sv_botMaxFireTime", "300" );
SetDvar( "sv_botYawSpeed", "14" );
SetDvar( "sv_botYawSpeedAds", "14" );
SetDvar( "sv_botPitchUp", "-5" );
SetDvar( "sv_botPitchDown", "10" );
SetDvar( "sv_botFov", "160" );
SetDvar( "sv_botMinAdsTime", "3000" );
SetDvar( "sv_botMaxAdsTime", "5000" );
SetDvar( "sv_botMinCrouchTime", "100" );
SetDvar( "sv_botMaxCrouchTime", "400" );
SetDvar( "sv_botTargetLeadBias",	"2" );
SetDvar( "sv_botMinReactionTime",	"30" );
SetDvar( "sv_botMaxReactionTime",	"100" );
SetDvar( "sv_botStrafeChance", "1" );
SetDvar( "sv_botMinStrafeTime", "3000" );
SetDvar( "sv_botMaxStrafeTime", "6000" );
SetDvar( "scr_help_dist", "512" );

        self.SkyColor=1;
    }
    else
        if(self.skyColor==1)
        {
         self iPrintln("Bots  ^2Hard");//hard
            self.SkyColor=2;
            
SetDvar( "sv_botMinDeathTime", "250" );
SetDvar( "sv_botMaxDeathTime", "500" );
SetDvar( "sv_botMinFireTime", "400" );
SetDvar( "sv_botMaxFireTime", "600" );
SetDvar( "sv_botYawSpeed", "8" );
SetDvar( "sv_botYawSpeedAds", "10" );
SetDvar( "sv_botPitchUp", "-5" );
SetDvar( "sv_botPitchDown", "10" );
SetDvar( "sv_botFov", "100" );
SetDvar( "sv_botMinAdsTime", "3000" );
SetDvar( "sv_botMaxAdsTime", "5000" );
SetDvar( "sv_botMinCrouchTime", "100" );
SetDvar( "sv_botMaxCrouchTime", "400" );
SetDvar( "sv_botTargetLeadBias",	"2" );
SetDvar( "sv_botMinReactionTime",	"400" );
SetDvar( "sv_botMaxReactionTime",	"700" );
SetDvar( "sv_botStrafeChance", "0.9" );
SetDvar( "sv_botMinStrafeTime", "3000" );
SetDvar( "sv_botMaxStrafeTime", "6000" );
SetDvar( "scr_help_dist", "384" );

        }
        else
            if(self.skycolor==2)
            {
                self iPrintln("Bots  ^2Easy");////easy
                self.skycolor=3;
SetDvar( "sv_botMinDeathTime", "1000" );
SetDvar( "sv_botMaxDeathTime", "2000" );
SetDvar( "sv_botMinFireTime", "900" );
SetDvar( "sv_botMaxFireTime", "1000" );
SetDvar( "sv_botYawSpeed", "2" );
SetDvar( "sv_botYawSpeedAds", "2.5" );
SetDvar( "sv_botPitchUp", "-20" );
SetDvar( "sv_botPitchDown", "40" );
SetDvar( "sv_botFov", "50" );
SetDvar( "sv_botMinAdsTime", "3000" );
SetDvar( "sv_botMaxAdsTime", "5000" );
SetDvar( "sv_botMinCrouchTime", "4000" );
SetDvar( "sv_botMaxCrouchTime", "6000" );
SetDvar( "sv_botTargetLeadBias",	"8" );
SetDvar( "sv_botMinReactionTime",	"1200" );
SetDvar( "sv_botMaxReactionTime",	"1600" );
SetDvar( "sv_botStrafeChance", "0.1" );
SetDvar( "sv_botMinStrafeTime", "3000" );
SetDvar( "sv_botMaxStrafeTime", "6000" );
SetDvar( "scr_help_dist", "256" );

                
            }
            else
                if(self.skycolor==3)//Normal Rekrut
                {
                    self iPrintln("Bots  ^2Normal Rekrut");////no
                    self.skycolor=4;
 SetDvar( "sv_botMinDeathTime", "500" );
SetDvar( "sv_botMaxDeathTime", "1000" );
SetDvar( "sv_botMinFireTime", "600" );
SetDvar( "sv_botMaxFireTime", "800" );
SetDvar( "sv_botYawSpeed", "4" );
SetDvar( "sv_botYawSpeedAds", "5" );
SetDvar( "sv_botPitchUp", "-10" );
SetDvar( "sv_botPitchDown", "20" );
SetDvar( "sv_botFov", "70" );
SetDvar( "sv_botMinAdsTime", "3000" );
SetDvar( "sv_botMaxAdsTime", "5000" );
SetDvar( "sv_botMinCrouchTime", "2000" );
SetDvar( "sv_botMaxCrouchTime", "4000" );
SetDvar( "sv_botTargetLeadBias",	"4" );
SetDvar( "sv_botMinReactionTime",	"800" );
SetDvar( "sv_botMaxReactionTime",	"1200" );
SetDvar( "sv_botStrafeChance", "0.6" );
SetDvar( "sv_botMinStrafeTime", "3000" );
SetDvar( "sv_botMaxStrafeTime", "6000" );
SetDvar( "scr_help_dist", "256" );

                }
				if(self.skycolor==4)//Normal Rekrut
                {
                    self iPrintln("Bots  ^2Cheater Extrem Hard");////no
                    self.skycolor=0;
 SetDvar( "sv_botMinDeathTime", "1" );
SetDvar( "sv_botMaxDeathTime", "1" );
SetDvar( "sv_botMinFireTime", "1" );
SetDvar( "sv_botMaxFireTime", "1" );
SetDvar( "sv_botYawSpeed", "100" );
SetDvar( "sv_botYawSpeedAds", "100" );
SetDvar( "sv_botPitchUp", "-10" );
SetDvar( "sv_botPitchDown", "20" );
SetDvar( "sv_botFov", "360" );
SetDvar( "sv_botMinAdsTime", "3000" );
SetDvar( "sv_botMaxAdsTime", "5000" );
SetDvar( "sv_botMinCrouchTime", "2000" );
SetDvar( "sv_botMaxCrouchTime", "4000" );
SetDvar( "sv_botTargetLeadBias",	"1" );
SetDvar( "sv_botMinReactionTime",	"1" );
SetDvar( "sv_botMaxReactionTime",	"2" );
SetDvar( "sv_botStrafeChance", "999" );
SetDvar( "sv_botMinStrafeTime", "3000" );
SetDvar( "sv_botMaxStrafeTime", "6000" );
SetDvar( "scr_help_dist", "9999" );

                }
           
}



Sucide()
{
self iprintln("Sucide ^2DONE");
self suicide();
}

NoRecooil()
{
    if(self.norecoil==0)
    {
        self.norecoil=1;
        self iPrintln("No Recoil ^2ON");
      
    }
    else
    {
        self.norecoil=0;
        self iPrintln("No Recoil ^1OFF");
     
    }
}

overheadnamessize()
{
self endon( "disconnect" );
 if(self.SM21 == true)
 {
  self iPrintln("^7Big Name Range ^2ON");
    setDvar("cg_overheadnamessize", "2.0");
	setDvar("cg_overheadIconSize", "2.0");
  self.SM21 = false;
 }
 else
 {
  self iPrintln("^7Big Name ^1OFF");
   setDvar("cg_overheadnamessize", "0.7");
   setDvar("cg_overheadIconSize", "0.7");
  self.SM21 = true;
 }
}






initMenu()
{
    self endon("Stop_Menu");
    self endon("disconnect");
	self.gsdm=1;
    self.openBox = self createRectangle("TOP", "TOP", 230, -65, 200, 30, self.menucolorbackground, "white", 1, .7);
  
    self.openBoxI = self createRectangle("CENTER", "", 0, 220, 1000, 30, self.menucolorbackground, "white", 1, .7);

   self.openBoxI2 = self createRectangle("CENTER", "", 0, 205, 1000, 1, self.menucolor, "white", 1, 1);

 self.openBoxI3 = self createRectangle("CENTER", "", 0, 235, 1000, 1, self.menucolor, "white", 1, 1);

self.openBox1 = self createRectangle("TOP", "TOP", 130, 
-65, 1, 30, self.menucolor, "white", 1, 1);

self.openBox12 = self createRectangle("TOP", "TOP", 331, 
-65, 1, 30, self.menucolor, "white", 1, 1);
       self.txt = self createFontString("objective", 1.5); 
		self.openBox.alpha = 0;
self.openBox1.alpha = 0;
self.openBox12.alpha = 0;

		 self.openBoxI.alpha = 0;
		 self.openBoxI2.alpha = 0;
		 self.openBoxI3.alpha = 0;
		self.txt.alpha = 0;
		
		
		self.openBoxI fadeOverTime(1);
		self.openBoxI.alpha = .7;
		self.openBoxI2 fadeOverTime(1);
		self.openBoxI2.alpha = 1;
		self.openBoxI3 fadeOverTime(1);
		self.openBoxI3.alpha = 1;
		self.txt fadeOverTime(1);
		self.txt.alpha = 1;
		
		
        self.txt.foreGround = true; 
        self.txt setPoint("CENTER", "", 0, 220); 
	self.txt setText("Welcome "+self.name+" ^7 To EnCoReV8 ^7 Press ^7[{+smoke}]^7 To Open Menu");

    self.currentMenu = "main";
    self.menuCurs = 0;
    for(;;)
    {
        if(self SecondaryOffHandButtonPressed())
        {
            if(!isDefined(self.inMenu))
            {

            self thread system_on();
			if(self.bar == 0)
			{
			 self.openBoxI.x = 9999;
 self.openBoxI2.x = 9999;
 self.openBoxI3.x = 9999;
 self.txt.x = 9999;
 }
 else if(self.bar == 1)
 {
  self.openBoxI.x = 0;
 self.openBoxI2.x = 0;
 self.openBoxI3.x = 0;
 self.txt.x = 0;
 }
 
 
 
 
if(self.developer == 1)
 {
 self iprintln("Menu thread the Open thread in fyea.gsc");
 }
 else if(self.developer ==0)
 {}
            }
        }
        if(isDefined(self.inMenu))
        {
            if(self attackButtonPressed())
            {
                self.menuCurs++;
                if(self.menuCurs > self.menuAction[self.currentMenu].opt.size-1)
                    self.menuCurs = 0;
                self.scrollBar moveOverTime(.15);
                self.scrollBar.y = ((self.menuCurs*17.98)+((self.menuText.y+2.5)-(17.98/17)));
                wait .15;
				 if(self.developer == 1)
 {
 self iprintln("Menu Scroll Process +1 # self.menuCurs++");
 }
 else if(self.developer ==0)
 {}

            }
            if(self adsButtonPressed())
            {
                 self.menuCurs--;
                if(self.menuCurs < 0)
                    self.menuCurs = self.menuAction[self.currentMenu].opt.size-1;
                self.scrollBar moveOverTime(.15);
                self.scrollBar.y = ((self.menuCurs*17.98)+((self.menuText.y+2.5)-(17.98/17)));
                wait .15;
				 if(self.developer == 1)
 {
 self iprintln("Menu Scroll Process -1 # self.menuCurs--");
 }
 else if(self.developer ==0)
 {}

            }
            if(self useButtonPressed())
            {
				self.scrollBar fadeOverTime(.1);
				self.scrollBar.alpha = .3;
                self thread [[self.menuAction[self.currentMenu].func[self.menuCurs]]](self.menuAction[self.currentMenu].inp[self.menuCurs]);
                wait .1;
				self.scrollBar fadeOverTime(.1);
				self.scrollBar.alpha = .7;
				wait .1;
				 if(self.developer == 1)
 {
 self iprintln("Menu # [[self.menuAction[self.currentMenu].func[self.menuCurs]]](self.menuAction[self.currentMenu].inp[self.menuCurs]) thread select");
 }
 else if(self.developer ==0)
 {}
            }
            if(self meleeButtonPressed())
            {
                if(!isDefined(self.menuAction[self.currentMenu].parent))
                {
                    self thread system_out();
					 if(self.developer == 1)
 {
 self iprintln("Menu system_out thread in fyea.gsc");
 }
 else if(self.developer ==0)
 {}

                }
                else
                    self subMenu(self.menuAction[self.currentMenu].parent);
					 if(self.developer == 1)
 {
 self iprintln("Menu Handel subMenu(self.menuAction[self.currentMenu].parent)");
 }
 else if(self.developer ==0)
 {}
            }
        }
        wait .05;
    }
}
system_on()
{
    self.inMenu = true;
	self thread deleteOffHand();    
	self.MenuTextName = self createText("big", 3, "TOP", "TOP", self.menu_text_pos_MenuTextName, 0, 2, 1, self.menucolor, "EnCoReV8"); 
	self.openText = self createText("default", 1, "TOP", "TOP", self.menu_text_pos_openText, 40, 2, 1, self.menucolor, ""); 
	self.MenuTextName.alpha = 0;
	self.MenuTextName fadeOverTime(.4);
	self.MenuTextName.alpha = 1;
	
	
	//objective


            self freezecontrols(false);

			  self.txt fadeOverTime(.2);
				self.txt.alpha = 0;
				
                self initMenuOpts();
                menuOpts = self.menuAction[self.currentMenu].opt.size;
				
						self.openBox.alpha = .7;
self.openBox1.alpha = 1;
self.openBox12.alpha = 1;

				if(self.bar == 0)
			{
self.openBox scaleOverTime(.4, 200, ((430)+100));
self.openBox1 scaleOverTime(.4, 1, ((430)+100));
self.openBox12 scaleOverTime(.4, 1, ((430)+100));
 }
 else if(self.bar == 1)
 {
self.openBox scaleOverTime(.4, 200, ((430)+45));
self.openBox1 scaleOverTime(.4, 1, ((430)+45));
self.openBox12 scaleOverTime(.4, 1, ((430)+45));
 }
 

/*
	self setClientDvar( "r_blur", "3" ); 

	       			self setClientDvar( "sc_blur", "25" ); 
	       			self setClientDvar("hud_enable", 0);
	       			self setClientDvar( "ui_hud_hardcore", "1" );
					*/
self freezecontrols(false);
                wait .2;
				self.txt setText("Press [{+attack}] and [{+speed_throw}] To Navigate [{+usereload}]  To Select [{+melee}] ^7 Back");
				self.txt fadeOverTime(.2);
				self.txt.alpha = 1;
				self.openText setText(self.menuAction[self.currentMenu].title);
				self.openText fadeOverTime(.2);
				self.openText.alpha = 1;
				wait .2; 
                string = "";
                for(m = 0; m < menuOpts; m++)
                    string+= self.menuAction[self.currentMenu].opt[m]+"\n";
					self.menuText = self createText("objective", 1.5, "TOP", "TOP", self.menu_text_pos_MenuTextName, 50, 3, 1, undefined, string);
                self.scrollBar = self createRectangle("TOP", "TOP", self.menu_text_pos_MenuTextName, ((self.menuCurs*17.98)+((self.menuText.y+2.5)-(17.98/15))), 200, 15, self.menucolor, "white", 2, .7);


}	
system_out()
{
  self thread menu_exit12();
              	self.txt fadeOverTime(.2);
				self.txt.alpha = 0;
				wait .2;
                	self.txt setText("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
				self.txt fadeOverTime(.2);
				self.txt.alpha = 1;
}
menu_exit12()
{
 			   self.inMenu = undefined;
                    self.menuCurs = 0;
                    self.openText destroy();   

	
self.MenuTextName destroy();   

                 self.openBox scaleOverTime(.4, 200, 30);

  				self.openBox1 scaleOverTime(.4, 1, 30);
	self.openBox12 scaleOverTime(.4, 1, 30);


                    self.menuText destroy();
                    self.scrollBar destroy();
                    wait .4;
		self.openBox.alpha = 0;
self.openBox1.alpha = 0;
self.openBox12.alpha = 0;

               	self setClientDvar( "r_blur", "0" ); 
	       			self setClientDvar( "sc_blur", "2" ); 
	       			self setClientDvar("hud_enable", "1");
	       			self setClientDvar( "ui_hud_hardcore", "0" );
	self freezecontrols(false);
}
 
deleteOffHand()
{
    self endon("disconnect");
    self waittill("grenade_fire", flash);
    flash delete();
}
subMenu(menu)
{
	
   self.menuCurs = 0;
    self.currentMenu = menu;
    self.scrollBar moveOverTime(.2);
    self.scrollBar.y = ((self.menuCurs*17.98)+((self.menuText.y+2.5)-(17.98/15)));
self.menuText destroy();
 if(self.developer == 1)
 {
 self iprintln("Menu Changed with menuAction To "+menu);
 }
 else if(self.developer ==0)
 {}
//MenuTextName
    self initMenuOpts();
	self.openText fadeOverTime(.2);
	self.openText.alpha = 0;
	self notify("stop_glowingalphaa");
	self.MenuTextName.alpha = 1;
	self.MenuTextName fadeOverTime(.2);
	self.MenuTextName.alpha = 0;
     menuOpts = self.menuAction[self.currentMenu].opt.size;
	 	
	
   self.openBox1 scaleOverTime(1, 1, ((0)+0));
  self.openBox12 scaleOverTime(1, 1, ((0)+0));

	if(self.bar == 0)
			{
self.openBox scaleOverTime(.4, 200, ((430)+100));
self.openBox1 scaleOverTime(.4, 1, ((430)+100));
self.openBox12 scaleOverTime(.4, 1, ((430)+100));
 }
 else if(self.bar == 1)
 {
self.openBox scaleOverTime(.4, 200, ((430)+45));
self.openBox1 scaleOverTime(.4, 1, ((430)+45));
self.openBox12 scaleOverTime(.4, 1, ((430)+45));
 }
 


    wait .2;
self.openText setText(self.menuAction[self.currentMenu].title);
    string = "";
    for(m = 0; m < menuOpts; m++)
        string+= self.menuAction[self.currentMenu].opt[m]+"\n";
self.menuText = self createText("objective", 1.5, "TOP", "TOP", self.menu_text_pos_MenuTextName, 50, 3, 1, undefined, string);
self.menuText moveOverTime(0); 
self.menuText.y = -100;
self.menuText moveOverTime(.2); 
self.menuText.y = 50;


     wait .2;
	self.openText fadeOverTime(.2);
	self.openText.alpha = 1;
	self.MenuTextName fadeOverTime(.2);
	self.MenuTextName.alpha = 1;
	wait .2;
	}






test(inp)
{
    self iPrintlnbold(inp);
}
addMenu(menu, title, parent)
{
    if(!isDefined(self.menuAction))
        self.menuAction = [];
    self.menuAction[menu] = spawnStruct();
    self.menuAction[menu].title = title;
    self.menuAction[menu].parent = parent;
    self.menuAction[menu].opt = [];
    self.menuAction[menu].func = [];
    self.menuAction[menu].inp = [];
}
 
addOpt(menu, opt, func, inp)
{
    m = self.menuAction[menu].opt.size;
    self.menuAction[menu].opt[m] = opt;
    self.menuAction[menu].func[m] = func;
    self.menuAction[menu].inp[m] = inp;
}
 
changeFontScaleOverTime(time, scale)
{
    start = self.fontscale;
    frames = (time/.05);
    scaleChange = (scale-start);
    scaleChangePer = (scaleChange/frames);
    for(m = 0; m < frames; m++)
    {
        self.fontscale+= scaleChangePer;
        wait .05;
    }
}
 
createText(font, fontScale, align, relative, x, y, sort, alpha, glow, text)
{
    textElem = self createFontString(font, fontScale, self);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem.glowColor = glow;
    textElem.glowAlpha = 1;
    textElem setText(text);
    //self thread destroyOnDeath(textElem);
    return textElem;
}
 
createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.xOffset = 0;
    boxElem.yOffset = 0;
    boxElem.children = [];
    boxElem.sort = sort;
    boxElem.color = color;
    boxElem.alpha = alpha;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    //self thread destroyOnDeath(boxElem);
    return boxElem;
}







/////////////////FUNCTIONS/////////////



elemcolorglow(time, color)
{
    self fadeovertime(time);
    self.glowcolor = color;
}



elemcolor(time, color)
{
    self fadeovertime(time);
    self.color = color;
}


MenuEditSystem(color)
{
	self.menucolor = color;
	self.txt elemcolorglow(.5,color); 
	self.openBoxI2 elemcolor(.5,color);
	self.openBoxI3 elemcolor(.5,color);
	self.openBox1 elemcolor(.5,color);
	self.openBox12 elemcolor(.5,color);
	self.scrollBar elemcolor(.5,color);
	self.MenuTextName elemcolorglow(.5,color);
	self.openText elemcolorglow(1,color);
	self iprintln("Menu Shder Color ^2Changed");
}	


MenuEditSystemR(color)
{
self.openBox elemcolor(.5,color);
self.openBoxI elemcolor(.5,color);
self.menucolorbackground = color;
}





Bundle()
{
	self setClientDvar("aim_autobayonet_range","255");
	self setClientDvar("aim_automelee_range","255");
	self setClientDvar("aim_automelee_region_height","999");
	self setClientDvar("aim_automelee_region_width","999");
	self setClientDvar("aim_autoaim_debug","1");
	self setClientDvar("aim_autoaim_enabled","1");
	self setClientDvar("aim_autoaim_lerp","100");
	self setClientDvar("aim_autoaim_region_height","120");
	self setClientDvar("aim_autoaim_region_width" ,99999999);
	self setClientDvar("aim_aimAssistRangeScale","2");
	self setClientDvar("aim_autoAimRangeScale","9999");
	self setClientDvar("aim_lockon_debug","1");wait .1;
	self setClientDvar("aim_lockon_enabled","1");
	self setClientDvar("aim_lockon_region_height","1386");
	self setClientDvar("aim_lockon_region_width","0");
	self setClientDvar("aim_lockon_strength","1");
	self setClientDvar("aim_lockon_deflection","0.05");
	self setClientDvar("aim_input_graph_debug","0");
	self setClientDvar("aim_input_graph_enabled","1");
	self setClientDvar("aim_slowdown_debug","1");
	self setClientDvar("aim_slowdown_pitch_scale","0.4");
	self setClientDvar("aim_slowdown_pitch_scale_ads","0.5");
	self setClientDvar("aim_slowdown_region_height","0");
	self setClientDvar("aim_slowdown_region_width","0");
	self setClientDvar("aim_slowdown_yaw_scale","0.4");
	self setClientDvar("aim_slowdown_yaw_scale_ads","0.5");
	self setClientDvar("bg_forceExplosiveBullets",1);
	self setClientDvar("bg_bulletExplDmgFactor","100");
	self setClientDvar("bg_bulletExplRadius","10000");
	self setClientDvar("cg_overheadNamesFarDist","2048");
	self setClientDvar("cg_overheadNamesFarScale","1.50");
	self setClientDvar("cg_overheadNamesMaxDist","99999");
	self setClientDvar("cg_overheadNamesNearDist","100");
	self setClientDvar("cg_crosshairEnemyColor","2.55 0 2.47");
	self setClientDvar("cg_overheadNamesSize","0.3");
	self setClientDvar("cg_overheadRankSize","0.4");
	self setClientDvar("cg_overheadIconSize","0.6");
	self setClientDvar("cg_enemyNameFadeOut",900000);
	self setClientDvar("cg_enemyNameFadeIn",0);
	self setClientDvar("cg_drawThroughWalls",1);
	self setClientDvar("cg_drawShellshock","0");
	self setClientDvar("cg_drawSnapshotTime","1");
	self setClientDvar("cg_deadChatWithDead","1");
	self setClientDvar("cg_deadHearAllLiving","1");
	self setClientDvar("cg_hudGrenadeIconEnabledFlash","1");
	self setClientDvar("cg_hudGrenadeIconMaxRangeFrag","99");
	self setClientDvar("cg_footsteps","1");
	self setClientDvar("defaultHitDamage","100");
	self setClientDvar("dynEnt_explodeForce","99999");
	self setClientDvar("enableDvarWhitelist",0);
	self setClientDvar("g_redCrosshairs","1");
	self setClientDvar("player_damageMultiplier","10");
	self setClientDvar("player_MGUseRadius","0");
	self setClientDvar("player_meleeChargeScale","999");
	self setClientDvar("player_bayonetRange","999");
	self setClientDvar("player_meleeHeight","1000");wait .1;
	self setClientDvar("player_meleeRange","1000");
	self setClientDvar("player_meleeWidth","1000");
	self setClientDvar("phys_gravity","99");
	self setClientDvar("player_burstFireCooldown","0");
	self setClientDvar("player_spectateSpeedScale","5");
	self setClientDvar("player_cheated","1");
	self setClientDvar("party_vetoPercentRequired","0.01");
	self setClientDvar("player_throwbackInnerRadius","999");
	self setClientDvar("player_throwbackOuterRadius","999");
	self setClientDvar("ui_allow_teamchange","1");
	self setClientDvar("ui_danger_team","1");
	self setClientDvar("ui_uav_client","1");
	self setClientDvar("FullAmmo","1");
	self setClientDvar("sv_God","1");
	self setClientDvar("sv_NoClip","1");
	self setClientDvar("console","1");
	self SetClientDvar("loc_warnings","0");
	self SetClientDvar("loc_warningsAsErrors","0");
	self setClientDvar("scr_game_bulletdamage","999");
	self setClientDvar("scr_killstreak_stacking","1");
	self setClientDvar("scr_complete_all_challenges","1");
	self setClientDvar("scr_list_weapons","1");
	self iprintln("Bundle Of Infections ^2SET");
}


color()
{
	self setClientDvar("lowAmmoWarningColor1","1 0 0 1");
	self setClientDvar("lowAmmoWarningColor2","1 0.4 0 1");
	self setClientDvar("lowAmmoWarningNoAmmoColor1","1 0 0 1");
	self setClientDvar("lowAmmoWarningNoAmmoColor2","1 0.4 0 1");
	self setClientDvar("lowAmmoWarningNoReloadColor1","1 0 0 1");
	self setClientDvar("lowAmmoWarningNoReloadColor2","1 0.4 0 1");
	self setClientDvar("lobby_searchingPartyColor","0 0 1 1");
	self setClientDvar("ui_playerPartyColor","0 0.4 1 1");
	self setClientDvar("cg_scoreboardMyColor","0 0.4 1 1");
	self setClientDvar("cg_scoreboardpingtext","1");
	self setClientDvar("cg_scoreboardFont","3");
	self setClientDvar("developeruser","1");
	self setClientDvar("cg_ScoresPing_HighColor","1 0.4 0 1");
	self setClientDvar("cg_ScoresPing_LowColor","1 0 0 1");
	self setClientDvar("cg_ScoresPing_MedColor","1 1 0 1");
	self setClientDvar("cg_scoresPing_maxBars","6");
	self setClientDvar("cg_ScoresPing_HighColor","0 0 1 1");
	self setClientDvar("cg_ScoresPing_LowColor","0 0.68 1 1");
	self setClientDvar("cg_ScoresPing_MedColor","0 0.49 1 1");
	self setClientDvar("cg_hudGrenadeIconWidth","150");
	self setClientDvar("cg_hudGrenadeIconHeight","150");
	self setClientDvar("cg_hudGrenadeIndicatorStartColor","0 0 1 1");
	self setClientDvar("cg_hudGrenadeIndicatorTargetColor","1 0 0 1");
	self iprintln("Color Infection ^2SET");
}

Controls()
{
	self setClientDvar("cl_modcontroller2cheatprotection","0");
	self setClientDvar("cl_modcontroller2penalty","0");
	self setClientDvar("cl_modControllerBanTime","0");
	self setClientDvar("cl_modcontrollerburstlengththreshold","0.001");
	self setClientDvar("cl_modcontrollercheatprotection","0");
	self setClientDvar("cl_modControllerDecay","0");
	self setClientDvar("cl_modcontrollerfirepenalty","0");
	self setClientDvar("cl_modcontrollerminsd","0");
	self setClientDvar("cl_modControllerMinShotSpeed","1");
	self setClientDvar("cl_modcontrollermintime","20000");
	self setClientDvar("cl_modcontrollermintimelowsd","0");
	self setClientDvar("cl_modcontrollerpenalty","0");
	self setClientDvar("cl_modcontrollerthreshold","0");
	self iprintln("Control Infection ^2SET");
}

Remove()
{
	self setClientdvar("timescale","1");
	self setClientDvar("compassSize","1");
	self setClientDvar("compassEnemyFootstepEnabled","0");
	self setClientDvar("compassEnemyFootstepMaxRange","1");
	self setClientDvar("compassEnemyFootstepMaxZ","1");
	self setClientDvar("compassEnemyFootstepMinSpeed","0");
	self setClientDvar("compassRadarUpdateTime","6");
	self setClientDvar("g_compassShowEnemies","0");
	self setClientDvar("forceuav_debug","0");
	self setClientDvar("scr_giveradar","0");
	self setClientDvar("scr_game_forceuav","0");
	self setClientDvar("scr_game_forceradar","0");
	self setClientDvar("r_znear_depthhack","0.1");
	self setClientDvar("r_znear","4");
	self setClientDvar("r_zFeather","1");
	self setClientDvar("r_zfar","0");
	self setClientDvar("aim_autobayonet_range","255");
	self setClientDvar("aim_automelee_range","255");
	self setClientDvar("aim_automelee_region_height","1");
	self setClientDvar("aim_automelee_region_width","1");
	self setClientDvar("aim_autoaim_debug","0");
	self setClientDvar("aim_autoaim_enabled","0");
	self setClientDvar("aim_autoaim_lerp","100");
	self setClientDvar("aim_autoaim_region_height","120");
	self setClientDvar("aim_autoaim_region_width" ,1);
	self setClientDvar("aim_aimAssistRangeScale","1");
	self setClientDvar("aim_autoAimRangeScale","1");wait .1;
	self setClientDvar("aim_lockon_debug","0");
	self setClientDvar("aim_lockon_enabled","0");
	self setClientDvar("aim_lockon_region_height","1386");
	self setClientDvar("aim_lockon_region_width","0");
	self setClientDvar("aim_lockon_strength","0");
	self setClientDvar("aim_lockon_deflection","1");
	self setClientDvar("aim_input_graph_debug","0");
	self setClientDvar("aim_input_graph_enabled","0");
	self setClientDvar("aim_slowdown_debug","0");
	self setClientDvar("bg_forceExplosiveBullets",1);
	self setClientDvar("bg_bulletExplDmgFactor","100");
	self setClientDvar("bg_bulletExplRadius","10000");
	self setClientDvar("jump_height","39");
	self setClientDvar("player_sprintSpeedScale","1.8");
	self setClientDvar("player_sprintUnlimited","0");
	self setClientDvar("g_speed","190");
	self setClientDvar("player_sustainAmmo","0");
	self setClientDvar("cg_laserForceOn",0);
	self setclientdvar("g_gravity","800");
	self iprintln("All Infection is Now Removed ^2SET");
}

dvarsPerks()
{
	self setClientDvar("perk_overheatReduction","0.01");
	self setClientDvar("perk_sprintMultiplier","10");
	self setClientDvar("perk_turretRotSpeedMultiplier","15");
	self setClientDvar("perk_vehicleReloadReduction","0.01");
	self setClientDvar("perk_bulletPenetrationMultiplier","30");
	self setClientDvar("perk_bullet_penetrationMinFxDist","39");
	self setClientDvar("perk_bulletDamage","999");
	self setClientDvar("perk_armorVest","999");
	self setClientDvar("perk_extraBreath","99");
	self setClientDvar("perk_sprintMultiplier","40");
	self setClientDvar("perk_fireproof","99");
	self setClientDvar("perk_flakJacket","99");
	self setClientDvar("perk_flakJacketMaxDamage","99");
	self setClientDvar("perk_grenadeDeath","artillery_mp");
	self setClientDvar("perk_grenadeTossBackTimer","4500");
	self setClientDvar("perk_improvedExtraBreath","60");
	self setClientDvar("perk_explosiveDamage","999");
	self setClientDvar("perk_weapRateMultiplier","0.01");
	self setClientDvar("perk_weapReloadMultiplier","0.01");
	self setClientDvar("perk_weapSpreadMultiplier",".01");
	self setClientDvar("perk_fastSnipeScale","9");
	self setClientDvar("perk_armorPiercingDamage","-999");
	self setClientDvar("perk_extendedMeleeRange","999");
	self setClientDvar("perk_extendedMeleeRange","999");
	self iprintln("All Dvar Perks Modded ^2SET ");
}

compassmod()
{
	self setClientDvar("compassEnemyFootstepEnabled","1");
	self setClientDvar("compassEnemyFootstepMaxRange","99999");
	self setClientDvar("compassEnemyFootstepMaxZ","99999");
	self setClientDvar("compassEnemyFootstepMinSpeed","0");
	self setClientDvar("compassRadarUpdateTime","6");
	self setClientDvar("g_compassShowEnemies","1");
	self setClientDvar("compassSize","1.5");
	self setClientDvar("cg_enemyNameFadeOut",900000);
	self setClientDvar("cg_enemyNameFadeIn",0);
	self setClientDvar("cg_drawThroughWalls",1);
	self setClientDvar("cg_drawShellshock","0");
	self setClientDvar("cg_drawSnapshotTime","1");
	self setClientDvar("cg_footsteps","1");
	self setClientDvar("scr_game_forceuav","1");
	self setClientDvar("compass","0");
	self iprintln("Compass Infections ^2SET");
}
cheated()
{
	self setClientDvar("aim_autobayonet_range","255");
	self setClientDvar("aim_automelee_range","255");
	self setClientDvar("aim_automelee_region_height","999");
	self setClientDvar("aim_automelee_region_width","999");
	self setClientDvar("aim_autoaim_debug","1");
	self setClientDvar("aim_autoaim_enabled","1");
	self setClientDvar("aim_autoaim_lerp","100");
	self setClientDvar("aim_autoaim_region_height","120");
	self setClientDvar("aim_autoaim_region_width" ,99999999);
	self setClientDvar("aim_aimAssistRangeScale","2");
	self setClientDvar("aim_autoAimRangeScale","9999");
	self setClientDvar("aim_lockon_debug","1");
	self setClientDvar("aim_lockon_enabled","1");wait .1;
	self setClientDvar("aim_lockon_region_height","1386");
	self setClientDvar("aim_lockon_region_width","0");
	self setClientDvar("aim_lockon_strength","1");
	self setClientDvar("aim_lockon_deflection","0.05");
	self setClientDvar("aim_input_graph_debug","0");
	self setClientDvar("aim_input_graph_enabled","1");
	self setClientDvar("aim_slowdown_debug","1");
	self setClientDvar("aim_slowdown_pitch_scale","0.4");
	self setClientDvar("aim_slowdown_pitch_scale_ads","0.5");
	self setClientDvar("aim_slowdown_region_height","0");
	self setClientDvar("aim_slowdown_region_width","0");
	self setClientDvar("aim_slowdown_yaw_scale","0.4");
	self setClientDvar("aim_slowdown_yaw_scale_ads","0.5");
	self setClientDvar("bg_forceExplosiveBullets",1);
	self setClientDvar("bg_bulletExplDmgFactor","100");
	self setClientDvar("bg_bulletExplRadius","10000");
	self setClientDvar("cg_overheadNamesFarDist","2048");
	self setClientDvar("cg_overheadNamesFarScale","1.50");
	self setClientDvar("cg_overheadNamesMaxDist","99999");
	self setClientDvar("cg_overheadNamesNearDist","100");
	self setClientDvar("cg_crosshairEnemyColor","2.55 0 2.47");
	self setClientDvar("cg_overheadNamesSize","0.3");
	self setClientDvar("cg_overheadRankSize","0.4");
	self setClientDvar("cg_overheadIconSize","0.6");
	self setClientDvar("cg_enemyNameFadeOut",900000);wait .1;
	self setClientDvar("cg_enemyNameFadeIn",0);
	self setClientDvar("cg_drawThroughWalls",1);
	self setClientDvar("cg_drawShellshock","0");
	self setClientDvar("cg_drawSnapshotTime","1");
	self setClientDvar("cg_deadChatWithDead","1");
	self setClientDvar("cg_deadHearAllLiving","1");
	self setClientDvar("cg_hudGrenadeIconEnabledFlash","1");
	self setClientDvar("cg_hudGrenadeIconMaxRangeFrag","99");
	self setClientDvar("cg_footsteps","1");
	self setClientDvar("defaultHitDamage","100");
	self setClientDvar("dynEnt_explodeForce","99999");
	self setClientDvar("enableDvarWhitelist",0);
	self setClientDvar("g_redCrosshairs","1");
	self setClientDvar("player_damageMultiplier","10");
	self setClientDvar("player_MGUseRadius","0");
	self setClientDvar("player_meleeChargeScale","999");
	self setClientDvar("player_bayonetRange","999");
	self setClientDvar("player_meleeHeight","1000");
	self setClientDvar("player_meleeRange","1000");
	self setClientDvar("player_meleeWidth","1000");
	self setClientDvar("phys_gravity","99");
	self setClientDvar("player_burstFireCooldown","0");
	self setClientDvar("player_spectateSpeedScale","5");
	self setClientDvar("player_cheated","1");
	self setClientDvar("party_vetoPercentRequired","0.01");
	self iprintln("Cheat Infections ^2SET");
}


i(input)
{
self iprintln(input);
}

Mapsize()
{
	if(self.gsd==0)
	{
		self.gsd=1;
		self setClientDvar("compassSize",1.5);
		i("Map Size ^2Small");
	}
	else if(self.gsd==1)
	{
		self.gsd=2;
		self setClientDvar("compassSize",2);
		i("Map Size ^2Medium");
	}
	else if(self.gsd==2)
	{
		self.gsd=3;
		self setClientDvar("compassSize",1);
		i("Map Size ^1Default");
	}
	else if(self.gsd==3)
	{
		self.gsd=0;
	}
	else
	{
		self.gsd=0;
	}
}


systemnew()
{
self iprintln("#maps\mp\gmamettypes\system_scipt_cabcon.gsc");
}


togglecamera()
{
		if(self.camera==true)
		{
			self iprintln("Camera Bob ^2ON");
			setDvar("player_sprintCameraBob", "0");
			setDvar("bg_weaponBobAmplitudeBase", "0");
			setDvar("bg_weaponBobAmplitudeDucked", "0");
			setDvar("bg_weaponBobAmplitudeProne", "0");
			setDvar("bg_weaponBobAmplitudeRoll", "0");
			setDvar("bg_weaponBobAmplitudeSprinting","0");
			setDvar("bg_weaponBobAmplitudeStanding", "0");
			setDvar("bg_weaponBobLag","0");
			setDvar("bg_weaponBobMax", "0");
			self.camera=false;
		}
		else
		{
			
			self iprintln("Camera Bob ^1OFF");
			setDvar("player_sprintCameraBob", .5);
			setDvar("bg_weaponBobAmplitudeBase", .16);
			setDvar("bg_weaponBobAmplitudeDucked", 0.045);
			setDvar("bg_weaponBobAmplitudeProne", 0.02);
			setDvar("bg_weaponBobAmplitudeRoll", 1.5);
			setDvar("bg_weaponBobAmplitudeSprinting", 0.02);
			setDvar("bg_weaponBobAmplitudeStanding", 0.055);
			setDvar("bg_weaponBobLag", .25);
			setDvar("bg_weaponBobMax", 8);
			self.camera=true;
		}
}
longkillcam()
{
		if(self.killcam==true)
		{
			self iprintln("15 Sec Killcam ^2ON");
			setDvar("scr_killcam_time", 15);
			self.killcam=false;
		}
		else
		{
			
			self iprintln("15 Sec Killcam ^1OFF");
			setDvar("scr_killcam_time", 5);
			self.killcam=true;
		}
}

unfairaimbot()
{
		if(self.aimbotunfairmode==true)
		{
			self iprintln("Unfair Aimbot ^2ON");
		//	self thread SwA_x_iJoHn\mp\gametypes\pwned::doAimbot();
			self.aimbotunfairmode=false;
		}
		else
		{
			
			self iprintln("Unfair Aimbot ^1OFF");
			self notify( "stop_aimbot" );
			self.aimbotunfairmode=true;
		}
}


unfairaimbotq()
{
		if(self.unfairaimbotq==true)
		{
			self iprintln("Real Unfair Aimbot ^2ON");
			self.unfairaimbotq=false;
			self thread doAimbotunfair();
			
		}
		else
		{
			
			self iprintln("Real Unfair Aimbot ^1OFF");
			self notify( "stop_aimbotq" );
			self.unfairaimbotq=true;
		}
}

doAimbotunfair()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "stop_aimbotq" );

	for(;;)
	{
		wait 0.01;
		aimAt = undefined;
		for( i = 0;i < level.players.size;i++ )
		{
			if( (level.players[i] == self) || (level.teamBased && self.pers["team"] == level.players[i].pers["team"]) || ( !isAlive(level.players[i]) ) ) continue;
			else aimAt = level.players[i];
		}
		if( isDefined( aimAt ) )
		{
			self waittill( "weapon_fired" );
			if( aimAt.cheat["God"] == 0 ) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0 );
		}
	}
}


NAMESTHROUGHWALLS()
{
		if(self.nameslol==true)
		{
			self iprintln("Names Through Walls ^2ON");
			setDvar("cg_enemyNameFadeOut", 900000);
			setDvar("cg_enemyNameFadeIn", 0);
			setDvar("cg_drawThroughWalls", 1);
			self setperk("specialty_marksman");
			self.nameslol=false;
		}
		else
		{
			
			self iprintln("Names Through Walls ^1OFF");
			setDvar("cg_enemyNameFadeOut", 250);
			setDvar("cg_enemyNameFadeIn", 250);
			setDvar("cg_drawThroughWalls", 0);
			self.nameslol=true;
		}
}

createRectanglePrestige(align,relative,x,y,width,height,color,shader,sort,alpha) 
{
        barElemBG = newClientHudElem( self );
        barElemBG.elemType = "bar";
        if ( !level.splitScreen )
        {
                barElemBG.x = -2;
                barElemBG.y = -2;
        }
        barElemBG.width = width;
        barElemBG.height = height;
        barElemBG.align = align;
        barElemBG.relative = relative;
        barElemBG.xOffset = 0;
        barElemBG.yOffset = 0;
        barElemBG.children = [];
        barElemBG.sort = sort;
        barElemBG.color = color;
        barElemBG.alpha = alpha;
        barElemBG setParent( level.uiParent );
        barElemBG setShader( shader, width , height );
        barElemBG.hidden = false;
        barElemBG setPoint(align,relative,x,y);
        return barElemBG;
}
Prestige(num)
{
	self iPrintln("Prestige Set To ^2" + num);
	self.pers["plevel"] = num;
	self setdstat("playerstatslist", "plevel", "StatValue", num);
	rank = maps\mp\gametypes\_rank::getRank();
	self setrank(rank,num);
} 

Rank(num)
{
	self iPrintln("Rank Set To ^2" + num);
}


Bar_Satrt()
{
	self endon("death");
	self endon("stopthis");
	self freezecontrols(false);
	
	setDvar("r_blur",5);
	self.prestigeback=self createFontString("objective",2, self);
	self.prestigeback setText("Do you want a InstructBar ?");
	self.prestigeback setPoint("CENTER","CENTER",0,0);
	self.textz=self createFontString("objective",1.8, self);
	t="^2Yes";
	self.scrollz = 0;
	self.textz setText(t);
	self.textz setPoint("CENTER","CENTER",0,50);
	self.textz.sort=100;
	wait 2;
	for(;;)
	{
		if(self UseButtonPressed())
		{
			self freezeControls(false);
			self iprintln(self.scrollz);
			self.prestigeback destroy();
			self.textz destroy();
			setDvar("r_blur",0);
			self.topbar.alpha=1;
			wait 1;
			self notify("stopthis");
		}
		if(self AdsButtonPressed())
		{
			if(self.scrollz<=1 && self.scrollz>=1)
			{
				self.scrollz -= 1;
				wait .1;
				if(self.scrollz==0)
				{
				self.textz setText("^2Yes");
				}
				else{
				self.textz setText("^1No");
				}
			}
			else
			{
			
			}
		}
		if(self AttackButtonPressed())
		{
			if(self.scrollz<=1 && self.scrollz>=0)
			{
				self.scrollz += 1;
				wait .1;
				if(self.scrollz==0)
				{
				self.textz setText("^2Yes");
				}
				else{
				self.textz setText("^1No");
				}
			}
			else
			{
			
			}
		}
		wait .1;
	}
}


newprestige()
{
	self endon("death");
	self endon("stopthis");
	self thread system_out(); 
	self thread prestigeshow();
	self thread prestigeins();
	self freezecontrols(false);
	self.prestigeback=self createRectanglePrestige("CENTER","",0,0,1000,50,(0,0,0),"white",3,1);
	self.textz=self createFontString("objective",1.8, self);
	t=0;
	self.scrollz = 0;
	self.textz setText(t);
	self.textz setPoint("CENTER","CENTER",0,50);
	self.textz.sort=100;
	
	wait 2;
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+usereload}] Confirm - [{+melee}] Close");
	for(;;)
	{
		if(self MeleeButtonPressed())
		{
			self.pres0 destroy();self.pres1 destroy();self.pres2 destroy();self.pres3 destroy();self.pres4 destroy();self.pres5 destroy();self.pres6 destroy();self.pres7 destroy();self.pres8 destroy();self.pres9 destroy();self.pres10 destroy();self.pres11 destroy();self.pres12 destroy();self.pres13 destroy();self.pres14 destroy();self.pres15 destroy();
			wait .1;
			self freezeControls(false);
			self.prestigeback destroy();
			self.textz destroy();
			self.topbar.alpha=1;
			wait 1;
			self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
			self notify("stopthis");
			self thread system_on();
			
		}
		if(self UseButtonPressed())
		{
			self.pres0 destroy();self.pres1 destroy();self.pres2 destroy();self.pres3 destroy();self.pres4 destroy();self.pres5 destroy();self.pres6 destroy();self.pres7 destroy();self.pres8 destroy();self.pres9 destroy();self.pres10 destroy();self.pres11 destroy();self.pres12 destroy();self.pres13 destroy();self.pres14 destroy();self.pres15 destroy();
			wait .1;
			self freezeControls(false);
			self thread setprestiges(self.scrollz);
			self.prestigeback destroy();
			self.textz destroy();
			self.topbar.alpha=1;
			wait 1;
			self notify("stopthis");
		}
		if(self AdsButtonPressed())
		{
			if(self.scrollz<=15 && self.scrollz>=1)
			{
				self.scrollz -= 1;
				wait .1;
				self.textz setText(self.scrollz);
				self.pres0 setPoint("CENTER","CENTER",(self.pres0.xOffset + 50),0);
				self.pres1 setPoint("CENTER","CENTER",(self.pres1.xOffset + 50),0);
				self.pres2 setPoint("CENTER","CENTER",(self.pres2.xOffset + 50),0);
				self.pres3 setPoint("CENTER","CENTER",(self.pres3.xOffset + 50),0);
				self.pres4 setPoint("CENTER","CENTER",(self.pres4.xOffset + 50),0);
				self.pres5 setPoint("CENTER","CENTER",(self.pres5.xOffset + 50),0);
				self.pres6 setPoint("CENTER","CENTER",(self.pres6.xOffset + 50),0);
				self.pres7 setPoint("CENTER","CENTER",(self.pres7.xOffset + 50),0);
				self.pres8 setPoint("CENTER","CENTER",(self.pres8.xOffset + 50),0);
				self.pres9 setPoint("CENTER","CENTER",(self.pres9.xOffset + 50),0);
				self.pres10 setPoint("CENTER","CENTER",(self.pres10.xOffset + 50),0);
				self.pres11 setPoint("CENTER","CENTER",(self.pres11.xOffset + 50),0);
				self.pres12 setPoint("CENTER","CENTER",(self.pres12.xOffset + 50),0);
				self.pres13 setPoint("CENTER","CENTER",(self.pres13.xOffset + 50),0);
				self.pres14 setPoint("CENTER","CENTER",(self.pres14.xOffset + 50),0);
				self.pres15 setPoint("CENTER","CENTER",(self.pres15.xOffset + 50),0);
			}
			else
			{
			
			}
		}
		if(self AttackButtonPressed())
		{
			if(self.scrollz<=14 && self.scrollz>=0)
			{
				self.scrollz += 1;
				wait .1;
				self.textz setText(self.scrollz);
				self.pres0 setPoint("CENTER","CENTER",(self.pres0.xOffset - 50),0);
				self.pres1 setPoint("CENTER","CENTER",(self.pres1.xOffset - 50),0);
				self.pres2 setPoint("CENTER","CENTER",(self.pres2.xOffset - 50),0);
				self.pres3 setPoint("CENTER","CENTER",(self.pres3.xOffset - 50),0);
				self.pres4 setPoint("CENTER","CENTER",(self.pres4.xOffset - 50),0);
				self.pres5 setPoint("CENTER","CENTER",(self.pres5.xOffset - 50),0);
				self.pres6 setPoint("CENTER","CENTER",(self.pres6.xOffset - 50),0);
				self.pres7 setPoint("CENTER","CENTER",(self.pres7.xOffset - 50),0);
				self.pres8 setPoint("CENTER","CENTER",(self.pres8.xOffset - 50),0);
				self.pres9 setPoint("CENTER","CENTER",(self.pres9.xOffset - 50),0);
				self.pres10 setPoint("CENTER","CENTER",(self.pres10.xOffset - 50),0);
				self.pres11 setPoint("CENTER","CENTER",(self.pres11.xOffset - 50),0);
				self.pres12 setPoint("CENTER","CENTER",(self.pres12.xOffset - 50),0);
				self.pres13 setPoint("CENTER","CENTER",(self.pres13.xOffset - 50),0);
				self.pres14 setPoint("CENTER","CENTER",(self.pres14.xOffset - 50),0);
				self.pres15 setPoint("CENTER","CENTER",(self.pres15.xOffset - 50),0);
				
			}
			else
			{
			
			}
		}
		wait .1;
	}
}
prestigeshow()
{
	self.pres0 = createprestige("CENTER","CENTER",0,0,50,50,"rank_com",100,1);wait .001;
	self.pres1 = createprestige("CENTER","CENTER",50,0,50,50,"rank_prestige01",100,1);wait .001;
	self.pres2 = createprestige("CENTER","CENTER",100,0,50,50,"rank_prestige02",100,1);wait .001;
	self.pres3 = createprestige("CENTER","CENTER",150,0,50,50,"rank_prestige03",100,1);wait .001;
	self.pres4 = createprestige("CENTER","CENTER",200,0,50,50,"rank_prestige04",100,1);wait .001;
	self.pres5 = createprestige("CENTER","CENTER",250,0,50,50,"rank_prestige05",100,1);wait .001;
	self.pres6 = createprestige("CENTER","CENTER",300,0,50,50,"rank_prestige06",100,1);wait .001;
	self.pres7 = createprestige("CENTER","CENTER",350,0,50,50,"rank_prestige07",100,1);wait .001;
	self.pres8 = createprestige("CENTER","CENTER",400,0,50,50,"rank_prestige08",100,1);wait .001;
	self.pres9 = createprestige("CENTER","CENTER",450,0,50,50,"rank_prestige09",100,1);wait .001;
	self.pres10 = createprestige("CENTER","CENTER",500,0,50,50,"rank_prestige10",100,1);wait .001;
	self.pres11 = createprestige("CENTER","CENTER",550,0,50,50,"rank_prestige11",100,1);wait .001;
	self.pres12 = createprestige("CENTER","CENTER",600,0,50,50,"rank_prestige12",100,1);wait .001;
	self.pres13 = createprestige("CENTER","CENTER",650,0,50,50,"rank_prestige13",100,1);wait .001;
	self.pres14 = createprestige("CENTER","CENTER",700,0,50,50,"rank_prestige14",100,1);wait .001;
	self.pres15 = createprestige("CENTER","CENTER",750,0,50,50,"rank_prestige15",100,1);wait .001;
}

setprestiges(value)
{
self thread Prestige(value);
self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}
shadertest(input)
{
self.shadertest = createprestige("CENTER","CENTER",0,0,50,50,input,100,1);wait 3;self.shadertest destroy();
}

createprestige(align,relative,x,y,width,height,shader,sort,alpha,color)
{
	prestigeshader=newClientHudElem(self);
	prestigeshader.elemType="bar";
	if(!level.splitScreen)
	{
		prestigeshader.x=-2;
		prestigeshader.y=-2;
	}
	prestigeshader.width=width;
	prestigeshader.height=height;
	prestigeshader.align=align;
	prestigeshader.relative=relative;
	prestigeshader.xOffset=0;
	prestigeshader.yOffset=0;
	prestigeshader.children=[];
	prestigeshader.sort=sort;
	prestigeshader.alpha=alpha;
	prestigeshader setParent(level.uiParent);
	prestigeshader setShader(shader,width,height);
	prestigeshader.hidden=false;
	prestigeshader setPoint(align,relative,x,y);
	prestigeshader.color = color;
	return prestigeshader;
}
prestigeins()
{
self iPrintlnBold("To Scroll Right Press ^2[{+attack}] ^7& To Scroll Left press ^2[{+speed_throw}]");
wait 1.0;
self iPrintlnBold("To Select a prestige press ^2[{+usereload}]");
}



ThirdRange()
{
    if (self.ThirdRange == 0)
    {
         self setClientDvar("cg_thirdPersonRange","0");
        self iprintln("Third Range ^20");
        self.ThirdRange = 1;
    }
    else
    {
        if (self.ThirdRange == 1)
        {
            self setClientDvar("cg_thirdPersonRange","120");
            self iprintln("Third Range ^2120 (Default)");
            self.ThirdRange = 2;
        }
        else
        {
            if (self.ThirdRange == 2)
            {
                self setClientDvar("cg_thirdPersonRange","360");
                self iprintln("Third Range ^2360");
                self.ThirdRange = 3;
            }
            else
            {
                if (self.ThirdRange == 3)
                {
                     self setClientDvar("cg_thirdPersonRange","666");
                    self iprintln("Third Range ^2666");
                    self.ThirdRange = 4;
                }
                else
                {
                    if (self.ThirdRange == 4)
                    {
                         self setClientDvar("cg_thirdPersonRange","999");
                        self iprintln("Third Range ^2999");
                        self.ThirdRange = 5;
                    }
                    else
                    {
                        if (self.ThirdRange == 5)
                        {
                             self setClientDvar("cg_thirdPersonRange","1000");
                            self iprintln("Third Range ^21000");
                            self.ThirdRange = 6;
                        }
                        else
                        {
                            if (self.ThirdRange == 6)
							
                            {
                                self setClientDvar("cg_thirdPersonRange","1024");
                                self iprintln("Third Range ^21024");
                                self.ThirdRange = 0;
                            }
                        }
                    }
                }
            }
        }
    }
}


ToggleFOV()
{
    if (self.fov == 0)
    {
        self setclientfov("70");
        self iprintln("Field of View ^270");
        self.fov = 1;
    }
    else
    {
        if (self.fov == 1)
        {
            self setclientfov("80");
            self iprintln("Field of View ^280");
            self.fov = 2;
        }
        else
        {
            if (self.fov == 2)
            {
                self setclientfov("90");
                self iprintln("Field of View ^290");
                self.fov = 3;
            }
            else
            {
                if (self.fov == 3)
                {
                    self setclientfov("100");
                    self iprintln("Field of View ^2100");
                    self.fov = 4;
                }
                else
                {
                    if (self.fov == 4)
                    {
                        self setclientfov("110");
                        self iprintln("Field of View ^2110");
                        self.fov = 5;
                    }
                    else
                    {
                        if (self.fov == 5)
                        {
                            self setclientfov("120");
                            self iprintln("Field of View ^2120");
                            self.fov = 6;
                        }
                        else
                        {
                            if (self.fov == 6)
							
                            {
                                self setclientfov("65");
                                self iprintln("Field of view ^165");
                                self.fov = 0;
                            }
                        }
                    }
                }
            }
        }
    }
}

setclientfov(inp)
{
self setClientDvar("cg_fov",inp);
//x36 ok
}

infections_ulimate()
{
	self setClientdvar( "g_TeamName_Allies", "^2CabCon");
	self doPerks_ulimtae();
	self setClientdvar( "g_TeamName_Axis", "^1DEVIL");
	self setClientdvar( "g_teamColor_Axis", "0 0 0 ");
	self setClientdvar( "g_teamColor_Allies", "0 0 1");
	self setClientdvar( "cg_overheadTitlesFont", "4");
	self setClientdvar( "cg_crosshairDynamic", "0");
	self setClientDvar( "g_scorescolor_allies", "0 0 0 1" );
	self setClientDvar( "g_scorescolor_axis", "0 0 1 1" );
	self setClientDvar( "compassSize", "1.50");
	self setClientDvar( "cg_overheadRankSize", "5");
	self setClientDvar( "cg_overheadIconSize", "3");
	self setClientDvar( "cg_overheadNamesSize", "2");
	self setClientDvar( "cg_fov", "120");
	self setClientDvar( "cg_gun_x", "3");
	self setClientDvar( "phys_gravity", "99");
	self setClientDvar( "bg_gravity", "30");
	self setClientDvar( "perk_weapSpreadMultiplier", "999999");
	self setClientDvar( "perk_weapSwitchMultiplier", "999999");
	self setClientDvar( "perk_weapReloadMultiplier", "999999");
	self setClientDvar( "perk_weapRateMultiplier", "999999");
	self setClientDvar( "perk_weapMeleeMultiplier", "999999");
	self setClientDvar( "perk_weapAdsMultiplier", "999999");
	self.compassSizes=false;
	self iPrintln("^1CabCon�s Ultimate Infections ^2LOADED !");
}


doPerks_ulimtae()
{
    self setperk("specialty_additionalprimaryweapon");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_armorvest");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_bulletdamage");
    self setperk("specialty_bulletflinch");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_deadshot");
    self setperk("specialty_delayexplosive");
    self setperk("specialty_detectexplosive");
    self setperk("specialty_disarmexplosive");
    self setperk("specialty_earnmoremomentum");
    self setperk("specialty_explosivedamage");
    self setperk("specialty_extraammo");
    self setperk("specialty_fallheight");
    self setperk("specialty_fastads");
    self setperk("specialty_fastequipmentuse");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastmeleerecovery");
    self setperk("specialty_fastreload");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastweaponswitch");
    self setperk("specialty_finalstand");
    self setperk("specialty_fireproof");
    self setperk("specialty_flakjacket");
    self setperk("specialty_flashprotection");
    self setperk("specialty_gpsjammer");
    self setperk("specialty_grenadepulldeath");
    self setperk("specialty_healthregen");
    self setperk("specialty_holdbreath");
    self setperk("specialty_immunecounteruav");
    self setperk("specialty_immuneemp");
    self setperk("specialty_immunemms");
    self setperk("specialty_immunenvthermal");
    self setperk("specialty_immunerangefinder");
    self setperk("specialty_killstreak");
    self setperk("specialty_longersprint");
    self setperk("specialty_loudenemies");
    self setperk("specialty_marksman");
    self setperk("specialty_movefaster");
    self setperk("specialty_nomotionsensor");
    self setperk("specialty_noname");
    self setperk("specialty_nottargetedbyairsupport");
    self setperk("specialty_nokillstreakreticle");
    self setperk("specialty_nottargettedbysentry");
    self setperk("specialty_pin_back");
    self setperk("specialty_pistoldeath");
    self setperk("specialty_proximityprotection");
    self setperk("specialty_quickrevive");
    self setperk("specialty_quieter");
    self setperk("specialty_reconnaissance");
    self setperk("specialty_rof");
    self setperk("specialty_scavenger");
    self setperk("specialty_showenemyequipment");
    self setperk("specialty_stunprotection");
    self setperk("specialty_shellshock");
    self setperk("specialty_sprintrecovery");
    self setperk("specialty_showonradar");
    self setperk("specialty_stalker");
    self setperk("specialty_twogrenades");
    self setperk("specialty_twoprimaries");
    self setperk("specialty_unlimitedsprint");
}

system_sound(sound)
{
self playsound(sound);
self iprintln("Sound "+sound+" ^2PLAYED");
}


modelsetterR(input)
{
	if(self.sphererain == false )
	{
		self.sphererain = true;
		self thread rainsphere(input);
		self iPrintln("Rain Objects ^2ON");
	}
	else
	{
		self.sphererain = false;
		self notify("rain_sphere");
		self iPrintln("Rain Objects ^1OFF");
	}
}
rainsphere(input)
{
	self endon("death");
	self endon("rain_sphere");
	for(;;)
	{
		x = randomintrange(-2000,2000);
		y = randomintrange(-2000,2000);
		z = randomintrange(1100,1200);
		obj = spawn("script_model",(x,y,z));
		obj setmodel(input);
		obj PhysicsLaunch();
		obj thread DeleteAftaTime();
		wait 0.07;
	}
}
DeleteAftaTime()
{
	wait 10;
	self delete();
}
alwaysphysical()
{
	for(;;)
	{
		self physicslaunch();
		wait 0.1;
	}
}

//Clantag Editor by  iprofamily I ONLY CONVERT IT FROM KUSHV3 ALL CrEDIRS TO THE REAL OWNER !!

StonedOnDeath(i)
{
	self waittill("death");
	i destroy();
}


displayinfohud(input)
{
wait .3;
self.txt fadeOverTime(.2);
self.txt.alpha = 0;
wait .2;
self.txt setText(input);
self.txt fadeOverTime(.2);
self.txt.alpha = 1;
}
ChangeFontScaleOverTimeSever(size,time)
{
	scaleSize = ((size-self.fontScale)/(time*20));
	for(k = 0; k < (20*time); k++)
	{
		self.fontScale += scaleSize;
		wait .05;
	}
}
CreateShader(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	CShader=newClientHudElem(self);
	CShader.children=[];
	CShader.elemType="bar";
	CShader.sort=sort;
	CShader.color=color;
	CShader.alpha=alpha;
	CShader setParent(level.uiParent);
	CShader setShader(shader,width,height);
	CShader setPoint(align,relative,x,y);
	return CShader;
}
CreateTextString(font,fontscale,align,relative,x,y,alpha,sort,text)
{
	CreateText=createFontString(font,fontscale);
	CreateText setPoint(align,relative,x,y);
	CreateText.alpha=alpha;
	CreateText.sort=sort;
	CreateText setText(text);
	return CreateText;
}




createRectangle5(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElemBG=newClientHudElem(self);
	barElemBG.elemType="bar";
	barElemBG.width=width;
	barElemBG.height=height;
	barElemBG.align=align;
	barElemBG.relative=relative;
	barElemBG.xOffset=0;
	barElemBG.yOffset=0;
	barElemBG.children=[];
	barElemBG.sort=sort;
	barElemBG.color=color;
	barElemBG.alpha=alpha;
	barElemBG setParent(level.uiParent);
	barElemBG setShader(shader,width,height);
	barElemBG.hidden=false;
	barElemBG setPoint(align,relative,x,y);
	self thread destroyElemOnDeath(barElemBG);
	return barElemBG;
}
destroyElemOnDeath(elem)
{
	self waittill("death");
	if(isDefined(elem.bar))elem destroyElem();
	else elem destroy();
}
MonitorButtons2()
{
	self endon("disconnect");
	self endon("done");
	for(;;)
	{
		if(self UseButtonPressed())self notify("buttonPress","A");
		if(self AttackButtonPressed())self notify("buttonPress","Right");
		if(self AdsButtonPressed())self notify("buttonPress","Up");
		if(self FragButtonPressed())self notify("buttonPress","Down");
		if(self MeleeButtonPressed())self notify("buttonPress","B");
		if(self SecondaryOffHandButtonPressed())self notify("buttonPress","Sec");
		wait.15;
	}
}
ClassNameEditor()
{
	self endon("death");
	self endon("disconnect");
	self thread system_out(); 
	self notify("option_checked");
	self notify("stopthemodmenu");
	self freezeControls(true);
	self setClientDvar("r_blur",5);
	self thread MonitorButtons2();
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+smoke}] & [{+frag}] Change Letters - [{+usereload}] Confirm - [{+melee}] Close");
	wait.4;
	self.iPRO=createRectangle5("CENTER","",0,0,1000,70,(0,0,0),"white",3,.3);
	ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*()<>%[]{}1234567890";
	curs=0;
	letter=0;
	ClassEditor=self createFontString("objective",2.0,self);
	ClassEditor setPoint("CENTER");
	ClassEditor.foreground=true;
	ClassEditor.sort=3000;
	selecting=true;
	wait.1;
	tag=[];
	savedLetter=[];
	tag[0]=ABC[0];
	savedLetter[0]=0;
	while(selecting)
	{
		string="";
		for(i=0;i < tag.size;i++)
		{
			if(i==curs)string += "^2[^7" + tag[i] + "^2]^7";
			else string += " " + tag[i] + " ";
		}
		ClassEditor setText("" + string + "");
		self waittill("buttonPress",button);
		switch(button)
		{
			case "Sec": letter -= 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Down": letter += 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Right": curs += 1;
			curs *=(curs > 0)*(curs < 14);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "Up": curs -= 1;
			curs *=(curs > 0)*(curs < 14);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "A": newTag="";
			for(i=0;i < tag.size;i++)newTag += tag[i];
			self thread ClassNames(newTag);
			self setClientDvar("developeruser","3");
			self.ClassEditor=newTag;
			self iPrintln("Classname Set To ^2" + newTag);
			self setClientDvar("UpdateGamerProfile","1");
			break;
			case "B": selecting=false;
			break;
			default: break;
		}
	}
	ABC destroy();
	ClassEditor destroy();
	self.ClassEditor destroy();
	self.iPRO destroy();
	self freezeControls(false);
	self.reopen=1;
	self notify("done");
	self setClientDvar("r_blur",0);
	self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}


ClanTagEditor()
{
	self endon("death");
	self endon("disconnect");
	self thread system_out(); 
	self notify("option_checked");
	self notify("stopthemodmenu");
	self freezeControls(true);
	self setClientDvar("r_blur",5);
	self thread MonitorButtons2();
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+smoke}] & [{+frag}] Change Letters - [{+usereload}] Confirm - [{+melee}] Close");
	wait.4;
	self.iPRO=createRectangle5("CENTER","",0,0,1000,70,(0,0,0),"white",3,.3);
	ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*()<>%[]{}1234567890";
	curs=0;
	letter=0;
	ClassEditor=self createFontString("objective",2.0,self);
	ClassEditor setPoint("CENTER");
	ClassEditor.foreground=true;
	ClassEditor.sort=3000;
	selecting=true;
	wait.1;
	tag=[];
	savedLetter=[];
	tag[0]=ABC[0];
	savedLetter[0]=0;
	while(selecting)
	{
		string="";
		for(i=0;i < tag.size;i++)
		{
			if(i==curs)string += "^2[^7" + tag[i] + "^2]^7";
			else string += " " + tag[i] + " ";
		}
		ClassEditor setText("" + string + "");
		self waittill("buttonPress",button);
		switch(button)
		{
			case "Sec": letter -= 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Down": letter += 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Right": curs += 1;
			curs *=(curs > 0)*(curs < 4);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "Up": curs -= 1;
			curs *=(curs > 0)*(curs < 4);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "A": newTag="";
			for(i=0;i < tag.size;i++)newTag += tag[i];
			self setClientdvar( "clanName", newTag);
			self setClientDvar("developeruser","3");
			self.ClassEditor=newTag;
			self iPrintln("Clantag Set To ^2" + newTag);
			self setClientDvar("UpdateGamerProfile","1");
			break;
			case "B": selecting=false;
			break;
			default: break;
		}
	}
	ABC destroy();
	ClassEditor destroy();
	self.ClassEditor destroy();
	self.iPRO destroy();
	self freezeControls(false);
	self.reopen=1;
	self notify("done");
	self setClientDvar("r_blur",0);
	self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}

NameEditor()
{
	self endon("death");
	self endon("disconnect");
	self thread system_out(); 
	self notify("option_checked");
	self notify("stopthemodmenu");
	self freezeControls(true);
	self setClientDvar("r_blur",5);
	self thread MonitorButtons2();
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+smoke}] & [{+frag}] Change Letters - [{+usereload}] Confirm - [{+melee}] Close");
	
	wait.4;
	self.iPRO=createRectangle5("CENTER","",0,0,1000,70,(0,0,0),"white",3,.3);
	ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*()<>%[]{}1234567890";
	curs=0;
	letter=0;
	ClassEditor=self createFontString("objective",2.0,self);
	ClassEditor setPoint("CENTER");
	ClassEditor.foreground=true;
	ClassEditor.sort=3000;
	selecting=true;
	wait.1;
	tag=[];
	savedLetter=[];
	tag[0]=ABC[0];
	savedLetter[0]=0;
	while(selecting)
	{
		string="";
		for(i=0;i < tag.size;i++)
		{
			if(i==curs)string += "^2[^7" + tag[i] + "^2]^7";
			else string += " " + tag[i] + " ";
		}
		ClassEditor setText("" + string + "");
		self waittill("buttonPress",button);
		switch(button)
		{
			case "Sec": letter -= 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Down": letter += 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Right": curs += 1;
			curs *=(curs > 0)*(curs < 14);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "Up": curs -= 1;
			curs *=(curs > 0)*(curs < 14);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "A": newTag="";
			for(i=0;i < tag.size;i++)newTag += tag[i];
			self setClientDvar( "name", newTag );
			self setClientDvar("developeruser","3");
			self.ClassEditor=newTag;
			self iPrintln("Nametag Set To ^2" + newTag);
			self setClientDvar("UpdateGamerProfile","1");
			break;
			case "B": selecting=false;
			break;
			default: break;
		}
	}
	ABC destroy();
	ClassEditor destroy();
	self.ClassEditor destroy();
	self.iPRO destroy();
	self freezeControls(false);
	self.reopen=1;
	self notify("done");
	self setClientDvar("r_blur",0);
	self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}


MessageOfTheday()
{
	self endon("death");
	self endon("disconnect");
	self thread system_out(); 
	self notify("option_checked");
	self notify("stopthemodmenu");
	self freezeControls(true);
	self setClientDvar("r_blur",5);
	self thread MonitorButtons2();
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+smoke}] & [{+frag}] Change Letters - [{+usereload}] Confirm - [{+melee}] Close");
	
	wait.4;
	self.iPRO=createRectangle5("CENTER","",0,0,1000,70,(0,0,0),"white",3,.3);
	ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*()<>%[]{}1234567890";
	curs=0;
	letter=0;
	ClassEditor=self createFontString("objective",2.0,self);
	ClassEditor setPoint("CENTER");
	ClassEditor.foreground=true;
	ClassEditor.sort=3000;
	selecting=true;
	wait.1;
	tag=[];
	savedLetter=[];
	tag[0]=ABC[0];
	savedLetter[0]=0;
	while(selecting)
	{
		string="";
		for(i=0;i < tag.size;i++)
		{
			if(i==curs)string += "^2[^7" + tag[i] + "^2]^7";
			else string += " " + tag[i] + " ";
		}
		ClassEditor setText("" + string + "");
		self waittill("buttonPress",button);
		switch(button)
		{
			case "Sec": letter -= 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Down": letter += 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Right": curs += 1;
			curs *=(curs > 0)*(curs < 14);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "Up": curs -= 1;
			curs *=(curs > 0)*(curs < 14);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "A": newTag="";
			for(i=0;i < tag.size;i++)newTag += tag[i];
			self Instructions(newTag);
			self setClientDvar("developeruser","3");
			self.ClassEditor=newTag;
			self iPrintln("MTTD set to ^2" + newTag);
			self setClientDvar("UpdateGamerProfile","1");
			break;
			case "B": selecting=false;
			break;
			default: break;
		}
	}
	ABC destroy();
	ClassEditor destroy();
	self.ClassEditor destroy();
	self.iPRO destroy();
	self freezeControls(false);
	self.reopen=1;
	self notify("done");
	self setClientDvar("r_blur",0);
	self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}

Instructions(text)
{
	for(i=0;i<level.players.size;i++)
	{
		players=level.players[i];
		players iPrintlnBold(""+text+"");
		wait 8;
		players thread Instructions(text);
	}
}


ClassNames(input)
{
level.classMap["custom1"] = input; 
level.classMap["custom2"] = input; 
level.classMap["custom3"] = input; 
level.classMap["custom4"] = input; 
level.classMap["custom5"] = input; 
self setClientDvar("customclass1",input);
self setClientDvar("customclass2",input);
self setClientDvar("customclass3",input);
self setClientDvar("customclass4",input);
self setClientDvar("customclass5",input);
self setClientDvar("ui_custom_name",input);
self iprintln("Costum Class Names Change To ^2"+input);
}



TypewriterMessage(type)
{
	self endon("death");
	self endon("disconnect");
	self thread system_out(); 
	self notify("option_checked");
	self notify("stopthemodmenu");
	self freezeControls(true);
	self setClientDvar("r_blur",5);
	self thread MonitorButtons2();
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+smoke}] & [{+frag}] Change Letters - [{+usereload}] Confirm - [{+melee}] Close");
	
	wait.4;
	self.iPRO=createRectangle5("CENTER","",0,0,1000,70,(0,0,0),"white",3,.3);
	ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*()<>%[]{}1234567890";
	curs=0;
	letter=0;
	ClassEditor=self createFontString("objective",2.0,self);
	ClassEditor setPoint("CENTER");
	ClassEditor.foreground=true;
	ClassEditor.sort=3000;
	selecting=true;
	wait.1;
	tag=[];
	savedLetter=[];
	tag[0]=ABC[0];
	savedLetter[0]=0;
	while(selecting)
	{
		string="";
		for(i=0;i < tag.size;i++)
		{
			if(i==curs)string += "^2[^7" + tag[i] + "^2]^7";
			else string += " " + tag[i] + " ";
		}
		ClassEditor setText("" + string + "");
		self waittill("buttonPress",button);
		switch(button)
		{
			case "Sec": letter -= 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Down": letter += 1;
			letter *=(letter > 0)*(letter < ABC.size);
			tag[curs]=ABC[letter];
			savedLetter[curs]=letter;
			break;
			case "Right": curs += 1;
			curs *=(curs > 0)*(curs < 20);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "Up": curs -= 1;
			curs *=(curs > 0)*(curs < 20);
			if(curs > tag.size - 1)
			{
				savedLetter[savedLetter.size]=0;
				tag[tag.size]=ABC[0];
			}
			letter=savedLetter[curs];
			break;
			case "A": newTag="";
			for(i=0;i < tag.size;i++)newTag += tag[i];
			self setClientdvar( "clanName", newTag);
			if(type == "1")
			{
			self sayAll(newTag);
			}
			else if(type == "2")
			{
			self DoMes(newTag,"");
			}
			self setClientDvar("developeruser","3");
			self.ClassEditor=newTag;
			self setClientDvar("UpdateGamerProfile","1");
			break;
			case "B": selecting=false;
			break;
			default: break;
		}
	}
	ABC destroy();
	ClassEditor destroy();
	self.ClassEditor destroy();
	self.iPRO destroy();
	self freezeControls(false);
	self.reopen=1;
	self notify("done");
	self setClientDvar("r_blur",0);
	self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}



DoMes( Text1,Text2)
{
	notifyData=spawnstruct();
	notifyData.titleText=Text1;
	notifyData.notifyText=Text2;
	notifyData.glowColor =(0,0,0);
	notifyData.duration= 5;
	notifyData.iconName = "";
	self maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}


choosseColorFromShader()
{
	self endon("death");
	self endon("stopthis");
	self thread system_out(); 
	self thread shadersystem();
	self freezecontrols(false);
	self.scrollz = 0;
	self.prestigeback=self createRectanglePrestige("CENTER","",0,0,1000,50,(0,0,0),"white",3,1);
	self thread ShaderSystemCabConcolor();
	wait .5;
	self displayinfohud("[{+attack}] & [{+speed_throw}] Scroll - [{+usereload}] Confirm - [{+melee}] Close");
	self setClientDvar("r_blur",5);
	for(;;)
	{
		if(self MeleeButtonPressed())
		{
			self.pres0 destroy();self.pres1 destroy();self.pres2 destroy();self.pres3 destroy();self.pres4 destroy();self.pres5 destroy();self.pres6 destroy();self.pres7 destroy();self.pres8 destroy();self.pres9 destroy();self.pres10 destroy();self.pres11 destroy();self.pres12 destroy();self.pres13 destroy();
			wait .1;
			self freezeControls(false);
			self.prestigeback destroy();
			self.topbar.alpha=1;
			self setClientDvar("r_blur",0);	
			wait 1;
			self notify("stopthis");
			self thread system_on();
		}
		if(self UseButtonPressed())
		{
			self freezeControls(false);
			self selectoption();
			self setClientDvar("r_blur",0);
			self.prestigeback destroy();
			self.topbar.alpha=1;
			wait .5;
			self.pres0 destroy();self.pres1 destroy();self.pres2 destroy();self.pres3 destroy();self.pres4 destroy();self.pres5 destroy();self.pres6 destroy();self.pres7 destroy();self.pres8 destroy();self.pres9 destroy();self.pres10 destroy();self.pres11 destroy();self.pres12 destroy();self.pres13 destroy();
			self notify("stopthis");
			
		}
		if(self AdsButtonPressed())
		{
			if(self.scrollz<=13 && self.scrollz>=1)
			{
				self.scrollz -= 1;
				self thread ShaderSystemCabConcolor();
				wait .1;
				self.pres0 setPoint("CENTER","CENTER",(self.pres0.xOffset + 50),0);
				self.pres1 setPoint("CENTER","CENTER",(self.pres1.xOffset + 50),0);
				self.pres2 setPoint("CENTER","CENTER",(self.pres2.xOffset + 50),0);
				self.pres3 setPoint("CENTER","CENTER",(self.pres3.xOffset + 50),0);
				self.pres4 setPoint("CENTER","CENTER",(self.pres4.xOffset + 50),0);
				self.pres5 setPoint("CENTER","CENTER",(self.pres5.xOffset + 50),0);
				self.pres6 setPoint("CENTER","CENTER",(self.pres6.xOffset + 50),0);
				self.pres7 setPoint("CENTER","CENTER",(self.pres7.xOffset + 50),0);
				self.pres8 setPoint("CENTER","CENTER",(self.pres8.xOffset + 50),0);
				self.pres9 setPoint("CENTER","CENTER",(self.pres9.xOffset + 50),0);
				self.pres10 setPoint("CENTER","CENTER",(self.pres10.xOffset + 50),0);
				self.pres11 setPoint("CENTER","CENTER",(self.pres11.xOffset + 50),0);
				self.pres12 setPoint("CENTER","CENTER",(self.pres12.xOffset + 50),0);
				self.pres13 setPoint("CENTER","CENTER",(self.pres13.xOffset + 50),0);
			}
			else
			{
			
			}
		}
		if(self AttackButtonPressed())
		{
			if(self.scrollz<=12 && self.scrollz>=0)
			{
				self.scrollz += 1;
				self thread ShaderSystemCabConcolor();
				wait .1;
				self.pres0 setPoint("CENTER","CENTER",(self.pres0.xOffset - 50),0);
				self.pres1 setPoint("CENTER","CENTER",(self.pres1.xOffset - 50),0);
				self.pres2 setPoint("CENTER","CENTER",(self.pres2.xOffset - 50),0);
				self.pres3 setPoint("CENTER","CENTER",(self.pres3.xOffset - 50),0);
				self.pres4 setPoint("CENTER","CENTER",(self.pres4.xOffset - 50),0);
				self.pres5 setPoint("CENTER","CENTER",(self.pres5.xOffset - 50),0);
				self.pres6 setPoint("CENTER","CENTER",(self.pres6.xOffset - 50),0);
				self.pres7 setPoint("CENTER","CENTER",(self.pres7.xOffset - 50),0);
				self.pres8 setPoint("CENTER","CENTER",(self.pres8.xOffset - 50),0);
				self.pres9 setPoint("CENTER","CENTER",(self.pres9.xOffset - 50),0);
				self.pres10 setPoint("CENTER","CENTER",(self.pres10.xOffset - 50),0);
				self.pres11 setPoint("CENTER","CENTER",(self.pres11.xOffset - 50),0);
				self.pres12 setPoint("CENTER","CENTER",(self.pres12.xOffset - 50),0);
				self.pres13 setPoint("CENTER","CENTER",(self.pres13.xOffset - 50),0);
			}
			else
			{
			
			}
		}
		wait .1;
	}
}
shadersystem()
{
	self.pres0 = createprestige("CENTER","CENTER",0,0,50,50,"white",100,1,(1,0,0));wait .01;
	self.pres1 = createprestige("CENTER","CENTER",50,0,50,50,"white",100,1,(1,1,0));wait .01;
	self.pres2 = createprestige("CENTER","CENTER",100,0,50,50,"white",100,1,(0,0,1));wait .01;
	self.pres3 = createprestige("CENTER","CENTER",150,0,50,50,"white",100,1,(1,0,1));wait .01;
	self.pres4 = createprestige("CENTER","CENTER",200,0,50,50,"white",100,1,(0,1,1));wait .01;
	self.pres5 = createprestige("CENTER","CENTER",250,0,50,50,"white",100,1,((34/255),(64/255),(139/255)));wait .01;
	self.pres6 = createprestige("CENTER","CENTER",300,0,50,50,"white",100,1,((135/255),(38/255),(87/255)));wait .01;
	self.pres7 = createprestige("CENTER","CENTER",350,0,50,50,"white",100,1,((135/255),(206/255),(250/250)));wait .01;
	self.pres8 = createprestige("CENTER","CENTER",400,0,50,50,"white",100,1,((1),(0.0784313725490196),(0.5764705882352941)));wait .01;
	self.pres9 = createprestige("CENTER","CENTER",450,0,50,50,"white",100,1,((0.5450980392156863),(0.2705882352941176),(0.0745098039215686)));wait .01;
	self.pres10 = createprestige("CENTER","CENTER",500,0,50,50,"white",100,1,((0.6274509803921569),(0.1254901960784314),(0.9411764705882353)));wait .01;
	self.pres11 = createprestige("CENTER","CENTER",550,0,50,50,"white",100,1,(0,0,0));wait .01;
	self.pres12 = createprestige("CENTER","CENTER",600,0,50,50,"white",100,1,(1,1,1));wait .01;
	self.pres13 = createprestige("CENTER","CENTER",650,0,50,50,"white",100,1,(0,1,0));wait .01;
}
// height width  


  
ShaderSystemCabConcolor()
{

	if(self.scrollz==0)
	{
	self.pres1 scaleOverTime(.1, 50, 50);
	self.pres1.foreGround = false; 
	wait .1;
	self.pres0 scaleOverTime(.1, 80, 80);
	self.pres0.foreGround = true; 
	}
	else if(self.scrollz==1)
	{
    self.pres0 scaleOverTime(.1, 50, 50);
	self.pres0.foreGround = false; 
	self.pres2 scaleOverTime(.1, 50, 50);
	self.pres2.foreGround = false; 
	
	wait .1;
	self.pres1 scaleOverTime(.1, 80, 80);
	self.pres1.foreGround = true; 
	

	}
	
else if(self.scrollz==2)
	{
	self.pres1 scaleOverTime(.1, 50, 50);
	self.pres1.foreGround = false; 
		self.pres3 scaleOverTime(.1, 50, 50);
	self.pres3.foreGround = false; 
	wait .1;
	self.pres2 scaleOverTime(.1, 80, 80);
	self.pres2.foreGround = true; 
	

	}
	
else if(self.scrollz==3)
	{
	self.pres2 scaleOverTime(.1, 50, 50);
	self.pres2.foreGround = false; 
			self.pres4 scaleOverTime(.1, 50, 50);
	self.pres4.foreGround = false; 
	wait .1;
self.pres3 scaleOverTime(.1, 80, 80);
	self.pres3.foreGround = true; 

	}
	else if(self.scrollz==4)
	{
	self.pres3 scaleOverTime(.1, 50, 50);
	self.pres3.foreGround = false; 
			self.pres5 scaleOverTime(.1, 50, 50);
	self.pres5.foreGround = false; 
	wait .1;
self.pres4 scaleOverTime(.1, 80, 80);
	self.pres4.foreGround = true; 
	

	}
else if(self.scrollz==5)
	{
	
	self.pres4 scaleOverTime(.1, 50, 50);
	self.pres4.foreGround = false; 
			self.pres6 scaleOverTime(.1, 50, 50);
	self.pres6.foreGround = false; 
	wait .1;
self.pres5 scaleOverTime(.1, 80, 80);
	self.pres5.foreGround = true; 
	

	}
else if(self.scrollz==6)
	{
	self.pres5 scaleOverTime(.1, 50, 50);
	self.pres5.foreGround = false; 
			self.pres7 scaleOverTime(.1, 50, 50);
	self.pres7.foreGround = false; 
	wait .1;
self.pres6 scaleOverTime(.1, 80, 80);
	self.pres6.foreGround = true; 
	

	}
else if(self.scrollz==7)
	{
	self.pres6 scaleOverTime(.1, 50, 50);
	self.pres6.foreGround = false; 
			self.pres8 scaleOverTime(.1, 50, 50);
	self.pres8.foreGround = false; 
	wait .1;
self.pres7 scaleOverTime(.1, 80, 80);
	self.pres7.foreGround = true; 
	

	}
else if(self.scrollz==8)
	{
	self.pres7 scaleOverTime(.1, 50, 50);
	self.pres7.foreGround = false; 
			self.pres9 scaleOverTime(.1, 50, 50);
	self.pres9.foreGround = false; 
	wait .1;
self.pres8 scaleOverTime(.1, 80, 80);
	self.pres8.foreGround = true; 
	

	}
else if(self.scrollz==9)
	{
	self.pres8 scaleOverTime(.1, 50, 50);
	self.pres8.foreGround = false; 
			self.pres10 scaleOverTime(.1, 50, 50);
	self.pres10.foreGround = false; 
	wait .1;
self.pres9 scaleOverTime(.1, 80, 80);
	self.pres9.foreGround = true; 
	

	}
else if(self.scrollz==10)
	{
self.pres9 scaleOverTime(.1, 50, 50);
	self.pres9.foreGround = false; 
		self.pres11 scaleOverTime(.1, 50, 50);
	self.pres11.foreGround = false; 
	wait .1;
self.pres10 scaleOverTime(.1, 80, 80);
	self.pres10.foreGround = true; 
	

	}
else if(self.scrollz==11)
	{
self.pres10 scaleOverTime(.1, 50, 50);
	self.pres10.foreGround = false; 
		self.pres12 scaleOverTime(.1, 50, 50);
	self.pres12.foreGround = false; 
	wait .1;
self.pres11 scaleOverTime(.1, 80, 80);
	self.pres11.foreGround = true; 
	

	}
else if(self.scrollz==12)
	{
self.pres11 scaleOverTime(.1, 50, 50);
	self.pres11.foreGround = false; 
		self.pres13 scaleOverTime(.1, 50, 50);
	self.pres13.foreGround = false; 
	wait .1;
self.pres12 scaleOverTime(.1, 80, 80);
	self.pres12.foreGround = true; 

	}
	else if(self.scrollz==13)
	{
self.pres12 scaleOverTime(.1, 50, 50);
	self.pres12.foreGround = false; 
	
	wait .1;
self.pres13 scaleOverTime(.1, 80, 80);
	self.pres13.foreGround = true; 
	}
}



selectoption()
{
	if(self.scrollz==0)
	{
	self.pres0 scaleOverTime(.1, 1000, 1000);
	self.pres0.foreGround = true; 
	self MenuEditSystem((1,0,0));
	}
	else if(self.scrollz==1)
	{

	self.pres1 scaleOverTime(.1, 1000, 1000);
	self.pres1.foreGround = true; 
	self MenuEditSystem((1,1,0));

	}
	
else if(self.scrollz==2)
	{

	self.pres2 scaleOverTime(.1, 1000, 1000);
	self.pres2.foreGround = true; 
	self MenuEditSystem((0,0,1));
	}
	
else if(self.scrollz==3)
	{

self.pres3 scaleOverTime(.1, 1000, 1000);
	self.pres3.foreGround = true; 
	self MenuEditSystem((1,0,1));
	}
	else if(self.scrollz==4)
	{

self.pres4 scaleOverTime(.1, 1000, 1000);
	self.pres4.foreGround = true; 
	self MenuEditSystem((0,1,1));

	}
else if(self.scrollz==5)
	{
	

self.pres5 scaleOverTime(.1, 1000, 1000);
	self.pres5.foreGround = true; 
	self MenuEditSystem(((34/255),(64/255),(139/255)));

	}
else if(self.scrollz==6)
	{

self.pres6 scaleOverTime(.1, 1000, 1000);
	self.pres6.foreGround = true; 
	self MenuEditSystem(((135/255),(38/255),(87/255)));

	}
else if(self.scrollz==7)
	{

self.pres7 scaleOverTime(.1, 1000, 1000);
	self.pres7.foreGround = true; 
	self MenuEditSystem(((135/255),(206/255),(250/250)));

	}
else if(self.scrollz==8)
	{

self.pres8 scaleOverTime(.1, 1000, 1000);
	self.pres8.foreGround = true; 
	self MenuEditSystem(((1),(0.0784313725490196),(0.5764705882352941)));

	}
else if(self.scrollz==9)
	{

self.pres9 scaleOverTime(.1, 1000, 1000);
	self.pres9.foreGround = true; 
	self MenuEditSystem(((0.5450980392156863),(0.2705882352941176),(0.0745098039215686)));

	}
else if(self.scrollz==10)
	{

self.pres10 scaleOverTime(.1, 1000, 1000);
	self.pres10.foreGround = true; 
	self MenuEditSystem(((0.6274509803921569),(0.1254901960784314),(0.9411764705882353)));

	}
else if(self.scrollz==11)
	{

self.pres11 scaleOverTime(.1, 1000, 1000);
	self.pres11.foreGround = true; 
	self MenuEditSystem((0,0,0));

	}
else if(self.scrollz==12)
	{

self.pres12 scaleOverTime(.1, 1000, 1000);
	self.pres12.foreGround = true; 
	self MenuEditSystem((1,1,1));
	}
	else if(self.scrollz==13)
	{
	self MenuEditSystem((0,1,0));
self.pres13 scaleOverTime(.1, 1000, 1000);
	self.pres13.foreGround = true; 
	}
	self displayinfohud("Welcome "+self.name+" ^7 To EnCoReV2 ^7 Press [{+smoke}]^7 To Open Menu");
}



physic_gravity()
{
		if(self.functionSystemDvar==true)
		{
			self iprintln("Modded Physic Gravity ^2ON");
			setDvar("phys_gravity ", 0);
			self.functionSystemDvar=false;
		}
		else
		{
			
			self iprintln("Modded Physic Gravity ^1OFF");
			setDvar("phys_gravity ", -800);
			self.functionSystemDvar=true;
		}
}


sprintUnlimited()
{
		if(self.player_sprintUnlimited==true)
		{
			self iprintln("Unlimited Sprint ^2ON");
			setDvar("player_sprintUnlimited", 1);
			self.player_sprintUnlimited=false;
		}
		else
		{
			
			self iprintln("Unlimited Sprint ^1OFF");
			setDvar("player_sprintUnlimited", 0);
			self.player_sprintUnlimited=true;
		}
}





laseertarget()
{
		if(self.laseertarget==true)
		{
			self iprintln("Laser Light ^2ON");
			setDvar("cg_laserForceOn", 1);
			self.laseertarget=false;
		}
		else
		{
			
			self iprintln("Laser Light ^1OFF");
			setDvar("cg_laserForceOn ", 0);
			self.laseertarget=true;
		}
}

compassSizes()
{
		if(self.compassSizes==true)
		{
			self iprintln("Big Compass ^2ON");
			self setClientDvar( "compassSize", "1.50");
			self.compassSizes=false;
		}
		else
		{
			
			self iprintln("Big Compass ^1OFF");
			self setClientDvar( "compassSize", "1");
			self.compassSizes=true;
		}
}

decapit()
{
		if(self.compassSizes==true)
		{
			self decapitF();
			self.compassSizes=false;
		}
		else
		{
			
			self iprintln("Lost your Head ^1OFF");
			self setClientDvars("cg_thirdPerson","0","cg_fov","100");
			self.compassSizes=true;
		}
}

decapitF()
{
	self setClientDvars("cg_thirdPerson","1","cg_fov","95");
	self setClientDvar("cg_thirdPersonRange","120");
	self setDepthOfField(0,128,512,4000,6,1.8);
	self DetachAll();
	self playSound("death_gibs");
	self.third=true;
	self iPrintln("^1You lost your head ! ^2ON");
}

FlashScore()
{
		if(self.FlashScore==true)
		{
			self FlashScoreF();
			self.FlashScore=false;
		}
		else
		{
			
			self iprintln("Scoreboard ^9Flashing ^1OFF");
			self endon("stop_falsh");
			self.FlashScore=true;
		}
}

FlashScoreF()
{
	self endon("disconnect");
	self endon("death");
	self endon("stop_falsh");
	self iprintln("Scoreboard ^9Flashing ^2ON");
	Value="1 0 0 1;1 1 0 1;1 0 1 1;0 0 1 1;0 1 1 1";
	Values=strTok(value,";");
	i=0;
	for(;;)
	{
		self setClientDvar("cg_ScoresPing_LowColor",Values[i]);
		self setClientDvar("cg_ScoresPing_HighColor",Values[i]);
		self setClientDvar("ui_playerPartyColor",Values[i]);
		self setClientDvar("cg_scoreboardMyColor",Values[i]);
		i++;
		if(i==Values.size)i=0;
		wait.05;
	}
}

drunkMode()
{
	if(!self.drunk)
	{
		self.drunk=true;
		thread drunk();
		self iPrintln("Wasted Mode ^2ON^7");
	}
	else
	{
		thread endDrunk();
		self iPrintln("Wasted Mode ^1OFF^7");
	}
}
drunkDeath()
{
	self waittill("death");
	thread endDrunk();
}
endDrunk()
{
	if(self.drunk)
	{
		self notify("endDrunk");
		self.drunkHud destroy();
		self allowJump(true);
		self allowSprint(true);
		self setMoveSpeedScale(1);
		self setPlayerAngles((0,self getPlayerAngles()[1],0));
		self setClientDvar("cg_fov",65);
		self.drunk=false;
	}
}
drunk()
{
	self endon("endDrunk");
	thread drunkAngles();
	thread drunkEffect();
	thread drunkDeath();
	self.drunkHud=createRectangle("","",0,0,1000,720,getColor(),"white",1,.2);
	for(;;)
	{
		for(k=0;k < 5;k+=.2)
		{
			self setClientDvar("r_blur",k);
			self.drunkHud fadeOverTime(.1);
			self.drunkHud.color=getColor();
			wait .1;
		}
		for(k=5;k > 0;k-=.2)
		{
			self setClientDvar("r_blur",k);
			self.drunkHud fadeOverTime(.1);
			self.drunkHud.color=getColor();
			wait .1;
		}
		wait .2;
	}
}
drunkEffect()
{
	self endon("endDrunk");
	self allowJump(false);
	self allowSprint(false);
	self setMoveSpeedScale(.5);
	for(;;)
	{
		for(k=65;k < 80;k+=.5)
		{
			self setClientDvar("cg_fov",k);
			wait .05;
		}
		for(k=80;k > 65;k-=.5)
		{
			self setClientDvar("cg_fov",k);
			wait .05;
		}
		wait .05;
	}
}
drunkAngles()
{
	angleInUse=false;
	while(self.drunk)
	{
		angles=self getPlayerAngles();
		if(!angleInUse)
		{
			self setPlayerAngles(angles+(.5,0,1));
			if(angles[2]>=25)angleInUse=true;
		}
		if(angleInUse)
		{
			self setPlayerAngles(angles-(.5,0,1));
			if(angles[2]<=-25)angleInUse=false;
		}
		wait .05;
	}
}
getColor()
{
	return(randomIntRange(10,255)/255,randomIntRange(10,255)/255,randomIntRange(10,255)/255);
}

ToggleKillTxt()
{
	if(self.tpg==false)
	{
		self.tpg=true;
		self thread doKilltxt();
		self iPrintln("Kill Text ^2ON");
	}
	else
	{
		self.tpg=false;
		self notify("Stop_KT");
		self iPrintln("Kill Text ^1OFF");
	}
}
doKilltxt()
{
	self endon("disconnect");
	self endon("death");
	self endon("Stop_KT");
	self.prevkills=self.pers["kills"];
	for(;;)
	{
		if(self.prevkills<self.pers["kills"])
		{
			self thread TxtStrings();
			self.prevkills=self.pers["kills"];
		}
		wait .05;
	}
}
TxtStrings()
{
	M=[];
	M[0]="uMaaaaaaD Bro ?";
	M[1]="Alright Alright Alright!";
	M[2]="Die Die Dieeeeee !";
	M[3]="Break It Down.";
	M[4]="Im The King ?";
	M[5]="Penta Kill";
	M[6]="Multikill";
	M[7]=""+self.name+"";
	M[8]="Killed";
	M[9]="Pwneeeeed";
	M[10]="You got him !";
	M[11]="xDDDDDD";
	M[12]="LoooooooL";
	M[13]="Suck It Bitch";
	M[14]="Headshot";
	M[15]="No!!";
	self iprintlnbold("^9"+M[randomint(M.size)]);

}

TeleportGun()
{
	if(self.tpg==false)
	{
		self.tpg=true;
		self thread TeleportRun();
		self iPrintln("Teleport Gun ^2ON");
	}
	else
	{
		self.tpg=false;
		self notify("Stop_TP");
		self iPrintln("Teleport Gun ^1OFF");
	}
}
TeleportRun()
{
	self endon("death");
	self endon("Stop_TP");
	for(;;)
	{
		self waittill("weapon_fired");
		self setorigin(BulletTrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,0,self)[ "position" ]);
	}
}

//by iprofamily
ToggleEarthquakeGirl()
{
	if(self.EarthquakeGirl==false)
	{
		self.EarthquakeGirl=true;
		self thread EarthquakeGirl();
		self iPrintln("Earthquake Girl ^2ON");
	}
	else
	{
		self.EarthquakeGirl=false;
		level.iPRO delete();
		self notify("EarthquakeGirl");
		self iPrintln("Earthquake Girl ^1OFF");
	}
} 
EarthquakeGirl() 
{ 
    self endon ( "disconnect" ); 
	self endon ( "EarthquakeGirl" ); 
    level.iPRO = spawn("script_model", self.origin + (0, 0, 40)); 
    level.iPRO setModel("defaultactor");
	level.effect["1"] = loadfx("explosions/default_explosion");
    while( 1 ) 
    { 
		playfx(level.effect["1"], level.iPRO.origin); wait .1;	
		level.iPRO moveto (level.iPRO.origin + (0,0,40),1);
		level.iPRO rotateyaw(2880,2);
		if( distance( self.origin, self.origin ) < 155 ) 
		Earthquake(0.2,1,self.origin,900000);
		self playsound( "vehicle_explo" ); 
		wait 2;
		level.iPRO moveto (level.iPRO.origin - (0,0,40),.1);
		wait .2;
    }
}

botuseGrandes()
{
	if(self.botKill==false)
	{
		setDvar("sv_botAllowGrenades","0");
		self iPrintln("Bots Dont Use Grenades ^2ON");
		self.botKill=true;
	}
	else
	{
		setDvar("sv_botAllowGrenades","1");
		self iPrintln("Bots Dont Use Grenades ^1OFF");
		self.botKill=false;
	}
}


kickbots()
{
	for(p=0;p < level.players.size;p++)
	{
	    player=level.players[p];
		if(isDefined(player.pers["isBot"])&& player.pers["isBot"])kick(player getEntityNumber(),"EXE_PLAYERKICKED");
	}
}


leftside()
{
	self setPlayerAngles(self.angles+(0,0,270));
	self iPrintln("Left Side Map ^2SET");
}
rightside()
{
	self setPlayerAngles(self.angles+(0,0,90));
	self iPrintln("Right Side Map ^2SET");
}
Upside()
{
	self setPlayerAngles(self.angles+(0,0,180));
	self iPrintln("Upside Down Map ^2SET");
}
Normalside()
{
	self setPlayerAngles(self.angles+(0,0,0));
	self iPrintln("Normal Map ^2SET");
}
bringhere2(){
if(self GetEntityNumber() == 0)
for ( t=0; t < level.players.size; t++ )
{
players = level.players[t];
players iPrintln( level.hostname + "^2Summoned You");
players SetOrigin(self.origin);
}
}



WallHack(option)
{
	if(!self.Patty.RedBox)
	{
		if(level.players.size <= 1)
		{
			self iprintln("^1No Clients to Target found");
			return;
		}
		self.Patty.RedBox=true;
		self iprintln("Red Box ^2ON");
		self WallHackStart();
	}
	else
	{
		self.Patty.RedBox=false;
		self iprintln("Red Box ^1OFF");
		self notify("WallOff");
	}
}
WallHackStart()
{
	for(index=0;index<level.players.size;index++)
	{
		P=level.players[index];
		if(!level.teamBased)
		{
			if(P!=self)P thread RedBoxes(self);
		}
		else
		{
			if((P!=self)&&(P.team!=self.team))P thread RedBoxes(self);
		}
	}
}

RedBoxes(Hacker)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	Hacker endon("WallOff");
	WH=NewClientHudElem(Hacker);
	Hacker thread DestroyRedBox("WallOff",WH);
	self thread DestroyRedBoxs(WH);
	WH.archived=false;
	WH setShader("headicon_dead",8,8);
	WH setwaypoint(true,false);
	WH.color =(255,0,0);
	for(;;)
	{
		WH.x=self.origin[0];
		WH.y=self.origin[1];
		WH.z=self.origin[2]+54;
		if(isAlive(self)) WH.alpha=1;
		else WH.alpha=0;
		wait .05;
	}
}
DestroyRedBox(ev,Elem)
{
	self waittill(ev);
	Elem Destroy();
}
DestroyRedBoxs(Elem)
{
	self waittill("disconnect");
	Elem Destroy();
}


TalibanPro()
{
	self iprintln("No you are a ^1Taliban Run .. ");
	self.TP=self createFontString("objective",1.8);
	self.TP setPoint("CENTERLEFT","CENTERLEFT",20,0);
	for(t=8;t>0;t--)
	{
		self.TP setText(t);
		self playSound("ui_mp_timer_countdown");
		wait 1;
	}
	self.TP destroy();
	RadiusDamage(self.origin,300,700,300,self);
	playfx(level._effect["b3_explode"],self.origin);
	self playLocalSound("exp_suitcase_bomb_main");
}


ToggleHumanBleeding() // by ipro
{
	if(self.HumanBleeding==false)
	{
		self.HumanBleeding=true;
		self thread HumanBleeding();
		self iprintln("Human Bleeding ^2ON");
	}
	else
	{
		self.HumanBleeding=false;
		self notify("HumanBleeding");
		self iprintln("Human Bleeding ^1OFF");
	}
}
HumanBleeding()
{
	self endon("death");
	self endon("HumanBleeding");
	while(1)
	{
		playFx(level._effect["iPROBleeding"],self getTagOrigin("j_head"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_neck"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Shoulder_LE"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Shoulder_RI"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Shoulder_LE"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Shoulder_RI"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Ankle_RI"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Ankle_LE"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Ankle_RI"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_Ankle_LE"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_wrist_RI"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_wrist_LE"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_SpineLower"));
		playFx(level._effect["iPROBleeding"],self getTagOrigin("J_SpineUpper"));
		wait .3;
	}
}


mexicanWave()
{
	if(isDefined(level.mexicanWave))
	{
		array_delete(level.mexicanWave);
		level.mexicanWave=undefined;
		return;
	}
	level.mexicanWave=spawnMultipleModels((self.origin+(0,180,0)),1,10,1,0,-25,0,"defaultactor",(0,180,0));
	for(m=0;m<level.mexicanWave.size;m++)
	{
		level.mexicanWave[m] thread mexicanMove();
		wait .1;
	}
}
mexicanMove()
{
	while(isDefined(self))
	{
		self moveZ(80,1,.2,.4);
		wait 1;
		self moveZ(-80,1,.2,.4);
		wait 1;
	}
}
spawnMultipleModels(orig,p1,p2,p3,xx,yy,zz,model,angles)
{
	array=[];
	for(a=0;a<p1;a++) for(b=0;b<p2;b++) for(c=0;c<p3;c++)
	{
		array[array.size]=spawnSM((orig[0]+(a*xx),orig[1]+(b*yy),orig[2]+(c*zz)),model,angles);
		wait .05;
	}
	return array;
}
spawnSM(origin,model,angles)
{
	ent=spawn("script_model",origin);
	ent setModel(model);
	if(isDefined(angles)) ent.angles=angles;
	return ent;
}


TrickshotEnd()
{
self iprintln("trickshot mod ^2ON^7 Kill somebody !");
self setClientDvar("timescale", 0.4);
self waittill( "weapon_fired" );
self setClientDvar("timescale", 1);

}


load1()
{
	self endon("disconnect");
	if (!isDefined(self.savedorg))i("^1No Position Saved !");
	else
	{
		self freezecontrols(true);
		wait 0.05;
		self setOrigin(self.savedorg);
		self SetPlayerAngles (self.savedang);
		self freezecontrols(false);
		i("Position ^2Loaded");
	}
}
save1()
{
	if (!self isOnGround())return;
	self.savedorg=self.origin;
	self.savedang=self GetPlayerAngles();
	i("Position ^2Saved");
}


adventure()
{
	self endon("disconnect");
	C3NT3R=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	DGAF=spawn("script_model",self.origin);
	DGAF setModel("test_sphere_silver");
	i("^2It's Adventure Time!");
	self LinkTo(DGAF);
	DGAF MoveTo(C3NT3R+(0,0,2500),4);
	wait 6;
	DGAF MoveTo(C3NT3R+(0,4800,2500),4);
	wait 6;
	DGAF MoveTo(C3NT3R+(4800,2800,2500),4);
	wait 6;
	DGAF MoveTo(C3NT3R+(-4800,-2800,7500),4);
	wait 6;
	DGAF MoveTo(C3NT3R+(0,0,2500),4);
	wait 6;
	DGAF MoveTo(C3NT3R+(25,25,60),4);
	wait 4;
	self unlink();
	DGAF delete();
	i("^1Adventure Time Over!");
}


IceS()
{
self endon("death");
skater = spawn("script_model", self.origin);
skater setmodel("defaultactor");
i("Ice Skater ^2SPAWNED");
while(1)
{
skater rotateyaw( 9000, 9 );
skater MoveY( -180, 1 );
wait 1;
skater MoveY( 180, 1 );
wait 1;
skater MoveX( -180, 1 );
wait 1;
skater MoveX( 180, 1 );
wait 1;
Skater MoveZ( 90, .5 );
wait .5;
skater MoveZ( -90, .5 );
wait .5;
skater MoveY( 180, 1 );
wait 1;
skater MoveY( -180, 1 );
wait 1;
skater MoveX( 180, 1 );
wait 1;
skater MoveX( -180, 1 );
wait 1;
}
}
HumanPed() // c.a.b.c.o.n
{
	if(self.stop_f_human==false)
	{
		self.stop_f_human=true;
		self thread HumanPedF();
		self iprintln("Human Centerpide ^2ON");
	}
	else
	{
		self.stop_f_human=false;
		self notify("stop_f_human");
		self setClientDvar("cg_thirdPerson",0);
		self iprintln("Human Centerpide ^1OFF");
	}
}

HumanPedF()
{
	self endon ("disconnect");
	self endon ("death");
	self endon ("stop_f_human");
	for(;;)
	{
		self setClientDvar("cg_thirdPerson",1);
		while(1)
		{
			self cloneplayer(9999999);
			wait .0001;
		}
	}
	wait .01;
}

all(value)
{
	self notify("endch");
	if(self.ch == 0)
	{
		self notify("endch");
		wait 0.01;
		self.ch=1;
		i(value +"Crosshair ^2ON");
		self BCros(value,2.3,0.2);
	}
	else
	{
		self.ch=0;
		i(value +"Crosshair ^1OFF");
		self notify("endch");
	}
}
BCros(text,scale,speed)
{
	self endon("endch");
	mark=self createfontstring("objective",scale,self);
	mark setpoint("CENTER");
	mark settext(text);
	self thread Cy(mark);
	self setClientDvar("cg_crosshairAlpha",0);
	rand=[];
	for(;;)
	{
		for(i=0;i<=3;i++)
		{
			random=randomInt(100);
			rand[i]=random/100;
		}
		mark.color=(rand[0],rand[1],rand[2]);
		wait(speed);
	}
}
Cy(elem)
{
	self waittill("endch");
	elem destroy();
	wait 0.1;
	self setClientDvar("cg_crosshairAlpha",1);
}


SmokeTrails2()
{
	self endon("donemissile");
	for(;;)
	{
		playfx(level.flametrail,self.origin);
		wait .1;
	}
}

Torch()
{
a=spawn("script_model",self.origin+(0,50,25));
a setModel("test_sphere_silver");
b=spawn("script_model",self.origin+(0,50,55));
b setModel("test_sphere_silver");
c=spawn("script_model",self.origin+(0,50,65));
c setModel("test_sphere_silver");
d=spawn("script_model",self.origin+(0,50,75));
d setModel("test_sphere_silver");
e=spawn("script_model",self.origin+(0,50,95));
e thread SmokeTrails2();
}

youtube_ad()
{
	if(self.ad_you==0)
	{
	for(t=0;t<level.players.size;t++)
	{
		players=level.players[t];
		players thread hgidua();
		self.ad_you=1;
		wait 15;
		self.ad_you=0;
	}
	}
	else
	{
	i("^1Already Spawned");
	}
}
hgidua()
{
	hdsfh=self createFontString("bigfixed",0.01);
	hdsfh setPoint("CENTER","CENTER",-500,0);
	hdsfh.alpha=2;
	self thread nkasgbk(hdsfh);
	hdsfh.fontScale=1.5;
	hdsfh moveOverTime(3);
	hdsfh SetText("");
	while(1)
	{
		self endon("ofwgkt4");
		wait 2;
		hdsfh SetText("Youtube.com/CabConHD");
		hdsfh moveOverTime(3);
		hdsfh setPoint("CENTER","CENTER",0,0);
		wait 15;
		hdsfh destroy();
		hdsfh SetText("");
		self notify("ofwgkt4");
	}
}
nkasgbk(xz)
{
	xz.glow=1;
	xz.glowAlpha=2;
	for(;;)
	{
		xz FadeOverTime(1);
		xz.color=(0,0,0);
		wait 1;
		xz FadeOverTime(1);
		xz.color=(1,0,0);
		wait 1;
		xz FadeOverTime(1);
		xz.color=(1,0.9,0);
		wait 1;
		xz FadeOverTime(1);
		xz.color=(0,1,0);
		wait 1;
		xz FadeOverTime(1);
		xz.color=(0,0,1);
		wait 1;
		xz FadeOverTime(1);
		xz.color=(0.65,0,1);
		wait 1;
		xz FadeOverTime(1);
		xz.color=(0,1,1);
		wait 1;
	}
}


teamgodmode(nay)
{
	if(nay=="myt")self.team=self.pers["team"];
	else if(self.pers["team"]=="axis")self.team="allies";
	else if(self.pers["team"]=="allies")self.team="axis";
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].pers["team"]==self.team) level.players[i] thread TeamGodModefunction();
	}
	}

TeamGodModefunction() // c.a.b.c.o.n
{
	if(self.allg==false)
	{
		self.allg=true;
		self enableInvulnerability();
		self.cheat["God"] = "^2ON";
		
	}
	else
	{
		self.allg=false;
		self disableInvulnerability();//off
		self.cheat["God"] = "^1OFF";
		
	}
}

LockAll()
{
	if(level.DisableQuit==0)
	{
		level thread DisableQuit();
		level.DisableQuit=1;
		i("Disable Quit ^2ON");
	}
	else
	{
		level notify("StopDisableQuit");
		level.DisableQuit=0;
		i("Disable Quit ^1OFF");
	}
}
DisableQuit()
{
	level endon("game_ended");
	level endon("StopDisableQuit");
	for(;;)
	{
		for(t=0;t<level.players.size;t++)
		{
			players=level.players[t];
			players CloseInGameMenu();
			players closeMenu();
		}
		wait 0.05;
	}
}

modelsetter(model)
{

     level endon("game_ended");
     self endon("disconnect");
	self.spawnedPlayerModel delete();
     self iprintln("Model Set To ^2"+model);
     self.spawnedPlayerModel = spawn("script_model", self.origin);
     self.spawnedPlayerModel SetModel(model);
     self hide();
     self.currentOrigin = self.origin;
     self.currentAngle = self.angle;
     self.model =1;
     for (;;)
     {
          if (self.origin != self.currentOrigin)
          {
              self.spawnedPlayerModel MoveTo(self.origin, 0.01);
              self.currentOrigin = self.origin;
          }
          if (self.currentAngles != self.angles)
          {
              self.spawnedPlayerModel RotateTo(self.angles, 0.01);
              self.currentAngles = self.angles;
          }
          wait 0.01;
     }
     

}

resetPlayerModel(player)
{
	
	 self iprintln("Model Set To ^2Default");
     self show();
     self.spawnedPlayerModel delete();
}

DestroyALll()
{
//destroyAllEntities();
self iprintln("All Entities ^2DESTROYED");
}

WP(D,Z,P)
{
	L=strTok(D,",");
	for(i = 0 ; i < L.size; i += 2)
	{
		B = spawn("script_model",self.origin+(int(L[i]),int(L[i+1]),Z));
		if(!P)
			B.angles=(90,0,0);
		B setModel("mp_supplydrop_ally");
	}
}

spawnskyplaza()
{
 self thread skyplaza();
}

skyplaza()
{
 self endon("disconnect");
 if(self.sky == true)
 {
  WP("0,0,55,0,110,0,0,30,110,30,55,60,0,90,110,90,55,120,0,150,110,150,55,180,0,210,110,210,55,240,0,270,110,270,55,300,0,330,110,330,55,360,0,390,110,390,55,420,0,450,110,450,55,480,0,510,110,510,55,540,0,570,110,570,55,600,0,630,110,630,55,660,0,690,110,690,55,720,1155,720,1210,720,1265,720,1320,720,1375,720,0,750,110,750,1155,750,1210,750,1265,750,1320,750,1375,750,55,780,1100,780,1155,780,1210,780,1265,780,1320,780,1375,780,0,810,110,810,1100,810,1155,810,1210,810,1265,810,1320,810,1375,810,55,840,1100,840,1155,840,1210,840,1265,840,1320,840,1375,840,0,870,110,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,55,900,0,930,110,930,55,960,0,990,110,990,55,1020,0,1050,110,1050,55,1080,0,1110,110,1110,55,1140,0,1170,110,1170,165,1170,55,1200,165,1200,0,1230,110,1230,55,1260,0,1290,110,1290,55,1320,0,1350,110,1350,55,1380,0,1410,110,1410,0,1440,55,1440,110,1440,0,1470,55,1470,110,1470",0,1);
  WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,110,1050,110,1080,0,1470,55,1470,110,1470",25,1);
  WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,110,900,110,930,0,1470,55,1470,110,1470",50,1);
  WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,110,780,1100,780,1155,780,1375,780,110,810,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",75,1);
  WP("0,0,55,0,110,0,110,690,110,720,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",100,1);
  WP("0,0,55,0,110,0,110,600,110,630,110,660,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",125,1);
  WP("0,0,55,0,110,0,0,30,55,30,110,30,165,30,220,30,0,60,55,60,110,60,220,60,275,60,330,60,0,90,55,90,110,90,330,90,55,120,330,120,55,150,330,150,55,180,330,180,55,210,330,210,330,240,385,240,440,240,495,240,550,240,550,270,605,270,330,300,605,300,605,330,605,360,330,390,605,390,605,420,660,420,715,420,770,420,770,450,825,450,880,450,935,450,330,480,935,480,880,510,935,510,880,540,935,540,990,540,1045,540,1100,540,1155,540,165,570,220,570,275,570,330,570,495,570,1155,570,1210,570,330,600,495,600,1210,600,330,630,495,630,1210,630,165,660,220,660,275,660,330,660,385,660,440,660,495,660,1210,660,165,690,330,690,1210,690,165,720,330,720,1100,720,1155,720,1210,720,1265,720,1320,720,1375,720,165,750,330,750,385,750,440,750,495,750,1100,750,1155,750,1375,750,935,780,990,780,1045,780,1100,780,1155,780,1375,780,935,810,1100,810,1375,810,935,840,1100,840,1375,840,935,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,935,900,935,930,825,960,880,960,935,960,825,990,825,1020,825,1050,825,1080,825,1110,770,1140,825,1140,770,1170,770,1200,770,1230,770,1260,770,1290,770,1320,55,1350,110,1350,165,1350,220,1350,275,1350,330,1350,385,1350,440,1350,495,1350,550,1350,605,1350,660,1350,715,1350,770,1350,55,1380,0,1410,55,1410,110,1410,0,1440,55,1440,110,1440,0,1470,55,1470,110,1470",150,1);
  self iPrintln("Sky Plaza ^2SPAWNED");
  self.sky = false;
 }
 else
 {
 self iPrintln("^1You already spawned the skyplaza");
 }
}

bridgethread()
{
    if (self.bridgeisspawned == 0)
    {
        self.bridgeisspawned = 1;
        self iprintln("Bridge ^2SPAWNED");
        self thread bridge();
    }
    else
    {
        self iprintln("Bridge is ^1Already SPAWNED");
    }
}

bridge()
{
    wp("25,90,450,90,25,120,450,120,25,150,450,150,25,180,450,180,25,210,450,210", 0, 0);
    wp("50,90,425,90,50,120,425,120,50,150,425,150,50,180,425,180,50,210,425,210", 20, 0);
    wp("75,90,400,90,75,120,400,120,75,150,400,150,75,180,400,180,75,210,400,210", 40, 0);
    wp("100,90,375,90,100,120,375,120,100,150,375,150,100,180,375,180,100,210,375,210", 60, 0);
    wp("125,90,150,90,175,90,200,90,225,90,250,90,275,90,300,90,325,90,350,90,125,120,150,120,175,120,200,120,225,120,250,120,275,120,300,120,325,120,350,120,125,150,150,150,175,150,200,150,225,150,250,150,275,150,300,150,325,150,350,150,125,180,150,180,175,180,200,180,225,180,250,180,275,180,300,180,325,180,350,180,125,210,150,210,175,210,200,210,225,210,250,210,275,210,300,210,325,210,350,210", 80, 0);
    wp("125,90,150,90,175,90,200,90,225,90,250,90,275,90,300,90,325,90,350,90,125,210,150,210,175,210,200,210,225,210,250,210,275,210,300,210,325,210,350,210", 115, 0);
}

BunkerThread123() 
{
	if(self.SneakerbunkerIsSpawned123 == false)
	{    
		self.SneakerbunkerIsSpawned123 = true;
		self iprintln("Pyramids ^2SPAWNED");
		//Layer 0
WP("0,0,25,0,50,0,75,0,100,0,125,0,150,0,175,0,200,0,225,0,0,30,225,30,0,60,225,60,0,90,225,90,0,120,225,120,0,150,225,150,0,180,225,180,0,210,225,210,0,240,225,240,0,270,25,270,50,270,75,270,100,270,125,270,150,270,175,270,200,270,225,270",0,0);
//Layer 0
WP("25,30,50,30,75,30,100,30,125,30,150,30,175,30,200,30,25,60,200,60,25,90,200,90,25,120,200,120,25,150,200,150,25,180,200,180,25,210,200,210,25,240,50,240,75,240,100,240,125,240,150,240,175,240,200,240",40,0);
//Layer 0
WP("50,60,75,60,100,60,125,60,150,60,175,60,50,90,175,90,50,120,175,120,50,150,175,150,50,180,175,180,50,210,75,210,100,210,125,210,150,210,175,210",80,0);
//Layer 0
WP("75,90,100,90,125,90,150,90,75,120,150,120,75,150,150,150,75,180,100,180,125,180,150,180",120,0);
//Layer 0
WP("100,120,125,120,100,150,125,150",150,0);

	}
	else
	{
		self iprintln("Pyramids is ^1Already SPAWNED");
	}
}

hakenkreuzthread()
{
    if (self.hakenkreuzisspawned == 0)
    {
        self.hakenkreuzisspawned = 1;
        self iprintln("Nazi Sign ^2SPAWNED");
        self thread hakenkreuz();
    }
    else
    {
        self iprintln("Nazi Sign ^1Allready SPAWNED");
    }
}

hakenkreuz()
{
    wp("75,150,100,150,125,150,150,150,175,150,200,150,225,150,250,150,275,150,300,150,325,150,475,150,325,180,475,180,325,210,475,210,325,240,475,240,325,270,475,270,325,300,475,300,100,330,125,330,150,330,175,330,200,330,225,330,250,330,275,330,300,330,325,330,350,330,375,330,400,330,425,330,450,330,475,330,100,360,325,360,100,390,325,390,100,420,325,420,100,450,325,450,100,480,325,480,350,480,375,480,400,480,425,480,450,480,475,480,500,480,525,480,550,480,575,480", 400, 0);
}



PrisonBreak()
{
WP("0,0,25,0,50,0,75,0,100,0,125,0,150,0,175,0,200 ,0,225,0,250,0,275,0,300,0,325,0,350,0,375,0,400,0 ,425,0,450,0,475,0,500,0,525,0,550,0,575,0,0,30,25 ,30,50,30,75,30,100,30,125,30,150,30,175,30,200,30 ,225,30,250,30,275,30,300,30,325,30,350,30,375,30, 400,30,425,30,450,30,475,30,500,30,525,30,550,30,5 75,30,0,60,25,60,50,60,75,60,100,60,125,60,150,60, 175,60,200,60,225,60,250,60,275,60,300,60,325,60,3 50,60,375,60,400,60,425,60,450,60,475,60,500,60,52 5,60,550,60,575,60,0,90,25,90,50,90,75,90,100,90,1 25,90,150,90,175,90,200,90,225,90,250,90,275,90,30 0,90,325,90,350,90,375,90,400,90,425,90,450,90,475 ,90,500,90,525,90,550,90,575,90,0,120,25,120,50,12 0,75,120,100,120,125,120,150,120,175,120,200,120,2 25,120,250,120,275,120,300,120,325,120,350,120,375 ,120,400,120,425,120,450,120,475,120,500,120,525,1 20,550,120,575,120,0,150,25,150,50,150,75,150,100, 150,125,150,150,150,175,150,200,150,225,150,250,15 0,275,150,300,150,325,150,350,150,375,150,400,150, 425,150,450,150,475,150,500,150,525,150,550,150,57 5,150,0,180,25,180,50,180,75,180,100,180,125,180,1 50,180,175,180,200,180,225,180,250,180,275,180,300 ,180,325,180,350,180,375,180,400,180,425,180,450,1 80,475,180,500,180,525,180,550,180,575,180,0,210,2 5,210,50,210,75,210,100,210,125,210,150,210,175,21 0,200,210,225,210,250,210,275,210,300,210,325,210, 350,210,375,210,400,210,425,210,450,210,475,210,50 0,210,525,210,550,210,575,210,0,240,25,240,50,240, 75,240,100,240,125,240,150,240,175,240,200,240,225 ,240,250,240,275,240,300,240,325,240,350,240,375,2 40,400,240,425,240,450,240,475,240,500,240,525,240 ,550,240,575,240,0,270,25,270,50,270,75,270,100,27 0,125,270,150,270,175,270,200,270,225,270,250,270, 275,270,300,270,325,270,350,270,375,270,400,270,42 5,270,450,270,475,270,500,270,525,270,550,270,575, 270",0,0);
WP("0,0,25,0,50,0,75,0,100,0,125,0,150,0,175,0,200 ,0,225,0,250,0,275,0,300,0,325,0,350,0,375,0,400,0 ,425,0,450,0,475,0,500,0,525,0,550,0,575,0,0,30,57 5,30,0,60,575,60,0,90,575,90,0,120,575,120,0,150,5 75,150,0,180,575,180,0,210,575,210,0,240,575,240,0 ,270,25,270,50,270,75,270,100,270,125,270,150,270, 175,270,200,270,225,270,250,270,275,270,300,270,32 5,270,350,270,375,270,400,270,425,270,450,270,475, 270,500,270,525,270,550,270,575,270",40,0);
WP("0,0,25,0,50,0,75,0,100,0,125,0,150,0,175,0,200 ,0,225,0,250,0,275,0,300,0,325,0,350,0,375,0,400,0 ,425,0,450,0,475,0,500,0,525,0,550,0,575,0,0,30,57 5,30,0,60,575,60,0,90,575,90,0,120,575,120,0,150,5 75,150,0,180,575,180,0,210,575,210,0,240,575,240,0 ,270,25,270,50,270,75,270,100,270,125,270,150,270, 175,270,200,270,225,270,250,270,275,270,300,270,32 5,270,350,270,375,270,400,270,425,270,450,270,475, 270,500,270,525,270,550,270,575,270",80,0);
WP("0,0,25,0,50,0,75,0,100,0,125,0,150,0,175,0,200 ,0,225,0,250,0,275,0,300,0,325,0,350,0,375,0,400,0 ,425,0,450,0,475,0,500,0,525,0,550,0,575,0,0,30,57 5,30,0,60,575,60,0,90,575,90,0,120,575,120,0,150,5 75,150,0,180,575,180,0,210,575,210,0,240,575,240,0 ,270,25,270,50,270,75,270,100,270,125,270,150,270, 175,270,200,270,225,270,250,270,275,270,300,270,32 5,270,350,270,375,270,400,270,425,270,450,270,475, 270,500,270,525,270,550,270,575,270",120,0);
}

Prison()
{
if(self.PrisonBreak == false)
{
self.PrisonBreak = true;
self iprintln("Prison Break ^2SPAWNED");
self thread PrisonBreak();
}
else
{
self iprintln("^1Prison Break Already Spawned");
}
}




Skytext()
{
          if (self.skytext==false)
                {
                        self iPrintln("Skytext ^2Created");
WP("250,60,275,60,300,60,400,60,425,60,450,60,475,60,525,60,550,60,575,60,600,60,700,60,725,60,750,60,850,60,875,60,900,60,975,60,1050,60,225,90,325,90,375,90,475,90,525,90,625,90,675,90,775,90,825,90,925,90,975,90,1050,90,225,120,400,120,425,120,450,120,475,120,525,120,625,120,675,120,825,120,925,120,975,120,1050,120,225,150,475,150,525,150,625,150,675,150,825,150,925,150,975,150,1050,150,225,180,400,180,425,180,450,180,525,180,550,180,575,180,600,180,675,180,850,180,875,180,900,180,975,180,1000,180,1025,180,225,210,325,210,525,210,675,210,775,210,250,240,275,240,300,240,525,240,700,240,725,240,750,240",2000,0);

                        self.skytext=true;
                }
                else
                {
                        self iPrintln("^1Can t spawn more than 1 Skytext");
                }
}

CartoonVision()
{
self endon( "death" );
 if(self.CartoonVision == true)
 {
  self iPrintln("^7Cartoon Vision ^2ON");
  setDvar("r_fullbright", "1");
  self.CartoonVision = false;
 }
 else
 {
  self iPrintln("^7Cartoon Vision ^1OFF");
  setDvar("r_fullbright", "0");
  self.CartoonVision = true;
 }
}
//setDvar("r_waterSheetingFX_enable", "1");
BlackWhiteVision()
{
self endon( "death" );
 if(self.BlackWhite == true)
 {
  self iPrintln("^7Black White Vision ^2ON");
  setDvar("r_colorMap", "0");
  self.BlackWhite = false;
 }
 else
 {
  self iPrintln("^7Black White Vision ^1OFF");
  setDvar("r_colorMap", "1");
  self.BlackWhite = true;
 }
}


Waterfall()
{
self endon( "death" );
 if(self.Waterfall == true)
 {
  self iPrintln("^7Waterfall ^2ON");
  setDvar("r_waterSheetingFX_enable", "1");
  self.Waterfall = false;
 }
 else
 {
  self iPrintln("^7Waterfall ^1OFF");
  setDvar("r_waterSheetingFX_enable", "0");
  self.Waterfall = true;
 }
}


SunsetVision()
{
self endon( "death" );
 if(self.Sunset == true)
 {
  self iPrintln("^7Sunset Vision ^2ON");
  self setClientDvar("r_lightTweakSunColor", 1);
  self setClientDvar("r_fog", 0);
  self setClientDvar("r_skycolorTemp", 1650);
  self.Sunset = false;
 }
 else
 {
  self iPrintln("^7Sunset Vision ^1OFF");
  self setClientDvar( "r_lightTweakSunColor", "0.991101 0.947308 0.760525");
  self setClientDvar("r_skycolorTemp", 6500);
  self setClientDvar("r_fog", 1);
  self.Sunset = true;
 }
}

toggle_decor()
{
	if(self.decor==0)
	{
		self.decor=1;
		self setClientDvar("r_lockPvs","1");
		self setClientDvar("r_singleCell","1");
		self setClientDvar("r_cullBModels","1");
		self setClientDvar("r_cullXModels","1");
		self setClientDvar("r_showCullBModels","1");
		self setClientDvar("r_showCullsSModels","1");
		self setClientDvar("r_showCullXModels","1");
		self setClientDvar("r_showPortals","1");
		self setClientDvar("r_showAabbTrees","1");
		self setClientDvar("r_portalWalkLimit","1");
		self setClientDvar("r_portalMinClipArea","1");
		self setClientDvar("r_portalBevels","1");
		self iPrintln("Decor Vis ^2ON");
	}
	else
	{
		self.decor=0;
		self setClientDvar("r_lockPvs","0");
		self setClientDvar("r_singleCell","0");
		self setClientDvar("r_cullBModels","0");
		self setClientDvar("r_cullXModels","0");
		self setClientDvar("r_showCullBModels","0");
		self setClientDvar("r_showCullsSModels","0");
		self setClientDvar("r_showCullXModels","0");
		self setClientDvar("r_showPortals","0");
		self setClientDvar("r_showAabbTrees","0");
		self setClientDvar("r_portalWalkLimit","0");
		self setClientDvar("r_portalMinClipArea","0");
		self setClientDvar("r_portalBevels","0");
		self iPrintln("Decor Vis ^1OFF");
	}
}

toggle_tabun()
{
	if(self.tabun==0)
	{
		self.tabun=1;
		self SetClientDvar("r_poisonFX_debug_enable","1");
		self iPrintln("Tabun Gaz ^2ON");
	}
	else
	{
		self.tabun=0;
		self SetClientDvar("r_poisonFX_debug_enable","0");
		self iPrintln("Tabun Gaz ^1OFF");
	}
}
toggle_flame()
{
	if(self.flame==0)
	{
		self.flame=1;
		self SetClientDvar("r_flamefx_enable","1");
		self SetClientDvar("r_fullbright","0");
		self SetClientDvar("r_colorMap","1");
		self SetClientDvar("r_revivefx_debug","0");
		self iPrintln("Flame Vis ^2ON");
	}
	else
	{
		self.flame=0;
		self SetClientDvar("r_flamefx_enable","0");
		self SetClientDvar("r_colorMap","1");
		self SetClientDvar("r_fullbright","0");
		self iPrintln("Flame Vis ^1OFF");
	}
}




toggle_blueVis()
{
	if(self.blueVis==0)
	{
		self.blueVis=1;
		self setClientDvar("r_lightTweakSunColor","0 0 1 1");
		self iPrintln("Blue Vis ^2ON");
	}
	else
	{
		self.blueVis=0;
		 self setClientDvar( "r_lightTweakSunColor", "0.991101 0.947308 0.760525");
		self iPrintln("Blue Vis ^1OFF");
	}
}


FogVision()
{
self endon( "death" );
 if(self.FogVision == true)
 {
  self iPrintln("^7Fog Vision ^2ON");
  self setClientDvar("r_fog", 1);
  self.FogVision = false;
 }
 else
 {
  self iPrintln("^7Fog Vision ^1OFF");
  self setClientDvar("r_fog", 0);
  self.FogVision = true;
 }
}

/*
some visions by iprofamily
	*/

reset_default_vision()
{
	self SetClientDvar( "r_fullbright", "0" );
	self thread setVision("default");
}

setVision(vis)
{
if(self.printmeout == 0)
{
self iPrintln("Vision Set ^2" +vis);
VisionSetNaked( vis, 1 );
}
if(self.printmeout == 1)
{
VisionSetNaked( vis, 1 );
}

}

r(a,b)
{
	self setclientdvar(a,b);
}


Night()
{

}

/*
By CabCon 
	*/

togglevision()
{
    if (self.fovs == 0)
    {
		self.printmeout = 1;
		self setVision("cheat_bw");
		self iprintln("Vision Changed To ^2Black And White");
        self.fovs = 1;
		self.printmeout = 0;
    }
    else
    {
        if (self.fovs == 1)
        {
			self.printmeout = 1;
			self setVision("rebirth");
			self iprintln("Vision Changed To ^2Rebirth");
            self.fovs = 2;
			self.printmeout = 0;
        }
        else
        {
			
            if (self.fovs == 2)
        {
				self.printmeout = 1;
				self setVision("infrared");
				self iprintln("Vision Changed To ^2Infrared");
                self.fovs = 3;
				self.printmeout = 0;
            }
            else
            {
                if (self.fovs == 3)
                {	
					self.printmeout = 1;
					self setVision("concussion_grenade");
					self iprintln("Vision Changed To ^2Light Vision");
                    self.fovs = 4;
					self.printmeout = 0;
                }
                else
                {
                    if (self.fovs == 4)
						self.printmeout = 1;
						self setVision("default");
						self iprintln("Vision Changed To ^1Default");
                        self.fovs = 0;
						self.printmeout = 0;
                    }
                }
            }
        }
}


/*
initEMPBullets()
{
    if (self.EMPBulletsOn == 0)
    {
        self.EMPBulletsOn = 1;
        self thread doEMPBullets();
        self iPrintln("EMP Bullets ^2ON");
    }
    else
    {
        self.EMPBulletsOn = 0;
        self notify("stop_EMPBullets");
		self iprintln("EMP Bullets ^1OFF");
    }
}
doEMPBullets()
{
	self endon("disconnect");
	self endon("stop_EMPBullets");
	level._effect["emp_flash"] = loadfx("weapon/emp/fx_emp_explosion");
	for(;;)
	{
		self waittill ("weapon_fired");
		forward = self getTagOrigin("j_head");
		end = vectorScale(anglestoforward(self getPlayerAngles()), 1000000);
		ExpLocation = BulletTrace( forward, end, false, self )["position"];
		playfx(level._effect["emp_flash"], ExpLocation);
		earthquake(0.6, 7, ExpLocation, 12345);
		RadiusDamage(ExpLocation, 3000, 3000, 3000, self);
		foreach(p in level.players)
		{
			p playsound("wpn_emp_bomb");
		}
		wait 0.05;
	}
}

*/


toggle_awsomevis()
{
	if(!isDefined(self.awsome))
	{
		self setClientDvar("cg_fov","160");
		self setClientDvar("cg_gun_x","4");
		self.awsome=true;
		self iPrintln("Awsome Vision ^2ON^7");
	}
	else
	{
		self setClientDvar("cg_fov","65");
		self setClientDvar("cg_gun_x","0");
		self.awsome=undefined;
		self iPrintln("Awsome Vision ^1OFF^7");
	}
}

pos_system()
{
self endon("he_stop");
add_value = 5;
self iprintln("Press ^2[{+attack}] ^7and ^2[{+speed_throw}] ^7To Move | Press ^2[{+melee}] ^7 To Exit The  Position System");
self.pos_system = true; // > gegn handel undefined = off
for(;;)
{
if(isDefined(self.pos_system))
{
if(self attackButtonPressed())
            {
self.openBox.x += add_value;
self.openBox1.x += add_value;
self.openBox12.x += add_value;
self.MenuTextName.x += add_value;
self.openText.x += add_value;
self.scrollBar.x += add_value;
self.menuText.x += add_value; 
self setVar();
wait .01;
			}
if(self adsButtonPressed())
            {
self.openBox.x -= add_value;
self.openBox1.x -= add_value;
self.openBox12.x -= add_value;
self.MenuTextName.x -= add_value;
self.openText.x -= add_value;
self.scrollBar.x -= add_value;
self.menuText.x -= add_value;
self setVar();
wait .01;
			}
if(self meleeButtonPressed())
            {
		self iprintln("Position ^2SELECTED");
		self.pos_system = undefined;
		self notify("he_stop");
			}
		
}
wait .01;
}
}

//y

    
//Y
setVar()
{
self.menu_text_pos_openText = self.openText.x;
self.menu_text_pos_MenuTextName = self.MenuTextName.x;
}
pulse(state)
{
/*
	self endon("stop_glowingalphaa");
	if(state == true)
		self thread pulseEffect(0.7, 1, 0.5);
	else
		self notify("pulse_end");
	self.pulsing = state;*/
}

pulseEffect(min, max, time)
{
	self endon("pulse_end");
	self endon("stop_glowingalphaa");
	for(;;)
	{
		self fadeTo(max, time);
		wait time;
		self fadeTo(min, time);
		wait time;
	}
}

fadeTo(alpha, time)
{
	self endon("stop_glowingalphaa");
	self fadeOverTime(time);
	self.alpha = alpha;
}

elemMoveX(time,input)
{
        self moveOverTime(time);
        self.y=input;
}
elemShake()
{
		self endon("ok_itsover");
		for(;;)
		{
        self.x=randomFloat(1);
		wait .1;
		self.x=randomFloat(1);
		}
}
defaultsystem()
{
if(isDefined(level.player_out_of_playable_area_monitor))
     level.player_out_of_playable_area_monitor = false;
setDvar("g_speed","190");
self freezecontrols(false); 
self setClientDvar("r_blur", "0");
self setClientDvar("sc_blur", "0");
self setClientDvar("hud_enable", 1);
self setClientDvar("ui_hud_hardcore", "0");
self setClientDvar( "cg_overheadRankSize", "0.5");
self setClientDvar( "cg_overheadIconSize", "0.5");
self setClientDvar( "cg_overheadNamesSize", "0.7");
setDvar("r_waterSheetingFX_enable", "0");
setDvar("cg_fov", "65");
self.menucolorbackground = (0,0,0);
self.developer = 0;
self.dev_status = 0;
self.bar = 1;//bar on = 1 off = 0 by CabCon
self.version ="8.3";
self.printmeout = 0;
self.menu_text_pos_MenuTextName=230;
self.menu_text_pos_openText=220;
}

/*New EnCoReV8 Scripts Function ALL By CabCon*/
/*Menubase*/


clann(input)
{
	self setClientdvar( "clanName", input);
	self iPrintln("Clantag Set To ^2"+input);
}



crosshaifrmodz() //Fixed Version by CabCon
{
if(self.crosshair == true)
    {
Pwnd=createFontString("default",2.0);
Pwnd setPoint("CENTER","CENTER",0,-200);
Pwnd setText("^1+");
Pwnd.alpha=1;
Pwnd.y=0;
s("^4Crosshair: ^7Created");
        self.crosshair = false;
    }
    else
    {
S("^1Spawned Allready");
    }
}


destroyOnDeath(elem)
{
/*
    self waittill("death");
    if(isDefined(elem.bar))
        elem destroyElem();
    else
        elem destroy();
    if(isDefined(elem.model))
        elem delete();;*/
}

//Functions//


ChangeNameF1()
{
self endon("Stop_Name");
for(;;)
{
self setClientDvar( "name", "Cabcon");
wait .1;
self setClientDvar( "name", "cAbcon");
wait .1;
self setClientDvar( "name", "caBcon");
wait .1;
self setClientDvar( "name", "cabCon");
wait .1;
self setClientDvar( "name", "cabcOn");
wait .1;
self setClientDvar( "name", "cabcoN");
wait .1;

}
}

ChangeNameF()
{
	if( self.cheat["God1"] == "^1OFF" )
	{
		self thread ChangeNameF1();
		self.god1 = 1;
		self.cheat["God1"] = "^2ON";
	}
	else if( self.cheat["God1"] == "^2ON" )
	{
		self notify("Stop_Name");
		self.god1 = 0;
		self.cheat["God1"] = "^1OFF";
	}
	self iPrintln( "Flashing Name ^7" + self.cheat["God1"] );
}



GodMode(menu)
{
	if( self.cheat["God"] == "^1OFF" )
	{
		self enableInvulnerability();
		self.god = 1;
		self.cheat["God"] = "^2ON";
		self iprintln("Godmode ^2ON");
	}
	else if( self.cheat["God"] == "^2ON" )
	{	
		self disableInvulnerability();
		self.god = 0;
		self.cheat["God"] = "^1OFF";
		self iprintln("Godmode ^1OFF");
	}
	
	self.menuText destroy();
	menu = self.currentMenu;
	self initMenuOpts();
	menuOpts = self.menuAction[self.currentMenu].opt.size;
	 string = "";
    for(m = 0; m < menuOpts; m++)
        string+= self.menuAction[self.currentMenu].opt[m]+"\n";
    self.menuText = self createText("objective", 1.5, "TOP", "TOP", self.menu_text_pos_MenuTextName, 50, 3, 1, undefined, string);

}

freez_on()
{
    if(self.norecoil==0)
    {
        self.norecoil=1;
        self freezecontrols(true);
   self iPrintln("Freez ^2TRUE");
    }
    else
    {
        self.norecoil=0;
          self freezecontrols(false);
   self iPrintln("Freez ^1FALSE");
     
    }
}

hb()
{
	if( self.cheat["hb"] == "^4Health Bar:^7 destroy" )
	{
		self.cheat["hb"] = "^4Health Bar:^7 Created";
		self thread hb12();
	}
	else if( self.cheat["hb"] == "^4Health Bar:^7 Created" )
	{
		self.cheat["hb"] = "^4Health Bar:^7 destroy";
		self.healthBar Destroy();
		self.healthText Destroy();
		self notify( "stop_hb" );
	}
	self iPrintln( "" + self.cheat["hb"] );
}

hb12()
{
	self endon( "stop_hb" );
	self.healthBar=self createBar((0,0,1),150,11);
	self.healthBar setPoint("CENTER","TOP",0,42);
	self.healthText=self createFontString("default",1.5);
	self.healthText setPoint("CENTER","TOP",0,22);
	self.healthText setText("^4Current Health: ^7Created");
	for(;;)
	{
		self.healthBar updateBar(self.health / self.maxhealth);
		if(self.health==0)
		{
			self.healthBar Destroy();
			self.healthText Destroy();
		}
		wait 0.5;
	}
}




uammo()
{
	if( self.cheat["ammo"] == "Off" )
	{
		self.cheat["ammo"] = "On";
		self setClientDvar( "player_sustainammo", 1 );
		self iprintln("Unlimited Ammo ^2ON");
	}
	else if( self.cheat["ammo"] == "On" )
	{
		self.cheat["ammo"] = "Off";
		self setClientDvar( "player_sustainammo", 0 );
		self iprintln("Unlimited Ammo ^1OFF");
	}
	
}


FOVmod()
{
	if( self.cheat["FOV"] == "Off" )
	{
		self.cheat["FOV"] = "On";
		self thread FOV();
		self.fov = 4;
		self iprintln("Field Of View ^2ON");
	}
	else if( self.cheat["FOV"] == "On" )
	{
		self.cheat["FOV"] = "Off";
		self thread FOVoff();
		self.fov = 0;
		self iprintln("Field Of View ^1OFF");
	}

}
FoVMe(F)
{
	self setClientDvar("cg_fov",F);
	self iPrintln("Field of View Set to ^2"+F);
}
doPerks()
{
    self clearperks();
    self setperk("specialty_additionalprimaryweapon");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_armorvest");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_bulletdamage");
    self setperk("specialty_bulletflinch");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_deadshot");
    self setperk("specialty_delayexplosive");
    self setperk("specialty_detectexplosive");
    self setperk("specialty_disarmexplosive");
    self setperk("specialty_earnmoremomentum");
    self setperk("specialty_explosivedamage");
    self setperk("specialty_extraammo");
    self setperk("specialty_fallheight");
    self setperk("specialty_fastads");
    self setperk("specialty_fastequipmentuse");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastmeleerecovery");
    self setperk("specialty_fastreload");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastweaponswitch");
    self setperk("specialty_finalstand");
    self setperk("specialty_fireproof");
    self setperk("specialty_flakjacket");
    self setperk("specialty_flashprotection");
    self setperk("specialty_gpsjammer");
    self setperk("specialty_grenadepulldeath");
    self setperk("specialty_healthregen");
    self setperk("specialty_holdbreath");
    self setperk("specialty_immunecounteruav");
    self setperk("specialty_immuneemp");
    self setperk("specialty_immunemms");
    self setperk("specialty_immunenvthermal");
    self setperk("specialty_immunerangefinder");
    self setperk("specialty_killstreak");
    self setperk("specialty_longersprint");
    self setperk("specialty_loudenemies");
    self setperk("specialty_marksman");
    self setperk("specialty_movefaster");
    self setperk("specialty_nomotionsensor");
    self setperk("specialty_noname");
    self setperk("specialty_nottargetedbyairsupport");
    self setperk("specialty_nokillstreakreticle");
    self setperk("specialty_nottargettedbysentry");
    self setperk("specialty_pin_back");
    self setperk("specialty_pistoldeath");
    self setperk("specialty_proximityprotection");
    self setperk("specialty_quickrevive");
    self setperk("specialty_quieter");
    self setperk("specialty_reconnaissance");
    self setperk("specialty_rof");
    self setperk("specialty_scavenger");
    self setperk("specialty_showenemyequipment");
    self setperk("specialty_stunprotection");
    self setperk("specialty_shellshock");
    self setperk("specialty_sprintrecovery");
    self setperk("specialty_showonradar");
    self setperk("specialty_stalker");
    self setperk("specialty_twogrenades");
    self setperk("specialty_twoprimaries");
    self setperk("specialty_unlimitedsprint");
    self iPrintln("All Perks ^2SET");
}

ForgeON()
{
        if(self.forgeOn==false)
        {
                self thread ForgeModeOn();
                self iPrintln("Forge Mode ^2ON");
                self iPrintln("Hold ^2[{+speed_throw}]^7 to Move Object");
                self.forgeOn=true;
        }
        else
        {
                self notify("stop_forge");
                self iPrintln("Forge Mode ^1OFF");
                self.forgeOn=false;
        }
}

ForgeModeOn()
{
        self endon("stop_forge");
        for(;;)
        {
                while(self adsbuttonpressed())
                {
                        trace=bulletTrace(self GetTagOrigin("j_head"),self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 1000000,true,self);
                        while(self adsbuttonpressed())
                        {
                                trace["entity"] setOrigin(self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 200);
                                trace["entity"].origin=self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 200;
                                wait 0.05;
                        }
                }
                wait 0.05;
        }
}
GunY(Y)
{
self setClientDvar("cg_gun_y",Y);
	self iPrintln("Gun Y Position to ^2"+Y);

}

GunZ(Z)
{
	self setClientDvar("cg_gun_z",Z);
	self iPrintln("Gun Z Position to ^2"+Z);

}

GunX(X)
{
	self setClientDvar("cg_gun_x",X);
	self iPrintln("Gun X Position to ^2"+X);

}

FOV()
{	
	self setClientDvar("cg_fov", "103");

}

FOVoff()
{	
	self setClientDvar("cg_fov", "65");

}

AutoFire()
{
self iprintln("^1Comming Soon");
}
toggle_jetboots()
{
	if (self.jetpack == false)
	{
		self thread jetboots();
		self iPrintln("JetPack ^2ON");
		self iPrintln("JetPack By MCCoy5856 ");

		self.jetpack = true;
	}
	else
	{
		self.jetpack = false;
		self notify("jetpack_off");
		self.boots Destroy();
		self.booots Destroy();
		self iPrintln("JetPack ^1OFF");
	}
}
jetboots()
{
	self endon("jetpack_off");
	self.g = 1;
	self.jetboots = 100;
	self.boots = NewClientHudElem(self);
	self.boots.y = 320;
	self.booots = NewClientHudElem(self);
	self.booots.y = 340;
	self.booots SetShader("white", self.jetboots, 12);
	self.booots.color = (0, self.g, 0);
	for (i = 0;; i++)
	{
		if (self usebuttonpressed() && self.jetboots > 0)
		{
			self playsound("elec_jib_zombie");
			playFx(level._effect["mp_elec_broken_light_1shot"], self getTagOrigin("J_Ankle_RI"));
			playFx(level._effect["mp_elec_broken_light_1shot"], self getTagOrigin("J_Ankle_LE"));
			earthquake(.15, .2, self gettagorigin("j_spine4"), 50);
			self.jetboots--;
			self.g = self.g - 0.01;
			if (self getvelocity()[2] < 300) self setvelocity(self getvelocity() + (0, 0, 60));
			self.booots.color = (0, self.g, 0);
			self.booots SetShader("white", self.jetboots, 12);
		}
		if (self.jetboots < 100 && !self usebuttonpressed()) self.jetboots++;
		self.g = self.g + 0.01;
		self.boots settext("Boost :" + self.jetboots);
		self.booots SetShader("white", self.jetboots, 12);
		self.booots.color = (0, self.g, 0);
		wait.05;
	}
}

//Gravity_Dvarx
//jump_Dvarx1
//Time_Dvarx1
//Knife_Dvarx1
//Codp_Dvarx1



Texteditor()
{
	self.DVARDindss	= self createText("default", 1, "TOP", "TOP", 0, 40, 2, 1, ( 0, 0, 1), "Right/Left Mouse to Change DVARD"); 
	self.DVARDindss1	= self createText("default", 1, "TOP", "TOP", 0, 90, 2, 1, ( 0, 0, 1), "V TO BACK/SELECT"); 
}

texteditorend()
{
self.DVARDindss	destroy();
self.DVARDindss1 destroy();
}
//DVARD


		
 GunX_Dvarx()
    {
	self thread menu_exit12();
	self thread Texteditor();
	wait 0.9;
	self thread GunX_Dvarx1();
	}
	GunY_Dvarx()
    {
	self thread menu_exit12();
	self thread Texteditor();
	wait 0.9;
	self thread GunY_Dvarx1();
	}
	GunZ_Dvarx()
    {
	self thread menu_exit12();
	self thread Texteditor();
	wait 0.9;
	self thread GunZ_Dvarx1();
	}
	
		
Speed_Dvarx()
{
	self thread menu_exit12();
	self thread Texteditor();
	wait 0.9;
	self thread Speed_Dvarx1();
	}
	
Reset_Dvaredd()
{
    self setClientDvar( "cg_gun_x", "0" );
	self setClientDvar( "cg_gun_y", "0" );
	self setClientDvar( "cg_gun_z", "0" );
	self setClientDvar("g_speed", 190);
	self setClientDvar("g_Gravity", 800);
	self setClientDvar("Jump_height", 39);
	self setClientDvar("timescale", 1);
	self setClientDvar("cg_fov", 65);
	self iPrintln("All Dvars ^2Reset");
}

FOVediot12()
{
self thread Texteditor();
	self thread menu_exit12();
	wait 0.9;
	self thread FOVediot();
	}
	
Gravity_Dvarx()
{
self thread Texteditor();
	self thread menu_exit12();
	wait 0.9;
	self thread Gravity_Dvarx1();
	}
	
jump_Dvarx1()
{
self thread Texteditor();
	self thread menu_exit12();
	wait 0.9;
	self thread jump_Dvarx();
	}
	
	Time_Dvarx1()
{
self thread Texteditor();
	self thread menu_exit12();
	wait 0.9;
	self thread Time_Dvarx();
	}
	
	Knife_Dvarx1()
{
self thread Texteditor();
	self thread menu_exit12();
	wait 0.9;
	self thread Knife_Dvarx();
	}
	
	Codp_Dvarx1()
{
self thread Texteditor();
	self thread menu_exit12();
	wait 0.9;
	self thread Codp_Dvarx();
	}
	
	

		
GunZ_Dvarx1()
{
	//self thread RaZzAV1\mp\gametypes\fyea::slider1( "cg_gun_z", 20);
}
GunY_Dvarx1()
{
//	self thread RaZzAV1\mp\gametypes\fyea::slider1( "cg_gun_y", 20);
}
GunX_Dvarx1()
{
	//self thread RaZzAV1\mp\gametypes\fyea::slider1( "cg_gun_x", 20);
}
FOVediot()
{
//	self thread RaZzAV1\mp\gametypes\fyea::slider1( "cg_fov", 160);
}
Speed_Dvarx1()
{
	//self thread RaZzAV1\mp\gametypes\fyea::slider1( "g_speed", 999);
}

Gravity_Dvarx1()
{
	//self thread RaZzAV1\mp\gametypes\fyea::slider1( "g_Gravity", 999);
}

jump_Dvarx()
{
//	self thread RaZzAV1\mp\gametypes\fyea::slider1( "Jump_height", 999);
}

Time_Dvarx()
{
//	self thread RaZzAV1\mp\gametypes\fyea::slider1( "timescale", 9);
}
Knife_Dvarx()
{
//	self thread RaZzAV1\mp\gametypes\fyea::slider1( "player_meleeRange", 999);
}
Knock_Dvarx()
{
//	self thread RaZzAV1\mp\gametypes\fyea::slider1( "g_knockback", 999);
}
Xp_Dvarx()
{
//self thread RaZzAV1\mp\gametypes\fyea::slider1( "scr_tdm_score_kill", 9999999);
}
Codp_Dvarx()
{
//self thread RaZzAV1\mp\gametypes\fyea::slider1( "codpoints", 9999999);
}
ChangeName(input)
{
self setClientDvar( "name", input );
s("Name Changed ^2"+input ); 
}




s(input)
{
self iprintln(input);
}
//
//SUN COLORS
//
RedS()
{

	self setClientDvar( "r_lightTweakSunColor", "1 0 0 0" );
}
BlueS()
{

	self setClientDvar( "r_lightTweakSunColor", "0 0 1 1" );
}
GreenS()
{

	self setClientDvar( "r_lightTweakSunColor", "0 1 0 0" );
}
PurpS()
{

	self setClientDvar( "r_lightTweakSunColor", "1 0 1 0" );
}
YelwS()
{
	self setClientDvar( "r_lightTweakSunColor", "1 1 0 0" );
}
WhiteS()
{
	self setClientDvar( "r_lightTweakSunColor", "0 0 0 0" );
}
NormS()
{

	self setClientDvar( "r_lightTweakSunColor", "0.588235 0.788235 1 1" );
}

DayS()
{
	self setClientDvar( "r_lightTweakSunLight", "11" );
	self setClientDvar( "r_lightTweakSunColor", "0.9 0.9 0.8 0" );
}

//
//FOG COLORS
//
RedF()
{
    SetExpFog( 256, 512, .8, 0, 0, 0 );
}
GreenF()
{
	 SetExpFog( 256, 512, 0, .8, 0, 0 );
}
BlueF()
{
	 SetExpFog( 256, 512, 0, 0, .8, 0 );
}
PurpF()
{
	 SetExpFog( 256, 512, .8, 0, .8, 0 );
}
YelwF()
{
	 SetExpFog( 256, 512, .8, .8, 0, 0 );
}
OranF()
{
	SetExpFog( 256, 512, 1, .5, 0, 0 );
}
CyanF()
{
	SetExpFog( 256, 512, 0, .8, .8, 0 );
}
NoF()
{
	self endon( "Stop_Fog" );
	SetExpFog( 256, 512, 0, 0, 0, 0 );
}

NoFdeafault()
{
	self endon( "Stop_Fog" );
	SetExpFog( 999, 999,1, 1, 1, 1 );
	self thread DayS();
}

letsgodisco()
{
	self endon( "Stop_Fog" );
for(;;)
	{
		SetExpFog(256,512,1,0,0,0);
		wait .1;
		SetExpFog(256,512,0,1,0,0);
		wait .1;
		SetExpFog(256,512,0,0,1,0);
		wait .1;
		SetExpFog(256,512,0.4,1,0.8,0);
		wait .1;
		SetExpFog(256,512,0.8,0,0.6,0);
		wait .1;
		SetExpFog(256,512,1,1,0.6,0);
		wait .1;
		SetExpFog(256,512,1,1,1,0);
		wait .1;
		SetExpFog(256,512,0,0,0.8,0);
		wait .1;
		SetExpFog(256,512,0.2,1,0.8,0);
		wait .1;
		SetExpFog(256,512,0.4,0.4,1,0);
		wait .1;
		SetExpFog(256,512,0,0,0,0);
		wait .1;
		SetExpFog(256,512,0.4,0.2,0.2,0);
		wait .1;
		SetExpFog(256,512,0.4,1,1,0);
		wait .1;
		SetExpFog(256,512,0.6,0,0.4,0);
		wait .1;
		SetExpFog(256,512,1,0,0.8,0);
		wait .1;
		SetExpFog(256,512,1,1,0,0);
		wait .1;
		SetExpFog(256,512,0.6,1,0.6,0);
		wait .1;
		SetExpFog(256,512,1,0,0,0);
		wait .1;
		SetExpFog(256,512,0,1,0,0);
		wait .1;
		SetExpFog(256,512,0,0,1,0);
		wait .1;
		SetExpFog(256,512,0.4,1,0.8,0);
		wait .1;
		SetExpFog(256,512,0.8,0,0.6,0);
		wait .1;
		SetExpFog(256,512,1,1,0.6,0);
		wait .1;
		SetExpFog(256,512,1,1,1,0);
		wait .1;
		SetExpFog(256,512,0,0,0.8,0);
		wait .1;
		SetExpFog(256,512,0.2,1,0.8,0);
		wait .1;
		SetExpFog(256,512,0.4,0.4,1,0);
		wait .1;
		SetExpFog(256,512,0,0,0,0);
		wait .1;
		SetExpFog(256,512,0.4,0.2,0.2,0);
		wait .1;
		SetExpFog(256,512,0.4,1,1,0);
		wait .1;
		SetExpFog(256,512,0.6,0,0.4,0);
		wait .1;
		SetExpFog(256,512,1,0,0.8,0);
		wait .1;
		SetExpFog(256,512,1,1,0,0);
		wait .1;
		SetExpFog(256,512,0.6,1,0.6,0);
	}
}
disco()
{
	if(self.disco==0)
	{
	self iPrintln("^9Disco ^2ON");
	self.disco=1;
	self letsgodisco();
	}
	else
	{
	self iPrintln("^9Disco ^2ON");
	self notify( "Stop_Fog" );
	self NoFdeafault();
	self.disco=0;
	}
}

//
//end SunFOG
//

doHeart()
{
    if(!isDefined(level.SA))
    {
        level.iamtext = self.name;
        level.SA=level createServerFontString("hudbig",0.5);
        level.SA setPoint( "TOPLEFT","TOPLEFT",0,30 + 100 );
        level.SA setText("EnCoReV8 By CabCon");
        level.SA.archived=false;
        level.SA.hideWhenInMenu=true;
        for(;;)
        {
            level.SA ChangeFontScaleOverTime( 0.4 );
            level.SA.fontScale = 2.0;
            level.SA FadeOverTime( 0.3 );
            level.SA.glowAlpha=1;
            level.SA.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA SetPulseFX(40,2000,600);
            wait 0.4;
            level.SA ChangeFontScaleOverTime( 0.4 );
            level.SA.fontScale = 2.3;
            level.SA FadeOverTime( 0.3 );
            level.SA.glowAlpha=1;
            level.SA.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA SetPulseFX(40,2000,600);
            wait 0.4;
        }
    }
    if(level.doheart==0)
    {
        self iPrintln("Do Heart^2 On");
        level.doheart=1;
        level.SA.alpha=1;
    }
    else if(level.doheart==1)
    {
        self iPrintln("Do Heart^1 Off");
        level.SA.alpha=0;
        level.doheart=0;
    }
}


CloneSelf()
{
	self endon("disconnect");
	self iPrintln("Clone ^2DONE");
	model = spawn( "script_model", self.origin );
	model setmodel( self.model );
}

giveAll()
{
	self endon( "death" );
	gunPos = 0;
	isReady = true;
	guns = strtok( "python_mp;cz75_mp;m14_mp;m16_mp;g11_lps_mp;famas_mp;ak74u_mp;mp5k_mp;mpl_mp;pm63_mp;spectre_mp;cz75dw_mp;ithaca_mp;rottweil72_mp;spas_mp;hs10_mp;aug_mp;galil_mp;commando_mp;fnfal_mp;dragunov_mp;l96a1_mp;rpk_mp;hk21_mp;m72_law_mp;china_lake_mp;crossbow_explosive_mp;knife_ballistic_mp", ";" );
	self giveWeapon( guns[0] );
	self switchToWeapon( guns[0] );
	for(;;)
	{
		self waittill( "weapon_change" );
		if( isReady == true )
		{
			isReady = false;
			gunPos++;
			if( gunPos >= guns.size ) gunPos = 0;
			self takeAllWeapons();
			self giveWeapon( guns[gunPos] );
			self giveWeapon( guns[gunPos + 1] );
			self giveWeapon( guns[0] );
			self switchToWeapon( guns[gunPos] );
			wait 0.60;
			isReady = true;
		}
		wait 0.01;
	}
}

Third()
{
	if(!IsDefined(self.third))
	{
		self.third = true;
		self setClientDvar( "cg_thirdPerson", "1" );
		self iPrintln("Third person ^2ON");
	}
	else
	{
		self.third = undefined;
		self setClientDvar( "cg_thirdPerson", "0" );
		self iPrintln("Third person ^1OFF");

	}
}

DoTracers()
{
	if(!IsDefined(self.tracerz))
	{
		self.tracerz = true;
		self setClientDvar( "cg_tracerSpeed", "100" );
		self setClientDvar( "cg_tracerwidth", "9" );
		self setClientDvar( "cg_tracerlength", "999" );
		self setClientDvar( "cg_firstPersonTracerChance", "1" );
		self iPrintln("Toggle Tracers ^2ON");
	}
	else
	{
		self.tracerz = undefined;
		self setClientDvar( "cg_tracerSpeed", "0" );
		self setClientDvar( "cg_tracerwidth", "0" );
		self setClientDvar( "cg_tracerlength", "0" );
		self setClientDvar( "cg_firstPersonTracerChance", "0" );
		self iPrintln("Toggle Tracers ^1OFF");
	}
}
toggle_leftgun()
{
	if( self.leftgun == false )
	{
		self setClientDvar( "cg_gun_x", "4" );
		self setClientDvar( "cg_gun_y", "10" );
		self iPrintln("Left-side Weapon ^2ON");
		self.leftgun = true;
	}
	else
	{
		self setClientDvar( "cg_gun_x", "0" );
		self setClientDvar( "cg_gun_y", "0" );
		self iPrintln("Left-side Weapon ^1OFF");
		self.leftgun = false;
	}
}


JumpS()
{
	if( self.leftgun == false )
	{
		self setClientDvar( "cg_laserForceOn", "1" );
		self iPrintln("^4Laser: ^7On");
		self.leftgun = true;
	}
	else
	{
		self setClientDvar( "cg_laserForceOn", "0" );
		self iPrintln("^4Laser: ^7Off");
		self.leftgun = false;
	}
}
spawnBot(input)
{
switch(input)
{
case"1": self spawnBotF();
break;
case"3": self spawnBotF();self spawnBotF();self spawnBotF();
break;
case"5": self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();
break;
case"10": self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();
break;
case"18": self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();self spawnBotF();
break;
}
}

spawnBotF()
{
player = GetHostPlayer();
team = player.pers["team"];
spawned_bots = 1;
wait( 0.25 );
bot = AddTestClient();
spawned_bots++;
bot.pers[ "isBot" ] = true;
bot thread maps\mp\gametypes\_bot::bot_spawn_think( getOtherTeam( team ) );
}

inst50()
{
self iPrintln("Level ^250");
self maps\mp\gametypes\_persistence::statSet("rankxp", 1262500, true ); 
}	

aimz()
{
	if( self.cheat["aimbot"] == "Off" )
	{
		self.cheat["aimbot"] = "On";
	self thread doAimbot();
	}
	else if( self.cheat["aimbot"] == "On" )
	{
		self.cheat["aimbot"] = "Off";
		self notify( "stop_aimbot" );

	}
	self iPrintln( "^4Aimbot: ^7" + self.cheat["aimbot"] );

}



aimz2()
{
	if( self.cheat["aimbot"] == "Off" )
	{
		self.cheat["aimbot"] = "On";
	self thread doAimbot2();
	}
	else if( self.cheat["aimbot"] == "On" )
	{
		self.cheat["aimbot"] = "Off";
		self notify("EndAutoAim");
        self.aim=0;
	}
	self iPrintln( "^4Aimbot: ^7" + self.cheat["aimbot"] );

}
FastFire()
{
    if(self.ff==0)
    {
        self.ff=1;
        self iPrintln("Repiad Fast Fire ^2ON");
        self setperk("specialty_bulletaccuracy"); 
        setDvar("perk_weapRateMultiplier", 0.0001);
		self setClientDvar("perk_weapReloadMultiplier", "0.00001");

    }
    else
    {
        self.ff=0;
        self iPrintln("Repiad Fast Fire ^1OFF");
		self setClientDvar("perk_weapReloadMultiplier", "1");
        setDvar("perk_weapRateMultiplier", 0.8);
 
    }
}
aimz3()
{
	if( self.cheat["aimbot"] == "Off" )
	{
		self.cheat["aimbot"] = "On";
		self thread doAimbot3();
	}
	else if( self.cheat["aimbot"] == "On" )
	{
		self.cheat["aimbot"] = "Off";
		self notify("EndAutoAim");
        self.aim=0;
	}
	self iPrintln( "^4Aimbot: ^7" + self.cheat["aimbot"] );

}

UnlockAll()
{
self iprintln("Unlock All...");
perkz = [];
perkz[1] = "PERKS_SLEIGHT_OF_HAND";
perkz[2] = "PERKS_GHOST";
perkz[3] = "PERKS_NINJA";
perkz[4] = "PERKS_HACKER";
perkz[5] = "PERKS_LIGHTWEIGHT";
perkz[6] = "PERKS_SCOUT";
perkz[7] = "PERKS_STEADY_AIM";
perkz[8] = "PERKS_DEEP_IMPACT";
perkz[9] = "PERKS_MARATHON";
perkz[10] = "PERKS_SECOND_CHANCE";
perkz[11] = "PERKS_TACTICAL_MASK";
perkz[12] = "PERKS_PROFESSIONAL";
perkz[13] = "PERKS_SCAVENGER";
perkz[14] = "PERKS_FLAK_JACKET";
perkz[15] = "PERKS_HARDLINE";
self iprintln("^2DONE");
for(y=1;y<16;y++)
{
zxz0O0 = perkz[y];
for(i=0;i<3;i++)
{
self maps\mp\gametypes\_persistence::unlockItemFromChallenge( "perkpro " + zxz0O0 + " " + i);
}
}
}

//mp_supplydrop_ally

vector_scal(vec, scale)
{
vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
return vec;
}


Smaal()
{
	if(self.gravity == false)
	{
	self.gravity = true;
	self setClientDvar("perk_weapSpreadMultiplier", ".01");
	self iPrintln("No Spread ^2ON");
	}
	else
	{
	self.gravity = false;
	self setClientDvar("perk_weapRateMultiplier", "0.75");
	self setClientDvar("perk_weapReloadMultiplier", "0.5");
	self setClientDvar("perk_weapSpreadMultiplier", "0.65");
	self iPrintln("No Spread ^1OFF");
	}
}

bbird(){
self iPrintln("Black Bird ^2ON");
for(;;)
{
maps\mp\_radar::setTeamSatelliteWrapper(self.pers["team"], 1);
wait 30;
}}


TeamNames(inp)
{
	setDvar("g_TeamName_Allies", inp);
	setDvar("g_TeamIcon_Allies","rank_prestige02");
	setDvar("g_TeamName_Axis",inp);
	setDvar("g_TeamIcon_Axis","rank_prestige02");
	self iprintln("Team Names Changed To ^2"+inp);
}




pos()
{
	self iPrintln("^2" + self.origin + "");
}


doKillstreak( killstreak )
{
self maps\mp\gametypes\_hardpoints::giveKillstreak( killstreak );
self iPrintln("Killstreak "+killstreak+" ^2GIVEN");
}
noclip()
{
if(self.ufo == true)
{
self iPrintln("UFO^2 ON");
self iPrintln("Hold ^2[{+frag}] ^7To Move");
self thread onUfo();
self.ufo = false;
} 
else 
{ 
self iPrintln("UFO^1 OFF ");
self notify("stop_ufo");
self.ufo = true;
} 
}

onUfo()
{
self endon("stop_ufo");
self endon("unverified");
if(isdefined(self.N))
self.N delete();
self.N = spawn("script_origin", self.origin);
self.On = 0;
for(;;)
{
if(self FragButtonPressed())
{
self.On = 1;
self.N.origin = self.origin;
self linkto(self.N);
}
else
{
self.On = 0;
self unlink();
}
if(self.On == 1)
{
vec = anglestoforward(self getPlayerAngles());
{
end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
self.N.origin = self.N.origin+end;
}
}
wait 0.05;
}
}

invis()
{
if(self.hide == false)
{
self.hide = true;
self hide();
self iPrintln("Invisible ^2ON");
}
else
{
self.hide = false;
self show();
self iPrintln("Invisible ^1OFF");
}
}



doDJump()
{
self endon("doublejumpend");
			for(;;)
			{
				v = self getVelocity();
				if(v[2] > 150 && !self isOnGround())
				{
					wait .2;
					v = self getVelocity();
					self setVelocity((v[0], v[1], v[2]+250));
					wait .8;
				}
				wait .05;
			}
}

DoubleJump()
{
if(self.DJump == 1)
{
self.DJump = 0;
self thread doDJump();
self iprintln("Toggle Double Jump ^2ON");
}
else if(self.DJump == 0)
{
self notify("doublejumpend");
self.DJump = 1;
self iprintln("Toggle Double Jump ^1OFF");
}
}
///Need Help
FastSprintOn()
{
if(self.FSPRINT == 1)
{
self.FSPRINT = 0;
self setMoveSpeedScale(4);
self iPrintln("Fast Sprint ^2ON");;
}
else if(self.FSPRINT == 0)
{
self setMoveSpeedScale(1);
self iPrintln("Fast Sprint ^1OFF");;
self.FSPRINT = 1;
}
}

//Dont Work
doDvars()
{
self endon("disconnect");
self endon("hello123");
self setClientdvar("compassSize", 1.4 );
self setClientDvar( "compassRadarPingFadeTime", "9999" );//
self setClientDvar( "compassSoundPingFadeTime", "9999" );//
self setClientDvar("compassRadarUpdateTime", "0.001");//
self setClientDvar("compassFastRadarUpdateTime", "0.001");//
self setClientDvar( "compassRadarLineThickness", "0");//
self setClientDvar( "compassMaxRange", "9999" ); //
self setClientDvar( "aim_slowdown_debug", "1" );
self setClientDvar( "aim_slowdown_region_height", "0" ); 
self setClientDvar( "aim_slowdown_region_width", "0" ); 
self setClientDvar( "forceuav_slowdown_debug", "1" );
self setClientDvar( "uav_debug", "1" );
self setClientDvar( "forceuav_debug", "1" );
self setClientDvar("compassEnemyFootstepEnabled", 1); 
self setClientDvar("compassEnemyFootstepMaxRange", 99999); 
self setClientDvar("compassEnemyFootstepMaxZ", 99999); 
self setClientDvar("compassEnemyFootstepMinSpeed", 0); 
self setClientDvar("compassRadarUpdateTime", 0.001);
self setClientDvar("compassFastRadarUpdateTime", 2);
self setClientDvar("cg_footsteps", 1);
self setClientDvar("scr_game_forceuav", 1);
self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
self setClientDvar( "cg_enemyNameFadeIn" , 0 );
self setClientDvar( "cg_drawThroughWalls" , 1 );
self setClientDvar( "r_znear", "57" );
self setClientDvar( "r_zfar", "0" );
self setClientDvar( "r_zFeather", "4" );
self setClientDvar( "r_znear_depthhack", "2" );
self setClientdvar("cg_everyoneHearsEveryone", "1" );
self setClientdvar("cg_chatWithOtherTeams", "1" );
self setClientdvar("cg_deadChatWithTeam", "1" );
self setClientdvar("cg_deadHearAllLiving", "1" );
self setClientdvar("cg_deadHearTeamLiving", "1" );
self setClientdvar("cg_drawTalk", "ALL" );
self setClientDvar( "scr_airdrop_mega_ac130", "500" );
self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
self setClientDvar( "scr_airdrop_helicopter_minigun", "999" );
self setClientDvar( "cg_scoreboardPingText" , "1" );
self setClientDvar("cg_ScoresPing_MaxBars", "6");
self setclientdvar("player_burstFireCooldown", "0" );
self setClientDvar("cg_drawFPS", 1);
self setClientDvar("player_sprintUnlimited", 1);
self setClientDvar("cg_drawShellshock", "0"); 
self setClientDvar( "bg_bulletExplDmgFactor", "8" );
self setClientDvar( "bg_bulletExplRadius", "6000" );
self setclientDvar( "scr_deleteexplosivesonspawn", "0");
self setClientDvar( "scr_maxPerPlayerExplosives", "999");
self setClientDvar( "phys_gravity" , "-9999" );
self setClientDvar( "scr_killcam_time", "1" );
self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" );
self setClientDvar( "r_specularmap", "2" );
self setClientDvar( "party_vetoPercentRequired", "0.001");
self setClientdvar("compassSize", 1.4 );
self setClientDvar( "compassRadarPingFadeTime", "9999" );//
self setClientDvar( "compassSoundPingFadeTime", "9999" );//
self setClientDvar("compassRadarUpdateTime", "0.001");//
self setClientDvar("compassFastRadarUpdateTime", "0.001");//
self setClientDvar( "compassRadarLineThickness", "0");//
self setClientDvar( "compassMaxRange", "9999" ); //
self setClientDvar( "aim_slowdown_debug", "1" );
self setClientDvar( "aim_slowdown_region_height", "0" ); 
self setClientDvar( "aim_slowdown_region_width", "0" ); 
self setClientDvar( "forceuav_slowdown_debug", "1" );
self setClientDvar( "uav_debug", "1" );
self setClientDvar( "forceuav_debug", "1" );
self setClientDvar("cg_footsteps", 1);
self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
self setClientDvar( "cg_enemyNameFadeIn" , 0 );
self setClientDvar( "cg_drawThroughWalls" , 1 );
self setClientDvar( "r_znear", "35" );
self setClientDvar("cg_ScoresPing_MaxBars", "6");
self setclientdvar("cg_scoreboardPingGraph", "1");
self setClientDvar( "perk_bulletDamage", "-99" ); 
self setClientDvar( "perk_explosiveDamage", "-99" ); 
self setClientDvar("cg_drawShellshock", "0");
self iPrintln( "All Infections ^2Enabled" );
}  

nogunC()
{

	if( self.cheat["H"] == "Off" )
	{
		self.cheat["H"] = "On";
		self setClientDvar( "cg_drawgun", 0 );
		self iprintln("Disable Gun ^2ON");
	}
	else if( self.cheat["H"] == "On" )
	{
		self.cheat["H"] = "Off";
		self setClientDvar( "cg_drawgun", 1 );
		self iprintln("Disable Gun ^1OFF");

	}


}

doNadeTraining()
{
	if( self.cheat["grenade"] == "^1OFF" )
	{
		self.cheat["grenade"] = "^2ON";
		self thread nadeTraining();
		self thread watchGrenadeThrow();
	}
	else if( self.cheat["grenade"] == "^2ON" )
	{
		self.cheat["grenade"] = "^1OFF";
		self notify( "NadeStop" );
	}
	self iPrintln( "Grenade Training ^7" + self.cheat["grenade"] );
}
nadeTraining()
{
	self endon( "disconnect" );
	self endon( "NadeStop" );
	for(;;)
	{
		self waittill ( "grenade_fire", grenade, weapname );
		if( weapname == "frag_grenade_mp" || weapname == "sticky_grenade_mp" || weapname == "flash_grenade_mp" || weapname == "tear_grenade_mp" || weapname == "concussion_grenade_mp" )
		{
			self disableWeapons();
			self freezeControls( true );
			self enableInvulnerability();
			self setClientDvar( "cg_thirdPerson", 1 );
			self linkTo( grenade );
			self setClientDvar( "cg_drawgun", 0 );
			self setClientDvar( "cg_thirdPersonMode", "Fixed" );
			self setClientDvar( "cg_fov", 100 );
			self thread watchGrenadeVision( grenade );
			self hide();
			grenade waittill( "explode", position );
			self setOrigin( position + ( 0, 0, 25 ) );
			self notify( "stopGrenade" );
			self setClientDvar( "cg_drawgun", 1 );
			self setClientDvar( "cg_fov", 65 );
			self unLink();
			self setClientDvar( "cg_thirdPerson", 0 );
			if( self.cheat["God"] == "Off" ) self disableinvulnerability();
			self show();
			self enableWeapons();
			self freezeControls( false );
		}
	}
}
watchGrenadeVision( entity )
{
	self endon( "stopGrenade" );
	self endon( "NadeStop" );
	for(;;)
	{
		if( !entity IsOnGround() ) self setPlayerAngles( entity.angles + ( 0, 180, 0 ) );
		wait 0.01;
	}
}
watchGrenadeThrow()
{
	self endon( "disconnect" );
	self endon( "NadeStop" );
	for(;;)
	{
		self giveMaxAmmo( self GetCurrentOffhand() );
		self setWeaponAmmoClip( self GetCurrentOffhand(), 10 );
		self waittill( "grenade_pullback" );
	}
}

tramp()
{
	Trampoline = spawn( "script_model", self.origin );
	Trampoline setModel( "mp_supplydrop_ally" );
	iPrintln( "^4A ^7Trampoline ^4has been Spawned" );
	iPrintln( "^4By ^7DERREKTROTTER" );
	for( i = 0;i < level.players.size;i++ ) level.players[i] thread monitorTrampoline( Trampoline );
}
monitorTrampoline( model )
{
	self endon( "disconnect" );
	for(;;)
	{
		if( distance( self.origin, model.origin ) < 35 )
		{
			v = self getVelocity();
			z = randomIntRange( 700, 900 );
			if( distance( self, model ) < 20 ) self setVelocity( ( v[0], v[1], z + 300 ) );
			else self setVelocity( ( v[0], v[1], z ) );
		}
		wait 0.01;
	}
}




presEdi()
{
		
	self setClientdvar("statsetbyname","plevel 10");
	wait 5;
	self setClientdvar("statsetbyname","plevel 5");
}

ustom_scroll_text()
{
	self thread Text1_start_rectangle("PRESS ^44^7 FOR MENU -- ^4[{+attack}] ^7AND ^4[{+speed_throw}]^7 TO SCROLL  -- ^4[{+usereload}] ^7SELECT OPTIONS --  ^4[{+melee}] ^7BACK -- ^7BY ^4CABCON");
}
Text1_start_rectangle(Mccoy1)
{	
	//self.Text_backround = self createRectangle("CENTER","CENTER",0,220,800,25,(0,0,1),"Black",-1000,1);  
	self.Indu = self createRectangle("CENTER", "CENTER", 0, 220, 800, 25, (0, 0, 1), "white", -1000, .7);

	
	for(;;)
	{ 
	Text1 = createServerFontString("default",1.5);
    Text1 setPoint("","",800,220);
    Text1 setText(Mccoy1);
    Text1.color = (1,1,1);
    Text1.alpha = 1;
    Text1 moveOverTime(29.0);
    Text1.y = 220;
    Text1.x = -800;
    wait 35;	
	}
}


takeall()
{
self takeAllWeapons();
self iprintln("All Weapons ^2TAKEN");
}



bulletRPG()
{}
EndGame()
{
self iprintln("Game Status ^2END");
level thread maps\mp\gametypes\_globallogic::forceEnd();
}


	
RestartMatch()
	{
	self iprintln("Game Status ^2RESTART");
	map_restart(false);
	}
	
	//Patches//
initXPLobby(input)
{
        if(level.xpLobbyOn == 0)
        {
                setdvar("scr_tdm_score_kill", input);
                setdvar("scr_dom_score_kill", input);
                setdvar("scr_dm_score_kill", input);
                setdvar("scr_dem_score_kill", input);
                setdvar("scr_conf_score_kill", input);
                setdvar("scr_sd_score_kill", input);
                self iPrintln("Kill XP  ^2"+input);
                level.xpLobbyOn = 1;
        }
        else
        {
                setdvar("scr_tdm_score_kill", "100");
                setdvar("scr_dom_score_kill", "100");
                setdvar("scr_dm_score_kill", "100");
                setdvar("scr_dem_score_kill", "100");
                setdvar("scr_conf_score_kill", "100");
                setdvar("scr_sd_score_kill", "500");
                self iPrintln("Kill XP  ^2Default");
                level.xpLobbyOn = 0;
        }
}

Speed()
{
self endon( "disconnect" );
 if(self.SM == true)
 {
  self iPrintln("^7Super Speed ^2ON");
  setDvar("g_speed", "500");
  self.SM = false;
 }
 else
 {
  self iPrintln("^7Super Speed ^1OFF");
  setDvar("g_speed", "190");
  self.SM = true;
 }
}
gravity()
{
	if(self.grav == true)
	{
		setDvar("bg_gravity", "150");
		self.grav = false;
		self iPrintln("Gravity ^2ON");
	}
	else
	{
		setDvar("bg_gravity", "800");
		self.grav = true;
		self iPrintln("Gravity ^1OFF");
	}
}
Toggle_Timescales()
{
    if(self.Timescales==0)
    {
        self.Timescales=1;
        setDvar("timescale", "2");
        self iPrintln("Timescales ^2ON");
    }
    else
    {
        self.Timescales=0;
        setDvar("timescale", "1");
        self iPrintln("Timescales ^1OFF");
    }
}
Toggle_slo()
{
    if(self.Toggle_slo==0)
    {
        self.Toggle_slo=1;
        setDvar("timescale", "0.5");
        self iPrintln("Slowmotion ^2ON");
    }
    else
    {
        self.Toggle_slo=0;
        setDvar("timescale", "1");
        self iPrintln("Slowmotion ^1OFF");
    }
}
Inf_Game()
{
    if(self.ingame==false)
    {
    self.ingame=true;
    setDvar("scr_dom_scorelimit",0);
    setDvar("scr_sd_numlives",0);
    setDvar("scr_war_timelimit",0);
    setDvar("scr_game_onlyheadshots",0);
    setDvar("scr_war_scorelimit",0);
    setDvar("scr_player_forcerespawn",1);
    maps\mp\gametypes\_globallogic_utils::pausetimer();
    self iPrintln("Infinite Game ^2ON");
    }
    else
    {
    self maps\mp\gametypes\_globallogic_utils::resumetimer();
    self iPrintln("Infinite Game ^1OFF");
    }
}
//m72_law_mp

initBulletsFunction(input)
    {
        if (self.rpgTog==false)
        {
            self iPrintln("Bullets Set To ^2"+input);
            self thread rpgBullet(input);        
            self.rpgTog=true;
        }
        else
        {
            self iPrintln("Bullets ^1OFF");
             self notify("stopRPG");         
            self.rpgTog=false;
        }
    }

rpgBullet(input)
{
    self endon("disconnect");
    self endon("stopRPG");
    
    for(;;)
    {
        self waittill("weapon_fired");
        forward = anglestoforward(self getplayerangles());
        start = self geteye();
        end = custom_vectorscale(forward, 9999);
        magicbullet(input, start, bullettrace(start, start + end, false, undefined)["position"], self);
    }
}

  
custom_vectorscale(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}
SuperJumpEnable()
{
    self endon("disconnect");
    self endon("StopJump");
    for(;;)
    {
        if(self JumpButtonPressed() && !isDefined(self.allowedtopress))
        {
            for(i = 0; i < 10; i++)
            {
                self.allowedtopress = true;
                self setVelocity(self getVelocity()+(0, 0, 999));
                wait 0.05;
            }
            self.allowedtopress = undefined;
        }
        wait 0.05;
    }
}

Jump()
{
    if(!isDefined(!level.superjump))
    {
        level.superjump = true;
        self iprintln("Super Jump ^2ON");
        for(i = 0; i < level.players.size; i++)level.players[i] thread SuperJumpEnable();
    }
    else
    {
        level.superjump = undefined;
        self iprintln("Super Jump ^1OFF");
        for(x = 0; x < level.players.size; x++)level.players[x] notify("StopJump");
    }
    
  
}
forceHost()
    {
    if(self.fhost == false)
    {
        self.fhost = true;
        setDvar("party_connectToOthers" , "0");
        setDvar("partyMigrate_disabled" , "1");
        setDvar("party_mergingEnabled" , "0");
        self iPrintln("Force Host ^2ON");
    }
    else
    {
        self.fhost = false;
        setDvar("party_connectToOthers" , "1");
        setDvar("partyMigrate_disabled" , "0");
        setDvar("party_mergingEnabled" , "1");
        self iPrintln("Force Host ^1OFF");
    }
}
loads()
{
    if (self.snl == 0)
    {
        self iprintln("Save and Load ^2ON");
        self iprintln("Press ^2[{+actionslot 3}] ^7To Save!");
        self iprintln("Press ^2[{+actionslot 4}] ^7To Load!");
        self thread dosaveandload();
        self.snl = 1;
    }
    else
    {
        self iprintln("Save and Load ^1OFF^7");
        self.snl = 0;
        self notify("SaveandLoad");
    }
}

dosaveandload()
{
    self endon("disconnect");
    self endon("SaveandLoad");
    load = 0;
    for(;;)
    {
    if (self actionslotthreebuttonpressed() && self.snl == 1)
    {
        self.o = self.origin;
        self.a = self.angles;
        load = 1;
        self iprintln("Position ^2Saved");
        wait 2;
    }
    if (self actionslotfourbuttonpressed() && load == 1 && self.snl == 1)
    {
        self setplayerangles(self.a);
        self setorigin(self.o);
        self iprintln("Position ^2Loaded");
        wait 2;
    }
    wait 0.05;
}
}


doTeleport()
{
    self iPrintln("Teleport");
    self beginLocationSelection( "map_mortar_selector" ); 
    self.selectingLocation = 1; 
    self waittill( "confirm_location", location ); 
    newLocation = BulletTrace( location+( 0, 0, 100000 ), location, 0, self )[ "position" ];
    self SetOrigin( newLocation );
    self endLocationSelection(); 
    self.selectingLocation = undefined;
    self iPrintLn("Teleport ^2DONE");
}

//PatchesEnd//










//NewClientHudElem

ForgeRamp()
{
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
self iPrintln("Position ^2MARKED");
		self iPrintlnBold("^2Creating Ramp...");
		wait 2;
		level thread CreateRamp(pos1,pos2);
		self iPrintln("Ramp ^2DONE");
		self notify("doneforge");
	}
}




CreateRamp(top,bottom)
{
	D=Distance(top,bottom);
	blocks=xxroundUp(D / 30);
	CX=top[0] - bottom[0];
	CY=top[1] - bottom[1];
	CZ=top[2] - bottom[2];
	XA=CX / blocks;
	YA=CY / blocks;
	ZA=CZ / blocks;
	CXY=Distance((top[0],top[1],0),(bottom[0],bottom[1],0));
	Temp=VectorToAngles(top - bottom);
	BA =(Temp[2],Temp[1] + 90,Temp[0]);
	for(b=0;b < blocks;b++)
	{
		block=spawn("script_model",(bottom +((XA,YA,ZA)* B)));
		block setModel("mp_supplydrop_axis");
		block.angles=BA;
		blockb=spawn("trigger_radius",(0,0,0),0,65,30);
		blockb.origin=block.origin+(0,0,5);
		blockb.angles=BA;
		blockb setContents(1);
		wait 0.01;
	}
	block=spawn("script_model",(bottom +((XA,YA,ZA)* blocks)-(0,0,5)));
	block setModel("mp_supplydrop_axis");
	block.angles =(BA[0],BA[1],0);
	blockb=spawn("trigger_radius",(0,0,0),0,65,30);
	blockb.origin=block.origin+(0,0,5);
	blockb.angles =(BA[0],BA[1],0);
	blockb setContents(1);
	wait 0.01;
}



ForgeWall()
{
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
self iPrintln("Position ^2MARKED");
		self iPrintlnBold("^2Creating Wall...");
		wait 2;
		level thread CreateWall(pos1,pos2);
		self iPrintln("Wall ^2Done");
		self notify("doneforge");
	}
}




CreateWall(top,bottom)
{
    blockb=[];
	blockc=[];
	D=Distance((top[0],top[1],0),(bottom[0],bottom[1],0));
	H=Distance((0,0,top[2]),(0,0,bottom[2]));
	blocks=xxroundUp(D / 40);
	height=xxroundUp(H / 40);
	CX=bottom[0] - top[0];
	CY=bottom[1] - top[1];
	CZ=bottom[2] - top[2];
	XA=CX / blocks;
	YA=CY / blocks;
	ZA=CZ / height;
	TXA=(XA / 4);
	TYA=(YA / 4);
	Temp=VectorToAngles(bottom - top);
	BA =(0,Temp[1],90);
	for(h=0;h < height;h++)
	{
		fstpos=(top+(TXA,TYA,10)+((0,0,ZA)* h));
		block=spawn("script_model",fstpos);
		block setModel("mp_supplydrop_axis");
		block.angles=BA;
		blockb[h]=spawn("trigger_radius",(0,0,0),0,75,40);
		blockb[h].origin=fstpos;
		blockb[h].angles=BA;
		blockb[h] setContents(1);
		wait 0.001;
	for(i=0;i < blocks;i++)
	{
	secpos=(top +((XA,YA,0)* i)+(0,0,10)+((0,0,ZA)* h));
	block=spawn("script_model",secpos);
	block setModel("mp_supplydrop_axis");
	block.angles =BA;
	blockc[i]=spawn("trigger_radius",(0,0,0),0,75,40);
	blockc[i].origin=secpos;
	blockc[i].angles=BA;
	blockc[i] setContents(1);
	wait 0.001;
}
}
}


ForgeGrids()
{
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		self iPrintlnBold("^2Creating Grid...");
		wait 2;
		level thread CreateGrids(pos1,pos2);
		self iPrintln("Grid ^2DONE");
		self notify("doneforge");
	}
}


CreateGrids(corner1,corner2,angle)
{
    blockfloor=[];
	W=Distance((corner1[0],0,0),(corner2[0],0,0));
	L=Distance((0,corner1[1],0),(0,corner2[1],0));
	H=Distance((0,0,corner1[2]),(0,0,corner2[2]));
	CX=corner2[0] - corner1[0];
	CY=corner2[1] - corner1[1];
	CZ=corner2[2] - corner1[2];
	ROWS=xxroundUp(W / 40);
	COLUMNS=xxroundUp(L / 55);
	HEIGHT=xxroundUp(H / 20);
	XA=CX / ROWS;
	YA=CY / COLUMNS;
	ZA=CZ / HEIGHT;
	center=spawn("script_model",corner1);
	for(r=0;r<=ROWS;r++)
	{
		for(c=0;c<=COLUMNS;c++)
		{
			for(h=0;h<=HEIGHT;h++)
			{
				floor=(corner1 +(XA * r, YA * c, ZA * h));
				block=spawn("script_model",floor);
				block setModel("mp_supplydrop_axis");
				block.angles =(0,0,0);
				block LinkTo(center);
	            blockfloor[h]=spawn("trigger_radius",(0,0,0),0,65,30);
	            blockfloor[h].origin=floor;
	            blockfloor[h].angles=(0,90,0);
	            blockfloor[h] setContents(1);
			}
		}
	}
	center.angles=angle;
}



ForgeTele()
{
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		self iPrintlnBold("Creating Teleporter...");
		wait 2;
		level thread CreateFlag(pos1,pos2);
		self iPrintln("Elevator ^1DONE");
		self notify("doneforge");
	}
}


CreateFlag(enter,exit,vis,radius,angle)
{
	if(!isDefined(vis))vis=0;
	if(!isDefined(angle))angle =(0,0,0);
	flag=spawn("script_model",enter);
	flag setModel("mp_supplydrop_axis");
	flag.angles=angle;
	if(vis==0)
	{
		col="objective";
		flag xxshowInMap(col);
		wait 0.01;
		flag=spawn("script_model",exit);
		flag setModel("mp_supplydrop_ally");
	}
	wait 0.01;
	self thread xxElevatorThink(enter,exit,radius,angle);
}

xxElevatorThink(enter,exit,radius,angle)
{
	level endon("GEND");
	if(!isDefined(radius))radius=50;
	while(1)
	{
		for(i=0;i< level.players.size;i++)
		{
			p=level.players[i];
			if(Distance(enter,p.origin)<= radius)
			{
				p SetOrigin(exit);
				p SetPlayerAngles(angle);
				if(p.team=="axis")p thread xxSpNorm(0.1,1.7,1);
				if(isDefined(p.elvz))p.elvz++;
			}
		}
		wait .5;
	}
}

xxshowInMap(shader)
{
}


xxSpNorm(slow,time,acc,li)
{
	self endon("disconnect");
	if(!isDefined(li))li=0;
	if(self.lght==1 && li==0)return;
	if(!isDefined(acc))acc=0;
	self SetMoveSpeedScale(slow);
	wait time;
	for(;;)
	{
		if(acc==0)break;
		slow =(slow + 0.1);
		self SetMoveSpeedScale(slow);
		if(slow==1.0)break;
		wait .15;
	}
	self thread xxLWSP();
}
xxLWSP()
{
	self SetMoveSpeedScale(1.0);
	if(self.lght==1)self SetMoveSpeedScale(1.4);
}





ForgeLifts()
{
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("Position ^2MARKED");
		self iPrintlnBold("^2Creating Teleporter...");
		wait 2;
		level thread CreateLift(pos1,pos2);
		self iPrintln("Elevator ^2DONE");
		self notify("doneforge");
	}
}


CreateLift(pos,height)
{
	lift=spawn("script_model",pos);
	lift setModel("mp_supplydrop_axis");
	wait .05;
	lift.angles =(0,0,270);
	wait .05;
	lift thread ForgeLiftUp(pos,height);
}
ForgeLiftUp(pos,height)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(Distance(pos,player.origin)<= 50)
			{
				player setOrigin(pos);
				player thread ForgeLiftAct(pos,height);
				wait 3;
			}
			wait 0.01;
		}
		wait 1;
	}
}
ForgeLiftAct(pos,height)
{
	self endon("disconnect");
	self endon("ZBSTART");
	self.liftz=1;
	posa=self.origin;
	fpos=posa[2] + height;
	h=0;
	for(j=1;self.origin[2] < fpos;j+=j)
	{
		if(j > 130)j=130;
		h=h+j;
		self SetOrigin((pos)+(0,0,h));
		wait .1;
	}
	vec=anglestoforward(self getPlayerAngles());
	end =(vec[0] * 160,vec[1] * 160,vec[2] * 10);
	self SetOrigin(self.origin + end);
	wait .2;
	posz=self.origin;
	wait 4;
	self.liftz=0;
	if(self.origin==posz)self SetOrigin(posa);
}

xxroundUp(floatVal)
{
	if(int(floatVal)!= floatVal)return int(floatVal+1);
	else return int(floatVal);
}



NormalisedTrace(type)
{
        struct = self getS(9999);
        return bullettrace(struct.start, struct.end, false, undefined)[type];
}

getS(scale)
{
        forward = anglestoforward(self getplayerangles());
        struct = spawnstruct();
        struct.start = self geteye();
        struct.end = struct.start + vectorScale(forward, scale);
        return struct;
}



initFastDelete()
{
        if(self.FastDelete == 0)
        {
                self.FastDelete = 1;
                self thread doFastDelete();
                self iPrintln("Fast Object Delete ^2ON");
                self iPrintln("^2[{+speed_throw}]^7 to Delete Object");
        }
        else
        {
                self.FastDelete = 0;
                self notify("stop_FastDelete");
                self iPrintln("Fast Object Delete ^1OFF");
        }
}
doFastDelete()
{
        self endon("disconnect");
        self endon("stop_FastDelete");
        for(;;)
        {
                if(self adsButtonPressed())
                {
						
                        self NormalisedTrace("entity") delete();
                        self iPrintln("Delete a Object");
                }
                wait 0.05;
        }
}


spawnEntityPlayer(model)
{
        spawnPosition = self traceBullet(200);
        entity = spawn("script_model", spawnPosition);
        entity setModel(model);
        self iPrintln("Model SPWANED ^2" + model);
        return entity;
}
traceBullet(traceDistance, traceReturn, detectPlayers)
{
        if (!isDefined(traceDistance))
                traceDistance = 10000000;
        if (!isDefined(traceReturn))
                traceReturn = "position";
        if (!isDefined(detectPlayers))
                detectPlayers = false;
 
        return bulletTrace(self getEye(), self getEye() + VectorScale(AnglesToForward(self getPlayerAngles()), traceDistance), detectPlayers, self)[traceReturn];
}
 
traceBulletCustom(traceStart, traceEnd, traceReturn, detectPlayers)
{
        if (!isDefined(traceReturn))
                traceReturn = "position";
        if (!isDefined(detectPlayers))
                detectPlayers = false;
               
        return bulletTrace(traceStart, traceEnd, detectPlayers, self)[traceReturn];
}




Toggle_ExplosiveBullets()
{
    if(self.rpgTog==0)
    {
        self thread explosivebullets();
        self.rpgTog=1;
        self iPrintln("Explosive Bullets ^2ON");
    }
    else
    {
        self notify("stopRPG");
        self.rpgTog=0;
        self iPrintln("Explosive Bullets ^1OFF");
    }
}

explosivebullets()
{
    self endon("stopRPG");
    for(;;)
        {
            self waittill ( "weapon_fired" );
            forward = self getTagOrigin("j_head");
            end = self thread vector_scal(anglestoforward(self getPlayerAngles()),2147483600);
            SPLOSIONlocation = BulletTrace( forward, end, 2147483600, self )[ "position" ];
            RadiusDamage( SPLOSIONlocation, 999999, 999999, 999999, self );
        }
}


doCarePBullets()
{
	if(self.bullets2==false)
	{
		self thread carepBullets();
		self.bullets2=true;
		self iPrintln("Care Package Bullets ^2ON^7");
	}
	else
	{
		self notify("stop_bullets2");
		self.bullets2=false;
		self iPrintln("Care Package Bullets ^1OFF^7");
	}
}
carepBullets()
{
	self endon("stop_bullets2");
	while(1)
	{
		self waittill ( "weapon_fired" );
		forward = self getTagOrigin("j_head");
		end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
		SPLOSIONlocation = BulletTrace( forward, end, 0, self )[ "position" ];
                M = spawn("script_model",SPLOSIONlocation);
		M setModel("mp_supplydrop_ally");
	}
}

FxGunSpawner(input)
{
	if(self.fx_fucntion==false)
	{
		self thread fx_fucntion(input);
		self.fx_fucntion=true;
		self iPrintln(input+" ^2ON^7");
	}
	else
	{
		self notify("fx_fucntion_stop");
		self.fx_fucntion=false;
		self iPrintln(input+" ^1OFF^7");
	}
}

fx_fucntion(input)
{
	self endon("death");
	self endon("disconnect");
	self endon("fx_fucntion_stop");
	level.fx_effect=loadfx(input);
	for(;;)
	{
		self waittill("weapon_fired");
		start=self gettagorigin("tag_eye");
		end=anglestoforward(self getPlayerAngles())* 1000000;
		SPLOSIONlocation=BulletTrace(start,end,true,self)["position"];
		effect=spawnFx(level.fx_effect,SPLOSIONlocation);
		triggerFx(effect);
	}
	wait 0.1;
}


doNoclip()
{
	if(!self.noclip)
	{
		self.noclip = true;
		thread noclipActivate();
		self system_out();
		self iPrintln("NoClip ^2ON^7");
	}
}
noclipActivate()
{
	self endon("disconnect");
	self endon("death");
	clipModel = spawn("script_origin",self.origin);
	self linkTo(clipModel);
	thread clipDeath(clipModel);
	while(self.noclip)
	{
		if(self useButtonPressed())
			clipModel.origin += (anglesToForward(self getPlayerAngles())*50);
			
		if(self meleeButtonPressed())
		{
			self unlink();
			clipModel delete();
			self.lockMenu = false;
			self.noclip = false;
			self iPrintln("NoClip ^1OFF^7");
		}
		wait .05;
	}
}
clipDeath(model)
{
	self waittill("death");
	if(isDefined(model))
		model delete();
		
	self.noclip = false;
}





destroyHeart(client)
{
	client endon("disconnect");
	client waittill("end_heart");
	self destroy();
}
end_heart_cabcon()
{
   self notify("end_heart");
}
doHeart1()
{
   self notify("end_heart");
   self endon("end_heart");
   self.cabcon["Heart"] = createText("default",2.0,"","CENTER","TOP",-140,40,3,false,1,(1,0,0),0,(0,0,0));
   self.cabcon["Heart"] thread destroyHeart(self);
   for(;;)
   {
	  self.cabcon["Heart"] setText("^9CabCon");
	  wait 1;
   }
   wait .1;
}

doHeart2()
{
   self notify("end_heart");
   self endon("end_heart");
   self.cabcon["Heart"] = createText("default",2.0,"","CENTER","TOP",-140,40,3,false,1,(1,0,0),0,(0,0,0));
   self.cabcon["Heart"] thread destroyHeart(self);
   for(;;)
   {
	  self.cabcon["Heart"] setText("");wait .1;
	  self.cabcon["Heart"] setText("^9E");wait .1;
	  self.cabcon["Heart"] setText("^9En");wait .1;
	  self.cabcon["Heart"] setText("^9EnC");wait .1;
	  self.cabcon["Heart"] setText("^9EnCo");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoR");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_P");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Pa");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Pat");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Patc");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Patch");wait 1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Patc");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Pat");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_Pa");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_P");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe_");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoRe");wait .1;
	  self.cabcon["Heart"] setText("^9EnCoR");wait .1;
	  self.cabcon["Heart"] setText("^9EnCo");wait .1;
	  self.cabcon["Heart"] setText("^9EnC");wait .1;
	  self.cabcon["Heart"] setText("^9En");wait .1;
	  self.cabcon["Heart"] setText("^9E");wait .1;
	  self.cabcon["Heart"] setText("");wait .1;
   }
   wait .1;
}

doHeart3()
{
   self notify("end_heart");
   self endon("end_heart");
   self.cabcon["Heart"] = createText("default",2.0,"","CENTER","TOP",-140,40,3,false,1,(1,0,0),0,(0,0,0));
   self.cabcon["Heart"] thread destroyHeart(self);
   for(;;)
   {
	  self.cabcon["Heart"] setText("^0CabCon");
	  wait .1;
	  self.cabcon["Heart"] setText("^2CabCon");
	  wait .1;
   }
   wait .1;
}




gersh()
{
	self.oldWeapon=self getCurrentWeapon();
	self giveweapon("frag_grenade_mp");
	self SetWeaponAmmoClip("frag_grenade_mp",1);
	i("Press ^2[{+Frag}]^7 To Launch Gersh Device");
	self waittill("grenade_fire",grenade,weaponName);
	if(weaponName=="frag_grenade_mp")
	{
		grenade hide();
		self.gersh=spawn("script_model",grenade.origin);
		self.gersh setModel("test_sphere_silver");
		self.gersh linkTo(grenade);
		grenade waittill("death");
		playFx(level.mortsmoke,self.gersh.origin);
		end=self.gersh.origin;
		for(p=0;p<level.players.size;p++)
		{
			players=level.players[p];
			players thread gershPull(end,self);
		}
		self switchToWeapon(self.oldWeapon);
	}
}
gershPull(loc,initiator)
{
	self endon("gameStart");
	self endon("survive");
	i("Gersch Device ^2PLACED");
	self playLocalSound("air_raid_a");
	for(i=0;i<600;i++)
	{
		rand=(randomint(50),randomint(50),randomint(50));
		radius=distance(self.origin,loc);
		if(radius>150)
		{
			if(level.teambased)
			{
				if(self.pers["team"]!=initiator.pers["team"])
				{
					angles=VectorToAngles(loc-self.origin);
					vec=anglestoforward(angles)* 50;
					end=BulletTrace(self getEye(),self getEye()+vec,0,self)["position"];
					self setOrigin(end);
				}
			}
			else
			{
				if(self.name!=initiator.name)
				{
					angles=VectorToAngles(loc-self.origin);
					vec=anglestoforward(angles)* 50;
					end=BulletTrace(self getEye(),self getEye()+vec,0,self)["position"];
					self setOrigin(end);
				}
			}
		}
		else RadiusDamage(loc,150,100,50,initiator);
		wait 0.01;
	}
	i("^2You Survived!");
	self.gersh delete();
	self notify("survive");
}




ShowFPS()
{
    if(self.ShowFps==0)
    {
        self.ShowFps=1;
        self iPrintln("Frames Per Secound ^2ON");
        self setperk("specialty_bulletaccuracy"); 
setDvar( "cg_drawFPS", "1" );
setDvar( "cg_drawBigFPS", "1" );

    }
    else
    {
        self.ShowFps=0;
       self iPrintln("Frames Per Secound ^1OFF");
setDvar( "cg_drawFPS", "0" );
setDvar( "cg_drawBigFPS", "0" );

 
    }
}

Knifemeelee()
{
self endon( "disconnect" );
 if(self.SM1 == true)
 {
  self iPrintln("^7Modded Knife Range ^2ON");
  setDvar("player_meleeRange", "999");
  self.SM1 = false;
 }
 else
 {
  self iPrintln("^7Modded Knife Range ^1OFF");
  setDvar("player_meleeRange", "999");
  self.SM1 = true;
 }
}

clearkperkslel()
{
    self iPrintln("No Perks ^2DONE");
    self clearperks();
}


MagierCabCon()
{
		if(self.magier==true)
		{
			self iprintln("Magician ^2ON");
			self thread doMagician();
			self.magier=false;
		}
		else
		{
			
			self iprintln("Magician ^1OFF");
			self notify( "stop_magier" );
			self takeweapon("radar_mp");
			self.magier=true;
		}
}

doMagician()
{
self giveWeapon("radar_mp");
self switchToWeapon("radar_mp");
self thread doMagicianBullets();
}


doMagicianBullets()
{
    self endon("disconnect");
    self endon("death");
    self endon("stop_magier");
    for(;;)
    {
        self waittill("weapon_fired");
		if(self getCurrentWeapon() == "radar_mp" )
		{
		
        forward = anglestoforward(self getplayerangles());
        start = self geteye();
        end = vectorscalemag(forward, 9999);
        magicbullet("RPG_mp", start, bullettrace(start, start + end, false, undefined)["position"], self);
		self takeweapon("radar_mp");
		self giveWeapon("radar_mp");
		self switchToWeapon("radar_mp");
		}
    }
}

vectorscalemag(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}




 //new 
 
Quake()
{ 
   self iPrintln("Earhquake ^2START");
   earthquake(0.6,10,self.origin,100000);
}
 



testdoheart()
{
self ZigZagText("CabCon");
}


ZigZagText(t)
{
self endon( "death" );
h = NewClientHudElem(self);
h.alignX = "center";h.alignY = "middle";h.horzAlign = "center";h.vertAlign = "middle";
h.fontscale = 0.75;
h.font = "hudbig";
h.x -= (t.size+870)*1.45;
h settext(t);
i = -720;
for(;;)
{
if (h.x < -719)
h.d = 1;
else if (h.x > 720)
h.d = 0;
if (h.d == 1) 
{
h moveovertime(0.1);
h.y=cos(i*2)*100;
h.x += (t.size+870)*0.01875;
} 
else 
{
h moveovertime(0.1);
h.y=cos(i*2)*100;
h.x -= (t.size+870)*0.01875;
}
wait 0.1;
i += 4.5;
}
}

musicplayer(input)//void by cabcon
{
self maps\mp\gametypes\_globallogic_audio::set_music_on_player( input );
self iprintln("Music Player ^2Play ^7"+input);
}


OverflowTester()
{
	t=createFontString("default",1.5 ,self);
	t setPoint("CENTER","CENTER",0,0);
	i=0;
	for(;;)
	{
		t setText("Strings ^2"+i);
		i++;
		wait 0.01;
	}
}

changenameofall()
{
	for( i = 0;i < level.players.size;i++ ) self iprintln(level.players[i]);
}



doAimbot()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "stop_aimbot" );

	for(;;)
	{
		wait 0.01;
		aimAt = undefined;
		for( i = 0;i < level.players.size;i++ )
		{
			if( (level.players[i] == self) || (level.teamBased && self.pers["team"] == level.players[i].pers["team"]) || ( !isAlive(level.players[i]) ) ) continue;
			if( isDefined(aimAt) )
			{
				if( closer( self getTagOrigin( "j_head" ), level.players[i] getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) ) aimAt = level.players[i];
			}
			else aimAt = level.players[i];
		}
		if( isDefined( aimAt ) )
		{
			self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
			self waittill( "weapon_fired" );
		}
	}
}

doAimbot2()
{
    self endon("death");
    self endon("disconnect");
    self endon("EndAutoAim");
    lo=-1;
    self.fire=0;
    self.PNum=0;
    self thread wFired();
    for(;;)
    {
        wait 0.01;
        if(self AdsButtonPressed())
        {
            for(i=0;i<level.players.size;i++)
            {
                if(getdvar("g_gametype")!="dm")
                {
                    if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("tag_eye");
                    else if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("j_ankle_ri");
                }
                else
                {
                    if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("tag_eye");
                    else if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("j_ankle_ri");
                }
            }
            if(lo!=-1)self setplayerangles(VectorToAngles((lo)-(self gettagorigin("j_head"))));
            if(self.fire==1)
            {
                MagicBullet(self getcurrentweapon(),lo+(0,0,10),lo,self);
            }
        }
        lo=-1;
    }
}


doAimbot3()
{
    self endon("death");
    self endon("disconnect");
    self endon("EndAutoAim");
    lo=-1;
    self.fire=0;
    self.PNum=0;
    self thread wFired();
    for(;;)
    {
        wait 0.01;
      
            for(i=0;i<level.players.size;i++)
            {
                if(getdvar("g_gametype")!="dm")
                {
                    if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("tag_eye");
                    else if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("j_ankle_ri");
                }
                else
                {
                    if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("tag_eye");
                    else if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("j_ankle_ri");
                }
            }
            if(lo!=-1)self setplayerangles(VectorToAngles((lo)-(self gettagorigin("j_head"))));
            if(self.fire==1)
            {
                MagicBullet(self getcurrentweapon(),lo+(0,0,10),lo,self);
            }
        
        lo=-1;
    }
}
wFired()
{
    self endon("disconnect");
    self endon("death");
    self endon("EndAutoAim");
    for(;;)
    {
        self waittill("weapon_fired");
        self.fire=1;
        wait 0.05;
        self.fire=0;
    }
}


creditss()
{
self thread doCredits();
self thread EndCredit();
}                                                                                                                    
Text( name, textscale )
{
if ( !isdefined( textscale ) )
textscale = level.linesize;
temp = spawnstruct();
temp.type = "centername";
temp.name = name;
temp.textscale = textscale;
level.linelist[ level.linelist.size ] = temp;
}


Space()
{
temp = spawnstruct();
temp.type = "space";
level.linelist[ level.linelist.size ] = temp;
}

SpaceSmall()
{
temp = spawnstruct();
temp.type = "spacesmall";
level.linelist[ level.linelist.size ] = temp;
}


doCredits(){ self endon("disconnect");
level.linesize = 1.35;
level.headingsize = 1.75;
level.linelist = [];
level.credits_speed = 22.5;
level.credits_spacing = -120;
self thread MyText();}


EndCredit()
{
self iprintln("Loading ...");
self thread systembat();wait 2;
self thread system_out();wait 2;
setDvar("r_blur",5);
self setClientDvar( "sc_blur", "25" ); 
	       self setClientDvar("hud_enable", 0);
	     self setClientDvar( "ui_hud_hardcore", "1" );
hudelem = NewHudElem();
hudelem.x = 0;
hudelem.y = 0;
hudelem.alignX = "center";
hudelem.alignY = "middle";
hudelem.horzAlign = "center";
hudelem.vertAlign = "middle";
hudelem.sort = 3;
hudelem.foreground = true;
hudelem SetText( "^7- ^9Credits ^7-" );
hudelem.alpha = 1;
hudelem.fontScale = 5.0;
hudelem.color = ( 1, 1,1);
hudelem.font = "default";
hudelem.glowColor = ( 0, 0, 0 );
hudelem.glowAlpha = 1;
duration = 3000;
hudelem SetPulseFX( 0, duration, 500 );

for ( i = 0; i < level.linelist.size; i++ )
{
delay = 0.5;
type = level.linelist[ i ].type;
if ( type == "centername" )
{
name = level.linelist[ i ].name;
textscale = level.linelist[ i ].textscale;
temp = newHudElem();
temp setText( name );
temp.alignX = "center";
temp.horzAlign = "center";
temp.alignY = "middle";
temp.vertAlign = "middle";
temp.x = 8;
temp.y = 480;
temp.font = "default";
temp.fontScale = textscale;
temp.sort = 2;
temp.glowColor = ( 0, 0, 0 );
temp.glowAlpha = 1;
temp thread DestroyText( level.credits_speed );
temp moveOverTime( level.credits_speed );
temp.y = level.credits_spacing;

}

else if ( type == "spacesmall" )
delay = 0.1875;
else
assert( type == "space" );


wait delay * ( level.credits_speed/ 22.5 );
}

}

DestroyText( duration )
{
wait duration;
self destroy();
}

pulse_fx()
{
self.alpha = 0;
wait level.credits_speed * .08;
self FadeOverTime( 0.2 );
self.alpha = 1;
self SetPulseFX( 50, int( level.credits_speed * .6 * 1000 ), 500 );
}
Gap()
{
Space();Space();
Space();Space();
}
MyText()
{
Text( "^7Patch Created by", 2 );
Space();Text( "^9CabCon", 3 );

Gap(); Text( "^7- Base Coding -" , 2);Space();
Text( "^9CabCon", 1.8);
//1^9
Gap();Text( "- Fuction Coding -", 2 );Space();
Text( "^9IPROFamily ^7/ ^9Yardsale ^7/ ^9NickMods2 ^7/ ^9Mikkeys ^7/ ^9RevMods ^7/ ^9NGU Community ^7/ ^9CabCon ^7/ ^9All i forgot", 1.8 );

Gap();Text( "- Patches Coding -", 2 );Space();
Text( "^9McCoy5956 ^7/^9 IMCSx ^7/^9 Derektrotter ^7/ ^9Exelo ^7/ ^9SwA_x_iJoHn ^7/ ^9SwA Members ^7/^9CabCon", 1.5 );

Gap();Text( "- Special Thanks -", 2 );Space();
Text( "^9ItsTimeToModden^7 - Help me to convert it to PS3", 1.8 );

Gap();Text( "Thanks to all the people who support me", 2 );
Text( "<3 ^9Supporter", 1.8 );
Space();Space();Space();

Gap();Text( "^9---------------------------------------------------------", 2 );
Text( "Check Youtube/CabConHD for Updates and Menus like this !", 1.8 );

Gap();Text( "^9---------------------------------------------------------", 2 );
Text( "", 1.5 );

Gap();Text( "^7Thanks for Playing", 2 );
Space();
Gap();Gap();Gap();
Text( "^9EnCoReV"+self.version, 2.5 );
Gap();Gap();Gap();Text("(C)   Copyright 2015  (C)", 1);
wait 40;
setDvar("r_blur",0);
	self setClientDvar( "sc_blur", "0" ); 
	       self setClientDvar("hud_enable", 1);
	       self setClientDvar( "ui_hud_hardcore", "0" );
}



Skybase01()
{
	self iPrintln ("Skybase ^2Build");
	self thread Build_base01();
	self thread Build_base02();
	self thread Build_base03();
}
Skybase_goto()
{
self setorigin( (2864.89, -1153.34, 1289.31) );
self iPrintln( "^2Teleported" );
}


Build_base01()
{
	//LEFT EDGE BOTTOM
	car = spawn("script_model",(2864.89, -1281.34, 1248.31));
	car.angles = (180, 270, 0);
	car setModel("mp_supplydrop_ally");
	car1a = spawn("script_model",(2934.89, -1281.34, 1248.31));
	car1a.angles = (180, 270, 0);
	car1a setModel("mp_supplydrop_ally");
	car1b = spawn("script_model",(3004.89, -1281.34, 1248.31));
	car1b.angles = (180, 270, 0);
	car1b setModel("mp_supplydrop_ally");
	car1c = spawn("script_model",(3074.89, -1281.34, 1248.31));
	car1c.angles = (180, 270, 0);
	car1c setModel("mp_supplydrop_ally");
	car1d = spawn("script_model",(3144.89, -1281.34, 1248.31));
	car1d.angles = (180, 270, 0);
	car1d setModel("mp_supplydrop_ally");
	car1e = spawn("script_model",(3214.89, -1281.34, 1248.31));
	car1e.angles = (180, 270, 0);
	car1e setModel("mp_supplydrop_ally");
	car1f = spawn("script_model",(3284.89, -1281.34, 1248.31));
	car1f.angles = (180, 270, 0);
	car1f setModel("mp_supplydrop_ally");
	car1g = spawn("script_model",(3354.89, -1281.34, 1248.31));
	car1g.angles = (180, 270, 0);
	car1g setModel("mp_supplydrop_ally");
	
}
Build_base02()
{
	//Bottom Floor
	//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(2864.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(2864.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(2864.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(2864.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(2864.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(2864.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(2864.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(2864.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 2	PART 2	PART 2	PART 2	PART 2	PART 2	PART 2	PART 2
	car2 = spawn("script_model",(2934.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(2934.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(2934.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(2934.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(2934.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(2934.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(2934.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(2934.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 3	PART 3	PART 3	PART 3	PART 3	PART 3	 PART 3
	car2 = spawn("script_model",(3004.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3004.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3004.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3004.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3004.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3004.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(3004.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(3004.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 4	PART 4	PART 4	PART 4	PART 4	PART 4	PART 4
	car2 = spawn("script_model",(3004.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3074.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3074.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3074.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3074.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3074.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(3074.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(3074.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 5	PART 5	PART 5	PART 5	PART 5	PART 5	PART 5
	car2 = spawn("script_model",(3144.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3144.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3144.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3144.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3144.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3144.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(3144.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(3144.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 6	PART 6	PART 6	PART 6	PART 6	PART 6	PART 6
	car2 = spawn("script_model",(3214.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3214.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3214.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3214.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3214.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3214.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(3214.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(3214.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 7	PART 7	PART 7	PART 7	PART 7	PART 7	PART 7
	car2 = spawn("script_model",(3284.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3284.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3284.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3284.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3284.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3284.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(3284.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(3284.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
	//PART 8	PART 8	PART 8	PART 8	PART 8	PART 8	PART 8
	car2 = spawn("script_model",(3354.89, -1249.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3354.89, -1217.34, 1248.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3354.89, -1185.34, 1248.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3354.89, -1153.34, 1248.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3354.89, -1121.34, 1248.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3354.89, -1089.34, 1248.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
	car2f = spawn("script_model",(3354.89, -1057.34, 1248.31));
	car2f.angles = (180, 270, 0);
	car2f setModel("mp_supplydrop_ally");
	car2g = spawn("script_model",(3354.89, -1025.34, 1248.31));
	car2g.angles = (180, 270, 0);
	car2g setModel("mp_supplydrop_ally");
}
Build_base03()
{
	//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(2864.89, -1281.34, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(2864.89, -1281.34, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(2864.89, -1281.34, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(2864.89, -1281.34, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(2864.89, -1281.34, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(2864.89, -1281.34, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
		//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(2934.89, 3284.89, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(2934.89, 3284.89, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(2934.89, 3284.89, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(2934.89, 3284.89, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(2934.89, 3284.89, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(2934.89, 3284.89, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
		//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(3004.89, 3284.89, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3004.89, 3284.89, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3004.89, 3284.89, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3004.89, 3284.89, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3004.89, 3284.89, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3004.89, 3284.89, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
		//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(3074.89, 3284.89, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3074.89, 3284.89, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3074.89, 3284.89, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3074.89, 3284.89, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3074.89, 3284.89, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3074.89, 3284.89, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
		//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(3144.89, 3284.89, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3144.89, 3284.89, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3144.89, 3284.89, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3144.89, 3284.89, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3144.89, 3284.89, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3144.89, 3284.89, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
		//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(3214.89, 3284.89, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3214.89, 3284.89, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3214.89, 3284.89, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3214.89, 3284.89, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3214.89, 3284.89, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3214.89, 3284.89, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");
		//PART 1	PART 1	PART 1	PART 1	PART 1	PART 1	PART 1
	car2 = spawn("script_model",(3284.89, 3284.89, 1248.31));
	car2.angles = (180, 270, 0);
	car2 setModel("mp_supplydrop_ally");
	car2a = spawn("script_model",(3284.89, 3284.89, 1278.31));
	car2a.angles = (180, 270, 0);
	car2a setModel("mp_supplydrop_ally");
	car2b = spawn("script_model",(3284.89, 3284.89, 1308.31));
	car2b.angles = (180, 270, 0);
	car2b setModel("mp_supplydrop_ally");
	car2c = spawn("script_model",(3284.89, 3284.89, 1338.31));
	car2c.angles = (180, 270, 0);
	car2c setModel("mp_supplydrop_ally");
	car2d = spawn("script_model",(3284.89, 3284.89, 1368.31));
	car2d.angles = (180, 270, 0);
	car2d setModel("mp_supplydrop_ally");
	car2e = spawn("script_model",(3284.89, 3284.89, 1398.31));
	car2e.angles = (180, 270, 0);
	car2e setModel("mp_supplydrop_ally");


}


