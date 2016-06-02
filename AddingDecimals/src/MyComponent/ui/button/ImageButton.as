package MyComponent.ui.button
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import MyComponent.ui.mo.SButton;
	
	public class ImageButton extends Sprite
	{
		protected var skin:Bitmap;
		protected var skinData:SButton;
		private var clickFun:Function;
		private var  data:Object;
		
		public function ImageButton(_skinData:SButton,_clickFun:Function=null)
		{
			this.skinData = _skinData;
			this.clickFun = _clickFun;
			
			this.buttonMode = true;
			this.mouseChildren = false;
			init();
		}
		private function init():void{
			skin = new Bitmap();
			this.addChildAt(skin,0);
			
			updateState(0);
			
			if(clickFun != null){
				this.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					clickFun(data);
				});
			}
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);
		}
		//=====================按钮皮肤状态切换============================///
		private function mouseOver(_arg1:MouseEvent):void
		{
			this.updateState(1);
		}
		private function mouseDown(_arg1:MouseEvent):void
		{
			this.updateState(2);
		}
		private function mouseUp(_arg1:MouseEvent):void{
			this.updateState(1);
		}
		private function mouseOut(_arg1:MouseEvent):void{
			this.updateState(0);
		}
		
		/**
		 * 切换指定状态皮肤 
		 * @param _arg1
		 */
		protected function updateState(_arg1:int):void
		{
			switch(_arg1)
			{
				case 0:
					this.skin.bitmapData = this.skinData.upSkin.bitmapData;
					break;
				case 1:
					this.skin.bitmapData = this.skinData.overSkin.bitmapData;
					break;
				case 2:
					this.skin.bitmapData = this.skinData.downSkin.bitmapData;
					break;
			}
		}
		
		override public function set width(value:Number):void{
			this.skin.width=value;
		}
		
		override public function get width():Number
		{
			return this.skin.width;
		}
		
		/**
		 *设置大小 
		 * @param w
		 * @param h
		 */		
		public function setSize(w:int,h:int):void{
			var _local3:int = getCurState();
			this.skinData.downSkin.setSize(w,h);
			this.skinData.upSkin.setSize(w,h);
			this.skinData.overSkin.setSize(w,h);
			this.updateState(_local3);
		}
		
		/**
		 * 获取当前状态 
		 * @return 
		 * 
		 */
		protected function getCurState():int
		{
			var _local2:int;
			if(this.skin.bitmapData == this.skinData.upSkin.bitmapData)
			{
				_local2 = 0;
			}
			else if(this.skin.bitmapData == this.skinData.overSkin.bitmapData)
			{
				_local2 = 1;
			}
			else if(this.skin.bitmapData == this.skinData.downSkin.bitmapData)
			{
				_local2 = 2;
			}
			return _local2;
		}
//		override public function set height(value:Number):void{
//			this,skin.height = value;
//		}
//		
//		override public function get height():Number
//		{
//			return this.skin.height;
//		}
//		
		/**
		 * 设置唯一数据 
		 * @param _value
		 */
		public function set datas(_value:Object):void
		{
			data = _value;
		}
		/**
		 * 获取唯一数据 
		 * @return 
		 */
		public function get datas():*
		{
			return 	data;
		}
	}
}