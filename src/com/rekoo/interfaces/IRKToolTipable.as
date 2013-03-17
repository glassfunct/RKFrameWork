package com.rekoo.interfaces
{
	/**
	 * 实现此接口的显示对象类可实现鼠标移入显示ToolTip，鼠标移出隐藏ToolTip的功能。
	 * @author Administrator
	 * 
	 */	
	public interface IRKTooltipable
	{
		/**
		 * tooltip内容。
		 * @param value *。
		 * 
		 */		
		function set tooltip(value:*):void
		
		/**
		 * tooltip内容。
		 * @return value Object。
		 * 
		 */	
		function get tooltip():*;
		
		/**
		 * toolTip皮肤。
		 * @param value IRKToolTip。
		 * 
		 */		
		function set tooltipSkin(value:IRKTooltipSkin):void;
		
		/**
		 * toolTip皮肤。
		 * @return value IRKToolTip。
		 * 
		 */	
		function get tooltipSkin():IRKTooltipSkin;
		
		/**
		 * toolTip对齐方式。
		 * @return String。
		 * 
		 */		
		function get tooltipAlign():String;
		
		/**
		 * toolTip对齐方式。
		 * @param value String。
		 * 
		 */	
		function set tooltipAlign(value:String):void
		
		/**
		 * 销毁。 
		 * 
		 */
		function dispose():void;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
		function hasEventListener(type:String):Boolean;
		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean;
	}
}