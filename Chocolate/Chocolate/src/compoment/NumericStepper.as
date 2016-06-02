package src.compoment 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import src.Global;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	
	/**数字选择器
	 * ...
	 * @author Mu
	 */
	public class NumericStepper extends Sprite 
	{
		//界面素材
		private var _upBtn:DisplayObject;
		private var _downBtn:DisplayObject;
		private var _label:TextField;
		private var _bg:MovieClip;
		
		private var _numeric:Number=0;//显示数值
		private var _max:Number=0;//最大值
		private var _min:Number = 0;//最小值
		
		private var _time:Timer;
		private var _delayTime:Number = 0;
		private var _flag:String;
		private var numberChangeHand:Function;//数字改变处理函数
		public function NumericStepper(def:Number=0,min:Number=0,max:Number=10,changeHands:Function=null) 
		{
			_upBtn = upBtn;
			_downBtn = downBtn;
			_label = label;
			_bg = bg;
			numberChangeHand = changeHands;
			MovieClip(_upBtn).buttonMode = true;
			MovieClip(_downBtn).buttonMode = true;
			
			_label.autoSize = "center";
			_label.selectable = false;
			
			_min = min;
			_max = max;
			
			_upBtn.addEventListener(MouseEvent.CLICK, upHand);
			_downBtn.addEventListener(MouseEvent.CLICK, downHand);
			
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			numeric = def;
			
			_time = new Timer(100);
			_time.addEventListener(TimerEvent.TIMER, timeHand);
		}
		
		private function timeHand(e:TimerEvent):void {
			_delayTime++;
			if (_delayTime > 3 && _flag == "up") {
				numeric++;
				numeric = Math.min(numeric, _max);
			}else if (_delayTime > 3 && _flag == "down") {
				numeric--;
				numeric = Math.max(numeric, _min);
			}
		}
		
		private function mouseDown(e:MouseEvent):void {
			_time.start();
			if (e.target == _upBtn) {
				_flag = "up";
			}else if(e.target == _downBtn) {
				_flag = "down";
			}
		}
		
		private function stageUp(e:MouseEvent):void {
			_time.stop();
			_delayTime = 0;
		}
		
		private function upHand(e:MouseEvent):void {
			numeric++;
			SoundManager.instance.playSound(SoundList.SOUND_NUMSEL);
			//numeric = Math.min(numeric, _max);
			//BtnEnabled("all", true);
			//if (numeric == _max) {
				//BtnEnabled("left", false);	
			//}
		}
		private function downHand(e:MouseEvent):void {
			numeric--;
			SoundManager.instance.playSound(SoundList.SOUND_NUMSEL);
			//numeric = Math.max(numeric, _min);
			//BtnEnabled("all", true);
			//if (numeric == _min) {
				//BtnEnabled("right", false);	
			//}
			
		}
		/**
		 * 是否显示背景
		 * @param	boo
		 */
		public function showbg(boo):void {
			_bg.visible = boo;
		}
		/**
		 * 获取数值
		 */
		public function get numeric():Number {
			return _numeric;
		}
		/**
		 * 获取数值
		 */
		public function set numeric(val:Number):void {
			_numeric = val;
			_numeric = Math.max(_numeric, _min);
			_numeric = Math.min(_numeric, _max);
			_label.text = _numeric.toString();
			//SoundManager.instance.playSound(SoundList.SOUND_NUMSEL);
			if (numberChangeHand != null) {
				numberChangeHand(_numeric,this);
			}
		}
		
		public function get max():Number 
		{
			return _max;
		}
		
		public function set max(value:Number):void 
		{
			_max = value;
		}
		
		public function get min():Number 
		{
			return _min;
		}
		
		public function set min(value:Number):void 
		{
			_min = value;
		}
		/**
		 * 按钮是否可用
		 * @param	flag  left right  all
		 * @param	boo  是否可用
		 */
		public function BtnEnabled(flag:String,boo:Boolean):void {
			if (flag == "up") {
				MovieClip(_upBtn).mouseEnabled = boo;
				if (boo) {
					MovieClip(_upBtn).alpha = 1;
				}else {
					MovieClip(_upBtn).alpha = 0.5;
				}
			}else if (flag == "down") {
				MovieClip(_downBtn).mouseEnabled = boo;
				if (boo) {
					MovieClip(_downBtn).alpha = 1;
				}else {
					MovieClip(_downBtn).alpha = 0.5;
				}
			}else if (flag == "all") {
				MovieClip(_upBtn).mouseEnabled = boo;
				MovieClip(_downBtn).mouseEnabled = boo;
				if (boo) {
					MovieClip(_upBtn).alpha = 1;
					MovieClip(_downBtn).alpha = 1;
				}else {
					MovieClip(_upBtn).alpha = 0.5;
					MovieClip(_downBtn).alpha = 0.5;
				}
			}
		}
	}

}