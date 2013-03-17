package com.rekoo.util
{
	public class RKObjectUtil
	{
		public function RKObjectUtil()
		{
		}
		
		/**
		 * 比较两个Object的结构和内容是否相同。
		 * @param obj1_ Object。
		 * @param obj2_ Object。
		 * @return 两个Object的结构和内容是否相同。
		 * 
		 */		
		public static function equals(obj1_:Object, obj2_:Object):Boolean
		{
			_comRes = true;
			
			dcm(obj1_, obj2_);
			
			return _comRes;
		}
		
		private static var _comRes:Boolean = false;
		
		private static function dcm(obj1_:Object, obj2_:Object):void
		{
			for (var _key:String in obj1_)
			{
				if (! obj2_.hasOwnProperty(_key) || obj2_[_key] != obj1_[_key])
				{
					if (obj1_[_key] && obj1_[_key].toString() == "[object Object]" && 
						obj2_[_key] && obj2_[_key].toString() == "[object Object]")
					{
						dcm(obj1_[_key], obj2_[_key]);
					}
					else
					{
						_comRes = false;
						return;
					}
				}
			}
		}
		
		/**
		 * 深拷贝Object（不对引用类型的值进行深拷贝）。
		 * @param obj_ 原始Object。
		 * @return 原始Object的副本。
		 */		
		public static function clone(obj_:Object):Object
		{
			var _res:Object = new Object();
			dcl(obj_, _res);
			return _res;
		}
		
		private static function dcl(old_:Object, new_:Object):void
		{
			for ( var _key:String in old_ )
			{
				if ( old_[_key] && old_[_key].toString() == "[object Object]" )
				{
					new_[_key] = {};
					dcl(old_[_key], new_[_key]);
				}
				else
				{
					new_[_key] = old_[_key];
				}
			}
		}
	}
}