package com.rekoo.remoting
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.interfaces.IRKSprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Http请求。
	 * @author Administrator
	 * 
	 */	
	public class RKHttpRequest
	{
		public static var requestVect:Vector.<RKHttpRequest> = new Vector.<RKHttpRequest>();
		
		private var _urlLoader:URLLoader = new URLLoader();
		private var _urlRequest:URLRequest = new URLRequest();
		
		private var _onResult:Function = null;
		private var _onFault:Function = null;
		
		private var _showLoading:Boolean = false;
		
		private var _retryTimes:int = 0;
		private var _curRetryTimes:int = 0;
		
		private var _loadingContainer:DisplayObjectContainer = null;
		private var _loadingMC:DisplayObject = null;
		
		private var _inProcess:Boolean = false;
		
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
		 * @param showLoading_ 是否显示loading图。
		 * @param loadingContainer_ 显示loading图的容器（若容器实现了IRKSprite接口，则在加载过程中其active属性为false，加载完成后变为true）。
		 */		
		public function send(onResult_:Function = null, onFault_:Function = null, showLoading_:Boolean = true, loadingContainer_:DisplayObjectContainer = null):void
		{
			_inProcess = true;
			
			if ( RKHttpRequest.requestVect.indexOf(this) == -1 )
			{
				RKHttpRequest.requestVect.push(this);
			}
			
			_showLoading = showLoading_;
			_retryTimes = RKFrameWork.httpRequestMaxRetryTimes;
			
			_onResult = onResult_;
			_onFault = _onFault;
			
			_urlLoader.addEventListener(Event.COMPLETE, onResultHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaultHandler);
			_urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onFaultHandler);
			_urlLoader.load(_urlRequest);
			_curRetryTimes ++;
			
			if ( showLoading )
			{
				_loadingContainer = loadingContainer_;
				sl();
			}
		}
		
		private function onResultHandler(evt_:Event):void
		{
			clearEvent();
			
			finish();
			
			onResult(data);
		}
		
		/**
		 * 请求成功。
		 * @param data_ 请求的返回值。
		 * 
		 */		
		protected function onResult(data_:*):void
		{
			if ( _onResult != null )
			{
				_onResult(data_);
			}
		}
		
		private function onFaultHandler(evt_:Event):void
		{
			clearEvent();
			
			if ( _curRetryTimes < _retryTimes )
			{
				send(_onResult, _onFault, showLoading, loadingContainer);
			}
			else
			{
				finish();
				onFault(data);
			}
		}
		
		private function finish():void
		{
			_curRetryTimes = 0;
			
			var _index:int = RKHttpRequest.requestVect.indexOf(this);
			
			if ( _index != -1 )
			{
				RKHttpRequest.requestVect.splice(_index, 1);
			}
			
			if ( showLoading )
			{
				hl();
				_loadingContainer = null;
			}
			
			_inProcess = false;
		}
		
		/**
		 * 请求失败。
		 * @param data_ 请求的返回值。
		 * 
		 */		
		protected function onFault(data_:*):void
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
		
		/**
		 * 是否显示加载图。
		 * @return Boolean。
		 * 
		 */		
		public function get showLoading():Boolean
		{
			return _showLoading;
		}
		
		/**
		 * 显示loading动画。
		 */		
		private function sl():void
		{
			if ( _loadingContainer != null )
			{
				if ( _loadingContainer is IRKSprite )
				{
					(_loadingContainer as IRKSprite).active = false;
				}
				else
				{
					//_loadingContainer.mouseChildren = false;
				}
				
				if ( _loadingMC == null )
				{
					var _cls:Class = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName(RKFrameWork.requestLoadingDis)) as Class;
					_loadingMC = new _cls() as DisplayObject;
					_loadingMC.x = (_loadingContainer.width - _loadingMC.width) / 2;
					_loadingMC.y = (_loadingContainer.height - _loadingMC.height) / 2;
				}
				
				if ( !_loadingContainer.contains(_loadingMC) )
				{
					_loadingContainer.addChild(_loadingMC);
				}
			}
			else
			{
				if ( RKFrameWork.loadingDisContainer != null && RKFrameWork.requestLoadingDis != null )
				{
					if ( !RKFrameWork.loadingDisContainer.contains(RKFrameWork.requestLoadingDis) )
					{
						RKFrameWork.loadingDisContainer.addChild(RKFrameWork.requestLoadingDis);
						updateLoadingDisPos(null);
					}
					
					RKFrameWork.APP_Stage.addEventListener(Event.RESIZE, updateLoadingDisPos);
				}
			}
		}
		
		public function get loadingContainer():DisplayObjectContainer
		{
			return _loadingContainer;
		}
		
		private function hl():void
		{
			var _flag:Boolean = false;
			
			for each ( var _request:RKHttpRequest in RKHttpRequest.requestVect )
			{
				if ( _request.showLoading && _request.loadingContainer == null )
				{
					_flag = true;
					break;
				}
			}
			
			if ( _loadingContainer )
			{
				_loadingContainer.removeChild(_loadingMC);
				
				if ( _loadingContainer is IRKSprite )
				{
					(_loadingContainer as IRKSprite).active = true;
				}
				else
				{
					//_loadingContainer.mouseChildren = true;
				}
				
				_loadingContainer = null;
			}
			
			if ( !_flag )
			{
				RKFrameWork.APP_Stage.removeEventListener(Event.RESIZE, updateLoadingDisPos);
				
				if ( RKFrameWork.loadingDisContainer != null && RKFrameWork.requestLoadingDis != null )
				{
					if ( RKFrameWork.loadingDisContainer.contains(RKFrameWork.requestLoadingDis) )
					{
						RKFrameWork.loadingDisContainer.removeChild(RKFrameWork.requestLoadingDis);
					}
					
					if ( RKFrameWork.loadingDisContainer.numChildren == 0 )
					{
						RKFrameWork.loadingDisContainer.graphics.clear();
					}
				}
			}
		}
		
		private static function updateLoadingDisPos(evt_:Event):void
		{
			RKFrameWork.requestLoadingDis.x = RKFrameWork.APP_Width / 2;
			RKFrameWork.requestLoadingDis.y = RKFrameWork.APP_Height / 2;
			RKFrameWork.loadingDisContainer.graphics.clear();
			RKFrameWork.loadingDisContainer.graphics.beginFill(0x000000, 0.4);
			RKFrameWork.loadingDisContainer.graphics.drawRect(0, 0, RKFrameWork.APP_Width, RKFrameWork.APP_Height);
			RKFrameWork.loadingDisContainer.graphics.endFill();
		}

		/**
		 * 是否正在加载。
		 */
		public function get inProcess():Boolean
		{
			return _inProcess;
		}

	}
}