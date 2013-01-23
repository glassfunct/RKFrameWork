package com.rekoo.display.gui
{
	import com.rekoo.display.RKSprite;
	import com.rekoo.display.layer.RKLayer;
	import com.rekoo.interfaces.IRKGUI;
	import com.rekoo.manager.RKLayerManager;
	import com.rekoo.manager.RKResourceManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * GUI基类。 
	 * @author Administrator
	 * 
	 */	
	public class RKGUI extends RKSprite implements IRKGUI
	{
		private var _className:String = null;
		
		/**
		 * GUI基类。
		 * 
		 */		
		public function RKGUI()
		{
			super();
			
			parseSkin();
		}
		
		/**
		 * 解析皮肤。默认是通过完整类名去匹配素材里的导出类。 
		 * 
		 */		
		protected function parseSkin():void
		{
			_className = flash.utils.getQualifiedClassName(this);
			var _arr:Array = _className.split("::");
			var _skinDefinitionName:String = null;
			
			if ( _arr.length == 1 )
			{
				_skinDefinitionName = _arr[0] + "Skin";
			}
			else
			{
				_skinDefinitionName = _arr[0] + "." + _arr[1] + "Skin";
			}
			
			skin = new (RKResourceManager.instance.getResourceClass(_skinDefinitionName))() as DisplayObject;
		}
		
		/**
		 * 显示。 
		 * 
		 */		
		public function show():void
		{
			var _layer:RKLayer = RKLayerManager.instance.getLayer(getLayer());
			
			if ( _layer == null )
			{
				throw new Error(getLayer() + "层不存在！");
			}
			else
			{
				_layer.addChild(this);
			}
		}
		
		/**
		 * 隐藏。 
		 * 
		 */		
		public function hide():void
		{
			if ( parent )
			{
				parent.removeChild(this);
			}
		}
		
		/**
		 * 返回GUI名称。默认是完整类名。 
		 * @return String。
		 * 
		 */		
		public function getName():String
		{
			return _className;
		}
		
		/**
		 * 返回所在的层。
		 * @return String。
		 * 
		 */		
		public function getLayer():String
		{
			throw new Error("子类需覆写getLayer"); 
		}
	}
}