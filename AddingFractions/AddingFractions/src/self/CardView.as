package src.self 
{
	import com.greensock.TweenLite;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**卡片类
	 * ...
	 * @author Mu
	 */
	public class CardView extends ListBoxView 
	{
		
		private var contentTxt:TextBox;//文本
		
		private var _fenzi:Number;//分子
		private var _fenmu:Number;//分母
		private var _position:Point;//处事坐标
		
		private var wentiArr:Array = ["一","二","三","四","五","六","七","八","九","十","十一","十二"];
		/**
		 * 卡片
		 * @param	color  颜色
		 * @param	size   每个格子的大小
		 * @param	total  卡片总长度
		 */
		public function CardView(color:uint,size:Number,total:Number,fz:Number,fm:Number,showFlag:Boolean = false) 
		{
			var format:TextFormat  = new TextFormat();
			if (fm < 9) {
				format.size = 20;
			}else if (fz >=3) {
				format.size = 20;
			}	
			
			updates(color, size, total);
			this.setChildIndex(numMc, this.numChildren - 1);
			this.setChildIndex(topMc, this.numChildren - 1);
			topMc.width = total;
			topMc.height = selfHeight;
			
			contentTxt = new TextBox();
			if (showFlag) {
				numMc.visible = false;
				
				contentTxt.texts(wentiArr[fm - 1] + "分之" + wentiArr[fz - 1]);
				addChild(contentTxt);
				
				if (contentTxt.width < total-10) {
					contentTxt.x = (this.width - contentTxt.width) / 2;
					contentTxt.y = (this.height - contentTxt.height) / 2;
				}else {
					contentTxt.rotates(90);
					contentTxt.x = (total- contentTxt.width) / 2+contentTxt.width;
					contentTxt.y = (selfHeight - contentTxt.height) / 2;
				}
			}else {
				contentTxt.visible = false;
				numMc.visible = true;
				numMc.mouseEnabled = false;
				numMc.mouseChildren = false;
			}
			TextField(numMc.fz).autoSize = "center";
			TextField(numMc.fm).autoSize = "center";
			this.buttonMode = true;
			fenzi = fz;
			fenmu = fm;
			_position = new Point(0, 0);
			
			centers();
		}
		
		override protected function drawLine(se:Number, total:Number):void 
		{
			lineContainer.graphics.clear();
			var size:Number = se;
			var startP:Point;
			var endP:Point;
			for (var i:int = 1; i < total/se; i++) {
				startP = new Point(size * i, 0);
				endP = new Point(size * i, selfHeight);
				drawDashed(lineContainer,startP,endP);
			}
		}
		
		override protected function drawColor(col:uint, se:Number, total:Number):void 
		{
			var g:Graphics = colorContaienr.graphics;
			g.clear();
			var size:Number = se;
			g.beginFill(col);
			g.drawRect(0, 0,total, selfHeight);
			g.endFill();
		}
		
		private function centerT():void {
			
		}
		
		public function get fenzi():Number 
		{
			return _fenzi;
		}
		
		public function set fenzi(value:Number):void 
		{
			_fenzi = value;
			numMc.fz.text = _fenzi.toString();
		}
		
		public function get fenmu():Number 
		{
			return _fenmu;
		}
		
		public function set fenmu(value:Number):void 
		{
			_fenmu = value;
			numMc.fm.text = _fenmu.toString();
		}
		
		public function get position():Point 
		{
			return _position;
		}
		
		public function set position(value:Point):void 
		{
			_position = value;
		}
		/**
		 * 动画效果
		 * @param	can
		 */
		public function animate(can:MovieClip):void {
			var endx:Number = can.x + Math.random() * (can.width - this.width);
			var endy:Number = can.y + Math.random() * (can.height - this.height);
			TweenLite.to(this, 0.4, { x:endx, y:endy } );
			position.x = endx;
			position.y = endy;
		}
		/**
		 * 复位
		 */
		public function resetPosition():void {
			TweenLite.to(this, 0.4, { x:position.x, y:position.y } );
		}
		
		private function centers():void {
			numMc.x = (this.width - numMc.width) / 2;
			numMc.y = (this.height - numMc.height) / 2;
		}
	}

}