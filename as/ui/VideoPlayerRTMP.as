package ui {
    import flash.display.Sprite;
    import flash.display.StageDisplayState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
//flash.events.FullScreenEvent
	import flash.media.Video;
	import flash.media.SoundTransform;

	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import flash.net.NetConnection;
    import flash.net.NetStream;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.greensock.*;
	import com.greensock.easing.Linear;

	import flash.geom.Point;

	import sergik.utils.Utils;
	import sergik.net.FileLoader;
	
	import ui.VimeoSoundUI;

	import Conf;

    public class VideoPlayerRTMP extends Sprite {
		public var inBitmapData:BitmapData = null;
        public var data:Object = null;			// Параметры плейера 
        private var povtorCont:Object = null;	// Контейнер рестарта 
        private var ajaxLoaderView:Object = null;	// Контейнер Дрочиловки 

		private	var hideAttr:int = 0;			// Тик в который надо отключить управление
		private var playBox:Sprite = null;		// Контейнер Bar 
		private var iconCont:Object = null;		// Контейнер иконки
		private var vimeo_sound:VimeoSoundUI = null;	// Контейнер vimeo_sound 

		private var volCont:Object = null;		// Контейнер управления звуком
        private var btn_full:Object = null;		// Экран
        private var mDownObj:Object = null;		// Обьект mouseDown

		public var duration:Number = 0;			// Общее время видео
		public var durationStr:String = '';		// Общее время видео - текст
		private var curTime:String = '';		// Строка текущего времени

		public var wStageWidth:Number = 0;
		public var hStageHeight:Number = 0;
		private var ratio:Number = 1;

		private var timePixel:Number = 0;		// Коэф.временной шкалы

		private var soundWidth:int = 0;			// ширина BG бегунка громкости
		private var barWidth:int = 0;			// ширина BG бегунка bar
		private var mouseDown:int = 0;			// признак нажатой мыши
		private var onPause:Boolean = false;	// признак паузы

		private var minVolume_x:int = 0;		// минимальная позиция бегунка громкости
        private var maxVolume_x:int = 0;		// максимальная позиция бегунка громкости
        //private var videoURL:String = "test1.flv";
        private var videoURL:String = "http://192.168.0.66:8191/test.flv";
        //private var streamName:String = "koza_087.mp4";
        private var streamName:String = "qwerty";

		private var connection:NetConnection;
        public var stream:NetStream;
		private	var video:Video;
		private var chkTimer:Timer = null;	// Таймер update
		private	var _HD_downState:Object = null;
		private	var _HD_upState:Object = null;

        public function VideoPlayerRTMP(inp:Object, plBox:Object = null) {
			this.data = inp;
			//this.playBox = plBox;
			//this.stopFlag = stop;
			this.addEventListener(Event.ADDED_TO_STAGE, initUI, false, 0, true);
        }

		public function setSkins():void {
			this.name = 'video_sprite';
			video = new Video();
			video.smoothing = true;
			//video.name = 'video';
			//video.x = 0; video.y = 0;

			this.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			if(this.data['width']) video.width = this.data['width'];
			if(this.data['height']) video.height = this.data['height'];
			//trace(">> connectStream11: ", videoURL, playBox, video.width, ' : ', video.height);
			iconCont = Conf.pUI._skin['video2']['video_icon'];	// Контейнер иконки
			iconCont.visible = false;
			if(this.data['icon']) {
				var st:String = Conf.pUI.sPrefix + this.data['icon'];
				iconCont.addChild(new FileLoader(st,  {'callback': iconLoded}));
			}

            this.addChild(video);
			
			playBox = Utils.takeLinkage('playBox_cont') as Sprite;
			playBox.x = 0; playBox.y = 536;
			//playBox.visible = false;
			//btn_full = Conf.pUI._skin['btn_full_cont'];
			btn_full = playBox['btn_cont']['btn_full_cont'];
			//btn_full['svern'].mouseEnabled = 
				//btn_full['razv'].mouseEnabled =
				btn_full['svern'].visible = false;
			//btn_full.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, eventFullScreen, false, 0, true);

vimeo_sound = new VimeoSoundUI(playBox['btn_cont']['vimeo_sound']);
vimeo_sound.addEventListener('SET_VIMEO_VOL', set_vimeo_vol, false, 0, true);

			Conf.pUI._skin['crop_btn_cont'].visible = false;

			_HD_downState = playBox['btn_cont']['btn_HD'].downState;
			_HD_upState = playBox['btn_cont']['btn_HD'].upState;
			var flag:Boolean = (this.data['quality'] == 'HD' ? true : false);
			playBox['btn_cont']['btn_HD'].upState = (flag ? _HD_downState : _HD_upState);
			playBox['btn_cont']['btn_LD'].visible = false;

			playBox['btn_cont']['curTime'].visible = false;
			playBox['bar']['beg']['time'].mouseEnabled = false;

			barWidth = playBox['bar']['barm'].width - 3;	// ширина BG bar
 
			playBox['bar']['beg'].buttonMode = 
			playBox['bar']['beg'].useHandCursor = true;
			//playBox['bar']['beg']['show_link'].visible = false;
			playBox['bar']['beg'].addEventListener(MouseEvent.MOUSE_DOWN, barbegMouseDown, false, 0, true);
			//playBox['bar']['beg'].addEventListener(MouseEvent.MOUSE_OVER, barbegMouseOver, false, 0, true);
			//playBox['bar']['beg'].addEventListener(MouseEvent.MOUSE_OUT, barbegMouseOut, false, 0, true);
			//playBox['bar']['beg'].addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp, false, 0, true);

			playBox['bar']['barm'].addEventListener(MouseEvent.MOUSE_MOVE, barmMouseMove, false, 0, true);
			playBox['bar']['barm'].addEventListener(MouseEvent.MOUSE_OUT, barmMouseOut, false, 0, true);
			barmMouseOut();

			wStageWidth = Conf.pUI.stage.fullScreenWidth;
			hStageHeight = Conf.pUI.stage.fullScreenHeight;

			setFull(false);
			setPlayPause(false);

			Conf.pUI._skin['video2']['video_btn_cont'].addChild(playBox);

			ajaxLoaderView = Utils.takeLinkage('ajaxLoaderView_cont');
			ajaxLoaderView.x = 335; ajaxLoaderView.y = 233;
			this.addChild(ajaxLoaderView as Sprite);

			playBox.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			vimeo_sound.setVolume(Conf.volLike);
		}

		private function barmMouseOut(e:MouseEvent = null):void {
			playBox['bar']['mouseTime'].visible = false;
		}
		private function barmMouseMove(e:MouseEvent):void {
			var sec:Number = (e.localX - 1)/ timePixel;
			if(sec < 0) sec =0;
			else if(sec > duration) sec = duration;
			var stOnly:String = setTimeStr(sec);
			var obj:Object = playBox['bar']['mouseTime'];

			obj['time'].htmlText = stOnly;
			obj.x = e.localX;
			if(!obj.visible) obj.visible = true;
		}

		/**
		 * Обработчик результата FileLoader
		*/
		private function iconLoded(status:String, ldr:Object):void {
			ldr.width = video.width;
			ldr.height = video.height;
		}

		private function setPlayPause(flag:Boolean = true):void {
			var obj:Object = playBox['btn_cont']['PlayPause'];
			obj['btnResume'].visible = flag;
			obj['btnPause'].visible = !flag;
		}

		public function videoStop():void {
			if(stream) stream.pause();
		}
		public function videoPlay():void {
//trace("videoPlay: " , stream, streamName);
			if(stream) {
				stream.play(streamName);
			}
		}

        public function desctructor() {
			//this.removeEventListener(MouseEvent.CLICK, mouseClick);
			connect_Closed();
			if(playBox) {
				if(chkTimer) {
					chkTimer.reset();
					chkTimer.removeEventListener(TimerEvent.TIMER, onRandTimer);
					//trace(">> desctructor: ", this.parent);
					chkTimer = null;
				}
			}

			if(this.parent) {
				this.parent.removeChild(this);
			}
        }

		private function initUI(ev:Event = null):void {
			if(this.data['videoURL']) videoURL = this.data['videoURL'];
			if(this.data['streamName']) streamName = this.data['streamName'];

			this.removeEventListener(Event.ADDED_TO_STAGE, initUI);
			setSkins();

			if(!chkTimer) {
				chkTimer = new Timer(500);	// Таймер update
				chkTimer.addEventListener(TimerEvent.TIMER, onRandTimer, false, 0, true);
				chkTimer.start();
			}

			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseOver, false, 0, true);
			this.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave, false, 0, true);

			initConnect();

			//this.stage.displayState = StageDisplayState.NORMAL;
			ratio = wStageWidth / 512;
			if(ratio > hStageHeight / 288) {
				ratio = hStageHeight / 288;
			}
//trace(">> videoURL: ", videoURL);
		}

		private function initConnect():void {
			connection = new NetConnection();
			var customClient:Object = new Object();
			customClient.onMetaData = onBWDone;
			connection.client = customClient;

			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
//trace(">> videoURL: ", videoURL, ':', this.data['type']);

			connection.connect(this.data['type'] == 'file'? null:videoURL);
		}

		private function connect_Closed():void {
			if(stream) {
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				stream.close();
				stream = null;
			}
			if(connection) {
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection = null;
			}
		}

        private function netStatusHandler(event:NetStatusEvent):void {
trace(">> netStatusHandler: ", event.info.code, videoURL, Utils.Dumper(event.info));
			switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetConnection.Connect.Closed":
					connect_Closed();
					setPlayPause(true);
					this.dispatchEvent(new Event('VIDEO_END'));
                    break;
				case "NetStream.Play.StreamNotFound":
                    //trace("Unable to locate video: " + videoURL);
                    break;
                case "NetStream.Play.Start":
					//if(stopFlag) stream.pause();
                    break;
                case "NetStream.Buffer.Full":
					this.dispatchEvent(new Event('VIDEO_BUFFER_FULL'));
					ajaxLoaderView.visible = false;
					break;
                case "NetStream.Buffer.Empty":
					ajaxLoaderView.visible = true;
                    break;
                case "NetStream.Play.Stop":
					//stream.close();
					pauseMe();
					this.dispatchEvent(new Event('VIDEO_END'));
					break;
                case "NetStream.Seek.Notify":
					if(this.data['notAutoStart']) {
						pauseMe();
					}
					delete this.data['notAutoStart'];
					break;
			}
        }

        private function connectStream():void {
            stream = new NetStream(connection);
			var zn:Number = this.data['bufferTime'] || 1;
			stream.bufferTime = zn;	// размер буфера после кторого стартуем
			//trace(">> stream: ", stream, ' : ', connection);

			var customClient:Object = new Object();
			customClient.onMetaData = onMetaDataHandler;
			//customClient.onImageData = onImageDataHandler;
			//customClient.onTextData = onTextDataHandler; 
			customClient.onCuePoint = onCuePointHandler;
			stream.client = customClient;

			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
				
			video.attachNetStream(stream);

			var flag:Boolean = (this.data['quality'] == 'HD' ? true : false);
			var plObj:Object = {
				'name': ( flag ? this.data['streamHQName'] : this.data['streamName'])
				,'start': Number(this.data['seek'])
			};
			var st:String = (this.data['type'] == 'file'? videoURL : plObj['name']);
trace("connectStream: " , st, Utils.Dumper(plObj));
			stream.play(st);

			playMe();
			ajaxLoaderView.visible = true;
			if(this.data['notAutoStart']) {
				iconCont.visible = true;
			}
		}

		private function setQuality(tp:String = 'HQ'):void {
			var flag:Boolean = false;
			if(this.data['quality'] == 'HD') {
				Conf.pUI.videoAttr['quality'] = 'LD';
			} else {
				flag = true;
				Conf.pUI.videoAttr['quality'] = 'HD';
			}
			if(stream) {
				Conf.pUI.videoAttr['seek'] = stream.time || 0;
			}
			Conf.pUI.addVideoPlayer();
/*
			playBox['btn_cont']['btn_HD'].upState = (flag ? _HD_downState : _HD_upState);

			if(stream) {
				this.data['seek'] = stream.time || 0;
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				stream.close();
				stream = null;
			}
			connectStream();
*/
trace("setQuality: " , tp, flag);
//			playBox['btn_cont']['btnQuality']['btnQualityLQ'].alpha = (tp == 'LQ' ? 1 : 0.5);
		}

		public function playMe():void {
//trace("playMe: " , connection, stream);

			if(!connection || !connection.connected) return;
			if(playBox) setPlayPause(false);
			if(onPause) { onPause = false; stream.resume(); }
			iconCont.visible = false;
		}

		public function chkBimap():BitmapData {
			inBitmapData = new BitmapData(video.width, video.height);
			if(inBitmapData) {
				playBox.visible = false;
				inBitmapData.draw(this);
				playBox.visible = true;
				return inBitmapData;
			}
			return null;
		}

		public function pauseMe():void {
//trace("pauseMe: " , connection.connected, stream);
			ajaxLoaderView.visible = false;
			if(!connection || !connection.connected) return;
			if(stream) {
//trace("bufferLength: " , stream.bufferLength, stream.bufferTime );
				onPause = true; stream.pause();
			}
			if(playBox) setPlayPause(true);
		}

		private function setTimeBar(nm:Number = 0):void {
			var stOnly:String = setTimeStr(nm);
			if(stOnly != curTime) {
				curTime = stOnly;
				//playBox['btn_cont']['curTime'].htmlText = curTime;
				playBox['bar']['beg']['time'].htmlText = curTime;
				setBar(nm);
//trace("setTimeBar: " , stream.time, ' : ', nm, ' : ', stOnly);
			}
		}

		private function mouseOver(e:MouseEvent = null):void {
//trace(">> mouseOver: ", mouseOver);
			hideAttr = 0;
			playBox.y = 536;
			if(stream && stream.time) Conf.pUI._skin['crop_btn_cont'].visible = true;
		}

		private function mouseLeave(e:Event = null):void {
//trace(">> mouseOut: ");
			if(!chkTimer) return;
			hideAttr = chkTimer.currentCount + 4;
			if(mDownObj) stageMouseUp();
		}
		private function onObjFinishTween(dObj:Object):void {
//trace("onObjFinishTween: " , dObj);
		}

		private function onRandTimer(e:TimerEvent = null):void {
			
			if(!connection || !connection.connected) return;

			if(hideAttr == chkTimer.currentCount) {
				var zn:int = (!this.stage.displayState || this.stage.displayState == StageDisplayState.NORMAL ? 700 : this.stage.fullScreenHeight);
				TweenLite.to(playBox, 0.5, {'y': zn, 'ease': Linear.easeNone, 'onComplete':onObjFinishTween, 'onCompleteParams': [playBox]});
				Conf.pUI._skin['crop_btn_cont'].visible = false;
			}

			if(stream && stream.time && !onPause) {
				setTimeBar(stream.time);
				this.dispatchEvent(new Event('CHK_COMMENT'));
			}
		}

		public function getTimeOnBar(x:Number):String {
			return setTimeStr(x / timePixel);
		}

		public function onBWDone(d:Object):void {
//trace("onBWDone: " , d);
		}

		public function onCuePointHandler(imageData:Object):void {
			trace("onCuePointHandler: " + imageData);
		}

		public function onImageDataHandler(imageData:Object):void {
//trace("imageData length: " + imageData.data.length);
		}
		public function onTextDataHandler(textData:Object):void {
//trace("--- textData properties ----", textData);
		}

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
        
        private function asyncErrorHandler(event:AsyncErrorEvent):void {
            trace("asyncErrorHandler: " + event);
        }
	
		private function mouseClick(e:MouseEvent):void {
			var tp:String = e.target.name;
trace(">> mouseClick: ", tp);
			switch(tp) {
				case 'btn_HD':		// Переключатель потоков
					setQuality(tp);
					//var st:String = data['qualityURL'] || '';
					//if(st) Utils.openURLtab(st, '_self');
					break;
				case 'btnQualityHQ':
					Conf.pUI.addVideoPlayer('HQ');
					break;
				case 'vol_bar':				// Управление звуком
					setVolume((e.localX + minVolume_x) / soundWidth);
					break;
				case 'btnPlay':				// Команды 
					playMe();
					break;
				case 'video_sprite':		// Стоп/Старт
					if(Conf.pUI._skin['crop_btn_cont']['crop_done_btn'].visible) return;
					if(onPause) playMe();
					else pauseMe();
					break;
				case 'btnStop':				// Стоп
					pauseMe();
					break;
				case 'btnPause':			// Команды 
					pauseMe();
					break;
				case 'btnResume':			// Команды 
					playMe();
					break;
				case 'btnSeek':				// Команды 
					//stream.seek(100);
					break;
				case 'btnClose':			// Команды 
					stream.close();
					break;
				case 'barm':					// воспроизводить поток, начиная с sec секунд 
					var sec:Number = e.localX / timePixel;
					stream.seek(sec);
					setTimeBar(sec);
					break;
				case 'razv':				// Полный экран
				case 'svern':				// Вернуться
				//case 'btn_full':			// Полный экран
					chkFull();
					break;
			}
		}

