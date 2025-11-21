#!/bin/bash

set -euo pipefail

THEME_NAME="GlitchSec"
RED_ACCENT="#FF0033"
DARK_RED="#330000"
GLITCH_GREY="#1a1a1a"
ACCENT_GREY="#2d2d2d"

echo "[*] Security-Focused KDE Desktop Environment Setup"
echo "[*] Theme: Glitchy Red/Black Aesthetic"
echo ""

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "[!] This script must be run as root"
        exit 1
    fi
}

install_dependencies() {
    echo "[*] Installing KDE and security dependencies..."
    pacman -S --needed --noconfirm \
        plasma-meta \
        kde-applications-meta \
        kvantum \
        latte-dock \
        kwin-effects-cube \
        kwin-scripts-forceblur \
        papirus-icon-theme \
        ttf-fira-code \
        ttf-hack \
        audit \
        auditd \
        aide \
        clamav \
        rkhunter \
        chkrootkit \
        firejail \
        apparmor \
        lynis \
        unhide \
        tiger \
        checksec \
        fail2ban
}

setup_file_auditing() {
    echo "[*] Configuring comprehensive file auditing..."
    
    systemctl enable auditd
    systemctl start auditd
    
    cat > /etc/audit/rules.d/security-audit.rules << 'EOF'
-D
-b 8192
-f 1

-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/sudoers -p wa -k sudoers
-w /etc/sudoers.d/ -p wa -k sudoers

-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
-w /var/run/utmp -p wa -k session

-w /bin/ -p wa -k binaries
-w /sbin/ -p wa -k binaries
-w /usr/bin/ -p wa -k binaries
-w /usr/sbin/ -p wa -k binaries
-w /usr/local/bin/ -p wa -k binaries
-w /usr/local/sbin/ -p wa -k binaries

-w /boot/ -p wa -k boot
-w /etc/modprobe.d/ -p wa -k modules
-w /etc/modules-load.d/ -p wa -k modules

-a always,exit -F arch=b64 -S execve -k exec
-a always,exit -F arch=b32 -S execve -k exec

-a always,exit -F arch=b64 -S open,openat,truncate,ftruncate -F exit=-EACCES -k access
-a always,exit -F arch=b64 -S open,openat,truncate,ftruncate -F exit=-EPERM -k access

-w /etc/ssh/sshd_config -p wa -k sshd
-w /etc/ssh/ssh_config -p wa -k ssh

-a always,exit -F arch=b64 -S mount,umount2 -k mounts
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -k delete

-w /etc/apparmor/ -p wa -k apparmor
-w /etc/apparmor.d/ -p wa -k apparmor

-e 2
EOF

    augenrules --load
    
    echo "[*] Setting up real-time audit monitoring..."
    cat > /usr/local/bin/audit-monitor.sh << 'EOF'
#!/bin/bash
ausearch -ts recent -i | while read -r line; do
    echo "[AUDIT] $(date '+%Y-%m-%d %H:%M:%S') - $line" >> /var/log/security-audit-monitor.log
done
EOF
    chmod +x /usr/local/bin/audit-monitor.sh
    
    cat > /etc/systemd/system/audit-monitor.timer << 'EOF'
[Unit]
Description=Run audit monitor every 5 minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
EOF

    cat > /etc/systemd/system/audit-monitor.service << 'EOF'
[Unit]
Description=Security Audit Monitor

[Service]
Type=oneshot
ExecStart=/usr/local/bin/audit-monitor.sh
EOF

    systemctl enable audit-monitor.timer
    systemctl start audit-monitor.timer
}

setup_apparmor() {
    echo "[*] Configuring AppArmor mandatory access control..."
    systemctl enable apparmor
    systemctl start apparmor
    
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 apparmor=1 security=apparmor"/' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
}

