#---------------------------------------------------------------
from libqtile import bar, layout, qtile, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.widget import backlight, Spacer
from libqtile.log_utils import logger

from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

import os
import time
import subprocess
import asyncio

#----------------------------------------------------------------
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])

@hook.subscribe.startup
def _():
    mybar.window.window.set_property("QTILE_BAR", 1, "CARDINAL", 32)

@lazy.function
def float_to_front(qtile):
   # logging.info("bring floating windows to front")
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.bring_to_front()

@lazy.function
def minimize(qtile):
    for window in qtile.current_group.windows:
        if window.minimized:
            window.minimized = False
            window.focus()
            return

@hook.subscribe.client_managed
def _screen1(window):
    wm_class = window.window.get_wm_class()
    w_name = window.window.get_name()
    if wm_class == ["Steam", "Steam"]:
        if w_name == "好友列表":
            window.kill()
        elif w_name == "Steam - 新闻":
            window.kill()

def move_window_and_switch_group(qtile, direction="right"):
    current_group = qtile.current_group
    groups = [g for g in qtile.groups if g.name != "scratchpad"]
    group_names = [g.name for g in groups]
 
    try:
        idx = group_names.index(current_group.name)
    except ValueError:
        return
 
    if direction == "left":
        target_idx = (idx - 1) % len(group_names)
    elif direction == "right":
        target_idx = (idx + 1) % len(group_names)
    else:
        return
 
    target_group_name = group_names[target_idx]
    win = qtile.current_window
 
    if win:
        # 移动窗口到目标 group（不切屏幕）
        win.togroup(target_group_name, switch_group=False)
 
        # 设置为浮动状态并固定位置大小
        if not win.floating:
            win.toggle_floating()
        win.place(
            x=200, y=150, width=900, height=600,
            borderwidth=2, bordercolor='cc6666'
        )
 
    # 切换屏幕到目标 group
    for screen in qtile.screens:
        if screen.group == current_group:
            qtile.groups_map[target_group_name].toscreen(screen.index)
            break
 
    # 切换 group 后聚焦当前窗口（不然看不到它）
    if win:
        qtile.groups_map[target_group_name].focus(win, warp=True)

#----------------------------------------------------------------
"""
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_repeat_rate=50,
        kb_repeat_delay=300,
    ),
    "type:input_method": InputConfig(
        # 这里可以添加输入法相关的配置
        # 假设你在使用 Fcitx5，可以设置默认输入法为拼音
        # 这里的配置可能会根据你使用的输入法框架而有所不同
        method="fcitx5",
        # 如果需要的话，可以添加更多的选项
    ),
}
"""
#----------------------------------------------------------------
mod = "mod4"
terminal = "kitty"
#terminal = guess_terminal()

keys = [
    # 在窗口间切换 
    Key([mod], "h", lazy.layout.left()), 
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()), 
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "Tab", lazy.layout.next()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),

    # 移动窗口 
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()), 

    # 窗口缩小/放大
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()), 
    Key([mod, "control"], "j", lazy.layout.grow_down(),lazy.layout.grow()),
    Key([mod, "control"], "k", lazy.layout.grow_up(),lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.normalize()),

    #堆栈模式
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
    ),

    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.reload_config()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "d", lazy.spawn("rofi -show drun -theme ~/.config/rofi/themes/mine.rasi")),

    Key(
        ["mod1"], "Tab",
        lazy.spawn("rofi -show window -theme ~/.config/rofi/themes/mine_win.rasi "),
        desc="模拟传统 Alt+Tab 行为"
    ),

    Key(
        [mod], "t",
        lazy.window.toggle_floating(), 
        lazy.window.center(),
        desc="浮动窗口"
    ),                                          
   
    #全屏窗口
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    
    Key([mod], "h", 
        lazy.window.toggle_minimize(), 
        lazy.layout.next(),
        desc="最小化窗口"
        ),
    
    #恢复最小化窗口
    Key([mod, "shift"], "h", minimize),
    
    #浮动窗口置顶
    Key([mod], "a", float_to_front),
    
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
        desc="音量+"
    ),

    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        desc="音量-"
    ),

    Key(
        [mod, "shift"],
        "Left",
        lazy.function(lambda qtile: move_window_and_switch_group(qtile, direction="left")),
        desc="移动窗口到下一个组"
    ),

    Key(
        [mod, "shift"],
        "Right",
        lazy.function(lambda qtile: move_window_and_switch_group(qtile, direction="right")),
        desc="移动窗口到上一个组"
    ),

    #应用快捷键
    Key([mod], "c", lazy.spawn("google-chrome-stable")),
    Key([mod], "F2", lazy.spawn("dolphin")),
    Key([mod], "F1", lazy.spawn("konsole")),
]
#-----------------------------------------------------------------

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
#for vt in range(1, 8):
#    keys.append(
#        Key(
#            ["control", "mod1"],
#            f"f{vt}",
#            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
#            desc=f"Switch to VT{vt}",
#        )
#    )


