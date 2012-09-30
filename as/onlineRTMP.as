package {
    import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	import fl.managers.FocusManager;

	import flash.display.StageDisplayState;
    import flash.display.StageScaleMode;
    import flash.display.StageQuality;
    import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.system.System;
	import flash.external.ExternalInterface;

	//import flash.geom.PerspectiveProjection;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import com.greensock.*;
	import com.greensock.easing.*;
	//import com.greensock.easing.Linear;

	import com.adobe.serialization.json.*;
	import com.adobe.images.JPGEncoder;

	import sergik.utils.Utils;
	import sergik.net.URLLoaderQueue;
	import sergik.net.FileLoader;

	import ui.VideoPlayerRTMP;
	import ui.Tolltip;
	//import ui.EmbedUI;
	import ui.CropControl;

	import MultipartURLLoader;

	import Conf;

//import nl.demonsters.debugger.MonsterDebugger;

public class onlineRTMP extends Sprite {
//private var debugger:MonsterDebugger;
	private var fm:FocusManager;

	private var vid:String = '';
	private var _cropControl:CropControl;
	private var cropBMP:Bitmap = null;
	private var cropBMPdata:BitmapData = null;
	private	var related_cont:Object = null;		// Контейнер похожих
	private	var showLink:Object = null;		// Контейнер showLink

	private	var relatedData:Array = null;		// Данные похожих
	private var imagesPos:int = 20;
	private var imagesPosMin:int = 20;
	private var imagesPosMax:int = -2000;
	private var dxPos:int = 96;
	private var prevPos:int = 0;

	public var _skin:Sprite;			//	Основной контейнер

	private var chkTimer:Timer = null;		// Таймер отложенных операций
	private var videoURL:String = "rtmp://impressweb.org:1935/koza&streamName=mp4:koza-lq/koza_168_apple_lq.mp4";
	//private var serverPrefix:String = 'http://gidvision.ru/';
	private var uploadServer:String = 'http://auchat.ru/cgi/imgLoader.pl';
	private var commentServer:String = '/video/comment';

	private var infoServer:String = 'http://beta.koza.tv/video/related.json';
	private var pageURL:String = 'test'; // URL HTML страницы
	public var sPrefix:String = '';
	private var CommentFadeDelay:int = 5;	// Задержка гашения коммента
	private	var commentObj:Object = {		// Данные комментов
	};
	private	var comment_cont:Object = null;	// Контейнер комментов

	public var hideWarn:Boolean = false;				//	флаг необходимости скрытия warnings
/*
// http://beta.koza.tv/video/74
логин kozaplayer
[26.02.2011 21:12:30] Maksim Trofimenko: пароль 737gFGds!d
*/
	public	var videoAttr:Object = {		// параметры Видео
			"text": ""				// Описание канала
			,"videoURL": "rtmp://impressweb.org:1935/koza"
			,"width": 720
			,"height": 576
			,"volume": 1
			,"bufferTime": 1
			,"notAutoStart": 0
			,"seek": 0
			,"quality": 'LD'
			,"streamHQName": ''
			,"streamName": "mp4:koza_199_apple.mp4"
			,"type": 'rtmp'
			//,"type": 'file'
			,"icon": '/resources/thumbs/thumb_10_1408_294e03ee6b_3_600x480.jpg'
		};
	private	var chkTime:int = 1000;			// Время проверки состояния FlashPlayer по умолчанию
	private	var hideAttr:int = 0;			// Тик в который надо отключить управление
	private	var skipHideAttr:Boolean = false;	// игнорировать hideAttr

	private	var tolltip:Tolltip = null;		// Туллтипы
	//private	var embedUI:EmbedUI = null;		// EmbedUI

	//private	var needAnonsLoad:Boolean = true;	// готовность загрузки Анонса

	public	var vdp2:VideoPlayerRTMP = null;	// Видео в окне video2
	private	var currFrom:int = 0;				// Текущий номер видео
	private	var vdp2Width:Number = 0;			// Ширина видео окна
	private	var vdp2Height:Number = 0;			// Высота видео окна
	private	var currGID:int = -1;				// Текущий id голосовалки

	private	var isDebug:Boolean = false;
	private	var isInit:Boolean = false;

	private	var vidRun:Array = [];			// отложенные загрузки видеопотоков
	public	var curID:int = 2;				// id текущей передачи

	public function onlineRTMP() {
		this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
//debugger = new MonsterDebugger(this);
//MonsterDebugger.trace(this, "Hello World!");
	}

	private function init(ev:Event = null):void {
		//trace(">> init: ", isDebug, ' : ', 720/528);
		if(isInit) return;
		fm = new FocusManager(this);
//		stage.align = "TL";
		stage.stageFocusRect = false
		//stage.fullScreenSourceRect = new Rectangle(62, 14, 512, 288);	// В полноэкранном режиме только видео
//stage.scaleMode = "noScale";

		Conf.chkLoaderURL(this);

		var onlineSWF:String = 'online.swf';

		var params:Object = this.loaderInfo.parameters;
//params['seek'] = 54;
//params['notAutoStart'] = 0;
//params['anonsURL'] = 'http://192.168.0.200:222/ajaxrequest.ashx';
		if(params['vid']) vid = params['vid'];
		if(params['type']) videoAttr['type'] = params['type'];
		if(params['image']) videoAttr['icon'] = params['image'];
		if(params['seek']) videoAttr['seek'] = params['seek'];
		if(params['bufferTime']) videoAttr['bufferTime'] = params['bufferTime'];
		if(params['quality']) videoAttr['quality'] = params['quality'];
		if(params['streamName']) videoAttr['streamName'] = params['streamName'];
		if(params['streamHQName']) videoAttr['streamHQName'] = params['streamHQName'];
		if(params['videoURL']) videoURL = videoAttr['videoURL'] = params['videoURL'];
		
		if(params['CommentFadeDelay']) CommentFadeDelay = params['CommentFadeDelay'];
		if(params['pageURL']) pageURL = params['pageURL'];

commentServer = pageURL;

		if(params['prefix']) sPrefix = params['prefix'];
		if(params['infoServer']) infoServer = params['infoServer'];
		if(params['servURL']) uploadServer = params['servURL'];
		if(params['volume']) videoAttr['volume'] = Conf.volLike = params['volume'];
		if(params['notAutoStart']) videoAttr['notAutoStart'] = int(params['notAutoStart']);
		//if(params['chkTime']) chkTime = int(params['chkTime']);
//trace(">> notAutoStart: ", params['notAutoStart']);

		isDebug = (loaderInfo.loaderURL.match(/^file:\/\//) ? true : false);
		if(isDebug) {
			vid = '72';
			sPrefix = 'http://beta.koza.tv';
			//videoAttr['seek'] = 1.12;
			videoAttr['quality'] = 'HD';
//sPrefix = '';
			videoAttr['streamName'] = 'mp4:koza-lq/koza_168_apple_lq.mp4';
			videoAttr['streamHQName'] = 'mp4:koza-lq/koza_168_apple_hq.mp4';
			pageURL = 'http://beta.koza.tv/video/72';
videoURL = videoAttr['videoURL'] =  "rtmp://impressweb.org:1935/koza";

//vid=72&image=/resources/thumbs/thumb_2_441_03ea2246f0_3_600x480.jpg&videoURL=rtmp://impressweb.org:1935/koza&streamName=mp4:koza-lq/koza_168_apple_lq.mp4&seek=0&prefix=http://beta.koza.tv&servURL=/video/capture&notAutoStart=1&pageURL=http://beta.koza.tv/video/72&SessionName=PHPSESSID&SessionId=kkjqcmgev9p1d2m0kmb0p53s94
//videoAttr['streamName'] =  "qwerty";
//CommentFadeDelay = 60;
		//this.addEventListener(MouseEvent.CLICK, mouseClick);
	
		}

		Utils.clrChilds(this);
		_skin =  Utils.takeLinkage('skin_cont') as Sprite;

		showLink = _skin['showLink'];
		showLink.visible = false;
		related_cont = _skin['related_cont'];
		related_cont.visible = false;

		comment_cont = _skin['comment_cont'];
		comment_cont.visible = false;

		_skin['crop_res'].visible = false;
		_skin['crop_btn_cont']['crop_done_btn'].visible = false;
		this.addChild(_skin);

		
		addVideoPlayer();
		_cropControl = new CropControl(vdp2.width, vdp2.height);
/*
		_skin['video2'].addEventListener(MouseEvent.MOUSE_MOVE, handleMove, false, 0, true);
		_skin['playBox'].addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
		_skin['playBox'].addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
		tolltip = new Tolltip(this);
		embedUI = new EmbedUI(this);

*/

		this.addEventListener(MouseEvent.CLICK, mouseClick);
		related_cont['images'].addEventListener(MouseEvent.MOUSE_OVER, rOver, false, 0, true);
		related_cont['images'].addEventListener(MouseEvent.MOUSE_OUT, rOut, false, 0, true);

		var st:String = infoServer + '?vid='+vid;
		getJSONFile(st);
		
		isInit = true;
	}

	public function delVideoPlayer():void {
		if(vdp2) {
			vdp2.removeEventListener('VIDEO_BUFFER_FULL', checkFull);
			vdp2.removeEventListener('VIDEO_END', checkEnd);
			vdp2.removeEventListener('SHOW_LINK', show_link);
			vdp2.removeEventListener('CHK_COMMENT', chk_comment);
			vdp2.desctructor();
		}
		vdp2 = null;
	}

	public function addVideoPlayer(tp:String = 'LQ'):void {
		if(vdp2) delVideoPlayer();
		//videoAttr['videoURL'] = videoAttr['videoURL' + tp];
		if(videoAttr['type'] == 'file') {
			videoAttr['videoURL'] = videoURL;
		}

		vdp2 = new VideoPlayerRTMP(videoAttr);
		vdp2.wStageWidth = this.stage.fullScreenWidth;
		vdp2.hStageHeight = this.stage.fullScreenHeight;

		vdp2.addEventListener('VIDEO_BUFFER_FULL', checkFull, false, 0, true);
		vdp2.addEventListener('VIDEO_END', checkEnd, false, 0, true);
		vdp2.addEventListener('SHOW_LINK', show_link, false, 0, true);
		vdp2.addEventListener('CHK_COMMENT', chk_comment, false, 0, true);

		_skin['video2']['video_obj'].addChild(vdp2);
	}

	private function show_link(e:Event = null):void {
		if(!vdp2 || !vdp2.stream) return;
		var st:String = pageURL + '?t=' + vdp2.stream.time;
		showLink['page_link'].text = st;
		System.setClipboard(st);
		showLink.visible = true;
		fm.setFocus(showLink['page_link']);
		showLink['page_link'].setSelection(0, st.length);
//trace(">> show_link: ", pageURL,  e);
	}

	private function cropCMD():void {
		if(_cropControl.parent) {
			_skin['crop_cont'].removeChild(_cropControl);
			//vdp2.playMe();
			_skin['crop_btn_cont']['crop_done_btn'].visible = false;
		} else {
			vdp2.pauseMe();
			_skin['crop_btn_cont']['crop_done_btn'].visible = true;
			
			_skin['crop_cont'].addChild(_cropControl);
		}
	}

	private function switchComment():void {
		_skin['crop_res'].visible = !_skin['crop_res'].visible;
		if(_skin['crop_res'].visible) {
			vdp2.pauseMe();
		} else {
			vdp2.playMe();
		}
	}

	private function sendComment():void {
		var ph:Object = {
			//'vid': vid
			'Comment[time]': vdp2.stream.time
			,'Comment[content]': _skin['crop_res']['crop_desc'].text
		};

		new URLLoaderQueue(commentServer, {
			'callback': urlResult
			,'type': 'POST'
			,'vars': ph
		});
		_skin['crop_res'].visible = false;

		if(!commentObj['arr']) commentObj['arr'] = [];
		commentObj['arr'].push({
			"time": ph['Comment[time]'],
			"content": ph['Comment[content]'],
			"author": "I am",
			"date": "today"
		});
		prp_comment(commentObj['arr']);
		vdp2.playMe();
		_skin['crop_res']['crop_desc'].text = '';
	}

	private function chkResultComment(ph:Object = null):void {
//trace(">> chkResultComment : ", Utils.Dumper(ph));
		sendJScmd({'callBack':'CommentsUpdate'});
	}

	private function sendCropCMD():void {
		//vdp2.chkBimap();
		if(cropBMP) _skin['crop_res'].removeChild(cropBMP);
		cropBMP = null
		_skin['crop_res'].visible = false;

		var ph:Object = {
			'vid': vid
			,'time': vdp2.stream.time
			,'desc': _skin['crop_res']['crop_desc'].text
		};

		var pix:ByteArray = null;
		if(cropBMPdata) {
			cropCMD();
			var myEncoder:JPGEncoder = new JPGEncoder(85);
			pix = myEncoder.encode(vdp2.inBitmapData);

			var cropRect:Rectangle = _cropControl.getCropRect();
			//var inpBMD:BitmapData = new BitmapData(cropRect.width, cropRect.height);
			//inpBMD.copyPixels(vdp2.inBitmapData, cropRect, new Point());
			//inpBMD.copyPixels(vdp2.inBitmapData, cropRect, new Point());

			ph['x'] = cropRect.x;
			ph['y'] = cropRect.y;
			ph['width'] = cropRect.width;
			ph['height'] = cropRect.height;
		}
		
		uploadData(pix, ph);

//trace(">> sendCropCMD : ", Utils.Dumper(ph), cropRect, vdp2.inBitmapData);
	}

	private function uploadData(pixels:ByteArray, ph:Object = null):void {
		var mll:MultipartURLLoader = new MultipartURLLoader();
		mll.addEventListener(Event.COMPLETE, onUploadComplete, false, 0, true);
		for (var key:String in ph) {
			mll.addVariable(key, ph[key]);
		}
		if(pixels) mll.addFile(pixels, "file.jpg", "file1", 'image/png');
		mll.load(uploadServer);
		cropBMPdata = null;
	}
	
	private function onUploadComplete(event:Event):void {
		event.currentTarget.removeEventListener(event.type, arguments.callee);

		var st:String = event.currentTarget.loader.data;
//trace(">> onUploadComplete st: ", st, event);
		if(st.substr(0,1) != '{') return;
		var ph:Object = JSON.decode(st);
//trace(">> onUploadComplete 00: ", event, Utils.Dumper(ph));
		sendJScmd(ph);
	}

	private function mouseClick(e:MouseEvent):void {
		var tp:String = e.target.name;
trace(">> mouseClick 00: ", tp);
		switch(tp) {
			case 'end_comment':		// Удалить коммент
				end_comment(e.target);
				break;
			case 'crop':			// Начнем распознавание
				cropCMD();
				break;
			case 'comment_send':		// коммент из коммента
				comment_send(e.target.parent.name);
			case 'close_comment':		// Коментарий
//				_skin['crop_res'].visible = false;
//				break;
			case 'comment_btn':		// Коментарий
				switchComment();
				break;
			case 'crop_done_btn':	// Взять картинку
				cropBMPdata = vdp2.chkBimap();
				sendCropCMD();
				//switchComment();
				break;
			case 'comm_send':		// Коммент на сервер
				sendComment();
				break;
			case 'crop_send':		// Картинку на сервер
				sendCropCMD();
				break;
			case 'povtor':			// Повторить просмотр видео
				vdp2.videoPlay();
				break;
			case 'btn_related_left': // Похожие видео
			case 'btn_related_right':
				btn_related(tp);
				break;
			case 'btn_related_go':
				btn_related(e.target.parent.name);
				break;
			case 'btn_related_view':
				related_cont.visible = !related_cont.visible;
				break;
			case 'show_link':
				if(showLink.visible) showLink.visible = false;
				else show_link();
				break;
			case 'close_link':
				//hideLink();
				showLink.visible = false;
				break;
		}
	}

	private function hideLink():void {
		TweenMax.to(showLink, 1, {visible:false});
	}

	/**
	 * по MOUSE_MOVE
	private function handleMove(e:MouseEvent):void {
//trace(">> handleMove: ", e.target.name);
		//if(!_skin['playBox'].visible) _skin['playBox'].visible = true;
		hideAttr = chkTimer.currentCount + 2;
	}

	private function mouseOver(e:MouseEvent = null):void {
		skipHideAttr = true;
	}

	private function mouseOut(e:MouseEvent = null):void {
//trace(">> mouseOver: ", e.target.name);
		skipHideAttr = false;
	}
	 */

	private function checkFull(e:Event):void {
		//trace('checkFull : ' ,e);
	}

	private function checkEnd(e:Event):void {
		if(!vdp2.duration || !relatedData) return;
trace('checkEnd : ' ,e);
		related_cont.visible = true;

	}

/*
	private function onObjFinishTween(dObj:Object):void {
		//_skin['playBox'].visible = false;
		vdp2.resizeVideo();
		//_skin['perAttr'].visible = false;
	}
*/
	/**
	 * Запросы к контейнеру
	*/
	public function sendJScmd(inp:Object = null):void {
//trace('sendJScmd : ', Utils.Dumper(inp));

		if(!inp || !ExternalInterface.available) return;
		var st:String = inp['callBack'] || 'CapturePopup'; 
		var ph:Object = inp; 
		ph['objectID'] = ExternalInterface.objectID;
// mark_id
		ExternalInterface.call(st, ph); 
	}

	/**
	* Получить JSON файл
	*/
	private function getJSONFile(url:String = 'mcl/1.js', inp:Object = null):void {
		var ph:Object = (inp ? inp : {});
		ph['callback'] = urlResult;
//trace('getJSONFile : ', url ,Utils.Dumper(ph));
		new URLLoaderQueue(url, ph);
	}
	/**
	 * Обработчик результата FileLoader
	*/
	private function urlResult(status:String, ldr:Object):void {
		var ph:Object = {};
//trace('urlResult ', status, ldr.file, commentServer)
		switch(status) {
			case 'onComplete':	// файл удачно загружен
//trace('urlResult 1 ', status, ldr.data)
				if(ldr.file.match(commentServer)) {
					chkResultComment();
					return;
				}
				if(!ldr.data) return;
				if(ldr.data.substr(0,1) != '{') return;
				ph = JSON.decode(ldr.data);
				if(ldr.file.match(infoServer)) chkResult(ph);
				break;
			case 'IOError':			// ошибка при загрузке файла
			case 'SecurityError':	// ошибка безопасности при загрузке файла
				break;
		}
	}

	private function chkResult(inp:Object = null):void {
//trace('chkResult : ', Utils.Dumper(inp));
		related_cont['title'].visible = false;
		relatedData = inp['related'];
		Utils.clrChilds(related_cont['images']);
		for (var i:int=0; i<relatedData.length; i++) {
			var ph:Object = relatedData[i];
			var ttk:Object = Utils.takeLinkage('related_ttk') as Sprite;
			var st:String = sPrefix + ph['image'];
			//ttk['scaleX'] = ttk['scaleY'] = 0.5;
		ttk['width'] = 90;
		ttk['height'] = 72;
			ttk['x'] = 50 + i*dxPos;
			ttk['y'] = 46;
			ttk['name'] = 'r_'+i;
			ttk['image'].mouseEnabled = false;
			ttk['image'].mouseChildren = false;
			ttk['image'].addChild(new FileLoader(st));

			//st = ph['title'] + ' ' + vdp2.setTimeStr(ph['duration']);
			//ttk['title'].htmlText = st;
			ttk['item_cur'].visible = false;

			related_cont['images'].addChild(ttk);
		}
		imagesPosMax = 688 - related_cont['images'].width;
		imagesPos = related_cont['images'].x;

		prp_comment(inp['comments']);
	}

// Похожие видео
	private function btn_related(tp:String = ''):void {
		var st:String = '';
//trace('btn_related : ', tp, imagesPosMax);
		var ph:Object = null;
		var pos:int = imagesPos;
		if(tp.match(/^r_(\d+)/)) {
			st = tp.replace(/^r_/, '');
			ph = relatedData[int(st)];
//trace('btn_related1 : ', ph['link']);
			st = sPrefix + ph['link'];
			Utils.openURLtab(st, '_self');
			return;
		} else if(tp == 'btn_related_left') {
			pos += dxPos*7;
		} else if(tp == 'btn_related_right') {
			pos -= dxPos*7;
		}

		if(pos > imagesPosMin) pos = imagesPosMin;
		else if(pos < imagesPosMax) pos = imagesPosMax;
		if(imagesPos == int(pos)) return;
		imagesPos = int(pos);
		var obj:Object = related_cont['images'];
		TweenMax.killTweensOf(obj);
		obj.filters = null;
		TweenMax.to(obj, 0.5, {'x':imagesPos, ease:Linear.easeOut});
		TweenMax.from(obj, 0.5, {blurFilter:{blurX:40}, ease:Linear.easeOut});

		//related_cont['images'].x = imagesPos;
	}

	private function rOver(e:MouseEvent = null):void {
		var ttk:Object = e.target.parent;
		if(!ttk.name.match(/^r_/)) return;
		ttk['item_cur'].visible = true;

		ttk['width'] = 150;
		ttk['height'] = 100;
		related_cont['images'].setChildIndex(ttk, related_cont['images'].numChildren - 1);
		var point1:Point = new Point(ttk.x, ttk.y);
		point1 = related_cont['images'].localToGlobal(point1);
		prevPos = 0;
		if(point1.x < 75) {
			prevPos = ttk.x;
			ttk.x = 75 - related_cont['images'].x + 20;
		} else if(point1.x > 600) {
			prevPos = ttk.x;
			ttk.x = 600 - related_cont['images'].x + 20;
		}

		var st:String = ttk.name.replace(/^r_/, '');
		var ph:Object = relatedData[int(st)];
		if(ph) {
			st = '<b>'+ph['title'] + ' ' + vdp2.setTimeStr(ph['duration']) + '</b>';

			//var point1:Point = new Point(ttk.x, ttk.y);

			related_cont['title'].x = point1.x - 100;
			related_cont['title'].htmlText = st;
			related_cont['title'].visible = true;
		}
//trace(">> rOver: ", ph);
	
	}

	private function rOut(e:MouseEvent = null):void {
//trace(">> rOut: ", e.target.parent.name);
		var ttk:Object = e.target.parent;
		if(!ttk.name.match(/^r_/)) return;
		ttk['width'] = 90;
		ttk['height'] = 72;
		if(prevPos) ttk.x = prevPos;

		related_cont['title'].visible = false;
		ttk['item_cur'].visible = false;
	}

// Просмотр комментариев comment_cont
	private function comment_send(st:String = ''):void {
trace(">> comment_send: ", st);
	}

	private function add_comment(nm:int = 0):void {
		var arr:Array = commentObj['arr'] || [];
		if(nm >= arr.length) return;
		var ph:Object = arr[nm];
		if(!ph || ph['_del'] || !ph['_sprite']) return;
		var obj:Object = ph['_sprite'];
		var hh:int = comment_cont['items'].height;
		var cnt:int = comment_cont['items'].numChildren;
		hh += (cnt ? 2 :0);
		obj['y'] = -hh - obj.height;
		comment_cont['items'].addChild(obj);
	}
	private function remove_comment(nm:int = 0, flag:Boolean = false):void {
		var ph:Object = commentObj['arr'][nm];
		var pt:Object = ph['_sprite'];
		var hh:int = pt['height'] + 2;
		if(flag) ph['_del'] = 1;
//trace('btn_related : ', pt.parent.name);
		if(pt.parent) pt.parent.removeChild(pt);
		tween_comment(nm, hh);
	}
	private function tween_comment(nm:int = 0, hh:int = 0):void {
		var arr:Array = commentObj['arr'] || [];
		var ph:Object = null;
		var obj:Object = null;
		var ypos:int = 0;
		var i:int = 0;
		for (i=nm; i<arr.length; i++) {
			ph = arr[i];
			if(ph['_del']) continue;
			obj = ph['_sprite'];
			ypos = obj['y'] + hh;
			TweenMax.killTweensOf(obj);
			//obj.filters = null;
			TweenMax.to(obj, 0.5, {'y':ypos, ease:Bounce.easeOut});
			//TweenMax.from(obj, 0.5, {blurFilter:{blurX:40}, ease:Linear.easeOut});
		}
	}

	private function end_comment(pt:Object):void {
//trace('btn_related : ', pt.parent.name);
		var nm:int = int(pt.parent.name) || 0;
		remove_comment(nm, true);
	}

	private function sortTime(itemA:Object, itemB:Object):int {
		if (itemA['_time'] > itemB['_time']) {
			return 1;
		} else if (itemA['_time'] < itemB['_time']) {
			return -1;
		} else {
			return 0;
		}
	}

	private function prp_comment(inp:Array = null):void {
/*
inp = [
	{				
		"time": "5.280",
		"content": "Я нашел <img src='http://russianbrides.com.au/jpeg/w/1/22030_1a.jpg'> на видео <font color='#ff0000'>ccdd Я нашел </font>на видео re44 Я на<br>ше<br>л на видео re44 Я нашел на видео re44 Я нашел на видео re44 Я нашел на видео re44 Я нашел на видео re44 Я нашел на в<b>идео re44 Я</b> нашел на видео re44 ",
		"author": "guest-test",
		"date": "March 3, 2011 at 11:11 am"
	},{				
		"time": "3.280",
		"content": "Я нашел на видео ",
		"author": "guest-test",
		"date": "March 3, 2011 at 11:11 am"
	},{				
		"time": "8.480",
		"content": "Я нашел на видео fdgfdg t5t5",
		"author": "guest-test",
		"date": "March 3, 2011 at 11:13 am"
	},{				
		"time": "10.780",
		"content": "Я нашел на видео",
		"author": "guest-test",
		"date": "March 3, 2011 at 11:42 am"
	}
];
*/	
		if(!inp) inp = [];
		var i:int = 0;
		var st:String = '';
		var ph:Object = null;
		for (i=0; i<inp.length; i++) {
			ph = inp[i];
			//inp[i]['_time'] = int(inp[i]['time']);
			ph['_time'] = int(ph['time']);
			ph['_end'] = CommentFadeDelay + ph['_time'];
		}

		commentObj['arr'] = inp.sort(sortTime);

		var arr:Array = commentObj['arr'] || [];
//trace(">> btn_comment: ", Utils.Dumper(arr));
		Utils.clrChilds(comment_cont['items']);
		comment_cont.visible = true;
		var ypos:int = 0;
		for (i=0; i<arr.length; i++) {
			ph = arr[i];
			if(ph['_del']) continue;
			var ttk:Object = Utils.takeLinkage('show_comment_ttk') as Sprite;
			st = String(i);
			ttk['name'] = st;
			st = '' + ph['author'] + ':';
			ttk['author'].htmlText = st;

//ttk['comment_send'].visible = false;

			st = '' + ph['content'];
			ttk['content'].htmlText = st;
			var th:int = ttk['content'].textHeight;
			ttk['content'].height = th + 5;
			th += 26;
ttk['comment_send'].y = th;
			th += 30;
			ttk['bg'].height = th ;
			th += 2;
			ypos -= th
			ph['_sprite'] = ttk;
		}
	}

	private function chk_comment(e:Event):void {
//trace('chk_comment : ' ,e);
		if(!vdp2 || !vdp2.stream) return;
		var streamTime:int = vdp2.stream.time;

		var arr:Array = commentObj['arr'] || [];
//trace(">> btn_comment: ", Utils.Dumper(arr));
		for (var i:int = 0; i<arr.length; i++) {
			var ph:Object = arr[i];
			if(ph['_del']) continue;
			var obj:Object = ph['_sprite'];
			var vTime:Boolean = (streamTime > ph['_time'] && streamTime < ph['_end'] ? true : false);
			if(vTime && !obj.parent) add_comment(i);
			else if(!vTime && obj.parent) remove_comment(i);
		}
	}
}
}
