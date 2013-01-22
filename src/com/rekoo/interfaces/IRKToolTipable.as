package com.rekoo.interfaces
{
	/**
	 * 实现此接口的显示对象类可实现鼠标移入显示ToolTip，鼠标移出隐藏ToolTip的功能。
	 * @author Administrator
	 * 
	 */	
	public interface IRKToolTipable
	{
		/**
		 * toolTip内容。
		 * @param value Object。
		 * 
		 */		
		function set toolTip(value:Object):void
		
		/**
		 * toolTip内容。
		 * @return value Object。
		 * 
		 */	
		function get toolTip():Object;
		
		/**
		 * toolTip皮肤。
		 * @param value IRKToolTip。
		 * 
		 */		
		function set toolTipSkin(value:IRKToolTipSkin):void;
		
		/**
		 * toolTip皮肤。
		 * @return value IRKToolTip。
		 * 
		 */	
		function get toolTipSkin():IRKToolTipSkin;
		
		/**
		 * toolTip对齐方式。
		 * @return String。
		 * 
		 */		
		function get toolTipAlign():String;
		
		/**
		 * toolTip对齐方式。
		 * @param value String。
		 * 
		 */	
		function set toolTipAlign(value:String):void
		
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