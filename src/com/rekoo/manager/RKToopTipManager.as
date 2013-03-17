package com.rekoo.manager
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.RKPosition;
	import com.rekoo.display.layer.RKLayer;
	import com.rekoo.interfaces.IRKSprite;
	import com.rekoo.interfaces.IRKTooltipSkin;
	import com.rekoo.interfaces.IRKTooltipable;
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
	public final class RKTooptipManager
	{
		private var _container:DisplayObjectContainer = null;
		
		private static var _instance:RKTooptipManager = null;
		
		public function RKTooptipManager(singletonEnforcer_:SingletonEnforcer)
		{
			_container = RKFrameWork.APP_Stage;
		}
		
		/**
		 * 单例。
		 * @return RKToopTipManager的唯一实例。
		 * 
		 */		
		public static function get instance():RKTooptipManager
		{
			if ( _instance == null )
			{
				_instance = new RKTooptipManager(new SingletonEnforcer());
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
		public function showToolTip(target_:IRKTooltipable):void
		{
			if ( target_.tooltipSkin == null || target_.tooltip == null )
			{
				return;
			}
			
			target_.tooltipSkin.tooltip = target_.tooltip;
			_container.addChild(target_.tooltipSkin as DisplayObject);
			
			if ( target_.tooltipAlign == RKPosition.NONE )
			{
				posToolTipSkin(target_);
				target_.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			else
			{
				var _tipSkin:IRKTooltipSkin = target_.tooltipSkin;
				var _rect:Rectangle = (target_ as DisplayObject).getBounds(_container);
				
				RKDisplayObjectUtil.align(_tipSkin as DisplayObject, _rect, target_.tooltipAlign, null, true);
			}
		}
		
		/**
		 * 隐藏tooltip。
		 * @param target_ 正在显示tooltip的显示对象。
		 * 
		 */		
		public function hideToolTip(target_:IRKTooltipable):void
		{
			if ( target_.hasEventListener(MouseEvent.MOUSE_MOVE) )
			{
				target_.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			
			if ( target_.tooltipSkin && _container.contains(target_.tooltipSkin as DisplayObject) )
			{
				_container.removeChild(target_.tooltipSkin as DisplayObject);
			}
		}
		
		private function onMouseMove(evt_:MouseEvent):void
		{
			var _target:IRKTooltipable = evt_.currentTarget as IRKTooltipable;
			posToolTipSkin(_target);
		}
		
		private function posToolTipSkin(target_:IRKTooltipable):void
		{
			if ( target_.tooltipSkin )
			{
				if ( _container.mouseX + target_.tooltipSkin.width >= RKFrameWork.APP_Width - 15 )
				{
					target_.tooltipSkin.x = _container.mouseX - target_.tooltipSkin.width - 3;
				}
				else
				{
					target_.tooltipSkin.x = _container.mouseX + 10;
				}
				
				if ( _container.mouseY + target_.tooltipSkin.height >= RKFrameWork.APP_Height - 20 )
				{
					target_.tooltipSkin.y = _container.mouseY - target_.tooltipSkin.height - 3;
				}
				else
				{
					target_.tooltipSkin.y = _container.mouseY + 15;
				}
			}
		}
	}
}

class SingletonEnforcer{}