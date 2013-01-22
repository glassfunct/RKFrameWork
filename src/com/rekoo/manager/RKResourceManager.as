package com.rekoo.manager
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.RKResourceType;
	import com.rekoo.event.RKResourceEvent;
	import com.rekoo.remoting.RKResourceLoader;
	import com.rekoo.remoting.RKResourceURLLoader;
	import com.rekoo.util.RKArrayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 素材管理器。
	 * @author Administrator
	 * 
	 */	
	public final class RKResourceManager extends EventDispatcher
	{
		/** 允许的最大链接数 */
		public static const MAX_CONNECTIONS:int = 1;
		
		public static const USE_APPLICATION_DOMAIN:Boolean = true;
		
		/* 影响加载进度的所有文件的数量。 */
		private var _totalFilesInProgress:int = 0;
		/* 影响加载进度的未加载文件的数量。 */
		private var _noLoadFilesInProgress:int = 0;
		
		/* 所用到的域列表。 */
		private var _domains:Array = [];
		/* 已加载的素材。 */
		private var _resDic:Object = {};
		
		/* 正在加载的Loader。 */
		private var _resLoadingLoader:Array = [];
		
		/* 正在加载的素材URL。 */
		private var _resLoadingURL:Array = [];
		/* 待加载的素材URL。 */
		private var _resToLoadURL:Array = [];
		
		/* 资源哈希映射表。 */
		private var _hashMap:Object = {};
		
		private static var _instance:RKResourceManager = null;
		
		public function RKResourceManager(singletonEnforcer_:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():RKResourceManager
		{
			if ( _instance == null )
			{
				_instance = new RKResourceManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		/**
		 * 是否正在加载（在待加载队列中也算正在加载）。
		 * @param url_ 素材URL。
		 * @return Boolean。
		 * 
		 */		
		public function isLoading(url_:String):Boolean
		{
			var _urlObj:Object = null;
			
			for each ( _urlObj in _resLoadingURL )
			{
				if ( _urlObj["url"] == url_ )
				{
					return true;
				}
			}
			
			for each ( _urlObj in _resToLoadURL )
			{
				if ( _urlObj["url"] == url_ )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 是否加载完成。
		 * @param url_ 素材URL。
		 * @return Boolean。
		 * 
		 */		
		public function isLoaded(url_:String):Boolean
		{
			return _resDic.hasOwnProperty(url_);
		}
		
		/**
		 * 立即加载（无视最大连接数，马上加载）。
		 * @param url_ 素材URL。
		 * 
		 */		
		public function loadNow(url_:String, binaryMode_:Boolean = false):void
		{
			if ( isLoading(url_) )
			{
				throw new Error("资源已在加载中！");
			}
			else if ( isLoaded(url_) )
			{
				throw new Error("资源已存在！");
			}
			else
			{
				startLoad(url_);
			}
			
			_totalFilesInProgress ++;
			_noLoadFilesInProgress ++;
		}
		
		/**
		 * 正常加载。若当前正在加载的素材数量已达最大连接数，则放入待加载队列中。
		 * @param url_ 素材URL。
		 * @param binaryMode_ 是否加载为二进制数组。
		 */		
		public function load(url_:String, binaryMode_:Boolean = false):void
		{
			if ( isLoading(url_) )
			{
				throw new Error("资源已在加载中！");
			}
			else if ( isLoaded(url_) )
			{
				throw new Error("资源已存在！");
			}
			else
			{
				if ( _resLoadingURL.length < MAX_CONNECTIONS )
				{
					startLoad(url_, binaryMode_);
				}
				else
				{
					delayLoad(url_, binaryMode_);
				}
			}
			
			_totalFilesInProgress ++;
			_noLoadFilesInProgress ++;
		}
		
		private function startLoad(url_:String, binaryMode_:Boolean = false):void
		{
			//trace("开始加载:", url_);
			
			_resLoadingURL.push({"url":url_, "bin_mode":binaryMode_});
			
			var _resType:String = binaryMode_ ? RKResourceType.RESOURCE_TYPE_BINARY : RKResourceType.getResourceType(url_);
			
			if ( (_resType == RKResourceType.RESOURCE_TYPE_SWF || _resType == RKResourceType.RESOURCE_TYPE_IMG) )
			{
				var _loader:RKResourceLoader = new RKResourceLoader(url_, getHashedURL(url_));
				
				_loader.execute(loadSingleCompleteHandler, loadErr, null, USE_APPLICATION_DOMAIN ? new LoaderContext(false, ApplicationDomain.currentDomain) : null);
				
				_resLoadingLoader.push(_loader);
			}
			else
			{
				var _urlLoader:RKResourceURLLoader = new RKResourceURLLoader(url_, getHashedURL(url_));
				
				if ( binaryMode_ )
				{
					_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				}
				
				_urlLoader.execute(loadSingleCompleteHandler, loadErr);
				
				_resLoadingLoader.push(_urlLoader);
			}
		}
		
		private function delayLoad(url_:String, binaryMode_:Boolean = false):void
		{
			//trace("准备加载:", url_);
			
			_resToLoadURL.push({"url":url_, "bin_mode":binaryMode_});
		}
		
		private function loadSingleCompleteHandler(target_:*):void
		{
			var _urlObj:Object = null;
			
			if ( target_.resourceType == RKResourceType.RESOURCE_TYPE_SWF )
			{
				if ( RKArrayUtil.getItemIndex(target_.contentLoaderInfo.applicationDomain, _domains) == -1 )
				{
					_domains.push(target_.contentLoaderInfo.applicationDomain);
				}
				
				_resDic[target_.baseURL] = target_.content;
			}
			else if ( target_.resourceType == RKResourceType.RESOURCE_TYPE_IMG ) 
			{
				_resDic[target_.baseURL] = target_.content.bitmapData.clone();
				(target_ as RKResourceLoader).unloadAndStop();
			}
			else
			{
				_resDic[target_.baseURL] = target_.data;
			}
			
			_urlObj = target_.baseURL;
			
			for ( var _i:int = 0; _i < _resLoadingURL.length; _i ++ )
			{
				if ( _urlObj == _resLoadingURL[_i]["url"] )
				{
					_resLoadingURL.splice(_i, 1);
					_resLoadingLoader.splice(_i, 1);
					break;
				}
			}
			
			//trace("加载完成:",_urlObj);
			
			if ( target_ is RKResourceLoader )
			{
				(target_ as RKResourceLoader).unloadAndStop();
			}
			
			_noLoadFilesInProgress --;
			
			dispatchEvent(new RKResourceEvent(RKResourceEvent.EVENT_COMPLETE_SINGLE_FILE, String(_urlObj)));
			
			if ( _resLoadingURL.length < MAX_CONNECTIONS && _resToLoadURL.length )
			{
				_urlObj = _resToLoadURL.shift();
				startLoad(_urlObj["url"], _urlObj["bin_mode"]);
			}
			
			if ( _resLoadingURL.length == 0 && _resToLoadURL.length == 0 )
			{
				//trace("资源队列全部加载完成");
				
				dispatchEvent(new RKResourceEvent(RKResourceEvent.EVENT_COMPLETE_ALL));
			}
		}
		
		private function loadErr(evt_:*):void
		{
			
		}
		
		/**
		 * 获取可视化资源的导出类。
		 * @param definitionName_ 导出类的完全类名。
		 * @return Class。
		 * 
		 */		
		public function getResourceClass(definitionName_:String):Class
		{
			var CLS:Class = null;
			
			for each ( var _domain:ApplicationDomain in _domains )
			{
				if ( _domain.hasDefinition(definitionName_) )
				{
					CLS = _domain.getDefinition(definitionName_) as Class;
					break;
				}
			}
			
			return CLS;
		}
		
		/**
		 * 获取位图资源。
		 * @param url_ 资源URL。
		 * @return 克隆后的资源副本。
		 * 
		 */		
		public function getBitmapData(url_:String):BitmapData
		{
			var _bitmapData:BitmapData = _resDic[url_];
			
			if ( _bitmapData )
			{
				return _bitmapData.clone();
			}
			
			return null;
		}
		
		/**
		 * 获取一个缓存后的资源，不会进行克隆。
		 * @param URL_ 资源URL。
		 * @return 资源。
		 * 
		 */		
		public function getResource(URL_:String):*
		{
			return _resDic[URL_];
		}
		
		/**
		 * 资源加载百分比（0--1）。
		 * @return Number。
		 * 
		 */		
		public function get loadingPercent():Number
		{
			if ( _totalFilesInProgress == 0 )
			{
				return 1;
			}
			
			var loadingPercent:Number = 0;
			
			for each (var _loader:Object in _resLoadingLoader)
			{
				loadingPercent += _loader.percent;
			}
			
			return ((_totalFilesInProgress - _noLoadFilesInProgress) + loadingPercent) / _totalFilesInProgress;
		}
		
		/**
		 * 克隆一个以二进制方式加载的可视化资源。
		 * @param ba_ 二进制数组。
		 * @param result_ 克隆完成回调函数。
		 * @param fault_ 克隆失败回调函数。
		 */		
		public function cloneVisualResourceFromBinary(ba_:ByteArray, result_:Function, fault_:Function = null):void
		{
			var _loader:RKResourceLoader = new RKResourceLoader(null);
			_loader.execute(result_, fault_, ba_);
		}
		
		/**
		 * 资源哈希映射表。
		 * @return Object。
		 */		
		public function get hashMap():Object
		{
			return _hashMap;
		}

		/**
		 * 资源哈希映射表。
		 * @param value。
		 * 
		 */		
		public function set hashMap(value:Object):void
		{
			_hashMap = value;
		}
		
		private function getHashedURL(url_:String):String
		{
			if ( _hashMap.hasOwnProperty(url_) )
			{
				return RKFrameWork.assetsBaseURL + _hashMap[url_];
			}
			
			return RKFrameWork.assetsBaseURL + url_;
		}
	}
}

class SingletonEnforcer{}