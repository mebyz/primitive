package primitive;

import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;

class Shape {

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;

	public function new() {

	}

	public function getIndexBuffer() {
		return indexBuffer;
	}

	public function getVertexBuffer() {
		return vertexBuffer;
	}
	
	public function getVertexStructure() {
		var structure = new VertexStructure();
        structure.add("pos", VertexData.Float3);
        return structure;
    }
}