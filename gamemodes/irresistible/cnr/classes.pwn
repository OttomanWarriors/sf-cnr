/*
 * Irresistible Gaming (c) 2018
 * Developed by Lorenc Pekaj
 * Module: cnr\classes.pwn
 * Purpose: the classes of the cops and robbers server
 */

/* ** Includes ** */
#include 							< YSI\y_hooks >

/* ** Functions ** */
#define GetPlayerClass(%0)			(p_Class[%0])

/* ** Definitions ** */
#define CLASS_CIVILIAN              ( 0 )
#define CLASS_POLICE              	( 1 )
#define CLASS_FIREMAN               ( 2 )
#define CLASS_MEDIC              	( 3 )

#define MAX_CLASS_BAN_WARNS			( 3 )

/* ** Constants ** */
static const
	Float: default_X 				= -2242.152,
	Float: default_Y 				= 759.0619,
	Float: default_Z 				= 30.0,
	Float: default_Angle 			= 0.0
;

static const CLASS_NAMES 			[ ] [ ] = { "Civilian", "Police", "FBI", "Army", "CIA", "Paramedic", "Fireman" };
static const CLASS_COLORS 			[ ] = { 0xC0C0C0FF, 0x3E7EFFFF, 0x0035FFFF, 0x954BFFFF, 0x191970FF, 0x4DFF4DFF, 0xA83434FF };

/* ** Variables ** */
static stock
	CLASS_CIVILIAN_RANGE			[ 2 ],
	CLASS_POLICE_RANGE				[ 2 ],
	CLASS_FBI_RANGE					[ 2 ],
	CLASS_CIA_RANGE 				[ 2 ],
	CLASS_FIRE_RANGE 				[ 2 ],
	CLASS_MEDIC_RANGE 				[ 2 ],
	CLASS_ARMY_RANGE
;

/* ** Textdraw Variables ** */
static stock
	Text: g_classBoxTD				= Text: INVALID_TEXT_DRAW,
	Text: g_classTextdrawBox		[ sizeof( CLASS_NAMES ) ] = { Text: INVALID_TEXT_DRAW, ... },
	Text: g_classTextdrawDescrip	[ sizeof( CLASS_NAMES ) ] = { Text: INVALID_TEXT_DRAW, ... },
	Text: g_classTextdrawName		[ sizeof( CLASS_NAMES ) ] = { Text: INVALID_TEXT_DRAW, ... }
;

/* ** Player Variables ** */
new p_Class 						[ MAX_PLAYERS ];

