package MyComponent.ui.button
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class FilterLib
	{
		public static const glow_Ora:GlowFilter = new GlowFilter(0xFFFF00, 1);
		public static const glow_inner_0xFF9900:GlowFilter = new GlowFilter(0xFF9900, 1, 4, 4, 2, 2, true);
		public static const glow_0x69E5FF:GlowFilter = new GlowFilter(6940159, 1);
		public static const glow_R22G5B5:GlowFilter = new GlowFilter(1443077, 1, 1, 1, 2, 2);
		public static const glow_0x272727:GlowFilter = new GlowFilter(0x272727, 1, 2, 2, 10);
		public static const glow_0x272727_3px:GlowFilter = new GlowFilter(0x272727, 1, 3, 3, 1.5);
		public static const glow_0xFF7200_6px:GlowFilter = new GlowFilter(0xFF7200, 1, 6, 6, 1.5);
		public static const glow_0xFFBA00_5px:GlowFilter = new GlowFilter(0xFFBA00, 1, 5, 5, 1);
		public static const glow_0xBEA884:GlowFilter = new GlowFilter(12494980, 1, 2, 2, 10);
		public static const glow_0x000000:GlowFilter = new GlowFilter(0, 1, 2, 2, 10);
		public static const glow_0xff3600:GlowFilter = new GlowFilter(0xFF3600, 1, 2, 2, 10);
		public static const dropShadow_0x000000:DropShadowFilter = new DropShadowFilter(1, 270, 0, 1, 1, 1, 5);
		public static const glow_0x00A8FF:GlowFilter = new GlowFilter(43263, 1, 6, 6, 2);
		public static const glow_0xE000A9:GlowFilter = new GlowFilter(0xE000A9, 1, 6, 6, 2);
		
		public static var enbaleFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		public static var enbaleFilter2:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0, 0, 0, 0, 0, 0.3, 0, 0, 0, 0, 0, 0.3, 0, 0, 0, 0, 0, 0.8, 0]);
		public static var glow_classic:GlowFilter = new GlowFilter(464663, 1, 1.3, 1.3, 7, 1);
		public static var glow_dust:GlowFilter = new GlowFilter(464663, 1, 1.1, 1.1, 1, 1);
		public static var glow_soft:GlowFilter = new GlowFilter(464663, 1, 1.4, 1.4, 3, 2);
		public static var glow_lite:GlowFilter = new GlowFilter(464663, 1, 1.4, 1.4, 2, 2);
		public static var glow_cloud:GlowFilter = new GlowFilter(464663, 1, 2, 2, 2.2, 5);
		public static var glow_white:GlowFilter = new GlowFilter(0xFFFFFF, 1, 1.1, 1.1, 2, 2);
		public static var glow_green:GlowFilter = new GlowFilter(6719539, 1, 3, 3, 5, 1.2);
		public static var glow_Red:GlowFilter = new GlowFilter(0xFFFFFF, 1, 1, 1, 3, 1);
		public static var glow_Green:GlowFilter = new GlowFilter(6750054, 1, 1, 1, 3, 1);
		public static var glow_Blue:GlowFilter = new GlowFilter(6750207, 1, 1, 1, 3, 1);
		public static var drop_shadow:DropShadowFilter = new DropShadowFilter(1.5, 45, 0, 0.5, 2, 2, 1.8);
		public static var drop_soft:DropShadowFilter = new DropShadowFilter(1.5, 45, 0, 0.8, 1, 1, 2);
		public static var drop_classic:DropShadowFilter = new DropShadowFilter(1, 45, 0, 1, 1, 1, 3);
		public static var drop_dust:DropShadowFilter = new DropShadowFilter(1, 45, 0, 0.8, 1, 1, 1);
		public static var drop_bold:DropShadowFilter = new DropShadowFilter(1, 45, ColorLib.orange, 1, 3, 3, 1);
		public static var drop_big:DropShadowFilter = new DropShadowFilter(2, 45, 34436, 1, 1, 1, 3);
		public static var drop_sun:DropShadowFilter = new DropShadowFilter(2, 225, 0xFFFFFF, 0.8, 1, 1, 2);
		public static var buttonModelTextFilter:GlowFilter = new GlowFilter(0x000000,1,2,2,4,2,false,false);
		
		public function FilterLib()
		{
		}
	}
}