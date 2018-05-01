public abstract class TenerePattern extends LXPattern {
  
  protected final Model model;
  
  public TenerePattern(LX lx) {
    super(lx);
    this.model = (Model)lx.model;
  }
  
  public abstract String getAuthor();
  
  public void onActive() {
    // TODO: report via OSC to blockchain
  }
  
  public void onInactive() {
    // TODO: report via OSC to blockchain
  }
}

public class PatternWaves extends TenerePattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }

  final int NUM_LAYERS = 3;
  
  final float AMP_DAMPING_V = 1.5;
  final float AMP_DAMPING_A = 2.5;
  
  final float LEN_DAMPING_V = 1.5;
  final float LEN_DAMPING_A = 1.5;

  public final CompoundParameter rate = (CompoundParameter)
    new CompoundParameter("Rate", 6000, 48000, 2000)
    .setDescription("Rate of the of the wave motion")
    .setExponent(.3);

  public final CompoundParameter size =
    new CompoundParameter("Size", 4*FEET, 6*INCHES, 28*FEET)
    .setDescription("Width of the wave");
    
  public final CompoundParameter amp1 =
    new CompoundParameter("Amp1", .5, 2, .2)
    .setDescription("First modulation size");
        
  public final CompoundParameter amp2 =
    new CompoundParameter("Amp2", 1.4, 2, .2)
    .setDescription("Second modulation size");
    
  public final CompoundParameter amp3 =
    new CompoundParameter("Amp3", .5, 2, .2)
    .setDescription("Third modulation size");
    
  public final CompoundParameter len1 =
    new CompoundParameter("Len1", 1, 2, .2)
    .setDescription("First wavelength size");
    
  public final CompoundParameter len2 =
    new CompoundParameter("Len2", .8, 2, .2)
    .setDescription("Second wavelength size");
    
  public final CompoundParameter len3 =
    new CompoundParameter("Len3", 1.5, 2, .2)
    .setDescription("Third wavelength size");
    
  private final LXModulator phase =
    startModulator(new SawLFO(0, TWO_PI, rate));
    
  private final LXModulator amp1Damp = startModulator(new DampedParameter(this.amp1, AMP_DAMPING_V, AMP_DAMPING_A));
  private final LXModulator amp2Damp = startModulator(new DampedParameter(this.amp2, AMP_DAMPING_V, AMP_DAMPING_A));
  private final LXModulator amp3Damp = startModulator(new DampedParameter(this.amp3, AMP_DAMPING_V, AMP_DAMPING_A));
  
  private final LXModulator len1Damp = startModulator(new DampedParameter(this.len1, LEN_DAMPING_V, LEN_DAMPING_A));
  private final LXModulator len2Damp = startModulator(new DampedParameter(this.len2, LEN_DAMPING_V, LEN_DAMPING_A));
  private final LXModulator len3Damp = startModulator(new DampedParameter(this.len3, LEN_DAMPING_V, LEN_DAMPING_A));  

  private final LXModulator sizeDamp = startModulator(new DampedParameter(this.size, 40*FEET, 80*FEET));

  private final double[] bins = new double[512];

  public PatternWaves(LX lx) {
    super(lx);
    addParameter("rate", this.rate);
    addParameter("size", this.size);
    addParameter("amp1", this.amp1);
    addParameter("amp2", this.amp2);
    addParameter("amp3", this.amp3);
    addParameter("len1", this.len1);
    addParameter("len2", this.len2);
    addParameter("len3", this.len3);
  }

  public void run(double deltaMs) {
    double phaseValue = phase.getValue();
    float amp1 = this.amp1Damp.getValuef();
    float amp2 = this.amp2Damp.getValuef();
    float amp3 = this.amp3Damp.getValuef();
    float len1 = this.len1Damp.getValuef();
    float len2 = this.len2Damp.getValuef();
    float len3 = this.len3Damp.getValuef();    
    float falloff = 100 / this.sizeDamp.getValuef();
    
    for (int i = 0; i < bins.length; ++i) {
      bins[i] = model.cy + model.yRange/2 * Math.sin(i * TWO_PI / bins.length + phaseValue);
    }
    for (LXPoint p : model.getPoints()) {
      int idx = Math.round((bins.length-1) * (len1 * p.xn)) % bins.length;
      int idx2 = Math.round((bins.length-1) * (len2 * (.2 + p.xn))) % bins.length;
      int idx3 = Math.round((bins.length-1) * (len3 * (1.7 - p.xn))) % bins.length; 
      
      float y1 = (float) bins[idx];
      float y2 = (float) bins[idx2];
      float y3 = (float) bins[idx3];
      
      float d1 = abs(p.y*amp1 - y1);
      float d2 = abs(p.y*amp2 - y2);
      float d3 = abs(p.y*amp3 - y3);
      
      float b = max(0, 100 - falloff * min(min(d1, d2), d3));      
      setColor(p.index, b > 0 ? LXColor.gray(b) : #000000);
    }
  }
}

