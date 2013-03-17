package com.rekoo.manager 
{
	import com.rekoo.display.layer.RKLayer;

	/**
	 * 层管理器。
	 * @author Administrator
	 * 
	 */	
	public final class RKLayerManager
	{
		private var _layerDic:Object = {};
		
		private static var _instance:RKLayerManager = null;
		
		public function RKLayerManager(singletonEnforcer_:SingletonEnforcer)
		{
		}
		
		public static function get instance():RKLayerManager
		{
			if ( _instance == null )
			{
				_instance = new RKLayerManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		/**
		 * 注册层。不注册没法用。
		 * @param layer_ 层。
		 * @return 是否注册成功。
		 * 
		 */		
		public function registerLayer(layer_:RKLayer):Boolean
		{
			if ( hasLayerRegisted(layer_.getType()) )
			{
				return false;
			}
			
			_layerDic[layer_.getType()] = layer_;
			
			return true;
		}
		
		/**
		 * 注销层。注销了就不能用了。
		 * @param type_ 层类型。
		 * @return 是否注销成功。
		 * 
		 */		
		public function unregisterLayer(type_:String):Boolean
		{
			if ( hasLayerRegisted(type_) )
			{
				delete _layerDic[type_];
				return true;
			}
			
			return false;
		}
		
		/**
		 * 是否已注册过某层。
		 * @param type_ 层类型。
		 * @return Boolean。
		 * 
		 */		
		public function hasLayerRegisted(type_:String):Boolean
		{
			return _layerDic.hasOwnProperty(type_);
		}
		
		/**
		 * 获取一个RKLayer。
		 * @param type_ RKLayer的类型。
		 */
		public function getLayer(type_:String):RKLayer
		{
			return _layerDic[type_];
		}
	}
}

class SingletonEnforcer{}