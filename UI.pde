/**
 * Example of a custom 3d UI component. This draws a box around
 * our custom matrix model.
 */
public class UIWalls extends UI3dComponent {
  
  private final float WALL_MARGIN = METRE/20;
  private final float WALL_SIZE = model.xRange + 2*WALL_MARGIN;
  private final float WALL_THICKNESS = 1*CM;
  
  @Override
  protected void beginDraw(UI ui, PGraphics pg) {
    pg.pointLight(100, 100, 100, model.cx, model.cy, 0);
  }
  
  @Override
  protected void onDraw(UI ui, PGraphics pg) {
    // pg.fill(#ffffff);
    // pg.stroke(#000000);
    // pg.pushMatrix();
    // pg.translate(model.cx, model.cy, model.zMax + WALL_MARGIN);
    // pg.box(WALL_SIZE, WALL_SIZE, WALL_THICKNESS);
    // pg.translate(-model.xRange/2 - WALL_MARGIN, 0, -model.zRange/2 - WALL_MARGIN);
    // pg.box(WALL_THICKNESS, WALL_SIZE, WALL_SIZE);
    // pg.translate(model.xRange + 2*WALL_MARGIN, 0, 0);
    // pg.box(WALL_THICKNESS, WALL_SIZE, WALL_SIZE);
    // pg.translate(-model.xRange/2 - WALL_MARGIN, model.yRange/2 + WALL_MARGIN, 0);
    // pg.box(WALL_SIZE, WALL_THICKNESS, WALL_SIZE);
    // pg.translate(0, -model.yRange - 2*WALL_MARGIN, 0);
    // pg.box(WALL_SIZE, WALL_THICKNESS, WALL_SIZE);
    // pg.popMatrix();
  }
  
  @Override
  protected void endDraw(UI ui, PGraphics pg) {
    pg.noLights();
  }
}

// public class CellEdge extends UI3dComponent {
//   private final float WALL_THICKNESS = CM;
//   private final float WALL_WIDTH = 4*CM;;
//   private float Wall_Length;
//   private LEDStrip LEDs;
// }