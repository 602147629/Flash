package src.compoment 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	/**单选按钮
	 * ...
	 * @author Mu
	 */
	public class RadioButton extends Sprite 
	{
		private var _label:TextField;
		private var _dotMc:MovieClip;
		private var _borderMc:MovieClip;
		
		private var _selected:Boolean = false;//是否选择
		private var _disabled:Boolean = false;//是否可选择
		private var _index:Number = -1;//索引
		public function RadioButton(labelStr:String="") 
		{
			_dotMc = dot;
			_borderMc = border;
			_label = label;
			_label.autoSize = "left";
			_label.text = labelStr;
			
			selected =  false;
			this.buttonMode = true;
			initEvent();
		}
		
		private function initEvent():void {
			this.addEventListener(MouseEvent.CLICK, clickHand);
		}
		private function clickHand(e:MouseEvent):void {
			if (!selected) {
				selected  = true;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		/**
		 * 是否选择
		 */
		public function get selected():Boolean {
			return _selected;
		}
		/**
		 * 是否选择
		 */
		public function set selected(boo:Boolean):void {
			_selected = boo;
			if (_selected) {
				_dotMc.visible = true;
			}else {
				_dotMc.visible = false;
			}
		}
		
		/**
		 * 是否可以选择
		 */
		public function set disabled(boo:Boolean):void {
			_disabled = boo;
			gray(boo);
		}
		/**
		 * 是否可以选择
		 */
		public function get disabled():Boolean {
			return _disabled;
		}
		
		public function set index(ind:Number):void {
			_index = ind;
		}
		public function get index():Number {
			return _index;
		}
		
		private function gray(boo:Boolean):void {
			if (boo) {
				var mat:Array =[0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
				var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
				this.filters = [colorMat];
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}else {
				this.filters = [];
				this.mouseChildren = true;
				this.mouseEnabled = true;
			}
		}
	}

}