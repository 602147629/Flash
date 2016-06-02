package src.self 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import src.Global;
	
	/**需要操作的盒子
	 * ...
	 * @author Mu
	 */
	public class OperationBox extends Sprite 
	{
		private var boxArr:Array = [];//集合
		public var boderContainer:Sprite//边框容器
		public var type:Number = 0;//类型
		private var _mcCollsion:Array = [];//存贮占用的外部格子集合
		
		//上下左右四个点
		public var luDot:DragDot;
		public var ruDot:DragDot;
		public var ldDot:DragDot;
		public var rdDot:DragDot;
		
		//真是宽高
		private var _reallyW:Number=0;
		private var _reallyH:Number = 0;
		
		private var _rows:Number=1;
		private var _colums:Number=1;
		private var _boxSize:Number = 35;
		
		//是否按下拖拽
		private var _isDrag:Boolean;
		private var currentDragDot:DragDot;
		
		private var _self_position:Point = new Point();
		
		private var _rec:Rectangle;
		
		private var _container:Sprite;
		
		private var _isDraw:Boolean;//是否绘制过
		private var _idDrawing:Boolean;//正在绘制
		private var _selfDrag:Boolean;//自身拖拽
		private var _fillAll:Boolean;//填充所有
		private var _isWrap:Boolean;//是否包装
		
		public var fillProgressFuns:Function;//填充过程
		public var fillCompleteFuns:Function;//填充完成
		
		private var _contentTxt:String;//显示字符串
		private var _isShowNubers:Boolean;//是否显示数字
		
		private var  wrap:WrapSkin;//包装纸
		private var  colT:TextField;
		private var  rowT:TextField;
		
		private var hitRectSprite:Sprite=new Sprite();//碰撞矩形
		public function OperationBox()
		{
			var box:ModelCellBox = new ModelCellBox();
			addChild(box);	
			
			boxArr.push(box);
			
			boderContainer = new Sprite();
			addChild(boderContainer);
			
			this.buttonMode = true;
			
			colT = new TextField();
			colT.selectable = false;
			colT.autoSize = "left";
			addChild(colT);
			rowT = new TextField();
			rowT.selectable = false;
			rowT.autoSize = "left";
			addChild(rowT);
			
			setTColor(0x000000);
			
			wrap = new WrapSkin();
			addChild(wrap);
			wrap.visible = false;
			//this.alpha = 0.3;
			wrap.updates(0, 0);
			this.setChildIndex(wrap, this.numChildren - 1);
		}
		//更新
		public function updates(position:Point, rows:Number, cols:Number):void {
			self_position = position;
			_rows = cols+1;
			_colums = rows + 1;
			if (selfDrag) return;
			clears();
			var i:uint = 0;
			var j:uint = 0;
			var box:ModelCellBox;
			for (i = 0; i <= cols; i++) {
				for (j = 0; j <= rows; j++) {
					box = new ModelCellBox();
					_boxSize = box.width;
					box.y = i * box.width;
					box.x = j * box.height;
					addChild(box);
					boxArr.push(box);
				}
			}
			
			wrap.updates(rows, cols);
			this.setChildIndex(wrap, this.numChildren - 1);
		}
		
		public function setTColor(color:uint):void {
			var format:TextFormat = new TextFormat();
			format.size = 26;
			format.font = "Arial";
			format.bold = true;
			format.color = color;
			colT.defaultTextFormat = format;
			rowT.defaultTextFormat = format;
			
			colT.filters = [new GlowFilter(0xffffff,1,2,2,20,1,false,false)];
			rowT.filters = [new GlowFilter(0xffffff,1,2,2,20,1,false,false)];
		}
		
		/**
		 * 显示包装纸
		 * @param	boo
		 * @param	nboo 显示数字
		 */	
		public function wrapd(boo:Boolean, nboo:Boolean):void {
			isWrap = boo;
			if (boo && fillAll) {
				wrap.visible = true;
				wrap._txt.visible = nboo;
				this.setChildIndex(wrap, this.numChildren - 1);
			}else {
				wrap.visible = false;
			}
		}
		
		//居中
		private function centers():void {
			colT.x = (reallyW - colT.width) / 2;
			rowT.y = (reallyH - colT.height) / 2;
		}
		
		/**
		 * 显示数字
		 * @param	boo
		 */
		public function showNubers(boo:Boolean):void {
			colT.visible = boo;
			rowT.visible = boo;
		}
		
		public function dragUpdate(position:Point):void {
			self_position = position;
		}
		
		/**
		 * 绘制边框
		 */
		public function drawBorders():void {
			updateBorder();
		}
		
		private function updateBorder():void {
			//四个点
			if (!luDot) {
				luDot = new DragDot();
				addChild(luDot);
				luDot.addEventListener(MouseEvent.MOUSE_DOWN, dotDownHand);
			}
			if (!ruDot) {
				ruDot = new DragDot();
				addChild(ruDot);
				ruDot.addEventListener(MouseEvent.MOUSE_DOWN, dotDownHand);
			}
			if (!ldDot) {
				ldDot = new DragDot();
				addChild(ldDot);
				ldDot.addEventListener(MouseEvent.MOUSE_DOWN, dotDownHand);
			}
			if (!rdDot) {
				rdDot = new DragDot();
				addChild(rdDot);
				rdDot.addEventListener(MouseEvent.MOUSE_DOWN, dotDownHand);
			}
			
			reallyW = _colums * _boxSize;
			reallyH = _rows * _boxSize;
			////显示数字
			colT.text = _colums.toString();
			rowT.text =  _rows.toString();
			this.setChildIndex(colT, this.numChildren - 1);
			this.setChildIndex(rowT, this.numChildren - 1);
			this.setChildIndex(wrap, this.numChildren - 1);
			
			if (colT.text == "0" && rowT.text == "0") {
				rowT.text = "";
				colT.x = (reallyW - colT.width) / 2;
				colT.y = (reallyH - colT.height) / 2;
				return;
			}else if (colT.text == "0") {
				colT.text = "";
			}else if (rowT.text == "0") {
				rowT.text = "";
			}else if (colT.text == "1" && rowT.text == "1") {
				rowT.text = "";
				colT.text = "1";
				colT.x = (reallyW - colT.width) / 2;
				colT.y = (reallyH - colT.height) / 2;
			}
			centers();
			/////////
			
			luDot.x = 0; luDot.y = 0;
			ruDot.x = reallyW; ruDot.y = 0;
			ldDot.x = 0; ldDot.y = reallyH;
			rdDot.x = reallyW, rdDot.y =reallyH;
			
			boderContainer.graphics.clear();
			this.setChildIndex(boderContainer, this.numChildren - 1);
			this.setChildIndex(luDot, this.numChildren - 1);
			this.setChildIndex(ruDot, this.numChildren - 1);
			this.setChildIndex(ldDot, this.numChildren - 1);
			this.setChildIndex(rdDot, this.numChildren - 1);
			
			drawDashed(boderContainer, new Point(luDot.x, luDot.y), new Point(ruDot.x, ruDot.y));
			drawDashed(boderContainer, new Point(ruDot.x, ruDot.y), new Point(rdDot.x, rdDot.y));
			drawDashed(boderContainer, new Point(rdDot.x, rdDot.y), new Point(ldDot.x, ldDot.y));
			drawDashed(boderContainer, new Point(ldDot.x, ldDot.y), new Point(luDot.x, luDot.y));
			
			hitRectSprite.graphics.clear();
			hitRectSprite.x = hitRectSprite.y = 5;
			hitRectSprite.graphics.beginFill(0xff0000,0);
			hitRectSprite.graphics.drawRect(0, 0, rdDot.x-10, rdDot.y-10);
			addChild(hitRectSprite);
			
			//rec =  boderContainer.getRect(container);
			rec =  hitRectSprite.getRect(container);
		}
		
		public function updateDragPosition(cup:Point, lup:Point, rup:Point,ldp:Point,rdp:Point):void {
			var minp:Point;
			var maxp:Point;
			if (currentDragDot == luDot) {
				minp = lup;
				maxp = new Point(rdDot.x - _boxSize, rdDot.y - _boxSize);
			}else if (currentDragDot == ruDot) {
				minp = new Point(ldDot.x + _boxSize, ldDot.y - _boxSize);
				maxp = rup;
			}else if (currentDragDot == ldDot) {
				minp = ldp;
				maxp = new Point(ruDot.x -_boxSize, ruDot.y +_boxSize);
			}else if (currentDragDot == rdDot) {
				minp = new Point(luDot.x +_boxSize, luDot.y + _boxSize);
				maxp = rdp;
			}
			
			var xx:Number = cup.x;
			var yy:Number = cup.y;
			var maxxx:Number = Math.max(minp.x, maxp.x);
			var minxx:Number = Math.min(minp.x, maxp.x);
			var maxyy:Number = Math.max(minp.y, maxp.y);
			var minyy:Number = Math.min(maxp.y, minp.y);
			if (xx <= maxxx && xx>=minxx) {
				currentDragDot.x = xx;
			}
			if (yy <= maxyy && yy >= minyy) {
				currentDragDot.y = yy;
			}
			
			if (currentDragDot == luDot) {
				ruDot.y = currentDragDot.y;
				ldDot.x = currentDragDot.x;
			}else if (currentDragDot == ruDot) {
				luDot.y = currentDragDot.y;
				rdDot.x = currentDragDot.x;
			}else if (currentDragDot == ldDot) {
				luDot.x = currentDragDot.x;
				rdDot.y = currentDragDot.y;
			}else if (currentDragDot == rdDot) {
				ldDot.y = currentDragDot.y;
				ruDot.x = currentDragDot.x;
			}
			
			boderContainer.graphics.clear();
			this.setChildIndex(boderContainer, this.numChildren - 1);
			this.setChildIndex(luDot, this.numChildren - 1);
			this.setChildIndex(ruDot, this.numChildren - 1);
			this.setChildIndex(ldDot, this.numChildren - 1);
			this.setChildIndex(rdDot, this.numChildren - 1);
			
			drawDashed(boderContainer, new Point(luDot.x, luDot.y), new Point(ruDot.x, ruDot.y));
			drawDashed(boderContainer, new Point(ruDot.x, ruDot.y), new Point(rdDot.x, rdDot.y));
			drawDashed(boderContainer, new Point(rdDot.x, rdDot.y), new Point(ldDot.x, ldDot.y));
			drawDashed(boderContainer, new Point(ldDot.x, ldDot.y), new Point(luDot.x, luDot.y));
		}
		
		private function dotDownHand(e:MouseEvent):void {
			isDrag = true;
			currentDragDot = e.currentTarget as DragDot;
		}
		
		//清除
		private function clears():void {
			var i:uint = 0;
			var len:uint = boxArr.length;
			var box:MovieClip;
			for (i = 0; i < len; i++) {
				box = boxArr[i] as MovieClip;
				box.parent.removeChild(box);
			}
			
			boxArr = [];
		}
		
		/**
		 * 绘制颜色
		 * @param	model  模式
		 * @param	auto   自动浇注
		 * @param	totalNumber  总数
		 */
		public function drawColor(model:String, auto:Boolean = false, totalNumber:Number = 0):void {
			
			var index:Number;
			if (model == "BLACK") {
				index = 1;
			}else if (model == "MILL") {
				index = 2;
			}else if (model == "WHILTE") {
				index = 3;
			}
			
			if (fillAll) {
				return;
			}
			if (isDraw) {
				cancelDraw();
				isDraw = false;
				return;
			}
			
			var num:Number = 0;
			totalNumber = Math.min(boxArr.length, totalNumber);
			var len:uint = auto?boxArr.length:totalNumber;
			var cellBox:ModelCellBox;
			var boo:Boolean = true;
			var mc:MovieClip;
			var tong:Tong = new Tong();
			addChild(tong);
			idDrawing = true;
			
			contentTxt = "浇注"+len+"块,"+"算式："+len + " = ";
			Global.contentContainer.mouseEnabled = false;
			Global.contentContainer.mouseChildren = false;
			
			addEventListener(Event.ENTER_FRAME, enterHand);
			function enterHand(e:Event):void {
				if (num >= len) {
					filled();
					removeEventListener(Event.ENTER_FRAME, enterHand);
					tong.parent.removeChild(tong);
					tong = null;
					idDrawing = false;
					isDraw = true;
					fillAll = false;
					if (auto || len == boxArr.length) {
						fillAll = true;
					}
					return;
				}
				
				if (boo) {
					boo = false;
					cellBox = boxArr[num];
					cellBox.gotoAndStop(index);
					mc= cellBox["a" + index] as MovieClip;
					mc.gotoAndPlay(2);
				}
				
				if (mc && mc.currentFrame == mc.totalFrames) {
					tong.update(new Point(cellBox.x+10, cellBox.y - 35), index);
					tong.open();
					mc.stop();
					boo = true;
					num++;
					fillIng(len,num);
					mc = null;
				}
			}
		}
		/**这个方法可以跟上面的方法，整合到一起，由于时间关系，没有整合，如果需要可以自行整合
		 * 绘制2  
		 * @param	model
		 * @param	totalNumber
		 */
		public function drawColor2(model:String, totalNumber:Number, canvas:Sprite):void {
			
			var index:Number;
			var color:uint;
			if (model == "BLACK") {
				index = 1;
				color = 0x56330A;
			}else if (model == "MILL") {
				index = 2;
				color = 0xF4E4CA;
			}else if (model == "WHILTE") {
				index = 3;
				color = 0xffffff;
			}
			
			if (fillAll) {
				return;
			}
			if (isDraw) {
				cancelDraw();
				isDraw = false;
				return;
			}
			var leftNum:Number = totalNumber - boxArr.length;
			if (leftNum <= 0) {
				drawColor(model, false, totalNumber);
				return;
			}
			//var leftNum:Number = totalNumber > boxArr.length?totalNumber - boxArr.length:totalNumber;
			var leftCount:Number = 0;
			var num:Number = 0;
			var len:uint = totalNumber;
			var cellBox:ModelCellBox;
			var boo:Boolean = true;
			var mc:MovieClip;
			var tong:Tong = new Tong();
			addChild(tong);
			idDrawing = true;
			contentTxt = "浇注"+len+"块,"+"算式："+len + " = ";
			Global.contentContainer.mouseEnabled = false;
			Global.contentContainer.mouseChildren = false;
			addEventListener(Event.ENTER_FRAME, enterHand);
			function enterHand(e:Event):void {
				if (leftNum == 0) {
					if (num >= len) {
						filled();
						removeEventListener(Event.ENTER_FRAME, enterHand);
						tong.parent.removeChild(tong);
						tong = null;
						idDrawing = false;
						isDraw = true;
						fillAll = false;
						if (len == boxArr.length) {
							fillAll = true;
						}
						return;
					}
				}else if (leftCount >= leftNum) {
					contentTxt += leftNum.toString();
					if (fillProgressFuns != null) {
						fillProgressFuns(contentTxt);
					}
					filled();
					removeEventListener(Event.ENTER_FRAME, enterHand);
					tong.parent.removeChild(tong);
					tong = null;
					idDrawing = false;
					isDraw = true;
					fillAll = true;
					return;
				}
				
				if (num< boxArr.length && boo) {
					boo = false;
					cellBox = boxArr[num];
					cellBox.gotoAndStop(index);
					mc = cellBox["a" + index] as MovieClip;
					mc.gotoAndPlay(2);
				}
				
				if (mc && mc.currentFrame == mc.totalFrames) {
					tong.update(new Point(cellBox.x+10, cellBox.y - 35), index);
					tong.open();
					mc.stop();
					boo = true;
					num++;
					fillIng(len,num);
					mc = null;
				}
				
				if (leftNum !=0 && num >= boxArr.length) {
					leftCount ++;
					tong.update(new Point(0,reallyH-10),index);
					draw(canvas, leftCount*8,color);
				}
			}
		}
		
		private function draw(canvas:Sprite, radius:Number,color:uint):void {
			canvas.x = this.x+10;
			canvas.y = this.y +this.height;
			var g:Graphics = canvas.graphics;
			g.clear();
			g.beginFill(color);
			g.drawCircle(0, 0, radius);
			g.endFill();
		}
		
		//填充过程
		private function fillIng(total:Number,num:Number):void {	
			var n1:Number = num%_colums;
			var n2:int = int( total / _colums);
			var n3:int = int( num / _colums);
			
			if (n1 == 0) {
				if (num == total) {
					contentTxt += _colums
				}else {
					contentTxt += _colums+" + ";
				}
			}else if (num == total) {
				contentTxt += (total - n2*_colums);
			}
			
			if (fillProgressFuns != null) {
				fillProgressFuns(contentTxt);
			}
		}
		//填充完成
		private function filled():void {
			Global.contentContainer.mouseEnabled = true;
			Global.contentContainer.mouseChildren = true;
			if (fillCompleteFuns != null) {
				fillCompleteFuns();
			}
		}
		
		/**
		 * 取消绘制
		 */
		public function cancelDraw():void {
			for (var i:int = 0; i < boxArr.length; i++) {
				var cellBox:ModelCellBox = boxArr[i];
				cellBox.gotoAndStop(1);
				var mc:MovieClip= cellBox["a" + 1] as MovieClip;
				mc.gotoAndStop(1);
			}
			isDraw = false;
		}
		/**
		 * 重置底部格子的type -1
		 */
		public function resetBoxType():void {
			for (var i:int = 0; i < mcCollsion.length; i++) {
				var box:cellBox = mcCollsion[i];
				box.type = -1;
			}
		}
		
		/**
		 * 设置拖拽点的显隐
		 * @param	boo
		 */
		public function dragDotVisible(boo:Boolean):void {
			luDot.visible = boo;
			ruDot.visible = boo;
			ldDot.visible = boo;
			rdDot.visible = boo;
			boderContainer.visible = boo;
		}
		
		//外部盒子集合
		public function get mcCollsion():Array 
		{
			return _mcCollsion;
		}
		public function set mcCollsion(value:Array):void 
		{
			_mcCollsion = value;
		}
		
		public function get reallyW():Number 
		{
			return _reallyW;
		}
		
		public function set reallyW(value:Number):void 
		{
			_reallyW = value;
		}
		
		public function get reallyH():Number 
		{
			return _reallyH;
		}
		
		public function set reallyH(value:Number):void 
		{
			_reallyH = value;
		}
		
		public function get isDrag():Boolean 
		{
			return _isDrag;
		}
		
		public function set isDrag(value:Boolean):void 
		{
			_isDrag = value;
		}
		
		public function get self_position():Point 
		{
			return _self_position;
		}
		
		public function set self_position(value:Point):void 
		{
			_self_position = value;
			this.x =  value.x;
			this.y = value.y;
		}
		
		public function get rec():Rectangle 
		{
			return _rec;
		}
		
		public function set rec(value:Rectangle):void 
		{
			_rec = value;
		}
		
		public function get container():Sprite 
		{
			return _container;
		}
		
		public function set container(value:Sprite):void 
		{
			_container = value;
		}
		
		public function get isDraw():Boolean 
		{
			return _isDraw;
		}
		
		public function set isDraw(value:Boolean):void 
		{
			_isDraw = value;
		}
		
		public function get idDrawing():Boolean 
		{
			return _idDrawing;
		}
		
		public function set idDrawing(value:Boolean):void 
		{
			_idDrawing = value;
		}
		
		public function get selfDrag():Boolean 
		{
			return _selfDrag;
		}
		
		public function set selfDrag(value:Boolean):void 
		{
			_selfDrag = value;
		}
		
		public function get fillAll():Boolean 
		{
			return _fillAll;
		}
		
		public function set fillAll(value:Boolean):void 
		{
			_fillAll = value;
		}
		
		public function get isWrap():Boolean 
		{
			return _isWrap;
		}
		
		public function set isWrap(value:Boolean):void 
		{
			_isWrap = value;
		}
		
		public function get contentTxt():String 
		{
			return _contentTxt;
		}
		
		public function set contentTxt(value:String):void 
		{
			_contentTxt = value;
		}
		
		public function get isShowNubers():Boolean 
		{
			return _isShowNubers;
		}
		
		public function set isShowNubers(value:Boolean):void 
		{
			_isShowNubers = value;
			showNubers(value);
		}
		
		//选择状态
		public function selected(boo:Boolean):void {
			if (boo) {
				this.filters = [new GlowFilter(0x000000)];
				this.alpha = 1;
			}else {
				this.filters = [];
				this.alpha = 0.9;
			}
		}
		
		/*虚线绘制
		 *@mc 绘制容器
		 *@beginPoint 起始点
		 *@thickness  线条粗细
		 *@color  线条颜色
		 *@alphas  线条透明度
		 *@w  小线段的宽度
		 *@grap 间隙
		 */
		private function drawDashed(container:Sprite,beginPoint: Point,endPoint:Point, thickness: Number = 2, color: uint = 0x00ff33, alphas: Number = 0.6, w: Number = 5, grap: Number = 5): void {
			var g: Graphics = container.graphics;
			//g.clear();
			g.lineStyle(thickness, color, alphas);
			var Ox: Number = beginPoint.x;
			var Oy: Number = beginPoint.y;
			
			var radian: Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen: Number = Point.distance(beginPoint, endPoint);
			var currLen: Number = 0;
			var xx: Number, yy: Number;
			while (currLen <= totalLen) {
				xx = Ox + Math.cos(radian) * currLen;
				yy = Oy + Math.sin(radian) * currLen;
				g.moveTo(xx, yy);
				currLen += w;
				if (currLen > totalLen) currLen = totalLen;
				xx = Ox + Math.cos(radian) * currLen;
				yy = Oy + Math.sin(radian) * currLen;
				g.lineTo(xx, yy);
				currLen += grap;
			}
		}

	}
}