create_glitch_theme() {
    echo "[*] Creating custom Glitch Security KDE theme..."
    
    THEME_DIR="/usr/share/plasma/desktoptheme/$THEME_NAME"
    mkdir -p "$THEME_DIR"
    
    cat > "$THEME_DIR/metadata.desktop" << EOF
[Desktop Entry]
Name=$THEME_NAME
Comment=Glitchy Red Security Theme
X-KDE-PluginInfo-Author=SecurityArch
X-KDE-PluginInfo-Email=security@arch
X-KDE-PluginInfo-Name=$THEME_NAME
X-KDE-PluginInfo-Version=1.0
X-KDE-PluginInfo-Website=
X-KDE-PluginInfo-License=GPL
X-Plasma-API=5.0
EOF

    mkdir -p "$THEME_DIR/colors"
    cat > "$THEME_DIR/colors/colors" << EOF
[ColorEffects:Disabled]
Color=56,56,56
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65
ContrastEffect=1
IntensityAmount=0.1
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=112,111,110
ColorAmount=0.025
ColorEffect=2
ContrastAmount=0.1
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate=$ACCENT_GREY
BackgroundNormal=$GLITCH_GREY
DecorationFocus=$RED_ACCENT
DecorationHover=$RED_ACCENT
ForegroundActive=$RED_ACCENT
ForegroundInactive=120,120,120
ForegroundLink=$RED_ACCENT
ForegroundNegative=255,0,0
ForegroundNeutral=255,170,0
ForegroundNormal=220,220,220
ForegroundPositive=0,255,0
ForegroundVisited=150,0,0

[Colors:Selection]
BackgroundAlternate=$RED_ACCENT
BackgroundNormal=$RED_ACCENT
DecorationFocus=$RED_ACCENT
DecorationHover=$RED_ACCENT
ForegroundActive=255,255,255
ForegroundInactive=220,220,220
ForegroundLink=255,255,255
ForegroundNegative=255,0,0
ForegroundNeutral=255,170,0
ForegroundNormal=255,255,255
ForegroundPositive=0,255,0
ForegroundVisited=150,0,0

[Colors:Tooltip]
BackgroundAlternate=$DARK_RED
BackgroundNormal=$GLITCH_GREY
DecorationFocus=$RED_ACCENT
DecorationHover=$RED_ACCENT
ForegroundActive=$RED_ACCENT
ForegroundInactive=120,120,120
ForegroundLink=$RED_ACCENT
ForegroundNegative=255,0,0
ForegroundNeutral=255,170,0
ForegroundNormal=220,220,220
ForegroundPositive=0,255,0
ForegroundVisited=150,0,0

[Colors:View]
BackgroundAlternate=$GLITCH_GREY
BackgroundNormal=$DARK_RED
DecorationFocus=$RED_ACCENT
DecorationHover=$RED_ACCENT
ForegroundActive=$RED_ACCENT
ForegroundInactive=120,120,120
ForegroundLink=$RED_ACCENT
ForegroundNegative=255,0,0
ForegroundNeutral=255,170,0
ForegroundNormal=220,220,220
ForegroundPositive=0,255,0
ForegroundVisited=150,0,0

[Colors:Window]
BackgroundAlternate=$ACCENT_GREY
BackgroundNormal=$GLITCH_GREY
DecorationFocus=$RED_ACCENT
DecorationHover=$RED_ACCENT
ForegroundActive=$RED_ACCENT
ForegroundInactive=120,120,120
ForegroundLink=$RED_ACCENT
ForegroundNegative=255,0,0
ForegroundNeutral=255,170,0
ForegroundNormal=220,220,220
ForegroundPositive=0,255,0
ForegroundVisited=150,0,0

[General]
ColorScheme=$THEME_NAME
Name=$THEME_NAME
shadeSortColumn=true

[WM]
activeBackground=$GLITCH_GREY
activeBlend=$RED_ACCENT
activeForeground=220,220,220
inactiveBackground=$DARK_RED
inactiveBlend=$ACCENT_GREY
inactiveForeground=120,120,120
EOF
}

