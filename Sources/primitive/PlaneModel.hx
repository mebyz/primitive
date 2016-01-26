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
	public var shaders : Dynamic;
	public var shader1 : Dynamic;
	public var shader2 : Dynamic;

	public function new(heightmap :Array<Int>,idx,idy, params : Dynamic) {

		var shader1 = {f:Shaders.simple_frag,v:Shaders.simple_vert};
		var shader2 = {f:Shaders.green_frag,v:Shaders.green_vert};
		var shaders = [shader1,shader2];

		var pr = new Primitive('heightmap', {w:params.w,h: params.h,x: params.x,y: params.y,heights:heightmap,idx:idx,idy:idy});
		st  = pr.getVertexStructure();
		idb = pr.getIndexBuffer();
		vtb = pr.getVertexBuffer();

        pipeline = new PipelineState();
		pipeline.inputLayout = [st];

		pipeline.fragmentShader = shader1.f;
		pipeline.vertexShader = shader1.v;
		pipeline.depthWrite = true;
        pipeline.depthMode = CompareMode.Less;
		pipeline.compile();

		mvpID = pipeline.getConstantLocation("MVP");
	}
	public function drawPlane(frame:Framebuffer, mvp:FastMatrix4) {	
		var g = frame.g4;
		g.setPipeline(pipeline);
		g.setVertexBuffer(vtb);
		g.setIndexBuffer(idb);
		// Get a handle for texture sample
		var sand = pipeline.getTextureUnit("sand");
		var image = Assets.images.sand;
		g.setTexture(sand, image);
		var stone = pipeline.getTextureUnit("stone");
		var image2 = Assets.images.stone;
		g.setTexture(stone, image2);
		var grass = pipeline.getTextureUnit("grass");
		var image3 = Assets.images.grass;
		g.setTexture(grass, image3);
		g.setMatrix(mvpID, mvp);
		g.drawIndexedVertices();
	}
}
