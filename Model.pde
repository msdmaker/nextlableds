import java.util.List;
import java.util.HashMap;

public static Structure structure = new Structure();

public static class Structure implements LXFixture{
  public Cubes cubes;
  public Diagonals diagonals;
  public Makerbots makerbots;

  public Structure() {

    LXTransform t = new LXTransform();
    t.push();
    this.cubes = new Cubes(t);
    t.pop();
    this.diagonals = new Diagonals(t);
    this.makerbots = new Makerbots(t);
  }

  public List<LXPoint> getPoints() {
    List<LXPoint> out = new ArrayList<LXPoint>();
    out.addAll(cubes.getPoints());
    out.addAll(diagonals.getPoints());
    out.addAll(makerbots.getPoints());

    return out;
  }
}

public static class Model extends LXModel {

  public Model() {
    super(structure);
  }
}