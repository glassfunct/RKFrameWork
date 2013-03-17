package com.rekoo.interfaces
{
	public interface IRKTooltipSkin
	{
		function set tooltip(value:*):void;
		function get tooltip():*;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function dispose():void;
	}
}