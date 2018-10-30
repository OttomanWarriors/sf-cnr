/*
 * Irresistible Gaming (c) 2018
 * Developed by Lorenc Pekaj
 * Module: cnrs
 * Purpose:
 */

/* ** Includes ** */
#include 							< YSI\y_hooks >

/* ** Definitions ** */
#define MAX_STOCKS					( 32 )

#define STOCK_REPORTING_PERIOD 		( 600 ) // 1 day

#define STOCK_REPORTING_PERIODS 	( 30 ) // last 30 periods (days)

#define DIALOG_STOCK_MARKET 		8923
#define DIALOG_STOCK_MARKET_BUY 	8925

#define STOCK_MM_USER_ID			( 0 )

/* ** Variables ** */
enum E_STOCK_MARKET_DATA
{
	E_NAME[ 64 ],			E_SYMBOL[ 4 ],			Float: E_MAX_SHARES,

	// market maker
	Float: E_IPO_SHARES,	Float: E_IPO_PRICE
};

enum E_STOCK_MARKET_PRICE_DATA
{
	E_SQL_ID,				Float: E_PRICE,
	Float: E_POOL
};

enum
{
	E_STOCK_MINING_COMPANY
};

static stock
	g_stockMarketData 				[ MAX_STOCKS ] [ E_STOCK_MARKET_DATA ],
	g_stockMarketReportData 		[ MAX_STOCKS ] [ STOCK_REPORTING_PERIODS ] [ E_STOCK_MARKET_PRICE_DATA ],
	Iterator: stockmarkets 			< MAX_STOCKS >
;

/* ** Forwards / Getters ** */
stock Float: StockMarket_GetCurrentPrice( stockid ) {
	return g_stockMarketReportData[ stockid ] [ 0 ] [ E_PRICE ];
}

/* ** Hooks ** */
hook OnScriptInit( )
{
	// server variables
	AddServerVariable( "stock_report_time", "0", GLOBAL_VARTYPE_INT );

	// create markets
	CreateStockMarket( 0, "The Mining Company", "MC", 1000000, 100 );
	return 1;
}

hook OnServerUpdate( )
{
	new current_time = GetServerTime( );
	new last_reporting = GetServerVariableInt( "stock_report_time" );

	// check if its reporting time
	if ( current_time > last_reporting )
	{
		// reporting period
		UpdateServerVariableInt( "stock_report_time", current_time + STOCK_REPORTING_PERIOD );

		// create a new reporting period for every stock there
		foreach ( new s : stockmarkets )
		{
			StockMarket_ReleaseDividends( s );
		}

		print( "Successfully created new reporting period for all online companies" );
	}
	return 1;
}

hook OnDialogResponse( playerid, dialogid, response, listitem, inputtext[ ] )
{
	if ( dialogid == DIALOG_STOCK_MARKET && response )
	{
		new
			x = 0;

		foreach ( new s : stockmarkets )
		{
			if ( x == listitem )
			{
				SetPVarInt( playerid, "stockmarket_selection", s );
				StockMarket_ShowBuySlip( playerid, s );
			}
			x ++;
		}
		return 1;
	}
	else if ( dialogid == DIALOG_STOCK_MARKET_BUY )
	{
		new
			stockid = GetPVarInt( playerid, "stockmarket_selection" );

		if ( response )
		{
			new
				Float: shares;

			if ( sscanf( inputtext, "f", shares ) ) SendError( playerid, "You must use a valid value." );
			else if ( shares <= 10.0 ) SendError( playerid, "The minimum number of shares you can buy is 10." );
			else
			{
				mysql_tquery( dbHandle, sprintf( "SELECT * FROM `STOCK_OWNERS` WHERE `STOCK_ID` = %d AND `USER_ID` = %d", stockid, STOCK_MM_USER_ID ), "StockMarket_OnPurchaseOrder", "ddf", playerid, stockid, shares );
				return 1;
			}
			return StockMarket_ShowBuySlip( playerid, stockid );
		}
		else
		{
			return cmd_stockmarkets( playerid, "" );
		}
	}
	return 1;
}

/* ** SQL Thread ** */
thread Stock_UpdateReportingPeriods( stockid )
{
	new
		rows = cache_get_row_count( );

	if ( rows )
	{
		for ( new row = 0; row < rows; row ++ )
		{
			g_stockMarketReportData[ stockid ] [ row ] [ E_SQL_ID ] = cache_get_field_content_int( row, "ID" );
			g_stockMarketReportData[ stockid ] [ row ] [ E_POOL ] = cache_get_field_content_float( row, "POOL" );
		}
	}
	else // no historical reporting data, restock the market maker
	{
		// set current stock market prices to IPO
		//g_stockMarketReportData[ stockid ] [ 1 ] [ E_PRICE ] = g_stockMarketData[ stockid ] [ E_IPO_PRICE ];

		// create report for the company using the IPO price
		//StockMarket_ReleaseDividends( stockid );

		// give market maker shares
		StockMarket_GiveShares( stockid, STOCK_MM_USER_ID, g_stockMarketData[ stockid ] [ E_IPO_SHARES ] ); // , g_stockMarketData[ stockid ] [ E_IPO_PRICE ]
	}
	return 1;
}

