--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import System.Exit
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.NoBorders
import XMonad.Actions.PhysicalScreens
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
 
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "gnome-terminal"
 
-- Width of the window border in pixels.
--
myBorderWidth   = 1
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1:mail","2:work","3","4","5:audio","6","7","8","9"]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#00ff00"
myFocusedBorderColor = "#0000ff"
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
 
    -- launch dmenu
    , ((controlMask,        xK_space     ), spawn "exe=\"dmenu_run -l 20 -fn 'xft:Source Code Pro Medium-16' -nb '#333335' -sb '#A0A0D0' -nf '#CCCCCF' -sf '#15151A' \" && eval \"exec $exe\"")

    -- launch file finder
    , ((modm .|. shiftMask, xK_o         ), spawn "exe=\"~/.xmonad/bin/file-finder \" && eval \"exec $exe\"")
 
    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- close focused window 
    , ((modm .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((mod4Mask,               xK_space ), sendMessage NextLayout)
 
     -- Lock Screen
     , ((mod4Mask,               xK_l ), do
                                 spawn "playerctl pause"
                                 spawn "cmus-remote --stop"
                                 spawn "slock"
                                 )

     -- Switch keyboard layout
    , ((modm,               xK_space ), spawn "/home/christian/.xmonad/bin/layout-switch")

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- toggle the status bar gap (used with avoidStruts from Hooks.ManageDocks)
    , ((modm , xK_f ), sendMessage ToggleStruts)
       --take a screenshot of entire display 
    , ((modm , xK_p ), spawn "scrot ~/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -e 'xdg-open $f'")
    --
    --      --take a screenshot of focused window 
    , ((modm .|. controlMask, xK_p ), spawn "scrot ~/Pictures/window_%Y-%m-%d-%H-%M-%S.png -u -e 'xdg-open $f'")

    --      --take a screenshot of marked area
    , ((modm .|. shiftMask, xK_p ), spawn "sleep 0.2; scrot ~/Pictures/selection%Y-%m-%d-%H-%M-%S.png -s -e 'xdg-open $f'")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modm              , xK_q     ), restart "xmonad" True)

    -- Multimedia Keys
    -- XF86Play
    , ((0              , 0x1008ff14     ), do
                                            spawn "cmus-remote -u"
                                            spawn "playerctl play-pause"
                                            )
    , ((0              , 0x1008ff17     ), do
                                            spawn "cmus-remote -n"
                                            spawn "playerctl next"
                                            )
    , ((0              , 0x1008ff16     ), do
                                            spawn "cmus-remobe -r"
                                            spawn "playerctl previous"
                                            )
    , ((0              , 0x1008ff13     ), spawn "/home/christian/.xmonad/bin/pulse-volume.sh increase")
    , ((0              , 0x1008ff11     ), spawn "/home/christian/.xmonad/bin/pulse-volume.sh decrease")
    , ((0              , 0x1008ff12     ), spawn "/home/christian/.xmonad/bin/pulse-volume.sh toggle")
    , ((0              , 0x1008ff02     ), spawn "xbacklight +2")
    , ((0              , 0x1008ff03     ), spawn "xbacklight -2")
    , ((0              , 0xff61         ), spawn "/home/christian/.xmonad/bin/toggle-wifi")
    , ((controlMask,        xK_m     ), spawn "/home/christian/.xmonad/bin/toggle-touchpad")
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = noBorders $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Thunderbird"    --> doShift "1:mail"
    , className =? "Spotify"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
 
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
 
------------------------------------------------------------------------
-- Status bars and logging
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--

myLogHook h = dynamicLogWithPP $ xmobarPP
                                     { ppOutput = hPutStrLn h,
                                       ppTitle = xmobarColor "#FFB6B0" "" . shorten 100,
                                       ppCurrent = xmobarColor "#CEFFAC" "",
                                       ppSep = "   "
                                     }
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
        xmproc <- spawnPipe "/home/christian/.cabal/bin/xmobar ~/.xmonad/xmobarrc"

        xmonad $ defaultConfig
            {
            logHook = myLogHook xmproc,
      -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,
 
      -- key bindings
            keys               = myKeys,
            mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
            layoutHook         = avoidStruts $ myLayout,
            manageHook         = manageDocks <+> myManageHook,
            startupHook        = myStartupHook
            }
