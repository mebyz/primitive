package primitive;

import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.ConstantLocation;
import kha.Framebuffer;
import kha.math.FastMatrix4;
import kha.graphics4.CompareMode;
import kha.Shaders;
import kha.Assets;

class PlaneModel {

	public var st:VertexStructure;
	public var vtb:VertexBuffer;
	public var idb:IndexBuffer;
	public var pipeline:PipelineState;
	public var mvpID:ConstantLocation;
	public var shader : Dynamic;

	public function new(idx,idy, params : Dynamic) {

		var shader = {f:Shaders.green_frag,v:Shaders.green_vert};

		var pr = new Primitive('plane', {w:params.w,h: params.h,x: params.x,y:params.y});
		st  = pr.getVertexStructure();
		idb = pr.getIndexBuffer();
		vtb = pr.getVertexBuffer();

        pipeline = new PipelineState();
		pipeline.inputLayout = [st];

		pipeline.fragmentShader = shader.f;
		pipeline.vertexShader = shader.v;
		pipeline.depthWrite = true;
        pipeline.depthMode = CompareMode.Less;
		pipeline.compile();

		mvpID = pipeline.getConstantLocation("MVP");
	}
	public function drawPlane(frame:Framebuffer, mvp:FastMatrix4) {	
		if (mvp != null) {		
			var g = frame.g4;
			g.setPipeline(pipeline);
			g.setVertexBuffer(vtb);
			g.setIndexBuffer(idb);
			// Get a handle for texture sample
			var texture = pipeline.getTextureUnit("texture");
			var image = Assets.images.water;
			g.setTexture(texture, image);
			g.setMatrix(mvpID, mvp);
			g.drawIndexedVertices();
		}
	}
}
