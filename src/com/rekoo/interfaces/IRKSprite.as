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
		
		function get selectable():Boolean;
		
		function set selectable(value:Boolean):void;
		
		function get onSelected():Function;
		
		function set onSelected(value:Function):void;
		
		function get active():Boolean;
		
		function set active(value:Boolean):void;
		
		/**
		 * 添加滤镜。
		 * @param args BitmapFilter。
		 */		
		function applyFilters(...args):void;
		
		/**
		 * 移除滤镜。
		 * @param args BitmapFilter。
		 */		
		function removeFilters(...args):void;
		
		/**
		 * 返回名称。默认是完整类名。 
		 * @return String。
		 */
		function getName():String;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
	}
}