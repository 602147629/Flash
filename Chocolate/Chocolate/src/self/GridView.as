package src.self 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import src.Global;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	
	/**格子界面
	 * ...
	 * @author Mu
	 */
	public class GridView extends Sprite 
	{
		public const COLUMNS:Number = 18;
		public const ROWS:Number = 14;
		
		private var boxArr:Array = [];//盒子集合
		private var mouseDown:Boolean;//鼠标是否按下
		
		private var startPoint:Point;
		private var endPoint:Point;
		private var areaContainer:Sprite;//选择区域
		private var boxSize:Number;//盒子边长
		
		//计时器
		private var timer:Timer;
		
		//创建的需要操作的盒子集合
		private var operationBoxArr:Array = [];
		private var currentOperationBox:OperationBox;
		
		private var _oldSelected:Array = [];
		private var _isCanDraw:Boolean;
		
		//操作盒子是否按下
		private var _operationBoxDown:Boolean = false;
		
		//模式
		private const MODEL_1:String = "modle1";
		private const MODEL_2:String = "modle2";
		private const MODEL_3:String = "modle3";
		//巧克力模式
		private const CHOCOMATIC_MODEL_1:String = "BLACK";
		private const CHOCOMATIC_MODEL_2:String = "MILL";
		private const CHOCOMATIC_MODEL_3:String = "WHILTE";
		
		private var _modelArr:Array = [];
		private var _chocoModelArr:Array = [];
		//当前模式
		private var _currentModel:String = "";
		//当前巧克力模式
		private var _chocomaticModel:String = "";
		//填充数量
		private var _fillNumber:Number;
		//是否自动填充满
		private var _autoFill:Boolean;
		//是否显示数量
		private var _showNumber:Boolean;
		//是否显示标签
		private var _showLabel:Boolean;
		
		public var externalFun:Function;//外部调用函数
		
		private var leftContaienr:Sprite = new Sprite();//多余物体容器
		
		private var delCanSprite:Sprite;//删除参照物
		public function GridView()
		{
			createBottomBox();
			initView();
			initEvent();
		}
		//创建底部盒子
		private function createBottomBox():void {
			for (var i:int = 0; i < COLUMNS; i++) {
				for (var j:int = 0; j < ROWS; j++) {
					var mc:cellBox = new cellBox;
					mc.x = i * mc.width;
					mc.y = j * mc.height;
					mc.name = i +"-" + j + "";
					boxSize = mc.width;
					mc.xx = i;
					mc.yy = j;
					mc.type = -1;
					addChild(mc);
					boxArr.push(mc);
				}
			}
		}
		//添加事件
		private function initEvent():void {
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDown);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisDown);
		}
		//初始化界面
		private function initView():void {
			_modelArr.push(MODEL_1, MODEL_2, MODEL_3);
			_chocoModelArr.push(CHOCOMATIC_MODEL_1, CHOCOMATIC_MODEL_2, CHOCOMATIC_MODEL_3);
			
			areaContainer = new Sprite();
			addChild(areaContainer);
			
			timer = new Timer(40);
			timer.addEventListener(TimerEvent.TIMER, timerHand);
			
			currentModel = MODEL_1;
			chocomaticModel = CHOCOMATIC_MODEL_1;
			showNumber = false;
			
			addChild(leftContaienr);
			
			delCanSprite = new Sprite();
			delCanSprite.graphics.beginFill(0xff0000,0);
			delCanSprite.graphics.drawRect(0, 0, 30, 30);
			delCanSprite.graphics.endFill();
			delCanSprite.x = this.width - 15;
			delCanSprite.y = this.height -15;
			addChild(delCanSprite);
		}
		
		//舞台按下
		private function stageDown(e:MouseEvent):void {
			
		}
		//舞台抬起
		private function stageUp(e:MouseEvent):void {
			if (_operationBoxDown && checkDelHit()) {
				delBox();
				_operationBoxDown = false;
				return;
			}
			//操作盒子
			if (currentOperationBox && _operationBoxDown) {
				currentOperationBox.stopDrag();	
				var boo:Boolean;
				//if (!checkDelHit()) {
					if (checkHit()) {
						//if (checkDelHit()) {
							//boo = true;
						//}else {
							currentOperationBox.self_position = currentOperationBox.self_position;
						//}
					}else {
						var p1:Point;
						var ep1:Point;
						p1= currentOperationBox.localToGlobal(new Point(currentOperationBox.luDot.x+10, currentOperationBox.luDot.y+10));
						p1.x -= this.x;
						p1.y -= this.y;
						ep1= new Point(p1.x + Sprite(currentOperationBox.boderContainer).width-20, p1.y + Sprite(currentOperationBox.boderContainer).height-20);
						
						drawRects(areaContainer, p1, ep1);
						var arr:Array = selectBoxs(areaContainer);
						var boxs:Array = getBorderBox(arr);
						var lubox:cellBox = boxs[0];
						var rdbox:cellBox = boxs[1];
						
						currentOperationBox.self_position = new Point(lubox.x, lubox.y);
						p1= currentOperationBox.localToGlobal(new Point(currentOperationBox.luDot.x+10, currentOperationBox.luDot.y+10));
						p1.x -= this.x;
						p1.y -= this.y;
						ep1= new Point(p1.x + Sprite(currentOperationBox.boderContainer).width-20, p1.y + Sprite(currentOperationBox.boderContainer).height-20);
						drawRects(areaContainer, p1, ep1);
						
						updates();
						currentOperationBox.drawBorders();
						currentOperationBox.selfDrag = false;
						_operationBoxDown = false;
					}
				//}
			}
			
			if (mouseDown && currentOperationBox) {
				
				if (currentOperationBox.isDrag) {
					var p:Point = currentOperationBox.localToGlobal(new Point(currentOperationBox.luDot.x+10, currentOperationBox.luDot.y+10));
					p.x -= this.x;
					p.y -= this.y;
					var ep:Point = new Point(p.x + Sprite(currentOperationBox.boderContainer).width-20, p.y + Sprite(currentOperationBox.boderContainer).height-20);
					
					drawRects(areaContainer, p, ep);
					updates();
					currentOperationBox.drawBorders();
					currentOperationBox.isDrag = false;
				}else {
					currentOperationBox.drawBorders();
				}
				
				resetAll();
				mouseDown = false;
				_isCanDraw = false;
				timer.stop();
				//currentOperationBox = null;
				areaContainer.graphics.clear();
				//Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			}
			
			//if (checkDelHit() || boo) {
				//delBox();
			//}
		}
		//自身按下
		private function thisDown(e:MouseEvent):void {
			mouseDown = true;
			if (!(e.target is cellBox)) return;
			if (currentModel == MODEL_2 || currentModel == MODEL_3) return;
			var pp:Point = new Point(Global.stage.mouseX, Global.stage.mouseY);
			var box:cellBox = getClickBox(pp);
			if (!box || box.type != -1) return;
			_isCanDraw = true;
			currentOperationBox = new OperationBox();
			currentOperationBox.isShowNubers = showNumber;
			selectedBox(currentOperationBox);
			
			//调用函数
			currentOperationBox.fillProgressFuns = cellBoxFilling;
			currentOperationBox.fillCompleteFuns = cellBoxFilled;
			
			currentOperationBox.self_position = new Point(box.x, box.y);
			addChild(currentOperationBox);
			operationBoxArr.push(currentOperationBox);
			
			currentOperationBox.type = operationBoxArr.length;
			box.type = currentOperationBox.type;
			currentOperationBox.addEventListener(MouseEvent.MOUSE_DOWN, operationBoxDown);
			currentOperationBox.container = this;
			currentOperationBox.mcCollsion = [box];
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			startPoint = new Point(this.mouseX, this.mouseY);
			timer.start();
		}
		
		//填充中
		private function cellBoxFilling(val:String):void {
			if (externalFun != null) {
				externalFun(val);
			}
		}
		//填充完成
		private function cellBoxFilled():void {
			
		}
		
		//状态显示
		private function selectedBox(box:OperationBox):void {
			for (var i:int = 0; i < operationBoxArr.length; i++) {
				var bb:OperationBox = operationBoxArr[i];
				bb.selected(false);
			}
			box.selected(true);
		}
		
		//操作box按下
		private function operationBoxDown(e:MouseEvent):void {
			currentOperationBox = e.currentTarget as OperationBox;
			selectedBox(currentOperationBox);
			
			currentOperationBox.parent.setChildIndex(currentOperationBox, currentOperationBox.parent.numChildren - 1);
			if (currentModel == MODEL_1) {//编辑模式
				if (!currentOperationBox.isDrag) {
					_operationBoxDown = true;
					currentOperationBox.selfDrag = true;
					currentOperationBox.startDrag(false,new Rectangle(0,0,630-currentOperationBox.reallyW,490-currentOperationBox.reallyH));
				}
			}else if (currentModel == MODEL_2) {//着色模式
				leftContaienr.graphics.clear();
				if (currentOperationBox.fillAll) {
					cellBoxFilling("模具已经浇注过，请选择其他模具！");
					return;
				}
				if (autoFill) {
					currentOperationBox.drawColor(chocomaticModel,true);
				}else {
					currentOperationBox.drawColor2(chocomaticModel,fillNumber,leftContaienr);
				}
				//if (chocomaticModel == CHOCOMATIC_MODEL_1) {
					//currentOperationBox.setTColor(0xffffff);
				//}else if (chocomaticModel == CHOCOMATIC_MODEL_2) {
					//currentOperationBox.setTColor(0x00ff00);
				//}else{
					//currentOperationBox.setTColor(0xff9977);
				//}
			}else if (currentModel == MODEL_3) {
					if (!currentOperationBox.fillAll) {
						cellBoxFilling("模具还没有浇注，请浇注后在包装！");
						return;
					}
					if (currentOperationBox.isWrap) {
						currentOperationBox.wrapd(false, showLabel);
					}
					else {
						currentOperationBox.wrapd(true, showLabel);
					}
			}
		}
		
		/**
		 * 删除box
		 */
		public function delBox():void {	
			SoundManager.instance.playSound(SoundList.SOUND_DELETE);
			if (currentOperationBox) {
				currentOperationBox.resetBoxType();
				currentOperationBox.parent.removeChild(currentOperationBox);
				operationBoxArr.splice(operationBoxArr.indexOf(currentOperationBox), 1);
				currentOperationBox = null;
			}
		}
		
		private function checkDelHit():Boolean {
			if (currentOperationBox) {
				if (currentOperationBox.hitTestObject(delCanSprite)) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 删除所有
		 */
		public function delAll():void {
			SoundManager.instance.playSound(SoundList.SOUND_DELETE);
			leftContaienr.graphics.clear();
			for (var i:int = 0; i < operationBoxArr.length; i++) {
				var box:OperationBox = operationBoxArr[i];
				box.parent.removeChild(box);
				box.resetBoxType();
			}
			operationBoxArr = [];
			
		}
		
		private function checkHit():Boolean {
			var box:OperationBox;
			var i:int = 0;
			var len:uint = operationBoxArr.length;
			currentOperationBox.drawBorders();
			var crect:Rectangle = currentOperationBox.rec;
			for (i = 0; i < len; i++) {
				box = operationBoxArr[i];
				if (box == currentOperationBox) continue;
				var ret:Rectangle = box.rec;
				if (crect.intersects(ret)) {
					return true;
				}
			}
			return false;
		}
		
		//鼠标移动
		private function stageMove(e:MouseEvent):void {
			if (mouseDown && _isCanDraw) {
				endPoint = new Point(this.mouseX, this.mouseY);
				drawRects(areaContainer, startPoint, endPoint);
				//oldSelected = selectBoxs(areaContainer);
			}
			
			//拖拽边框
			if (currentOperationBox && currentOperationBox.isDrag) {
				var curp:Point = currentOperationBox.globalToLocal(new Point(stage.mouseX, stage.mouseY));
				var lup:Point = currentOperationBox.globalToLocal(new Point(this.x, this.y));
				var rup:Point = currentOperationBox.globalToLocal(new Point(int(this.x+630), this.y));
				var ldp:Point = currentOperationBox.globalToLocal(new Point(this.x, this.y+490));
				var rdp:Point = currentOperationBox.globalToLocal(new Point(int(this.x+630), int(this.y+490)));
				
				currentOperationBox.updateDragPosition(curp, lup, rup, ldp, rdp);
			}
		}
		
		//计时器函数
		private function timerHand(e:TimerEvent):void {
			updates();
		}
		
		/**
		 * 获取点击的box
		 * @param	clickp
		 * @return    获取box
		 */
		private function getClickBox(clickp:Point):cellBox {
			for (var i:int = 0; i < boxArr.length; i++) {
				var mc:cellBox = boxArr[i] as cellBox;
				if (mc.hitTestPoint(clickp.x, clickp.y)) {
					return mc;
				}
			}
			return null;
		}
		
		/**
		 * 拖动鼠标，绘制选择表示区域的矩形
		 * @param	container容器
		 * @param	sp开始坐标
		 * @param	ep结束坐标
		 */
		private function drawRects(container:Sprite, sp:Point, ep:Point):void {
			container.graphics.clear();
			container.graphics.lineStyle(1,0x00ccff,0);
			container.graphics.beginFill(0xcccccc,0);
			
			ep.x = ep.x<0?0:ep.x;
			ep.y = ep.y<0?0:ep.y;
			ep.x = ep.x > 0+this.width?0+this.width:ep.x;
			ep.y = ep.y > 0+this.height?0+this.height:ep.y;
			
			container.graphics.moveTo(sp.x,sp.y);
			container.graphics.lineTo(sp.x,ep.y);
			container.graphics.lineTo(ep.x,ep.y);
			container.graphics.lineTo(ep.x,sp.y);
			container.graphics.lineTo(sp.x,sp.y);
			container.graphics.endFill();
			
			container.parent.setChildIndex(container, container.parent.numChildren - 1);
		}
		
		
		private function updates():void {
			if (currentOperationBox) {
				var arr:Array = selectBoxs(areaContainer);
				var boxs:Array = getBorderBox(arr);
				var lubox:cellBox = boxs[0];
				var rdbox:cellBox = boxs[1];
				
				var boo:Boolean = checkType(arr);
				if (boo) return;
				
				if (lubox && rdbox) {
					currentOperationBox.updates(new Point(lubox.x, lubox.y), rdbox.xx - lubox.xx, rdbox.yy - lubox.yy);
					var arr1:Array = getArr(lubox, rdbox);
					currentOperationBox.mcCollsion = arr1;
				}
			}
		}
		
		private function resetAll():void {
			for (var i:int = 0; i < boxArr.length; i++) {
				var box:cellBox = boxArr[i] as cellBox;
				
				if (box.type == currentOperationBox.type && currentOperationBox.mcCollsion.indexOf(box) == -1) {
					box.type = -1;
				}
			}
		}
		
		/**
		 * 获取当前选择的box集合
		 * @param	container
		 * @return
		 */
		private function selectBoxs(container:Sprite):Array {
			var i:uint = 0;
			var len:uint = boxArr.length;
			var cell:cellBox;
			var arr:Array = [];
			for (i = 0; i < len; i++) {
				cell = boxArr[i] as cellBox;
				if (container.hitTestObject(cell)) {
					if (cell.type == -1) {
						cell.type = currentOperationBox.type;
						//cell.tt.text = currentOperationBox.type.toString();
					}
					arr.push(cell);
				}
			}
			
			return arr;
		}
		/**
		 * 当前选择的容器是否碰撞到了其他创建的物体
		 * @param	container
		 * @return
		 */
		private function hasHitBoxs():Boolean {
			var i:uint = 0;
			var len:uint = operationBoxArr.length;
			var box:OperationBox;
			for (i = 0; i < len; i++) {
				box = operationBoxArr[i] as OperationBox;
				if (box != currentOperationBox && currentOperationBox.hitTestObject(box)) {
					return true;
				}
			}
			
			return false;
		}
		/**
		 * 获取一个集合里左上 和 右下两个box
		 * @param	arr
		 * @return
		 */
		private function getBorderBox(arr:Array):Array {
			if (arr.length == 0) return [];
			var luBox:cellBox;
			var rdBox:cellBox;
			
			var i:uint = 0;
			var len:uint = arr.length;
			var box:cellBox;
			
			var minXX:Number=arr[0].xx;
			var minYY:Number=arr[0].yy;
			var maxXX:Number=arr[0].xx;
			var maxYY:Number=arr[0].yy;
			for (i = 0; i < len; i++) {
				box = arr[i] as cellBox;
				minXX = Math.min(minXX, box.xx);
				minYY = Math.min(minYY, box.yy);
				maxXX = Math.max(maxXX, box.xx);
				maxYY = Math.max(maxYY, box.yy);
			}
			
			luBox = getBox(minXX, minYY,arr);
			rdBox = getBox(maxXX, maxYY,arr);
			
			return [luBox,rdBox];
		}
		/**
		 * 获取单个box
		 * @param	xxx  xx值
		 * @param	yyy  yy值
		 * @param	arr   盒子集合
		 * @return    符合条件的box
		 */
		private function getBox(xxx:Number, yyy:Number,arr:Array):cellBox {
			var i:uint = 0;
			var len:uint = arr.length;
			var box:cellBox;
			for (i = 0; i < len; i++) {
				box = arr[i] as cellBox;
				if ( box.xx == xxx && box.yy ==yyy) {
					return box;
				}
			}
			
			return null;
		}
		
		private function hitPoint(p:Point):Boolean {
			var i:uint = 0;
			var len:uint = operationBoxArr.length;
			var box:OperationBox;
			for (i = 0; i < len; i++) {
				box = operationBoxArr[i] as OperationBox;
				if (box != currentOperationBox &&box.hitTestPoint(p.x,p.y)) {
					return true;
				}
			}
			
			return false;
		}
		/**
		 * 是否编辑模式
		 * @param	boo
		 */
		private function editModel(boo:Boolean):void {
			for (var i:int = 0; i < operationBoxArr.length; i++) {
				var box:OperationBox = operationBoxArr[i];
				if(!box.isDraw)
					box.dragDotVisible(boo);
				//if (!box.fillAll)
					//box.cancelDraw();
			}
		}
		
		//检查是否可以创建box
		private function checkType(arr:Array):Boolean {
			for (var i:int = 0; i < arr.length; i++) {
				var box:cellBox = arr[i] as cellBox;
				if (box.type !=currentOperationBox.type && box.type != -1) {
					return true;
				}
			}
			return false;
		}
		
		private function restoreBoxType(arr:Array):void {
			for (var i:int = 0; i < arr.length; i++) {
				var box:MovieClip = arr[i] as MovieClip;
				if (box.type ==currentOperationBox.type) {
					box.type = -1;
				}
			}
		}
		
		private function getArr(lu:cellBox,rd:cellBox):Array {
			var arr:Array = [];
			for (var i:int = 0; i < boxArr.length; i++) {
				var mc:cellBox  = boxArr[i] as cellBox;
				if (mc.xx >= lu.xx && mc.yy >= lu.yy && mc.xx <= rd.xx && mc.yy<=rd.yy) {
					arr.push(mc);
					mc.type = currentOperationBox.type;
				}
			}
			return arr;
		}
		
		public function get oldSelected():Array 
		{
			return _oldSelected;
		}
		
		public function set oldSelected(value:Array):void 
		{
			if (_oldSelected) {
				for (var i:int = 0; i < _oldSelected.length; i++) {
					var box:cellBox = _oldSelected[i] as cellBox;
					if (box.type == currentOperationBox.type) {
						box.type = -1;
					}
				}
			}
			_oldSelected = value;
		}
		
		public function get currentModel():String 
		{
			return _currentModel;
		}
		
		public function set currentModel(value:String):void 
		{
			_currentModel = value;
			if (_currentModel == MODEL_1) {
				editModel(true);
				cellBoxFilling("在设置模具模式下，点击格子拖拽，设计模具！");
				leftContaienr.graphics.clear();
			}else if(_currentModel == MODEL_2){
				editModel(false);
				cellBoxFilling("点击没有浇注的巧克力，浇注它！");
			}else if (_currentModel == MODEL_3) {
				leftContaienr.graphics.clear();
				editModel(false);
				cellBoxFilling("点击已经浇注的巧克力，包装或者打开它！");
			}
		}
		
		/**
		 * 显示边长
		 * @param	boo
		 */
		private function showBoxNumber(boo:Boolean):void {
			for (var i:int = 0; i < operationBoxArr.length; i++) {
				var box:OperationBox = operationBoxArr[i];
				box.showNubers(boo);
			}
		}
		
		public function get chocomaticModel():String 
		{
			return _chocomaticModel;
		}
		
		public function set chocomaticModel(value:String):void 
		{
			_chocomaticModel = value;
		}
		
		public function get fillNumber():Number 
		{
			return _fillNumber;
		}
		
		public function set fillNumber(value:Number):void 
		{
			_fillNumber = value;
		}
		
		public function get autoFill():Boolean 
		{
			return _autoFill;
		}
		
		public function set autoFill(value:Boolean):void 
		{
			_autoFill = value;
		}
		
		public function get showNumber():Boolean 
		{
			return _showNumber;
		}
		
		public function set showNumber(value:Boolean):void 
		{
			_showNumber = value;
			showBoxNumber(value);
		}
		
		public function get modelArr():Array 
		{
			return _modelArr;
		}
		
		public function set modelArr(value:Array):void 
		{
			_modelArr = value;
		}
		
		public function get chocoModelArr():Array 
		{
			return _chocoModelArr;
		}
		
		public function set chocoModelArr(value:Array):void 
		{
			_chocoModelArr = value;
		}
		
		public function get showLabel():Boolean 
		{
			return _showLabel;
		}
		
		public function set showLabel(value:Boolean):void 
		{
			_showLabel = value;
			if (currentOperationBox) {
				currentOperationBox.wrapd(currentOperationBox.isWrap, value);
			}
		}
		
	}//CLASS END
}