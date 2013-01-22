package com.rekoo.manager
{
	import com.rekoo.interfaces.IRKGUI;

	public final class RKGUIManager
	{
		private var _guiDic:Object ={};
		
		private static var _instance:RKGUIManager = null;
		
		public function RKGUIManager(singletonEnforcer_:SingletonEnforcer)
		{
		}
		
		public static function get instance():RKGUIManager
		{
			if ( _instance == null )
			{
				_instance = new RKGUIManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		public function register(gui_:IRKGUI):Boolean
		{
			return false;
		}
	}
}

class SingletonEnforcer{}