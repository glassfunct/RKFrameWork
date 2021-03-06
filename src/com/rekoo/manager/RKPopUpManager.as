package com.rekoo.manager
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.RKPosition;
	import com.rekoo.display.gui.popup.RKPopUp;
	import com.rekoo.display.layer.RKLayer;
	import com.rekoo.interfaces.IRKPopUp;
	import com.rekoo.util.RKDisplayObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 弹框管理。 
	 * @author Administrator
	 * 
	 */	
	public final class RKPopUpManager
	{
		/* 当前正在显示的弹框。 */
		private var _showingPopUpList:Vector.<Object> = new Vector.<Object>();
		/* 排队等待显示的弹框。 */
		private var _queuePopUpList:Vector.<Object> = new Vector.<Object>();
		
		/* 弹框蒙版。 */
		private var _modalPopUpMask:Sprite = new Sprite();
		
		private static var _instance:RKPopUpManager = null;
		
		public function RKPopUpManager(singletonEnforcer_:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():RKPopUpManager
		{
			if ( _instance == null )
			{
				_instance = new RKPopUpManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		/**
		 * 显示弹框。 
		 * @param popUp_ 框。
		 * @param modal_ 是否模态显示。
		 * @param queue_ 是否放入队列。放入队列的话会等前一个弹框关闭后才显示，否则立刻显示。
		 * @param align_ 对齐方式。
		 * @param offset_ 坐标偏移量。
		 */		
		public function show(popUp_:IRKPopUp, modal_:Boolean = true, queue_:Boolean = false, align_:String = RKPosition.CENTER, offset_:Point = null):void
		{
			if ( !popUp_ is IRKPopUp )
			{
				throw new Error("RKPopUpManager的show方法只接受RKPopUp类型的GUI！");
			}
			
			popUp_.modal = modal_;
			popUp_.queue = queue_;
			
			if ( popUp_.queue )
			{
				if (_showingPopUpList.length == 0 && _queuePopUpList.length == 0)
				{
					showPopUp(popUp_, align_, offset_);
				}
				
				_queuePopUpList.push({"popUp":popUp_, "align":align_, "offset":offset_});
			}
			else
			{
				showPopUp(popUp_, align_, offset_);
			}
		}
		
		/**
		 * 隐藏弹框。 
		 * @param popUp_ 框。
		 * 
		 */		
		public function hide(popUp_:RKPopUp):void
		{
			popUp_.hide();
		}
		
		private function showPopUp(popUp_:IRKPopUp, align_:String = RKPosition.CENTER, offset_:Point = null):void
		{
			_showingPopUpList.push({"popUp":popUp_, "align":align_, "offset":offset_});
			RKDisplayObjectUtil.align((popUp_ as DisplayObject), new Rectangle(0, 0, RKFrameWork.APP_Width, RKFrameWork.APP_Height), align_, offset_);
			popUp_.show();
			
			if ( popUp_.modal )
			{
				showModalPopUpMask(popUp_);
			}
			
			(popUp_ as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, onPopUpClosedHandler);
		}
		
		private function showModalPopUpMask(popUp_:IRKPopUp):void
		{
			var _layer:RKLayer = RKLayerManager.instance.getLayer(popUp_.getLayer());
			
			_modalPopUpMask.graphics.clear();
			_modalPopUpMask.graphics.beginFill(0x000000, 0.4);
			_modalPopUpMask.graphics.drawRect(0, 0, RKFrameWork.APP_Width, RKFrameWork.APP_Height);
			_modalPopUpMask.graphics.endFill();
			
			if ( _modalPopUpMask.parent )
			{
				_modalPopUpMask.parent.removeChild(_modalPopUpMask);
			}
			
			_layer.addChildAt(_modalPopUpMask, _layer.getChildIndex((popUp_ as DisplayObject)));
		}
		
		private function hidePopUpMask():void
		{
			if ( _modalPopUpMask.parent )
			{
				_modalPopUpMask.graphics.clear();
				_modalPopUpMask.parent.removeChild(_modalPopUpMask);
			}
		}
		
		private function onPopUpClosedHandler(evt_:Event):void
		{
			var _popUp:RKPopUp = evt_.target as RKPopUp;
			
			_popUp.removeEventListener(Event.REMOVED_FROM_STAGE, onPopUpClosedHandler);
			
			for ( var _i:int = 0; _i < _showingPopUpList.length; _i ++ )
			{
				if ( _showingPopUpList[_i]["popUp"] == _popUp )
				{
					_showingPopUpList.splice(_i, 1);
					break;
				}
			}
			
			if ( _popUp.queue )
			{
				_queuePopUpList.shift();
			}
			
			if ( _popUp.modal )
			{
				hidePopUpMask();
			}
			
			if ( _showingPopUpList.length )
			{
				for ( var _j:int = _showingPopUpList.length - 1; _j >= 0; _j -- )
				{
					if ( _showingPopUpList[_j]["popUp"].modal )
					{
						showModalPopUpMask(_showingPopUpList[_j]["popUp"]);
						break;
					}
				}
			}
			else
			{
				if ( _queuePopUpList.length )
				{
					showPopUp(_queuePopUpList[0]["popUp"], _queuePopUpList[0]["align"], _queuePopUpList[0]["offset"]);
				}
			}
		}
	}
}

class SingletonEnforcer{}