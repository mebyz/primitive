package primitive;

import kha.math.FastVector3;
import kha.math.Vector3;
import js.lib.Int16Array;
import kha.graphics4.DepthStencilFormat;
import kha.SystemImpl;
import js.html.webgl.Texture;
import kha.WebGLImage;
import kha.graphics5_.BlendingOperation;
import kha.graphics5_.BlendingFactor;
import kha.graphics5_.CullMode;
import haxe.Timer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.ConstantLocation;
import kha.Framebuffer;
import kha.math.FastMatrix4;
import kha.graphics4.CompareMode;
import kha.Shaders;
import kha.Assets;
import kha.graphics4.TextureUnit;
import primitive.GL;

class PlaneModel {

	public var st:VertexStructure;
	public var vtb:VertexBuffer;
	public var idb:IndexBuffer;
	public var pipeline:PipelineState;
	public var mvpID:ConstantLocation;
	public var camPosID:ConstantLocation;
	public var shader : Dynamic;
	public var timeLocation:ConstantLocation;

	static inline var TEXTURE0 : Int = 33984;
	static inline var TEXTURE_2D : Int = 3553;
	
	public function new(idx,idy, params : Dynamic) {

		var shader = {f:Shaders.ocean_frag,v:Shaders.ocean_vert};

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
		timeLocation = pipeline.getConstantLocation("time");
		camPosID = pipeline.getConstantLocation("camPos");
	}

	public function createWebGLImagefromWebglTExture(texture: Texture) : WebGLImage {
		var gl = SystemImpl.gl;
		var image = new WebGLImage(512,512,RGBA32,false,DepthStencilFormat.NoDepthAndStencil,1,true);
		image.texture = texture;
		return image;
	}

	public function drawPlane(frame:Framebuffer, mvp:FastMatrix4, renderTexture: Texture, camPos:FastVector3) {	
		if (mvp != null) {		
			var g = frame.g4;
			pipeline.blendSource = SourceAlpha;
			pipeline.blendDestination = DestinationAlpha;
			pipeline.blendOperation = BlendingOperation.Add;
			g.setPipeline(pipeline);
			g.setVertexBuffer(vtb);
			g.setIndexBuffer(idb);
			// Get a handle for texture sample
			var gl = SystemImpl.gl;

			var unit = pipeline.getTextureUnit("render_texture");
			g.setTextureWebGLImage(unit, createWebGLImagefromWebglTExture(renderTexture));

			var texture = pipeline.getTextureUnit("s_texture");
			var image = Assets.images.water;
			g.setTexture(texture, image);
			
			var texture = pipeline.getTextureUnit("s_normals");
			var image = Assets.images.waternormals;
			g.setTexture(texture, image);

			// gl.NEAREST is also allowed, instead of gl.LINEAR, as neither mipmap.
			SystemImpl.gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
			// Prevents s-coordinate wrapping (repeating).
			SystemImpl.gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			// Prevents t-coordinate wrapping (repeating).
			SystemImpl.gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);


			g.setMatrix(mvpID, mvp);

			g.setVector3(camPosID, camPos);
			g.drawIndexedVertices();
			g.setFloat(timeLocation, Timer.stamp());
		}
	}
}