public class PatternVortex extends TenerePattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }
  
  public final CompoundParameter speed = (CompoundParameter)
    new CompoundParameter("Speed", 2000, 9000, 300)
    .setExponent(.5)
    .setDescription("Speed of vortex motion");
  
  public final CompoundParameter size =
    new CompoundParameter("Size",  4*FEET, 1*FEET, 10*FEET)
    .setDescription("Size of vortex");
  
  public final CompoundParameter xPos = (CompoundParameter)
    new CompoundParameter("XPos", model.cx, model.xMin, model.xMax)
    .setPolarity(LXParameter.Polarity.BIPOLAR)
    .setDescription("X-position of vortex center");
    
  public final CompoundParameter yPos = (CompoundParameter)
    new CompoundParameter("YPos", model.cy, model.yMin, model.yMax)
    .setPolarity(LXParameter.Polarity.BIPOLAR)
    .setDescription("Y-position of vortex center");
    
  public final CompoundParameter xSlope = (CompoundParameter)
    new CompoundParameter("XSlp", .2, -1, 1)
    .setPolarity(LXParameter.Polarity.BIPOLAR)
    .setDescription("X-slope of vortex center");
    
  public final CompoundParameter ySlope = (CompoundParameter)
    new CompoundParameter("YSlp", .5, -1, 1)
    .setPolarity(LXParameter.Polarity.BIPOLAR)
    .setDescription("Y-slope of vortex center");
    
  public final CompoundParameter zSlope = (CompoundParameter)
    new CompoundParameter("ZSlp", .3, -1, 1)
    .setPolarity(LXParameter.Polarity.BIPOLAR)
    .setDescription("Z-slope of vortex center");
  
  private final LXModulator pos = startModulator(new SawLFO(1, 0, this.speed));
  
  private final LXModulator sizeDamped = startModulator(new DampedParameter(this.size, 5*FEET, 8*FEET));
  private final LXModulator xPosDamped = startModulator(new DampedParameter(this.xPos, model.xRange, 3*model.xRange));
  private final LXModulator yPosDamped = startModulator(new DampedParameter(this.yPos, model.yRange, 3*model.yRange));
  private final LXModulator xSlopeDamped = startModulator(new DampedParameter(this.xSlope, 3, 6));
  private final LXModulator ySlopeDamped = startModulator(new DampedParameter(this.ySlope, 3, 6));
  private final LXModulator zSlopeDamped = startModulator(new DampedParameter(this.zSlope, 3, 6));

  public PatternVortex(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("size", this.size);
    addParameter("xPos", this.xPos);
    addParameter("yPos", this.yPos);
    addParameter("xSlope", this.xSlope);
    addParameter("ySlope", this.ySlope);
    addParameter("zSlope", this.zSlope);
  }

  public void run(double deltaMs) {
    final float xPos = this.xPosDamped.getValuef();
    final float yPos = this.yPosDamped.getValuef();
    final float size = this.sizeDamped.getValuef();
    final float pos = this.pos.getValuef();
    
    final float xSlope = this.xSlopeDamped.getValuef();
    final float ySlope = this.ySlopeDamped.getValuef();
    final float zSlope = this.zSlopeDamped.getValuef();

    float dMult = 2 / size;
    for (LXPoint p : model.getPoints()) {
      float radix = abs((xSlope*abs(p.x-model.cx) + ySlope*abs(p.y-model.cy) + zSlope*abs(p.z-model.cz)));
      float dist = dist(p.x, p.y, xPos, yPos); 
      float falloff = 100 / max(20*INCHES, 2*size - .5*dist);
      // float b = 100 - falloff * LXUtils.wrapdistf(radix, pos * size, size);
      float b = abs(((dist + radix + pos * size) % size) * dMult - 1);
      setColor(p.index, (b > 0) ? LXColor.gray(b*b*100) : #000000);
    }
  }
}

