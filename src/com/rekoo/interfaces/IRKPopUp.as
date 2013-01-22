package com.rekoo.interfaces
{
	import flash.display.Bitmap;

	public interface IRKPopUp extends IRKGUI, IRKSprite
	{
		/**
		 * 是否模态显示。 
		 * @return Boolean。
		 * 
		 */	
		function get modal():Boolean;
		
		/**
		 * 是否模态显示。 
		 * @param value Boolean。
		 * 
		 */	
		function set modal(value:Boolean):void;
		
		/**
		 * 是否排队显示。 
		 * @return Boolean。
		 * 
		 */	
		function get queue():Boolean;
		
		/**
		 * 是否排队显示。 
		 * @param value Boolean。
		 * 
		 */	
		function set queue(value:Boolean):void;
	}
}