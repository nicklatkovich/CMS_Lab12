package
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Plane;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vermilliest
	 */
	public class Main extends Sprite
	{
		
		private var camera:Camera3D;
		private var plane:Plane;
		private var rootContainer:Object3DContainer;
		
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
			camera.render();
		}
		
		public function initScene():void
		{
			rootContainer = new Object3DContainer();
			
			camera = new Camera3D();
			camera.y = -800;
			camera.z = 400;
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			camera.rotationX = -120 * Math.PI / 180;
			addChild(camera.view);
			addChild(camera.diagram);
			rootContainer.addChild(camera);
			
			plane = new Plane(500, 500);
			//plane.rotationX = Math.PI / 2.0;
			plane.setMaterialToAllFaces(new FillMaterial(0x77FF00, 1, 2, 0));
			rootContainer.addChild(plane);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	
	}

}