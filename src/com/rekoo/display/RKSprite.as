package com.rekoo.display
{
	import com.rekoo.interfaces.IRKSprite;
	import com.rekoo.util.RKDisplayObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * <b>基本显示对象。</b>
	 * @author Administrator
	 * 
	 */	
	public class RKSprite extends Sprite implements IRKSprite
	{
		public var onNumchildrenChange:Function = null;
		
		private var _skin:DisplayObject = null;
		private var _enabled:Boolean = false;
		private var _selected:Boolean = false;
		private var _selectable:Boolean = false;
		private var _onSelected:Function = null;
		
		private var _evtDic:Dictionary = new Dictionary();
		private var _dragable:Boolean = false;
		private var _dragArea:Rectangle = null;
		private var _drag:Function = null;
		private var _drop:Function = null;
		
		private var _active:Boolean = false;
		
		/**
		 * <b>基本显示对象。</b>
		 * @param skin_ 皮肤。
		 * 
		 */		
		public function RKSprite(skin_:DisplayObject = null)
		{
			super();
			enabled = true;
			selectable = false;
			
//			if ( skin_ )
//			{
				skin = skin_;
//			}
			
			_dragArea = getBounds(this);
		}
		
		/**
		 * <b>皮肤。</b>
		 * @return DisplayObject。 
		 * 
		 */		
		public function get skin():DisplayObject
		{
			return _skin;
		}
		
		/**
		 * <b>皮肤。</b>
		 * @param value DisplayObject。
		 * 
		 */		
		public function set skin(value:DisplayObject):void
		{
			if ( _skin )
			{
				RKDisplayObjectUtil.dispose(_skin);
			}
			
			_skin = value;
			
			if ( _skin )
			{
				if ( _skin.parent )
				{
					x = _skin.x;
					y = _skin.y;
					_skin.parent.addChildAt(this, _skin.parent.getChildIndex(_skin));
				}
				
				_skin.x = 0;
				_skin.y = 0;
				addChild(_skin);
			}
			
			initView();
		}
		
		/**
		 * <b>皮肤显示后进行初始化。</b>
		 * 
		 */
		public function initView():void
		{
			
		}
		
		/**
		 * <b>销毁。</b>
		 * 
		 */		
		public function dispose():void
		{
			var _child:DisplayObject = null;
			
			if ( skin && skin is DisplayObjectContainer )
			{
				while( (skin as DisplayObjectContainer).numChildren )
				{
					_child = (skin as DisplayObjectContainer).getChildAt(0);
					
					if ( _child )
					{
						RKDisplayObjectUtil.dispose(_child);
					}
					else
					{
						break;
					}
				}
			}
			
			skin = null;
			
			while ( numChildren )
			{
				_child = getChildAt(0);
				
				if ( _child )
				{
					RKDisplayObjectUtil.dispose(_child);
				}
				else
				{
					break;
				}
			}
			
			graphics.clear();
			
			clearEvents();
			
			if ( parent )
			{
				parent.removeChild(this);
			}
			
			_onSelected = null;
		}
		
		/**
		 * <b>清空子显示对象。</b>
		 * 
		 */		
		public function removeAllChildren():void
		{
			while ( numChildren )
			{
				removeChildAt(0);
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			buttonMode = (enabled && selectable);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if ( selectable && enabled && selected != value )
			{
				_selected = value;
				
				if ( selected && _onSelected != null )
				{
					if ( _onSelected.length )
					{
						_onSelected(this);
					}
					else
					{
						_onSelected();
					}
				}
			}
			
		}
		
		public function get onSelected():Function
		{
			return _onSelected;
		}
		
		public function set onSelected(value:Function):void
		{
			_onSelected = value;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			addEvtToDic(type, listener, useCapture);
		}
		
		private function addEvtToDic(type_:String, listener_:Function, useCapture_:Boolean):void
		{
			if ( _evtDic.hasOwnProperty(type_) )
			{
				//事件对应的监听器列表。
				var _list:Vector.<Object> = _evtDic[type_];
				var _len:int = _list.length;
				
				for ( var _i:int = 0; _i < _len; _i ++ )
				{
					if ( _list[_i]["listener"] == listener_ )
					{
						//此事件已经监听过了。
						_list[_i]["useCapture"] = useCapture_;
						return;
					}
				}
				
				_list[_len] = {"listener":listener_, "useCapture":useCapture_};
			}
			else
			{
				_evtDic[type_] = new Vector.<Object>();
				_evtDic[type_][0] = {"listener":listener_, "useCapture":useCapture_};
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			removeEvtFromDic(type, listener);
		}
		
		private function removeEvtFromDic(type_:String, listener_:Function):void
		{
			if ( _evtDic.hasOwnProperty(type_) )
			{
				//事件对应的监听器列表。
				var _list:Vector.<Object> = _evtDic[type_];
				var _len:int = _list.length;
				
				for ( var _i:int = 0; _i < _len; _i ++ )
				{
					if ( _list[_i]["listener"] == listener_ )
					{
						//此事件已经监听过了。
						_list.splice(_i, 1);
						_len --;
						break;
					}
				}
				
				if ( _len == 0 )
				{
					delete _evtDic[type_];
				}
			}
		}
		
		/**
		 * <b>清除所有事件监听。</b>
		 */
		public function clearEvents():void
		{
			var _arr:Vector.<Object> = null;
			var _len:int = 0;
			
			for ( var _key:String in _evtDic )
			{
				_arr = _evtDic[_key];
				
				for each ( var _obj:Object in _arr )
				{
					removeEventListener(_key, _obj["listener"], _obj["useCapture"]);
				}
			}
		}
		
		/**
		 * <b>拖拽区域。</b>
		 * @return Rectangle。 
		 * 
		 */		
		public function get dragArea():Rectangle
		{
			return _dragArea;
		}
		
		/**
		 * <b>拖拽区域。</b>
		 * @param value。
		 * 
		 */		
		public function set dragArea(value:Rectangle):void
		{
			_dragArea = value;
		}
		
		/**
		 * <b>是否可拖拽。</b>
		 * @return Boolean。 
		 * 
		 */
		public function get dragable():Boolean
		{
			return _dragable;
		}
		
		/**
		 * <b>是否可拖拽。</b>
		 * @param value。 
		 * 
		 */
		public function set dragable(value:Boolean):void
		{
			if ( value )
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function onMouseDown(evt_:MouseEvent):void
		{
			if ( _dragArea.contains(mouseX, mouseY) )
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				startDrag();
				
				if ( _drag != null )
				{
					drag();
				}
			}
		}
		
		private function onMouseMove(evt_:MouseEvent):void
		{
			//evt_.updateAfterEvent();
		}
		
		private function onMouseUp(evt_:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stopDrag();
			
			if ( _drop != null )
			{
				drop();
			}
		}
		
		public function get drag():Function
		{
			return _drag;
		}
		
		public function set drag(value:Function):void
		{
			_drag = value;
		}
		
		public function get drop():Function
		{
			return _drop;
		}
		
		public function set drop(value:Function):void
		{
			_drop = value;
		}
		
		/**
		 * 添加滤镜。
		 * @param args BitmapFilter。
		 * 
		 */		
		public function applyFilters(...args):void
		{
			var _fs:Array = [];
			
			if ( filters != null && filters.length > 0 )
			{
				for each ( var _f:BitmapFilter in filters  )
				{
					_fs.push(_f);
				}
			}
			
			if ( args.length > 0 )
			{
				for each ( var _nf:BitmapFilter in args )
				{
					_fs.push(_nf);
				}
				
				filters = _fs;
			}
		}
		
		/**
		 * 移除滤镜。
		 * @param args BitmapFilter。
		 * 
		 */		
		public function removeFilters(...args):void
		{
			if ( filters != null && filters.length > 0 && args.length > 0 )
			{
				var _fs:Array = filters;
				
				var _len:int = args.length;
				
				for ( var _i:int = 0; _i < _len; _i ++ )
				{
					if ( _fs.indexOf(args[_i] != -1) )
					{
						_fs.splice(_i, 1);
					}
				}
				
				filters = _fs;
			}
		}

		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			buttonMode = (enabled && selectable);
		}
		
		/**
		 * 返回名称。默认是完整类名。 
		 * @return String。
		 */		
		public function getName():String
		{
			return flash.utils.getQualifiedClassName(this);
		}

		/**
		 * 是否相应鼠标。一般不需要手动设置。
		 */
		public function get active():Boolean
		{
			return _active;
		}

		/**
		 * @private
		 */
		public function set active(value:Boolean):void
		{
			_active = value;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			
			if ( onNumchildrenChange != null )
			{
				onNumchildrenChange();
			}
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			
			if ( onNumchildrenChange != null )
			{
				onNumchildrenChange();
			}
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var _c:DisplayObject = super.removeChild(child);
			
			if ( onNumchildrenChange != null )
			{
				onNumchildrenChange();
			}
			
			return _c;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var _c:DisplayObject = super.removeChildAt(index);
			
			if ( onNumchildrenChange != null )
			{
				onNumchildrenChange();
			}
			
			return _c;
		}
		
		override public function removeChildren(beginIndex:int=0, endIndex:int=int.MAX_VALUE):void
		{
			super.removeChildren(beginIndex, endIndex);
			
			if ( onNumchildrenChange != null )
			{
				onNumchildrenChange();
			}
		}

	}
}