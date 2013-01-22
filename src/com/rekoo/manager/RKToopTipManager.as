package com.rekoo.manager
{
	import com.rekoo.RKDisplayAlign;
	import com.rekoo.RKFrameWork;
	import com.rekoo.display.layer.RKLayer;
	import com.rekoo.interfaces.IRKSprite;
	import com.rekoo.interfaces.IRKToolTipSkin;
	import com.rekoo.interfaces.IRKToolTipable;
	import com.rekoo.util.RKDisplayObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * ToolTip管理。
	 * @author Administrator
	 * 
	 */	
	public final class RKToopTipManager
	{
		private var _container:DisplayObjectContainer = null;
		
		private static var _instance:RKToopTipManager = null;
		
		public function RKToopTipManager(singletonEnforcer_:SingletonEnforcer)
		{
			_container = RKFrameWork.APP_Stage;
		}
		
		/**
		 * 单例。
		 * @return RKToopTipManager的唯一实例。
		 * 
		 */		
		public static function get instance():RKToopTipManager
		{
			if ( _instance == null )
			{
				_instance = new RKToopTipManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		/**
		 * 初始化，制定tooltip的显示层，若不初始化，TIP的显示层为舞台。
		 * @param container_ tooltip的显示层。
		 * 
		 */		
		public function init(container_:DisplayObjectContainer):void
		{
			_container = container_;
		}
		
		/**
		 * 显示tooltip。
		 * @param target_ 需要显示tooltip的显示对象。
		 * 
		 */		
		public function showToolTip(target_:IRKToolTipable):void
		{
			if ( target_.toolTipSkin == null )
			{
				return;
			}
			
			target_.toolTipSkin.data = target_.toolTip;
			_container.addChild(target_.toolTipSkin as DisplayObject);
			
			if ( target_.toolTipAlign == RKDisplayAlign.NONE )
			{
				posToolTipSkin(target_);
				target_.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			else
			{
				var _tipSkin:IRKToolTipSkin = target_.toolTipSkin;
				var _rect:Rectangle = (target_ as DisplayObject).getBounds(_container);
				
				RKDisplayObjectUtil.align(_tipSkin as DisplayObject, _rect, target_.toolTipAlign, null, true);
			}
		}
		
		/**
		 * 隐藏tooltip。
		 * @param target_ 正在显示tooltip的显示对象。
		 * 
		 */		
		public function hideToolTip(target_:IRKToolTipable):void
		{
			if ( target_.hasEventListener(MouseEvent.MOUSE_MOVE) )
			{
				target_.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			
			if ( target_.toolTipSkin && _container.contains(target_.toolTipSkin as DisplayObject) )
			{
				_container.removeChild(target_.toolTipSkin as DisplayObject);
			}
		}
		
		private function onMouseMove(evt_:MouseEvent):void
		{
			var _target:IRKToolTipable = evt_.currentTarget as IRKToolTipable;
			posToolTipSkin(_target);
		}
		
		private function posToolTipSkin(target_:IRKToolTipable):void
		{
			if ( target_.toolTipSkin )
			{
				target_.toolTipSkin.x = _container.mouseX + 10;
				target_.toolTipSkin.y = _container.mouseY + 15;
			}
		}
	}
}

class SingletonEnforcer{}