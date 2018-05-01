import java.util.List;

public static class Cubes implements LXFixture{
  List<Cube> cubes = new ArrayList();
  List<LXPoint> points = new ArrayList();

  public Cubes(LXTransform t){
    //Respective pixel counts of vxi, vxo, vyi, vyo, vzi, vzo
    int[][] dimensions = new int[7][6];

    dimensions[0] = new int[]{
      48, 46,
      28, 28,
      48, 46
    };
    dimensions[1] = new int[]{
      72, 70,
      42, 42,
      72, 70
    };
    dimensions[2] = new int[]{
      96, 94,
      56, 56,
      96, 94
    };
    dimensions[3] = new int[]{
      120, 118,
      70, 70,
      120, 118
    };
    dimensions[4] = new int[]{
      140, 138,
      84, 84,
      140, 138
    };
    dimensions[5] = new int[]{
      164, 162,
      98, 98,
      164, 162
    };
    dimensions[6] = new int[]{
      188, 186,
      112, 112,
      188, 186
    };

    //Alternate cube orientations and correct for cumulative offsets
    cubes.add(new Cube(dimensions[0], t, 0));
    for(int i=1;i<7;++i){
      if(i%2==0){
        t.rotateY(3*Math.PI/2);
        cubes.add(new Cube(dimensions[i], t, 0));
      } else {
        t.rotateY(-3*Math.PI/2);
        t.translate(0,0,8*CM);
        cubes.add(new Cube(dimensions[i], t, 1));
        t.translate(0,0,-8*CM);
      }
    }
    for(Cube c : cubes){
      points.addAll(c.getPoints());
    }
  }
  public List<LXPoint> getPoints(){
    return points;
  }
}

public static class Cube implements LXFixture{
  List<Vertex> vertices = new ArrayList();
  List<LXPoint> points = new ArrayList();
  List<LXPoint> inner = new ArrayList();
  List<LXPoint> outer = new ArrayList();
  List<LXPoint> x = new ArrayList();
  List<LXPoint> y = new ArrayList();
  List<LXPoint> z = new ArrayList();

  public Cube(int[] dimensions, LXTransform t, int orientation){
    t.push();
    t.push();
    float[] pos = getOrigin(dimensions);
    t.translate(pos[0],pos[1],pos[2]);

    t.push();
    vertices.add(new Vertex(dimensions, t, orientation));
    t.translate(dimensions[1]*METRE/60+8*CM,0,-dimensions[5]*METRE/60-8*CM);
    t.rotateY(Math.PI);
    vertices.add(new Vertex(dimensions, t, orientation));
    t.pop();
    t.translate(dimensions[1]*METRE/60+8*CM,dimensions[3]*METRE/60);
    t.rotateZ(Math.PI);
    vertices.add(new Vertex(dimensions, t, orientation));
    t.translate(dimensions[1]*METRE/60+8*CM,0,-dimensions[5]*METRE/60-8*CM);
    t.rotateY(Math.PI);
    vertices.add(new Vertex(dimensions, t, orientation));
    t.pop();

    for(Vertex v : vertices){
      points.addAll(v.getPoints());
      inner.addAll(v.in);
      outer.addAll(v.out);
      x.addAll(v.x);
      y.addAll(v.y);
      z.addAll(v.z);
    }
  }
  private float[] getOrigin(int[] dimensions){
    return new float[]{
      (-dimensions[1]*METRE/60)/2,
      (-dimensions[3]*METRE/60)/2,
      (dimensions[5]*METRE/60)/2
    };
  }
  public List<LXPoint> getPoints(){
    return points;
  }
}

public static class Vertex implements LXFixture{
  List<LXPoint> points = new ArrayList();
  List<LXPoint> x = new ArrayList();
  List<LXPoint> y = new ArrayList();
  List<LXPoint> z = new ArrayList();
  List<LXPoint> in = new ArrayList();
  List<LXPoint> out = new ArrayList();

