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

package heronarts.p3lx.ui;

import processing.core.PConstants;
import processing.core.PFont;
import processing.core.PGraphics;

public abstract class UI2dComponent extends UIObject {

  /**
   * Position of the object, relative to parent, top left corner
   */
  protected float x;

  /**
   * Position of the object, relative to parent, top left corner
   */
  protected float y;

  /**
   * Width of the object
   */
  protected float width;

  /**
   * Height of the object
   */
  protected float height;

  float scrollX = 0;

  float scrollY = 0;

  private boolean hasBackground = false;

  private int backgroundColor = 0xFF000000;

  private boolean hasBorder = false;

  private int borderColor = 0xFF000000;

  private int borderWeight = 1;

  private int borderRounding = 0;

  private boolean hasFocusColor = false;

  private int focusColor = 0;

  private PFont font = null;

  private boolean hasFontColor = false;

  private int fontColor = 0xff000000;

  protected int textAlignHorizontal = PConstants.LEFT;

  protected int textAlignVertical = PConstants.BASELINE;

  protected int textOffsetX = 0;

  protected int textOffsetY = 0;

  private boolean mappable = true;

  boolean needsRedraw = true;

  boolean childNeedsRedraw = true;

  protected UI2dComponent() {
    this(0, 0, 0, 0);
  }