thread StockMarket_InsertReport( stockid )
{
	g_stockMarketReportData[ stockid ] [ 0 ] [ E_SQL_ID ] = cache_insert_id( );
	return 1;
}

thread StockMarket_OnPurchaseOrder( playerid, stockid, Float: shares )
{
	new
		rows = cache_get_row_count( );

	if ( ! rows ) {
		return SendError( playerid, "This stock has no available shares for sale." );
	}

	// check if the player has the money for the purchase
	new Float: ask_price = g_stockMarketReportData[ stockid ] [ 1 ] [ E_PRICE ];
	new purchase_cost = floatround( ask_price * shares );

	if ( GetPlayerCash( playerid ) < purchase_cost ) {
		return SendError( playerid, "You need at least %s to purchase this many shares.", cash_format( purchase_cost ) ), StockMarket_ShowBuySlip( playerid, stockid ), 1;
	}

	// check if quantity is valid
	new Float: available_quantity = cache_get_field_content_float( 0, "SHARES" );

	if ( shares > available_quantity ) {
		return SendError( playerid, "There are not that many shares available for sale." ), StockMarket_ShowBuySlip( playerid, stockid ), 1;
	}

	// reduce the market makers shares
	StockMarket_GiveShares( stockid, STOCK_MM_USER_ID, -shares );

	// increment the players shares
	StockMarket_GiveShares( stockid, GetPlayerAccountID( playerid ), shares );

	// reduce player balance and alert
	GivePlayerCash( playerid, -purchase_cost );
	SendServerMessage( playerid, "You have successfully purchased %s shares of %s (@ %s/ea) for %s.", number_format( shares, .decimals = 3 ), g_stockMarketData[ stockid ] [ E_NAME ], cash_format( ask_price, .decimals = 2 ), cash_format( purchase_cost ) );
	return 1;
}

thread StockMarket_OnShowBuySlip( playerid, stockid )
{
	new
		rows = cache_get_row_count( );

	if ( ! rows ) {
		return SendError( playerid, "This stock does now have any shares available to buy." );
	}

	new
		Float: available_quantity = cache_get_field_content_float( 0, "SHARES" );

	format(
		szBigString, sizeof ( szBigString ),
		""COL_WHITE"You can buy shares of %s for "COL_GREEN"%s"COL_WHITE" each.\n\nThere are %s available shares to buy.",
		g_stockMarketData[ stockid ] [ E_NAME ],
		cash_format( g_stockMarketReportData[ stockid ] [ 1 ] [ E_PRICE ], .decimals = 2 ),
		number_format( available_quantity, .decimals = 3 )
	);
	ShowPlayerDialog( playerid, DIALOG_STOCK_MARKET_BUY, DIALOG_STYLE_INPUT, ""COL_WHITE"Stock Market", szBigString, "Buy", "Close" );
	return 1;
}

thread StockMarket_OnShowShares( playerid )
{
	new
		rows = cache_get_row_count( );

	if ( ! rows ) {
		return SendError( playerid, "This stock does now have any shares available to buy." );
	}

	szLargeString = ""COL_WHITE"Stock\t"COL_WHITE"Total Shares\t"COL_WHITE"Current Price ($)\t"COL_GREEN"Value ($)\n";

	for ( new row = 0; row < rows; row ++ )
	{
		new
			stockid = cache_get_field_content_int( row, "ID" );

		if ( Iter_Contains( stockmarkets, stockid ) )
		{
			new Float: current_price = StockMarket_GetCurrentPrice( stockid );
			new Float: shares = cache_get_field_content_float( row, "SHARES" );

			format(
				szLargeString, sizeof( szLargeString ),
				"%s%s (%s)\t%s\t%s\t"COL_GREEN"%s\n",
				szLargeString,
				g_stockMarketData[ stockid ] [ E_NAME ],
				g_stockMarketData[ stockid ] [ E_SYMBOL ],
				number_format( shares, .decimals = 3 ),
				cash_format( current_price, .decimals = 2 ),
				cash_format( floatround( shares * current_price ) )
			);
		}
	}
	return ShowPlayerDialog( playerid, DIALOG_STOCK_MARKET, DIALOG_STYLE_TABLIST_HEADERS, ""COL_WHITE"Stock Market", szLargeString, "Sell", "Close" ), 1;
}

