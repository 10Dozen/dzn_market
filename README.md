# dzn_market
Arma 3 Arsenal Market System


### Dependencies
- dzn_commonFunctions
- dzn_gear


### API

##### dzn_fnc_market_updateMarketBox
<tt>[ @Box, @ItemList] call dzn_fnc_addItemsToMarketBox;</tt>
<tt>INPUT:</tt>
<tt>0 (OBJECT)</tt> - ammo box where market arsenal will be added
<tt>1 (ARRAY)</tt> - item list of market
<br><br>Add arsenal market to given box with market's item list

##### dzn_fnc_market_addItemsToList
<tt>[ [@Classname, [@Price, @Available], ... ] call dzn_fnc_market_addItemsToList;</tt>
<tt>INPUT:</tt>
<tt>0..n (ARRAY)</tt> - ItemLines to add to market item list (in format [ @Classname (String),[ @Price(Number),  @IsAvailable(Boolean)]] )
<br><br>Adds itemLine to market item list

##### dzn_fnc_market_addFreeItemsToList
<tt>[ @ClassName, @ClassName2 ... ] call dzn_fnc_market_addFreeItemsToList;</tt>
<tt>INPUT:</tt>
<tt>0..n (STRING)</tt> - classnames of items
<br><br>Adds items with given classname as free available items to market item list

##### dzn_fnc_market_removeItemFromList
// @Classname call dzn_fnc_market_removeItemFromList


##### dzn_fnc_market_isItemAvailable
##### dzn_fnc_market_getItemPrice

##### dzn_fnc_market_setItemPrice
##### dzn_fnc_market_setItemAvailable
