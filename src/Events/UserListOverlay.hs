module Events.UserListOverlay where

import qualified Graphics.Vty as Vty

import           Events.Keybindings
import           State.UserListOverlay
import           State.ListOverlay
import           Types


onEventUserListOverlay :: Vty.Event -> MH ()
onEventUserListOverlay =
    onEventListOverlay csUserListOverlay userListOverlayKeybindings

-- | The keybindings we want to use while viewing a user list overlay
userListOverlayKeybindings :: KeyConfig -> [Keybinding]
userListOverlayKeybindings = mkKeybindings
    [ mkKb CancelEvent "Close the user search list" (exitListOverlay csUserListOverlay)
    , mkKb SearchSelectUpEvent "Select the previous user" userListSelectUp
    , mkKb SearchSelectDownEvent "Select the next user" userListSelectDown
    , mkKb PageDownEvent "Page down in the user list" userListPageDown
    , mkKb PageUpEvent "Page up in the user list" userListPageUp
    , mkKb ActivateListItemEvent "Interact with the selected user" (listOverlayActivateCurrent csUserListOverlay)
    ]
