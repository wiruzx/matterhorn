module Draw.ManageAttachments
  ( drawManageAttachments
  )
where

import           Prelude ()
import           Prelude.MH

import           Brick
import           Brick.Widgets.List
import           Brick.Widgets.Center
import           Brick.Widgets.Border
import qualified Brick.Widgets.FileBrowser as FB

import           Types
import           Types.KeyEvents
import           Events.Keybindings ( getFirstDefaultBinding )
import           Themes
import           Draw.Main ( drawMain )


drawManageAttachments :: ChatState -> [Widget Name]
drawManageAttachments st =
    topLayer : drawMain True st
    where
        topLayer = case appMode st of
            ManageAttachments -> drawAttachmentList st
            ManageAttachmentsBrowseFiles -> drawFileBrowser st
            _ -> error "BUG: drawManageAttachments called in invalid mode"

drawAttachmentList :: ChatState -> Widget Name
drawAttachmentList st =
    let addBinding = ppBinding $ getFirstDefaultBinding AttachmentListAddEvent
        delBinding = ppBinding $ getFirstDefaultBinding AttachmentListDeleteEvent
        escBinding = ppBinding $ getFirstDefaultBinding CancelEvent
        openBinding = ppBinding $ getFirstDefaultBinding AttachmentOpenEvent
    in centerLayer $
       hLimit 60 $
       vLimit 15 $
       joinBorders $
       borderWithLabel (txt "Attachments") $
       vBox [ renderList renderAttachmentItem True (st^.csEditState.cedAttachmentList)
            , hBorder
            , hCenter $ withDefAttr clientMessageAttr $
                        txt $ addBinding <> ":add " <>
                              delBinding <> ":delete " <>
                              openBinding <> ":open " <>
                              escBinding <> ":close"
            ]

renderAttachmentItem :: Bool -> AttachmentData -> Widget Name
renderAttachmentItem _ d =
    padRight Max $ str $ FB.fileInfoSanitizedFilename $ attachmentDataFileInfo d

drawFileBrowser :: ChatState -> Widget Name
drawFileBrowser st =
    centerLayer $
    hLimit 60 $
    vLimit 20 $
    borderWithLabel (txt "Attach File") $
    FB.renderFileBrowser True (st^.csEditState.cedFileBrowser)
