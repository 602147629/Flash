package src.self 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import src.Global;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class ListBoxView extends MovieClip 
	{
		protected var _totalNum:Number=5;
		protected var _selectedNum:Number=1;
		protected var _colors:uint=0x99ffdd;
		
		protected var lineContainer:Sprite;//线容器
		protected var colorContaienr:Sprite;//颜色容器
		
		private var thisDown:Boolean = false;
		
		public var externalSynFun:Function;//外部同步函数
		
		protected var selfHeight:Number = 105;
		public function ListBoxView(hands:Function = null) 
		{
			externalSynFun = hands;
			initView();
			initEvent();
		}
		
		private function initView():void {
			
			colorContaienr = new Sprite();
			addChild(colorContaienr);
			
			lineContainer = new Sprite();
			addChild(lineContainer);
			if(topBg)
				this.setChildIndex(topBg, this.numChildren - 1);
			
			
			drawLine(selectedNum, totalNum);
			drawColor(colors, selectedNum, totalNum);
		}
		//事件
		private function initEvent():void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisDwonHand);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHand);
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMoveHand);
		}
		
		private function thisDwonHand(e:MouseEvent):void {
			thisDown = true;
			getSelectedNum(new Point(this.mouseX, this.mouseY), totalNum);
		}
		
		private function stageUpHand(e:MouseEvent):void {
			if (thisDown) {
				thisDown = false;
			}
		}
		
		private function stageMoveHand(e:MouseEvent):void {
			if (thisDown) {
				getSelectedNum(new Point(this.mouseX, this.mouseY), totalNum);
			}
		}
		
		/**
		 * 划线
		 * @param	se  选择的份数
		 * @param	total 总的份数
		 */
		protected function drawLine(se:Number, total:Number):void {
			lineContainer.graphics.clear();
			var size:Number = this.width / total;
			var startP:Point;
			var endP:Point;
			for (var i:int = 1; i < total; i++) {
				startP = new Point(size * i, 0);
				endP = new Point(size * i, selfHeight);
				drawDashed(lineContainer,startP,endP);
			}
		}
		
		/**
		 * 绘制颜色
		 * @param	col  颜色
		 * @param	se    选择份数
		 * @param	total  总的份数
		 */
		protected function drawColor(col:uint, se:Number, total:Number):void {
			var g:Graphics = colorContaienr.graphics;
			g.clear();
			var size:Number = this.width / total;
			g.beginFill(col);
			g.drawRect(0, 0, se * size, selfHeight);
			g.endFill();
			
		}
		/**
		 * 根据鼠标坐标更新绘制
		 * @param	p
		 * @param	total
		 */
		private function getSelectedNum(p:Point,total:Number):void {
			var size:Number = this.width / total;
			var se:Number = Math.ceil(p.x / size);
			if (se > total || se<1) return;
			drawColor(colors, se, total);
			if (externalSynFun != null) {
				externalSynFun(se,total);
			}
		}
		/**
		 * 更新绘制
		 * @param	color
		 * @param	se
		 * @param	total
		 */
		public function updates(color:uint, se:Number, total:Number):void {
			selectedNum = se;
			totalNum = total;
			colors = color;
			drawLine(se, total);
			drawColor(colors, se, total);
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
		
		public function get totalNum():Number 
		{
			return _totalNum;
		}
		
		public function set totalNum(value:Number):void 
		{
			_totalNum = value;
		}
		
		public function get selectedNum():Number 
		{
			return _selectedNum;
		}
		
		public function set selectedNum(value:Number):void 
		{
			_selectedNum = value;
		}
		
		public function get colors():uint 
		{
			return _colors;
		}
		
		public function set colors(value:uint):void 
		{
			_colors = value;
		}
	}

}