  public Vertex(int[] dim, LXTransform t, int orientation){
    List<LXPoint> a = new ArrayList();
    List<LXPoint> b = new ArrayList();
    List<LXPoint> c = new ArrayList();

    t.push();
    t.push();
    a = buildRail(dim, 0, t);
    t.rotateZ(Math.PI/2);
    t.rotateX(7*Math.PI/4);
    b = buildRail(dim, 2, t);
    t.pop();
    t.rotateY(Math.PI/2);
    t.rotateX(Math.PI);
    c = buildRail(dim, 4, t);
    t.pop();
    
    //Normal orientation
    if(orientation == 0){
      this.x = a;
      this.y = b;
      this.z = c;
    //Alternated orientation
    }
    if (orientation == 1) {
      this.x = c;
      this.y = b;
      this.z = a;
    }
  }
  private List<LXPoint> buildRail(int[] dim, int index, LXTransform t){
    List<LXPoint> out = new ArrayList();
    t.push();
    for(int i=0;i<dim[index];++i){
      LXPoint new_lxpoint = new LXPoint(t.x(),t.y(),t.z());
      points.add(new_lxpoint);
      out.add(new_lxpoint);
      this.out.add(new_lxpoint);
      t.translate(METRE/60,0);
    }
    t.translate(-METRE/60,0,15*MM);
    t.rotateY(Math.PI);
    for(int i=0;i<dim[index+1];++i){
      LXPoint new_lxpoint = new LXPoint(t.x(),t.y(),t.z());
      points.add(new_lxpoint);
      out.add(new_lxpoint);
      this.in.add(new_lxpoint);
      t.translate(METRE/60,0);
    }
    t.pop();
    return out;
  }
  public List<LXPoint> getPoints(){
    return points;
  }
}

public static class Diagonals implements LXFixture{
  List<Diagonal> diagonals = new ArrayList();
  List<LXPoint> points = new ArrayList();

  double y_rot = Math.PI/4,
        z_rot = 0.385;

  public Diagonals(LXTransform t){
    //LSE Starting point
    t.translate(100*MM, -30*MM, 0*MM);
    t.push();
    t.translate(-1.825*METRE, -1*METRE, -1.81*METRE);
    t.rotateY(-y_rot);
    t.rotateZ(z_rot);
    diagonals.add(new Diagonal(t));
    t.pop();
    //LNE Starting point
    t.push();
    t.translate(1.725*METRE, -1*METRE, -1.825*METRE);
    t.rotateY(5*y_rot);
    t.rotateZ(z_rot);
    diagonals.add(new Diagonal(t));
    t.pop();
    //USE Starting point
    t.push();
    t.translate(-1.825*METRE, 1.035*METRE, -1.81*METRE);
    t.rotateY(-y_rot);
    t.rotateZ(-z_rot);
    diagonals.add(new Diagonal(t));
    t.pop();
    //UNE Starting point
    t.push();
    t.translate(1.725*METRE, 1.035*METRE, -1.825*METRE);
    t.rotateY(5*y_rot);
    t.rotateZ(-z_rot);
    diagonals.add(new Diagonal(t));
    t.pop();

    for(Diagonal d : diagonals){
      points.addAll(d.getPoints());
    }
  }
  public List<LXPoint> getPoints(){
    return points;
  }
}

public static class Diagonal implements LXFixture{
  List<LXPoint> points = new ArrayList();

  int outer = 14, 
      regular = 16, 
      post_outer = 6, 
      post_inner = 2, 
      inner = 36;

  public Diagonal(LXTransform t){
    DiagonalRun(t);
    t.rotateY(Math.PI);
    t.translate(-23.5*CM,0,24*MM);
    DiagonalRun(t);
  }

