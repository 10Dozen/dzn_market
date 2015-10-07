class dzn_market_dialog
{
	idd=-1;
	movingenable=true;
	onLoad = "_this spawn dzn_fnc_market_setPurchaseDialogText"; 
	class controls 
	{		
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by 10Dozen, v1.063, #Wugida)
		////////////////////////////////////////////////////////

		class dzn_market_frame: RscFrame
		{
			idc = 1800;
			x = 0.310417 * safezoneW + safezoneX;
			y = 0.318 * safezoneH + safezoneY;
			w = 0.364583 * safezoneW;
			h = 0.168 * safezoneH;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			style = 1;
		};
		class dzn_market_textbox: RscText
		{
			
			idc = 1100;
			text = ""; //--- ToDo: Localize;
			x = 0.325 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.335417 * safezoneW;
			h = 0.084 * safezoneH;
			
			sizeEx = 0.04;
			style = 530;
			colorBackground[] = {0,0,0,0.8};
		};
		class dzn_market_button_yes: RscButton
		{
			idc = 1600;
			text = "PURCHASE"; //--- ToDo: Localize;
			x = 0.325 * safezoneW + safezoneX;
			y = 0.43 * safezoneH + safezoneY;
			w = 0.0729167 * safezoneW;
			h = 0.028 * safezoneH;
			colorBackground[] = {0,0,0,0.7};
			action = "player call dzn_fnc_market_buttonYes";
		};
		class dzn_market_button_no: RscButton
		{
			idc = 1601;
			text = "CANCEL"; //--- ToDo: Localize;
			x = 0.5875 * safezoneW + safezoneX;
			y = 0.43 * safezoneH + safezoneY;
			w = 0.0729167 * safezoneW;
			h = 0.028 * safezoneH;
			colorBackground[] = {0,0,0,0.7};
			action = "player call dzn_fnc_market_buttonNo";
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};

