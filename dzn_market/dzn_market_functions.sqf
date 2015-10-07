// ********************************
// PAYMENT functions
// ********************************
dzn_fnc_market_doPayment = {
	// @Value call dzn_fnc_market_doPayment
	dzn_market_accountCash = dzn_market_accountCash - _this;
};

dzn_fnc_market_getCurrentBalance = {
	if (dzn_market_accountCash > 0) then {
		hint parseText format ["<t color='#99CC00' align='center'>BALANCE:</t><br /><t color='#99CC00'>%1 $</t>", dzn_market_accountCash];
	} else {
		hint parseText format ["<t color='#99CC00' align='center'>BALANCE:</t><t color='#CC3300'>%1 $</t>", dzn_market_accountCash];
	};
};

dzn_fnc_market_showAccount = {
	hint parseText format [
		"<t color='#99CC00' align='center'>ACCOUNT  #414ce-860b96c-331<br />Expires: 10/2025<br />Owner: John Doe<br /><br />Balance: %1</t>",
		dzn_market_accountCash
	];
};

// ********************************
// DISPLAY functions
// ********************************
dzn_fnc_market_invTotals = {
	// @ArrayOfTotals call dzn_fnc_showInvTotals
	
	_add = _this select 0;
	_sell = _this select 1;
	_addCost = 0;
	_sellCost = 0;
	
	_stringsToShow = [
		parseText (format ["<t color='#FFFFFF' size='1.4' align='center'>%1</t>", "TOTALS"])
		,lineBreak
	];
	
	// ADDED
	if !(_add isEqualTo []) then {
		_stringsToShow = _stringsToShow + [
			parseText (format ["<t color='#F5322F' size='1.1' align='center'>%1</t>", "BUY:"])
			,lineBreak
		];
	};

	{
		_itemPrice = ((_x select 0) call dzn_fnc_market_getItemPrice) * (_x select 1);
		_itemName = (_x select 0) call dzn_fnc_getItemDisplayName;

		_addCost = _addCost + _itemPrice;
		_stringsToShow = _stringsToShow + [
			if (_x select 1 > 1) then {
				parseText (format ["<t color='#AAAAAA' align='left'>x%1 %2</t>", _x select 1, _itemName])
			} else {
				parseText (format ["<t color='#AAAAAA' align='left'>%1</t>", _itemName])
			}
			,parseText (format ["<t color='#FFFFFF' align='right'>%1</t>", _itemPrice])			
			,lineBreak
		];
	} forEach _add;	
	
	// REMOVED
	if !(_sell isEqualTo []) then {
		_stringsToShow = _stringsToShow + [
			parseText (format ["<t color='#C7F56C' size='1.1' align='center'>%1</t>", "SELL:"])
			,lineBreak
		];
	};

	{
		_itemPrice = round(((_x select 0) call dzn_fnc_market_getItemPrice) * (_x select 1) * dzn_market_sellCoefficient);
		_itemName = (_x select 0) call dzn_fnc_getItemDisplayName;
		
		_sellCost = _sellCost + _itemPrice;
		_stringsToShow = _stringsToShow + [
			if (_x select 1 > 1) then {
				parseText (format ["<t color='#AAAAAA' align='left'>x%1 %2</t>", _x select 1, _itemName])
			} else {
				parseText (format ["<t color='#AAAAAA' align='left'>%1</t>", _itemName])
			}
			,parseText (format ["<t color='#FFFFFF' align='right'>+%1</t>", _itemPrice])			
			,lineBreak
		];
	} forEach _sell;		
	
	// TOTAL COST	
	_stringsToShow = _stringsToShow + [
		parseText (format [
			"<t color='#F5BC6C' size='1.3' align='center'>%1</t>", 
			if (_sellCost <= _addCost) then {"TOTAL COST:"} else {"INCOME:"}
		])
		,lineBreak
		,if (_sellCost <= _addCost) then {
			parseText (format ["<t color='#F2D2A5' size='1.1' align='center'>$%1</t>", _addCost - _sellCost])
		} else {
			parseText (format ["<t color='#B8F53C' size='1.1' align='center'>+$%1</t>", _sellCost - _addCost])
		}
		,if ((dzn_market_accountCash - _addCost + _sellCost) < 0) then { lineBreak }	
		,if ((dzn_market_accountCash - _addCost + _sellCost) < 0) then {	
			parseText (format ["<t color='#F5322F' align='center'>Overfund: $%1</t>", (-1)*(dzn_market_accountCash - _addCost + _sellCost)])
		}
	];	

	player setVariable ["dzn_market_arsenalInventoryCost", (_addCost - _sellCost)];
	hintSilent (composeText _stringsToShow);
};

