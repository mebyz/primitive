# primitives

Create Primitives for use in your Kha project. Can be used directly as Kha library included in khafile.js.  

## Getting started
- Clone into 'your_kha_project/Libraries'
- Add 'project.addLibrary('primitive');' into khafile.js
``` hx

// in your project init

public function new() {

	var structure    : VertexStructure;
	var vertexbuffer : VertexBuffer;
	var indexbuffer  : IndexBuffer;

	///var myprimitive = new Primitive(/*type, params*/);
	var myplane = new Primitive('plane', { size : 10 });

	structure = pr.getVertexStructure();
	vertexbuffer = pr.getVertexBuffer();
	indexbuffer = pr.getIndexBuffer();

	//...
	//...
	pipeline.inputLayout = [structure];
	//...
	//...
}
//...
//...
// then in render()
public function render(frame:Framebuffer) {
    var g = frame.g2;
    g.begin();
    //...
	g.setPipeline(pipeline);
	g.setVertexBuffer(vertexbuffer);
	g.setIndexBuffer(indexbuffer);
    //...
    g.end();
    
}
```