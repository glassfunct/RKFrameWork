package com.rekoo.interfaces{	/**	 * 订阅者必须实现此接口,即可成为消息的接收者。	 * @author Administrator	 * 	 */		public interface IRKSubscriber	{				/**		 * 消息订阅者的响应。		 * @param protocol_ 协议。		 * @param args_ 额外参数。		 * 		 */				function notify(protocol_:String, ...args):void	}}