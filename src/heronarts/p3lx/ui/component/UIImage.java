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
import processing.core.PGraphics;
import processing.core.PImage;

public class UIImage extends UI2dComponent {

  private final PImage image;

  public UIImage(PImage image) {
    this(image, 0, 0);
  }

  public UIImage(PImage image, float x, float y) {
    super(x, y, image.width, image.height);
    this.image = image;
  }

  @Override
  public void onDraw(UI ui, PGraphics pg) {
    pg.image(this.image, 0, 0, this.width, this.height);
  }

}
