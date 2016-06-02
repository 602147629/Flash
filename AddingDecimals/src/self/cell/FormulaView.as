package self.cell 
{
	import game.ui.self.FormulaUI;
	
	/**式子类
	 * ...
	 * @author Mu
	 */
	public class FormulaView extends FormulaUI 
	{
		
		public function FormulaView() 
		{
			super();
			num1.visible = false;
			num2.visible = false;
			sum.visible = false;
			line.visible = false;
			add.visible = false;
		}
		/**
		 * 设置文本内容
		 * @param	add1
		 * @param	add2
		 */
		public function values(add1:String, add2:String,sums:String):void {
			num1.text = add1;
			num2.text = add2;
			sum.text =  sums;
		}
		
		public function showAdd(boo:Boolean):void {
			num1.visible = boo;
			num2.visible = boo;
			line.visible = boo;
			add.visible = boo;
		}
		public function showSum(boo:Boolean):void {
			sum.visible = boo;
		}
		public function clear():void {
			num1.text = "0";
			num2.text = "0";
			sum.text =  "0";
		}
	}

}