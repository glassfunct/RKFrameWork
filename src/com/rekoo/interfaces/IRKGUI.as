package com.rekoo.interfaces
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public interface IRKGUI extends IRKSprite
	{
		/**
		 * 显示。 
		 * 
		 */
		function show():void;
		
		/**
		 * 隐藏。 
		 * 
		 */
		function hide():void;
		
		/**
		 * 返回GUI名称。默认是完整类名。 
		 * @return String。
		 * 
		 */
		function getName():String;
		
		/**
		 * 返回所在的层。
		 * @return String。
		 * 
		 */
		function getLayer():String;
	}
}