package src.compoment 
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import src.Global;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class ComboBox extends Sprite 
	{
		private var _list:List;//列表
		private var _data:Array=[];//数据源
		private var _selectIndex:Number = 0;//选择索引
		private var status:String;//当前状态
		
		private var _normalMc:MovieClip;
		private var _downMc:MovieClip;
		private var _label:TextField;
		private var _arrowMc:MovieClip;
		
		private var changeHand:Function;//选择函数
		/**
		 * 打开状态
		 */
		public static const OPEN:String = "open";
		/**
		 * 关闭状态
		 */
		public static const CLOSE:String = "close";
		/**
		 * 
		 * @param	changeFuns  选择处理函数
		 */
		public function ComboBox(changeFuns:Function = null) 
		{
			super();
			
			changeHand = changeFuns;
			
			initView();
			addEvent();
		}
		//初始化
		private function initView():void {
			status = CLOSE;
			
			_normalMc = normal;
			_downMc = downs;
			_label = label;
			_arrowMc  = arrow;
			
			_label.mouseEnabled = false;
			this.buttonMode = true;
			
			closeList();
		}
		//添加事件
		private function addEvent():void {
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDown);
			
			this.addEventListener(MouseEvent.CLICK, clickHand);
		}
		//舞台down事件
		private function stageDown(e:MouseEvent):void {
			if (!checkHit()) {
				closeList();
			}
		}
		private function clickHand(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (status == OPEN) {
				closeList();
				SoundManager.instance.playSound(SoundList.SOUND_CLOSE_COMBOX);
			}else if (status == CLOSE) {
				openList();
			}
		}
		//点击的区域是否在当前区域内，如果在区域内，不隐藏list
		private function checkHit():Boolean {
			return this.hitTestPoint(Global.stage.mouseX,Global.stage.mouseY);
		}
		
		//打开列表
		private function openList():void {
			if (!_list) {
				_list = new List();
				_list.addEventListener(Event.CHANGE, listChange);
				addChild(_list);
				_list.y = 40;
				_list.createListByData(data);
			}
			
			status = OPEN;
			_list.open();
			changeShow();
			
			SoundManager.instance.playSound(SoundList.SOUND_OPEN_COMBOX);
		}
		//关闭列表
		private function closeList():void {
			if (_list)
				_list.close();
			status = CLOSE;
			changeShow();
			
		}
		//选择改变
		private function listChange(e:Event):void {
			if (_list.selectIndex == selectIndex) {
				
			}else {
				selectIndex = _list.selectIndex;
				showLabel(_list.selectIndex);
				if (changeHand != null) {
					changeHand(selectIndex);	
				}
			}
		}
		/**
		 * 根据状态更变显示对象的显示
		 */
		private function changeShow():void {
			if (status == OPEN) {
				_normalMc.visible = false;
				_downMc.visible = true;
				TweenLite.to(_arrowMc, 0.2, {rotation:0} );
			}else if (status == CLOSE) {
				_normalMc.visible = true;
				_downMc.visible = false;
				TweenLite.to(_arrowMc, 0.2, {rotation:-90} );
			}
		}
		
		public function showLabel(index:Number):void {
			_label.text = data[index];
		}
		
		public function get selectIndex():Number 
		{
			return _selectIndex;
		}
		
		public function set selectIndex(value:Number):void 
		{
			_selectIndex = value;
		}
		
		public function get data():Array {
			return _data;
		}
		public function set data(da:Array):void {
			_data = da;
			showLabel(0);
		}
	}

}