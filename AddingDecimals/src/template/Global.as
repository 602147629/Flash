package template 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import morn.core.components.Label;
	/**全局数据
	 * ...
	 * @author Mu
	 */
	public class Global 
	{
		/**全局舞台**/
		public static var stage:Stage;
		
		public static function init(main:Sprite):void {
			stage = main.stage;
		}
		
		public static var templateContainer:Sprite = new Sprite();////模板容器
		public static var contentContainer:Sprite = new Sprite();////内容容器
	}

}