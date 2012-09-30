package ui {
    import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import sergik.utils.Utils;

    public class Tolltip {
        public var pUI:Object = null;			// Обьект родителя
        private var cont:Object = null;			// Контейнер reklama 
		private var chkTimer:Timer = null;		// Таймер смены рекламы
		private	var deltaX:int = 0;		// сдвиг туллтипов

        public function Tolltip(inp:Object) {
			this.pUI = inp;
			initUI();
        }

		private function initUI(ev:Event = null):void {
			if(pUI.hasOwnProperty('tolltipDeltaX')) this.deltaX = pUI.tolltipDeltaX;
			cont = pUI._skin['tolltip'];
			pUI._skin.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			pUI._skin.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
			pUI._skin.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);

			chkTimer = new Timer(3000, 1);	// Таймер смены рекламы
			chkTimer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			cont.visible = false;
		}

		private function mouseMove(e:MouseEvent):void {
			cont.y = e.stageY - (e.stageY < 50 ? -1:1) * 30;
			var pos:int = e.stageX - cont.width/2;
			if(pos < 0) pos += cont.width/2;
			if(pos + cont.width > cont.stage.stageWidth) pos -= cont.width/2;
			cont.x = pos + deltaX;

			var tp:String = e.target.name;
//trace(">> mouseMove: ", tp);
			if(tp == 'barm' || tp == 'bar' || tp == 'beg') {
				var zn:Number = (tp == 'beg' ? e.target.x : e.localX);
				var out:String = pUI.vdp2.getTimeOnBar(zn, tp) + ' / ' + pUI.vdp2.durationStr;
				//var out:String = pUI.vdp2.getTimeOnBar(e.stageX) + ' / ' + pUI.vdp2.durationStr;
				showText(out, e);
			}
		}

		private function mouseOver(e:MouseEvent):void {
			var out:String = '';
			var tp:String = e.target.name;
//trace(">> mouseOver: ", tp);
			switch(tp) {
				case 'video3':			// мышь на видео
				case 'video2':
				case 'video1':
					//var vObj:Object = pUI[tp.replace(/^video/, 'vdp')];
					//if(!vObj) return;
					//out = vObj.data['text'];
					break;
				case 'btnStop':
					out = 'Стоп';
					break;
				case 'btnPause':
					out = 'Пауза';
					break;
				case 'btnPlay':
					out = 'Старт';
					break;
				case 'btnResume':
					out = 'Продолжить';
					break;
				case 'soundOff':
					out = 'Включить звук';
					break;
				case 'soundSwitch':
					out = 'Отключение звука';
					break;
				case 'off_mc':
					out = 'Полный экран';
					break;
				case 'on_mc':
					out = 'Обычный экран';
					break;
				case 'vol_bar':
				case 'vol_beg':
				case 'volumeBar':
				case 'btnVolume':
					out = 'Громкость';
					break;
				case 'bar':
					//out = 'Полный экран';
					break;
			}

			if(out) showText(out, e);
		}

		private function showText(st:String, e:MouseEvent):void {
			cont.text = st;
			cont.width = cont.textWidth + 8;
			cont.visible = true;

			if(chkTimer.running) chkTimer.reset();
			chkTimer.start();
			//mouseMove(e);
		}

		private function mouseOut(e:MouseEvent):void {
			//trace(">> mouseOut: ", e.target.name);
			cont.visible = false;
		}

		private function onTimer(e:TimerEvent = null):void {
			//trace('onTimer : ' ,e);
			if(cont.visible) cont.visible = false;
		}

	}
 }
