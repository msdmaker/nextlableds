import heronarts.lx.LX;
import heronarts.lx.LXPattern;
import heronarts.lx.modulator.SawLFO;
import heronarts.lx.parameter.CompoundParameter;
import heronarts.lx.parameter.FunctionalParameter;

public class GroupSelector extends LXPattern {

    public final CompoundParameter b = 
                new CompoundParameter("Brt", 100, 100);

    public final CompoundParameter d_num = 
                new CompoundParameter("Diagonal",0,3);

    public final CompoundParameter c_num = 
                new CompoundParameter("Cube",0,6);

    public final CompoundParameter o_num = 
                new CompoundParameter("Output",0,35);

    public final CompoundParameter cv_num = 
                new CompoundParameter("CubeVert",0,3);

    public final CompoundParameter v_num = 
                new CompoundParameter("Vertex",0,27);


    public final BooleanParameter enableDiagonals =
                new BooleanParameter("Diag")
                .setDescription("Turn diagonals on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);

    public final BooleanParameter enableCubes =
                new BooleanParameter("Cube")
                .setDescription("Turn cubes on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);

    public final BooleanParameter enableOutputs =
                new BooleanParameter("Output")
                .setDescription("Turn outputs on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);
    public final BooleanParameter enableBots =
                new BooleanParameter("Makerbots")
                .setDescription("Turn makerbots on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);


    public final BooleanParameter enableSingleStrip =
                new BooleanParameter("Strip")
                .setDescription("Turn single strips on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);
    public final BooleanParameter enableVertex =
                new BooleanParameter("Vertex")
                .setDescription("Turn vertices on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);

    public final BooleanParameter allX =
                new BooleanParameter("allX")
                .setDescription("All X on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);
    public final BooleanParameter allY =
                new BooleanParameter("allY")
                .setDescription("All Y on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);
    public final BooleanParameter allZ =
                new BooleanParameter("allZ")
                .setDescription("All Z on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);
    public final BooleanParameter allD =
                new BooleanParameter("allD")
                .setDescription("diags on/off")
                .setMode(BooleanParameter.Mode.TOGGLE);
    


    public GroupSelector(LX lx) {
        super(lx);
        addParameter("b", this.b);
        addParameter("diagonals toggle", this.enableDiagonals);
        addParameter("diagonals", this.d_num);
        addParameter("cubes toggle", this.enableCubes);
        addParameter("cubes", this.c_num);
        addParameter("outputs toggle", this.enableOutputs);
        addParameter("outputs", this.o_num);
        addParameter("strip toggle", this.enableSingleStrip);
        // addParameter("diagonal strip", this.ds_num);
        addParameter("cube vertex", this.cv_num);
        addParameter("vertex toggle", this.enableVertex);
        addParameter("vertex number", this.v_num);
        addParameter("x toggle", this.allX);
        addParameter("y toggle", this.allY);
        addParameter("z toggle", this.allZ);
        addParameter("d toggle", this.allD);
        addParameter("bots toggle", this.enableBots);



    }

    public void run(double deltaMs) {

        int diag = (int)this.d_num.getValue();
        int cube = (int)this.c_num.getValue();
        int out = (int)this.o_num.getValue();
        // int dstrip = (int)this.ds_num.getValue();
        int c_vertex = (int)this.cv_num.getValue();
        int vertex = (int)this.v_num.getValue();


        List<Cube> cubes = structure.cubes.cubes;
        List<Diagonal> diagonals = structure.diagonals.diagonals;
        List<Vertex> vertices = new ArrayList();
        Makerbots makerbots = structure.makerbots;
        for(Cube c : cubes){
        	vertices.addAll(c.vertices);
        }

        for(LXPoint point : model.getPoints()){
            setColor(point.index, LXColor.hsb(0, 0, 0));
        }

        for (int i=0;i<diagonals.size();++i) {
            if (!this.enableDiagonals.getValueb()){
                break;
            }
            for(LXPoint point : diagonals.get(i).getPoints()){
	            if ((diag!=i)){
	            	break;
	            }
	            setColor(point.index, LXColor.hsb(0, 0, this.b.getValue()));
            }
        }

        for (LXPoint point : cubes.get(cube).getPoints()) {
            if (!this.enableCubes.getValueb()){
                break;
            }
            setColor(point.index, LXColor.hsb(0, 0, this.b.getValue()));
        }
        for(LXPoint point : cubes.get(cube).vertices.get(c_vertex).getPoints()){
            if (!this.enableSingleStrip.getValueb()){
                break;
            }
            setColor(point.index, LXColor.hsb(0, 0, this.b.getValue()));
        }

        for(LXPoint point : vertices.get(vertex).getPoints()){
            if (!this.enableVertex.getValueb()){
                break;
            }
            setColor(point.index, LXColor.hsb(0, 0, this.b.getValue()));
        }

        for(Cube c : cubes){
        	if(!this.allX.getValueb()) break;
        	for(LXPoint p : c.x){
        		setColor(p.index, LXColor.hsb(0, 0, this.b.getValue())); 
        	}
        }

        for(Cube c : cubes){
            if(!this.allY.getValueb()) break;
        	for(LXPoint p : c.y){
        		setColor(p.index, LXColor.hsb(0, 0, this.b.getValue())); 
        	}
        }

        for(Cube c : cubes){
            if(!this.allZ.getValueb()) break;
        	for(LXPoint p : c.z){
        		setColor(p.index, LXColor.hsb(0, 0, this.b.getValue())); 
        	}
        }

        for(Diagonal d : diagonals){
            if(!this.allD.getValueb()) break;
            for(LXPoint p : d.getPoints()){
	            setColor(p.index, LXColor.hsb(0, 0, this.b.getValue()));  
            }
        }

        for(LXPoint p : output.outputs.get(out)){
        	if(!this.enableOutputs.getValueb()) break;
        	setColor(p.index, LXColor.hsb(0, 0, this.b.getValue()));
        }

        for(LXPoint p : makerbots.getPoints()){
        	if(!this.enableBots.getValueb()) break;
        	setColor(p.index, LXColor.hsb(0, 0, this.b.getValue()));
        }
    }
}


// /**
//  * Braindead simple test pattern that iterates through all the nodes turning
//  * them on one by one in fixed order.
//  */
// public class CollectionsIterator extends LXPattern {

//   private final SawLFO index;
//   public final CompoundParameter speed = new CompoundParameter("Speed", 10, 1, 100);

//   private final FunctionalParameter period = new FunctionalParameter() {
//     @Override
//     public double getValue() {
//       return (1000 / speed.getValue()) * lx.total;
//     }
//   };

//   public CollectionsIterator(LX lx) {
//     super(lx);
//     addParameter(speed);
//     setAutoCycleEligible(false);
//     startModulator(this.index = new SawLFO(0, lx.total, period));
//   }

//   @Override
//   public void run(double deltaMs) {
//     int active = (int) Math.floor(this.index.getValue());
//     for (LXPoint point : structure.diagonals.diagonals.get(0)) {
//       int i = point.index;
//       System.out.println("i: "+i);
//       this.colors[i] = (i == active) ? 0xFFFFFFFF : 0xFF000000;
//     }
//   }
// }