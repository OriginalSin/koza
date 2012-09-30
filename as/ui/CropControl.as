package ui {
//	import fl.controls.Button;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import flash.ui.Mouse;
	
	public class CropControl extends Sprite
	{
		// ------- Constants -------
		private var init_width:Number = 50;
		private var init_height:Number = 50;
		private static const BUTTON_SIZE:Number = 4;
		private static const HALF_BUTTON_SIZE:Number = BUTTON_SIZE / 2;
		private static const MIN_SIZE:Number = 30;
		
		
		// ------- Child Controls -------
		private var _tl:Sprite;
		private var _tr:Sprite;
		private var _bl:Sprite;
		private var _br:Sprite;
		private var _center:Sprite;
		
		private var _cursor_move:cursor_move = new cursor_move();
		private var _cursor_resize:cursor_resize = new cursor_resize();

		
		// ------- Private Properties -------
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _cropRect:Rectangle;
		private var _currentBtn:Object;
		
		// ------- Constructor -------
		public function CropControl(maxWidth:Number, maxHeight:Number)
		{
			addEventListener(Event.ADDED, setupChildren);
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			init_width = maxWidth / 2;
			init_height = maxHeight / 2;
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDrag);
			_cursor_move.visible = 
			_cursor_resize.visible = 
			_cursor_move.mouseChildren = 
			_cursor_resize.mouseChildren = 
			_cursor_move.mouseEnabled = 
			_cursor_resize.mouseEnabled = false;
			addChild(_cursor_move);
			addChild(_cursor_resize);
			//this.addEventListener(MouseEvent.MOUSE_MOVE, chkCursor);
		}

		private function chkCursor(e:MouseEvent):void
		{
			if(_tl.hitTestPoint(e.stageX, e.stageY, true)
				|| _tr.hitTestPoint(e.stageX, e.stageY, true)
				|| _bl.hitTestPoint(e.stageX, e.stageY, true)
				|| _br.hitTestPoint(e.stageX, e.stageY, true)
				) {
				Mouse.hide();
				_cursor_move.visible = false;
				_cursor_resize.visible = true;
				_cursor_resize.x = e.stageX;
				_cursor_resize.y = e.stageY;
			} else if(_center.hitTestPoint(e.stageX, e.stageY, true)) {
				Mouse.hide();
				_cursor_resize.visible = false;
				_cursor_move.visible = true;
				_cursor_move.x = e.stageX;
				_cursor_move.y = e.stageY;
			} else {
				_cursor_move.visible = false;
				_cursor_resize.visible = false;
				Mouse.show();
			}
		}
		
		
		// ------- Public Properties -------
		
		
		// ------- Public Methods -------
		public function getCropRect():Rectangle
		{
			return _cropRect.clone();
		}
		
		
		public function resetUI():void
		{
			var initX:Number = (_maxWidth - init_width) / 2;
			var initY:Number = (_maxHeight - init_height) / 2;
			
			_cropRect.x = initX;
			_cropRect.y = initY;
			_cropRect.width = init_width;
			_cropRect.height = init_height;
			
			updateUI();
		}
		
		
		// ------- Protected Methods -------
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			var initX:Number = (_maxWidth - init_width) / 2;
			var initY:Number = (_maxHeight - init_height) / 2;
			
			_cropRect = new Rectangle(initX, initY, init_width, init_height);
			
			// Create and add the buttons
			_center = new Sprite();
			_center.buttonMode = true;
			addChild(_center);

			_tl = new Sprite();
			initButton(_tl);
			
			_tr = new Sprite();
			initButton(_tr);
			
			_bl = new Sprite();
			initButton(_bl);
			
			_br = new Sprite();
			initButton(_br);

			updateUI();
		}

		private function initCenter(circle1:Sprite):void
		{

			circle1.graphics.drawCircle(BUTTON_SIZE/2, BUTTON_SIZE/2, BUTTON_SIZE);
			//circle1.graphics.drawCircle(0, 0, BUTTON_SIZE);
			circle1.alpha = 0.5;
			circle1.buttonMode = true;
			circle1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(circle1);
/*
			btn.label = "";
			btn.width = BUTTON_SIZE;
			btn.height = BUTTON_SIZE;
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(btn);
*/
		}

		