setup_kwin_effects() {
    echo "[*] Configuring unique KDE window effects..."
    
    cat > /tmp/kwin-glitch-config.js << 'EOF'
var config = {
    "wobblyWindows": true,
    "cubeEffect": true,
    "desktopCube": true,
    "glitchEffect": true,
    "blurEffect": true,
    "fadeEffect": true,
    "slideEffect": true
};

workspace.setOption("AnimationSpeed", 3);
workspace.setOption("BorderlessMaximizedWindows", true);
EOF

    mkdir -p /etc/skel/.config
    cat > /etc/skel/.config/kwinrc << EOF
[Compositing]
AnimationSpeed=3
Backend=OpenGL
Enabled=true
GLCore=true
GLPreferBufferSwap=a
GLTextureFilter=2
HiddenPreviews=5
OpenGLIsUnsafe=false
WindowsBlockCompositing=false

[Effect-Blur]
BlurStrength=10
NoiseStrength=5

[Effect-CoverSwitch]
TabBox=true
TabBoxAlternative=false

[Effect-DesktopGrid]
BorderActivate=9

[Effect-PresentWindows]
BorderActivateAll=9

[Effect-Slide]
Duration=200
HorizontalGap=0
SlideBackground=true
VerticalGap=0

[Effect-Wobbly]
AdvancedMode=false
Drag=85
MoveFactor=10
Stiffness=10
WobblynessLevel=1

[Plugins]
blurEnabled=true
contrastEnabled=true
coverswitchEnabled=true
cubeEnabled=true
desktopchangeosdEnabled=true
desktopgridEnabled=true
diminactiveEnabled=true
fadeEnabled=true
glideEnabled=true
kwin4_effect_fadeEnabled=true
kwin4_effect_translucencyEnabled=true
magiclampEnabled=true
minimizeanimationEnabled=true
presentwindowsEnabled=true
scaleEnabled=true
slideEnabled=true
slidingpopupsEnabled=true
synchronizeskipswitcherEnabled=false
translucencyEnabled=true
windowgeometryEnabled=false
wobblywindowsEnabled=true
zoomEnabled=true

[Windows]
BorderlessMaximizedWindows=true
ElectricBorderCooldown=350
ElectricBorderCornerRatio=0.25
ElectricBorderDelay=150
ElectricBorderMaximize=true
ElectricBorderTiling=true
ElectricBorders=1
FocusPolicy=FocusFollowsMouse
FocusStealingPreventionLevel=2
NextFocusPrefersMouse=false
RollOverDesktops=true
SeparateScreenFocus=false
EOF
}

setup_latte_dock() {
    echo "[*] Setting up Latte Dock with glitch theme..."
    
    mkdir -p /etc/skel/.config/latte
    cat > /etc/skel/.config/latte/Default.layout.latte << EOF
[Containments][1]
activityId=
byPassWM=true
dockWindowBehavior=true
enableKWinEdges=true
formfactor=2
immutability=1
isPreferredForShortcuts=false
lastScreen=-1
location=3
onPrimary=true
plugin=org.kde.latte.containment
raiseOnActivityChange=false
raiseOnDesktopChange=false
timerHide=700
timerShow=200
viewType=0
visibility=2
wallpaperplugin=org.kde.image

[Containments][1][Applets][2]
immutability=1
plugin=org.kde.latte.plasmoid

[Containments][1][Applets][2][Configuration]
PreloadWeight=0

[Containments][1][Applets][2][Configuration][General]
animationSpeed=2
glowOption=1
iconSize=64
shadowSize=35
shadows=All
threeColorsWindows=true
titleTooltips=true

[Containments][1][ConfigDialog]
DialogHeight=600
DialogWidth=800

[Containments][1][General]
advanced=true
alignmentUpgraded=true
animationsSpeed=2
appletOrder=2
autoDecreaseIconSize=false
backgroundAllCorners=true
backgroundOnlyOnMaximized=false
blurEnabled=true
durationTime=x3
glowOption=1
iconSize=56
inConfigureAppletsMode=true
lengthExtMargin=5
panelOutline=true
panelShadows=true
panelSize=100
panelTransparency=80
shadowOpacity=60
shadowSize=45
shadows=All
splitterPosition=3
splitterPosition2=4
tasksUpgraded=true
themeColors=SmartThemeColors
titleTooltips=true
zoomLevel=8
EOF
}

