package com.rekoo.display.gui
{
	import com.rekoo.display.RKSprite;
	import com.rekoo.display.RKTooltipableSprite;
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
	public class RKGUI extends RKTooltipableSprite implements IRKGUI
	{
		/**
		 * 当添加到舞台上后回调此函数。
		 */		
		public var onShow:Function = null;
		/**
		 * 当从舞台上移除后回调此函数。
		 */		
		public var onHide:Function = null;
		
		
		
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
		 * 默认皮肤已存在。
		 * 若皮肤不存在，则需要复写此方法去加载皮肤，当皮肤加载完成后调用super.parseSkin()。
		 */		
		protected function parseSkin():void
		{
			var _skinDefinitionName:String = getName().replace(/::/g, ".") + "Skin";
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
				
				if ( onShow != null )
				{
					onShow();
				}
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
				
				if ( onHide != null )
				{
					onHide();
				}
			}
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
		
		override public function dispose():void
		{
			super.dispose();
			onShow = null;
			onHide = null;
		}
	}
}