private var dragFlag:Boolean = false;
private var posX:int = 0;
private var posY:int = 0;
private var posXcont:int = 0;
private var posYcont:int = 0;
		
		private function mouseDownDrag(event:MouseEvent):void
		{
			posX = event.stageX;
			posY = event.stageY;
			posXcont = _cropRect.x;
			posYcont = _cropRect.y;
			if(!_cropRect.contains(event.localX, event.localY)) return;
			dragFlag = true;
			mouseDownHandler(event);
		}

		private function mouseDownHandler(event:MouseEvent):void
		{

			_currentBtn = event.target;
			
			addEventListener(Event.RENDER, renderHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var invalid:Boolean = false;
//trace(">> mouseDownHandler: ", event, event.target);
			if(dragFlag) {
				_cropRect.x = posXcont + (event.stageX - posX);
				_cropRect.y = posYcont + (event.stageY - posY);
				invalid = true;
			} else {
				var tempRect:Rectangle = _cropRect.clone();
				
				switch (_currentBtn)
				{
					case _tl:
						tempRect.left = mouseX;
						tempRect.top = mouseY;
						break;
					case _tr:
						tempRect.right = mouseX;
						tempRect.top = mouseY;
						break;
					case _bl:
						tempRect.left = mouseX;
						tempRect.bottom = mouseY;
						break;
					case _br:
						tempRect.right = mouseX;
						tempRect.bottom = mouseY;
						break;
				}
				
				if (tempRect.left < 0)
				{
					tempRect.left = 0;
				}
				if (tempRect.right > _maxWidth)
				{
					tempRect.right = _maxWidth;
				}
				if (tempRect.top < 0)
				{
					tempRect.top = 0;
				}
				if (tempRect.bottom > _maxHeight)
				{
					tempRect.bottom = _maxHeight;
				}
				
				if (tempRect.width >= MIN_SIZE)
				{
					_cropRect.left = tempRect.left;
					_cropRect.right = tempRect.right;
					invalid = true;
				}
				
				if (tempRect.height >= MIN_SIZE)
				{
					_cropRect.top = tempRect.top;
					_cropRect.bottom = tempRect.bottom;
					invalid = true;
				}
			}
			
			if (invalid)
			{
				stage.invalidate();
			}
		}
		
		
		private function renderHandler(event:Event):void
		{
			updateUI();
		}
		
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			_currentBtn = null;
			dragFlag = false;
			
			removeEventListener(Event.RENDER, renderHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		// ------- Private Methods -------
		private function initButton(circle1:Sprite):void
		{
			circle1.graphics.beginFill(0xFFCC00);
			circle1.graphics.drawCircle(BUTTON_SIZE/2, BUTTON_SIZE/2, BUTTON_SIZE);
			//circle1.graphics.drawCircle(0, 0, BUTTON_SIZE);
			circle1.alpha = 0.5;
			circle1.buttonMode = true;
			circle1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(circle1);
/*
			btn.label = "";
			btn.width = BUTTON_SIZE;
			btn.height = BUTTON_SIZE;
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(btn);
*/
		}
		
		
		private function updateUI():void
		{
			positionButtons();
			drawMatte();
		}
		
		
		private function positionButtons():void
		{
			_tl.x = _cropRect.left - HALF_BUTTON_SIZE;
			_tl.y = _cropRect.top - HALF_BUTTON_SIZE;
			_tr.x = _cropRect.right - HALF_BUTTON_SIZE;
			_tr.y = _cropRect.top - HALF_BUTTON_SIZE;
			_bl.x = _cropRect.left - HALF_BUTTON_SIZE;
			_bl.y = _cropRect.bottom - HALF_BUTTON_SIZE;
			_br.x = _cropRect.right - HALF_BUTTON_SIZE;
			_br.y = _cropRect.bottom - HALF_BUTTON_SIZE;
		}
		
		
		private function drawMatte():void
		{
			var fill:uint = 0x000000;
			var fillAlpha:Number = .5;
			
			var g:Graphics = graphics;
			g.clear();
			
			// draw the gray matte
			g.beginFill(fill, fillAlpha);
			g.drawRect(0, 0, _maxWidth, _cropRect.top);
			g.drawRect(0, _cropRect.top, _cropRect.left, _cropRect.height);
			g.drawRect(_cropRect.right, _cropRect.top, (_maxWidth - _cropRect.right), _cropRect.height);
			g.drawRect(0, _cropRect.bottom, _maxWidth, (_maxHeight - _cropRect.bottom));
			g.endFill();
			
			// draw a transparent rectangle over the crop area to serve as a mouse target
			g.beginFill(fill, 0);
			g.lineStyle(2, 0xFF0000);

			g.drawRect(_cropRect.x, _cropRect.y, _cropRect.width, _cropRect.height);
			g.endFill();

			_center.graphics.clear();
			_center.graphics.beginFill(0xffffff, 0);
			_center.graphics.drawRect(_cropRect.x, _cropRect.y, _cropRect.width, _cropRect.height);
			_center.graphics.endFill();

		}
	}
}