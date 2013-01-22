package com.rekoo
{
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Stage;

	public final class RKFrameWork
	{
		private static var _obj:Object = {};
		
		public function RKFrameWork()
		{
		}
		
		/**
		 * 初始化框架。
		 * @param APP_Width_ 应用宽度。
		 * @param APP_Height_ 应用高度。
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
	}
}