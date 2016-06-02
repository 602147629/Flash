package src.self 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**文本
	 * ...
	 * @author Mu
	 */
	public class TextBox extends Sprite 
	{
		private var txt:TextField;
		private var format:TextFormat;
		var b:Sprite = new Sprite();
		public function TextBox() 
		{
			txt = new TextField();
			addChild(txt);
			txt.autoSize = "left";
			txt.selectable = false;
			//txt.border = true;
			txt.mouseEnabled = false;
			txt.text = "";
			
			format = new TextFormat();
			format.bold = true;
			format.size = 18;
			format.font = "Arial";
			txt.defaultTextFormat = format;
			
			
			//addChild(b);
			//var a:Sprite = new Sprite();
			//a.graphics.beginFill(0xff0000);
			//a.graphics.drawCircle(0, 0, 5);
			//addChild(a);
		}
		
		public function rotates(val:Number):void {
			rotationZ = val;
		}
		public function texts(t:String):void {
			txt.text = t;
		}
		
		public function setFs(rows:Number, cols:Number):void {
			//if (rows >= 10 && cols >= 10) {
				//setSize(46)
			//}else if (rows >= 8 && cols >= 8) {
				//setSize(28)
			//}else if (rows >= 3 && cols >= 3) {
				//setSize(24)
			//}else if (rows >= 2 && cols >= 2) {
				//setSize(20)
			//}else if (rows >= 0 && cols >= 0) {
				//setSize(16)
			//}else {
				//
			//}
			
			if (rows >= 0 && rows <= 3) {
				if (cols >= 0 && cols <= 2) {
					setSize(16)
				}else if (cols >= 3 && cols <= 4) {
					setSize(24)
				}else if (cols >= 5 && cols <= 8) {
					setSize(28)
				}else if (cols >= 9 && cols <= 14) {
					setSize(34)
				}else{
					setSize(46)
				}
			}else if (rows >= 4 && rows <= 6) {
				if (cols >= 0 && cols <= 2) {
					setSize(16)
				}else if (cols >= 3 && cols <= 4) {
					setSize(24)
				}else if (cols >= 5 && cols <= 8) {
					setSize(28)
				}else if (cols >= 9 && cols <= 14) {
					setSize(34)
				}else{
					setSize(46)
				}
			}else if (rows >= 7 && rows <= 12) {
				if (cols >= 0 && cols <= 2) {
					setSize(16)
				}else if (cols >= 3 && cols <= 4) {
					setSize(24)
				}else if (cols >= 5 && cols <= 8) {
					setSize(28)
				}else if (cols >= 9 && cols <= 14) {
					setSize(34)
				}else{
					setSize(46)
				}
			}else{
				if (cols >= 0 && cols <= 2) {
					setSize(16)
				}else if (cols >= 3 && cols <= 4) {
					setSize(24)
				}else if (cols >= 5 && cols <= 8) {
					setSize(28)
				}else if (cols >= 9 && cols <= 14) {
					setSize(34)
				}else{
					setSize(46)
				}
			}
			
		}
		
		private function tweens(srn:Number, min:Number, max:Number):Boolean {
			if (srn >= min && srn <= max) {
				return true;
			}
			return false;
		}
		
		/**
		 * 设置字体大小
		 * @param	size
		 */
		public function setSize(size:Number):void {
			format.size = size;
			txt.defaultTextFormat = format;
		}
	}

}