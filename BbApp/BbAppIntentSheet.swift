import SwiftUI

import BbAppContentSchema
import BbAppSearchSchema

import BbAppContentSource
import BbAppConfiguration
import BbAppIntent
import BbAppContent
import BbAppPush
import BbAppStatusBar
import BbAppNewPost
import BbAppNewComment
import BbAppEditPost
import BbAppEditComment
import BbAppAuthProvider
import BbAppModuleSet

@MainActor
func BbAppIntentSheet(
    moduleSet: BbAppModuleSetData
) -> Void {
    BbAppNewPostIntentSheet(moduleSet: moduleSet)
    BbAppNewCommentIntentSheet(moduleSet: moduleSet)
    BbAppEditPostIntentSheet(moduleSet: moduleSet)
    BbAppEditCommentIntentSheet(moduleSet: moduleSet)
    BbAppAuthProviderIntentSheet(moduleSet: moduleSet)
}
