package com.rekoo.util
{
	import mx.utils.ArrayUtil;

	public final class RKArrayUtil
	{
		public function RKArrayUtil()
		{
		}
		
		/**
		 * 返回某个元素在数组中的位置，从0开始，没有则返回-1。
		 * @param item_ 要检测的元素。
		 * @param source_ 要检测的数组。
		 * @return int。
		 * 
		 */
		public static function getItemIndex(item_:Object, source_:Array):int
		{
			var _i:int = 0;
			
			for each ( var _item:Object in source_ )
			{
				if ( _item == item_ )
				{
					return _i;
				}
				
				_i ++;
			}
			
			return -1;
		}
	}
}