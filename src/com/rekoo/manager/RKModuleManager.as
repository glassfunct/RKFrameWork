package com.rekoo.manager
{
	import com.rekoo.interfaces.IRKModule;
	
	public final class RKModuleManager
	{
		private static var _instance:RKModuleManager;
		private var _modules:Object = {};
		
		public function RKModuleManager(singletonEnforcer_:SingletonEnforcer)
		{
		}
		
		public static function get instance():RKModuleManager
		{
			if (null == _instance)
			{
				_instance=new RKModuleManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		/**
		 * 注册模块。
		 * @param module_ 模块实例。
		 * 
		 */		
		public function register(module_:IRKModule):void
		{
			if (_modules[module_.getModuleName()] == null)
			{
				_modules[module_.getModuleName()] = module_;
				module_.init();
			}
			
			throw new Error("已经存在的模块,请不要重复注册");
		}
		
		/**
		 * 销毁模块。
		 * @param name_ 模块名称。
		 * 
		 */		
		public function dispose(name_:String):void
		{
			if(_modules[name_]==null)
			{
				throw new Error("不存在这个模块或模块已被销毁");
				return;
			}
			
			(_modules[name_] as IRKModule).dispose();
			delete _modules[name_];
		}
		
		/**
		 * 通过模块名称取模块。
		 * @param name_ 模块名称。
		 * @return 模块实例。
		 * 
		 */		
		public function getModule(name_:String):IRKModule
		{
			return _modules[name_];
		}
		
		/**
		 * 点对点呼叫模块。
		 * @param moduleName_ 被呼叫的模块名。
		 * @param protocol_ 协议。
		 * @param params_ 附加参数。
		 * @return Object 返回值。
		 * 
		 */		
		public function callModule(moduleName_:String, protocol_:String, ...params_):Object
		{
			var _module:IRKModule = getModule(moduleName_);
			
			if ( !_module )
			{
				throw new Error("不存在这个模块或模块已被销毁！");
			}
			
			return _module.call(protocol_, params_);
		}
	}
}

class SingletonEnforcer{}