  protected UI2dComponent(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  @Override
  public UI2dComponent setDescription(String description) {
    return (UI2dComponent) super.setDescription(description);
  }

  /**
   * X position
   *
   * @return x position
   */
  @Override
  public final float getX() {
    return this.x;
  }

  /**
   * Y position
   *
   * @return y position
   */
  @Override
  public final float getY() {
    return this.y;
  }

  /**
   * Width
   *
   * @return width
   */
  @Override
  public final float getWidth() {
    return this.width;
  }

  /**
   * Height
   *
   * @return height
   */
  @Override
  public final float getHeight() {
    return this.height;
  }

  /**
   * Whether the given coordinate, in the parent-space, is contained
   * by this object.
   *
   * @param x X-coordinate in parent's coordinate space
   * @param y Y-coordinate in parent's coordinate space
   * @return Whether this object's bounds contain that point
   */
  @Override
  public boolean contains(float x, float y) {
    return
      (x >= this.x && x < (this.x + this.width)) &&
      (y >= this.y && y < (this.y + this.height));
  }

  /**
   * Set the visibility state of this component
   *
   * @param visible Whether this should be visible
   * @return this
   */
  @Override
  public UIObject setVisible(boolean visible) {
    if (isVisible() != visible) {
      super.setVisible(visible);
      if (this.parent instanceof UI2dContainer) {
        ((UI2dContainer) this.parent).reflow();
      }
      if (visible) {
        redraw();
      } else {
        redrawContainer();
      }
    }
    return this;
  }

  /**
   * Set the position of this component in its parent coordinate space
   *
   * @param x X-position in parents coordinate space
   * @return this
   */
  public UI2dComponent setX(float x) {
    return setPosition(x, this.y);
  }

  /**
   * Set the position of this component in its parent coordinate space
   *
   * @param y Y-position in parents coordinate space
   * @return this
   */
  public UI2dComponent setY(float y) {
    return setPosition(this.x, y);
  }

  /**
   * Set the position of this component in its parent coordinate space
   *
   * @param x X-position in parents coordinate space
   * @param y Y-position in parents coordinate space
   * @return this
   */
  public UI2dComponent setPosition(float x, float y) {
    if ((this.x != x) || (this.y != y)) {
      this.x = x;
      this.y = y;
      if (this.parent instanceof UI2dContainer) {
        ((UI2dContainer) this.parent).reflow();
      }
      redrawContainer();
    }
    return this;
  }

  /**
   * Sets the height of this component
   *
   * @param height Height
   * @return this
   */
  public UI2dComponent setHeight(float height) {
    return setSize(this.width, height);
  }

  /**
   * Sets the width of this component
   *
   * @param width
   * @return Width of this component
   */
  public UI2dComponent setWidth(float width) {
    return setSize(width, this.height);
  }

  /**
   * Set the dimensions of this component
   *
   * @param width Width of component
   * @param height Height of component
   * @return this
   */
  public UI2dComponent setSize(float width, float height) {
    if ((this.width != width) || (this.height != height)) {
      this.width = width;
      this.height = height;
      if (this.parent instanceof UI2dContainer) {
        ((UI2dContainer) this.parent).reflow();
      }
      onResize();
      redrawContainer();
    }
    return this;
  }

  /**
   * Subclasses may override this method, invoked when the component is resized
   */
  protected void onResize() {

  }

  /**
   * Whether this object has a background
   *
   * @return true or false
   */
  public boolean hasBackground() {
    return this.hasBackground;
  }

  /**
   * The background color, if there is a background
   *
   * @return color
   */
  public int getBackgroundColor() {
    return this.backgroundColor;
  }

  /**
   * Sets whether the object has a background
   *
   * @param hasBackground true or false
   * @return this
   */
  public UI2dComponent setBackground(boolean hasBackground) {
    if (this.hasBackground != hasBackground) {
      this.hasBackground = hasBackground;
      redraw();
    }
    return this;
  }

  /**
   * Sets a background color
   *
   * @param backgroundColor color
   * @return this
   */
  public UI2dComponent setBackgroundColor(int backgroundColor) {
    if (!this.hasBackground || (this.backgroundColor != backgroundColor)) {
      this.hasBackground = true;
      this.backgroundColor = backgroundColor;
      redraw();
    }
    return this;
  }

  /**
   * Whether this object has a border
   *
   * @return true or false
   */
  public boolean hasBorder() {
    return this.hasBorder;
  }

  /**
   * Current border color
   *
   * @return color
   */
  public int getBorderColor() {
    return this.borderColor;
  }

  /**
   * The weight of the border
   *
   * @return weight
   */
  public int getBorderWeight() {
    return this.borderWeight;
  }

  /**
   * Sets whether there is a border
   *
   * @param hasBorder true or false
   * @return this
   */
  public UI2dComponent setBorder(boolean hasBorder) {
    if (this.hasBorder != hasBorder) {
      this.hasBorder = hasBorder;
      redraw();
    }
    return this;
  }

  /**
   * Sets the color of the border
   *
   * @param borderColor color
   * @return this
   */
  public UI2dComponent setBorderColor(int borderColor) {
    if (!this.hasBorder || (this.borderColor != borderColor)) {
      this.hasBorder = true;
      this.borderColor = borderColor;
      redraw();
    }
    return this;
  }

  /**
   * Sets the weight of the border
   *
   * @param borderWeight weight
   * @return this
   */
  public UI2dComponent setBorderWeight(int borderWeight) {
    if (!this.hasBorder || (this.borderWeight != borderWeight)) {
      this.hasBorder = true;
      this.borderWeight = borderWeight;
      redraw();
    }
    return this;
  }

  public UI2dComponent setBorderRounding(int borderRounding) {
    if (this.borderRounding != borderRounding) {
      this.borderRounding = borderRounding;
      redraw();
    }
    return this;
  }

  public UI2dComponent setFocusColor(int focusColor) {
    this.hasFocusColor = true;
    this.focusColor = focusColor;
    return this;
  }

  /**
   * Whether a font is set on this object
   *
   * @return true or false
   */
  public boolean hasFont() {
    return this.font != null;
  }

  /**
   * Get default font, may be null
   *
   * @return The default font, or null
   */
  public PFont getFont() {
    return this.font;
  }

  /**
   * Sets the default font for this object to use, null indicates component may
   * use its own default behavior.
   *
   * @param font Font
   * @return this
   */
  public UI2dComponent setFont(PFont font) {
    if (this.font != font) {
      this.font = font;
      redraw();
    }
    return this;
  }

  /**
   * Whether this object has a specific color
   *
   * @return true or false
   */
  public boolean hasFontColor() {
    return this.hasFontColor;
  }

  /**
   * The font color, if there is a color specified
   *
   * @return color
   */
  public int getFontColor() {
    return this.fontColor;
  }

  /**
   * Sets whether the object has a font color
   *
   * @param hasFontColor true or false
   * @return this
   */
  public UI2dComponent setFontColor(boolean hasFontColor) {
    if (this.hasFontColor != hasFontColor) {
      this.hasFontColor = hasFontColor;
      redraw();
    }
    return this;
  }

  /**
   * Sets a font color
   *
   * @param fontColor color
   * @return this
   */
  public UI2dComponent setFontColor(int fontColor) {
    if (!this.hasFontColor|| (this.fontColor != fontColor)) {
      this.hasFontColor = true;
      this.fontColor = fontColor;
      redraw();
    }
    return this;
  }

  /**
   * Sets the text alignment
   *
   * @param horizontalAlignment From PConstants LEFT/RIGHT/CENTER
   * @return this
   */
  public UI2dComponent setTextAlignment(int horizontalAlignment) {
    return setTextAlignment(horizontalAlignment, this.textAlignVertical);
  }

  /**
   * Sets an offset for text rendering position relative to alignment. Note that
   * adherence to this offset is not strictly enforced by all subclasses, it is
   * up to them to implement it.
   *
   * @param textOffsetX
   * @param textOffsetY
   * @return this
   */
  public UI2dComponent setTextOffset(int textOffsetX, int textOffsetY) {
    if (this.textOffsetX != textOffsetX || this.textOffsetY != textOffsetY) {
      this.textOffsetX = textOffsetX;
      this.textOffsetY = textOffsetY;
      redraw();
    }
    return this;
  }

  /**
   * Sets the text alignment of this component
   *
   * @param horizontalAlignment From PConstants LEFT/RIGHT/CENTER
   * @param verticalAlignment From PConstants TOP/BOTTOM/BASELINE/CENTER
   * @return
   */
  public UI2dComponent setTextAlignment(int horizontalAlignment, int verticalAlignment) {
    if (this.textAlignHorizontal != horizontalAlignment ||
        this.textAlignVertical != verticalAlignment) {
        this.textAlignHorizontal = horizontalAlignment;
        this.textAlignVertical = verticalAlignment;
        redraw();
    }
    return this;
  }

  /**
   * Clip a text to fit in the given width
   *
   * @param pg PGraphics
   * @param str String
   * @param width Width to fit in
   * @return
   */
  public static String clipTextToWidth(PGraphics pg, String str, float width) {
    while (str.length() > 0 && pg.textWidth(str) > width) {
      str = str.substring(0, str.length() - 1);
    }
    return str;
  }

  /**
   * Sets whether this component can ever be used for mapping control
   *
   * @param mappable
   * @return
   */
  public UI2dComponent setMappable(boolean mappable) {
    this.mappable = mappable;
    return this;
  }

  protected boolean isMappable() {
    return this.mappable;
  }

  /**
   * Removes this components from the container is is held by
   *
   * @return this
   */
  public UI2dComponent removeFromContainer() {
    if (this.parent == null) {
      throw new IllegalStateException("Cannot remove parentless UIObject from container");
    }
    if (hasFocus()) {
      blur();
    }
    this.parent.mutableChildren.remove(this);
    if (this.parent instanceof UI2dContainer) {
      ((UI2dContainer) this.parent).reflow();
    }
    redrawContainer();
    this.parent = null;
    return this;
  }

  /**
   * Get the parent object that this is in
   *
   * @return
   */
  @Override
  public UIObject getParent() {
    return this.parent;
  }

  /**
   * Returns the 2d container that this is in
   *
   * @return
   */
  public UI2dContainer getContainer() {
    return (UI2dContainer) this.parent;
  }

  /**
   * Adds this component to a container, also removing it from any other container that
   * is currently holding it.
   *
   * @param container Container to place in
   * @return this
   */
  public final UI2dComponent addToContainer(UIContainer container) {
    return addToContainer(container, -1);
  }

  /**
   * Adds this component to a container at a specified index, also removing it from any
   * other container that is currently holding it.
   *
   * @param container Container to place in
   * @return this
   */
  public UI2dComponent addToContainer(UIContainer container, int index) {
    if (this.parent != null) {
      removeFromContainer();
    }
    UIObject containerObject = container.getContentTarget();
    if (containerObject == this) {
      throw new IllegalArgumentException("Cannot add an object to itself");
    }
    if (index < 0) {
      containerObject.mutableChildren.add(this);
    } else {
      containerObject.mutableChildren.add(index, this);
    }
    this.parent = containerObject;
    setUI(containerObject.ui);
    if (this.parent instanceof UI2dContainer) {
      ((UI2dContainer) this.parent).reflow();
    }
    redraw();
    return this;
  }

  /**
   * Sets the index of this object in its container.
   *
   * @param index Desired index
   * @return this
   */
  public UI2dComponent setContainerIndex(int index) {
    if (this.parent == null) {
      throw new UnsupportedOperationException("Cannot setContainerIndex() on an object not in a container");
    }
    this.parent.mutableChildren.remove(this);
    this.parent.mutableChildren.add(index, this);
    if (this.parent instanceof UI2dContainer) {
      ((UI2dContainer) this.parent).reflow();
    }
    redrawContainer();
    return this;
  }

  /**
   * Redraws this object.
   *
   * @return this object
   */
  public final UI2dComponent redraw() {
    if (this.ui != null && this.parent != null && this.isVisible()) {
      this.ui.redraw(this);
    }
    return this;
  }

  private void redrawContainer() {
    if ((this.parent != null) && (this.parent instanceof UI2dComponent)) {
      ((UI2dComponent) this.parent).redraw();
    }
  }

  final void _redraw() {
    // Mark object and children as needing redraw
    _redrawChildren();

    // Mark parent containers as needing a child redrawn
    UIObject p = this.parent;
    while ((p != null) && (p instanceof UI2dComponent)) {
      UI2dComponent p2d = (UI2dComponent) p;
      p2d.childNeedsRedraw = true;
      p = p2d.parent;
    }
  }

  /**
   * Internal helper. Marks this object and all of its children as needing to be
   * redrawn.
   */
  private final void _redrawChildren() {
    this.needsRedraw = true;
    this.childNeedsRedraw = (this.mutableChildren.size() > 0);
    for (UIObject child : this.mutableChildren) {
      ((UI2dComponent)child)._redrawChildren();
    }
  }

  /**
   * Draws this object to the graphics context.
   *
   * @param ui UI
   * @param pg graphics buffer
   */
  @Override
  void draw(UI ui, PGraphics pg) {
    if (!isVisible()) {
      return;
    }
    boolean needsBorder = this.needsRedraw || this.childNeedsRedraw;
    boolean needsMappingOverlay = this.needsRedraw;
    float sx = this.scrollX;
    float sy = this.scrollY;
    if (this.needsRedraw) {
      this.needsRedraw = false;
      drawBackground(ui, pg);
      pg.translate(sx, sy);
      onDraw(ui, pg);
      pg.translate(-sx, -sy);
    }
    if (this.childNeedsRedraw) {
      this.childNeedsRedraw = false;
      pg.translate(sx, sy);
      for (UIObject childObject : this.mutableChildren) {
        UI2dComponent child = (UI2dComponent) childObject;
        if (child.needsRedraw || child.childNeedsRedraw) {
          float cx = child.x;
          float cy = child.y;
          pg.translate(cx, cy);
          child.draw(ui, pg);
          pg.translate(-cx, -cy);
          if (child.needsRedraw && !needsMappingOverlay) {
            drawMappingOverlay(ui, pg, cx, cy, child.width, child.height);
          }
        }
      }
      pg.translate(-sx, -sy);
    }
    if (needsBorder) {
      drawBorder(ui, pg);
      if (isModulationSource() || isTriggerSource()) {
        pg.noFill();
        pg.stroke(0xff000000 | ui.theme.getModulationTargetMappingColor());
        pg.rect(0, 0, this.width-1, this.height-1, this.borderRounding);
      }
    }
    if (needsMappingOverlay) {
      drawMappingOverlay(ui, pg, 0, 0, this.width, this.height);
    }
  }

  private void drawMappingOverlay(UI ui, PGraphics pg, float x, float y, float w, float h) {
    if (isModulationSource() || isTriggerSource()) {
      // Do nothing!
    } else if (isMidiMapping()) {
      pg.noStroke();
      pg.fill(ui.theme.getMidiMappingColor());
      pg.rect(x, y, w, h);
      if (isControlTarget()) {
        drawFocus(ui, pg, 0xccff0000);
      }
    } else if (isModulationSourceMapping() || isTriggerSourceMapping()) {
      pg.noStroke();
      pg.fill(ui.theme.getModulationSourceMappingColor());
      pg.rect(x, y, w, h);
    } else if (isModulationTargetMapping() || isTriggerTargetMapping()) {
      pg.noStroke();
      pg.fill(ui.theme.getModulationTargetMappingColor());
      pg.rect(x, y, w, h);
    }
  }

  private void drawBackground(UI ui, PGraphics pg) {
    if (!this.hasBackground || (this.borderRounding > 0)) {
      // If we don't have our own background, or our borders are rounded,
      // then we need to walk up the UI tree to figure out how to paint
      // in the background.
      UIObject component = this.parent;
      while ((component != null) && (component instanceof UI2dComponent)) {
        UI2dComponent component2d = (UI2dComponent) component;
        if (component2d.hasBackground) {
          pg.noStroke();
          pg.fill(component2d.backgroundColor);
          pg.rect(0, 0, this.width, this.height);
          break;
        }
        component = component.parent;
      }
    }

    if (this.hasBackground) {
      pg.noStroke();
      pg.fill(this.backgroundColor);
      pg.rect(0, 0, this.width, this.height, this.borderRounding);
    }

  }

  protected void drawBorder(UI ui, PGraphics pg) {
    if (this.hasBorder) {
      int border = this.borderWeight;
      pg.strokeWeight(border);
      pg.stroke(this.borderColor);
      pg.noFill();
      pg.rect(border / 2, border / 2, this.width - border, this.height - border, this.borderRounding);

      // Reset stroke weight
      pg.strokeWeight(1);
    }
    if (hasFocus() && (this instanceof UIFocus)) {
      drawFocus(ui, pg);
    }
  }

  protected int getFocusColor(UI ui) {
    return this.hasFocusColor ? this.focusColor : ui.theme.getFocusColor();
  }

  /**
   * Focus size for hashes drawn on the outline of the object. May be overridden.
   *
   * @return Focus hash line size
   */
  protected int getFocusSize() {
    return (int) Math.min(8, Math.min(this.width, this.height) / 8);
  }

  /**
   * Draws focus on this object. May be overridden by subclasses.
   *
   * @param ui UI
   * @param pg PGraphics
   */
  protected void drawFocus(UI ui, PGraphics pg) {
    drawFocus(ui, pg, getFocusColor(ui));
  }

  protected void drawFocus(UI ui, PGraphics pg, int color) {
    drawFocus(ui, pg, color, 0, 0, this.width, this.height, getFocusSize());
  }

  public static void drawFocus(UI ui, PGraphics pg, int color, float x, float y, float width, float height, int focusSize) {
    pg.stroke(color);
    pg.noFill();
    // Top left
    pg.line(x, y, x + focusSize, y);
    pg.line(x, y, x, y + focusSize);
    // Top right
    pg.line(x + width - focusSize - 1, y, x + width - 1, y);
    pg.line(x + width - 1, y, x + width - 1, y + focusSize);
    // Bottom right
    pg.line(x + width - focusSize - 1, y + height - 1, x + width - 1, y + height - 1);
    pg.line(x + width - 1, y + height - 1, x + width - 1, y + height - 1 - focusSize);
    // Bottom left
    pg.line(x, y + height - 1, x + focusSize, y + height - 1);
    pg.line(x, y + height - 1, x, y + height - 1 - focusSize);
  }

}
