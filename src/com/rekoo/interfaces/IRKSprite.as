package com.rekoo.interfaces
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public interface IRKSprite
	{
		/**
		 * 皮肤。
		 * @return DisplayObject。 
		 * 
		 */		
		function get skin():DisplayObject;
		
		/**
		 * 皮肤。
		 * @param value DisplayObject。
		 * 
		 */		
		function set skin(value:DisplayObject):void;
		
		/**
		 * <b>皮肤显示后进行初始化。</b>
		 * 
		 */
		function initView():void;
		
		/**
		 * 销毁。 
		 * 
		 */
		function dispose():void;
		
		function get enabled():Boolean;
		
		function set enabled(value:Boolean):void;
		
		function get selected():Boolean;
		
		function set selected(value:Boolean):void;
		
		/**
		 * 返回位图。
		 * @param refresh_ 是否重新绘制。
		 * @return Bitmap。
		 * 
		 */		
		function getCapture(refresh_:Boolean = true):Bitmap;
	}
}