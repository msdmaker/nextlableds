// import java.util.List;
// import java.util.HashMap;

// public class GraphMap{

// 	private HashMap<Integer, List<LEDStrip>> map = new HashMap();

// 	public GraphMap(){
// 		EdgeCube[] cubes = structure.cubes.cubes;
// 		List<LEDStrip> diagonals = structure.diagonals.strips;
// 		List<LEDStrip> vertex = new ArrayList();

// 		//Grab the centre vertex
// 		for(int i=0;i<8;++i){
// 			vertex.add(diagonals.get(i));
// 		}
// 		map.put(0, vertex);
// 		vertex = new ArrayList();

// 		int i = 0;
// 		// for(EdgeCube cube : cubes){
// 			vertex.add(cubes[0].vertex[0].strip[0]);
// 			vertex.add(cubes[0].vertex[0].strip[1]);
// 			vertex.add(cubes[0].vertex[0].strip[2]);
// 			vertex.add(diagonals.get(0));
// 			vertex.add(diagonals.get(8));
// 			map.put(1,vertex);
// 		// }

// 	}
// }

// public class Vertex implements LXFixture{
// 	public List<EdgeStrip> edges = new ArrayList();
// 	public HashMap<EdgeStrip, Vertex> adjacents = new HashMap();

// 	public Vertex(List<EdgeStrip> edges){
// 		this.edges = edges;
// 		for(EdgeStrip edge : edges){
// 			edge.assignVertex(this);
// 		}
// 	}

// 	public List<LXPoint> getPoints(){
// 		List<LXPoint> points = new ArrayList();
// 		for(EdgeStrip edge : edges){
// 			points.addAll(edge.getPoints());
// 		}
// 		return points;
// 	}
// }

// public class EdgeStrip implements LXFixture{
// 	public StripModel inner, outer;
// 	public List<Vertex> vertices = new ArrayList();

// 	public EdgeStrip(LEDStrip strip){
// 		this.inner = strip.strip_inner;
// 		this.outer = strip.strip_outer;
// 	}
// 	public void assignVertex(Vertex vertex){
// 		vertices.add(vertex);
// 	}
// 	public List<LXPoint> getPoints(){
// 		List<LXPoint> points = new ArrayList();
// 		points.addAll(inner.getPoints());
// 		points.addAll(outer.getPoints());
// 		return points;
// 	}
// }