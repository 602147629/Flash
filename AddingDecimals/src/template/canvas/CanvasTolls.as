package template.canvas
{
	import com.greensock.core.SimpleTimeline;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.templateView.CanvasTollsUI;
	import template.canvas.util.component.MyColorPixer;
	import template.Global;
	
	/**绘图工具显示，逻辑类
	 * ...
	 * @author Mu
	 */
	public class CanvasTolls extends CanvasTollsUI
	{
		/////边数
		private var _edgeNum:Number = 3;
		
		public function set edgeNum(value:Number):void
		{
			_edgeNum = value;
			
			label_edgeNum.text = value + "";
		}
		
		public function get edgeNum():Number
		{
			return _edgeNum;
		}
		
		/////线粗细
		private var _thickNum:Number = 2;
		
		public function set thickNum(value:Number):void
		{
			_thickNum = value;
			
			label_lineThick.text = value + "";
		}
		
		public function get thickNum():Number
		{
			return _thickNum;
		}
		
		////边的颜色
		private var _lineColor:uint = 0x000000;
		
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}
		
		public function get lineColor():uint
		{
			return _lineColor
		}
		
		/////线透明度
		private var _lineAlpha:Number = 1;
		
		public function set lineAlpha(value:Number):void
		{
			_lineAlpha = value;
		}
		
		public function get lineAlpha():Number
		{
			return _lineAlpha;
		}
		
		////填充透明度
		private var _fillAlpha:Number = 1;
		
		public function set fillAlpha(value:Number):void
		{
			_fillAlpha = value;
		}
		
		public function get fillAlpha():Number
		{
			return _fillAlpha;
		}
		
		////是否填充
		private var _isFill:Boolean;
		
		public function set isFill(value:Boolean):void
		{
			_isFill = value;
		}
		
		public function get isFill():Boolean
		{
			return _isFill;
		}
		
		////填充颜色
		private var _fillColor:uint = 0x000000;
		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		/////当前选择绘制的图形  -1没有选择  0箭头   1直线  2虚线........3,4,5多边形
		private var _selectNum:Number = -1;
		
		public function get selectNum():Number
		{
			return _selectNum;
		}
		
		public function set selectNum(value:Number):void
		{
			_selectNum = value;
			setBlock(value);
		}
		
		/////边数最小大值
		private const EDGE_NUM_MIN:Number = 3;
		private const EDGE_NUM_MAX:Number = 10;
		////线条粗细最小大值
		private const THICK_LINE_MIN:Number = 2;
		private const THICK_LINE_MAX:Number = 20;
		private var canvas:Sprite;
		private var shapesArr:Array = []; ////绘制图形数组
		private var currentShape:MovieClip; ////当前绘制的图形
		private var cancelArr:Array = []; ////取消数组
		
		private var lineColorPixer:MyColorPixer;
		private var fillColorPixer:MyColorPixer;
		public function CanvasTolls()
		{
			super();
			initView();
			this.visible = true;
		}
		
		private function initView():void
		{
			canvas = new Sprite();
			addChild(canvas);
			
			lineColorPixer = new MyColorPixer();
			lineColorPixer.setAlphaLabel("透明度:");
			addChild(lineColorPixer);
			lineColorPixer.setPosition(img_lineColor.x, img_lineColor.y);
			lineColorPixer.setColorBlockSize(img_lineColor.width, img_lineColor.height);
			img_lineColor.visible = false;
			
			
			fillColorPixer = new MyColorPixer();
			fillColorPixer.setAlphaLabel("透明度:");
			addChild(fillColorPixer);
			fillColorPixer.setPosition(img_fillColor.x, img_fillColor.y);
			fillColorPixer.setColorBlockSize(img_fillColor.width, img_fillColor.height);
			img_fillColor.visible = false;
			
			reset();
		}
		
		private function addEvent():void
		{
			btn_arrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowHand);
			btn_pencil.addEventListener(MouseEvent.MOUSE_DOWN, pencilHand);
			btn_line.addEventListener(MouseEvent.MOUSE_DOWN, lineHand);
			btn_dotline.addEventListener(MouseEvent.MOUSE_DOWN, dotlineHand);
			btn_rectangle.addEventListener(MouseEvent.MOUSE_DOWN, rectangleHand);
			btn_circle.addEventListener(MouseEvent.MOUSE_DOWN, ciclrHand);
			btn_polygon.addEventListener(MouseEvent.MOUSE_DOWN, polygonHand);
			
			btn_edgeNumPre.addEventListener(MouseEvent.MOUSE_DOWN, edgeNumPreHand);
			btn_edgeNumNext.addEventListener(MouseEvent.MOUSE_DOWN, edgeNumNextHand);
			btn_lineThickPre.addEventListener(MouseEvent.MOUSE_DOWN, lineThickPreHand);
			btn_lineThickNext.addEventListener(MouseEvent.MOUSE_DOWN, lineThickNextHand);
			
			btn_isFill.addEventListener(Event.CHANGE, isfillChangeHand);
			
			btn_cancel.addEventListener(MouseEvent.MOUSE_DOWN, cancelHand);
			btn_restore.addEventListener(MouseEvent.MOUSE_DOWN, restoreHand);
			btn_eyeopen.addEventListener(MouseEvent.MOUSE_DOWN, eyeopenHand);
			btn_eyeclose.addEventListener(MouseEvent.MOUSE_DOWN, eyecloseHand);
			btn_delete.addEventListener(MouseEvent.MOUSE_DOWN, deleteHand);
			btn_help.addEventListener(MouseEvent.MOUSE_DOWN, helpHand);
			
			App.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDwon);
			App.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			App.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			
			lineColorPixer.addEventListener(Event.CHANGE, linePixerHand);
			fillColorPixer.addEventListener(Event.CHANGE, fillPixerHand);
		}
		
		private function fillPixerHand(e:Event):void 
		{
			fillColor = fillColorPixer.selectedColor;
			fillAlpha = fillColorPixer.alphaValue;
		}
		
		private function linePixerHand(e:Event):void 
		{
			lineColor = lineColorPixer.selectedColor;
			lineAlpha = lineColorPixer.alphaValue;
		}
		
		private function stageUp(e:MouseEvent):void
		{
			if (currentShape)
			{
				currentShape = null;
			}
			
			if (selectShape)
			{
				selectShape.stopDrag();
				selectShape = null;
			}
		}
		
		private function stageMove(e:MouseEvent):void
		{
			if (currentShape)
			{
				drawShapesByFlag(selectNum);
			}
		}
		
		private function stageDwon(e:MouseEvent):void
		{
			if (this.mouseY < 45)
				return;
			
			var shape:MovieClip = new MovieClip();
			shape.flag = "one";
			shape.startp = new Point(this.mouseX, this.mouseY);
			currentShape = shape;
		}
		
		private function edgeNumNextHand(e:MouseEvent):void
		{
			edgeNum++;
			edgeNum = Math.min(EDGE_NUM_MAX, edgeNum);
		}
		
		private function isfillChangeHand(e:Event):void
		{
			isFill = btn_isFill.selected;
		}
		
		private function helpHand(e:MouseEvent):void
		{
		
		}
		
		private function deleteHand(e:MouseEvent):void
		{
			deleteAllShapes();
		}
		
		private function eyecloseHand(e:MouseEvent):void
		{
			hideOrShowAllShapes(true);
		}
		
		private function eyeopenHand(e:MouseEvent):void
		{
			hideOrShowAllShapes(false);
		}
		
		private function restoreHand(e:MouseEvent):void
		{
			nextShapes();
		}
		
		private function cancelHand(e:MouseEvent):void
		{
			preShapes();
		}
		
		private function lineThickNextHand(e:MouseEvent):void
		{
			thickNum++;
			thickNum = Math.min(THICK_LINE_MAX, thickNum);
		}
		
		private function lineThickPreHand(e:MouseEvent):void
		{
			thickNum--;
			thickNum = Math.max(THICK_LINE_MIN, thickNum);
		}
		
		private function edgeNumPreHand(e:MouseEvent):void
		{
			edgeNum--;
			edgeNum = Math.max(EDGE_NUM_MIN, edgeNum);
		
		}
		
		private function polygonHand(e:MouseEvent):void
		{
			selectNum = 6;
		}
		
		private function ciclrHand(e:MouseEvent):void
		{
			selectNum = 5;
		}
		
		private function rectangleHand(e:MouseEvent):void
		{
			selectNum = 4;
		}
		
		private function dotlineHand(e:MouseEvent):void
		{
			selectNum = 3;
		}
		
		private function lineHand(e:MouseEvent):void
		{
			selectNum = 2;
		}
		
		private function pencilHand(e:MouseEvent):void
		{
			selectNum = 1;
		}
		
		private function arrowHand(e:MouseEvent):void
		{
			selectNum = 0;
		}
		
		/*
		 *隐藏或显示多有图形
		 */
		private function hideOrShowAllShapes(boo:Boolean):void
		{
			if (shapesArr.length <= 0)
				return;
			if (boo)
			{
				btn_eyeclose.visible = false;
				btn_eyeopen.visible = true;
			}
			else
			{
				btn_eyeclose.visible = true;
				btn_eyeopen.visible = false;
			}
			for (var i:int = 0; i < shapesArr.length; i++)
			{
				var mc:MovieClip = shapesArr[i] as MovieClip;
				mc.visible = boo;
			}
		}
		
		/* *删除多有的图形
		 */
		private function deleteAllShapes():void
		{
			if (shapesArr.length <= 0)
				return;
			for (var i:int = 0; i < shapesArr.length; i++)
			{
				var mc:MovieClip = shapesArr[i] as MovieClip;
				if (mc)
				{
					mc.parent.removeChild(mc);
				}
			}
			
			shapesArr = [];
		}
		
		//撤销一步
		private function preShapes():void
		{
			if (shapesArr.length <= 0)
				return;
			var mc:MovieClip = shapesArr.pop();
			mc.parent.removeChild(mc);
			cancelArr.push(mc);
		}
		
		//还原一步
		private function nextShapes():void
		{
			if (cancelArr.length <= 0)
				return;
			var mc:MovieClip = cancelArr.pop();
			shapesArr.push(mc);
			canvas.addChild(mc);
		}
		
		/**
		 * 绘制图形
		 * @param	flag
		 */
		private function drawShapesByFlag(flag:Number):void
		{
			if (flag != -1)
			{
				switch (flag)
				{
					case 0: //选择
						//operationShape();
						break;
					case 1: //铅笔
						Pencil(currentShape, thickNum, lineColor, lineAlpha);
						break;
					case 2: //直线
						segment(currentShape, currentShape.startp, thickNum, lineColor, lineAlpha);
						break;
					case 3: 
						drawDashed(currentShape, currentShape.startp, thickNum, lineColor, lineAlpha);
						break;
					case 4: 
						Rectangular(currentShape, currentShape.startp, thickNum, lineColor, lineAlpha, isFill, fillColor, fillAlpha);
						break;
					case 5: 
						ellipse(currentShape, currentShape.startp, thickNum, lineColor, lineAlpha, isFill, fillColor, fillAlpha);
						break;
					case 6: 
						polygon(currentShape, currentShape.startp, thickNum, lineColor, lineAlpha, isFill, fillColor, fillAlpha, edgeNum);
						break;
				}
			}
		}
		
		/////设置标志块
		private function setBlock(values:Number):void
		{
			flag_block.visible = true;
			var p:Point;
			switch (values)
			{
				case-1: 
					flag_block.visible = false;
					break;
				case 0: 
					p = getBlockPosition(btn_arrow);
					flag_block.setPosition(p.x, p.y);
					break;
				case 1: 
					p = getBlockPosition(btn_pencil);
					flag_block.setPosition(p.x, p.y);
					break;
				case 2: 
					p = getBlockPosition(btn_line);
					flag_block.setPosition(p.x, p.y);
					break;
				case 3: 
					p = getBlockPosition(btn_dotline);
					flag_block.setPosition(p.x, p.y);
					break;
				case 4: 
					p = getBlockPosition(btn_rectangle);
					flag_block.setPosition(p.x, p.y);
					break;
				case 5: 
					p = getBlockPosition(btn_circle);
					flag_block.setPosition(p.x, p.y);
					break;
				case 6: 
					p = getBlockPosition(btn_polygon);
					flag_block.setPosition(p.x, p.y);
					break;
			}
		}
		
		/**
		 * 设置flag_block的位置
		 * @param	good
		 * @return
		 */
		private function getBlockPosition(good:Sprite):Point
		{
			var xd:Number = Math.abs(good.width - flag_block.width);
			var yd:Number = Math.abs(good.height - flag_block.height);
			var p:Point = new Point(good.x - xd / 2, good.y - yd / 2);
			return p;
		}
		
		/**
		 * 重置 释放资源
		 */
		public function reset():void
		{
			edgeNum = 3;
			thickNum = 2;
			
			label_edgeNum.text = edgeNum + "";
			label_lineThick.text = thickNum + "";
			
			flag_block.visible = false;
			btn_eyeclose.visible = false;
			
			selectNum = -1;
			
			removeEvent();
		}
		
		private var selectShape:MovieClip = null; ////当前选择的形状
		
		////给新建的图形添加事件
		private function shapeAddFun(mc:MovieClip):void
		{
			mc.addEventListener(MouseEvent.MOUSE_DOWN, shapeDown);
			mc.doubleClickEnabled = true;
			mc.addEventListener(MouseEvent.DOUBLE_CLICK, shapeDoubleD);
		}
		
		private function shapeDoubleD(e:MouseEvent):void
		{
			if (selectNum != 0)
				return;
			var mm:MovieClip = e.currentTarget as MovieClip;
			var index:Number = shapesArr.indexOf(mm);
			if (index != -1)
			{
				shapesArr.splice(index, 1);
				mm.parent.removeChild(mm);
			}
		
		}
		
		private function shapeDown(e:MouseEvent):void
		{
			if (selectNum != 0)
				return;
			var mc:MovieClip = e.currentTarget as MovieClip;
			selectShape = mc;
			mc.startDrag();
			mc.parent.setChildIndex(mc, mc.parent.numChildren - 1);
		}
		
		/**
		 * 铅笔绘制
		 * @param	mc绘制容器
		 * @param	thickness线条粗细
		 * @param	color线条颜色
		 * @param	alphas线条透明度
		 */
		private function Pencil(mc:MovieClip, thickness:Number = 2, color:uint = 0XFF00CC, alphas:Number = 1):void
		{
			if (mc.flag == "one")
			{
				mc.graphics.clear();
				mc.graphics.lineStyle(thickness, color, alphas);
				mc.graphics.moveTo(this.mouseX, this.mouseY);
				canvas.addChild(mc);
				mc.flag = "two";
				shapesArr.push(currentShape);
				shapeAddFun(mc);
			}
			else if (mc.flag == "two")
			{
				mc.graphics.lineTo(mc.mouseX, mc.mouseY);
				mc.graphics.endFill();
			}
		}
		
		/**直线绘制
		 *@param mc 绘制容器
		 *@beginPoint 起始点
		 *@thickness  线条粗细
		 *@color  线条颜色
		 *@alphas  线条透明度
		 */
		private function segment(mc:MovieClip, beginPoint:Point, thickness:Number = 2, color:uint = 0XFF00CC, alphas:Number = 1):void
		{
			if (mc.flag == "one")
			{
				canvas.addChild(mc);
				mc.flag = "two";
				shapesArr.push(currentShape);
				shapeAddFun(mc);
			}
			else if (mc.flag == "two")
			{
				mc.graphics.clear();
				mc.graphics.lineStyle(thickness, color, alphas);
				mc.graphics.moveTo(beginPoint.x, beginPoint.y);
				mc.graphics.lineTo(mc.mouseX, mc.mouseY);
			}
		}
		
		/**虚线绘制
		 *@mc 绘制容器
		 *@beginPoint 起始点
		 *@thickness  线条粗细
		 *@color  线条颜色
		 *@alphas  线条透明度
		 *@w  小线段的宽度
		 *@grap 间隙
		 */
		private function drawDashed(mc:MovieClip, beginPoint:Point, thickness:Number = 2, color:uint = 0XFF00CC, alphas:Number = 1, w:Number = 5, grap:Number = 5):void
		{
			if (mc.flag == "one")
			{
				canvas.addChild(mc);
				mc.flag = "two";
				shapesArr.push(currentShape);
				shapeAddFun(mc);
			}
			else if (mc.flag == "two")
			{
				var endPoint:Point = new Point(mc.mouseX, mc.mouseY);
				var g:Graphics = mc.graphics;
				g.clear();
				g.lineStyle(thickness, color, alphas);
				var Ox:Number = beginPoint.x;
				var Oy:Number = beginPoint.y;
				
				var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
				var totalLen:Number = Point.distance(beginPoint, endPoint);
				var currLen:Number = 0;
				var xx:Number, yy:Number;
				while (currLen <= totalLen)
				{
					
					xx = Ox + Math.cos(radian) * currLen;
					yy = Oy + Math.sin(radian) * currLen;
					g.moveTo(xx, yy);
					
					currLen += w;
					if (currLen > totalLen)
						currLen = totalLen;
					
					xx = Ox + Math.cos(radian) * currLen;
					yy = Oy + Math.sin(radian) * currLen;
					g.lineTo(xx, yy);
					
					currLen += grap;
				}
			}
		}
		
		/**矩形绘制
		 *@mc 绘制容器
		 *@beginPoint 起始点
		 *@thickness  线条粗细
		 *@color  线条颜色
		 *@alphas  线条透明度
		 *@isFille  是否填充
		 *@fillColor  填充颜色
		 *@fillAlpha  填充颜色透明度
		 */
		private function Rectangular(mc:MovieClip, beginPoint:Point, thickness:Number = 2, color:uint = 0XFF00CC, alphas:Number = 1, isFille:Boolean = false, fillColor:uint = 0xff0000, fillAlpha:Number = 1):void
		{
			if (mc.flag == "one")
			{
				canvas.addChild(mc);
				mc.flag = "two";
				shapesArr.push(currentShape);
				shapeAddFun(mc);
			}
			mc.graphics.clear();
			mc.graphics.lineStyle(thickness, color, alphas);
			//填充
			if (isFille)
			{
				mc.graphics.beginFill(fillColor, fillAlpha);
			}
			mc.graphics.moveTo(beginPoint.x, beginPoint.y);
			mc.graphics.lineTo(beginPoint.x, mc.mouseY);
			mc.graphics.lineTo(mc.mouseX, mc.mouseY);
			mc.graphics.lineTo(mc.mouseX, beginPoint.y);
			mc.graphics.lineTo(beginPoint.x, beginPoint.y);
		}
		
		/**椭圆绘制
		 *@mc 绘制容器
		 *@beginPoint 起始点
		 *@thickness  线条粗细
		 *@color  线条颜色
		 *@alphas  线条透明度
		 *@isFille  是否填充
		 *@fillColor  填充颜色
		 *@fillAlpha  填充颜色透明度
		 */
		private function ellipse(mc:MovieClip, startPoint:Point, thickness:Number = 2, color:uint = 0XFF00CC, alphas:Number = 1, isFille:Boolean = false, fillColor:uint = 0xff0000, fillAlpha:Number = 1):void
		{
			if (mc.flag == "one")
			{
				canvas.addChild(mc);
				mc.flag = "two";
				shapesArr.push(currentShape);
				shapeAddFun(mc);
			}
			mc.graphics.clear();
			var a:Number = mc.mouseX - startPoint.x;
			var b:Number = mc.mouseY - startPoint.y;
			mc.graphics.lineStyle(thickness, color, alphas);
			//填充
			if (isFille)
			{
				mc.graphics.beginFill(fillColor, fillAlpha);
			}
			var angle:Number = 0;
			mc.graphics.moveTo(startPoint.x + a * Math.cos(angle), startPoint.y + b * Math.sin(angle));
			do
			{
				angle += 0.01;
				mc.graphics.lineTo(startPoint.x + a * Math.cos(angle), startPoint.y + b * Math.sin(angle));
			} while (angle < 2 * Math.PI);
		}
		
		/**多边形绘制
		 *@mc 绘制容器
		 *@beginPoint 起始点
		 *@thickness  线条粗细
		 *@color  线条颜色
		 *@alphas  线条透明度
		 *@isFille  是否填充
		 *@fillColor  填充颜色
		 *@fillAlpha  填充颜色透明度
		 *@n  多边形边数
		 */
		private function polygon(mc:MovieClip, startPoint:Point, thickness:Number = 2, color:uint = 0XFF00CC, alphas:Number = 1, isFille:Boolean = false, fillColor:uint = 0xff0000, fillAlpha:Number = 1, n:int = 3):void
		{
			if (mc.flag == "one")
			{
				canvas.addChild(mc);
				mc.flag = "two";
				shapesArr.push(currentShape);
				shapeAddFun(mc);
			}
			mc.graphics.clear();
			var endPoint:Point = new Point(mc.mouseX, mc.mouseY);
			var alfa = 2 * Math.PI / n;
			var p = new Array(n - 1);
			var q = new Array(n - 1);
			p[0] = startPoint.x;
			p[1] = endPoint.x;
			q[0] = startPoint.y;
			q[1] = endPoint.y;
			for (var i:int = 2; i < n; i++)
			{
				p[i] = p[i - 1] * (1 + Math.cos(alfa)) - q[i - 1] * Math.sin(alfa) - p[i - 2] * Math.cos(alfa) + q[i - 2] * Math.sin(alfa);
				q[i] = p[i - 1] * Math.sin(alfa) + q[i - 1] * (1 + Math.cos(alfa)) - p[i - 2] * Math.sin(alfa) - q[i - 2] * Math.cos(alfa);
			}
			mc.graphics.lineStyle(thickness, color, alphas);
			//填充
			if (isFille)
			{
				mc.graphics.beginFill(fillColor, fillAlpha);
			}
			mc.graphics.moveTo(startPoint.x, startPoint.y);
			for (var qi:int = 1; qi < n; qi++)
			{
				mc.graphics.lineTo(p[qi], q[qi]);
			}
			mc.graphics.lineTo(startPoint.x, startPoint.y);
		}
		
		/**
		 * 重写父类的visible
		 */
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (value)
			{
				addEvent();
			}
			else
			{
				reset();
			}
		}
		
		private function removeEvent():void
		{
			btn_arrow.removeEventListener(MouseEvent.MOUSE_DOWN, arrowHand);
			btn_pencil.removeEventListener(MouseEvent.MOUSE_DOWN, pencilHand);
			btn_line.removeEventListener(MouseEvent.MOUSE_DOWN, lineHand);
			btn_dotline.removeEventListener(MouseEvent.MOUSE_DOWN, dotlineHand);
			btn_rectangle.removeEventListener(MouseEvent.MOUSE_DOWN, rectangleHand);
			btn_circle.removeEventListener(MouseEvent.MOUSE_DOWN, ciclrHand);
			btn_polygon.removeEventListener(MouseEvent.MOUSE_DOWN, polygonHand);
			
			btn_edgeNumPre.removeEventListener(MouseEvent.MOUSE_DOWN, edgeNumPreHand);
			btn_edgeNumNext.removeEventListener(MouseEvent.MOUSE_DOWN, edgeNumNextHand);
			btn_lineThickPre.removeEventListener(MouseEvent.MOUSE_DOWN, lineThickPreHand);
			btn_lineThickNext.removeEventListener(MouseEvent.MOUSE_DOWN, lineThickNextHand);
			
			btn_isFill.removeEventListener(Event.CHANGE, isfillChangeHand);
			
			btn_cancel.removeEventListener(MouseEvent.MOUSE_DOWN, cancelHand);
			btn_restore.removeEventListener(MouseEvent.MOUSE_DOWN, restoreHand);
			btn_eyeopen.removeEventListener(MouseEvent.MOUSE_DOWN, eyeopenHand);
			btn_eyeclose.removeEventListener(MouseEvent.MOUSE_DOWN, eyecloseHand);
			btn_delete.removeEventListener(MouseEvent.MOUSE_DOWN, deleteHand);
			btn_help.removeEventListener(MouseEvent.MOUSE_DOWN, helpHand);
			
			App.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageDwon);
			App.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			App.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
			
			lineColorPixer.removeEventListener(Event.CHANGE, linePixerHand);
			fillColorPixer.removeEventListener(Event.CHANGE, fillPixerHand);
		}
	}

}