dzn_fnc_market_setPurchaseDialogText = {
	disableSerialization;
	private ["_display", "_idc", "_ctrl"];
	_display = _this select 0;
	
	_idc = 1100;	
	_ctrl = _display displayCtrl _idc;
	
	_cost = player getVariable "dzn_market_arsenalInventoryCost";	
	if (_cost > 0) then {
		if (_cost <= dzn_market_accountCash) then {
			_ctrl ctrlSetText format [
				"Do you want to change your inventory\n and purchase $%1 for selected items?"
				,_cost		
			];
			_ctrl ctrlSetBackgroundColor [0.95, 0.82, 0.65, 0.8];
		} else {
			_ctrl ctrlSetText format [
				"Not enough money to buy all selected items\n (total cost $%1, you have $%2)"
				,_cost
				,dzn_market_accountCash	
			];
			_ctrl ctrlSetBackgroundColor [0.6, 0.2, 0.2, 0.8];
		};
	} else {
		_ctrl ctrlSetText format [
			"Do you want to change your inventory\n and sell selected items for $%1?"
			,_cost * (-1)
		];
		_ctrl ctrlSetBackgroundColor [0.4, 0.6, 0.4, 0.8];
	};
	
	_idc = 1600;	
	_ctrl = _display displayCtrl _idc;
	
	if (_cost > 0) then {
		if (_cost <= dzn_market_accountCash) then {
			_ctrl ctrlSetTextColor [0.95, 0.82, 0.65, 1];
			_ctrl ctrlSetText "PURCHASE";
		} else {
			_ctrl ctrlSetTextColor [1,1,1, 1];
			_ctrl ctrlSetText "OK";
		};
	} else {
		_ctrl ctrlSetTextColor [0.2, 0.8, 0.2, 1];
		_ctrl ctrlSetText "SELL";
	};
	
	_ctrl ctrlCommit 0;	
};

dzn_fnc_market_buttonYes = {
	closeDialog 0;
	
	if (player getVariable "dzn_market_arsenalInventoryCost" >= 0) then {		
		if (player getVariable "dzn_market_arsenalInventoryCost" <= dzn_market_accountCash) then {
			[player, player getVariable "dzn_market_newGear"] spawn dzn_fnc_gear_setPreciseGear;
			(player getVariable "dzn_market_arsenalInventoryCost") call dzn_fnc_market_doPayment;
			call dzn_fnc_market_getCurrentBalance;
		};	
	} else {
		[player, player getVariable "dzn_market_newGear"] spawn dzn_fnc_gear_setPreciseGear;
		(player getVariable "dzn_market_arsenalInventoryCost") call dzn_fnc_market_doPayment;
		call dzn_fnc_market_getCurrentBalance;
	};
	player setVariable ["dzn_market_newGear", nil];
	player setVariable ["dzn_market_currentGear", nil];
};

dzn_fnc_market_buttonNo = {
	closeDialog 0;
	
	player setVariable ["dzn_market_newGear", nil];
	player setVariable ["dzn_market_currentGear", nil];
};

// ********************************
// ITEM LIST MANAGEMENT functions
// ********************************
dzn_fnc_market_updateMarketBox = {
	// [ @Box, @ItemList] call dzn_fnc_addItemsToMarketBox;
	private["_box","_itemsToAdd"];
	
	_box = _this select 0;
	_itemsToAdd = [];
	{
		if (_x call dzn_fnc_market_isItemAvailable) then {
			_itemsToAdd pushBack (_x select 0);
		};
	} forEach (_this select 1);	
	
	[_box , (_box call BIS_fnc_getVirtualBackpackCargo)] call BIS_fnc_removeVirtualBackpackCargo;
	[_box , (_box call BIS_fnc_getVirtualItemCargo)] call BIS_fnc_removeVirtualItemCargo;
	[_box , (_box call BIS_fnc_getVirtualWeaponCargo)] call BIS_fnc_removeVirtualWeaponCargo;
	[_box , (_box call BIS_fnc_getVirtualMagazineCargo)] call BIS_fnc_removeVirtualMagazineCargo;
	
	[_box, _itemsToAdd, true, false] call BIS_fnc_addVirtualBackpackCargo;
	[_box, _itemsToAdd, true,false] call BIS_fnc_addVirtualItemCargo;
	[_box, _itemsToAdd, true, false] call BIS_fnc_addVirtualWeaponCargo;
	[_box, _itemsToAdd, true, false] call BIS_fnc_addVirtualMagazineCargo;
};

