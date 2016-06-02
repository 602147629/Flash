package src.self 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...	
	 * @author Mu
	 */
	public class WrapSkin extends Sprite 
	{
		private var boxArr:Array = [];
		private var _rowsNumber:Number;
		private var _colsNumber:Number;
		
		public var _txt:TextBox;
		private var _boxSize:Number;
		
		private var reallyw:Number;
		private var reallyh:Number;
		public function WrapSkin() 
		{
			super();
			_txt = new TextBox();
			addChild(_txt);
		}
		public function updates(rows:Number, cols:Number):void {
			clears();
			var i:uint = 0;
			var j:uint = 0;
			var box:Wrap;
			rowsNumber = cols + 1;
			colsNumber = rows + 1;
			
			for (i = 0; i <= cols; i++) {
				for (j = 0; j <= rows; j++) {
					box = new Wrap();
					_boxSize = box.width;
					box.y = i * box.width;
					box.x = j * box.height;
					addChild(box);
					boxArr.push(box);
				}
			}
			
			reallyw = colsNumber * _boxSize;
			reallyh = rowsNumber * _boxSize;
			
			_txt.setFs(cols, rows);
			if (rows == 0 && cols == 0) {
				ones();
			}else {
				updateT(rows+1, cols+1);
			}
		}
		
		//更新文本
		private function updateT(r:Number, cl:Number):void {
			_txt.texts ( (r * cl) + " = " + r + " × " + cl);
			this.setChildIndex(_txt, this.numChildren - 1);

			if (colsNumber <= 3) {
				if (colsNumber == 1) {
					_txt.rotates(90);
					_txt.x = (colsNumber * _boxSize - _txt.width) / 2+_txt.width-5//+18-colsNumber*5;
					_txt.y = (rowsNumber * _boxSize - _txt.height) / 2;
				}else if (colsNumber == 2 && rowsNumber == 3) {
					_txt.rotates(90);
					_txt.x = (colsNumber * _boxSize - _txt.width) / 2+_txt.width-5//+18-colsNumber*5;
					_txt.y = (rowsNumber * _boxSize - _txt.height) / 2;
				}else if(rowsNumber>3){
					_txt.rotates(90);
					_txt.x = (colsNumber * _boxSize - _txt.width) / 2+_txt.width-5//+18-colsNumber*5;
					_txt.y = (rowsNumber * _boxSize - _txt.height) / 2;
				}else {
					_txt.rotates(0);
					_txt.x = (colsNumber * _boxSize - _txt.width) / 2;
					_txt.y = (rowsNumber * _boxSize - _txt.height) / 2;
				}
				
			}else {
				_txt.rotates(0);
				_txt.x = (colsNumber * _boxSize - _txt.width) / 2;
				_txt.y = (rowsNumber * _boxSize - _txt.height) / 2;
			}
		}
		/**
		 * 算式结果为一
		 */
		public function ones():void {
			_txt.texts ("1");
			this.setChildIndex(_txt, this.numChildren - 1);
			_txt.rotates(0);
			_txt.x = (colsNumber * _boxSize - _txt.width) / 2;
			_txt.y = (rowsNumber * _boxSize - _txt.height) / 2;
		}
		
		//清除
		private function clears():void {
			var i:uint = 0;
			var len:uint = boxArr.length;
			var box:Wrap;
			for (i = 0; i < len; i++) {
				box = boxArr[i] as Wrap;
				box.parent.removeChild(box);
			}
			
			boxArr = [];
		}
		
		public function get rowsNumber():Number 
		{
			return _rowsNumber;
		}
		
		public function set rowsNumber(value:Number):void 
		{
			_rowsNumber = value;
		}
		
		public function get colsNumber():Number 
		{
			return _colsNumber;
		}
		
		public function set colsNumber(value:Number):void 
		{
			_colsNumber = value;
		}
	}
}