setup_security_dashboard() {
    echo "[*] Creating security monitoring dashboard widget..."
    
    mkdir -p /etc/skel/.local/share/plasma/plasmoids/org.kde.security.monitor
    
    cat > /etc/skel/.local/share/plasma/plasmoids/org.kde.security.monitor/metadata.desktop << EOF
[Desktop Entry]
Name=Security Monitor
Comment=Real-time security status monitoring
Icon=security-high
Type=Service
X-KDE-ServiceTypes=Plasma/Applet
X-KDE-PluginInfo-Name=org.kde.security.monitor
X-KDE-PluginInfo-Category=System Information
X-KDE-PluginInfo-Version=1.0
X-Plasma-API=declarativeappletscript
X-Plasma-MainScript=ui/main.qml
EOF
}

configure_privacy_settings() {
    echo "[*] Applying privacy-focused KDE settings..."
    
    cat > /etc/skel/.config/kdeconnect/config << EOF
[General]
name=SecureDevice
EOF

    cat > /etc/skel/.config/kdeglobals << EOF
[General]
BrowserApplication=firefox.desktop
ColorScheme=$THEME_NAME

[KDE]
AnimationDurationFactor=0.5
LookAndFeelPackage=org.kde.breezedark.desktop
ShowDeleteCommand=false
ShowIconsInMenuItems=true
ShowIconsOnPushButtons=true
SingleClick=false
widgetStyle=kvantum-dark

[KFileDialog Settings]
Allow Expansion=false
Automatically select filename extension=true
Breadcrumb Navigation=true
Decoration position=2
LocationCombo Completionmode=5
PathCombo Completionmode=5
Show Bookmarks=false
Show Full Path=false
Show Inline Previews=true
Show Preview=false
Show Speedbar=true
Show hidden files=false
Sort by=Name
Sort directories first=true
Sort reversed=false
Speedbar Width=138
View Style=DetailTree

[PreviewSettings]
MaximumRemoteSize=0
EOF

    cat > /etc/skel/.config/baloofilerc << EOF
[Basic Settings]
Indexing-Enabled=false

[General]
dbVersion=2
exclude filters=*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found
exclude filters version=8
exclude folders[$e]=$HOME/.cache/,$HOME/.config/google-chrome/,$HOME/.config/chromium/,$HOME/.local/share/baloo/,$HOME/.mozilla/,$HOME/.steam/,$HOME/.wine/,/boot/,/dev/,/media/,/mnt/,/proc/,/run/,/sys/,/tmp/,/usr/tmp/,/var/
first run=true
only basic indexing=true
EOF
}

setup_network_security() {
    echo "[*] Configuring network security settings..."
    
    cat > /etc/sysctl.d/99-security.conf << EOF
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.yama.ptrace_scope = 2
net.core.bpf_jit_harden = 2
kernel.unprivileged_bpf_disabled = 1
net.ipv4.tcp_rfc1337 = 1
kernel.perf_event_paranoid = 3
EOF

    sysctl --system
}

create_security_scripts() {
    echo "[*] Creating security audit scripts..."
    
    cat > /usr/local/bin/security-audit << 'EOF'
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}[*] Running Security Audit${NC}"
echo ""

echo -e "${YELLOW}[*] Checking for rootkits...${NC}"
rkhunter --check --skip-keypress --report-warnings-only

echo ""
echo -e "${YELLOW}[*] Running system integrity check...${NC}"
aide --check

echo ""
echo -e "${YELLOW}[*] Checking for hidden processes...${NC}"
unhide proc
unhide sys

