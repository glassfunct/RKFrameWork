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
			if ( hasLayerRegisted(layer_.getName()) )
			{
				return false;
			}
			
			_layerDic[layer_.getName()] = layer_;
			
			return true;
		}
		
		/**
		 * 注销层。注销了就不能用了。
		 * @param name_ 层名称。
		 * @return 是否注销成功。
		 * 
		 */		
		public function unregisterLayer(name_:String):Boolean
		{
			if ( hasLayerRegisted(name_) )
			{
				delete _layerDic[name_];
				return true;
			}
			
			return false;
		}
		
		/**
		 * 是否已注册过某层。
		 * @param name_ 层名称。
		 * @return Boolean。
		 * 
		 */		
		public function hasLayerRegisted(name_:String):Boolean
		{
			return _layerDic.hasOwnProperty(name_);
		}
		
		/**
		 * 获取一个RKLayer。
		 * @param name_ RKLayer的注册名称。
		 */
		public function getLayer(name_:String):RKLayer
		{
			return _layerDic[name_];
		}
	}
}

class SingletonEnforcer{}