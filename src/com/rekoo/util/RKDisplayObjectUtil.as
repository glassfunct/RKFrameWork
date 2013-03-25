package com.rekoo.util
{
	import com.rekoo.RKPosition;
	import com.rekoo.interfaces.IRKMovieClip;
	import com.rekoo.interfaces.IRKSprite;
	import com.rekoo.interfaces.IRKTooltipSkin;
	import com.rekoo.interfaces.IRKTooltipable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class RKDisplayObjectUtil
	{
		public static const DISABLED_FILTER:ColorMatrixFilter = 
			new ColorMatrixFilter([0.4086, 0.6094, 0.082, 0, 0,
				0.4086, 0.6094, 0.082, 0, 0,
				0.4086, 0.6094, 0.082, 0, 0,
				0,0,0,1,0]);
		
		/**
		 * 销毁显示对象。
		 * @param displayObject_ DisplayObject。
		 * 
		 */		
		public static function dispose(displayObject_:DisplayObject):void
		{
			if ( displayObject_ == null )
			{
				return;
			}
			
			if ( displayObject_.parent )
			{
				displayObject_.parent.removeChild(displayObject_);
			}
			
			if ( displayObject_ is IRKTooltipSkin )
			{
				(displayObject_ as IRKTooltipSkin).dispose();
			}
			else if ( displayObject_ is IRKTooltipable )
			{
				(displayObject_ as IRKTooltipable).dispose();
			}
			else if ( displayObject_ is IRKSprite )
			{
				(displayObject_ as IRKSprite).dispose();
			}
			else if ( displayObject_ is IRKMovieClip )
			{
				(displayObject_ as IRKMovieClip).dispose();
			}
			else if ( displayObject_ is MovieClip )
			{
				(displayObject_ as MovieClip).stop();
				(displayObject_ as MovieClip).graphics.clear();
			}
			else if ( displayObject_ is Sprite )
			{
				(displayObject_ as Sprite).graphics.clear();
			}
			else if ( displayObject_ is Shape )
			{
				(displayObject_ as Shape).graphics.clear();
			}
			else if ( displayObject_ is Bitmap )
			{
				(displayObject_ as Bitmap).bitmapData.dispose();
			}
			
			displayObject_ = null;
		}
		
		/**
		 * 更新显示对象对齐方式。
		 * @param target_ 显示对象。
		 * @param area_ 目标区域。
		 * @param align_ 对齐方式。
		 * @param offset_ 坐标偏移量。
		 * @param simple_ 是否简单对齐。简单对齐的话不会考虑显示对象的大小。
		 * 
		 */		
		public static function align(target_:DisplayObject, area_:Rectangle, align_:String, offset_:Point = null, simple_:Boolean = false):void
		{
			var _rect:Rectangle = null;
			
			if ( simple_ )
			{
				_rect = new Rectangle();
			}
			else
			{
				if ( target_.scrollRect != null )
				{
					_rect = target_.scrollRect.clone();
				}
				else
				{
					_rect = target_.getBounds(target_);
				}
			}
			
			switch ( align_ )
			{
				case RKPosition.LEFT:
					target_.x = area_.x;
					target_.y = area_.y + (area_.height - _rect.height) / 2;
					break;
				
				case RKPosition.LEFT_TOP:
					target_.x = area_.x;
					target_.y = area_.y;
					break;
				
				case RKPosition.TOP:
					target_.x = area_.x + (area_.width - _rect.width) / 2;
					target_.y = area_.y;
					break;
				
				case RKPosition.RIGHT_TOP:
					target_.x = area_.x + area_.width - _rect.width;
					target_.y = area_.y;
					break;
				
				case RKPosition.RIGHT:
					target_.x = area_.x + area_.width - _rect.width;
					target_.y = area_.y + (area_.height - _rect.height) / 2;
					break;
				
				case RKPosition.RIGHT_BOTTOM:
					target_.x = area_.x + area_.width - _rect.width;
					target_.y = area_.y + area_.height - _rect.height;
					break;
				
				case RKPosition.BOTTOM:
					target_.x = area_.x + (area_.width - _rect.width) / 2;
					target_.y = area_.y + area_.height - _rect.height;
					break;
				
				case RKPosition.LEFT_BOTTOM:
					target_.x = area_.x;
					target_.y = area_.y + area_.height - _rect.height;
					break;
				
				case RKPosition.CENTER:
					target_.x = area_.x + (area_.width - _rect.width) / 2;
					target_.y = area_.y + (area_.height - _rect.height) / 2;
					break;
				
				case RKPosition.NONE:
					target_.x = area_.x;
					target_.y = area_.y;
					break;
				
				default:
					target_.x = area_.x;
					target_.y = area_.y;
					break;
			}
			
			if ( offset_ )
			{
				target_.x += offset_.x;
				target_.y += offset_.y;
			}
		}
		
		/**
		 * 切割图像（先从左向右，后自上而下）。
		 * @param bitmapData_ 源图像。
		 * @param cols_ 源图像包含的列数。
		 * @param rows_ 源图像包含的行数。
		 * @return Vector.<BitmapData>。
		 */		
		public static function splitBitmapData(bitmapData_:BitmapData, cols_:int, rows_:int):Vector.<BitmapData>
		{
			var _v:Vector.<BitmapData> = new Vector.<BitmapData>();
			var _bitmapData:BitmapData = null;
			var _cellW:Number = bitmapData_.width / cols_;
			var _cellH:Number = bitmapData_.height / rows_;
			
			for ( var _row:int = 0; _row < rows_; _row ++ )
			{
				for ( var _col:int = 0; _col < cols_; _col ++ )
				{
					_bitmapData = new BitmapData(_cellW, _cellH, true, 0);
					_bitmapData.lock();
					_bitmapData.copyPixels(bitmapData_, new Rectangle(_col * _cellW, _row * _cellH, _cellW, _cellH), new Point());
					_bitmapData.unlock();
					
					_v.push(_bitmapData);
				}
			}
			
			return _v;
		}
		
		/**
		 * 获取截图。
		 * @param displayObject_ 截图对象。
		 * @param ignoreScale_ 是否忽略缩放。
		 * @return 截图Bitmap。
		 * 
		 */		
		public static function getCapture(displayObject_:DisplayObject, ignoreScale_:Boolean = false):Bitmap
		{
			var _capture:Bitmap = new Bitmap(null, "auto", true);
			
			var _sx:Number = displayObject_.scaleX;
			var _sy:Number = displayObject_.scaleY;
			
			if ( ignoreScale_ )
			{
				displayObject_.scaleX = displayObject_.scaleY = 1;
			}
			
			var _rect:Rectangle = displayObject_.scrollRect ? 
				displayObject_.scrollRect.clone() : displayObject_.getBounds(displayObject_);
			
			var _bitmapData:BitmapData = new BitmapData(Math.ceil(_rect.width), Math.ceil(_rect.height), true, 0);
			var _mt:Matrix = displayObject_.transform.matrix.clone();
			_mt.tx = -_rect.x;
			_mt.ty = -_rect.y;
			_bitmapData.lock();
			_bitmapData.draw(displayObject_, _mt, displayObject_.transform.colorTransform, displayObject_.blendMode, null, true);
			_bitmapData.unlock();
			_capture.bitmapData = _bitmapData;
			
			if ( ignoreScale_ )
			{
				displayObject_.scaleX = _sx;
				displayObject_.scaleY = _sy;
			}
				
			return _capture;
		}
		
		public static function removeAllChildren(disp_:DisplayObjectContainer):void
		{
			while ( disp_.numChildren )
			{
				disp_.removeChildAt(0);
			}
		}
	}
}