public class PatternAxisPlanes extends TenerePattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }
  
  public final CompoundParameter xSpeed = new CompoundParameter("XSpd", 11000, 21000, 5000).setDescription("Speed of motion on X-axis");
  public final CompoundParameter ySpeed = new CompoundParameter("YSpd", 13000, 21000, 5000).setDescription("Speed of motion on Y-axis");
  public final CompoundParameter zSpeed = new CompoundParameter("ZSpd", 17000, 21000, 5000).setDescription("Speed of motion on Z-axis");
  
  public final CompoundParameter xSize = new CompoundParameter("XSize", .1, .05, .3).setDescription("Size of X scanner");
  public final CompoundParameter ySize = new CompoundParameter("YSize", .1, .05, .3).setDescription("Size of Y scanner");
  public final CompoundParameter zSize = new CompoundParameter("ZSize", .1, .05, .3).setDescription("Size of Z scanner");
  
  private final LXModulator xPos = startModulator(new SinLFO(0, 1, this.xSpeed).randomBasis());
  private final LXModulator yPos = startModulator(new SinLFO(0, 1, this.ySpeed).randomBasis());
  private final LXModulator zPos = startModulator(new SinLFO(0, 1, this.zSpeed).randomBasis());
  
  public PatternAxisPlanes(LX lx) {
    super(lx);
    addParameter("xSpeed", this.xSpeed);
    addParameter("ySpeed", this.ySpeed);
    addParameter("zSpeed", this.zSpeed);
    addParameter("xSize", this.xSize);
    addParameter("ySize", this.ySize);
    addParameter("zSize", this.zSize);
  }
  
  public void run(double deltaMs) {
    float xPos = this.xPos.getValuef();
    float yPos = this.yPos.getValuef();
    float zPos = this.zPos.getValuef();
    float xFalloff = 100 / this.xSize.getValuef();
    float yFalloff = 100 / this.ySize.getValuef();
    float zFalloff = 100 / this.zSize.getValuef();
    
    for (LXPoint p : model.points) {
      float b = max(max(
        100 - xFalloff * abs(p.xn - xPos),
        100 - yFalloff * abs(p.yn - yPos)),
        100 - zFalloff * abs(p.zn - zPos)
      );
      setColor(p.index, LXColor.gray(max(0, b)));
    }
  }
}

public class PatternAudioMeter extends TenerePattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }
  
  public final CompoundParameter mode =
    new CompoundParameter("Mode", 0)
    .setDescription("Sets the mode of the equalizer");
    
  public final CompoundParameter size =
    new CompoundParameter("Size", .2, .1, .4)
    .setDescription("Sets the size of the display");
  
  public PatternAudioMeter(LX lx) {
    super(lx);
    addParameter("mode", this.mode);
    addParameter("size", this.size);
  }
  
  public void run(double deltaMs) {
    float meter = lx.engine.audio.meter.getValuef();
    float mode = this.mode.getValuef();
    float falloff = 100 / this.size.getValuef();
    for (LXPoint p : model.points) {
      float pPos = 2 * abs(p.yn - .5);
      float b1 = constrain(50 - falloff * (pPos - meter), 0, 100);
      float b2 = constrain(50 - falloff * abs(pPos - meter), 0, 100);
      setColor(p.index, LXColor.gray(lerp(b1, b2, mode)));
    }
  } 
}

