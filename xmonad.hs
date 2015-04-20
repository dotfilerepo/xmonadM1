module Main (main) where

import XMonad

import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Graphics.X11.Xlib
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Actions.RotSlaves

main :: IO ()
main = do
    rBar <- spawnPipe rightBar
    lBar <- spawnPipe leftBar
    xmonad =<< dzen defaultConfig
      { terminal = "urxvt"
      , workspaces = myWorkspaces
      , keys = newKeys
      , logHook = myLogHook lBar
      , focusedBorderColor = myFocusedBorderColor
      }

-- custom keybindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
            [ ((modm                , xK_F12    ), xmonadPrompt defaultXPConfig)
            , ((modm                , xK_F3     ), shellPrompt defaultXPConfig)
            , ((modm                , xK_r      ), spawn myDmenu            )
            , ((modm                , xK_u      ), prevWS                   )
            , ((modm                , xK_i      ), nextWS                   )
            , ((modm                , xK_h      ), windows W.focusDown      )
            , ((modm                , xK_l      ), windows W.focusUp        )
            , ((modm .|. shiftMask  , xK_h      ), nextScreen               )
            , ((modm .|. shiftMask  , xK_l      ), prevScreen               )
            , ((modm                , xK_k      ), rotAllDown               )
            , ((modm                , xK_j      ), rotAllUp                 )
            ]

-- creating new map by joining the default keybindings with the custom ones
newKeys x = myKeys x `M.union` keys defaultConfig x

myWorkspaces = ["alpha","beta","gamma","delta"]

myDmenu = "dmenu_run -fn \"xft:Monospace:pixelsize=14\" -nb \"#1B1D1E\" -nf \"#F92672\" -sb \"#1B1D1E\" -sf \"#A6E22E\""
-- simple dummy
-- leftBar = "echo \"Hello World 1\" | dzen2 -x '0' -y '0' -w 1920 -h '24' -p"
leftBar = "dzen2 -xs 1 -x '0' -y '0' -w 1920 -ta l"
rightBar = "conky | dzen2 -xs 2 -x '0' -y '0' -ta l"

-- myLogHook :: GHC.IO.Handle.Types.Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#A6E22E" "#1B1D1E" . pad
      , ppVisible           =   dzenColor "#960050" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "#960050" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#465457" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppTitle             =   (" " ++) . dzenColor "#F8F8F0" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

myFocusedBorderColor = "#960050"
