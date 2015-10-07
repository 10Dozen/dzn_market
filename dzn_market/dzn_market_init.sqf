// Properties
dzn_market_accountCash = _this select 0;
dzn_market_sellCoefficient = _this select 1;



// Include functions
#include "dzn_market_inventory.sqf"

// Include functions
#include "dzn_market_functions.sqf"




[
	marketBox, 
	["FirstAidKit"], 
	true,
	true
] call BIS_fnc_addVirtualItemCargo;

[marketBox, dzn_market_itemList] call dzn_fnc_market_updateMarketBox;

	
	
waitUntil {!isNil "dzn_fnc_gear_getGear" && !isNil "dzn_fnc_gear_assignGear"};
player setVariable ["ArsenalOpened",false];
player setVariable ["ArsenalTimer",time + 1];

[] spawn {
	["arsenal", "onEachFrame", {
		if !(isNull ( uinamespace getvariable "RSCDisplayArsenal" )) then {
			if !(player getVariable "ArsenalOpened") then {
				player setVariable ["ArsenalOpened",true];
				
				player setVariable ["CurrentGear", player call dzn_fnc_gear_getGear];
				player setVariable ["BaseInv", (player call BIS_fnc_saveInventory) call dzn_fnc_convertInventoryToLine];
			};
			
			if (time > player getVariable "ArsenalTimer") then {
				player setVariable ["ArsenalTimer",time + 1];
				_currentInv = (player call BIS_fnc_saveInventory) call dzn_fnc_convertInventoryToLine;
				_diff = [_currentInv, player getVariable "BaseInv"] call dzn_fnc_getChangedInvItems;
				
				if !(_diff isEqualTo []) then {
					_diff call dzn_fnc_market_invTotals;			
				};
			};
		} else {
			if (player getVariable "ArsenalOpened") then {
				player setVariable ["ArsenalOpened",false];				
				player setVariable ["NewGear", (player call dzn_fnc_gear_getGear)];
				
				if !((player getVariable "CurrentGear") isEqualTo (player getVariable "NewGear")) then {
					[ player, player getVariable "CurrentGear" ] spawn dzn_fnc_gear_assignGear;					
					0 = createDialog "dzn_market_dialog";					
				};				
			};
		};
	}] call BIS_fnc_addStackedEventHandler;
};
