package ui {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;

	import flash.geom.Rectangle;
	import flash.geom.Point;

	import com.greensock.*;
	import com.greensock.easing.*;

	import sergik.utils.Utils;
	import Conf;
	
	public class VimeoSoundUI extends EventDispatcher {
		// ------- Constants -------
		private var _cont:Object = null;
		private static const EASE_TYPE:Object = Linear.easeOut;
		private static const DELAY:Number = 0.2;
		private static const MAX_WIDTH:int = 42;
		private static const MAX_SIZE:int = 20;
		private static var MIN_SIZE:int = 14;
		private static var BAR_COLOR:uint = Conf.BAR_COLOR;
		private static var BAR_BG:uint = Conf.BAR_BG;
		
		// ------- Constructor -------
		public function VimeoSoundUI(inp:Object) {
			_cont = inp;
			init();
		}

		private function init():void {
			_cont.buttonMode = true;
			_cont.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			_cont.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
//trace("VimeoSoundUI: " , _cont);
		}
		private function mouseClick(mev:MouseEvent):void {
			var pt:Point = new Point(mev.localX, mev.localY);
			pt = mev.target.localToGlobal(pt);
			pt = _cont.globalToLocal(pt);
			//Conf.volLike = int(10*pt.x/MAX_WIDTH) / 10;
			var zn:Number = pt.x / MAX_WIDTH;
			Conf.volLike = (zn <= 0.01 ? 0 : (zn>1 ? 1 : zn));
			this.dispatchEvent(new Event('SET_VIMEO_VOL'));
//trace(">> mouseClick: ", Conf.volLike, pt);
		}
		public function setVolume(vol:Number = 0.5):void {
			
			var zn:int = MAX_WIDTH * vol;
			var obj:Object = _cont['bar_cont']['bar'];
			obj.mouseEnabled = false;
			Utils.clrChilds(obj);
			var g:Graphics = obj.graphics;
			g.clear();
			g.beginFill(BAR_COLOR, 1);
			g.drawRect(0, 0, zn, 20);
			g.beginFill(BAR_BG, 1);
			g.drawRect(zn, 0, MAX_WIDTH - zn, 20);
			g.endFill();
//trace("setVolume: " , zn);
		}
		private function mouseOver(mev:MouseEvent):void {
			var st:String = mev.target.name.replace(/^v/, '');
//trace(">> mouseOver: ", st, mev.target.name);
			var obj:Object = _cont['bar_cont']['mask']['s'+st];
			if(obj) TweenMax.to(obj, DELAY, {'y': MIN_SIZE - MAX_SIZE, 'height':MAX_SIZE, ease:EASE_TYPE, 'onComplete': twEnd, 'onCompleteParams': [obj]});
		}

		private function twEnd(inp:Object):void {
			TweenMax.to(inp, DELAY*2, {'y': 0, 'height':MIN_SIZE, ease:EASE_TYPE});
		}
}
}