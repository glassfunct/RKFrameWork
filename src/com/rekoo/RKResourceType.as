package com.rekoo
{
	public final class RKResourceType
	{
		/** 资源类型：JSON */
		public static const RESOURCE_TYPE_JSON:String = "json";
		/** 资源类型：纯文本 */
		public static const RESOURCE_TYPE_TXT:String = "txt";
		/** 资源类型：XML */
		public static const RESOURCE_TYPE_XML:String = "xml";
		/** 资源类型：二进制文件 */
		public static const RESOURCE_TYPE_BINARY:String = "bin";
		/** 资源类型：Flash影片 */
		public static const RESOURCE_TYPE_SWF:String = "swf";
		/** 资源类型：图片:jpg,jpeg,png,gif */
		public static const RESOURCE_TYPE_IMG:String = "img";
		
		public static function getResourceType(fileName_:String):String
		{
			var _arr:Array = fileName_.split(".");
			
			if ( _arr.length > 1 )
			{
				switch ( _arr[_arr.length - 1] )
				{
					case "json":
						return RESOURCE_TYPE_JSON;
						break;
					case "txt":
						return RESOURCE_TYPE_TXT;
						break;
					case "xml":
						return RESOURCE_TYPE_XML;
						break;
					case "bin":
						return RESOURCE_TYPE_BINARY;
						break;
					case "swf":
						return RESOURCE_TYPE_SWF;
						break;
					case "jpg":
					case "jpeg":
					case "png":
					case "gif":
						return RESOURCE_TYPE_IMG;
						break;
					default:
						return RESOURCE_TYPE_TXT;
						break;
				}
			}
			else
			{
				return RESOURCE_TYPE_BINARY;
			}
		}
	}
}