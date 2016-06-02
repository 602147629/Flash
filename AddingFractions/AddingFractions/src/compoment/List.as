package src.compoment 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**List
	 * ...
	 * @author Mu
	 */
	public class List extends Sprite 
	{
		
		private var _selectIndex:Number = 0;//选择的索引
		private var _selectContent:String = ""; //选择的内容
		
		private var _bottomBg:MovieClip;//底部背景
		
		private var _listTotalHeight:Number = 0;//列表总高度
		private var _cellSpace:Number = 0;//格子间距
		
		private var _bg:MovieClip;
		public function List() 
		{
			super();
			initView();
		}
		private function initView():void {
			_bg = bg;
			
		}
		
		/**
		 * 创建列表
		 * @param	data  数据源
		 */
		public function createListByData(data:Array):void {
			var i:uint = 0;
			var len:uint = data.length;
			var cell:ListCell;
			for (i = 0; i < len; i++) {
				cell = new ListCell();
				addChild(cell);
				cell.y =12+ i * (cell.height + _cellSpace);
				_listTotalHeight += cell.height;
				cell.labels(data[i]);
				cell.index =  i;
				cell.addEventListener(MouseEvent.CLICK, cellClickHand);
			}
			
			_bg.height  = _listTotalHeight+15;
		}
		//cell 鼠标事件
		private function cellClickHand(e:MouseEvent):void {
			var target:ListCell =  e.currentTarget as ListCell;
			//if (selectIndex != target.index_) {
				selectIndex = target.index;
				dispatchEvent(new Event(Event.CHANGE));
			//}
		}
		/**
		 * 打开
		 */
		public function open():void {
			this.visible = true;
			//this.height = 0;
			//TweenLite.to(this, 0.5, { height:_bg.height,ease:Expo.easeOut} );
		}
		/**
		 * 关闭
		 */
		public function close():void {
			this.visible = false;
			//TweenLite.to(this, 0.5, { height:0,ease:Expo.easeOut, onComplete:overHand } );
		}
		//private function overHand():void {
			//this.visible = false;
		//}
		
		
		public function get selectIndex():Number 
		{
			return _selectIndex;
		}
		
		public function set selectIndex(value:Number):void 
		{
			_selectIndex = value;
		}
		
		public function get selectContent():String 
		{
			return _selectContent;
		}
		
		public function set selectContent(value:String):void 
		{
			_selectContent = value;
		}
	}
}