public abstract class BufferPattern extends TenerePattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }
  
  public final CompoundParameter speedRaw = (CompoundParameter)
    new CompoundParameter("Speed", 256, 2048, 64)
    .setExponent(.5)
    .setDescription("Speed of the wave propagation");
  
  public final LXModulator speed = startModulator(new DampedParameter(speedRaw, 256, 512));
  
  private static final int BUFFER_SIZE = 4096;
  protected int[] history = new int[BUFFER_SIZE];
  protected int cursor = 0;

  public BufferPattern(LX lx) {
    super(lx);
    addParameter("speed", this.speedRaw);
    for (int i = 0; i < this.history.length; ++i) {
      this.history[i] = #000000;
    }
  }
  
  public final void run(double deltaMs) {
    // Add to history
    if (--this.cursor < 0) {
      this.cursor = this.history.length - 1;
    }
    this.history[this.cursor] = getColor();
    onRun(deltaMs);
  }
  
  protected int getColor() {
    return LXColor.gray(100 * getLevel());
  }
  
  protected float getLevel() {
    return 0;
  }
  
  abstract void onRun(double deltaMs); 
}

public abstract class SpinningPattern extends TenerePattern {
  
  public final CompoundParameter speed = (CompoundParameter)
    new CompoundParameter("Speed", 17000, 25000, 5000)
    .setExponent(2)
    .setDescription("Speed of lighthouse motion");
        
  protected final LXModulator azimuth = startModulator(new SawLFO(0, TWO_PI, speed));
    
  public SpinningPattern(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
  }
}

public class PatternChess extends SpinningPattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }
  
  public final CompoundParameter numSpots = (CompoundParameter)
    new CompoundParameter("Spots", 4, 2, 8)
    .setDescription("Number of spots");
  
  private final LXModulator numSpotsDamped = startModulator(new DampedParameter(numSpots, 12, 20, 6));
  
  public PatternChess(LX lx) {
    super(lx);
    addParameter("numSpots", this.numSpots);
  }
  
  public void run(double deltaMs) {
    float azimuth = this.azimuth.getValuef();
    float numSpots = this.numSpotsDamped.getValuef(); 
    for (LXPoint p : model.points) {
      // LXPoint p = assemblage.points[0];
      float az = p.azimuth + azimuth;
      if (az > TWO_PI) {
        az -= TWO_PI;
      }
      float d = LXUtils.wrapdistf(az, 0, TWO_PI);
      d = abs(d - PI) / PI;
      int add = ((int) (numSpots * p.yn)) % 2;
      float basis = (numSpots * d + .5 * add) % 1;
      float d2 = 2*abs(.5 - basis);
      setColor(p.index, LXColor.gray(100 * (1-d2)*(1-d2)));
    }
  }
}

public class PatternSwarm extends TenerePattern {
  public String getAuthor() {
    return "Mark C. Slee";
  }
  
  private static final int NUM_GROUPS = 5;

  public final CompoundParameter speed = (CompoundParameter)
    new CompoundParameter("Speed", 2000, 10000, 500)
    .setDescription("Speed of swarm motion")
    .setExponent(.25);
    
  public final CompoundParameter base =
    new CompoundParameter("Base", 10, 60, 1)
    .setDescription("Base size of swarm");
    
  public final CompoundParameter floor =
    new CompoundParameter("Floor", 20, 0, 100)
    .setDescription("Base level of swarm brightness");

  public final LXModulator[] pos = new LXModulator[NUM_GROUPS];