  private void makeStrip(int num, LXTransform t){
    t.push();
    for(int i=0; i<num; ++i){
      points.add(new LXPoint(t.x(),t.y(),t.z()));
      t.translate(METRE/60,0);
    }
    t.pop();
  }
  private void DiagonalRun(LXTransform t){
    makeStrip(outer, t);
    t.translate(27.75*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(post_outer, t);
    t.translate(20.4*CM,0);
    makeStrip(post_inner, t);
    t.translate(9.9*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(inner, t);
    t.translate(68.4*CM,0);
    makeStrip(inner, t);
    t.translate(62.58*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(post_inner, t);
    t.translate(17*CM,0);    
    makeStrip(post_outer, t);
    t.translate(12.68*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(regular, t);
    t.translate(30*CM,0);
    makeStrip(outer, t);    

  }
  public List<LXPoint> getPoints(){
    return points;
  }
}

public static class Makerbots implements LXFixture{
  List<Makerbot> makerbots = new ArrayList();
  List<LXPoint> points = new ArrayList();
  List<MakerbotGroup> groups = new ArrayList();


  public Makerbots(LXTransform t){
    t.translate(1365*MM,-1350*MM,1140.5*MM);
    t.push();
    MakerbotGroup g1 = new BotGroup1(t);
    t.pop();
    t.translate(67*CM,-76*CM,-60*CM);
    t.rotateY(Math.PI);
    t.push();
    MakerbotGroup g2 = new BotGroup2(t);
    t.pop();
    t.rotateY(Math.PI/2);
    t.translate(0,0,2.705*METRE+950*MM);
    MakerbotGroup g3 = new BotGroup3(t);

    makerbots.addAll(g2.makerbots);
    makerbots.addAll(g3.makerbots);

    points.addAll(g1.getPoints());

    groups.add(g1);
    groups.add(g2);
    groups.add(g3);
  }
  
  public List<LXPoint> getPoints(){
    List<LXPoint> out = new ArrayList();
    for(Makerbot bot : makerbots){
      out.addAll(bot.getPoints());
    }
    out.addAll(points);
    return out;
  }
}

public static abstract class MakerbotGroup implements LXFixture{
  public List<Makerbot> makerbots = new ArrayList();
  List<LXPoint> points = new ArrayList();
  float pixel_distance = METRE/60;
  HashMap<Integer, BotOutput> output_map = new HashMap();
  public class BotOutput implements LXFixture{
    List<LXPoint> points = new ArrayList();
    public List<LXPoint> getPoints(){
      return points;
    }
  }


  public abstract List<LXPoint> getPoints();
}

public static class BotGroup1 extends MakerbotGroup{
    int vertical = 46, horizontal = 35;
    List<LXPoint> points = new ArrayList();
    List<Makerbot> makerbots = new ArrayList();
  public BotGroup1(LXTransform t){
    BotOutput out1 = new BotOutput();
    BotOutput out2 = new BotOutput();
    this.output_map.put(0, out1);
    this.output_map.put(1, out2);

    t.push();
    t.rotateY(Math.PI/2);
    t.rotateZ(-Math.PI/2);
    //Large makerbot 1
    for(int i =0;i<4*vertical+horizontal;++i){
      LXPoint new_point = new LXPoint(t.x(),t.y(),t.z());
      points.add(new_point);
      out1.points.add(new_point);
      t.translate(METRE/60, 0);
      if(i==vertical){
        t.translate(-METRE/60,0,415*MM);
        t.rotateZ(Math.PI);
      }
      if(i==2*vertical){
        t.translate(-METRE/60+215*MM,39*MM);
        t.rotateZ(Math.PI/2);
        t.push();
      }
      if(i==2*vertical+horizontal){
        t.translate(-METRE/60+39*MM, 215*MM);
        t.rotateZ(Math.PI/2);
      }
      if(i==3*vertical+horizontal){
        t.translate(-METRE/60,0,-415*MM);
        t.rotateZ(Math.PI);
      }
    }
    //~~~~~
    t.pop();
    t.translate(-39*MM-50*MM, 420*MM, 0);
    t.rotateX(Math.PI);
    t.push();
    t.rotateZ(Math.PI);
    t.rotateX(Math.PI);
    t.rotateZ(Math.PI);
    for(int i=1;i<10;++i){
      makerbots.add(new MakerbotSmall(t));
      t.translate(-740*MM,0);
      if(i%3==0){
        t.translate(33*MM,560*MM);
        t.rotateY(Math.PI);
      }
    }
    t.translate(39*MM,-189.5*CM,415*MM);
    t.rotateX(Math.PI);
    t.rotateZ(-Math.PI/2);

    //Large Makerbot 2
    List<LXPoint> _temp = new ArrayList();
    for(int i =0;i<4*vertical+horizontal;++i){
      LXPoint new_point = new LXPoint(t.x(),t.y(),t.z());
      points.add(new_point);
      _temp.add(new_point);
      t.translate(METRE/60, 0);
      if(i==vertical){
        t.translate(-METRE/60,0,415*MM);
        t.rotateZ(Math.PI);
      }
      if(i==2*vertical){
        t.translate(-METRE/60+215*MM,-39*MM);
        t.rotateZ(-Math.PI/2);
        t.push();
      }
      if(i==2*vertical+horizontal){
        t.translate(-METRE/60+39*MM, -215*MM);
        t.rotateZ(-Math.PI/2);
      }
      if(i==3*vertical+horizontal){
        t.translate(-METRE/60,0,-415*MM);
        t.rotateZ(-Math.PI);
      }
    }
    //~~~~~

    for(int i =0;i<makerbots.size();++i){
      if(i<6){
        out1.points.addAll(makerbots.get(i).getPoints());
      } else out2.points.addAll(makerbots.get(i).getPoints());
    }
    out2.points.addAll(_temp);
  }

  public List<LXPoint> getPoints(){
    List<LXPoint> out = new ArrayList();
    for(Makerbot bot : makerbots){
      out.addAll(bot.getPoints());
    }
    out.addAll(points);
    return out;
  }
}

public static class BotGroup2 extends MakerbotGroup{
  public BotGroup2(LXTransform t){
    t.translate(65*MM,347*MM,180*MM);
    t.rotateY(Math.PI/2);
    t.rotateX(Math.PI);
    for(int i=1;i<13;++i){
      if(i==5){
        t.push();
        t.translate(0*MM,0,-582*MM-23*CM);
        t.rotateY(-Math.PI/2);
      }
      if(i==7){
        t.push();
        t.translate(0,-438*MM);
        t.rotateZ(Math.PI);
        t.rotateX(Math.PI);
        makerbots.add(new MakerbotDoor(t));
        t.pop();
        t.translate(50*MM,560*MM);
        t.rotateY(Math.PI);
      }
      if(i==9){
        t.pop();
        t.translate(50*MM,532*MM);
        t.rotateY(Math.PI);
      }
      if(i==4||i==9){
        makerbots.add(new MakerbotSmallBespoke(t));
      } else makerbots.add(new MakerbotSmall(t));
      t.translate(-740*MM,0);
    }
  }
  public List<LXPoint> getPoints(){
    List<LXPoint> out = new ArrayList();
    for(Makerbot bot : makerbots){
      out.addAll(bot.getPoints());
    }
    return out;
  }
}

public static class BotGroup3 extends MakerbotGroup{
  public BotGroup3(LXTransform t){
    t.translate(-3059*MM,347*MM,-22*MM);
    t.rotateX(Math.PI);
    t.rotateY(Math.PI);
    for(int i=1;i<9;++i){
      if(i==5){
        t.translate(50*MM,532*MM);
        t.rotateY(Math.PI);
      }
      if(i==1||i==8){
        makerbots.add(new MakerbotSmallBespoke(t));
      } else makerbots.add(new MakerbotSmall(t));

      t.translate(-740*MM,0);
    }
    t.translate(0,0,607*MM);
    t.rotateX(Math.PI);
    makerbots.add(new MakerbotDoor(t));
  }
  public List<LXPoint> getPoints(){
    List<LXPoint> out = new ArrayList();
    for(Makerbot bot : makerbots){
      out.addAll(bot.getPoints());
    }
    return out;
  }
}

public static abstract class Makerbot implements LXFixture{
  public List<LXPoint>  points = new ArrayList(),
                        strip_illuminator = new ArrayList(), 
                        strip_content = new ArrayList();

  public final float pixel_distance = METRE/60;

  public List<LXPoint> getPoints(){
    return points;
  } 
}

public static class MakerbotSmall extends Makerbot{

  int horizontal = 38, vertical =12;

  public MakerbotSmall(LXTransform t){
    t.push();
    t.rotateZ(-Math.PI/2);
    strip(vertical, t);
    t.translate(210*MM,-46*MM);
    t.rotateZ(-Math.PI/2);
    strip(horizontal, t);
    t.translate(28*MM,-206.5*MM+pixel_distance);
    t.rotateZ(-Math.PI/2);
    strip(vertical, t);
    t.rotateZ(-Math.PI/2);
    t.pop();
  }
  private void strip(int num, LXTransform t){
    for(int i=0;i<num;++i){
      t.translate(pixel_distance,0);
      LXPoint newPoint = new LXPoint(t.x(),t.y(),t.z());
      points.add(newPoint);
      if(num==15){
        strip_content.add(newPoint);
      }else{
        strip_illuminator.add(newPoint);
      }
    }
  }
}

public static class MakerbotSmallBespoke extends Makerbot{

  int horizontal = 35, vertical =12;

  public MakerbotSmallBespoke(LXTransform t){
    t.push();
    t.rotateZ(-Math.PI/2);
    strip(vertical, t);
    t.translate(210*MM,-49*MM);
    t.rotateZ(-Math.PI/2);
    strip(horizontal, t);
    t.translate(28*MM,-206.5*MM+pixel_distance);
    t.rotateZ(-Math.PI/2);
    strip(vertical, t);
    t.rotateZ(-Math.PI/2);
    t.pop();
  }
  private void strip(int num, LXTransform t){
    for(int i=0;i<num;++i){
      t.translate(pixel_distance,0);
      LXPoint newPoint = new LXPoint(t.x(),t.y(),t.z());
      points.add(newPoint);
      if(num==15){
        strip_content.add(newPoint);
      }else{
        strip_illuminator.add(newPoint);
      }
    }
  }
}

public static class MakerbotLarge extends Makerbot{
  int vertical = 46, horizontal = 35;

  public MakerbotLarge(LXTransform t){
    t.push();
    t.rotateY(Math.PI);
    t.rotateZ(Math.PI);
    strip(vertical, t);
    t.translate(0,0,-415*MM);
    t.rotateX(Math.PI);
    strip(vertical, t);
    t.translate(-39*MM,215*MM);
    t.rotateX(Math.PI/2);
    t.rotateZ(Math.PI/2);
    strip(horizontal,t);
    t.translate(0,39*MM,215*MM);
    t.rotateX(Math.PI/2);
    strip(vertical,t);
    t.rotateX(Math.PI);
    t.translate(-415*MM,0);
    strip(vertical, t);
    t.pop();
  }
  public void strip(int num, LXTransform t){
    for(int i=0;i<num;++i){
      LXPoint newPoint = new LXPoint(t.x(),t.y(),t.z());
      points.add(newPoint);
      if(num==30){
        strip_illuminator.add(newPoint);
      }else{
        strip_content.add(newPoint);
      }
      t.translate(0,pixel_distance);
    }
    t.translate(0, -pixel_distance);
  }
}

public static class MakerbotDoor extends Makerbot{
  int num = 60;

  public MakerbotDoor(LXTransform t){
    for(int i=0;i<num;++i){
      LXPoint newPoint = new LXPoint(t.x(),t.y(),t.z());
      points.add(newPoint);
      strip_illuminator.add(newPoint);
      t.translate(0,pixel_distance);
    }
  }
}