package com.rekoo.interfaces
{
	public interface IRKTimerTicker
	{
		/**
		 * 心跳动作反馈。
		 * 
		 */		
		function tick():void;
		
		/**
		 * 心跳步长。
		 * @return int。
		 * 
		 */		
		function get interval():int;
		
		/**
		 * 心跳步长。
		 * @param value int。
		 * 
		 */	
		function set interval(value:int):void;
	}
}