  public final LXModulator swarmX = startModulator(new SinLFO(
    startModulator(new SinLFO(0, .2, startModulator(new SinLFO(3000, 9000, 17000).randomBasis()))), 
    startModulator(new SinLFO(.8, 1, startModulator(new SinLFO(4000, 7000, 15000).randomBasis()))), 
    startModulator(new SinLFO(9000, 17000, 33000).randomBasis())
    ).randomBasis());

  public final LXModulator swarmY = startModulator(new SinLFO(
    startModulator(new SinLFO(0, .2, startModulator(new SinLFO(3000, 9000, 19000).randomBasis()))), 
    startModulator(new SinLFO(.8, 1, startModulator(new SinLFO(4000, 7000, 13000).randomBasis()))), 
    startModulator(new SinLFO(9000, 17000, 33000).randomBasis())
    ).randomBasis());

  public final LXModulator swarmZ = startModulator(new SinLFO(
    startModulator(new SinLFO(0, .2, startModulator(new SinLFO(3000, 9000, 19000).randomBasis()))), 
    startModulator(new SinLFO(.8, 1, startModulator(new SinLFO(4000, 7000, 13000).randomBasis()))), 
    startModulator(new SinLFO(9000, 17000, 33000).randomBasis())
    ).randomBasis());

  public PatternSwarm(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("base", this.base);
    addParameter("floor", this.floor);
    for (int i = 0; i < pos.length; ++i) {
      final int ii = i;
      float start = (i % 2 == 0) ? 0 : 10;
      pos[i] = new SawLFO(start, 10 - start, new FunctionalParameter() {
        public double getValue() {
          return speed.getValue() + ii*500;
        }
      }).randomBasis();
      startModulator(pos[i]);
    }
  }

  public void run(double deltaMs) {
    float base = this.base.getValuef();
    float swarmX = this.swarmX.getValuef();
    float swarmY = this.swarmY.getValuef();
    float swarmZ = this.swarmZ.getValuef();
    float floor = this.floor.getValuef();

    int i = 0;
    for (LXFixture fixture : model.fixtures) {
      float pos = this.pos[i++ % NUM_GROUPS].getValuef();
      for (LXPoint p : fixture.getPoints()) {
        float falloff = min(100, base + 40 * dist(p.xn, p.yn, p.zn, swarmX, swarmY, swarmZ));
        float b = max(floor, 100 - falloff * LXUtils.wrapdistf(p.index, pos, 10));
        setColor(p.index, LXColor.gray(b));
      }
    }
  }
}

public class Plasma extends TenerePattern {
  
  public String getAuthor() {
    return "Fin McCarthy";
  }
  
  //by Fin McCarthy
  // finchronicity@gmail.com
  
  //variables
  int brightness = 255;
  float red, green, blue;
  float shade;
  float movement = 0.1;
  
  PlasmaGenerator plasmaGenerator;
  
  long framecount = 0;
    
    //adjust the size of the plasma
    public final CompoundParameter size =
    new CompoundParameter("Size", 0.8, 0.1, 1)
    .setDescription("Size");
  
    //variable speed of the plasma. 
    public final SinLFO RateLfo = new SinLFO(
      2, 
      20, 
      45000     
    );
  
    //moves the circle object around in space
    public final SinLFO CircleMoveX = new SinLFO(
      model.xMax*-1, 
      model.xMax*2, 
      40000     
    );
    
      public final SinLFO CircleMoveY = new SinLFO(
      model.xMax*-1, 
      model.yMax*2, 
      22000 
    );

  private final LXUtils.LookupTable.Sin sinTable = new LXUtils.LookupTable.Sin(255);
  private final LXUtils.LookupTable.Cos cosTable = new LXUtils.LookupTable.Cos(255);
  
  public Plasma(LX lx) {
    super(lx);
    
    addParameter(size);
    
    startModulator(CircleMoveX);
    startModulator(CircleMoveY);
    startModulator(RateLfo);
    
    plasmaGenerator =  new PlasmaGenerator(model.xMax, model.yMax, model.zMax);
    UpdateCirclePosition();
    
    //PrintModelGeometory();
}
    
