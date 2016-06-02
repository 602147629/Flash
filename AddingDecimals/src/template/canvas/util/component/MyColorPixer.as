package template.canvas.util.component 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import morn.core.components.ColorPicker;
	
	/**自定义颜色选择器，带透明
	 * ...
	 * @author Mu
	 */
	public class MyColorPixer extends ColorPicker 
	{
		private var alphaSlider:MyAlphaSlider;
		public function MyColorPixer() 
		{
			super();
			initView();
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			_colorPanel.addChild(alphaSlider = new MyAlphaSlider());
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			alphaSlider.y = 170;
		}
		
		private function initView():void {
			setColorBlockSize(26, 26);
			selectedColor = 0x000000;
		}
		
		override public function close():void 
		{
			super.close();
			sendEvent(Event.CHANGE);//关闭时，获取一次alpha值
		}
		
		/**
		 * 设置颜色显示块的尺寸
		 * @param	w
		 * @param	h
		 */
		public function setColorBlockSize(w:Number, h:Number):void {
			_colorButton.setSize(w, h);
		}
		
		/**
		 * 设置alpha  label
		 * @param	con
		 */
		public function setAlphaLabel(con:String):void {
			alphaSlider.setLabel(con);
		}
		
		/**
		 * 获取透明度
		 */
		public function get alphaValue():Number {
			var value:Number = alphaSlider.getValues();
			return value / 100;
		}
		
	}

}