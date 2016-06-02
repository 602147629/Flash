package src.self 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import src.compoment.CheckBox;
	import src.compoment.ComboBox;
	import src.compoment.NumericStepper;
	import src.compoment.RadioButton;
	import src.Global;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class MainView extends MovieClip 
	{
		//一些组件
		private var showSumBox:CheckBox;//显示分数和
		private var creatCardBox:CheckBox;//文字标签
		private var upNumNumeric:NumericStepper;//数字选择器
		private var downNumNumeric:NumericStepper;//数字选择器
		
		private var listViewBox:ListBoxView;
		
		//private var colorValue:Array = [0xffadad, 0xffc64d, 0xffff99, 0xccff66, 0x00ffff, 0xcc99ff];
		private var colorValue:Array = [0xFFC901, 0x99D9EA, 0xB5E61D, 0xC8BFE7, 0xC3C3CE, 0xFFAEC9];
		private var colorMc:Array = [];//颜色对应的影片
		private var _selecterColor:uint;//当前选择的颜色
		private var _cardArr:Array = [];//卡片集合
		private var currentCard:CardView;//当前选择的卡片
		private var stageDown:Boolean;//在舞台上按下
		private var _showFlags:Boolean;//是否显示标签
		private var _showNums:Boolean;//是否显示数
		
		private var topNumArr:Array = [];//顶部集合
		private var bottomNumArr:Array = [];//底部集合
		private var _upHitMc:MovieClip;
		private var _downHitMc:MovieClip;
		private var upLineContainer:Sprite;
		private var downLineContainer:Sprite;
		private var upNumBox:NumberBox;
		private var downNumBox:NumberBox;
		public function MainView() 
		{
			initView();
			initEvent();
		}
		//初始化界面
		private function initView():void {
			_upHitMc = upHitMc;
			_downHitMc = downHitMc;
			
			upLineContainer = new Sprite();
			upLineContainer.visible = false;
			addChild(upLineContainer);
			downLineContainer = new Sprite();
			downLineContainer.visible = false;
			addChild(downLineContainer);
			
			
			upNumBox = new NumberBox();
			upNumBox.visible = false;
			addChild(upNumBox);
			downNumBox = new NumberBox();
			downNumBox.visible = false;
			addChild(downNumBox);
			
			showSumBox = new CheckBox("显示分数和",showSumBoxHand);
			showSumBox.x = 60;
			showSumBox.y = 440;
			addChild(showSumBox);
			
			creatCardBox = new CheckBox("文字标签",showCardBoxHand);
			creatCardBox.x = 293;
			creatCardBox.y = 635;
			addChild(creatCardBox);
			
			listViewBox = listView;
			listViewBox.externalSynFun = listViewBoxChange;
			listViewBox.colors = 0x994885;
			
			upNumNumeric = new NumericStepper(1, 1, 12,upNumberChange);
			upNumNumeric.x = 75;
			upNumNumeric.y = 498;
			upNumNumeric.scaleX = upNumNumeric.scaleY = 0.9;
			addChild(upNumNumeric);
			upNumNumeric.BtnEnabled("down", false);
			
			downNumNumeric = new NumericStepper(5, 1, 12,downNumberChange);
			downNumNumeric.x = 75;
			downNumNumeric.y = 548;
			downNumNumeric.scaleX = downNumNumeric.scaleY = 0.9;
			addChild(downNumNumeric);
			
			colorMc.push(color1, color2, color3, color4, color5, color6);
			colorMcHand();
			
			emc.visible = false;
			
			initCard();
		}
		//显示标签
		private function showCardBoxHand(select:Boolean):void 
		{
			showFlags = select;
		}
		//显示分数和
		private function showSumBoxHand(select:Boolean):void 
		{
			showNums = select;
			updateShow();
		}
		
		private function initEvent():void 
		{
			clearBtn.addEventListener(MouseEvent.CLICK, clearHand);
			createCardBtn.addEventListener(MouseEvent.CLICK, createCardHand);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHand);
		}
		//初始化卡片
		private function initCard():void {
			cardCreate(colorValue[1], listViewBox.width / 6, listViewBox.width / 6 * 1, 1, 6);
			cardCreate(colorValue[2], listViewBox.width / 6, listViewBox.width / 6 * 1, 1, 6);
			
			cardCreate(colorValue[3], listViewBox.width / 4, listViewBox.width / 4 * 1, 1, 4);
			cardCreate(colorValue[4], listViewBox.width / 4, listViewBox.width / 4 * 1, 1, 4);
			
			cardCreate(colorValue[0], listViewBox.width / 2, listViewBox.width / 2 * 1, 1, 2);
			//cardCreate(colorValue[3], listViewBox.width / 2, listViewBox.width / 2 * 1, 1, 2);
			
			cardCreate(colorValue[2], listViewBox.width / 3, listViewBox.width / 3 * 1, 1, 3);
			cardCreate(colorValue[4], listViewBox.width / 3, listViewBox.width / 3 * 1, 1, 3);
		}
		
		//创建卡片
		private function createCardHand(e:MouseEvent=null):void 
		{
			SoundManager.instance.playSound(SoundList.SOUND_BTN_DEFAULT);
			cardCreate(selecterColor,listViewBox.width/listViewBox.totalNum,listViewBox.width/listViewBox.totalNum*listViewBox.selectedNum,listViewBox.selectedNum,listViewBox.totalNum,showFlags);
		}
		/**
		 * 卡片创建
		 * @param	color
		 * @param	size
		 * @param	total
		 * @param	fz
		 * @param	fm
		 * @param	showFlag
		 */
		private function cardCreate(color:uint,size:Number,total:Number,fz:Number,fm:Number,showFlag:Boolean=false):void {
			var card:CardView = new CardView(color,size,total,fz,fm,showFlag);
			card.x = 260;
			card.y = 490;
			card.animate(cans);
			card.addEventListener(MouseEvent.MOUSE_DOWN, cardDown);
			addChild(card);
			
			cardArr.push(card);
		}
		
		//删除卡片
		private function deleteCard():void {
			SoundManager.instance.playSound(SoundList.SOUND_DELETE);
			if (!currentCard) return;
			if (currentCard.hitTestObject(deleteMc)) {
				var index:int = cardArr.indexOf(currentCard);
				cardArr.splice(index, 1);
				currentCard.parent.removeChild(currentCard);
				currentCard = null;
				deleteMc.gotoAndStop(1);
			}
		}
		
		//舞台按下事件
		private function stageUpHand(e:MouseEvent):void {
			if (stageDown && currentCard) {
				var index:int;
				var index2:int;
				if (currentCard.hitTestObject(deleteMc)) {
					deleteCard();
					return;
				}
				if (currentCard.hitTestObject(_downHitMc) && checkCanHit(currentCard, bottomNumArr, _downHitMc)) {//碰撞到下面的mc
					
					bottomNumArr.push(currentCard);
					var hitmc:CardView = getHitMc(currentCard, bottomNumArr);
					if (hitmc) {
						index= bottomNumArr.indexOf(hitmc);
						index2= bottomNumArr.indexOf(currentCard);
						if(index2!=-1)
							bottomNumArr.splice(index2, 1);
						bottomNumArr.splice(index, 0, currentCard);
					}
					
					sortArrMc(_downHitMc, bottomNumArr);
					updateShow();
				}else if (currentCard.hitTestObject(_upHitMc) && checkCanHit(currentCard, topNumArr, _upHitMc)){//碰撞到上面的mc
					topNumArr.push(currentCard);
					var hitmc1:CardView = getHitMc(currentCard, topNumArr);
					
					if (hitmc1) {
						index= topNumArr.indexOf(hitmc1);
						index2 = topNumArr.indexOf(currentCard);
						if(index2!=-1)
							topNumArr.splice(index2, 1);
						topNumArr.splice(index, 0, currentCard);
					}
					
					sortArrMc(_upHitMc, topNumArr);
					updateShow();
				}else {
					//currentCard.resetPosition();
					var boo:Boolean = overBorder(currentCard);
					if (boo) {
						currentCard.resetPosition();
					}else {
						currentCard.position = new Point(currentCard.x, currentCard.y);
					}
				}
				
				currentCard.stopDrag();
				//deleteCard();
				currentCard = null;
				stageDown = false;
				removeEventListener(Event.ENTER_FRAME, enterHand);
			}
		}
		//溢出边界
		private function overBorder(goods:CardView):Boolean {
			if (!goods) return false;
			//var tempValue:Number = 2.5;///修正值
			var bottomSprite:MovieClip = cans;
			if (goods.x > bottomSprite.x && goods.y > bottomSprite.y && goods.x + goods.width < bottomSprite.x + bottomSprite.width && goods.y + goods.height < bottomSprite.y + bottomSprite.height) {
				return false;
			}
			
			return true;
		}
		
		//更新
		private function updateShow():void {
			var len:Number;
			if (bottomNumArr.length != 0 && showNums) {
				downNumBox.visible = true;
				len = getLength(bottomNumArr)+_downHitMc.x;
				drawLineAndSetTxt(downLineContainer, new Point(80, 357), new Point(80, 400), new Point(len, 357), new Point(len, 400), new Point(80, 400), new Point(len, 400));
				downNumBox.x = _downHitMc.x + ( getLength(bottomNumArr) - downNumBox.width) / 2;
				downNumBox.y = 368;
			}else {
				clears("down");
			}
			
			if (topNumArr.length != 0 && showNums) {
				upNumBox.visible = true;
				len = getLength(topNumArr) + _upHitMc.x;
				drawLineAndSetTxt(upLineContainer, new Point(80, 214), new Point(80, 74), new Point(len, 214), new Point(len, 74), new Point(80, 74), new Point(len, 74));
				upNumBox.x = _upHitMc.x + ( getLength(topNumArr) - upNumBox.width) / 2;
				upNumBox.y = 43;
			}else {
				clears("up");
			}
			
			setNumbers(topNumArr,upNumBox);
			setNumbers(bottomNumArr, downNumBox, "two");
			
			if(bottomNumArr.length != 0 && topNumArr.length != 0)
				checkEquil(isEquile(), new Point(_upHitMc.x + getLength(topNumArr) + 5, 200));
			else if((bottomNumArr.length==0&&topNumArr.length!=0)||(bottomNumArr.length!=0&&topNumArr.length==0)){
				emc.visible = false;
			}
		}
		
		private function setNumbers(arr:Array,numBox:NumberBox,flag:String="one"):void {
			var card:CardView;
			var card2:CardView;
			var minNumber:Number;
			if (arr.length != 0) {
				if (arr.length <= 1) {
					card = arr[0] as CardView;
					numBox.setValue(card.fenzi, card.fenmu, flag);
				}else {
					card = arr[0] as CardView;
					card2 = arr[1] as CardView;
					minNumber = getsNumber(card.fenmu, card2.fenmu);
					var i:uint = 0;
					var ca:CardView;
					for (i = 2; i < arr.length; i++) {
						ca = arr[i];
						minNumber = getsNumber(minNumber, ca.fenmu);
					}
					
					var fz:int;
					var fm:int=minNumber;
					for (i = 0; i < arr.length; i++) {
						ca = arr[i] as CardView;
						if (ca.fenmu != minNumber) {
							fz += ca.fenzi * (minNumber / ca.fenmu);
						}else {
							fz += ca.fenzi;
						}
					}
					
					numBox.setValue(fz, fm, flag);
				}
			}
			
		}
		
		//是否相等
		private function isEquile():Boolean {
			if (upNumBox.ffz/downNumBox.ffz == upNumBox.ffm/downNumBox.ffm)
				return true;
			return false;
		}
		
		/**
		 * 求两个数的最小公倍数
		 * @param	m
		 * @param	n
		 * @return
		 */
		private function getsNumber(m:int, n:int):int {
			var remainder, m1, n1:int;
			m1 = m;
			n1 = n;
			
			while (n != 0) {
				remainder = m % n;
				m = n;
				n = remainder;
			}
			
			return m1 * n1 / m;
		}
		
		//清除
		private function clears(flag:String):void {
			if (flag == "up") {
				upLineContainer.visible = false;
				upNumBox.visible = false;
			}else {
				downLineContainer.visible = false;
				downNumBox.visible = false;
			}
		}
		
		//获取总长度
		private function getLength(arr:Array):Number {
			var totalLength:Number = 0;
			for (var i:int = 0; i < arr.length; i++) {
				var card:CardView = arr[i] as CardView;
				totalLength += card.width;
			}
			return totalLength;
		}
		//相等处理
		private function checkEquil(boo:Boolean,p:Point):void {
			emc.visible = boo;
			emc.x = p.x;
			emc.y = p.y;
		}
		
		//划线
		private function drawLineAndSetTxt(container:Sprite, sxs1:Point, sxe1:Point, sxs2:Point, sxe2:Point, xxs:Point, xxe:Point):void {
			container.visible = true;
			var g:Graphics = container.graphics;
			g.clear();
			g.lineStyle(1);
			g.moveTo(sxs1.x, sxs1.y);
			g.lineTo(sxe1.x, sxe1.y);
			g.moveTo(sxs2.x, sxs2.y);
			g.lineTo(sxe2.x, sxe2.y);
			drawDashed(container, xxs, xxe);
		}
		
		//获取碰撞的影片
		private function getHitMc(smc:CardView, arr:Array):CardView {
			for (var i:int = 0; i < arr.length; i++) {
				var card:CardView = arr[i] as CardView;
				if (smc !=  card && smc.hitTestObject(card)) {
					return card;
				}
			}
			return null;
		}
		/**
		 * 检查是否可以碰撞
		 * @param	smc  源mc
		 * @param	arr    数组
		 * @param	canMc  参照
		 */
		private function checkCanHit(smc:CardView,arr:Array,canMc:MovieClip):Boolean {
			var totalLength:Number =0;
			for (var i:int = 0; i < arr.length; i++) {
				var card:CardView = arr[i] as CardView;
				//totalLength += card.width;
				totalLength += card.fenzi / card.fenmu;
			}
			//trace(totalLength + smc.fenzi / smc.fenmu);
			if (totalLength+smc.fenzi/smc.fenmu > 3) {
				return false;
			}
			
			return true;
		}
		
		//影片按下
		private function cardDown(e:MouseEvent):void {
			var card:CardView = e.currentTarget as CardView;
			currentCard = card;
			stageDown = true;
			currentCard.startDrag();
			currentCard.parent.setChildIndex(currentCard, currentCard.parent.numChildren - 1);
			
			var index:int = bottomNumArr.indexOf(currentCard);
			//trace(index);
			if (index != -1) {
				bottomNumArr.splice(index, 1);
				sortArrMc(_downHitMc, bottomNumArr);
				updateShow();
			}
			
			index = topNumArr.indexOf(currentCard);
			//trace(index);
			if ( index != -1) {
				topNumArr.splice(index, 1);
				sortArrMc(_upHitMc, topNumArr);
				updateShow();
			}
			
			addEventListener(Event.ENTER_FRAME, enterHand);
		}
		
		private var isHD:Boolean;
		private function enterHand(e:Event):void {
			if (!currentCard) return;
			
			if (currentCard.hitTestObject(deleteMc)) {
				isHD = true;
				deleteMc.gotoAndStop(2);
			}else {
				isHD = false;
				deleteMc.gotoAndStop(1);
			}
		}
		
		private function sortArrMc(canMc:MovieClip, arr:Array):void {
			var tempx:Number = canMc.x;
			var tempy:Number = canMc.y;
			for (var i:int = 0; i < arr.length; i++) {
				var card:CardView = arr[i] as CardView;
				card.x = tempx;
				card.y = tempy;
				tempx += card.width;
			}
		}
		
		//清除
		private function clearHand(e:MouseEvent):void 
		{
			
			SoundManager.instance.playSound(SoundList.SOUND_BTN_DEFAULT);
			
			for (var i:int = 0; i < cardArr.length; i++) {
				var card:CardView = cardArr[i];
				card.parent.removeChild(card);
			}
			
			cardArr = [];
			bottomNumArr = [];
			topNumArr = [];
			clears("down");
			clears("up");
			emc.visible = false;
		}
		
		private function colorMcHand():void {
			for (var i:int = 0; i < colorMc.length; i++) {
				var mc:MovieClip = colorMc[i];
				mc.buttonMode = true;
				mc.addEventListener(MouseEvent.CLICK, colorMcClickHand);
			}
			
			colorMc[0].gotoAndStop(2);
			colorMc[0].an.play();
			selecterColor = colorValue[0];
		}
		//颜色影片
		private function colorMcClickHand(e:MouseEvent):void 
		{
			var mm:MovieClip = e.currentTarget as MovieClip;
			var index:int = colorMc.indexOf(mm);
			selecterColor = colorValue[index];
			for (var i:int = 0; i < colorMc.length; i++) {
				var mc:MovieClip = colorMc[i];
				mc.gotoAndStop(1);
			}
			
			mm.gotoAndStop(2);
			mm.an.play();
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
		protected function drawDashed(container:Sprite,beginPoint: Point,endPoint:Point, thickness: Number = 1, color: uint = 0x000000, alphas: Number = 0.6, w: Number = 5, grap: Number = 5): void {
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
		
		//数字改变处理
		private function upNumberChange(number:Number,obj:NumericStepper):void {
			if (!downNumNumeric) return;
			if (number <= 1) {
				upNumNumeric.BtnEnabled("down", false);
				upNumNumeric.BtnEnabled("up", true);
			}else if (number >= downNumNumeric.numeric) {
				upNumNumeric.BtnEnabled("up", false);
				upNumNumeric.BtnEnabled("down", true);
			}else {
				upNumNumeric.BtnEnabled("all", true);
			}
			
			listViewBox.updates(listViewBox.colors, number,downNumNumeric.numeric);
		}
		private function downNumberChange(number:Number, obj:NumericStepper):void {
				if (number <= upNumNumeric.numeric) {
					upNumNumeric.numeric = number;
				}
				
				if (upNumNumeric.numeric == 1 && number == 1) {
					upNumNumeric.BtnEnabled("all", false);
					return;
				}
				
				if (number <= 1) {
					obj.BtnEnabled("down", false);
					obj.BtnEnabled("up", true);
				}else if (number >= obj.max) {
					obj.BtnEnabled("up", false);
					obj.BtnEnabled("down", true);
				}else {
					obj.BtnEnabled("all", true);
				}
				
				if (upNumNumeric.numeric <= 1) {
					upNumNumeric.BtnEnabled("down", false);
					upNumNumeric.BtnEnabled("up", true);
				}else if (upNumNumeric.numeric >= number) {
					upNumNumeric.BtnEnabled("up", false);
					upNumNumeric.BtnEnabled("down", true);
				}else {
					upNumNumeric.BtnEnabled("all", true);
				}
				listViewBox.updates(listViewBox.colors,upNumNumeric.numeric,number);
		}
		/**
		 * 设置左侧数字
		 * @param	se
		 * @param	total
		 */
		private function listViewBoxChange(se:Number,total:Number):void {
			upNumNumeric.numeric = se;
			downNumNumeric.numeric = total;
		}
		
		public function get selecterColor():uint 
		{
			return _selecterColor;
		}
		
		public function set selecterColor(value:uint):void 
		{
			_selecterColor = value;
			listViewBox.updates(_selecterColor, upNumNumeric.numeric, downNumNumeric.numeric);
		}
		
		//卡片集合
		public function get cardArr():Array 
		{
			return _cardArr;
		}
		
		public function set cardArr(value:Array):void 
		{
			_cardArr = value;
		}
		
		public function get showFlags():Boolean 
		{
			return _showFlags;
		}
		
		public function set showFlags(value:Boolean):void 
		{
			_showFlags = value;
		}
		
		public function get showNums():Boolean 
		{
			return _showNums;
		}
		
		public function set showNums(value:Boolean):void 
		{
			_showNums = value;
		}
	}
}