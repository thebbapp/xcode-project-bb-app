import Foundation

import BbAppContentSchema

import BbAppAuthProvider
import BbAppContentSource
import BbAppConfiguration
import BbAppIntent
import BbAppViewSection
import BbAppViewPost
import BbAppViewComment
import BbAppContent
import BbAppTask
import BbAppModuleSet

@MainActor
func BbAppIntentRoute(moduleSet: BbAppModuleSetData) -> Void {
    BbAppAuthProviderIntentRoute(moduleSet: moduleSet)
    BbAppViewSectionIntentRoute(moduleSet: moduleSet)
    BbAppViewPostIntentRoute(moduleSet: moduleSet)
    BbAppViewCommentIntentRoute(moduleSet: moduleSet)
}
