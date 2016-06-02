package template.canvas.util.component 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import morn.core.components.HSlider;
	import morn.core.components.Image;
	import morn.core.components.Label;
	
	/**透明度调节器
	 * ...
	 * @author Mu
	 */
	public class MyAlphaSlider extends Sprite 
	{
		private var _titleLabel:Label;
		private var _valueLabel:Label;
		private var _slider:HSlider;
		private var _bg:Image;
		
		private var _skin:String;
		private var _format:TextFormat;
		public function MyAlphaSlider(skin:String = "png.comp.hslider") 
		{
			_skin = skin;
			initView();
			setCoor();
		}
		
		private function initView():void {
			_bg = new Image("png.comp.blank");
			_bg.sizeGrid = "2,2,2,2";
			_bg.width = 200;
			_bg.height = 20;
			addChild(_bg);
			
			_format = new TextFormat();
			_format.size = 16;
			_format.color = 0xffffff;
						
			_titleLabel = new Label("title");
			_titleLabel.format
			_titleLabel.format = _format;
			addChild(_titleLabel);
			
			_slider = new HSlider(_skin);
			_slider.showLabel = false;
			_slider.sizeGrid = "2,2,2,2";
			_slider.width = 100;
			_slider.setSlider(0, 100, 100);
			_slider.x = 150;
			addChild(_slider);
			
			_valueLabel = new Label("value");
			_valueLabel.x = 400;
			_valueLabel.format = _format;
			addChild(_valueLabel);
			
			_valueLabel.text = _slider.value+"%";
			_slider.addEventListener(Event.CHANGE, changeH);
		}
		
		private function changeH(e:Event):void {
			_valueLabel.text = _slider.value+"%";
		}
		
		/**
		 * 设置位置
		 * @param	xx
		 * @param	yy
		 */
		public function setPosition(xx:Number, yy:Number):void {
			this.x = xx;
			this.y = yy;
		}
		
		/**
		 * 获取当前的透明值
		 * @return
		 */
		public function getValues():Number {
			return _slider.value;
		}
		
		/**
		 * 设置标签
		 * @param	con
		 */
		public function setLabel(con:String):void {
			_titleLabel.text = con;
			setCoor();
		}
		
		/////设置坐标
		private function setCoor():void {
			_titleLabel.x = 5;
			_titleLabel.y = (this.height - _titleLabel.height) /2;
			_slider.x = _titleLabel.x + _titleLabel.width + 10;
			_slider.y = (this.height - _slider.height) / 2;
			_valueLabel.x = _slider.x + _slider.width +10;
			_valueLabel.y = (this.height - _valueLabel.height) / 2;
			
			_bg.setSize(_valueLabel.x + _valueLabel.width + 5, this.height);
		}
	}

}