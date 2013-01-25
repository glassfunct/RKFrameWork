package com.rekoo
{
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.rekoo.display.layer.RKLayer;
	import com.rekoo.manager.RKLayerManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	public final class RKFrameWork
	{
		private static var _obj:Object = {};
		
		/**
		 * 加载素材时显示的loading图。
		 */		
		public static var resLoadingDis:DisplayObject = null;
		
		/**
		 * http请求时显示的loading图。
		 */
		public static var requestLoadingDis:DisplayObject = null;
		
		/**
		 * 用来显示loading图的容器。
		 */		
		public static var loadingDisContainer:Sprite = null;
		
		/** 静态资源加载允许的最大链接数。 */
		public static var resLoadMaxConnections:int = 5;
		
		/**
		 * 静态资源加载的最大重试次数。
		 */		
		public static var resLoadMaxRetryTimes:int = 3;
		
		/**
		 * http请求的最大重试次数。
		 */		
		public static var httpRequestMaxRetryTimes:int = 3;
		
		public function RKFrameWork()
		{
		}
		
		/**
		 * 初始化框架。
		 * @param requestBaseURL_ 请求根域名。
		 * @param assetsBaseURL_ 素材根目录。
		 * 
		 */		
		public static function init(APPStage_:Stage, requestBaseURL_:String, assetsBaseURL_:String):void
		{
			_obj["APP_Stage"] = APPStage_;
			_obj["request_base_url"] = requestBaseURL_;
			_obj["assets_base_url"] = assetsBaseURL_;
			
			TweenPlugin.activate([TransformAroundPointPlugin, TransformAroundCenterPlugin]);
		}
		
		/**
		 * 应用宽度。
		 * @return Number。
		 * 
		 */		
		public static function get APP_Width():Number
		{
			return _obj["APP_Stage"].stageWidth;
		}
		
		/**
		 * 应用高度。
		 * @return Number。
		 * 
		 */
		public static function get APP_Height():Number
		{
			return _obj["APP_Stage"].stageHeight;
		}
		
		/**
		 * 应用的舞台。
		 * @return Stage。
		 * 
		 */
		public static function get APP_Stage():Stage
		{
			return _obj["APP_Stage"];
		}
		
		/**
		 * 请求根域名。
		 * @return String。
		 * 
		 */
		public static function get requestBaseURL():String
		{
			return _obj["request_base_url"];
		}
		
		/**
		 * 素材根目录。
		 * @return String。
		 * 
		 */
		public static function get assetsBaseURL():String
		{
			return _obj["assets_base_url"];
		}
		
		/**
		 * 注册Layer。
		 */		
		public static function registerLayer(layer_:RKLayer):void
		{
			APP_Stage.addChild(layer_);
			RKLayerManager.instance.registerLayer(layer_);
		}
	}
}