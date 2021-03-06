import System.Exit
import XMonad
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.Run
import XMonad.Hooks.Script
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import Graphics.X11.ExtraTypes.XF86
import Data.Monoid

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main = do
    d <- spawnPipe "xmobar /home/mose/.xmonad/data/xmobar/xmonad_bar"

    xmonad $ fullscreenSupport $ docks def
        { 
          terminal          = myTerminal
        , focusFollowsMouse = myFocusFollowsMouse
        , modMask           = myModMask
        , borderWidth       = myBorderWidth
        , workspaces        = myWorkspaces

        , keys              = myKeys
        , mouseBindings     = myMouseBindings

        , layoutHook        = myLayoutHook
        , manageHook        = manageDocks <+> myManageHook
        , handleEventHook   = myEventHook
        , logHook           = myLogHook d
        , startupHook       = myStartupHook
        }

myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myModMask       = mod1Mask
myBorderWidth   = 0
myWorkspaces    = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_d     ), spawn "rofi -matching fuzzy -show combi -combi-modi drun,run,ssh")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

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

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; pkill xmobar; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
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
    ++
    --
    -- Function extra keys for screen-backlight or Volume control
    --
    [ ((0, xF86XK_AudioRaiseVolume), spawn "pulsemixer --change-volume +5")
    , ((0, xF86XK_AudioLowerVolume), spawn "pulsemixer --change-volume -5")
    , ((0, xF86XK_AudioMute), spawn "pulsemixer --toggle-mute")
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 5")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
    ]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1),  (\w -> focus w >> mouseMoveWindow w
                                        >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

gaps l = spacingRaw False (Border 0 10 10 10) True (Border 10 10 10 10) True l

myLayoutHook = avoidStruts ((gaps tiled) ||| (gaps (Mirror tiled))) ||| noBorders (fullscreenFull Full)
    where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by master pane
        ratio   = 1/2
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    ]

myEventHook = mempty

myLogHook h = dynamicLogWithPP $ defaultPP
    {
    -- output to the handle we were given as an argument
      ppOutput          = hPutStrLn h
    , ppTitle           = const ""
    , ppLayout          = const ""
    , ppCurrent         = xmobarColor "#006000" "" . wrap "[" "]"
    , ppVisible         = xmobarColor "#e49400" "" . wrap "(" ")"
    , ppUrgent          = xmobarColor "darkred" ""
    , ppSep             = ""
    }

myStartupHook = execScriptHook "startup"