  public void run(double deltaMs) {
   
    for (LXPoint p : model.points) {
      
      //GET A UNIQUE SHADE FOR THIS PIXEL

      //convert this point to vector so we can use the dist method in the plasma generator
      float _size = size.getValuef(); 
      
      //combine the individual plasma patterns 
      shade = plasmaGenerator.GetThreeTierPlasma(p, _size, movement );
 
      //separate out a red, green and blue shade from the plasma wave 
      red = map(sinTable.sin(shade*PI), -1, 1, 0, brightness);
      green =  map(sinTable.sin(shade*PI+(2*cosTable.cos(movement*490))), -1, 1, 0, brightness); //*cos(movement*490) makes the colors morph over the top of each other 
      blue = map(sinTable.sin(shade*PI+(4*sinTable.sin(movement*300))), -1, 1, 0, brightness);

      //ready to populate this color!
      setColor(p.index, LXColor.rgb((int)red,(int)green, (int)blue));

    }
    
   movement =+ ((float)RateLfo.getValue() / 1000); //advance the animation through time. 
   
  UpdateCirclePosition();
    
  }
  
  void UpdateCirclePosition()
  {
      plasmaGenerator.UpdateCirclePosition(
      (float)CircleMoveX.getValue(), 
      (float)CircleMoveY.getValue(),
      0
      );
  }
}


// This is a helper class to generate plasma. 

public static class PlasmaGenerator {
    
  //NOTE: Geometory is FULL scale for this model. Dont use normalized values. 
    
    float xmax, ymax, zmax;
    LXVector circle; 
    
    static final LXUtils.LookupTable.Sin sinTable = new LXUtils.LookupTable.Sin(255);
    
    float SinVertical(LXVector p, float size, float movement)
    {
      return sinTable.sin(   ( p.x / xmax / size) + (movement / 100 ));
    }
    
    float SinRotating(LXVector p, float size, float movement)
    {
      return sinTable.sin( ( ( p.y / ymax / size) * sin( movement /66 )) + (p.z / zmax / size) * (cos(movement / 100))  ) ;
    }
     
    float SinCircle(LXVector p, float size, float movement)
    {
      float distance =  p.dist(circle);
      return sinTable.sin( (( distance + movement + (p.z/zmax) ) / xmax / size) * 2 ); 
    }
  
    float GetThreeTierPlasma(LXPoint p, float size, float movement)
    {
      LXVector pointAsVector = new LXVector(p);
      return  SinVertical(  pointAsVector, size, movement) +
      SinRotating(  pointAsVector, size, movement) +
      SinCircle( pointAsVector, size, movement);
    }
    
    public PlasmaGenerator(float _xmax, float _ymax, float _zmax)
    {
      xmax = _xmax;
      ymax = _ymax;
      zmax = _zmax;
      circle = new LXVector(0,0,0);
    }
    
  void UpdateCirclePosition(float x, float y, float z)
  {
    circle.x = x;
    circle.y = y;
    circle.z = z;
  }
}

public class Lattice extends LXPattern {

  public final double MAX_RIPPLES_TREAT_AS_INFINITE = 2000.0;
  
  public final CompoundParameter rippleRadius =
    new CompoundParameter("Ripple radius", 500.0, 200.0, MAX_RIPPLES_TREAT_AS_INFINITE)
    .setDescription("Controls the spacing between ripples");

  public final CompoundParameter subdivisionSize =
    new CompoundParameter("Subdivision size", MAX_RIPPLES_TREAT_AS_INFINITE, 200.0, MAX_RIPPLES_TREAT_AS_INFINITE)
    .setDescription("Subdivides the canvas into smaller canvases of this size");

  public final CompoundParameter numSpirals =
    new CompoundParameter("Spirals", 0, -3, 3)
    .setDescription("Adds a spiral effect");

