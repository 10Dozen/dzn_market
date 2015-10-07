
// Add to init.sqf
// 0: true or false - Edit mode activation,
// 1: NUMBER - script call delay (where 0 - is mission start). If not passed - runs without delay (before mission start);
[false] execVM "dzn_gear\dzn_gear_init.sqf";

[0.3] execVM "dzn_market\dzn_market_init.sqf";
