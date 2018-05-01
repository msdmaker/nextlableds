// Let's work in metric
final static float METRE = 100;
final static float CM = METRE / 100;
final static float MM = METRE / 1000;
final static float FEET = 304.8*MM;
final static float INCH = METRE / 100;
final static float INCHES = INCH;

// Top-level, we have a model and an LXStudio instance
Model model;
LXStudio lx;
// GraphMap graph;
ArtNetOut output;

float temperature;

// Setup establishes the windowing and LX constructs
void setup() {
  size(1280, 960, P3D);
  
  // Create the model, which describes where our light points are
  model = new Model();

  // graph = new GraphMap();
  
  // Create the P3LX engine
  lx = new LXStudio(this, model)  {
    @Override
    protected void initialize(LXStudio lx, LXStudio.UI ui) {
      // Add custom LXComponents or LXOutput objects to the engine here,
      // before the UI is constructed
      try {
        output = new ArtNetOut(lx);
        lx.engine.output.gammaCorrection.setValue(0);
        lx.engine.output.enabled.setValue(false);
        lx.addOutput(output);
      } catch (Exception x) {
        x.printStackTrace();
       throw new RuntimeException(x);
      }
    }
    
    @Override
    protected void onUIReady(LXStudio lx, LXStudio.UI ui) {
      // The UI is now ready, can add custom UI components if desired
      // ui.preview.addComponent(new UIWalls());
    }
  };

}

void draw() {
  // lx.engine.output.brightness.setValue((float)iter++/1000);
  // if(iter>999) iter=0;

  // Empty placeholder... LX handles everything for us!
}