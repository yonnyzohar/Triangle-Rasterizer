package {
	import flash.geom.Point;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;

	public class Main extends MovieClip {

		var p0: Object = {
			x: 200,
			y: 10,
			u: 0.5,
			v: 0
		};
		var p1: Object = {
			x: 30,
			y: 150,
			u: 0,
			v: .001
		};
		var p2: Object = {
			x: 300,
			y: 350,
			u: .5,
			v: .5
		};

		var ctrlPo: CtrlPoint = new CtrlPoint();
		var ctrlP1: CtrlPoint = new CtrlPoint();
		var ctrlP2: CtrlPoint = new CtrlPoint();

		var currCtrl: CtrlPoint;

		var bd: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false);
		var bmp: Bitmap = new Bitmap(bd);

		var mona: Mona = new Mona();
		var texW: Number = mona.width;
		var texH: Number = mona.height;
		
		var points: Array;
		var g;
		
		var mc:MovieClip = new MovieClip();


		public function Main() {
			stage.addChild(bmp);
			stage.addChild(mc);
			stage.addChild(ctrlPo);
			stage.addChild(ctrlP1);
			stage.addChild(ctrlP2);
			

			ctrlPo.point = p0;
			ctrlP1.point = p1;
			ctrlP2.point = p2;

			ctrlPo.x = p0.x;
			ctrlPo.y = p0.y;

			ctrlP1.x = p1.x;
			ctrlP1.y = p1.y;

			ctrlP2.x = p2.x;
			ctrlP2.y = p2.y;

			ctrlPo.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			ctrlP1.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			ctrlP2.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(Event.ENTER_FRAME, update);

			points = [p0, p1, p2];

			g = mc.graphics;
			mc.mouseEnabled = false;

			bd.fillRect(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 0x000000);
			sortPoints();
			fillTriangle();

		}



		function onUp(e: MouseEvent): void {
			currCtrl = null;
		}

		function onDown(e: MouseEvent): void {
			currCtrl = CtrlPoint(e.target);
		}

		function update(e: Event): void {
			if (currCtrl) {
				
				var point: Object = currCtrl.point;
				point.x = currCtrl.x = stage.mouseX;
				point.y = currCtrl.y = stage.mouseY;
				bd.fillRect(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 0x000000);
				sortPoints();
				fillTriangle();
			}
		}




		function sortPoints(): void {
			var aux: Object;
			//if point 0 is lower than point 1, then point 1 needs to be 0
			if (points[0].y > points[1].y) {
				aux = points[0];
				points[0] = points[1];
				points[1] = aux;
			}
			//if point 0 is lower than point 2, then point 2 needs to be 0
			if (points[0].y > points[2].y) {
				aux = points[0];
				points[0] = points[2];
				points[2] = aux;
			}
			//if point 1 is lower than point 2, then point 2 needs to be 1
			if (points[1].y > points[2].y) {
				aux = points[1];
				points[1] = points[2];
				points[2] = aux;
			}
		}

		function fillTriangle(): void {


			var p0x: Number = points[0].x;
			var p0y: Number = points[0].y;

			var p0u: Number = points[0].u;
			var p0v: Number = points[0].v;

			var p1x: Number = points[1].x;
			var p1y: Number = points[1].y;

			var p1u: Number = points[1].u;
			var p1v: Number = points[1].v;

			var p2x: Number = points[2].x;
			var p2y: Number = points[2].y;

			var p2u: Number = points[2].u;
			var p2v: Number = points[2].v;
			
			
			

			//each triangle is split in 2 to make calculations easier.
			//first we do the top part, then the bottom part
			if (p0y < p1y) {


				var side1Width: Number = (p1x - p0x);
				var side1Height: Number = (p1y - p0y);

				//slope from top to first side - when y moves by 1, how much does x move by?
				var slope1: Number = side1Width / side1Height;

				var side2Width: Number = (p2x - p0x);
				var side2Height: Number = (p2y - p0y);
				//slope from top to second side - when y moves by 1, how much does x move by?
				var slope2: Number = side2Width / side2Height;


				//u length - the width of change in percentage on the u (x) axis
				var side1uWidth: Number = (p1u - p0u);
				//v height - the height of change in percentage on the v (y) axis
				var side1vHeight: Number = (p1v - p0v);

				//u length - the width of change in percentage on the u (x) axis
				var side2uWidth: Number = (p2u - p0u);

				//u length - the width of change in percentage on the u (x) axis
				var side2vHeight: Number = (p2v - p0v);

				for (var i: int = 0; i <= side1Height; i++) {

					var _y: Number = p0y + i; // when y grows by 1
					var startX: int = p0x + i * slope1; // start x grows by initial x + (i * slope1)
					var endX: int = p0x + i * slope2; // end x grows by initial x + (i * slope2)

					//u start and v start
					var side1Per:Number = (i / side1Height);
					var startU: Number = p0u + (side1Per * side1uWidth);
					var startV: Number = p0v + (side1Per * side1vHeight);

					//u end and v end
					var side2Per:Number = i / side2Height;
					var endU: Number = p0u + (side2Per * side2uWidth);
					var endV: Number = p0v + (side2Per * side2vHeight);


					//if start is greater than and, swap the,
					if (startX > endX) {
						var aux: Number = startX;
						startX = endX;
						endX = aux;

						//and also swap uv
						aux = startU;
						startU = endU;
						endU = aux;

						aux = startV;
						startV = endV;
						endV = aux;
					}


					if (endX > startX) {

						var triangleCurrWidth: Number = endX - startX;

						//this is the initial u which we will increment
						var u: Number = startU * texW;

						//this is the increment step on the u axis
						var ustep: Number = ((endU - startU) / triangleCurrWidth) * texW;

						//this is the initial v which we will increment
						var v: Number = startV * texH;
						//this is the increment step on the v axis
						var vstep: Number = ((endV - startV) / triangleCurrWidth) * texH;


						for (var j: int = 0; j <= triangleCurrWidth; j++) {
							var _x: int = startX + j;

							u += ustep;
							v += vstep;

							var pixel: uint = mona.getPixel(u, v);
							bd.setPixel(_x, _y, pixel);
							//g.lineTo(_x, _y);
						}
					}
				}
			}

			////
			//bottom part of the triangle
			if (p1y < p2y) {

				var side3Width: Number = (p2x - p1x);
				var side3Height: Number = (p2y - p1y);
				//slope from top to first side - when y moves by 1, how much does x move by?
				var slope3: Number = side3Width / side3Height;

				var side2Width: Number = (p2x - p0x);
				var side2Height: Number = (p2y - p0y);
				//slope from top to second side - when y moves by 1, how much does x move by?
				var slope2: Number = side2Width / side2Height;

				//this is the middle point on slope 2
				//the slope means - when we move y by 1, how much does x move by?
				//so if we start at the bottom and decrease the side3Height * the slope of side 2 we will get the start point
				var midPointSlope2: Number = p2x - (side3Height * slope2);
				
				//this is just for drawing the triangle, not part of the algorithm
				g.clear();
				g.lineStyle(1, 0xff0000);
				g.moveTo(p0x, p0y);
				g.lineTo(p1x, p1y);
				g.lineStyle(2, 0xffcc00);
				g.lineTo( midPointSlope2  , p1y);
				g.lineStyle(1, 0xff0000);
				g.lineTo(p0x, p0y);
				g.lineTo(p2x, p2y);
				g.lineTo(p1x, p1y);
				//

				//u length - the width of change in percentage on the u (x) axis
				var side3uWidth: Number = (p2u - p1u);
				//v height - the height of change in percentage on the v (y) axis
				var side3vHeight: Number = (p2v - p1v);

				//u length - the width of change in percentage on the u (x) axis
				var side2uWidth: Number = (p2u - p0u);

				//u length - the width of change in percentage on the u (x) axis
				var side2vHeight: Number = (p2v - p0v);

				for (var i: int = 0; i <= side3Height; i++) {
					var startX: int = p1x + i * slope3;
					var endX: int = midPointSlope2 + i * slope2;
					var _y: Number = p1y + i;

					//u start and v start
					var side3Per:Number = (i / side3Height);
					var startU: Number = p1u + (side3Per * side3uWidth);
					var startV: Number = p1v + (side3Per * side3vHeight);

					//u nd and v end
					var side2Per:Number = (_y - p0y) / side2Height;
					var endU: Number = p0u + (side2Per * side2uWidth);
					var endV: Number = p0v + (side2Per * side2vHeight);



					if (startX > endX) {
						var aux: Number = startX;
						startX = endX;
						endX = aux;

						//and also swap uv
						aux = startU;
						startU = endU;
						endU = aux;

						aux = startV;
						startV = endV;
						endV = aux;
					}


					if (endX > startX) {
						var triangleCurrWidth: Number = endX - startX;

						var u: Number = startU * texW;
						//this is the increment on the u axis
						var ustep: Number = ((endU - startU) / triangleCurrWidth) * texW;
						var v: Number = startV * texH;
						//this is the increment on the v axis
						var vstep: Number = ((endV - startV) / triangleCurrWidth) * texH;

						for (var j: int = 0; j <= triangleCurrWidth; j++) {
							var _x: int = j + startX;
							u += ustep;
							v += vstep;

							var pixel: uint = mona.getPixel(u, v);
							bd.setPixel(_x, _y, pixel);
						}
					}
				}

			}
		}

	}

}