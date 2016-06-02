package src.self 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**数字显示框
	 * ...
	 * @author Mu
	 */
	public class NumberBox extends MovieClip 
	{
		private var _fenziT:TextField;
		private var _fenmuT:TextField;
		private var _ffT:TextField
		
		private var _ffz:Number;
		private var _ffm:Number;
		public function NumberBox() 
		{
			_fenziT = fz;
			_fenmuT = fm;
			_ffT = ff;
			
			_fenziT.autoSize = "center";
			_fenmuT.autoSize = "center";
			_ffT.autoSize = "center";
		}
		
		/**
		 *设置值 
		 * @param	fz
		 * @param	fm
		 */
		public function setValue(fz:int, fm:int, flag:String = "one"):void {
			ffz = fz;
			ffm = fm;
			line.width = 47;
			//line.x = 22;
			//_fenziT.x = 6;
			//_fenmuT.x = 0;
			if (flag == "one") {
				_fenziT.text = fz.toString();
				_fenmuT.text = fm.toString();
				_ffT.text = "";
				this.x -= 15;
				//line.x = 3;
			}else {
				var zz:int;
				var yu:int;
				if (fz >= fm) {
					zz = int(fz / fm);
					yu = fz % fm;
					if (yu == 0) { 
						line.width = 0;
						_fenziT.text = "";
						_fenmuT.text = "";
						this.x += 15;
						//_fenziT.x = 0;
						//_fenmuT.x = 0;
						_ffT.text = zz.toString();
					}else {
						_fenziT.text = yu.toString();
						_fenmuT.text = fm.toString();
						_ffT.text = zz.toString();
						//_fenziT.x = 20;
						//_fenmuT.x = 19;
					}
				}else if ( fz < fm) {
					_fenziT.text = fz.toString();
					_fenmuT.text = fm.toString();
					_ffT.text = "";
					this.x -= 15;
					//_fenziT.x = 20;
					//_fenmuT.x = 19;
					//line.x = 3;
				}
			}
		}
		
		public function get ffz():Number 
		{
			return _ffz;
		}
		
		public function set ffz(value:Number):void 
		{
			_ffz = value;
		}
		
		public function get ffm():Number 
		{
			return _ffm;
		}
		
		public function set ffm(value:Number):void 
		{
			_ffm = value;
		}
		
	}

}