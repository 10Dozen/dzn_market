// ****************************************************
//	PARAMETERS OF DZN_MARKET
// ****************************************************

// Source where cash is stored. It may be variable on player, or even fucntion which return a value number.
dzn_market_getCashSource = { dzn_market_accountCash };
// How to update cash: code which update cash at the source
dzn_market_updateCashSource = { dzn_market_accountCash = dzn_market_accountCash + _this };

dzn_market_cashSyncTimerDelay = 300;

dzn_market_accountCash = call dzn_market_getCashSource;
dzn_market_sellCoefficient = _this select 0;


// ****************************************************
//	END OF PARAMETERS OF DZN_MARKET
// ****************************************************


// Include functions
#include "dzn_market_inventory.sqf"

// Include functions
#include "dzn_market_functions.sqf"

[marketBox, ["FirstAidKit"], true, true] call BIS_fnc_addVirtualItemCargo;
[marketBox, dzn_market_itemList] call dzn_fnc_market_updateMarketBox;

waitUntil {!isNil "dzn_gear_initialized" && { dzn_gear_initialized }};
player setVariable ["dzn_market_arsenalOpened", false];
player setVariable ["dzn_market_arsenalTimer", time + 1];
player setVariable ["dzn_market_cashSyncTimer", time + dzn_market_cashSyncTimerDelay];

[] spawn {
	["arsenal", "onEachFrame", {
		if !(isNull ( uinamespace getvariable "RSCDisplayArsenal" )) then {
			if !(player getVariable "dzn_market_arsenalOpened") then {
				player setVariable ["dzn_market_arsenalOpened",true];
				
				player setVariable ["dzn_market_currentGear", player call dzn_fnc_gear_getGear];
				player setVariable ["dzn_market_baseInv", (player call BIS_fnc_saveInventory) call dzn_fnc_convertInventoryToLine];
			};
			
			if (time > player getVariable "dzn_market_arsenalTimer") then {
				player setVariable ["dzn_market_arsenalTimer",time + 1];
				_currentInv = (player call BIS_fnc_saveInventory) call dzn_fnc_convertInventoryToLine;
				_diff = [_currentInv, player getVariable "dzn_market_baseInv"] call dzn_fnc_getChangedInvItems;
				
				if !(_diff isEqualTo []) then {
					_diff call dzn_fnc_market_invTotals;			
				};
			};
		} else {
			if (player getVariable "ArsenalOpened") then {
				player setVariable ["dzn_market_arsenalOpened",false];				
				player setVariable ["dzn_market_newGear", (player call dzn_fnc_gear_getGear)];
				
				if !((player getVariable "dzn_market_currentGear") isEqualTo (player getVariable "dzn_market_newGear")) then {
					[ player, player getVariable "dzn_market_currentGear" ] spawn dzn_fnc_gear_assignGear;					
					0 = createDialog "dzn_market_dialog";					
				};				
			};
		};
		
		if (time > player getVariable "dzn_market_cashSyncTimer") then {
			player setVariable ["dzn_market_cashSyncTimer",time + dzn_market_cashSyncTimerDelay];
			
			[(player getVariable "squadLogic") getVariable (name player), "cash", dzn_market_accountCash] call dzn_fnc_setValueByKey;
			(player getVariable "squadLogic") setVariable [
				name player
				,(player getVariable "squadLogic")  getVariable (name player)
				,true
			];
		};
		
	}] call BIS_fnc_addStackedEventHandler;
};