dzn_fnc_market_addItemsToList = {
	// [ [@Classname, [@Price, @Available], ... ] call dzn_fnc_market_addItemsToList;
	{
		if (typename _x == "ARRAY" && {typename (_x select 0) == "STRING"}) then {
			dzn_market_itemList pushBack _x;
		};
	} forEach _this;
};

dzn_fnc_market_addFreeItemsToList = {
	// [ @ClassName, @ClassName2 ... ] call dzn_fnc_market_addFreeItemsToList;
	{
		dzn_market_itemList pushBack [_x, [0, true]];	
	} forEach _this;
};

dzn_fnc_market_removeItemFromList = {
	// @Classname call dzn_fnc_market_removeItemFromList
	private["_idx"];
	
	_idx = -1;
	{ 
		if (_x select 0 == _this) exitWith {_idx = _forEachIndex; };
	} forEach dzn_market_itemList;
	
	dzn_market_itemList set [_idx, -1];
	dzn_market_itemList = dzn_market_itemList - [-1];
};


dzn_fnc_market_getItemPrice = {
	// @ItemLine call dzn_fnc_market_getItemPrice
	
	private["_price"];
	
	_price = [dzn_market_itemList, _this] call dzn_fnc_getValueByKey;
	if (!isNil {_price} && {typename _price != "ARRAY"}) exitWith { 0 };
	
	(_price select 0)
};

dzn_fnc_market_isItemAvailable = {
	// @Boolean = @ItemList call dzn_fnc_market_isItemAvailable
	// @ItemList = [@Classname, [@IsAvailable, @Cost]]
	
	(_this select 1) select 1
};

// ********************************
// CHECK INVENTORY during arsenal
// ********************************
dzn_fnc_convertInventoryToLine = {
	// @InventoryArray call dzn_fnc_convertInventoryToLine
	private[
		"_line"
		,"_cat"
		,"_subCat"
	];
	#define	linePush(X)		if (_x != "") then {_line pushBack X;};
	_line = [];
	{
		_cat = _x;
		if (typename _cat == "ARRAY") then {
			{
				_subCat = _x;
				if (typename _subCat == "ARRAY") then {
					{
						linePush(_x)
					} forEach _subCat;
				} else {
					linePush(_x)
				};
			} forEach _cat;
		} else {
			linePush(_x)
		};
	} forEach _this;
	
	_line
};

dzn_fnc_getChangedInvItems = {
	// [@InvToCheck, @BaseInv] call dzn_fnc_getChangedInvItems;
	private[
		"_curInv"
		,"_baseInv"
		,"_changed"
		,"_removed"
		,"_cItems"
		,"_rItems"
		,"_item"
		,"_itemCount"
		,"_rItemCount"
	];
	
	_curInv = (_this select 0) call BIS_fnc_consolidateArray;
	_baseInv = (_this select 1) call BIS_fnc_consolidateArray;
	
	if (_curInv isEqualTo _baseInv) exitWith { [] };

	_changed = _curInv - _baseInv;
	_removed = _baseInv - _curInv;
	
	_cItems = [];
	_rItems = [];
	
	{
		_item = _x select 0;
		_itemCount = _x select 1;
		_rItemCount = [_removed, _item] call dzn_fnc_getValueByKey;
		if (typename _rItemCount != "BOOL") then {
			if (_itemCount > _rItemCount) then {
				_cItems pushBack [_item, _itemCount - _rItemCount];
			} else {
				_rItems pushBack [_item, _rItemCount - _itemCount];
			};
		} else {
			_cItems pushBack _x;
		};
	} forEach _changed;
	
	{
		if (typename ([_changed, _x select 0] call dzn_fnc_getValueByKey) == "BOOL") then {
			_rItems pushBack _x;
		};			
	} forEach _removed;
	
	[_cItems, _rItems]
};
