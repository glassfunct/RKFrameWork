package com.rekoo.remoting
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * Http请求。
	 * @author Administrator
	 * 
	 */	
	public class RKHttpRequest
	{
		private var _urlLoader:URLLoader = new URLLoader();
		private var _urlRequest:URLRequest = new URLRequest();
		
		private var _onResult:Function = null;
		private var _onFault:Function = null;
		
		/**
		 * Http请求。
		 * @param URL_ 请求地址。
		 * @param params_ 请求参数。
		 * @param mathod_ GET/POST。
		 */		
		public function RKHttpRequest(URL_:String, params_:Object = null, method_:String = "POST")
		{
			_urlRequest.url = URL_;
			
			if ( params_ )
			{
				var _var:URLVariables = new URLVariables();
				
				for ( var _key:String in params_ )
				{
					_var[_key] = params_[_key];
				}
				
				_urlRequest.data = _var;
			}
			
			_urlRequest.method = method_;
		}
		
		/**
		 * 执行Http请求。
		 * @param onResult_ 成功的回调，参数：RKHttpRequest。
		 * @param onFault_ 失败的回调，参数：RKHttpRequest。
		 */		
		public function send(onResult_:Function = null, onFault_:Function = null):void
		{
			_onResult = onResult_;
			_onFault = _onFault;
			
			_urlLoader.addEventListener(Event.COMPLETE, onResultHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaultHandler);
			_urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onFaultHandler);
			_urlLoader.load(_urlRequest);
		}
		
		private function onResultHandler(evt_:Event):void
		{
			clearEvent();
			
			onResult(data);
		}
		
		/**
		 * 请求成功。
		 * @param data_ 请求的返回值。
		 * 
		 */		
		protected function onResult(data_:Object):void
		{
			if ( _onResult != null )
			{
				_onResult(data_);
			}
		}
		
		private function onFaultHandler(evt_:Event):void
		{
			clearEvent();
			
			onFault(data);
		}
		
		/**
		 * 请求失败。
		 * @param data_ 请求的返回值。
		 * 
		 */		
		protected function onFault(data_:Object):void
		{
			if ( _onFault != null )
			{
				_onFault(data_);
			}
		}
		
		private function clearEvent():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, onResultHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaultHandler);
			_urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onFaultHandler);
		}
		
		/**
		 * 返回值。
		 * @return *。
		 */		
		public function get data():*
		{
			return _urlLoader.data;
		}
		
		/**
		 * 请求地址。
		 * @return String。
		 */		
		public function get URL():String
		{
			return _urlRequest.url;
		}
		
		/**
		 * 请求地址。
		 * @param value String。
		 */		
		public function set URL(value:String):void
		{
			_urlRequest.url = value;
		}
		
		/**
		 * 请求参数。
		 * @return Object。
		 */		
		public function get params():Object
		{
			return _urlRequest.data;
		}
		
		/**
		 * 请求参数。
		 * @param value Object。
		 */		
		public function set params(value:Object):void
		{
			_urlRequest.data = value;
		}
	}
}