echo ""
echo -e "${YELLOW}[*] Scanning for malware...${NC}"
clamscan -r --bell -i /

echo ""
echo -e "${YELLOW}[*] Recent authentication failures:${NC}"
aureport --auth --failed --summary

echo ""
echo -e "${YELLOW}[*] Recent file modifications:${NC}"
ausearch -ts recent -k delete | aureport --file --summary

echo ""
echo -e "${GREEN}[*] Audit complete${NC}"
EOF
    chmod +x /usr/local/bin/security-audit
    
    cat > /etc/systemd/system/security-audit.timer << EOF
[Unit]
Description=Daily Security Audit

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

    cat > /etc/systemd/system/security-audit.service << EOF
[Unit]
Description=Security Audit Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/security-audit
StandardOutput=journal
EOF

    systemctl enable security-audit.timer
}

setup_plasma_look_and_feel() {
    echo "[*] Applying plasma look and feel..."
    
    cat > /etc/skel/.config/plasmarc << EOF
[Theme]
name=breeze-dark

[Wallpapers]
usersWallpapers=/usr/share/wallpapers/SecureGlitch/glitch-default.svg
EOF

    cat > /etc/skel/.config/kscreenlockerrc << EOF
[Greeter][Wallpaper][org.kde.image][General]
Image=/usr/share/wallpapers/SecureGlitch/glitch-lock.svg
PreviewImage=/usr/share/wallpapers/SecureGlitch/glitch-lock.svg

[Daemon]
Autolock=true
LockGrace=5000
LockOnResume=true
Timeout=5
EOF
}

create_glitch_animations() {
    echo "[*] Setting up custom glitch animations..."
    
    mkdir -p /usr/share/kwin/effects/glitch
    
    cat > /usr/share/kwin/effects/glitch/metadata.json << EOF
{
    "KPlugin": {
        "Authors": [
            {
                "Name": "SecurityArch"
            }
        ],
        "Category": "Appearance",
        "Description": "Glitch effect for windows",
        "EnabledByDefault": true,
        "Id": "glitch",
        "License": "GPL",
        "Name": "Glitch Effect",
        "Version": "1.0"
    },
    "X-Plasma-API": "javascript",
    "X-Plasma-MainScript": "code/main.js"
}
EOF
}

