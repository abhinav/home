{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
import           XMonad
import           XMonad.Actions.CycleWS
import           XMonad.Config.Gnome
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.Circle
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Grid
import           XMonad.Layout.Maximize
import           XMonad.Layout.Minimize
import           XMonad.Layout.NoBorders
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet             as W
import           XMonad.Util.EZConfig


myModMask        = mod1Mask                     -- Use @alt@ as the mod key.
myWorkspaces     = map show ([1..9] :: [Int])   -- 9 workspaces
startupWorkspace = "1"                          -- Start with the first

myLayouts = maximize $ minimize $ smartBorders $ avoidStruts $
  -- Master to the left, tile to the right. Use M-h and M-l to change width of
  -- master. Use M-a and M-z to change height of current tile.
  ResizableTall 1 (3/100) (1/2) []

  -- Same as previous except master is at the top and tiles at the bottom.
  ||| Mirror (ResizableTall 1 (3/100) (1/2) [])

  -- Full screen layout for everything.
  ||| noBorders Full

  -- Tries to distribute available space to windows equally. Master at the top
  -- left.
  ||| Grid

  -- Put master in the center, others on the left and right.
  ||| ThreeColMid 1 (3/100) (3/4)

  -- Master in the center, others in a circle around it.
  ||| Circle

-- Make it possible to use numpad (with and without numlock) to change
-- workspaces.
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
             , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
             , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
             ]

-- TODO prefer using additionalKeysP for this.
myKeys = [
  -- Show/hide panels
    ((myModMask, xK_b), sendMessage ToggleStruts)

  -- Change height of tile
  , ((myModMask, xK_a), sendMessage MirrorShrink)
  , ((myModMask, xK_z), sendMessage MirrorExpand)

  -- Log out
  , ((myModMask .|. shiftMask, xK_q), spawn "gnome-session-quit")

  -- Move between workspaces using left/right arrow keys.
  , ((myModMask .|. controlMask, xK_Left), prevWS)
  , ((myModMask .|. controlMask, xK_Right), nextWS)
  , ((myModMask .|. shiftMask .|. controlMask, xK_Left), shiftToPrev)
  , ((myModMask .|. shiftMask .|. controlMask, xK_Right), shiftToNext)

  -- Minimze and restore
  , ((myModMask, xK_m), withFocused minimizeWindow)
  , ((myModMask .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)

  -- Maximize
  , ((myModMask, xK_backslash), withFocused (sendMessage . maximizeRestore))
  ] ++
  [((m .|. myModMask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces numPadKeys
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myManagementHooks =
  [ resource =? "synapse"     --> doIgnore
  ]

main :: IO ()
main = xmonad $ withUrgencyHook FocusHook
              $ gnomeConfig
  { focusedBorderColor  = "#ff0000"
  , normalBorderColor   = "#cccccc"
  , borderWidth         = 3
  , layoutHook          = myLayouts
  , workspaces          = myWorkspaces
  , modMask             = myModMask
  , handleEventHook     = fullscreenEventHook
  , startupHook = do
      windows $ W.greedyView startupWorkspace
      spawn "~/.xmonad/startup-hook"
      startupHook gnomeConfig
  , manageHook = manageHook defaultConfig
      <+> composeAll myManagementHooks
      <+> manageDocks
  } `additionalKeys` myKeys
