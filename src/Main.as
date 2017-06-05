package
{
	import alternativa.engine3d.containers.LODContainer;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Plane;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.KeyboardEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoaderDataFormat;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.text.engine.TextBlock;
	
	/**
	 * ...
	 * @author Vermilliest
	 */
	public class Main extends Sprite
	{
		
		private var traceY:Number = 0;
		
		private var camera:Camera3D;
		private var plane:Plane;
		private var rootContainer:Object3DContainer;
		
		private var loader3DS:URLLoader;
		private var head:Mesh;
		private var body:Mesh;
		private var gun:Mesh;
		private var tank:Object3DContainer = new Object3DContainer();
		private var headWithGun:Object3DContainer = new Object3DContainer();
		
		public var KeyWPressed:Boolean = false;
		public var KeySPressed:Boolean = false;
		public var KeyAPressed:Boolean = false;
		public var KeyDPressed:Boolean = false;
		public var KeyLeftPressed:Boolean = false;
		public var KeyRightPressed:Boolean = false;
		public var KeyUpPressed:Boolean = false;
		public var KeyDownPressed:Boolean = false;
		
		public var dir:Number = 0;
		public var camDir:Number = 0;
		public var headDir:Number = 0;
		
		public var headSpeed:Number = 0.02;
		public var camSpeed:Number = 0.04;
		
		public var speed:Number = 0;
		public var maxSpeed:Number = 5;
		public var speedAcc:Number = 0.01;
		public var gunDir:Number = 0;
		
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			initScene();
		}
		
		private function onEnterFrame(e:Event):void
		{
			dir += (KeyAPressed ? 0.02 : 0) - (KeyDPressed ? 0.02 : 0);
			camDir += (KeyLeftPressed ? camSpeed : 0) - (KeyRightPressed ? camSpeed : 0);
			if (camDir > headDir)
			{
				headDir += Math.min(camDir - headDir, headSpeed);
			}
			else
			{
				headDir -= Math.min(headDir - camDir, headSpeed);
			}
			body.rotationZ = dir;
			
			var tar:Number = (KeySPressed ? maxSpeed : 0) - (KeyWPressed ? maxSpeed : 0);
			if (tar > speed)
			{
				speed += Math.min(tar - speed, speedAcc * (tar == 0 ? 1 : 5));
			}
			else
			{
				speed -= Math.min(speed - tar, speedAcc * (tar == 0 ? 1 : 5));
			}

			gunDir += (KeyUpPressed ? 0.05 : 0) - (KeyDownPressed ? 0.05 : 0);
			gunDir = Math.min(Math.PI * 0.4, Math.max( -Math.PI * 0.1, gunDir));
			gun.rotationY = -gunDir - Math.PI / 2;
			
			tank.x += Math.cos(dir) * speed;
			tank.y += Math.sin(dir) * speed;
			
			camera.x = tank.x + Math.cos(camDir) * 160;
			camera.y = tank.y + Math.sin(camDir) * 160;
			camera.rotationZ = camDir + Math.PI / 2;
			headWithGun.rotationZ = headDir;
			camera.render();
		}
		
		public function initScene():void
		{
			rootContainer = new Object3DContainer();
			
			camera = new Camera3D();
			
			camera.y = -160;
			camera.z = 80;
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			camera.rotationX = -120 * Math.PI / 180;
			addChild(camera.view);
			addChild(camera.diagram);
			rootContainer.addChild(camera);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
			
			for (var i:Number = -3000; i < 3000; i += 500)
			{
				for (var j:Number = -3000; j < 3000; j += 500)
				{
					plane = new Plane(500, 500);
					plane.x = i;
					plane.y = j;
					//plane.rotationX = Math.PI / 2.0;
					plane.setMaterialToAllFaces(new FillMaterial(0x77FF00, 1, 1, 0));
					rootContainer.addChild(plane);
				}
			}
			
			loader3DS = new URLLoader();
			loader3DS.dataFormat = URLLoaderDataFormat.BINARY;
			loader3DS.addEventListener(Event.COMPLETE, onLoadingComplete);
			try
			{
				loader3DS.load(new URLRequest("TANK.3DS"));
			}
			catch (error:ArgumentError)
			{
				trace("An ArgumentError has occurred.");
			}
			catch (error:SecurityError)
			{
				trace("A SecurityError has occurred.");
			}
			catch (error:Error)
			{
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function OnKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 87: 
				KeyWPressed = true;
				break;
			case 65: 
				KeyAPressed = true;
				break;
			case 83: 
				KeySPressed = true;
				break;
			case 68: 
				KeyDPressed = true;
				break;
			case 37: 
				KeyLeftPressed = true;
				break;
			case 39: 
				KeyRightPressed = true;
				break;
			case 38: 
				KeyUpPressed = true;
				break;
			case 40: 
				KeyDownPressed = true;
				break;
			}
			//MyTrace(String(e.keyCode));
		}
		
		private function OnKeyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 87: 
				KeyWPressed = false;
				break;
			case 65: 
				KeyAPressed = false;
				break;
			case 83: 
				KeySPressed = false;
				break;
			case 68: 
				KeyDPressed = false;
				break;
			case 37: 
				KeyLeftPressed = false;
				break;
			case 39: 
				KeyRightPressed = false;
				break;
			case 38: 
				KeyUpPressed = false;
				break;
			case 40: 
				KeyDownPressed = false;
				break;

			}
		}
		
		private function onLoadingComplete(e:Event):void
		{
			var parser:Parser3DS = new Parser3DS();
			parser.parse((e.target as URLLoader).data);
			for (var i:int = 0; i < parser.objects.length; i++)
			{
				var mesh:Mesh = parser.objects[i] as Mesh;
				if (mesh != null)
				{
					if (mesh.name == "Head")
					{
						head = mesh;
						mesh.setMaterialToAllFaces(new FillMaterial(0xFF0000));
					}
					else if (mesh.name == "Gun")
					{
						gun = mesh;
						mesh.setMaterialToAllFaces(new FillMaterial(0x777700));
					}
					else if (mesh.name == "Body")
					{
						body = mesh;
						mesh.setMaterialToAllFaces(new FillMaterial(0x0000FF));
					}
					mesh.weldVertices();
					mesh.weldFaces();
				}
			}
			headWithGun = new Object3DContainer();
			if (gun != null)
			{
				headWithGun.addChild(gun);
			}
			if (head != null)
			{
				headWithGun.addChild(head);
			}
			tank = new Object3DContainer();
			if (body != null)
			{
				tank.addChild(body);
			}
			
			var textureLoader:Loader = new Loader();
			textureLoader.addEventListener(Event.COMPLETE, OnTextureLoaded);
			MyTrace("Start loading");
			try
			{
				textureLoader.load(new URLRequest("MATERIAL.png"));
			}
			catch (e:Error)
			{
				MyTrace(e.message);
			}
			
			//tank.addChild(snar);
			//tank.scaleX = tank.scaleY = tank.scaleZ = 0.2;
			tank.addChild(headWithGun);
			rootContainer.addChild(tank);
			//tank.rotationZ += -90 * Math.PI / 180;
			//isStart = true;
		}
		
		private function OnTextureLoaded(e:Event):void
		{
			//var info:Loader = e.target as Loader;
			//var bitmap:Bitmap = info.content as Bitmap;
			MyTrace("Loaded");
			var bitmapData:BitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			head.setMaterialToAllFaces(new TextureMaterial(bitmapData, true, true, 0, 1))
			gun.setMaterialToAllFaces(new TextureMaterial(bitmapData, true, true, 0, 1));
			body.setMaterialToAllFaces(new TextureMaterial(bitmapData, true, true, 0, 1));
		}
		
		private function MyTrace(s:String):void
		{
			var tb:TextField = new TextField();
			tb.text = s;
			tb.y = traceY;
			traceY += 16;
			addChild(tb);
		}
	
	}

}