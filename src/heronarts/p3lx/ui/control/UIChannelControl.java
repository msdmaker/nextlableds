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

package heronarts.p3lx.ui.control;

import heronarts.lx.LX;
import heronarts.lx.LXChannel;
import heronarts.lx.LXPattern;
import heronarts.lx.parameter.LXListenableNormalizedParameter;
import heronarts.lx.parameter.LXParameter;
import heronarts.p3lx.ui.UI;
import heronarts.p3lx.ui.UIWindow;
import heronarts.p3lx.ui.component.UIButton;
import heronarts.p3lx.ui.component.UIItemList;
import heronarts.p3lx.ui.component.UIKnob;

import java.util.ArrayList;
import java.util.List;

public class UIChannelControl extends UIWindow {

  private final static String DEFAULT_TITLE = "PATTERN";
  private final static int DEFAULT_NUM_KNOBS = 12;
  private final static int KNOBS_PER_ROW = 4;
  private final static int KNOB_ROW_HEIGHT = 48;
  private final static int BASE_HEIGHT = 174;
  public final static int WIDTH = 140;

  private final LXChannel channel;

  public UIChannelControl(UI ui, LX lx, float x, float y) {
    this(ui, lx, DEFAULT_TITLE, x, y);
  }

  public UIChannelControl(UI ui, LX lx, int numKnobs, float x, float y) {
    this(ui, lx.engine.getChannel(0), numKnobs, x, y);
  }

  public UIChannelControl(UI ui, LX lx, String label, float x, float y) {
    this(ui, lx.engine.getChannel(0), label, x, y);
  }

  public UIChannelControl(UI ui, LX lx, String label, int numKnobs, float x, float y) {
    this(ui, lx.engine.getChannel(0), label, numKnobs, x, y);
  }

  public UIChannelControl(UI ui, LXChannel channel, int numKnobs, float x, float y) {
    this(ui, channel, DEFAULT_TITLE, numKnobs, x, y);
  }

  public UIChannelControl(UI ui, LXChannel channel, float x, float y) {
    this(ui, channel, DEFAULT_TITLE, x, y);
  }

  public UIChannelControl(UI ui, LXChannel channel, String label, float x, float y) {
    this(ui, channel, label, DEFAULT_NUM_KNOBS, x, y);
  }

  public UIChannelControl(UI ui, LXChannel channel, String label, int numKnobs, float x, float y) {
    super(ui, label, x, y, WIDTH, BASE_HEIGHT + KNOB_ROW_HEIGHT * (numKnobs / KNOBS_PER_ROW));

    this.channel = channel;
    int yp = TITLE_LABEL_HEIGHT;

    new UIButton(width-18, 4, 14, 14)
    .setParameter(channel.autoCycleEnabled)
    .setLabel("A")
    .setActiveColor(ui.theme.getControlBackgroundColor())
    .addToContainer(this);

    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    for (LXPattern p : channel.getPatterns()) {
      items.add(new PatternScrollItem(p));
    }
    final UIItemList.ScrollList patternList = new UIItemList.ScrollList(ui, 1, yp, this.width - 2, 140);
    patternList.setItems(items);
    patternList
    .setBackgroundColor(ui.theme.getDeviceBackgroundColor())
    .addToContainer(this);
    yp += patternList.getHeight() + 10;

    final UIKnob[] knobs = new UIKnob[numKnobs];
    for (int ki = 0; ki < knobs.length; ++ki) {
      knobs[ki] = new UIKnob(5 + 34 * (ki % KNOBS_PER_ROW), yp
          + (ki / KNOBS_PER_ROW) * KNOB_ROW_HEIGHT);
      knobs[ki].addToContainer(this);
    }

    LXChannel.Listener lxListener = new LXChannel.AbstractListener() {
      @Override
      public void patternWillChange(LXChannel channel, LXPattern pattern, LXPattern nextPattern) {
        patternList.redraw();
      }

      @Override
      public void patternDidChange(LXChannel channel, LXPattern pattern) {
        patternList.redraw();
        int pi = 0;
        for (LXParameter parameter : pattern.getParameters()) {
          if (pi >= knobs.length) {
            break;
          }
          if (parameter instanceof LXListenableNormalizedParameter) {
            knobs[pi++].setParameter((LXListenableNormalizedParameter) parameter);
          }
        }
        while (pi < knobs.length) {
          knobs[pi++].setParameter(null);
        }
      }
    };

    channel.addListener(lxListener);
    lxListener.patternDidChange(channel, channel.getActivePattern());
  }

  private class PatternScrollItem extends UIItemList.AbstractItem {

    private LXPattern pattern;

    PatternScrollItem(LXPattern pattern) {
      this.pattern = pattern;
    }

    @Override
    public String getLabel() {
      return this.pattern.getLabel();
    }

    @Override
    public boolean isActive() {
      return
        (channel.getActivePattern() == this.pattern) ||
        (channel.getNextPattern() == this.pattern);
    }

    @Override
    public int getActiveColor(UI ui) {
      return (channel.getActivePattern() == this.pattern) ? ui.theme.getPrimaryColor() : ui.theme.getSecondaryColor();
    }

    @Override
    public void onActivate() {
      channel.goPattern(this.pattern);
    }
  }
}