groups = [
        Group(
            '1',
        ),
        Group(
            '2',
        ),
        Group(
            '3',
        ),
        Group(
            '4',
        ),
        Group(
            '5',
        ),
        Group(
            '6',
        ),
        Group(
            '7',
        ),
        Group(
            '8',
        ),
        Group(
            '9',
            matches=[
                Match(wm_class="clash-verge"),
            ],
        ),
]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

groups.append(ScratchPad("scratchpad",[
    DropDown("term", terminal, width=0.5, height=0.5, x=0.20, y=0.20, opacity=0.9)
]))

keys.extend([
    Key([mod], "z",lazy.group["scratchpad"].dropdown_toggle("term"))
])
#---------------------------------------------------------------
def init_layout_theme():
    return {
            "margin":10,
            "border_focus": "#D08769",
            "border_normal": "#4c566a",
           }
layout_theme = init_layout_theme()


layouts = [
    layout.MonadTall(
        **layout_theme,
        ratio = 0.6,
        #border_focus=RoundedCustomBorder()
    ),
    layout.Max(**layout_theme),
    #layout.Plasma(),
    layout.Matrix(**layout_theme,columns = 3),
]

floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="QQ"),  # QQ
        Match(wm_class="fcitx5-config-qt"),  # 输入法
        Match(wm_class="lxappearance"),  # lxappearance，GTK主
        Match(wm_class="qt5ct"),  # qt5ct，QT主题
        Match(wm_class="qt6ct"),  # qts6ct，QT主题
        Match(wm_class="blueman-manager"),  #蓝牙设置 
        Match(wm_class="nm-connection-editor"),  #蓝牙设置 
        Match(wm_class="pavucontrol"),  # 音频设置
        Match(wm_class="steamwebhelper"),  # steam
        Match(wm_class="steam"),  # steam
        Match(wm_class="clash-verge"),  #clash
    ]
)
#---------------------------------------------------------------
def init_colors():
    return [
            ["00000000","00000000"], # color 0 | 透明
            ["#000000", "#000000"], # color 1 | 黑色
            ["#FFFFFF", "#FFFFFF"], # color 2 | 白色
            ["#4C566A", "#4C566A"], # color 3 | 灰色
            ["#BF616A", "#BF616A"], # color 4 | 红色
            ["#D08770", "#D08770"], # color 5 | 橙色
            ["#EBCB8B", "#EBCB8B"], # color 6 | 黄色
            ["#A3BE8C", "#A3BE8C"], # color 7 | 绿色
            ["#B48EAD", "#B48EAD"], # color 8 | 紫色
            ["#8FBCBB", "#8FBCBB"], # color 9 | 青色
            ["#88C0D0", "#88C0D0"], # color 10 | 水色
            ["#81A1C1", "#81A1C1"], # color 11 | 蓝色
            ["#5E81AC", "#5E81AC"], # color 12 | 海军
            ["#31313D"], # color 13
           ]
colors = init_colors()

widget_defaults = dict(
    font="my_font",
    fontsize=11,
    padding=3,
)
extension_defaults = widget_defaults.copy()

