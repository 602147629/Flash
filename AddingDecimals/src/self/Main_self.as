package self 
{
	import flash.display.Sprite;
	import self.cell.MainView;
	/**
	 * ...
	 * @author Mu
	 */
	public class Main_self extends Sprite 
	{
		
		public function Main_self() 
		{
			super();
			var mainView:MainView = new MainView();
			addChild(mainView);
		}
		
	}

}