// beg: Полный экран
		private function setFull(flag:Boolean = true):void {
			btn_full['razv'].visible = !flag;
			btn_full['svern'].visible = flag;
		}

		private function eventFullScreen(e:Object = null):void {
			var flag:Boolean = (!Conf.pUI.stage.displayState || Conf.pUI.stage.displayState == StageDisplayState.NORMAL ? false:true);
//trace(">> eventFullScreen: ", flag);
			setFull(flag);
		}

		public function chkFull():void {
//trace(">> chkFull: ", Conf.pUI.stage);
			Conf.pUI.stage.displayState = (Conf.pUI.stage.displayState == StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN);
			eventFullScreen();
		}
// end: Полный экран
/*
		private function barbegMouseOver(mev:MouseEvent):void {
			if(mev.target.name != 'beg') return;
			//var obj:Object = playBox['bar']['beg']['show_link'];
			//if(!obj.visible) obj.visible = true;
		}
		private function barbegMouseOut(e:MouseEvent):void {
		}
*/
		/**
		 * по нажатию мыши drag бегунка bar
		 */
		private function barbegMouseDown(mev:MouseEvent):void {
			var tmp:uint = (new Date()).time;
			if(tmp < mouseDown + 1000) return;
			if(mev.target.name == 'show_link') return;
			mouseDown = tmp;
			
			if(!this.stage) return;
			mDownObj = playBox['bar']['beg'];
			mDownObj.startDrag(false, new Rectangle(1, -2, barWidth - 5, 0));
		}

		/** по релизу мыши
		 */
		private function stageMouseUp(mev:MouseEvent = null):void {
			if(!mDownObj) return;
			var tp:String = mDownObj.name;
			var obj:Object = null;
			switch (tp) {
                case "barm":
                case "beg":
					var sec:Number = mDownObj.x / timePixel;
					stream.seek(sec);
                    break;
			}
			mouseDown = 0;
			if(mDownObj) mDownObj.stopDrag();
			mDownObj = null;
		}

