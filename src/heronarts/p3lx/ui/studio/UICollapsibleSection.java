/**
 * Copyright 2017- Mark C. Slee, Heron Arts LLC
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

package heronarts.p3lx.ui.studio;

import heronarts.p3lx.ui.UI;
import heronarts.p3lx.ui.UI2dContainer;
import heronarts.p3lx.ui.UIMouseFocus;
import heronarts.p3lx.ui.component.UILabel;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.event.MouseEvent;

/**
 * Section with a title which can collapse/expand
 */
public class UICollapsibleSection extends UI2dContainer implements UIMouseFocus {

  private static final int PADDING = 4;
  private static final int TITLE_LABEL_HEIGHT = 12;
  private static final int CHEVRON_PADDING = 20;
  private static final int CLOSED_HEIGHT = TITLE_LABEL_HEIGHT + 2*PADDING;
  private static final int CONTENT_Y = CLOSED_HEIGHT;

  private final UILabel title;
  private boolean expanded = true;
  private float expandedHeight;

  private final UI2dContainer content;

  /**
   * Constructs a new collapsible section
   *
   * @param ui UI
   * @param x Xpos
   * @param y Ypos
   * @param w Width
   * @param h Height
   */
  public UICollapsibleSection(UI ui, float x, float y, float w, float h) {
    super(x, y, w, h);
    setBackgroundColor(ui.theme.getDeviceBackgroundColor());
    setBorderRounding(4);

    this.title = new UILabel(PADDING, PADDING + 1, this.width - PADDING - CHEVRON_PADDING, TITLE_LABEL_HEIGHT);
    this.title.setTextAlignment(PConstants.LEFT, PConstants.TOP).setTextOffset(0,  1);
    addTopLevelComponent(this.title);

    setHeight(this.expandedHeight = (int) Math.max(CLOSED_HEIGHT, h));
    this.content = new UI2dContainer(PADDING, CONTENT_Y, this.width - 2*PADDING, Math.max(0, this.expandedHeight - PADDING - CONTENT_Y)) {
      @Override
      public void onResize() {
        expandedHeight = (this.height <= 0 ? CLOSED_HEIGHT : CONTENT_Y + this.height + PADDING);
        if (expanded) {
          UICollapsibleSection.this.setHeight(expandedHeight);
        }
      }
    };
    setContentTarget(this.content);
  }

  public boolean isExpanded() {
    return this.expanded;
  }

  protected UICollapsibleSection setTitleX(float x) {
    this.title.setX(x);
    this.title.setWidth(this.width - CHEVRON_PADDING - x);
    return this;
  }

  /**
   * Sets the title of the section
   *
   * @param title Title
   * @return this
   */
  public UICollapsibleSection setTitle(String title) {
    this.title.setLabel(title);
    return this;
  }

  @Override
  public void onDraw(UI ui, PGraphics pg) {
    pg.noStroke();
    pg.fill(0xff333333);
    pg.rect(width-16, PADDING, 12, 12, 4);
    pg.fill(ui.theme.getControlTextColor());
    if (this.expanded) {
      pg.beginShape();
      pg.vertex(this.width-7, 9);
      pg.vertex(this.width-13, 9);
      pg.vertex(this.width-10, 13);
      pg.endShape(PConstants.CLOSE);
    } else {
      pg.ellipseMode(PConstants.CENTER);
      pg.ellipse(width-10, 10, 4, 4);
    }
  }

  /**
   * Toggles the expansion state of the section
   *
   * @return this
   */
  public UICollapsibleSection toggle() {
    return setExpanded(!this.expanded);
  }

  /**
   * Sets the expanded state of this section
   * @param expanded
   * @return this
   */
  public UICollapsibleSection setExpanded(boolean expanded) {
    if (this.expanded != expanded) {
      this.expanded = expanded;
      this.content.setVisible(this.expanded);
      setHeight(this.expanded ? this.expandedHeight : CLOSED_HEIGHT);
      redraw();
    }
    return this;
  }

  @Override
  public void onMousePressed(MouseEvent mouseEvent, float mx, float my) {
    if (my < CONTENT_Y) {
      if ((mx >= this.width - CHEVRON_PADDING) || (mx >= this.title.getX() && mouseEvent.getCount() == 2)) {
        toggle();
      }
    }
  }

  @Override
  public UI2dContainer getContentTarget() {
    return this.content;
  }
}
