package self.cell 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import MyComponent.ui.SkinManager;
	/**
	 * ...
	 * @author Mu
	 */
	public class Box extends Sprite 
	{
		private var _boxCellArr:Array = [];//格子总数数组
		private var _tempSelectArr:Array = [];//临时存放选择的数据
		
		private var bottomSprite:Sprite;///底部大格子，底部格子的宽高是限制选择区域的大小
		public var selectAreaContaienr:Sprite;//选择矩形临时容器
		
		private var startPoint:Point;//选择区域开始点
		private var endPoint:Point;//选择区域结束点
		
		private var tempSelectContainer:Sprite;//选择物体临时组合容器
		public var tempSelectContainerDrag:Boolean = false;//选择物体临时组合容器是否在拖拽中
		private var isDownArea:Boolean = false;//是否按下鼠标
		
		private var _isDrawArea:Boolean = false;//鼠标抬起的时候记录一个值，是否在进行绘制选择矩形
		
		private var _selectSrcPosition:Point=new Point();;//物体原来坐标
		
		private var srcBorderColor:uint = 0xD55056;//物体边框颜色
		private var srcContentColor:uint = 0xF9ADA4//物体内容颜色
		private var selectBorderColor:uint = 0x000000;//选择物体边框颜色
		
		private var _groupInfo:String;///分组信息<暂时没用到>
		
		private var _numView:NumberView;//显示数字容器
		public function Box(_width:Number=300,_height:Number=300,_thinkNess:Number=1,_lineColor:uint=0x000000,_color:uint=0xffffcc,_alpha:Number=1) 
		{
			super();
			drawBottomSprite(_width, _height, _thinkNess, _lineColor, _color, _alpha);
			initFuns();
			addEvent();
		}
		////绘制底部背景
		private function drawBottomSprite(w:Number, h:Number,thinkNess:Number,lineColor:uint,color:uint, al:Number):void {
			bottomSprite = new Sprite();
			addChild(bottomSprite);
			bottomSprite.graphics.beginFill(color, al);
			//bottomSprite.graphics.lineStyle(thinkNess, lineColor, al);
			bottomSprite.graphics.drawRect(0, 0, w, h);
			bottomSprite.graphics.endFill();
		}
		////初始化
		private function initFuns():void {
			selectAreaContaienr = new Sprite();
			addChild(selectAreaContaienr);
			
			bottomSprite.addEventListener(MouseEvent.MOUSE_DOWN, bottomDown);
			
			restorColor(boxCellArr, srcBorderColor);
			
			_numView = new NumberView(bottomSprite);
			addChild(_numView);
			_numView.setNum(0);
			
			numViewVisible(false);
		}
		
		
		private function bottomDown(e:MouseEvent):void {
			//e.stopImmediatePropagation();
			isDownArea = true;
			startPoint = new Point(this.mouseX, this.mouseY);
			if(!App.stage.hasEventListener(MouseEvent.MOUSE_MOVE))
				App.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMoveH);
		}
		////事件
		private function addEvent():void {
			//if (!App.stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				App.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			//}
			//if (!App.stage.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				App.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDown);
			//}
		}
		private function stageUp(e:MouseEvent):void {
			//trace("box 在舞台上UP");
			if (isDownArea) {
				if (selectAreaContaienr.width != 0) {
					//trace("---------");
					tempSelectArr = checkHit(selectAreaContaienr, boxCellArr);
					changeColor(tempSelectArr);
					_isDrawArea = true;
				}else {
					_isDrawArea = false;
				}
				
				isDownArea = false;
				clearRect(selectAreaContaienr);
			}
			
			if (tempSelectContainer && tempSelectContainerDrag) {
				tempSelectContainerDrag = false;
				tempSelectContainer.stopDrag();
			}
			
			numViewUp();
			
			if(App.stage.hasEventListener(MouseEvent.MOUSE_MOVE))
				App.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveH);
		}
		private function stageDown(e:MouseEvent):void {
			changeOperation();
		}
		//改变物体容器的一些操作
		private function changeOperation():void {
			if (tempSelectArr.length != 0) {
				//trace("打撒容器！");
				tempSelectContainerDrag = false;
				changeParentsContainer(tempSelectArr,this);
				tempSelectContainer.parent.removeChild(tempSelectContainer);
				restorColor(tempSelectArr,srcBorderColor);
				tempSelectContainer = null;
				tempSelectArr = [];
				numViewUp();
			}
		}
		
		///舞台上移动鼠标
		private function stageMoveH(e:MouseEvent):void {
			if(isDownArea){///如果在大背景上按下鼠标，拖动鼠标，表示当前需要选择多个物体
				endPoint = new Point(this.mouseX,this.mouseY);
				drawRects(selectAreaContaienr,startPoint,endPoint);
			}
		}
		/**
		 * 拖动鼠标，绘制选择表示区域的矩形
		 * @param	container容器
		 * @param	sp开始坐标
		 * @param	ep结束坐标
		 */
		private function drawRects(container:Sprite,sp:Point,ep:Point):void{
			container.graphics.clear();
			container.graphics.lineStyle(1,0x00ccff,1);
			container.graphics.beginFill(0xcccccc,0.3);
			if(bottomSprite)
			{
				ep.x = ep.x<bottomSprite.x?bottomSprite.x:ep.x;
				ep.y = ep.y<bottomSprite.y?bottomSprite.y:ep.y;
				ep.x = ep.x > bottomSprite.x+bottomSprite.width?bottomSprite.x+bottomSprite.width:ep.x;
				ep.y = ep.y > bottomSprite.y+bottomSprite.height?bottomSprite.y+bottomSprite.height:ep.y;
			}
			
			container.graphics.moveTo(sp.x,sp.y);
			container.graphics.lineTo(sp.x,ep.y);
			container.graphics.lineTo(ep.x,ep.y);
			container.graphics.lineTo(ep.x,sp.y);
			container.graphics.lineTo(sp.x,sp.y);
			container.graphics.endFill();
			
			container.parent.setChildIndex(container, container.parent.numChildren - 1);
		}
		/**
		 * 检查碰撞，当前所有的物体，和临时选择区域的碰撞，表示当前选取了那些物体
		 * @param	areamc  当前临时选择矩形区域
		 * @param	arr    全部物体
		 * @return
		 */
		private function checkHit(areamc:Sprite,arr:Array):Array{
			var tempArr:Array = [];
			for(var i:int = 0;i<arr.length;i++){
				var mc:MovieClip = arr[i] as MovieClip;
				if(areamc.hitTestObject(mc)){
					tempArr.push(mc);
				}
			}
			return tempArr;
		}
		
		/**
		 * 改变选择的物体的外边框的颜色，后期样式可以自定义修改
		 * @param	arr  当前选择的物体集合
		 */
		private function changeColor(arr:Array):void {
			if (!tempSelectContainer) {
				tempSelectContainer = new Sprite();
				addChild(tempSelectContainer);
				tempSelectContainer.parent.setChildIndex(tempSelectContainer, tempSelectContainer.parent.numChildren - 1);
				tempSelectContainer.name = "selectContaienr";
				tempSelectContainer.addEventListener(MouseEvent.MOUSE_DOWN, tempSDownH, true);
				//tempSelectContainer.alpha = 0.7;
			}
			//trace("tempSelectArr:",tempSelectArr.length);
			var p:Point = minPosition(tempSelectArr);
			tempSelectContainer.x = p.x;
			tempSelectContainer.y = p.y;
			updatePosition();
			for(var i:int = 0;i<arr.length;i++){
				var mc:MovieClip = arr[i] as MovieClip;
				var cf:ColorTransform = new ColorTransform();
				mc.wborder.visible = true;
				cf.color = selectBorderColor;
				mc.wborder.transform.colorTransform = cf;
				tempSelectContainer.addChild(mc);
				mc.x = mc.x - p.x;
				mc.y = mc.y - p.y;
			}
			//tempSelectContainer.addEventListener(MouseEvent.MOUSE_DOWN, tempSDownH);
			//trace("....:", tempSelectContainer.numChildren);
			//tempSelectContainer.graphics.beginFill(0xff0000);
			//tempSelectContainer.graphics.drawRect(0, 0, tempSelectContainer.width, tempSelectContainer.height);
			//tempSelectContainer.graphics.endFill();
		}
		
		//临时物体组合容器鼠标按下事件，开时拖动
		private function tempSDownH(e:MouseEvent):void {
			e.stopImmediatePropagation();
			//trace("临时容器down");
			tempSelectContainer.parent.setChildIndex(tempSelectContainer, tempSelectContainer.parent.numChildren - 1);
			_isDrawArea = false;
			tempSelectContainerDrag = true;
			tempSelectContainer.startDrag();
		}
		/**
		 * 清楚选择区域矩形
		 * @param	container 选择区域容器
		 */
		private function clearRect(container:Sprite):void{
			container.graphics.clear();
		}
		/**
		 * 取消多物体选择时，恢复之前选择的物体的颜色
		 * @param	arr 物体集合
		 * @param	color 颜色值
		 */
		private function restorColor(arr:Array,color:uint=0x000000):void{
			for(var i:int = 0;i<arr.length;i++){
				var mc:MovieClip = arr[i] as MovieClip;
				//var cf:ColorTransform = new ColorTransform();
				//cf.color =color;
				//mc.wborder.transform.colorTransform = cf;
				mc.wborder.visible = false;
			}
		}
		/**
		 * 打撒组合物体，改变组合物体的父容器
		 * @param	arr 组合物体集合
		 * @param	container  打撒后，放到这个容器里
		 */
		private function changeParentsContainer(arr:Array,container:DisplayObjectContainer):void{
			var currentGlobalPoint:Point;
			var newLocalPoint:Point;
			for(var i:int = 0;i<arr.length;i++){
				var mc:MovieClip = arr[i] as MovieClip;
				currentGlobalPoint = mc.parent.localToGlobal(new Point(mc.x,mc.y));
				container.addChild(mc);
				newLocalPoint = container.globalToLocal(currentGlobalPoint);
				mc.x = newLocalPoint.x;
				mc.y = newLocalPoint.y;
			}
		}
		/**
		 * 获取临时组合容器物体的最小坐标
		 * @param	arr
		 * @return
		 */
		private function minPosition(arr:Array):Point {
			var tempMinX:Number=1000;
			var tempminY:Number=1000;
			for (var i:int = 0; i < arr.length; i++) {
				var mc:MovieClip = arr[i] as MovieClip;
				tempMinX = Math.min(tempMinX, mc.x);
				tempminY = Math.min(tempminY, mc.y);
			}
			
			return new Point(tempMinX, tempminY);
		}
		
		//=================================================public ==========================
		public static const TYPE_DELETE:String = "DELETE";
		public static const TYPE_HUNDREDS:String = "HUNDREDS";
		public static const TYPE_TENS:String = "TENS";
		public static const TYPE_ONES:String = "ONES";
		
		private var _type:String;
		/**
		 * 获取类型
		 */
		public function set type(value:String):void {
			_type = value;
		}
		/**
		 * 获取类型
		 */
		public function get type():String {
			return _type;
		}
		
		/**<暂时没用到>
		 * 根据类型处理
		 * @param	types
		 */
		public function chackType(flag:String):void {
			if (type == TYPE_HUNDREDS) {
				if (flag == TYPE_DELETE) {
				
				}else if (flag == TYPE_HUNDREDS) {
					
				}else if (flag == TYPE_TENS) {
						
				}else if (flag == TYPE_ONES) {
					
				}
			}
		}
		
		/**
		 * 全部物体的集合
		 */
		public function get boxCellArr():Array {
			return _boxCellArr;
		}
		/**
		 * 全部物体的集合
		 */
		public function set boxCellArr(value:Array):void {
			_boxCellArr = value;
			
			for (var i:int = 0; i < value.length; i++) {
				var mc:MovieClip = value[i] as MovieClip;
				addChild(mc);
				mc.addEventListener(MouseEvent.MOUSE_DOWN, singleDown,true);
				mc.x = i * 25;
				mc.y = i * 25;
			}
			
			updateNum();
		}
		
		/**
		 * 添加单个物体
		 * @param	mc
		 */
		public function addGood(mc:MovieClip):void {
			boxCellArr.push(mc);
		}
		
		/**
		 * 创建自身类型的物体 
		 * @param	num  个数
		 */
		public function createBoxs(num:uint,startX:Number=3,startY:Number=3):void {
			var flag:String;
			if (type == TYPE_HUNDREDS) {
				flag = "hundreds";
			}else if (type == TYPE_TENS) {
				flag = "tens";
			}else if (type == TYPE_ONES) {
				flag = "ones";
			}
			
			var mc:MovieClip;
			var tempX:Number = 3;
			var tempY:Number = 3;
			var countX:Number = 0;
			var countY:Number = 0;
			var tempValue:Number = 30; //修正值
			for (var i:int = 0; i < num; i++) {
				mc = SkinManager.instance.getObjectByName(flag) as MovieClip;
				addChild(mc);
				//trace("i：", i, "value:", tempX,"bottomSprite:",bottomSprite.width);
				if (flag == "ones") {
					if (tempX + mc.width > bottomSprite.width-tempValue ) {
					countY++;
					if (tempY +mc.height > bottomSprite.height-tempValue) {
						countY = 0;
					}
					countX = 0;
					}
					tempX = startX + countX * 24;
					tempY = startY + countY * 24;
					countX++;
				}else if (flag == "tens" || flag == "hundreds") {
					tempX = startX;
					if (tempY + mc.height >  bottomSprite.height - tempValue) {
						countY = 0;
					}
					tempY = startY + countY * 26;
					countY ++;
				}
				
				mc.x = tempX;
				mc.y = tempY;
				mc.wborder.visible = false;
				changeSingeGoodColor(mc);
				
				boxCellArr.push(mc);
				mc.addEventListener(MouseEvent.MOUSE_DOWN, singleDown, true);
				adjustGoodsPosition(mc);
			}
			
			numViewUp();
			updateNum();
		}
		
		private function singleDown(e:MouseEvent):void {
			///trace("单个物体按下");
			e.stopImmediatePropagation();
			///e.stopPropagation();
			var mc:MovieClip = e.currentTarget as MovieClip;
			App.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			///changeOperation();
			tempSelectArr.push(mc);
			changeColor(tempSelectArr);
			_isDrawArea = false;///当第一选中单个物体时，鼠标抬起会出问题，这里假设第一次选中单个物体时在绘制选择区域
			
			if (tempSelectContainer) {
				tempSelectContainerDrag = true;
				tempSelectContainer.startDrag();
				///_isDrawArea = false;
			}
		}
		
		/**
		 * 清除当前选择的所有物体
		 */
		public function deleteAllSelectBoxs():void {
			if (tempSelectArr.length != 0 && tempSelectContainer) {
				///从总集合里面删除，清除的物体
				for (var i:int = 0; i < tempSelectArr.length; i++) {
					var mc:MovieClip = tempSelectArr[i] as MovieClip;
					var index:int = boxCellArr.indexOf(mc);
					if (index != -1) {
						boxCellArr.splice(index, 1);
					}
				}
				
				tempSelectContainerDrag = false;
				tempSelectContainer.parent.removeChild(tempSelectContainer);
				restorColor(tempSelectArr,srcBorderColor);
				tempSelectContainer = null;
				tempSelectArr = [];
			}
			
			updateNum();
		}
		/**
		 * 获取临时选择容器的全局坐标
		 * @return
		 */
		public function tempSelectContainerGlobalPosition():Point {
			if (tempSelectContainer) {
				var globalPoint:Point = localToGlobal(new Point(tempSelectContainer.x, tempSelectContainer.y));
				return globalPoint;
			}
			return null;
		}
		
		/**
		 * 移除 集合中的物体
		 * @param	arr  要移除的物体的集合
		 */
		public function deleteSomeBoxs(arr:Array):void {
			if (!tempSelectContainer) {
				///trace("选择容器不存在！");
				return;
			}
			for (var i:int = 0; i < arr.length; i++) {
				var mc:MovieClip = arr[i] as MovieClip;
				if (tempSelectContainer.contains(mc)) {
					tempSelectContainer.removeChild(mc);
				}
				var index:int = boxCellArr.indexOf(mc);
				if (index != -1) {
					boxCellArr.splice(index, 1);
				}
			}
			
			updateNum();
		}
		
		/**
		 * 如果物体超出范围，物体坐标重设定
		 */
		private function  resetPosition():void {
			
		}
		
		/**
		 * 组合选择物体的集合
		 */
		public function get tempSelectArr():Array {
			return _tempSelectArr;
		}
		/**
		 * 组合选择物体的集合
		 */
		public function set tempSelectArr(value:Array):void {
			_tempSelectArr = value;
		}
		
		/**
		 * 当前选择物体的元坐标
		 */
		public function set selectSrcPosition(value:Point):void {
			_selectSrcPosition = value;
		}
		/**
		 * 当前选择物体的元坐标
		 */
		public function get selectSrcPosition():Point {
			return _selectSrcPosition;
		}
		
		/**
		 * 获取临时选择组容器
		 */
		public function get selectContainer():Sprite {
			if (tempSelectContainer) {
				return tempSelectContainer
			}
			
			return null;
		}
		/**
		 * 临时组合容器恢复原位置
		 */
		public function restorePosition():void {
			//trace("临时组合容器恢复原位置：",selectSrcPosition);
			if (tempSelectContainer) {
				tempSelectContainer.x = selectSrcPosition.x;
				tempSelectContainer.y = selectSrcPosition.y;
			}
		}
		/**
		 * 更新坐标
		 */
		public function updatePosition():void {
			if (tempSelectContainer) {
				selectSrcPosition.x = tempSelectContainer.x;
				selectSrcPosition.y = tempSelectContainer.y;
			}
		}
		
		/**
		 * 鼠标位置与当前底部是否碰撞
		 * @param	point
		 * @return
		 */
		public function inRange(point:Point):Boolean {
			if (bottomSprite.hitTestPoint(point.x, point.y)) {
				return true;
			}
			return false;
		}
		/**
		 * 调整坐标
		 */
		public function adjustPosition():void {
			if (tempSelectContainer) {
				adjustGoodsPosition(tempSelectContainer);
				updatePosition();
			}
		}
		
		public function  get isDrawArea():Boolean {
			return _isDrawArea;
		}
		/**
		 * 调整物体的坐标，如果物体超出当前的box区域，重新设置坐标
		 * @param	goods
		 */
		public function adjustGoodsPosition(goods:Sprite):void {
			if (!goods) return;
			var tempValue:Number = 2.5;///修正值
			//trace("tempSelectContainer:", tempSelectContainer.x, tempSelectContainer.y,tempSelectContainer.width,tempSelectContainer.height);
			var totalW:Number = goods.x +goods.width;
			var totalH:Number = goods.y + goods.height;
			if (goods.x < bottomSprite.x && goods.y < bottomSprite.y) {
				goods.x = bottomSprite.x+tempValue;
				goods.y = bottomSprite.y+tempValue;
			}else  if (totalW>bottomSprite.width && totalH>bottomSprite.height) {
				goods.x = bottomSprite.width - goods.width-tempValue*2;
				goods.y = bottomSprite.height - goods.height-tempValue*2;
			}else if (goods.x < bottomSprite.x && goods.y >bottomSprite.y && totalW< bottomSprite.width && totalH< bottomSprite.height) {
				goods.x = bottomSprite.x+tempValue;
			}else if(goods.x > bottomSprite.x && goods.y <bottomSprite.y && totalW< bottomSprite.width && totalH< bottomSprite.height) {
				goods.y = bottomSprite.y+tempValue;
			}else if (goods.x > bottomSprite.x && goods.y > bottomSprite.y && totalW > bottomSprite.width && totalH < bottomSprite.height) {
				goods.x = bottomSprite.width - goods.width-tempValue*2;
			}else if (goods.x > bottomSprite.x && goods.y > bottomSprite.y && totalW < bottomSprite.width && totalH > bottomSprite.height) {
				goods.y = bottomSprite.height - goods.height-tempValue*2;
			}else if (goods.x < bottomSprite.x && totalH > bottomSprite.height) {
				goods.x = bottomSprite.x + tempValue;
				goods.y = bottomSprite.height - goods.height - tempValue * 2;
			}else if (goods.y < bottomSprite.y && bottomSprite.width < totalW) {
				goods.y = bottomSprite.y + tempValue;
				goods.x = bottomSprite.width - goods.width -tempValue* 2;
			}
		}
		/**
		 * 改变物体的颜色
		 * @param	borderColor  边框颜色
		 * @param	contentColor 内容颜色
		 */
		public function changeGoodsColor(borderColor:uint, contentColor:uint):void {
			srcBorderColor = borderColor;
			srcContentColor = contentColor;
			
			for (var i:int = 0; i < boxCellArr.length; i++) {
				var mc:MovieClip = boxCellArr[i] as  MovieClip;
				changeSingeGoodColor(mc);
			}
		}
		/**
		 * 改变单个物体的颜色
		 */
		private function changeSingeGoodColor(mc:MovieClip):void {
			var borColor:ColorTransform = new ColorTransform();
			var conColor:ColorTransform = new ColorTransform();
			
			borColor.color = srcBorderColor;
			conColor.color = srcContentColor;
			
			mc.nborder.transform.colorTransform = borColor;
			mc.content.transform.colorTransform = conColor;
			
			//if (type == TYPE_HUNDREDS || type == TYPE_TENS) {
				//mc.border.transform.colorTransform = borColor;
				//for (var j:int = 0; j < mc.numChildren - 1; j++) {
					//var mm:MovieClip = mc.getChildAt(j) as MovieClip;
					//mm.border.transform.colorTransform = borColor;
					//mm.content.transform.colorTransform = conColor;
				//}
			//}else if (type == TYPE_ONES) {
				//
			//}
		}
		/**
		 * 设定默认的颜色
		 * @param	border
		 * @param	content
		 */
		public function setDefaultColor(border:uint, content:uint):void {
			srcBorderColor = border;
			srcContentColor = content;
			changeGoodsColor(srcBorderColor, srcContentColor);
		}
		/**
		 * 显示数字
		 * @param	boo
		 */
		public function numViewVisible(boo:Boolean):void {
			_numView.visible = boo;
			if (_numView.visible) {
				_numView.up();
			}
		}
		/**
		 * 数字置顶
		 */
		public function numViewUp():void {
			if (_numView.visible) {
				_numView.up();
			}
		}
		/**更新数字
		 * */
		public function updateNum():void {
			_numView.setNum(boxCellArr.length);
		}
		/**
		 * 当前物体个数是否小于10
		 * @return
		 */
		public function downTen():Boolean {
			return boxCellArr.length < 10;
		}
		
		/**
		 * 重新排序
		 */
		public function sort():void {
			var startX:Number = 3;
			var startY:Number = 3;
			var space:Number = 25;
			var tempX:Number = 3;
			var tempY:Number = 3;
			var countX:Number = 0;
			var countY:Number = 0;
			var i:int = 0;
			var len:uint = boxCellArr.length;
			var tempValue:Number = 30;
			var mc:MovieClip;
			for (i = 0; i < len; i++) {
				mc = boxCellArr[i];
				if (tempX + mc.width > bottomSprite.width-tempValue ) {
					countY++;
					if (tempY +mc.height > bottomSprite.height-tempValue) {
						countY = 0;
					}
					countX = 0;
				}
				tempX = startX + countX * space;
				tempY = startY + countY * space;
				countX++;
				
				mc.x = tempX;
				mc.y = tempY;
				
				adjustGoodsPosition(mc);
			}
		}
		
		/**
		 * 清除所有
		 */
		public function clearAll():void {
			for (var i:int = 0; i < boxCellArr.length; i++) {
				var mc:MovieClip = boxCellArr[i] as MovieClip;
				mc.parent.removeChild(mc);
			}
			boxCellArr = [];
			if (tempSelectContainer) {
				tempSelectContainer.parent.removeChild(tempSelectContainer);
				tempSelectContainerDrag = false;
				tempSelectContainer = null;
				tempSelectArr = [];
				isDownArea = false;
				_isDrawArea = false;
				
			}
		}
	}

}