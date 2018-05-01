/**
 * Copyright 2013- Mark C. Slee, Heron Arts LLC
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * ##library.name##
 * ##library.sentence##
 * ##library.url##
 *
 * @author      ##author##
 * @modified    ##date##
 * @version     ##library.prettyVersion## (##library.version##)
 */

package heronarts.p3lx.ui.component;

import heronarts.lx.model.LXModel;
import heronarts.lx.model.LXPoint;
import heronarts.p3lx.P3LX;
import heronarts.p3lx.ui.UI;
import heronarts.p3lx.ui.UI3dComponent;
import processing.core.PConstants;
import processing.core.PGraphics;

/**
 * Draws a cloud of points in the layer
 */
public class UIPointCloud extends UI3dComponent {

  protected final P3LX lx;

  protected final LXModel model;

  /**
   * Weight of points
   */
  protected float pointSize = 2;

  protected float[] pointSizeAttenuation = null;

  /**
   * Point cloud for everything in the LX instance
   *
   * @param lx LX instance
   */
  public UIPointCloud(P3LX lx) {
    this(lx, lx.model);
  }

  /**
   * Point cloud for points in the specified model
   *
   * @param lx LX instance
   * @param model Model to draw
   */
  public UIPointCloud(P3LX lx, LXModel model) {
    this.lx = lx;
    this.model = model;
  }

  /**
   * Sets the size of points
   *
   * @param pointSize Point size
   * @return this
   */
  public UIPointCloud setPointSize(float pointSize) {
    this.pointSize = pointSize;
    return this;
  }

  /**
   * Disable point size attenuation
   *
   * @return this
   */
  public UIPointCloud disablePointSizeAttenuation() {
    this.pointSizeAttenuation = null;
    return this;
  }

  /**
   * Sets point size attenuation, fn = 1/sqrt(constant + linear*d + quadratic*d^2)
   *
   * @param a Constant factor
   * @param b Linear factor
   * @param c Quadratic factor
   * @return this
   */
  public UIPointCloud setPointSizeAttenuation(float a, float b, float c) {
    if (this.pointSizeAttenuation == null) {
      this.pointSizeAttenuation = new float[3];
    }
    this.pointSizeAttenuation[0] = a;
    this.pointSizeAttenuation[1] = b;
    this.pointSizeAttenuation[2] = c;
    return this;
  }

  @Override
  protected void onDraw(UI ui, PGraphics pg) {
    int[] colors = this.lx.getColors();
    pg.noFill();
    pg.strokeWeight(this.pointSize);
    pg.beginShape(PConstants.POINTS);
    for (LXPoint p : this.model.points) {
      pg.stroke(colors[p.index]);
      pg.vertex(p.x, p.y, p.z);
    }
    pg.endShape();
    pg.strokeWeight(1);
  }
}
