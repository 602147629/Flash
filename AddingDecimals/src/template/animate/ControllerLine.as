package template.animate 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.ui.templateView.ControllerViewUI;
	import template.animate.event.AnimateControllerEvent;
	import template.animate.view.ControllerLineUI;
	import template.utily.EventBridge;
	/**
	 * 线性动画动画控制器
	 * @author Mu
	 */
	public class ControllerLine extends ControllerViewUI 
	{
		
		private var startPoint:Point;
		private var totalLength:Number;
		
		private var soundStartPoint:Point;
		private var soundTotalLength:Number;
		
		private var anBarIsDwon:Boolean = false;//动画bar是否按下
		private var soundBarIsDown:Boolean = false;//声音bar是否按下
		public function ControllerLine() 
		{
			super();
			initView();
			addEvent();
		}
		/////初始化显示元素
		private function initView():void {
			startPoint = new Point(line.x - bar.width / 2, bar.y);
			totalLength = line.width;
			flag_line.mouseEnabled = false;
			sound_flagline.mouseEnabled = false;
			
			soundStartPoint = new Point(sound_line.x - soundbar.width / 2, soundbar.y);
			soundTotalLength = sound_line.width;
			
			reset();
		}
		/////添加事件
		private function addEvent():void {
			bar.addEventListener(MouseEvent.MOUSE_DOWN, barDown);
			line.addEventListener(MouseEvent.MOUSE_DOWN, lineDown);
			
			btn_play.addEventListener(MouseEvent.MOUSE_DOWN, playDown);
			btn_pause.addEventListener(MouseEvent.MOUSE_DOWN, pauseDown);
			btn_pre.addEventListener(MouseEvent.MOUSE_DOWN, preDown);
			btn_next.addEventListener(MouseEvent.MOUSE_DOWN, nextDown);
			btn_stop.addEventListener(MouseEvent.MOUSE_DOWN, stopDown);
			
			btn_soundOpen.addEventListener(MouseEvent.MOUSE_DOWN, soundOpenDwon);
			btn_mute.addEventListener(MouseEvent.MOUSE_DOWN, muteDown);
			soundbar.addEventListener(MouseEvent.MOUSE_DOWN, soundBarDown);
			sound_line.addEventListener(MouseEvent.MOUSE_DOWN, soundLineDown);
			
			App.stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHand);
		}
		
		private function barDown(e:MouseEvent):void {
			anBarIsDwon = true;
			bar.startDrag(false, new Rectangle(startPoint.x, line.y, totalLength, 0));
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_BAR_DOWN, data));
		}
		
		private function lineDown(e:MouseEvent):void {
			var data:Object = { };
			data.rate = line.mouseX / totalLength;
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_LINE_DOWN, data));
		}
		private function playDown(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_PLAY_EVENT, data));
		}
		private function pauseDown(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_PAUSE_EVENT, data));
		}
		private function preDown(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_BACK_EVENT, data));
		}
		private function nextDown(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_FOWARD_EVENT, data));
		}
		private function stopDown(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_STOP_EVENT, data));
		}
		
		private function soundOpenDwon(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.SOUND_OPEN_DOWN, data));
		}
		private function muteDown(e:MouseEvent):void {
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.SOUND_MURE_DOWN, data));
		}
		private function soundBarDown(e:MouseEvent):void {
			soundBarIsDown = true;
			soundbar.startDrag(false, new Rectangle(soundStartPoint.x, soundStartPoint.y, soundTotalLength, 0));
			
			var data:Object = { };
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.SOUND_BAR_DOWN, data));
		}
		private function soundLineDown(e:MouseEvent):void {
			var data:Object = { };
			data.rate = sound_line.mouseX / soundTotalLength;
			EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.SOUND_LINE_DOWN, data));
		}
		
		private function stageUpHand(e:MouseEvent):void {
			e.stopPropagation();
			if (anBarIsDwon) {
				anBarIsDwon = false;
				bar.stopDrag();
				
				var data:Object = { };
				EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.ANIMATE_BAR_UP, data));
			}
			
			if (soundBarIsDown) {
				soundBarIsDown = false;
				soundbar.stopDrag();
				
				var data1:Object = { };
				EventBridge.instance.dispatchEvent(new AnimateControllerEvent(AnimateControllerEvent.SOUND_BAR_UP, data1));
			}
		}
		/**
		 * 设置bar的位置
		 * @param	rate  当前为值的比例值
		 */
		public function setBarPosition(rate:Number):void {
			bar.x = startPoint.x + rate * totalLength;
			setText(rate);
		}
		
		//////设置显示文本
		public function setText(rate:Number):void {
			animate_label.text = int(rate * 100).toString() + "%";
			flag_line.width = int(rate * totalLength)+1;
		}
		
		/**
		 * 获取当前 bar/line 的比率值
		 * @return
		 */
		public function getCurrentRate():Number {
			return (bar.x - startPoint.x) / totalLength;
		}
		/**
		 * 获取音量控制条的位置比率
		 * @return
		 */
		public function getCurrentSoundRate():Number {
			return (soundbar.x - soundStartPoint.x) / soundTotalLength;
		}
		
		/**
		 * 设置播放状态 按钮状态
		 * @param	flag  "play"  "pause"
		 */
		public function status(flag:String):void {
			if (flag == "play") {
				btn_play.visible = false;
				btn_pause.visible = true;
			}else if (flag == "pause") {
				btn_play.visible = true;
				btn_pause.visible = false;
			}
		}
		
		/**
		 * 重置
		 */
		public function reset():void {
			bar.x = startPoint.x;
			flag_line.x = line.x;
			flag_line.height = 2;
			flag_line.width = 1;
			flag_line.y = bar.y + bar.height / 2;
			
			
			soundbar.x = soundStartPoint.x;
			sound_flagline.x = sound_line.x;
			sound_flagline.height = 2;
			sound_flagline.width = 1;
			sound_flagline.y = soundbar.y + soundbar.height / 2-1;
		}
		
		/**
		 * 销毁，释放资源
		 */
		public function destory():void {
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, barDown);
			line.removeEventListener(MouseEvent.MOUSE_DOWN, lineDown);
			
			btn_play.removeEventListener(MouseEvent.MOUSE_DOWN, playDown);
			btn_pause.removeEventListener(MouseEvent.MOUSE_DOWN, pauseDown);
			btn_pre.removeEventListener(MouseEvent.MOUSE_DOWN, preDown);
			btn_next.removeEventListener(MouseEvent.MOUSE_DOWN, nextDown);
			btn_stop.removeEventListener(MouseEvent.MOUSE_DOWN, stopDown);
			
			btn_soundOpen.removeEventListener(MouseEvent.MOUSE_DOWN, soundOpenDwon);
			btn_mute.removeEventListener(MouseEvent.MOUSE_DOWN, muteDown);
			soundbar.removeEventListener(MouseEvent.MOUSE_DOWN, soundBarDown);
			sound_line.removeEventListener(MouseEvent.MOUSE_DOWN, soundLineDown);
			
			App.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUpHand);
			
			diposeUpdate();
		}
		
		private var enterHander:Function = null;
		/**
		 * 开始实时检测器
		 * @param	hander  监测的函数
		 */
		public function update(hander:Function):void {
			
			enterHander = hander;
			
			if (!this.hasEventListener(Event.ENTER_FRAME)) {
				this.addEventListener(Event.ENTER_FRAME, enterHand);
			}
		}
		
		private function enterHand(e:Event):void {
			enterHander();
		}
		
		/**
		 * 销毁检测器
		 */
		public function diposeUpdate():void {
			//if (this.hasEventListener(Event.ENTER_FRAME)) {    *********************************** layabox bug
				try {
					this.removeEventListener(Event.ENTER_FRAME, enterHand);
				}catch (e:Error) {
					
				}
			//}
		}
		
		/**
		 * 设置声音显示
		 * @param	rate  0-1
		 */
		public function setSoundShowByRate(rate:Number):void {
			var volume:Number = Math.min(rate, 1);
			volume = Math.max(0, volume);
			
			sound_label.text = Math.ceil(rate * 100) + "%";
			soundbar.x = soundStartPoint.x + rate * soundTotalLength;
			sound_flagline.width = soundbar.x - soundStartPoint.x+1;
			
			if (volume == 0) {
				btn_mute.visible = true;
				btn_soundOpen.visible = false;
			}else {
				btn_mute.visible = false;
				btn_soundOpen.visible = true;
			}
		}
		
		/**
		 * 设置按钮是否可以操作
		 * @param	boo
		 */
		public function setBtnEnabeld(boo:Boolean):void {
			btn_pre.disabled = boo;
			btn_next.disabled = boo;
			btn_stop.disabled = boo;
			bar.disabled = boo;
			line.disabled = boo;
		}
	}
}