wallpaper = '11.jpg'
my_font = "JetBrainsMono Nerd Font"
my_fontsize = 20
clock_fontsize = 25
background = colors[13]
foreground = colors[2]

def init_widgets_list(secondar=False):
    def init_decor(width=0):
        return {
            "decorations": [
                RectDecoration(
                    use_widget_background = True,
                    colour = colors[0],
                    radius = [8,8,8,8],
                    filled = True,
                    padding_y = 4,
                    padding_x = 0,
                    group = True,
                    clip = True,
                ),
            ],
        }
    decor = init_decor()
    systray_decor = init_decor(width=5)

    widgets_list = [
        widget.Spacer(length=5),
        widget.CurrentLayoutIcon(
            background = background,
            scale = 0.5,
            **decor,
        ),
        widget.GroupBox(
            background = background,
            font = my_font,
            fontsize = my_fontsize,
            disable_drag = True,
            hide_unused = False,
            **decor
        ),
        widget.Spacer(length=5),
        widget.TaskList(
            background = colors[0],
            border = colors[6],
            borderwidth = -3,
            unfocused_border = colors[2],
            foreground = colors[1],
            font = my_font,
            fontsize = 15,
            highlight_method = "block",
            icon_size = 15,
            margin_y = 6,
            margin_x = 3,
            padding_y = 0,
            padding_x = 5,
            spacing = 8,
            stretch = True,
            max_title_width = 200,
            #theme_path="/usr/share/icons/breeze",
            #theme_mode = "preferred",
            **decor,
        ),
        widget.Spacer(length=200),
        #网速显示
        widget.Net(
            background = background,
            foreground = foreground,
            font = my_font,
            fontsize = my_fontsize,
            padding = 0,
            format = '{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}',
            prefix="M",
            **decor
        ),
        widget.Spacer(length=10),
        #系统托盘
        #widget.Systray(
        #    background = "#D08770",
        #    icon_size = 20,
        #    padding = 5,
        #    #**systray_decor,
        #    **decor,
        #    ),
        #widget.StatusNotifier(
        #    background = background,
        #    icon_size = 16,
        #    padding = 3,
        #    **decor,
        #),
        widget.Spacer(length=5),
        #cpu显示
        widget.CPU(
            background = background,
            foreground = foreground,
            font = my_font,
            fontsize = my_fontsize,
            format="CPU{load_percent:2.0f}%",
            padding = 3,
            mouse_callbacks={
                "Button1": 
                lazy.spawn("st -e btop")
            },
            **decor
        ),
        #内存显示
        widget.Memory(
            background = background,
            foreground = foreground,
            font = my_font,
            fontsize = my_fontsize,
            format="|{MemUsed:2.0f}{mm}",
            measure_mem='G',
            padding = 0,
            mouse_callbacks={
                "Button1": 
                lazy.spawn("st -e btop")
            },
            **decor
        ),
        widget.Spacer(length=10),
        #音量显示
        widget.Volume(
            background = background,
            font = my_font,
            fontsize = my_fontsize, 
            emoji = True,
            padding = 0,
            **decor
        ),
        widget.Volume(
            background = background,
            foreground = foreground,
            fontsize = my_fontsize,
            **decor
        ),
        #时间显示
        widget.Clock(
            background = background,
            foreground = foreground,
            font = my_font,
            fontsize = clock_fontsize,
            format = "| %I:%M",
            **decor,
        ),
        widget.Spacer(length=5),
    ]
    return widgets_list

widgets_list = init_widgets_list()

mybar = bar.Bar(widgets_list,30,opacity=0.9,background="00000000")

screens = [Screen(top = mybar)]

#----------------------------------------------------------------------------
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),

    Click(["control"], "Button1", lazy.window.bring_to_front()),
]

#------------------------------------------------------------------------------
dgroups_key_binder = None                                                        
follow_mouse_focus = True
dgroups_app_rules = []  # type: list
bring_front_click = True
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
l_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "qtile"
