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
		public function TextBox() 
		{
			txt = new TextField();
			addChild(txt);
			txt.autoSize = "left";
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
			
			format = new TextFormat();
			format.font = "微软雅黑";
			format.bold = true;
			format.size = 16;
			txt.defaultTextFormat = format;
		}
		
		public function rotates(val:Number):void {
			rotationZ = val;
		}
		public function texts(t:String):void {
			txt.text = t;
		}
	}

}