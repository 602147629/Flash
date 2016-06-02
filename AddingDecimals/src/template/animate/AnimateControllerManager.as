package template.animate 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import template.animate.event.AnimateControllerEvent;
	import template.utily.EventBridge;
	import template.utily.sound.SoundManager;
	
	/**动画控制条，控制器
	 * @author Mu
	 */
	public class AnimateControllerManager extends Sprite 
	{
		private static var _instance:AnimateControllerManager = new AnimateControllerManager();
		public function AnimateControllerManager() 
		{
			if (_instance) {
				throw new Error("单列类！");
			}else {
				addEvent();
			}
		}
		public static function get instance():AnimateControllerManager {
			return _instance;
		}
		
		//////播放状态
		private const STATUS_PLAY:String = "play";
		private const STATUS_PAUSE:String = "pause";
		
		
		/////线性控制器
		private var controlLine:ControllerLine;
		
		/////目标影片
		private var _targetMc:MovieClip;
		private function set targetMc(mc:MovieClip):void {
			_targetMc = mc;
		}
		private function get targetMc():MovieClip {
			return _targetMc;
		}
		
		/////是否正在播放中
		private var _isPlaying:Boolean = false;
		public function set isPlaying(boo:Boolean):void {
			_isPlaying = boo;
		}
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		/////是否播放到动画结尾
		private var _isPlayComplete:Boolean = false;
		public function set isPlayComplete(boo:Boolean):void {
			_isPlayComplete = boo;
		}
		public function get isPlayComplete():Boolean {
			return _isPlayComplete;
		}
		
		/////快进，快退，帧数设置
		private var _frameSpace:Number = 5;
		public function set frameSpace(n:Number):void {
			_frameSpace = n;
		}
		public function get frameSpace():Number {
			return _frameSpace;
		}
		
		/////是否可以拖拽
		private var _canDrag:Boolean = false;
		public function set canDrag(value:Boolean):void {
			_canDrag = value;
		}
		public function get canDrag():Boolean {
			return _canDrag;
		}
		
		/////是否循环播放
		private var _loop:Boolean = false;
		public function set loop(boo:Boolean):void {
			_loop = boo;
		}
		public function get loop():Boolean {
			return _loop;
		}
		
		//////音量值
		private var _volume:Number = 0.5;
		public function set volume(value:Number):void {
			_volume = value;
		}
		public function get volume():Number {
			return _volume;
		}
		
		////是否以创建控制条
		private var _isHava:Boolean = false;
		public function set isHave(value:Boolean):void {
			_isHava = value;
		}
		public function get isHave():Boolean {
			return _isHava;
		}
		/**
		 * 控制条
		 * @param	mc  要控制的时间轴影片
		 * @param	parentMc  控制条的父容器
		 * @param	isAutoPlay  是否自动播放
		 * @param	isCanDrag   是否可以拖拽  是否可以操作控制轴
		 * @param   isLoop 是否循环播放
		 * @return
		 */
		public function controlls(mc:MovieClip,parentMc:DisplayObjectContainer,isAutoPlay:Boolean = false, isCanDrag:Boolean = true,isLoop:Boolean = false):void {
			if (!mc || !parentMc) {
				return;
			}
			targetMc = null;
			targetMc = mc;
			canDrag = isCanDrag;
			loop = isLoop;
			targetMc.gotoAndStop(1);
			
			//////线性动画控制条
			if (controlLine && this.contains(controlLine)) {
				destory();
				this.removeChild(controlLine);
				controlLine = null;
			}
			controlLine = new ControllerLine();
			addChild(controlLine);
			isHave = true;
			
			setBtnEnabled();
			parentMc.addChild(this);
			
			/////////逻辑控制
			setVolumeByNumber(volume);
			if (isAutoPlay) {
				controlLine.status(STATUS_PLAY);
				targetMc.play();
				monitorMc();
			}else {
				controlLine.status(STATUS_PAUSE);
				targetMc.stop();
			}
		}
		/**
		 * 设置控制条在父容器中的位置
		 * @param	xx
		 * @param	yy
		 */
		public function setPosition(xx:Number, yy:Number):void {
			this.x = xx;
			this.y = yy;
		}
		
		////设置是否可以操作控制器
		private function setBtnEnabled():void {
			controlLine.setBtnEnabeld(!canDrag);
		}
		
		private var counter:Number = 0;///每隔几帧检测影片是不是在播放
		private var con:Number = 0;////记录当前帧
		/////监测播放的mc
		private function monitorMc():void {
			isPlaying = true;
			if (!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME, monitorMcHand);
			}
		}
		private function monitorMcHand(e:Event):void {
			var rate:Number = targetMc.currentFrame / targetMc.totalFrames;
			controlLine.setBarPosition(rate);
			
			////遇到stop,切换到停止状态
			counter ++;
			if (counter >= 2) {
				counter = 0;
				if (con == targetMc.currentFrame) {
					pauseMc();
				}
				con =  targetMc.currentFrame;
			}
			
			if (animateIsPlayEnd() && !loop) {
				isPlaying = false;
				this.removeEventListener(Event.ENTER_FRAME, monitorMcHand);
				targetMc.stop();
				controlLine.status(STATUS_PAUSE);
			}else if (animateIsPlayEnd() && loop) {
				stopMc();
				playMc();
			}
		}
		
		/////播放
		public function playMc():void {
			if (!targetMc) return;
			controlLine.status(STATUS_PLAY);
			//targetMc.play();   ***********************************layabox bug
			targetMc.nextFrame();
			targetMc.play();
			monitorMc();
		}
		/////暂停  save = "no"  不保存当前的播放状态 只在拖动的时候 暂停一下影片
		public function pauseMc(save:String=""):void {
			if (!targetMc) return;
			controlLine.status(STATUS_PAUSE);
			targetMc.stop();
			
			if(save == "") {
				isPlaying = false;
			}
			//if (this.hasEventListener(Event.ENTER_FRAME)) {  ***********************************layabox bug
				//this.removeEventListener(Event.ENTER_FRAME, monitorMcHand);
			//}
			
			try {
				this.removeEventListener(Event.ENTER_FRAME, monitorMcHand);
			}catch (e:Error) { };
		}
		/////停止
		public function stopMc():void {
			if (!targetMc) return;
			isPlaying = false;
			targetMc.gotoAndStop(1);
			controlLine.status(STATUS_PAUSE);
			controlLine.setBarPosition(0);
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, monitorMcHand);
			}
		}
		/////快退
		public function backFrames():void {
			if (!targetMc) return;
			var curr:Number = targetMc.currentFrame;
			curr -= frameSpace;
			curr = Math.max(1, curr);
			if (isPlaying) {
				targetMc.gotoAndPlay(curr);
				monitorMc();
			}else {
				targetMc.gotoAndStop(curr);
				controlLine.setBarPosition(targetMc.currentFrame / targetMc.totalFrames);
			}
		}
		/////快进
		public function fowardFrames():void {
			if (!targetMc) return;
			var curr:Number = targetMc.currentFrame;
			curr += frameSpace;
			curr = Math.min(targetMc.totalFrames, curr);
			if (isPlaying) {
				if (curr == targetMc.totalFrames) {
					targetMc.gotoAndStop(curr);
				}else {
					targetMc.gotoAndPlay(curr);
				}
				monitorMc();
			}else {
				targetMc.gotoAndStop(curr);
				controlLine.setBarPosition(targetMc.currentFrame / targetMc.totalFrames);
			}
		}
		
		/////销毁 释放资源 重置数据
		public function destory():void {
			try {
				controlLine.destory();
				this.parent.removeChild(this);
				isHave = false;
			}catch (e:Error) {
				//throw new Error("动画控制器，已经销毁，不能再次销毁！");
			}
			
			try {
				this.removeEventListener(Event.ENTER_FRAME, monitorMcHand);
			}catch (e:Error) {};
		}
		
		//////动画是否播结束
		private function animateIsPlayEnd():Boolean {
			if (!targetMc) {
				return false;
			}
			
			if (targetMc.currentFrame == targetMc.totalFrames) {
				isPlayComplete = true;
				return true;
			}
			isPlayComplete = false;
			return false;
		}
		
		/////注册事件
		private function addEvent():void {
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_PLAY_EVENT, playHandler);//播放
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_PAUSE_EVENT, pauseHandler);//暂停
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_BACK_EVENT, backHandler);//快退
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_FOWARD_EVENT, fowardHandler);//快进
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_STOP_EVENT, stopHandler);//停止
			
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_BAR_DOWN, animateBarDown);
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_BAR_UP, animateBarUp);
			EventBridge.instance.addEventListener(AnimateControllerEvent.ANIMATE_LINE_DOWN, animateLineDown);
			
			////声音
			EventBridge.instance.addEventListener(AnimateControllerEvent.SOUND_BAR_DOWN, soundBarDown);
			EventBridge.instance.addEventListener(AnimateControllerEvent.SOUND_BAR_UP, soundBarUp);
			EventBridge.instance.addEventListener(AnimateControllerEvent.SOUND_LINE_DOWN, soundLineDown);
			EventBridge.instance.addEventListener(AnimateControllerEvent.SOUND_MURE_DOWN, soundMureDown);
			EventBridge.instance.addEventListener(AnimateControllerEvent.SOUND_OPEN_DOWN, soundOpenDown);
		}
		private function playHandler(e:AnimateControllerEvent):void {
			playMc();
		}
		private function pauseHandler(e:AnimateControllerEvent):void {
			pauseMc();
		}
		private function backHandler(e:AnimateControllerEvent):void {
			backFrames();
		}
		private function fowardHandler(e:AnimateControllerEvent):void {
			fowardFrames();
		}
		private function stopHandler(e:AnimateControllerEvent):void {
			stopMc();
		}
		
		private function animateBarDown(e:AnimateControllerEvent):void {
			pauseMc("no");
			controlLine.update(lineUpdateHander);
		}
		private function animateBarUp(e:AnimateControllerEvent):void {
			controlLine.diposeUpdate();
			
			if (!animateIsPlayEnd()) {
				if (isPlaying) {
					playMc();
				}else {
					pauseMc();
				}
			}else {
				pauseMc("no");
			}
		}
		private function animateLineDown(e:AnimateControllerEvent):void {
			var data:Object = e.data;	
			var curr:Number = Math.round(data.rate * targetMc.totalFrames);
			if (isPlaying) {
				targetMc.gotoAndPlay(curr);
			}else {
				targetMc.gotoAndStop(curr);
			}
			controlLine.setBarPosition(targetMc.currentFrame/targetMc.totalFrames);
		}
		
		////拖拽时间线，更新动画
		private function lineUpdateHander():void {
			jumpToFrames(controlLine.getCurrentRate());
		}
		/////动画跳到某一帧
		private function jumpToFrames(rate:Number):void {
			if (!targetMc) return;
			var val:Number = Math.ceil(rate * targetMc.totalFrames);
			if (isPlaying) {
				targetMc.gotoAndPlay(val);
			}else {
				targetMc.gotoAndStop(val);
			}
			
			controlLine.setText(rate);
		}
		
		private function soundBarDown(e:AnimateControllerEvent):void {
			controlLine.update(setVolumeByBarPostion);
		}
		private function soundBarUp(e:AnimateControllerEvent):void {
			controlLine.diposeUpdate();
		}
		private function soundLineDown(e:AnimateControllerEvent):void {
			var data:Object = e.data;
			setVolumeByNumber(data.rate);
		}
		private function soundMureDown(e:AnimateControllerEvent):void {
			restoreSound();
		}
		private function soundOpenDown(e:AnimateControllerEvent):void {
			muteSound();
		}
		
		///////////////////////////////声音相关//////////////////////////////////
		/**
		 * 静音
		 */
		public function muteSound():void {
			setSoundValue(0, false);
			controlLine.setSoundShowByRate(0);
		}
		
		/**
		 * 恢复声音
		 */
		public function restoreSound():void {
			setSoundValue(volume);
			controlLine.setSoundShowByRate(volume);
		}
		
		/**
		 * 设置声音
		 * @param	value  音量大小 0-1
		 * @param	save   是否保存音量 静音时不需要保存
		 */
		public function setSoundValue(va:Number, save:Boolean=true):void {
			var value:Number = Math.max(0, va);
			value = Math.min(1, value);
			
			//var soundtf:SoundTransform = new SoundTransform();
			//soundtf.volume = value;
			//SoundMixer.soundTransform = soundtf;
			
			SoundManager.instance.volumeTotal(va);
			if (save) {
				volume = value;
			}
		}
		
		/**
		 * 更新音量大小
		 * @param	value 0-1
		 */
		public function setVolumeByNumber(value:Number):void {
			setSoundValue(value);
			restoreSound();
		}
		
		////根据bar的位置设置音量
		private function setVolumeByBarPostion():void {
			setVolumeByNumber(controlLine.getCurrentSoundRate());
		}
	}
}