package com.rekoo.manager
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.RKResourceType;
	import com.rekoo.event.RKResourceEvent;
	import com.rekoo.interfaces.IRKBaseLoader;
	import com.rekoo.interfaces.IRKFrameTicker;
	import com.rekoo.remoting.RKResourceLoader;
	import com.rekoo.remoting.RKResourceURLLoader;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 素材管理器。
	 * @author Administrator
	 * 
	 */	
	public final class RKResourceManager extends EventDispatcher implements IRKFrameTicker
	{
		public static const USE_APPLICATION_DOMAIN:Boolean = true;
		
		/* 影响加载进度的所有文件的数量。 */
		private var _totalFilesInProgress:int = 0;
		/* 影响加载进度的未加载完成的文件的数量。 */
		private var _noLoadFilesInProgress:int = 0;
		
		/* 影响加载进度且需要显示加载图的所有文件的数量。 */
		private var _totalSLFilesInProgress:int = 0;
		/* 影响加载进度且需要显示加载图的未加载完成的文件的数量。 */
		private var _noLoadSLFilesInProgress:int = 0;
		
		/* 所用到的域列表。 */
		private var _domains:Vector.<ApplicationDomain> = new Vector.<ApplicationDomain>();
		/* 已加载的素材。 */
		private var _resDic:Object = {};
		
		/* 正在加载的Loader。 */
		private var _resLoadingLoader:Vector.<IRKBaseLoader> = new Vector.<IRKBaseLoader>();
		
		/* 正在加载的素材URL。 */
		private var _resLoadingURL:Vector.<Object> = new Vector.<Object>();
		/* 待加载的素材URL。 */
		private var _resToLoadURL:Vector.<Object> = new Vector.<Object>();
		
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
		 * @param binaryMode_ 是否加载为二进制数组。
		 * @param onComplete_ 加载成功的回调函数。
		 * @param onFault_ 加载失败的回调函数。
		 * @param effectLoadingPer_ 是否影响加载进度。
		 * @param showLoading_ 是否显示loading图（需和effectLoadingPer_配合使用，effectLoadingPer_为false时，showLoading_无效）。
		 */		
		public function loadNow(url_:String, binaryMode_:Boolean = false, onComplete_:Function = null, onFault_:Function = null, effectLoadingPer_:Boolean = true, showLoading_:Boolean = true):void
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
				startLoad(url_, binaryMode_, onComplete_, onFault_, showLoading_);
			}
		}
		
		/**
		 * 正常加载。若当前正在加载的素材数量已达最大连接数，则放入待加载队列中。
		 * @param url_ 素材URL。
		 * @param binaryMode_ 是否加载为二进制数组。
		 * @param onComplete_ 加载成功的回调函数。
		 * @param onFault_ 加载失败的回调函数。
		 * @param effectLoadingPer_ 是否影响加载进度。
		 * @param showLoading_ 是否显示loading图（需和effectLoadingPer_配合使用，effectLoadingPer_为false时，showLoading_无效）。
		 */
		public function load(url_:String, binaryMode_:Boolean = false, onComplete_:Function = null, onFault_:Function = null, effectLoadingPer_:Boolean = true, showLoading_:Boolean = true):void
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
				if ( _resLoadingURL.length < RKFrameWork.resLoadMaxConnections )
				{
					startLoad(url_, binaryMode_, onComplete_, onFault_, effectLoadingPer_, showLoading_);
				}
				else
				{
					delayLoad(url_, binaryMode_, onComplete_, onFault_, effectLoadingPer_, showLoading_);
				}
			}
		}
		
		private function startLoad(url_:String, binaryMode_:Boolean = false, onComplete_:Function = null, onFault_:Function = null, effectLoadingPer_:Boolean = true, showLoading_:Boolean = true):void
		{
			if ( _resDic.hasOwnProperty(url_) )
			{
				if ( onComplete_ != null )
				{
					onComplete_();
				}
				
				this.loadSingleCompleteHandler(url_);
				return;
			}
			
			if ( effectLoadingPer_ )
			{
				_totalFilesInProgress ++;
				_noLoadFilesInProgress ++;
				
				if ( showLoading_ )
				{
					_totalSLFilesInProgress ++;
					_noLoadSLFilesInProgress ++;
				}
			}
			
			//trace("开始加载:", url_);
			
			_resLoadingURL.push({"url":url_, "bin_mode":binaryMode_, "complete":onComplete_, "fault":onFault_, "effectLoadingPer":effectLoadingPer_, "showLoading":showLoading_});
			
			var _resType:String = binaryMode_ ? RKResourceType.RESOURCE_TYPE_BINARY : RKResourceType.getResourceType(url_);
			
			if ( (_resType == RKResourceType.RESOURCE_TYPE_SWF || _resType == RKResourceType.RESOURCE_TYPE_IMG) )
			{
				var _loader:RKResourceLoader = new RKResourceLoader(url_, getResHashedURL(url_), effectLoadingPer_, showLoading_);
				
				_loader.execute(loadSingleCompleteHandler, loadSingleFaultHandler, null, USE_APPLICATION_DOMAIN ? new LoaderContext(false, ApplicationDomain.currentDomain) : null);
				
				_resLoadingLoader.push(_loader);
			}
			else
			{
				var _urlLoader:RKResourceURLLoader = new RKResourceURLLoader(url_, getResHashedURL(url_), effectLoadingPer_, showLoading_);
				
				_urlLoader.execute(loadSingleCompleteHandler, loadSingleFaultHandler, binaryMode_);
				
				_resLoadingLoader.push(_urlLoader);
			}
			
			if ( showLoading_ && effectLoadingPer_ && RKFrameWork.loadingDisContainer != null && RKFrameWork.resLoadingDis != null )
			{
				if ( !RKFrameWork.loadingDisContainer.contains(RKFrameWork.resLoadingDis) )
				{
					RKFrameWork.loadingDisContainer.addChild(RKFrameWork.resLoadingDis);
					updateLoadingDisPos(null);
					RKFrameWork.APP_Stage.addEventListener(Event.RESIZE, updateLoadingDisPos);
				}
				
				RKFrameTickerManager.instance.register(this);
			}
		}
		
		private function delayLoad(url_:String, binaryMode_:Boolean = false,  onComplete_:Function = null, onFault_:Function = null, effectLoadingPer_:Boolean = true, showLoading_:Boolean = true):void
		{
			if ( effectLoadingPer_ )
			{
				_totalFilesInProgress ++;
				_noLoadFilesInProgress ++;
				
				if ( showLoading_ )
				{
					_totalSLFilesInProgress ++;
					_noLoadSLFilesInProgress ++;
				}
			}
			
			//trace("准备加载:", url_);
			
			_resToLoadURL.push({"url":url_, "bin_mode":binaryMode_, "complete":onComplete_, "fault":onFault_, "effectLoadingPer":effectLoadingPer_, "showLoading":showLoading_});
		}
		
		private function loadSingleCompleteHandler(target_:*):void
		{
			var _urlObj:Object = null;
			
			if ( target_ is IRKBaseLoader )
			{
				if ( target_.resourceType == RKResourceType.RESOURCE_TYPE_SWF )
				{
					if ( _domains.indexOf(target_.contentLoaderInfo.applicationDomain) == -1 )
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
						if ( _resLoadingURL[_i]["complete"] != null )
						{
							_resLoadingURL[_i]["complete"]();
						}
						
						if ( _resLoadingURL[_i]["effectLoadingPer"] )
						{
							_noLoadFilesInProgress --;
							
							if ( _resLoadingURL[_i]["showLoading"] )
							{
								_noLoadSLFilesInProgress --;
							}
						}
						
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
			}
			else
			{
				_urlObj = target_;
			}
			
			dispatchEvent(new RKResourceEvent(RKResourceEvent.EVENT_COMPLETE_SINGLE_FILE, String(_urlObj)));
			
			if ( _resLoadingURL.length < RKFrameWork.resLoadMaxConnections && _resToLoadURL.length > 0 )
			{
				_urlObj = _resToLoadURL.shift();
				startLoad(_urlObj["url"], _urlObj["bin_mode"], _urlObj["complete"], _urlObj["fault"], _urlObj["effectLoadingPer"], _urlObj["showLoading"]);
			}
			
			if ( _resLoadingURL.length == 0 && _resToLoadURL.length == 0 )
			{
				//trace("资源队列全部加载完成");
				_totalFilesInProgress = 0;
				_totalSLFilesInProgress = 0;
				_noLoadFilesInProgress = 0;
				_noLoadSLFilesInProgress = 0;
				dispatchEvent(new RKResourceEvent(RKResourceEvent.EVENT_COMPLETE_ALL));
			}
		}
		
		private function loadSingleFaultHandler(target_:*):void
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
			trace("-------------------------------------------------------------------------");
			trace("get resource class:", definitionName_);
			
			var CLS:Class = null;
			
			for each ( var _domain:ApplicationDomain in _domains )
			{
				if ( _domain.hasDefinition(definitionName_) )
				{
					trace("success");
					CLS = _domain.getDefinition(definitionName_) as Class;
					break;
				}
			}
			
			if ( CLS == null )
			{
				trace("fail");
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
		 * 所有影响加载进度的资源加载百分比（0--1）。
		 * @return Number。
		 */		
		public function get loadingPercent():Number
		{
			if ( _totalFilesInProgress == 0 )
			{
				return 1;
			}
			
			var loadingPercent:Number = 0;
			
			for each (var _loader:IRKBaseLoader in _resLoadingLoader)
			{
				if ( _loader.effectLoadingPer )
				{
					loadingPercent += _loader.percent;
				}
			}
			
			return ((_totalFilesInProgress - _noLoadFilesInProgress) + loadingPercent) / _totalFilesInProgress;
		}
		
		/**
		 * 所有影响加载进度且显示加载图的资源加载百分比（0--1）。
		 * @return Number。
		 */		
		public function get loadingPercentSL():Number
		{
			if ( _totalSLFilesInProgress == 0 )
			{
				return 1;
			}
			
			var loadingPercent:Number = 0;
			
			for each (var _loader:IRKBaseLoader in _resLoadingLoader)
			{
				if ( _loader.showLoading && _loader.effectLoadingPer )
				{
					loadingPercent += _loader.percent;
				}
			}
			
			return ((_totalSLFilesInProgress - _noLoadSLFilesInProgress) + loadingPercent) / _totalSLFilesInProgress;
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
		
		/**
		 * 返回指定资源url的哈希映射。
		 * @param url_ 资源URL。
		 * @return 哈希映射。
		 * 
		 */		
		public function getResHashedURL(url_:String):String
		{
			if ( _hashMap.hasOwnProperty(url_) )
			{
				return RKFrameWork.assetsBaseURL + _hashMap[url_];
			}
			
			return RKFrameWork.assetsBaseURL + url_;
		}
		
		public function tick():void
		{
			var _progress:Number = loadingPercentSL;
			
			if ( _progress >= 1.0 && _noLoadSLFilesInProgress == 0 )
			{
				RKFrameTickerManager.instance.unregister(this);
				RKFrameWork.APP_Stage.removeEventListener(Event.RESIZE, updateLoadingDisPos);
				
				if ( RKFrameWork.loadingDisContainer != null && RKFrameWork.resLoadingDis != null )
				{
					if ( RKFrameWork.loadingDisContainer.contains(RKFrameWork.resLoadingDis) )
					{
						RKFrameWork.loadingDisContainer.removeChild(RKFrameWork.resLoadingDis);
					}
					
					RKFrameWork.loadingDisContainer.graphics.clear();
				}
				
				return;
			}
			
			if ( RKFrameWork.resLoadingDis.hasOwnProperty("pLabel") )
			{
				RKFrameWork.resLoadingDis["pLabel"].text = (int(_progress * 100) + "%");
			}
		}
		
		private function updateLoadingDisPos(evt_:Event):void
		{
			RKFrameWork.resLoadingDis.x = RKFrameWork.APP_Width / 2;
			RKFrameWork.resLoadingDis.y = RKFrameWork.APP_Height / 2;
			RKFrameWork.loadingDisContainer.graphics.clear();
			RKFrameWork.loadingDisContainer.graphics.beginFill(0x000000, 0.4);
			RKFrameWork.loadingDisContainer.graphics.drawRect(0, 0, RKFrameWork.APP_Width, RKFrameWork.APP_Height);
			RKFrameWork.loadingDisContainer.graphics.endFill();
		}
	}
}

class SingletonEnforcer{}