package com.rekoo.interfaces
{
	public interface IRKModule extends IRKSubscriber
	{
		/**
		 * 初始化。注册模块时自动调用。
		 */
		function init():void;
		
		/**
		 * 返回模块名。
		 * @return String。
		 */
		function getModuleName():String;
		
		/**
		 * 接受其他模块的点对点呼叫。
		 * @param protocol_ 协议。
		 * @param args_ 额外参数。
		 * @return Object。
		 * 
		 */		
		function call(protocol_:String, ...args_):Object;
		
		/**
		 * 销毁模块。
		 * 
		 */		
		function dispose():void;
	}
}