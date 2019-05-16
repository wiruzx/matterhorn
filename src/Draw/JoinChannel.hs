{-# LANGUAGE OverloadedStrings #-}
module Draw.JoinChannel
    ( drawJoinChannel
    )
where

import           Prelude ()
import           Prelude.MH

import           Brick
import           Brick.Widgets.Border
import           Brick.Widgets.Center
import           Brick.Widgets.List
import qualified Data.Text as T
import qualified Data.Vector as V
import           Text.Wrap ( defaultWrapSettings, preserveIndentation )

import           Network.Mattermost.Lenses ( channelDisplayNameL , channelNameL
                                           , channelPurposeL )
import           Network.Mattermost.Types ( Channel )

import           Draw.Main
import           Themes
import           Types
import           Types.Common


drawJoinChannel :: ChatState -> [Widget Name]
drawJoinChannel st = (joinBorders $ joinChannelBox st) : (drawMain False st)

joinChannelBox :: ChatState -> Widget Name
joinChannelBox st =
    let chList = case st^.csJoinChannelList of
          Nothing -> center $ withDefAttr dialogEmphAttr $ txt "[Loading channel list]"
          Just chanList -> renderList renderJoinListItem True chanList
        highlight = withDefAttr dialogEmphAttr
        cur = maybe 0 ((+1) . fst) (listSelectedElement =<< st^.csJoinChannelList)
        len = maybe 0 (\l -> V.length $ l^.listElementsL) $ st^.csJoinChannelList
    in centerLayer $
       vLimit 20 $
       hLimit 60 $
       withDefAttr dialogAttr $
       borderWithLabel (txt "Join Channel") $
       vBox [ chList
            , hBorderWithLabel (str $ (show cur) <> "/" <> (show len))
            , hCenter $ txt "Use " <+> (highlight $ txt "arrow keys") <+> txt " and " <+>
                        (highlight $ txt "Enter") <+> txt " to select a channel"
            , hCenter $ txt "to join or press " <+> (highlight $ txt "Esc") <+> txt " to cancel."
            ]

renderJoinListItem :: Bool -> Channel -> Widget Name
renderJoinListItem _ chan =
    let baseStr = (sanitizeUserText $ chan^.channelNameL) <> " (" <> (sanitizeUserText $ chan^.channelDisplayNameL) <> ")"
        s = "  " <> (T.strip $ sanitizeUserText $ chan^.channelPurposeL)
    in (vLimit 1 $ padRight Max $ txt baseStr) <=>
       (vLimit 1 $ txtWrapWith (defaultWrapSettings { preserveIndentation = True }) s)