// beg: Звук
		private function set_vimeo_vol(e:Object = null):void {
			setVolume(Conf.volLike);
		}

		/**
		 * Установка громкости
		 */
		private function setVolume(vol:Number = 0.5):void {
			if(!connection.connected || !stream) return;
			var transform:SoundTransform = stream.soundTransform;
			Conf.volLike = vol;
			transform.volume = vol;
			stream.soundTransform = transform;
			vimeo_sound.setVolume(Conf.volLike);
		}
// end: Звук

		public function onMetaDataHandler(metaData:Object):void {
			Conf.metaData = metaData;
			if(!metaData.duration || !playBox) return;

			var firstFlag:Boolean = (!duration ? true:false);
			duration = metaData.duration;	// Общее время видео

			if(duration) {
				if(playBox['bar']) timePixel = barWidth / duration;
				durationStr = setTimeStr(duration);
//trace(">> onMetaData: ", timePixel, duration, playBox['bar'].width, Utils.Dumper(metaData));
				if(firstFlag) {
					var startTime:Number = 0;
					if(this.data['seek']) {
						startTime = Number(this.data['seek']);
					}

					stream.seek(startTime);
					//pauseMe();
					delete this.data['seek'];
					curTime = '  ';
					setTimeBar(startTime);

					if(this.data['notAutoStart']) {
						pauseMe();
						iconCont.visible = true;
					}
					delete this.data['notAutoStart'];
				}
			}
			 if(playBox['bar']) playBox['bar'].visible = true;
		}	

		public function setTimeStr(inp:Number):String {
			var len:int = inp;
			var out:String = '';
			var zn:int = int(len / 3600); len -= zn*3600;
			if(zn > 0) out += zn + ':'; 
			
			zn = int(len / 60); len -= zn*60;
			//out += (out && zn < 10 ? '0' : '') + zn + ':'; 
			out += (zn < 10 ? '0' : '') + zn + ':'; 

			out += (len < 10 ? '0' : '') + len;
			return out;
		}
		private function setBar(tm:Number):void {
			if(!duration) return;		// еще не получили - Общее время видео
			if(playBox && playBox['bar']) {
				var zn:Number = timePixel * tm;
				if(zn > barWidth) zn = barWidth;
				if(zn != playBox['bar']['playBar'].width) {
					playBox['bar']['playBar'].width = zn;
				}
				zn = stream.bytesLoaded * barWidth / stream.bytesTotal;
				if(zn > barWidth) zn = barWidth;
				if(zn != playBox['bar']['loadedBar'].width) playBox['bar']['loadedBar'].width = zn;
				if(!mouseDown) playBox['bar']['beg'].x = playBox['bar']['playBar'].width;
			}
		}
	}
 }
