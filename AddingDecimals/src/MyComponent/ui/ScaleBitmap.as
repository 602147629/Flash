package MyComponent.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 继承自bitmap的九宫缩放BitMap 
	 * @author Administrator
	 * 
	 */
	public class ScaleBitmap extends Bitmap
	{
		protected var _originalBitmap:BitmapData;//图像数据
		protected var _scale9Grid:Rectangle;//缩放区域
		
		public function ScaleBitmap(_parentBitmapData:BitmapData,_pixelSnapping:String = "auto",_smoothing:Boolean = false)
		{
			super(_parentBitmapData.clone(),_pixelSnapping,_smoothing);
			this._originalBitmap = _parentBitmapData.clone();
		}
		/**
		 * 判断当前巨型缩放区域是否超出位图数据 
		 * @param _rect
		 * @return 
		 */
		private function validGrid(_rect:Rectangle):Boolean
		{
			return ((_rect.right <= this._originalBitmap.width) && (_rect.bottom <= this._originalBitmap.height));
		}
		
		/**
		 * 设置宽高 
		 * @param _width
		 * @param _height
		 */
		public function setSize(_width:Number, _height:Number):void{
			if (this._scale9Grid == null)
			{
				super.width = _width;
				super.height = _height;
			} 
			else
			{
				//_width = Math.max(_width,this._originalBitmap.width - this._scale9Grid.width);
				//_height = Math.max(_height,this._originalBitmap.height - this._scale9Grid.height);
				this.resizeBitmap(_width, _height);
			}
		}
		
		/**
		 * 重新赋值宽 
		 * @param _width
		 */
		override public function set width(_width:Number):void
		{
			if (_width != width)
			{
				this.setSize(_width, height);
			}
		}
		
		/**
		 * 重新赋值高 
		 * @param _height
		 * 
		 */
		override public function set height(_height:Number):void
		{
			if (_height != height)
			{
				this.setSize(width, _height);
			}
		}
		
		/**
		 * 重新赋值 
		 * @param _bitmapdata
		 */
		private function assignBitmapData(_bitmapdata:BitmapData):void
		{
			//super.bitmapData.dispose();
			super.bitmapData = _bitmapdata;
		}
		
		/**
		 * 九宫缩放bitmapdata 
		 * @param _arg1
		 * @param _arg2
		 */
		protected function resizeBitmap(_width:Number, _heigth:Number):void
		{
			var rect1:Rectangle;
			var rect2:Rectangle;
			var _local11:int;
			var _local12:int;
			var newScaleBitmapData:BitmapData = new BitmapData(_width, _heigth, true, 0);
			var _local4:Array = [0, this._scale9Grid.top, this._scale9Grid.bottom, this._originalBitmap.height];
			var _local5:Array = [0, this._scale9Grid.left, this._scale9Grid.right, this._originalBitmap.width];
			var _local6:Array = [0, this._scale9Grid.top, (_heigth - (this._originalBitmap.height - this._scale9Grid.bottom)), _heigth];
			var _local7:Array = [0, this._scale9Grid.left, (_width - (this._originalBitmap.width - this._scale9Grid.right)), _width];
			var _local10:Matrix = new Matrix();
			while (_local11 < 3) 
			{
				_local12 = 0;
				while (_local12 < 3)
				{
					rect1 = new Rectangle(_local5[_local11], _local4[_local12], (_local5[(_local11 + 1)] - _local5[_local11]), (_local4[(_local12 + 1)] - _local4[_local12]));
					rect2 = new Rectangle(_local7[_local11], _local6[_local12], (_local7[(_local11 + 1)] - _local7[_local11]), (_local6[(_local12 + 1)] - _local6[_local12]));
					_local10.identity();
					_local10.a = (rect2.width / rect1.width);
					_local10.d = (rect2.height / rect1.height);
					_local10.tx = (rect2.x - (rect1.x * _local10.a));
					_local10.ty = (rect2.y - (rect1.y * _local10.d));
					newScaleBitmapData.draw(this._originalBitmap, _local10, null, null, rect2, true);
					_local12++;
				}
				_local11++;
			}
			this.assignBitmapData(newScaleBitmapData);
		}
		
		/**
		 * 重新 bitmap赋值 
		 * @param _arg1
		 * 
		 */
		override public function set bitmapData(_bitmapdata:BitmapData):void
		{
			this._originalBitmap = _bitmapdata.clone();
			
			if(this._scale9Grid != null)
			{
				if(!this.validGrid(this._scale9Grid))
				{
					this._scale9Grid = null;
				}
				this.setSize(_bitmapdata.width, _bitmapdata.height);
			}
			else 
			{
				this.assignBitmapData(this._originalBitmap.clone());
			}
		}
		
		/**
		 * 设置缩放区域 
		 * @param _arg1
		 * 
		 */
		override public function set scale9Grid(_rect:Rectangle):void
		{
			var _width:Number;
			var _heigth:Number;
			if ((this._scale9Grid == null) && _rect != null || this._scale9Grid != null && !(this._scale9Grid.equals(_rect)))
			{
				if (_rect == null)
				{
					_width = width;
					_heigth = height;
					this._scale9Grid = null;
					this.assignBitmapData(this._originalBitmap.clone());
					this.setSize(_width, _heigth);
				}
				else 
				{
					if (!this.validGrid(_rect))
					{
						throw (new Error("当前传入的矩形超出了图形数据的最大值！"));
					}
					this._scale9Grid = _rect.clone();
					this.resizeBitmap(width, height);
					scaleX = 1;
					scaleY = 1;
				}
			}
		}
		
		/**
		 * 获取缩放区域数据 
		 * @return
		 */
		override public function get scale9Grid():Rectangle
		{
			return this._scale9Grid;
		}
		
		/**
		 * 获取bitmapData的原始数据 
		 * @return 
		 */
		public function getOriginalBitmapData():BitmapData
		{
			return this._originalBitmap;
		}
		
		/**
		 * 释放资源 
		 */
		public function dispose():void
		{
			if(_originalBitmap)
			{
				this._originalBitmap.dispose();
				this._originalBitmap = null;
			}
			
			if(super.bitmapData)
			{
				super.bitmapData.dispose();
				super.bitmapData = null;
			}
		}
	}
}