setup_kvantum_theme() {
    echo "[*] Configuring Kvantum theme engine..."
    
    mkdir -p /usr/share/Kvantum/GlitchSecKvantum
    
    cat > /usr/share/Kvantum/GlitchSecKvantum/GlitchSecKvantum.kvconfig << EOF
[%General]
author=SecurityArch
comment=Glitch Security Theme
x11drag=menubar_and_primary_toolbar
alt_mnemonic=true
left_tabs=true
attach_active_tab=false
mirror_doc_tabs=false
group_toolbar_buttons=false
toolbar_item_spacing=0
toolbar_interior_spacing=2
spread_progressbar=true
composite=true
menu_shadow_depth=7
tooltip_shadow_depth=6
splitter_width=1
scroll_width=12
scroll_arrows=false
scroll_min_extent=50
slider_width=6
slider_handle_width=16
slider_handle_length=16
center_toolbar_handle=true
check_size=16
textless_progressbar=false
progressbar_thickness=2
menubar_mouse_tracking=true
toolbutton_style=0
double_click=false
translucent_windows=true
blurring=true
popup_blurring=true
vertical_spin_indicators=false
spin_button_width=16
fill_rubberband=false
merge_menubar_with_toolbar=true
small_icon_size=16
large_icon_size=32
button_icon_size=16
toolbar_icon_size=16
combo_as_lineedit=true
animate_states=true
button_contents_shift=false
combo_menu=true
hide_combo_checkboxes=true
combo_focus_rect=true
groupbox_top_label=true
inline_spin_indicators=true
joined_inactive_tabs=false
layout_spacing=4
layout_margin=4
scrollbar_in_view=false
transient_scrollbar=false
transient_groove=false
submenu_overlap=0
tooltip_delay=-1
tree_branch_line=true
contrast=1.00
dialog_button_layout=0
intensity=1.00
saturation=1.00
shadowless_popup=false
dark_titlebar=true
opaque=kaffeine,kmplayer,subtitlecomposer,kdenlive,vlc,smplayer,smplayer2,avidemux,avidemux2_qt4,avidemux3_qt4,avidemux3_qt5,kamoso,QtCreator,VirtualBox,VirtualBoxVM,trojita,dragon,digikam,lyx
reduce_window_opacity=0
respect_DE=true
reduce_menu_opacity=0
no_window_pattern=false
click_behavior=0

[GeneralColors]
window.color=#1a1a1aff
base.color=#330000ff
alt.base.color=#2d2d2dff
button.color=#1a1a1aff
light.color=#FF0033ff
mid.light.color=#2d2d2dff
dark.color=#000000ff
mid.color=#1a1a1aff
highlight.color=#FF0033ff
inactive.highlight.color=#551111ff
text.color=#dcdcdcff
window.text.color=#dcdcdcff
button.text.color=#dcdcdcff
disabled.text.color=#787878ff
tooltip.base.color=#1a1a1aff
tooltip.text.color=#dcdcdcff
highlight.text.color=#ffffffff
link.color=#FF0033ff
link.visited.color=#960000ff
progress.indicator.text.color=#ffffffff

[Hacks]
transparent_ktitle_label=true
transparent_dolphin_view=true
transparent_pcmanfm_sidepane=true
blur_translucent=true
transparent_menutitle=true
respect_darkness=true
kcapacitybar_as_progressbar=true
force_size_grip=true
iconless_pushbutton=false
iconless_menu=false
disabled_icon_opacity=70
lxqtmainmenu_iconsize=22
normal_default_pushbutton=true
single_top_toolbar=true
tint_on_mouseover=0
transparent_pcmanfm_view=false
no_selection_tint=false
transparent_arrow_button=false

[PanelButtonCommand]
frame.top=2
frame.bottom=2
frame.left=2
frame.right=2
interior=true
frame=true
frame.element=button
interior.element=button
indicator.size=8
text.normal.color=#dcdcdcff
text.focus.color=#ffffffff
text.press.color=#ffffffff
text.toggle.color=#ffffffff
min_width=+0.3font
min_height=+0.3font
frame.expansion=0

[PanelButtonTool]
inherits=PanelButtonCommand
text.normal.color=#dcdcdcff
text.focus.color=#ffffffff
text.press.color=#ffffffff
text.toggle.color=#ffffffff
EOF

    mkdir -p /etc/skel/.config/Kvantum
    cat > /etc/skel/.config/Kvantum/kvantum.kvconfig << EOF
[General]
theme=GlitchSecKvantum
EOF
}

main() {
    check_root
    
    echo "[*] Starting installation process..."
    install_dependencies
    
    echo "[*] Configuring security..."
    setup_file_auditing
    setup_apparmor
    setup_network_security
    create_security_scripts
    
    echo "[*] Setting up theme and desktop..."
    create_glitch_theme
    setup_kwin_effects
    setup_latte_dock
    setup_kvantum_theme
    setup_security_dashboard
    configure_privacy_settings
    setup_plasma_look_and_feel
    create_glitch_animations
    
    echo ""
    echo "[✓] Installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Reboot system"
    echo "2. Log into KDE Plasma"
    echo "3. Apply Kvantum theme: Kvantum Manager > Change/Delete Theme > GlitchSecKvantum"
    echo "4. Enable Latte Dock: Right-click panel > Add Widgets > Latte Dock"
    echo "5. Review security logs: journalctl -u audit-monitor"
    echo "6. Run security audit: sudo security-audit"
    echo ""
    echo "[!] Remember: AppArmor will be active after reboot"
}

main "$@"