thread Stock_OnDividendPayout( stockid )
{
	new
		rows = cache_get_row_count( );

	// pay out existing shareholders
	if ( rows )
	{
		new
			Float: total_shares = g_stockMarketData[ stockid ] [ E_MAX_SHARES ];

		for ( new row = 0; row < rows; row ++ )
		{
			new account_id = cache_get_field_content_int( row, "USER_ID" );
			new Float: shares_owned = cache_get_field_content_float( row, "SHARES" );

			new Float: dividend_rate = shares_owned / total_shares;
			new dividend_payout = floatround( g_stockMarketReportData[ stockid ] [ 0 ] [ E_POOL ] * dividend_rate );

			new
				shareholder;

			foreach ( shareholder : Player ) if ( GetPlayerAccountID( shareholder ) == account_id ) {
				break;
			}

			if ( 0 <= shareholder < MAX_PLAYERS && Iter_Contains( Player, shareholder ) ) {
				GivePlayerBankMoney( shareholder, dividend_payout ), Beep( shareholder );
				SendServerMessage( shareholder, "A "COL_GOLD"%s"COL_WHITE" dividend (%0.2f%s) has been paid out for owning %s!", cash_format( dividend_payout ), dividend_rate * 100.0, "%%", g_stockMarketData[ stockid ] [ E_NAME ] );
			} else {
				mysql_single_query( sprintf( "UPDATE `USERS` SET `BANKMONEY` = `BANKMONEY` + %d WHERE `ID` = %d", dividend_payout, account_id ) );
			}
		}
	}

	// store temporary stock info
	new temp_stock_price_data[ MAX_STOCKS ] [ STOCK_REPORTING_PERIODS ] [ E_STOCK_MARKET_PRICE_DATA ];
	temp_stock_price_data = g_stockMarketReportData;

	// shift all earnings by one
	for ( new r = 0; r < sizeof( g_stockMarketReportData[ ] ) - 2; r ++ ) {
		g_stockMarketReportData[ stockid ] [ r + 1 ] [ E_POOL ] = temp_stock_price_data[ stockid ] [ r ] [ E_POOL ];
	}

	// reset earnings
	g_stockMarketReportData[ stockid ] [ 0 ] [ E_POOL ] = 1.0; // set to 1 instead of 0 to prevent errors

	// insert to database the old information
	mysql_format( dbHandle, szBigString, sizeof ( szBigString ), "INSERT INTO `STOCK_REPORTS` (`STOCK_ID`, `POOL`) VALUES (%d, %f)", stockid, g_stockMarketReportData[ stockid ] [ 0 ] [ E_POOL ] );
	mysql_tquery( dbHandle, szBigString, "StockMarket_InsertReport", "d", stockid );
	return 1;
}

thread Stock_UpdateMaximumShares( stockid )
{
	new
		rows = cache_get_row_count( );

	if ( rows ) {
		g_stockMarketData[ stockid ] [ E_MAX_SHARES ] = cache_get_field_content_float( 0, "TOTAL_SHARES" );
	} else {
		g_stockMarketData[ stockid ] [ E_MAX_SHARES ] = g_stockMarketData[ stockid ] [ E_IPO_SHARES ];
	}
	return 1;
}

/* ** Command ** */
CMD:increase( playerid, params[ ] ) {
	StockMarket_UpdateEarnings( 0, strval( params ) );
	return 1;
}

CMD:newreport( playerid, params[ ] ) {
	StockMarket_ReleaseDividends( 0 );
	return 1;
}

CMD:stocks( playerid, params[ ] ) return cmd_stockmarkets( playerid, params );
CMD:stockmarkets( playerid, params[ ] )
{
	szLargeString = ""COL_WHITE"Stock\t"COL_WHITE"Max Shares\t"COL_WHITE"Dividend Per Share ($)\n";

	foreach ( new s : stockmarkets )
	{
		new
			Float: payout = g_stockMarketReportData[ s ] [ 0 ] [ E_POOL ] / g_stockMarketData[ s ] [ E_MAX_SHARES ];

		format(
			szLargeString, sizeof( szLargeString ),
			"%s%s (%s)\t%s\t"COL_GREEN"%s\n",
			szLargeString,
			g_stockMarketData[ s ] [ E_NAME ],
			g_stockMarketData[ s ] [ E_SYMBOL ],
			number_format( g_stockMarketData[ s ] [ E_MAX_SHARES ], .decimals = 0 ),
			cash_format( payout, .decimals = 2 )
		);
	}

	SendServerMessage( playerid, "The stock market will payout dividends in %s.", secondstotime( GetServerVariableInt( "stock_report_time" ) - GetServerTime( ) ) );
	return ShowPlayerDialog( playerid, DIALOG_STOCK_MARKET, DIALOG_STYLE_TABLIST_HEADERS, ""COL_WHITE"Stock Market", szLargeString, "Buy", "Close" );
}

