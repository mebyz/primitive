package primitive;

import primitive.Primitive;
import primitive.Shape;
import primitive.Plane;

class Primitive {

	var s : Shape;

	public function new(shapeName : String, params : Dynamic) {
		
		switch shapeName {
		    case 'plane': {
		    	s = new Plane(params.size,[]);
		    }
		    case 'heightmap': {
		    	s = new Plane(params.size,params.heightmap);
		    }
		    case 'cube': {
		    	s = new Cube(params.x,params.y,params.z);
		    }
		    default: s = new Shape();
		}
			
	}

	public function getIndexBuffer() {
		return s.getIndexBuffer();
	}

	public function getVertexBuffer() {
		return s.getVertexBuffer();
	}
	
	public function getVertexStructure() {
		return s.getVertexStructure();
    }
}