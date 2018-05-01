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

import heronarts.p3lx.ui.UI;
import heronarts.p3lx.ui.UI2dComponent;
import processing.core.PConstants;
import processing.core.PGraphics;

/**
 * A simple text label object. Draws a string aligned top-left to its x-y
 * position.
 */
public class UILabel extends UI2dComponent {

  private int topPadding = 0;
  private int rightPadding = 0;
  private int leftPadding = 0;
  private int bottomPadding = 0;

  /**
   * Label text
   */
  private String label = "";

  public UILabel() {
    this(0, 0, 0, 0);
  }

  public UILabel(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  /**
   * Sets padding on all 4 sides
   *
   * @param padding Padding
   * @return this
   */
  public UILabel setPadding(int padding) {
    return setPadding(padding, padding, padding, padding);
  }

  /**
   * Sets padding on top and sides, CSS style
   *
   * @param topBottom Top bottom padding
   * @param leftRight Left right padding
   * @return this
   */
  public UILabel setPadding(int topBottom, int leftRight) {
    return setPadding(topBottom, leftRight, topBottom, leftRight);
  }

  /**
   * Sets padding on all 4 sides
   *
   * @param topPadding Top padding
   * @param rightPadding Right padding
   * @param bottomPadding Bottom padding
   * @param leftPadding Left padding
   * @return this
   */
  public UILabel setPadding(int topPadding, int rightPadding, int bottomPadding, int leftPadding) {
    boolean redraw = false;
    if (this.topPadding != topPadding) {
      this.topPadding = topPadding;
      redraw = true;
    }
    if (this.rightPadding != rightPadding) {
      this.rightPadding = rightPadding;
      redraw = true;
    }
    if (this.bottomPadding != bottomPadding) {
      this.bottomPadding = bottomPadding;
      redraw = true;
    }
    if (this.leftPadding != leftPadding) {
      this.leftPadding = leftPadding;
      redraw = true;
    }
    if (redraw) {
      redraw();
    }
    return this;
  }

  @Override
  protected void onDraw(UI ui, PGraphics pg) {
    pg.textFont(hasFont() ? getFont() : ui.theme.getLabelFont());
    pg.fill(hasFontColor() ? getFontColor() : ui.theme.getLabelColor());
    float tx = this.leftPadding, ty = this.topPadding;
    switch (this.textAlignHorizontal) {
    case PConstants.CENTER:
      tx = this.width / 2;
      break;
    case PConstants.RIGHT:
      tx = this.width - this.rightPadding;
      break;
    }
    switch (this.textAlignVertical) {
    case PConstants.BASELINE:
      ty = this.height - this.bottomPadding;
      break;
    case PConstants.BOTTOM:
      ty = this.height - this.bottomPadding;
      break;
    case PConstants.CENTER:
      ty = this.height / 2;
      break;
    }
    String str = clipTextToWidth(pg, this.label, this.width - this.leftPadding - this.rightPadding);
    pg.textAlign(this.textAlignHorizontal, this.textAlignVertical);
    pg.text(str, tx + this.textOffsetX, ty + this.textOffsetY);
  }

  public UILabel setLabel(String label) {
    if (this.label != label) {
      this.label = label;
      redraw();
    }
    return this;
  }

  @Override
  public String getDescription() {
    return this.label;
  }
}
