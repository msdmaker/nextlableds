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

import processing.event.KeyEvent;
import processing.event.MouseEvent;

public abstract class UIEventHandler {
  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   */
  protected void onMousePressed(MouseEvent mouseEvent, float mx, float my) {
  }

  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   */
  protected void onMouseReleased(MouseEvent mouseEvent, float mx, float my) {
  }

  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   */
  protected void onMouseClicked(MouseEvent mouseEvent, float mx, float my) {
  }

  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   * @param dx movement in x
   * @param dy movement in y
   */
  protected void onMouseDragged(MouseEvent mouseEvent, float mx, float my, float dx, float dy) {
  }

  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   */
  protected void onMouseMoved(MouseEvent mouseEvent, float mx, float my) {
  }

  /**
   * Subclasses override to receive events when mouse moves over this object
   *
   * @param mouseEvent Mouse Event
   */
  protected void onMouseOver(MouseEvent mouseEvent) {
  }

  /**
   * Subclasses override to receive events when mouse moves out of this object
   *
   * @param mouseEvent Mouse Event
   */
  protected void onMouseOut(MouseEvent mouseEvent) {
  }

  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   * @param delta Amount of wheel movement
   */
  protected void onMouseWheel(MouseEvent mouseEvent, float mx, float my, float delta) {
  }

  /**
   * Subclasses override to receive mouse events
   *
   * @param mouseEvent Mouse event
   * @param mx x-coordinate
   * @param my y-coordinate
   */
  protected void onKeyPressed(KeyEvent keyEvent, char keyChar, int keyCode) {
  }

  /**
   * Subclasses override to receive key events
   *
   * @param keyEvent Key event
   * @param keyChar Key character
   * @param keyCode Key code value
   */
  protected void onKeyReleased(KeyEvent keyEvent, char keyChar, int keyCode) {
  }

  /**
   * Subclasses override to receive key events
   *
   * @param keyEvent Key event
   * @param keyChar Key character
   * @param keyCode Key code value
   */
  protected void onKeyTyped(KeyEvent keyEvent, char keyChar, int keyCode) {
  }

}
