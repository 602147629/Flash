package self.cell 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import game.ui.self.MainSelfPageUI;
	import morn.core.components.CheckBox;
	import morn.core.components.RadioGroup;
	import MyComponent.ui.SkinManager;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class MainView extends MainSelfPageUI 
	{
		
		private var boxDown:Boolean = false;
		private var currentBox:Box;
		private var boxArr:Array = [];///box数组
		private var createBoxDown:Boolean = false;//创建物体按下
		private var tempGoods:MovieClip;//临时创建的物体
		
		private const HUNDREDS:String = "hundreds";
		private const TENS:String = "tens";
		private const ONES:String = "ones";
		
		private var singleGoods:Boolean = false;//确定每次鼠标以上只创建一个物体
		
		private var box1:Box;
		private var box2:Box;
		private var box3:Box;
		private var box4:Box;
		private var box5:Box;
		private var box6:Box;
		
		//////顶部label文字库
		private var titleLabelArr1:Array = ["百位","十位","个位"];
		private var titleLabelArr2:Array = ["十位","个位","十分位"];
		private var titleLabelArr3:Array = ["个位","十分位","百分位"];
		private var titleLabelArr4:Array = ["十分位", "百分位", "千分位"];
		///////颜色库 [0]边线颜色 [1]内容颜色
		private var color1:Array = [0x0099cc,0x00CCFF];
		private var color2:Array = [0xff3300,0xFFAFAF];
		private var color3:Array = [0x339900,0xCFF88C];
		private var color4:Array = [0x9933CC, 0xD3A3F3];
		
		private var dotMc1:MovieClip;//小数点上面
		private var dotMc2:MovieClip;//小数点下面
		
		private var baiMc:MovieClip;
		private var shiMc:MovieClip;
		private var geMc:MovieClip;
		
		private var currentColor:Array = color1;//当前的颜色
		private var isShowNumber:Boolean = false;
		private var currentSelectIndex:Number = 0;//当前选择的索引
		private var isShowAdd:Boolean;//是否显示加数
		private var isShowSum:Boolean;//是否显示和
		
		private var formulaView:FormulaView;//公式界面
		public function MainView() 
		{
			super();
			initTopGoods();
			initBox();
			initEvent();
		}
		//初始化顶部物体
		private function initTopGoods():void {
			baiMc = SkinManager.instance.getObjectByName("hundreds") as MovieClip;
			shiMc = SkinManager.instance.getObjectByName("tens") as MovieClip;
			geMc = SkinManager.instance.getObjectByName("ones") as MovieClip;
			
			addChild(baiMc);
			addChild(shiMc);
			addChild(geMc);
			
			baiMc.x = 100;
			baiMc.y = 85;
			baiMc.type = "hundreds";
			baiMc.scaleX = baiMc.scaleY = 0.5;
			
			shiMc.x = 320;
			shiMc.y = 120;
			shiMc.type = "tens";
			shiMc.scaleX = shiMc.scaleY = 0.5;
			
			geMc.x = 570;
			geMc.y = 120;
			geMc.type = "ones";
			geMc.scaleX = geMc.scaleY = 0.5;
			
			//baiMc.addEventListener(MouseEvent.ROLL_OVER, overHand);
			//shiMc.addEventListener(MouseEvent.ROLL_OVER, overHand);
			//geMc.addEventListener(MouseEvent.ROLL_OVER, overHand);
			
			baiMc.addEventListener(MouseEvent.MOUSE_DOWN, downHand);
			shiMc.addEventListener(MouseEvent.MOUSE_DOWN, downHand);
			geMc.addEventListener(MouseEvent.MOUSE_DOWN, downHand);
			
			baiMc.wborder.visible = false;
			shiMc.wborder.visible = false;
			geMc.wborder.visible = false;
		}
		
		/**
		 * 改变顶部物体的颜色
		 */
		private function changeSingeGoodColor(mc:MovieClip, borderColor:uint,contentColor:uint ):void {
			var borColor:ColorTransform = new ColorTransform();
			var conColor:ColorTransform = new ColorTransform();
			
			borColor.color = borderColor;
			conColor.color = contentColor;
			
			
			mc.nborder.transform.colorTransform = borColor;
			mc.content.transform.colorTransform = conColor;
			
			//if (mc.type == "hundreds" || mc.type == "tens") {
				//mc.border.transform.colorTransform = borColor;
				//for (var j:int = 0; j < mc.numChildren - 1; j++) {
					//var mm:MovieClip = mc.getChildAt(j) as MovieClip;
					//mm.border.transform.colorTransform = borColor;
					//mm.content.transform.colorTransform = conColor;
				//}
			//}else if (mc.type == "ones") {
				//mc.border.transform.colorTransform = borColor;
				//mc.content.transform.colorTransform = conColor;
			//}
		}
		/**
		 * 顶部盒子按下
		 * @param	e
		 */
		private function downHand(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!singleGoods) {
				var mc:MovieClip = e.currentTarget as MovieClip;
				var tempMc:MovieClip = SkinManager.instance.getObjectByName(mc.type) as MovieClip;
				tempMc.type = mc.type;
				tempMc.x = mc.x -mc.width / 2;
				tempMc.y = mc.y -mc.height / 2;
				tempMc.wborder.visible = false;
				//tempMc.addEventListener(MouseEvent.ROLL_OUT, tempOutHand);
				//tempMc.addEventListener(MouseEvent.MOUSE_DOWN, tempDownHand);
				tempMc.addEventListener(MouseEvent.MOUSE_UP, tempUpHand);
				changeSingeGoodColor(tempMc, currentColor[0], currentColor[1]);
				createBoxDown = true;
				tempGoods = tempMc;
				addChild(tempMc);
				singleGoods = true;
				tempMc.startDrag();
			}
		}
		
		private function tempOutHand(e:MouseEvent):void {
			e.stopImmediatePropagation();
			var mc:MovieClip = e.currentTarget as MovieClip;
			if (mc && mc.parent) {
				singleGoods = false;
				mc.parent.removeChild(mc);
			}
		}
		private function tempDownHand(e:MouseEvent):void {
			e.stopImmediatePropagation();
			var mc:MovieClip = e.currentTarget as MovieClip;
			if (mc.hasEventListener(MouseEvent.ROLL_OUT)) {
				mc.removeEventListener(MouseEvent.ROLL_OUT, tempOutHand);
			}
			createBoxDown = true;
			mc.startDrag();
		}
		private function tempUpHand(e:MouseEvent):void {
			//e.stopImmediatePropagation();
			//var mc:MovieClip = e.currentTarget as MovieClip;
			//if (mc && mc.parent) {
				//singleGoods = false;
				//mc.parent.removeChild(mc);
			//}
		}
		////初始化盒子
		private function initBox():void {
			box1 = new Box(251,250);
			box1.x = 21;
			box1.y = 201;
			addChild(box1);
			box1.type = Box.TYPE_HUNDREDS;
			box2 = new Box(250,250);
			box2.type = Box.TYPE_TENS;
			box2.x = 273;
			box2.y = 201;
			addChild(box2);
			
			box3 = new Box(250,250);
			box3.type = Box.TYPE_ONES;
			box3.x = 524;
			box3.y = 201;
			addChild(box3);
			
			box4 = new Box(251,249);
			box4.x = 21;
			box4.y = 452;
			addChild(box4);
			box4.type = Box.TYPE_HUNDREDS;
			
			box5 = new Box(250,249);
			box5.type = Box.TYPE_TENS;
			box5.x = 273;
			box5.y = 452;
			addChild(box5);
			
			box6 = new Box(250,249);
			box6.type = Box.TYPE_ONES;
			box6.x = 524;
			box6.y = 452;
			addChild(box6);
			
			boxArr.push(box1,box2,box3,box4,box5,box6);
			
			for (var i:int = 0; i < boxArr.length; i++) {
				var boxMc:Box = boxArr[i] as Box;
				boxMc.addEventListener(MouseEvent.MOUSE_DOWN, boxHand,true);
			}
			
			/////小数点
			dotMc1 = SkinManager.instance.getObjectByName("dot") as MovieClip;
			dotMc2 = SkinManager.instance.getObjectByName("dot") as MovieClip;
			dotMc1.x = 8;
			dotMc1.y = 440;
			dotMc2.x = 8;
			dotMc2.y = 685;
			addChild(dotMc1);
			addChild(dotMc2);
			showDot();
			showSum.disabled = true;
			
			formulaView = new FormulaView();
			addChild(formulaView);
			formulaView.x = 800;
			formulaView.y = 450;
			
			selectHandByIndex(0);
		}
		////事件初始化
		private function initEvent():void {
			App.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			
			checkBox.addEventListener(Event.CHANGE, checkBoxChangeHand);///下拉组件事件
			numberBox.addEventListener(Event.CHANGE, numberBoxChangeHand);///复选框
			modelGroup.addEventListener(Event.CHANGE,modelChangeHand);///单选框
			showAddends.addEventListener(Event.CHANGE, showAddendHand);///显示加数模式
			showSum.addEventListener(Event.CHANGE, showSumHand);////显示和模式
			
			sortBtn.addEventListener(MouseEvent.CLICK, sortHand);///排序功能
			clearBtn.addEventListener(MouseEvent.CLICK, clearHand);///清除
		}
		
		private function checkBoxChangeHand(e:Event):void {
			selectHandByIndex(checkBox.selectedIndex);
			updateFormula();
		}
		private function numberBoxChangeHand(e:Event):void {
			var numbox:CheckBox = e.currentTarget as CheckBox;
			isShowNumber = numberBox.selected;
			showNuber();
		}
		private function modelChangeHand(e:Event):void {
			var group:RadioGroup = e.currentTarget as RadioGroup;
			if (group.selectedIndex == 0) {
				deleteGroupBox();
			}else {
				crateGroupBoxs();
			}
		}
		private function showAddendHand(e:Event):void {
			showSum.disabled = !showAddends.selected;
			isShowAdd = showAddends.selected;
			formulaView.showAdd(isShowAdd);
			if (isShowAdd && isShowSum) {
				formulaView.showSum(true);
			}else {
				formulaView.showSum(false);
			}
			
		}
		private function showSumHand(e:Event):void {
			isShowSum = showSum.selected;
			formulaView.showSum(isShowSum);
		}
		private function sortHand(e:MouseEvent):void {
			sort();
		}
		private function clearHand(e:MouseEvent):void {
			clear();
		}
		//盒子上鼠标按下事件
		private function boxHand(e:MouseEvent):void {
			var mc:Box = e.currentTarget as Box;
			this.setChildIndex(mc, this.numChildren - 1);
			if (dotMc1.visible || dotMc2.visible) {
				dotMc1.parent.setChildIndex(dotMc1, dotMc1.parent.numChildren - 1);
				dotMc2.parent.setChildIndex(dotMc2, dotMc2.parent.numChildren - 1);
			}
			boxDown = true;
			currentBox = mc;
			showDot();
		}
		/**
		 * 鼠标在舞台上抬起
		 * @param	e
		 */
		private function stageUp(e:MouseEvent):void {
			///if (currentBox) {
				///trace(currentBox.isDrawArea);
			///}
			if (currentBox && currentBox.isDrawArea == false) {
				if (currentBox.inRange(new Point(this.mouseX, this.mouseY))) {
					///trace("鼠标在范围内！");
					currentBox.adjustPosition();
				}else {
					///trace("鼠标在范围外！");
					var hitBox:Box = checkHit(currentBox,boxArr);
					if (hitBox) {
						///trace("碰撞到其他Box");
						operation(currentBox, hitBox);
					}else {
						///currentBox.restorePosition();
						currentBox.deleteAllSelectBoxs();
					}
				}
				boxDown = false;
				currentBox = null;
				showDot();
				updateFormula();
			}
			
			if (createBoxDown) {
				tempGoods.stopDrag();
				var box:Box  = checkCrateBoxHit(tempGoods, boxArr);
				if (box) {
					crateBoxs(tempGoods, box);
				}
				///trace("tempGoods:",tempGoods, tempGoods.parent);
				if (tempGoods && tempGoods.parent) {
					tempGoods.parent.removeChild(tempGoods);
					if (tempGoods.hasEventListener(MouseEvent.MOUSE_DOWN)) {
						tempGoods.removeEventListener(MouseEvent.MOUSE_DOWN, tempDownHand);
					}
					tempGoods = null;
					singleGoods = false;
				}
				
				createBoxDown = false;
				showDot();
				updateFormula();
			}
		}
		/**
		 * 排序
		 */
		private function sort():void {
			for (var i:int = 0; i < boxArr.length; i++) {
				var box:Box = boxArr[i] as Box;
				box.sort();
			}
		}
		/**
		 * 清除
		 */
		private function clear():void {
			for (var i:int = 0; i < boxArr.length; i++) {
				var box:Box = boxArr[i] as Box;
				box.clearAll();
			}
			box1.clearAll();
			box2.clearAll();
			box3.clearAll();
			box4.clearAll();
			box5.clearAll();
			box6.clearAll();
			formulaView.clear();
		}
		
		/**
		 * 更新公式
		 */
		private function updateFormula():void {
			//计算个为单位的值
			var add1:Number = countAdd(box1, box2, box3);
			var add2:Number = countAdd(box4, box5, box6);
			var sum:Number = add1 + add2;
			
			var addStr1:String = add1.toString();
			var addStr2:String = add2.toString();
			var sumStr:String = sum.toString();
			
			switch(currentSelectIndex) {
				case 0:
					addStr1 = add1 + "";
					addStr2 = add2 + "";
					sumStr = sum +"";
					break;
				case 1:
					addStr1 = operationStr(addStr1, 1);
					addStr2 = operationStr(addStr2, 1);
					sumStr = operationStr(sumStr, 1);
					break;
				case 2:
					addStr1 = operationStr(addStr1, 2);
					addStr2 = operationStr(addStr2, 2);
					sumStr = operationStr(sumStr, 2);
					break;
				case 3:
					addStr1 = operationStr(addStr1, 3);
					addStr2 = operationStr(addStr2, 3);
					sumStr = operationStr(sumStr, 3);
					break;
			}
			
			formulaView.values(addStr1,addStr2,sumStr);
		}
		/**
		 * 处理字符串
		 * */
		private function operationStr(str:String, index:Number):String {
			var tempStr:String = "";
			if (index == 1) {
				if (str.length == 1 ) {
					tempStr = "0." + str;
				}else {
					tempStr = str.substring(0, str.length - 1) + "." + str.substr( -1, 1);
				}
			}else if (index == 2) {
				if (str.length == 1) {
					tempStr = "0.0" + str;
				}else if (str.length == 2) {
					tempStr = "0." + str;
				}else {
					tempStr = str.substring(0, str.length - 2) + "." + str.substr( -2, 2);	
				}
			}else if (index == 3) {
				if (str.length == 1) {
					tempStr = "0.00" + str;
				}else if (str.length == 2) {
					tempStr = "0.0" + str;
				}else if (str.length == 3){
					tempStr = "0." + str;
				}else {
					tempStr = str.substring(0, str.length - 3) + "." + str.substr( -3, 3);	
				}
			}
			
			return tempStr;
		}
		
		/**
		 * 计算加数
		 * @param	baibox
		 * @param	shibox
		 * @param	gebox
		 */
		private function countAdd(baibox:Box,shibox:Box,gebox:Box):Number {
			var bai:Number = 0;
			var shi:Number = 0;
			var ge:Number = 0;
			
			var baiYu:Number = 0;
			var shiYu:Number = 0;
			var geYu:Number = 0;
			geYu = gebox.boxCellArr.length % 10;
			if (geYu != 0) {
				ge = geYu;
			}else {
				ge = 0;
			}
			shiYu = (shibox.boxCellArr.length + int(gebox.boxCellArr.length / 10)) % 10;
			if (shiYu != 0) {
				shi = shiYu;	
			}else {
				shi = 0;
			}
			baiYu = (baibox.boxCellArr.length + int((shibox.boxCellArr.length + int(gebox.boxCellArr.length / 10))/10));
			bai = baiYu;
			
			var sub:Number = (bai * 100 + shi * 10 + ge);
			var result:Number=0;
			return sub;
		}
		
		/**
		 * 显示数字 和 小数点
		 */
		private function showNuber():void {
			for (var i:int = 0; i < boxArr.length; i++) {
				var box:Box = boxArr[i] as Box;
				box.numViewVisible(isShowNumber);
			}
			
			showDot();
		}
		/**
		 * 显示小数点
		 */
		private function showDot():void {
			if (currentSelectIndex == 0) {
				dotMc1.visible = false;
				dotMc2.visible = false;
				return;
			}
			
			var boo:Array = checkCanShowDot();
			var d1:Boolean = boo[0];
			var d2:Boolean = boo[1];
			if (isShowNumber && d1) {
				dotMc1.visible = true;
				dotMc1.parent.setChildIndex(dotMc1, dotMc1.parent.numChildren - 1);
			}else {
				dotMc1.visible = false;
			}
			
			if ( isShowNumber && d2) {
				dotMc2.visible = true;
				dotMc2.parent.setChildIndex(dotMc2, dotMc2.parent.numChildren - 1);
			}else {
				dotMc2.visible = false;
			}
		}
		
		/**
		 * 是否可以显示小数点 每三个box一组，其中一个box中的物体数量大于10不可以显示小数点
		 * @return  【true ,ture 】索引0 第一个小数点是否可以显示 1第二个小数点
		 */
		private function checkCanShowDot():Array {
			if (boxArr.length <= 3) {
				for (var i:int = 0; i < boxArr.length; i++) {
					var box:Box = boxArr[i] as Box;
					if (!box.downTen()) {
						return [false, false];
					}
				}
				return [true,false]
			}else {
				var d1:Boolean = true;
				var d2:Boolean = true;
				var box:Box;
				for (var i:int = 0; i < 3; i++) {
					box= boxArr[i] as Box;
					if (!box.downTen()) {
						d1 =  false;
						break;
					}
				}
				
				for (i = 3; i < 6; i++) {
					box = boxArr[i] as Box;
					if (!box.downTen()) {
						d2 =  false;
						break;
					}
				}
				
				return [d1, d2];
			}
			
			return [false,false];
		}
		
		/**
		 * checkbox 根据索引 做不同处理
		 * @param	index
		 */
		private function selectHandByIndex(index:uint):void {
			currentSelectIndex = index;
			showDot();
			
			var labelArr:Array;
			var colorArr:Array;
			switch(index) {
				case 0:
					labelArr = titleLabelArr1;
					colorArr = color1;
					dotMc1.x = 760;
					dotMc2.x = 760;
					break;
				case 1:
					labelArr = titleLabelArr2;
					colorArr = color2;
					dotMc1.x = 510;
					dotMc2.x = 510;
					break;
				case 2:
					labelArr = titleLabelArr3;
					colorArr = color3;
					dotMc1.x = 260;
					dotMc2.x = 260;
					break;
				case 3:
					labelArr = titleLabelArr4;
					colorArr = color4;
					dotMc1.x = 8;
					dotMc2.x = 8;
					break;
			}
			
			baiLabel.text = labelArr[0];
			shiLabel.text = labelArr[1];
			geLabel.text = labelArr[2];
			
			currentColor = colorArr;
			
			for (var i = 0; i < boxArr.length; i++) {
				var box:Box = boxArr[i] as Box;
				box.changeGoodsColor(colorArr[0], colorArr[1]);
			}
			
			changeSingeGoodColor(baiMc, colorArr[0], colorArr[1]);
			changeSingeGoodColor(shiMc, colorArr[0], colorArr[1]);
			changeSingeGoodColor(geMc, colorArr[0], colorArr[1]);
		}
		
		/**
		 * 拖拽到不同盒子上的不同操作
		 * @param	srcMc
		 * @param	box
		 */
		private function crateBoxs(srcMc:MovieClip, box:Box):void {
			var globalPosition:Point = this.localToGlobal(new Point(srcMc.x,srcMc.y));
			var localPosition:Point = box.globalToLocal(globalPosition);
			if (srcMc.type == HUNDREDS && box.type ==  Box.TYPE_HUNDREDS) {
				box.createBoxs(1, localPosition.x, localPosition.y);
			}else if (srcMc.type == HUNDREDS && box.type ==  Box.TYPE_TENS) {
				box.createBoxs(10, localPosition.x, localPosition.y);
			}else if (srcMc.type == HUNDREDS && box.type ==  Box.TYPE_ONES) {
				box.createBoxs(100, localPosition.x, localPosition.y);
			}else if (srcMc.type == TENS && box.type ==  Box.TYPE_HUNDREDS) {
				
			}else if (srcMc.type == TENS && box.type ==  Box.TYPE_TENS) {
				box.createBoxs(1, localPosition.x, localPosition.y);
			}else if (srcMc.type == TENS && box.type ==  Box.TYPE_ONES) {
				box.createBoxs(10, localPosition.x, localPosition.y);
			}else if (srcMc.type == ONES && box.type ==  Box.TYPE_HUNDREDS) {
				
			}else if (srcMc.type == ONES && box.type ==  Box.TYPE_TENS) {
				
			}else if (srcMc.type == ONES && box.type ==  Box.TYPE_ONES) {
				box.createBoxs(1, localPosition.x, localPosition.y);
			}
		}
		
		//临时创建的物体在结束时是否碰撞到了集合中的一个盒子
		private function checkCrateBoxHit(mc:MovieClip, arr:Array):Box {
			for (var i:int = 0; i < arr.length; i++) {
				var box:Box = arr[i];
				if (mc.hitTestObject(box)) {
					return box;
				}
			}
			return null;
		}
		
		/**
		 * 鼠标提起，检查碰撞，
		 * @param	srcBox  原box
		 * @param	arr  box集合
		 * @return　　返回和原box碰撞的box
		 */
		private function checkHit(srcBox:Box,arr:Array):Box
		{
			var box:Box;
			
			for (var i:int = 0; i < arr.length; i++) {
				box =  arr[i] as Box;
				if ( srcBox != box && srcBox.selectContainer&& srcBox.selectContainer.hitTestObject(box)) {
					return  box;
				}
			}
			return null;
		}
		/**
		 * 鼠标抬起,检查当前鼠标的位置 跟物体的碰撞<暂时没用到>
		 * @param	arr
		 * @return
		 */
		private function checkPointHit(arr:Array):Box {
			var p:Point = new Point(this.mouseX, this.mouseY);
			for (var i:int = 0; i < arr.length; i++) {
				var box:Box = arr[i] as Box;
				if (box.hitTestPoint(p.x,p.y)) {
					return box;
				}
			}
			return null;
		}
		/**
		 * 不同盒子之间的拖拽操作
		 * @param	srcBox
		 * @param	endBox
		 */
		private function operation(srcBox:Box, endBox:Box):void {
			var srcType:String = srcBox.type;
			var endType:String = endBox.type;
			var localP:Point = new Point(0, 0);
			var tempGlobal:Point = srcBox.tempSelectContainerGlobalPosition();	
			if (tempGlobal) {
				localP = endBox.globalToLocal(tempGlobal);
			}
			var nums:Number;
			if (srcType == Box.TYPE_HUNDREDS && endType == Box.TYPE_HUNDREDS) {
				//一百到一百
				nums = srcBox.tempSelectArr.length;
				srcBox.deleteAllSelectBoxs();
				endBox.createBoxs(nums,localP.x,localP.y);
			}else if (srcType == Box.TYPE_HUNDREDS && endType == Box.TYPE_TENS) {
				//一百到十 分解成10个十单位的物体
				nums = srcBox.tempSelectArr.length;
				srcBox.deleteAllSelectBoxs();
				endBox.createBoxs(nums * 10,localP.x);
			}else if ( srcType == Box.TYPE_HUNDREDS && endType == Box.TYPE_ONES) {
				//一百到一 分解成100个一单位的物体
				nums = srcBox.tempSelectArr.length;
				srcBox.deleteAllSelectBoxs();
				endBox.createBoxs(nums * 100);
			}else if (srcType == Box.TYPE_TENS && endType == Box.TYPE_HUNDREDS) {
				//十到一百.每是个合成一个一百单位，剩余的回到原位置
				groupGood(srcBox,endBox,10);
			}else if (srcType == Box.TYPE_TENS && endType == Box.TYPE_TENS) {
				//十到十
				nums = srcBox.tempSelectArr.length;
				srcBox.deleteAllSelectBoxs();
				endBox.createBoxs(nums,localP.x,localP.y);
			}else if (srcType == Box.TYPE_TENS && endType == Box.TYPE_ONES) {
				//十到一 ，每个分解成10个 一单位
				nums = srcBox.tempSelectArr.length;
				srcBox.deleteAllSelectBoxs();
				endBox.createBoxs(nums * 10,localP.x,localP.y);
			}else if (srcType == Box.TYPE_ONES && endType == Box.TYPE_HUNDREDS) {
				//一道一百  每一百个合成一个  剩余回到原位置
				groupGood(srcBox,endBox,100);
			}else if (srcType == Box.TYPE_ONES && endType == Box.TYPE_TENS) {
				//一到十 每十个合成一个 剩余回到原位置
				groupGood(srcBox,endBox,10);
			}else if (srcType == Box.TYPE_ONES && endType == Box.TYPE_ONES) {
				//一到一
				nums = srcBox.tempSelectArr.length;
				srcBox.deleteAllSelectBoxs();
				endBox.createBoxs(nums,localP.x,localP.y);
			}
		}
		/**
		 * 隐藏盒子	
		 * @param	arr
		 */
		private function visibleBoxs(arr:Array,boo:Boolean):void {
			for (var i:int = 0; i < arr.length; i++) {
				var box:Box = arr[i];
				box.visible = boo;
				box.changeGoodsColor(currentColor[0], currentColor[1]);
			}
		}
		/**
		 * 创建组合box
		 */
		private function crateGroupBoxs():void {
			visibleBoxs(boxArr,false);
			
			var goundBox1:Box = new Box(box1.width,box1.height*2);
			goundBox1.type = Box.TYPE_HUNDREDS;
			goundBox1.x = box1.x;
			goundBox1.y = box1.y;
			goundBox1.changeGoodsColor(currentColor[0], currentColor[1]);
			addChild(goundBox1);
			
			var goundBox2:Box = new Box(box1.width-1,box1.height*2);
			goundBox2.type = Box.TYPE_TENS;
			goundBox2.x = box2.x;
			goundBox2.y = box2.y;
			goundBox2.changeGoodsColor(currentColor[0], currentColor[1]);
			addChild(goundBox2);
			
			var goundBox3:Box = new Box(box1.width-1,box1.height*2);
			goundBox3.type = Box.TYPE_ONES;
			goundBox3.x = box3.x;
			goundBox3.y = box3.y;
			goundBox3.changeGoodsColor(currentColor[0], currentColor[1]);
			addChild(goundBox3);
			
			boxArr = [];
			
			boxArr.push(goundBox1, goundBox2, goundBox3);
			for (var i:int = 0; i < boxArr.length; i++) {
				var boxMc:Box = boxArr[i] as Box;
				boxMc.addEventListener(MouseEvent.MOUSE_DOWN, boxHand,true);
			}
			crateGroupGoods(goundBox1, box1, box4);
			crateGroupGoods(goundBox2, box2, box5);
			crateGroupGoods(goundBox3, box3, box6);
			
			showNuber();
		}
		/**
		 * 组合box
		 * @param	group  组合box
		 * @param	sub1   子box 1
		 * @param	sub2   子box 2
		 */
		private function crateGroupGoods(group:Box, sub1:Box, sub2:Box):void {
			var sub1Goods:Array = sub1.boxCellArr;
			var sub2Goods:Array = sub2.boxCellArr;
			var i:int = 0;
			var mc:MovieClip;
			var len:uint = sub1Goods.length;
			var globalP:Point;
			var localP:Point;
			for (i = 0; i < len; i++) {
				mc = sub1Goods[i];
				globalP = sub1.localToGlobal(new Point(mc.x, mc.y));
				localP = group.globalToLocal(globalP);
				group.createBoxs(1, localP.x, localP.y);
			}
			len = sub2Goods.length;
			for (i = 0; i < len; i++) {
				mc = sub2Goods[i];
				globalP = sub2.localToGlobal(new Point(mc.x, mc.y));
				localP = group.globalToLocal(globalP);
				group.createBoxs(1, localP.x, localP.y);
			}
		}
		
		//删除组合box
		private function deleteGroupBox():void {
			for (var i:int = 0; i < boxArr.length; i++) {
				var box:Box = boxArr[i];
				if (box.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					box.removeEventListener(MouseEvent.MOUSE_DOWN, boxHand);
				}
				box.parent.removeChild(box);
			}
			
			boxArr = [];
			boxArr.push(box1, box2, box3, box4, box5, box6);
			visibleBoxs(boxArr, true);
			showNuber();
		}
		
		
		/**
		 * 组合物体
		 * @param	srcBox  源盒子
		 * @param	endBox  目标盒子
		 * @param	groundNum  源盒子的多少个物体组合成目标盒子的一个物体
		 */
		private function groupGood(srcBox:Box, endBox:Box,groundNum:Number):void {
			
			var nums:Number = srcBox.tempSelectArr.length;
				var hunNums:int = int(nums / groundNum);
				var leftNums:int = nums % groundNum;
				if (hunNums > 0) {//足够合成
					var localP:Point = new Point(0, 0);
					var tempGlobal:Point = srcBox.tempSelectContainerGlobalPosition();	
					if (tempGlobal) {
						localP = endBox.globalToLocal(tempGlobal);
					}
					if (leftNums == 0) {
						endBox.createBoxs(hunNums,localP.x,localP.y);
						srcBox.deleteAllSelectBoxs();
					}else if ( leftNums != 0) {
						var tempArr:Array = srcBox.tempSelectArr.splice(0, nums - leftNums);
						endBox.createBoxs(hunNums,localP.x,localP.y);
						srcBox.deleteSomeBoxs(tempArr);
						srcBox.restorePosition();
					}
				}else {///不够合成一个
					srcBox.restorePosition();
				}	
		}
	}

}