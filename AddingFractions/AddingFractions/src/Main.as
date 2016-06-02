package src 
{
	import flash.display.MovieClip;
	import src.self.MainView;
	/**
	 * ...
	 * @author Mu
	 */
	public class Main extends MovieClip
	{
		public function Main() 
		{
			Global.stage = mainView;
			Global.contentContainer = mainView.content;
			
			var view:MainView = new MainView();
			Global.contentContainer.addChild(view);
		}
	}

}