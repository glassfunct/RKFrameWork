package com.rekoo.util
{
	public class RKDateUtil
	{
		public function RKDateUtil()
		{
		}
		
		/**
		 * 字符串转换为日期。
		 * @param str_ "XXXX-XX-XX hh:mm:ss"/"XXXX-XX-XX hh:mm"。
		 * @return Date。
		 * 
		 */		
		public static function fromString(str_:String):Date
		{
			return new Date(str_.replace(/-/g, "/"));
		}
		
		/**
		 * 返回最早的日期。
		 * @param args Date。
		 * @return Date。
		 * 
		 */		
		public static function min(...args):Date
		{
			return null;
		}
		
		/**
		 * 返回最晚的日期。
		 * @param args Date。
		 * @return Date。
		 * 
		 */
		public static function max(...args):Date
		{
			return null;
		}
	}
}