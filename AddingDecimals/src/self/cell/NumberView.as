package self.cell 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**显示数字
	 * ...
	 * @author Mu
	 */
	public class NumberView extends Sprite 
	{
		private var _contentTxt:TextField;
		private var _format:TextFormat;
		private var can:Sprite;///设置中心位置参照物
		public function NumberView(canMc:Sprite) 
		{
			can = canMc;
			
			_contentTxt = new TextField();
			_contentTxt.autoSize = "left";
			_contentTxt.selectable = false;
			_contentTxt.x = _contentTxt.y = 0;
			addChild(_contentTxt);
			
			_format = new TextFormat();
			_format.size = 120;
			_format.color = 0x000000;
			_format.align = "center";
			
			_contentTxt.defaultTextFormat = _format;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.alpha = 0.3;
		}
		/**
		 * 设置数字
		 * @param	num
		 */
		public function setNum(num:Number):void {
			_contentTxt.text = num + "";
			center();
			
			//this.graphics.clear();
			//this.graphics.beginFill(0x000000);
			//this.graphics.drawRect(0, 0, this.width, this.height);
		}
		/**
		 * 在父容器中置顶
		 */
		public function up():void {
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		////位置居中
		private function center():void {
			this.x = (can.width - this.width) / 2;
			this.y = (can.height - this.height) / 2;
		}
		
		override public function get visible():Boolean 
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void 
		{
			super.visible = value;
		}	
	}

}