/* ** Hooks ** */
hook OnScriptInit( )
{
	/* ** CIVILIAN ** */
	CLASS_CIVILIAN_RANGE[ 0 ] = AddPlayerClass( 119, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 0
	AddPlayerClass( 289, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 1
	AddPlayerClass( 273, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 2
	AddPlayerClass( 271, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 3
	AddPlayerClass( 208, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 4
	AddPlayerClass( 268, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 5
	AddPlayerClass( 292, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 6
	AddPlayerClass( 293, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 7
	AddPlayerClass(  3, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	8
	AddPlayerClass(  4, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	9
	AddPlayerClass(  2, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  10
	AddPlayerClass(  7, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  11
	AddPlayerClass( 12, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  12
	AddPlayerClass( 13, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  13
	AddPlayerClass( 14, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  14
	AddPlayerClass( 15, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  15
	AddPlayerClass( 17, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  16
	AddPlayerClass( 19, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  17
	AddPlayerClass( 20, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  18
	AddPlayerClass( 21, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //  19
	AddPlayerClass( 22, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	20
	AddPlayerClass( 23, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	21
	AddPlayerClass( 24, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	22
	AddPlayerClass( 26, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	23
	AddPlayerClass( 28, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	24
	AddPlayerClass( 29, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	25
	AddPlayerClass( 30, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	26
	AddPlayerClass( 31, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	27
	AddPlayerClass( 32, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	28
	AddPlayerClass( 33, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	29
	AddPlayerClass( 34, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	30
	AddPlayerClass( 35, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	31
	AddPlayerClass( 36, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	32
	AddPlayerClass( 37, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	33
	AddPlayerClass( 38, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	34
	AddPlayerClass( 46, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	35
	AddPlayerClass( 47, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	36
	AddPlayerClass( 48, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	37
	AddPlayerClass( 59, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	38
	AddPlayerClass( 60, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	39
	AddPlayerClass( 63, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	40
	AddPlayerClass( 64, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	41
	AddPlayerClass( 152, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	42
	AddPlayerClass( 237, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	43
	AddPlayerClass( 78, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); //	44
	AddPlayerClass( 79, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 	45
	AddPlayerClass( 134, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 46
	AddPlayerClass( 100, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 47
	AddPlayerClass( 101, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 48
	CLASS_CIVILIAN_RANGE[ 1 ] = AddPlayerClass( 137, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 49

	/* ** FBI ** */
	CLASS_FBI_RANGE[ 0 ] = AddPlayerClass( 286, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 50
	AddPlayerClass( 71, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 );  // 51
	CLASS_FBI_RANGE[ 1 ] = AddPlayerClass( 285, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 52

	/* ** ARMY ** */
	CLASS_ARMY_RANGE = AddPlayerClass( 287, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 53

	/* ** CIA ** */
	CLASS_CIA_RANGE[ 0 ] = AddPlayerClass( 303, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 54
	AddPlayerClass( 304, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 55
	CLASS_CIA_RANGE[ 1 ] = AddPlayerClass( 305, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 56

	/* ** FIRE ** */
	CLASS_FIRE_RANGE[ 0 ] = AddPlayerClass( 277, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 57
	AddPlayerClass( 278, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 58
	CLASS_FIRE_RANGE[ 1 ] = AddPlayerClass( 279, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 59

	/* ** MEDIC ** */
	CLASS_MEDIC_RANGE[ 0 ] = AddPlayerClass( 274, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 60
	AddPlayerClass( 275, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 61
	AddPlayerClass( 276, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 62
	CLASS_MEDIC_RANGE[ 1 ] = AddPlayerClass( 308, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 63

	/* ** POLICE ** */
	CLASS_POLICE_RANGE[ 0 ] = AddPlayerClass( 265, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 66
	AddPlayerClass( 266, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 67
	AddPlayerClass( 267, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 68
	AddPlayerClass( 306, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 69
	AddPlayerClass( 280, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 70
	AddPlayerClass( 281, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 71
	AddPlayerClass( 284, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 72
	CLASS_POLICE_RANGE[ 1 ] = AddPlayerClass( 307, default_X, default_Y, default_Z, default_Angle, 0, 0, 0, 0, 0, 0 ); // 73

	// Textdraws
	g_classBoxTD = TextDrawCreate(40.000000, 170.000000, "_");
	TextDrawBackgroundColor(g_classBoxTD, 255);
	TextDrawFont(g_classBoxTD, 1);
	TextDrawLetterSize(g_classBoxTD, 0.500000, 16.000000);
	TextDrawColor(g_classBoxTD, -1);
	TextDrawSetOutline(g_classBoxTD, 0);
	TextDrawSetProportional(g_classBoxTD, 1);
	TextDrawSetShadow(g_classBoxTD, 1);
	TextDrawUseBox(g_classBoxTD, 1);
	TextDrawBoxColor(g_classBoxTD, 144);
	TextDrawTextSize(g_classBoxTD, 170.000000, 10.000000);

	for ( new i = 0; i < sizeof( g_classTextdrawBox ); i ++ )
	{
		g_classTextdrawBox[ i ] = TextDrawCreate(40.000000, 138.000000, "_");
		TextDrawBackgroundColor(g_classTextdrawBox[ i ], 255);
		TextDrawFont(g_classTextdrawBox[ i ], 1);
		TextDrawLetterSize(g_classTextdrawBox[ i ], 0.500000, 3.000000);
		TextDrawColor(g_classTextdrawBox[ i ], -1);
		TextDrawSetOutline(g_classTextdrawBox[ i ], 0);
		TextDrawSetProportional(g_classTextdrawBox[ i ], 1);
		TextDrawSetShadow(g_classTextdrawBox[ i ], 1);
		TextDrawUseBox(g_classTextdrawBox[ i ], 1);
		TextDrawBoxColor(g_classTextdrawBox[ i ], CLASS_COLORS[ i ]);
		TextDrawTextSize(g_classTextdrawBox[ i ], 170.000000, 10.000000);

		szLargeString[ 0 ] = '\0';

		switch ( i )
		{
			case 0: {
				strcat( szLargeString,	"- Select different types of jobs~n~" \
										"- Able to rob stores and players~n~" \
										"- Can gang up with players~n~" \
										"~g~~h~- Accessible to everybody" );
			}
			case 1:	{
				strcat( szLargeString,	"- Protect the city from criminals~n~" \
										"- Access to police gun lockers~n~" \
										"- Can arrest/jail people~n~" \
										"~g~~h~- Accessible to everybody" );
			}
			case 2:	{
				strcat( szLargeString,	"- Protect the city from criminals~n~" \
										"- Access to police gun lockers~n~" \
										"- Can arrest/jail people~n~" \
										"- Can set roadblocks on roads~n~" \
										"- Can set spike traps on roads~n~" \
										"~r~~h~- Requires 10,000 XP or more" );
			}
			case 3: {
				strcat( szLargeString,	"- Protect the city from criminals~n~" \
										"- Access to police gun lockers~n~" \
										"- Can arrest/jail people~n~" \
										"- Can set roadblocks on roads~n~" \
										"- Can set spike traps on roads~n~" \
										"- Can use combat vehicles~n~" \
										"~r~~h~- Requires 20,000 XP or more" );
			}
			case 4: {
				strcat( szLargeString,	"- Protect the city from criminals~n~" \
										"- Access to police gun lockers~n~" \
										"- Can arrest/jail people~n~" \
										"- Can set roadblocks on roads~n~" \
										"- Can set spike traps on roads~n~" \
										"- Hidden from radar~n~" \
										"~r~~h~- Requires 15,000 XP or more" );
			}
			case 5: {
				strcat( szLargeString,	"- Can heal and cure players~n~" \
										"- Ambulance passengers pay you~n~"\
										"- Able to rob stores and players~n~" \
										"~r~~h~- Requires 1,000 XP or more" );
			}
			case 6: {
				strcat( szLargeString,	"- Protect the city from fires~n~" \
										"- Firetrucks able to extinguish fires~n~"\
										"- Able to rob stores and players~n~" \
										"~r~~h~- Requires 1,000 XP or more" );
			}
		}

		g_classTextdrawDescrip[ i ] = TextDrawCreate(43.000000, 171.000000, szLargeString);
		TextDrawBackgroundColor(g_classTextdrawDescrip[ i ], 0);
		TextDrawFont(g_classTextdrawDescrip[ i ], 1);
		TextDrawLetterSize(g_classTextdrawDescrip[ i ], 0.190000, 1.100000);
		TextDrawColor(g_classTextdrawDescrip[ i ], -1);
		TextDrawSetOutline(g_classTextdrawDescrip[ i ], 1);
		TextDrawSetProportional(g_classTextdrawDescrip[ i ], 1);

		g_classTextdrawName[ i ] = TextDrawCreate(46.000000, 141.000000, CLASS_NAMES[ i ] );
		TextDrawBackgroundColor(g_classTextdrawName[ i ], 0);
		TextDrawFont(g_classTextdrawName[ i ], 3);
		TextDrawLetterSize(g_classTextdrawName[ i ], 0.550000, 2.099999);
		TextDrawColor(g_classTextdrawName[ i ], i == 0 ? 0x000000FF : 0xFFFFFFFF );
		TextDrawSetOutline(g_classTextdrawName[ i ], 1);
		TextDrawSetProportional(g_classTextdrawName[ i ], 1);
		TextDrawSetSelectable(g_classTextdrawName[ i ], 0);
	}
	return 1;
}

hook OnPlayerSpawn( playerid )
{
	// prevent npcs from being treated like players
	if ( IsPlayerNPC( playerid ) ) {
		return Y_HOOKS_BREAK_RETURN_1; // add a callback otherwise OnNpcSpawn
	}

	// check if this spawn is even approved
	if ( ! IsPlayerClassApproved( playerid ) )
	{
		SendClientMessageToAdmins( -1, ""COL_PINK"[ABNORMAL SPAWN]"COL_GREY" %s(%d) - %d skin - %d ping - %s IP", ReturnPlayerName( playerid ), playerid, GetPlayerSkin( playerid ), GetPlayerPing( playerid ), ReturnPlayerIP( playerid ) );
	    return KickPlayerTimed( playerid ), 1;
	}
	return 1;
}

hook OnPlayerRequestClass( playerid, classid )
{
	// SetPlayerPos( playerid, 	-1971.1536, 129.4870, 27.6875 );
	// SetPlayerFacingAngle( playerid,	90.0 );
	SetPlayerPos( playerid, 229.613998, 87.164001, 1605.039978 );
	SetPlayerFacingAngle( playerid, -90.000000 );
	SetPlayerInterior( playerid, 0 );
	SetPlayerVirtualWorld( playerid, 0 );
	//SetPlayerCameraPos(		playerid, 	-1974.1431, 133.3700, 29.7107 );
	//SetPlayerCameraLookAt(	playerid, 	-1970.6431, 129.3700, 28.2107 );

	if ( p_ClassSelection{ playerid } == false )
	{
		static const Float: START_POS[ 3 ] = { 243.5, 87.23, 1605.9 };
		static const Float: FINAL_POS[ 3 ] = { 231.9, 87.23, 1605.9 };

		InterpolateCameraPos( playerid, START_POS[ 0 ], START_POS[ 1 ], START_POS[ 2 ], FINAL_POS[ 0 ], FINAL_POS[ 1 ], FINAL_POS[ 2 ], 17500, CAMERA_MOVE );
		InterpolateCameraLookAt( playerid, FINAL_POS[ 0 ], FINAL_POS[ 1 ], FINAL_POS[ 2 ], FINAL_POS[ 0 ] - 0.4, FINAL_POS[ 1 ], FINAL_POS[ 2 ] - 0.05, 15000, CAMERA_MOVE );

		// InterpolateCameraPos( playerid, -1976.4252, 119.9899, 30.0, -1974.0302, 133.0427, 27.6940, 10000, CAMERA_MOVE );
		// InterpolateCameraLookAt( playerid, -1974.0302,133.0427,27.6940, -1971.1536,129.4870,27.6875, 10000, CAMERA_MOVE );

		p_ClassSelection{ playerid } = true;
	}

	RemovePlayerAttachedObject( playerid, 1 );
	SetPlayerAttachedObject( playerid, 1, 19560, 6, 0.084999, 0.060998, -0.164999, 3.8, 81.6001, -19.3, .materialcolor1 = 0xFF000000 );
	Streamer_Update( playerid, STREAMER_TYPE_OBJECT );

	// ApplyAnimation( playerid, "MISC", "SEAT_TALK_02", 2.0, 1, 0, 0, 0, 0 );
	if ( GetPlayerSpecialAction( playerid ) != SPECIAL_ACTION_CARRY ) {
		TogglePlayerControllable( playerid, 0 );
		SetPlayerSpecialAction( playerid, SPECIAL_ACTION_CARRY );
	}

	if ( CLASS_CIVILIAN_RANGE[ 0 ] <= classid <= CLASS_CIVILIAN_RANGE[ 1 ] )
    {
		p_Class[ playerid ] = ( CLASS_CIVILIAN );
		//SetPlayerTeam( playerid, NO_TEAM );
		SetPlayerColorToTeam( playerid );
		p_inFBI{ playerid } = false;
		p_inArmy{ playerid } = false;
		p_inCIA{ playerid } = false;
		ShowPlayerClassTextdraw( playerid, 0 );
    }
	else if ( CLASS_POLICE_RANGE[ 0 ] <= classid <= CLASS_POLICE_RANGE[ 1 ] )
    {
		p_Class[ playerid ] = ( CLASS_POLICE );
		SetPlayerColor( playerid, COLOR_POLICE );
		//SetPlayerTeam( playerid, CLASS_POLICE );
		p_inFBI{ playerid } = false;
		p_inArmy{ playerid } = false;
		p_inCIA{ playerid } = false;

		ShowPlayerClassTextdraw( playerid, 1 );
    }
    else if ( CLASS_FBI_RANGE[ 0 ] <= classid <=  CLASS_FBI_RANGE[ 1 ] )
    {
		p_Class[ playerid ] = ( CLASS_POLICE );
		//SetPlayerTeam( playerid, CLASS_POLICE );
		SetPlayerColor( playerid, COLOR_FBI );
		p_inFBI{ playerid } = true;
		p_inArmy{ playerid } = false;
		p_inCIA{ playerid } = false;
		ShowPlayerClassTextdraw( playerid, 2 );
    }
    else if ( classid == CLASS_ARMY_RANGE )
    {
		p_Class[ playerid ] = ( CLASS_POLICE );
		SetPlayerColor( playerid, COLOR_ARMY );
		//SetPlayerTeam( playerid, CLASS_POLICE );
		p_inFBI{ playerid } = true;
		p_inArmy{ playerid } = true;
		p_inCIA{ playerid } = true;
		ShowPlayerClassTextdraw( playerid, 3 );
    }
    else if ( CLASS_CIA_RANGE[ 0 ] <= classid <= CLASS_CIA_RANGE[ 1 ] )
    {
		p_Class[ playerid ] = ( CLASS_POLICE );
		SetPlayerColor( playerid, COLOR_CIA );
		//SetPlayerTeam( playerid, CLASS_POLICE );
		p_inFBI{ playerid } = true;
		p_inArmy{ playerid } = false;
		p_inCIA{ playerid } = true;
		ShowPlayerClassTextdraw( playerid, 4 );
    }
    else if ( CLASS_FIRE_RANGE[ 0 ] <= classid <= CLASS_FIRE_RANGE[ 1 ] )
	{
		p_Class[ playerid ] = ( CLASS_FIREMAN );
		SetPlayerColor( playerid, COLOR_FIREMAN );
		//SetPlayerTeam( playerid, NO_TEAM );
		p_inFBI{ playerid } = false;
		p_inArmy{ playerid } = false;
		p_inCIA{ playerid } = false;
		ShowPlayerClassTextdraw( playerid, 6 );
	}
    else if ( CLASS_MEDIC_RANGE[ 0 ] <= classid <= CLASS_MEDIC_RANGE[ 1 ] )
	{
		p_Class[ playerid ] = ( CLASS_MEDIC );
		SetPlayerColor( playerid, COLOR_MEDIC );
		//SetPlayerTeam( playerid, NO_TEAM );
		p_inFBI{ playerid } = false;
		p_inArmy{ playerid } = false;
		p_inCIA{ playerid } = false;
		ShowPlayerClassTextdraw( playerid, 5 );
	}
	return 1;
}

hook OnPlayerRequestSpawn( playerid )
{
	// army limit
	/*if ( IsPlayerArmy( playerid ) )
	{
		static const ARMY_LIMIT = 15;

		new players = Iter_Count( Player );
		new army_limit = floatround( float( players ) / ARMY_LIMIT );
		new army_players = 0;

		// count army players
		foreach ( new armyid : Player ) if ( p_inArmy{ armyid } && armyid != playerid )
			army_players ++;

		if ( army_players >= army_limit ) {
			SendError( playerid, "Army is currently restricted to %d personnel. Need %d more players online for an additional slot.", army_limit, ( ( army_limit + 1 ) * ARMY_LIMIT ) - players );
			return 0;
		}
	}*/
	return IsPlayerClassApproved( playerid );
}

stock IsPlayerClassApproved( playerid ) {

	// is logged in
	if ( ! IsPlayerLoggedIn( playerid ) )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You must be authenticated to play the game." ), 0;

	// is verified
	if ( ! IsPlayerSecurityFullyVerified( playerid ) )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You must be verified to play the game." ), 0;

	// is cop/army banned
	if ( p_CopBanned{ playerid } == MAX_CLASS_BAN_WARNS && ( IsPlayerPolice( playerid ) || IsPlayerFBI( playerid ) || IsPlayerCIA( playerid ) ) )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You are banned from using the police class(es). Use "COL_GREY"/unbanme"COL_WHITE" to pay for an unban." ), 0;

	if ( p_ArmyBanned{ playerid } == MAX_CLASS_BAN_WARNS && IsPlayerArmy( playerid ) )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You are banned from using the army class. Use "COL_GREY"/unbanme"COL_WHITE" to pay for an unban." ), 0;

	// wanted level an issue?
	if ( GetPlayerWantedLevel( playerid ) && ( IsPlayerPolice( playerid ) || IsPlayerFBI( playerid ) || IsPlayerCIA( playerid ) || GetPlayerSkin( playerid ) == 287 ) )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You must not have a wanted level to use this class." ), 0;

	// get player total experience
	new
		Float: total_experience;

	GetPlayerTotalExperience( playerid, total_experience );

	// bought xp
	if ( IsPlayerFBI( playerid ) && total_experience < 10000.0 )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You need 10,000 Total XP to use this class." ), 0;

	if ( IsPlayerArmy( playerid ) && total_experience < 20000.0 )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You need 20,000 Total XP to use this class." ), 0;

	if ( IsPlayerCIA( playerid ) && total_experience < 15000.0 )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You need 15,000 Total XP to use this class." ), 0;

	if ( IsPlayerFireman( playerid ) && total_experience < 1000.0 )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You need 1,000 Total XP to use this class." ), 0;

	if ( IsPlayerMedic( playerid ) && total_experience < 2000.0 )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You need 2,000 Total XP to use this class." ), 0;

	// job not set
	if ( ! p_JobSet{ playerid } ) // || !p_CitySet{ playerid } )
		return SendClientMessage( playerid, -1, ""COL_RED"[ERROR]"COL_WHITE" You must ensure your job have been properly set." ), 0; // and city

	// hide textdraws
	for ( new i = 0; i < sizeof( CLASS_COLORS ); i ++ ) {
		TextDrawHideForPlayer( playerid, g_classTextdrawBox[ i ] );
		TextDrawHideForPlayer( playerid, g_classTextdrawDescrip[ i ] );
		TextDrawHideForPlayer( playerid, g_classTextdrawName[ i ] );
	}
	TextDrawHideForPlayer( playerid, g_classBoxTD );
	RemovePlayerAttachedObject( playerid, 1 );
	return 1;
}

stock ShowPlayerClassTextdraw( playerid, classid ) {
	for ( new i = 0; i < sizeof( CLASS_COLORS ); i ++ ) if ( i != classid ) {
		TextDrawHideForPlayer( playerid, g_classTextdrawBox[ i ] );
		TextDrawHideForPlayer( playerid, g_classTextdrawDescrip[ i ] );
		TextDrawHideForPlayer( playerid, g_classTextdrawName[ i ] );
	}

    TextDrawShowForPlayer( playerid, g_classBoxTD );
	TextDrawShowForPlayer( playerid, g_classTextdrawBox[ classid ] );
	TextDrawShowForPlayer( playerid, g_classTextdrawDescrip[ classid ] );
	TextDrawShowForPlayer( playerid, g_classTextdrawName[ classid ] );
}
