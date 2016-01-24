package primitive;

import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

class Plane extends Shape {

	//!TODO : clean this code. work in progress.
	public function new(size : Int = 10) {

		super();

		var v:Array<Float> = new Array();
		var ind:Array<Int> = new Array();

		for (i in 0...size) {

			for (j in 0...size) {

				v.push(-0.1*i);v.push(-0.1*j);v.push(0.0);
				v.push(0.1*i);v.push(-0.1*j);v.push(0.0);
				v.push(-0.1*i);v.push(0.1*j);v.push(0.0);
				v.push(0.1*i);v.push(0.1*j);v.push(0.0);

				ind.push((i*size+j)*4);
				ind.push((i*size+j)*4+1);
				ind.push((i*size+j)*4+2);

				ind.push((i*size+j)*4+1);
				ind.push((i*size+j)*4+2);
				ind.push((i*size+j)*4+3);

			}
		}

		var structure : VertexStructure = getVertexStructure();

		vertexBuffer = new VertexBuffer(
			Std.int(v.length / 3), // 3 floats per vertex
			structure, 
			Usage.StaticUsage 
		);
		
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, v[i]);
		}
		vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(
			ind.length, 
			Usage.StaticUsage 
		);
		
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = ind[i];
		}
		indexBuffer.unlock();
	}
}