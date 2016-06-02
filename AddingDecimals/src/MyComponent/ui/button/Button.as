package MyComponent.ui.button
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import MyComponent.ui.mo.SButton;
	
	public class Button extends ImageButton
	{
		protected var upTextFormat:TextFormat;
		protected var overTextFormat:TextFormat;
		protected var downTextFormat:TextFormat;
		protected var offset:Point = new Point(10,5);////偏移位置
		
		private var label:TextField;
		
		public function Button(_str:String="",_tf:TextFormat=null,_width:int=120,_bskin:SButton=null,_clickFun:Function=null)
		{
			if(_tf === null){
				this.upTextFormat = TextFormatLib.format_0xffe304_14px;
				this.overTextFormat = TextFormatLib.format_0xffe88d_14px;
				this.downTextFormat = TextFormatLib.format_0xffe88d_14px;
			}else
			{
				this.upTextFormat = this.overTextFormat = this.downTextFormat = _tf;
			}
			
			label = new TextField();
			label.text = _str;
			label.autoSize="center";
			label.filters = [FilterLib.glow_0x272727];
			
			super(_bskin,_clickFun);
			
			addChild(label);
			setLabelPosition();
		}
		
		/**
		 * 更新状态 
		 * @param _arg1
		 */
		override protected function updateState(_arg1:int):void
		{
			super.updateState(_arg1);
			switch(_arg1)
			{
				case 0:
					textFormat = this.upTextFormat;
					break;
				case 1:
					textFormat = this.overTextFormat;
					break;
				case 2:
					textFormat = this.downTextFormat;
					break;
			}
			setLabelPosition();
		}
		
		/**
		 * 设置文本样式 
		 * @param _arg1
		 */
		public function set textFormat(_arg1:TextFormat):void
		{
			this.label.defaultTextFormat = _arg1;
		}
		
		/**
		 * 获取文本样式
		 * @return 
		 */
		public function get textFormat():TextFormat
		{
			return this.label.defaultTextFormat;
		}
		
		/**
		 * 获取文本 
		 * @return 
		 */
		public function get textLabel():String
		{
			return this.label.text;
		}
		/**
		 *设置文本居中 
		 */		
		public function setLabelPosition():void{
			label.x = (this.skin.width+offset.x-label.width)/2;
			label.y = (this.skin.height+offset.y-label.height)/2;
		}
	}
}