CMD:shares( playerid, params[ ] )
{
	mysql_tquery( dbHandle, sprintf( "SELECT * FROM `STOCK_OWNERS` WHERE `USER_ID` = %d", GetPlayerAccountID( playerid ) ), "StockMarket_OnShowShares", "d", playerid );
	return 1;
}

/* ** Functions ** */
stock CreateStockMarket( stockid, const name[ 64 ], const symbol[ 4 ], Float: ipo_shares, Float: ipo_price )
{
	if ( ! Iter_Contains( stockmarkets, stockid ) )
	{
		strcpy( g_stockMarketData[ stockid ] [ E_NAME ], name );
		strcpy( g_stockMarketData[ stockid ] [ E_SYMBOL ], symbol );

		g_stockMarketData[ stockid ] [ E_IPO_SHARES ] = ipo_shares;
		g_stockMarketData[ stockid ] [ E_IPO_PRICE ] = ipo_price;

		// reset stock price information
		for ( new r = 0; r < sizeof( g_stockMarketReportData[ ] ); r ++ ) {
			g_stockMarketReportData[ stockid ] [ r ] [ E_POOL ] = 1.0;
		}

		// load price information if there is
 		mysql_tquery( dbHandle, sprintf( "SELECT * FROM `STOCK_REPORTS` WHERE `STOCK_ID`=%d ORDER BY `REPORTING_TIME` DESC LIMIT %d", stockid, sizeof( g_stockMarketReportData[ ] ) ), "Stock_UpdateReportingPeriods", "d", stockid );

 		// load the maximum number of shares
		mysql_tquery( dbHandle, sprintf( "SELECT SUM(`SHARES`) AS TOTAL_SHARES FROM `STOCK_OWNERS` WHERE `STOCK_ID`=0", stockid ), "Stock_UpdateMaximumShares", "d", stockid );

 		// add to iterator
		Iter_Add( stockmarkets, stockid );
	}
	return stockid;
}

static stock StockMarket_ReleaseDividends( stockid )
{
	mysql_format( dbHandle, szBigString, sizeof ( szBigString ), "SELECT * as `TOTAL_SHARES` FROM `STOCK_OWNERS` WHERE `STOCK_ID`=%d", stockid, stockid );
	mysql_tquery( dbHandle, szBigString, "Stock_OnDividendPayout", "d", stockid );
	return 1;
}

stock StockMarket_UpdateEarnings( stockid, amount )
{
	if ( ! Iter_Contains( stockmarkets, stockid ) )
		return 0;

	printf( "Current Pool: %f, Prior Pool: %f", g_stockMarketReportData[ stockid ] [ 0 ] [ E_POOL ], g_stockMarketReportData[ stockid ] [ 1 ] [ E_POOL ] );
	g_stockMarketReportData[ stockid ] [ 0 ] [ E_POOL ] += float( amount );
	mysql_single_query( sprintf( "UPDATE `STOCK_REPORTS` SET `POOL` = `POOL` + %d WHERE `ID` = %d", g_stockMarketReportData[ stockid ] [ 0 ] [ E_POOL ], g_stockMarketReportData[ stockid ] [ 0 ] [ E_SQL_ID ] ) );
	return 1;
}

stock StockMarket_GiveShares( stockid, accountid, Float: shares )
{
	mysql_format(
		dbHandle, szBigString, sizeof ( szBigString ),
		"INSERT INTO `STOCK_OWNERS` (`USER_ID`, `STOCK_ID`, `SHARES`) VALUES (%d, %d, %f) ON DUPLICATE KEY UPDATE `SHARES` = `SHARES` + %f",
		accountid, stockid, shares, shares
	);
	mysql_single_query( szBigString );
}

static stock StockMarket_ShowBuySlip( playerid, stockid )
{
	mysql_tquery( dbHandle, sprintf( "SELECT * FROM `STOCK_OWNERS` WHERE `STOCK_ID` = %d AND `USER_ID` = %d", stockid, STOCK_MM_USER_ID ), "StockMarket_OnShowBuySlip", "dd", playerid, stockid );
	return 1;
}

/*
	CREATE TABLE IF NOT EXISTS `STOCK_REPORTS` (
		`ID` int(11) primary key auto_increment,
		`STOCK_ID` int(11),
		`POOL` float,
		`REPORTING_TIME` TIMESTAMP default CURRENT_TIMESTAMP
	);

	CREATE TABLE IF NOT EXISTS `STOCK_OWNERS` (
		`USER_ID` int(11),
		`STOCK_ID` int(11),
		`SHARES` float,
		PRIMARY KEY (USER_ID, STOCK_ID)
	);

	CREATE TABLE IF NOT EXISTS `STOCK_TRADE_LOG` (
		`ID` int(11) primary key auto_increment,
		`USER_ID` int(11),
		`STOCK_ID` int(11),
		`SHARES` float,
	)
 */