  public final CompoundParameter yFactor =
    new CompoundParameter("Y factor")
    .setDescription("How much Y is taken into account");

  public final CompoundParameter manhattanCoefficient =
    new CompoundParameter("Square")
    .setDescription("Whether the rippes should be circular or square");

  public final CompoundParameter triangleCoefficient =
    new CompoundParameter("Triangle coeff")
    .setDescription("Whether the wave resembles a sawtooth or a triangle");

  public final CompoundParameter visibleAmount =
    new CompoundParameter("Visible", 1.0, 0.1, 1.0)
    .setDescription("Whether the full wave is visible or only the peaks");

  public Lattice(LX lx) {
    super(lx);
    addParameter(rippleRadius);
    addParameter(subdivisionSize);
    addParameter(numSpirals);
    addParameter(yFactor);
    addParameter(manhattanCoefficient);
    addParameter(triangleCoefficient);
    addParameter(visibleAmount);
  }
  
  private double _modAndShiftToHalfZigzag(double dividend, double divisor) {
    double mod = (dividend + divisor) % divisor;
    double value = (mod > divisor / 2) ? (mod - divisor) : mod;
    int quotient = (int) (dividend / divisor);
    return (quotient % 2 == 0) ? -value : value;
  }
  
  private double _calculateDistance(LXPoint p) {
    double x = p.x;
    double y = p.y * this.yFactor.getValue();
    double z = p.z;
    
    double subdivisionSizeValue = subdivisionSize.getValue();
    if (subdivisionSizeValue < MAX_RIPPLES_TREAT_AS_INFINITE) {
      x = _modAndShiftToHalfZigzag(x, subdivisionSizeValue);
      y = _modAndShiftToHalfZigzag(y, subdivisionSizeValue);
      z = _modAndShiftToHalfZigzag(z, subdivisionSizeValue);
    }
        
    double manhattanDistance = (Math.abs(x) + Math.abs(y) + Math.abs(z)) / 1.5;
    double euclideanDistance = Math.sqrt(x * x + y * y + z * z);
    return LXUtils.lerp(euclideanDistance, manhattanDistance, manhattanCoefficient.getValue());
  }

  public void run(double deltaMs) {
    // add an arbitrary number of beats so refreshValueModOne isn't negative;
    // divide by 4 so you get one ripple per measure
    double ticksSoFar = (lx.tempo.beatCount() + lx.tempo.ramp() + 256) / 4;

    double rippleRadiusValue = rippleRadius.getValue();
    double triangleCoefficientValueHalf = triangleCoefficient.getValue() / 2;
    double visibleAmountValueMultiplier = 1 / visibleAmount.getValue();
    double visibleAmountValueToSubtract = visibleAmountValueMultiplier - 1;
    double numSpiralsValue = Math.round(numSpirals.getValue());

    // Let's iterate over all the leaves...
    for (LXPoint p : model.points) {
      double totalDistance = _calculateDistance(p);
      double rawRefreshValueFromDistance = totalDistance / rippleRadiusValue;
      double rawRefreshValueFromSpiral = Math.atan2(p.z, p.x) * numSpiralsValue / (2 * Math.PI);

      double refreshValueModOne = (ticksSoFar - rawRefreshValueFromDistance - rawRefreshValueFromSpiral) % 1.0;
      double brightnessValueBeforeVisibleCheck = (refreshValueModOne >= triangleCoefficientValueHalf) ?
        1 - (refreshValueModOne - triangleCoefficientValueHalf) / (1 - triangleCoefficientValueHalf) :
        (refreshValueModOne / triangleCoefficientValueHalf);

      double brightnessValue = brightnessValueBeforeVisibleCheck * visibleAmountValueMultiplier - visibleAmountValueToSubtract;

      if (brightnessValue > 0) {
        setColor(p.index, LXColor.gray((float) brightnessValue * 100));
      } else {
        setColor(p.index, #000000);
      }
    }
  }
}