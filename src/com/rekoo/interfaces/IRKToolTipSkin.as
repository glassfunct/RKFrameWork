package com.rekoo.interfaces
{
	public interface IRKToolTipSkin
	{
		function set data(value:Object):void;
		function get data():Object;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function dispose():void;
	}
}