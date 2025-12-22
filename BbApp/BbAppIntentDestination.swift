import SwiftUI

import BbAppContentSchema
import BbAppSearchSchema

import BbAppContentSource
import BbAppConfiguration
import BbAppIntent
import BbAppContent
import BbAppPush
import BbAppViewSection
import BbAppViewPost
import BbAppViewComment
import BbAppSearch
import BbAppStatusBar
import BbAppContent
import BbAppModuleSet

@MainActor
func BbAppIntentDestination(moduleSet: BbAppModuleSetData) -> Void {
    BbAppViewSectionIntentDestination(moduleSet: moduleSet)
    BbAppViewPostIntentDestination(moduleSet: moduleSet)
    BbAppViewCommentIntentDestination(moduleSet: moduleSet)
    BbAppSearchIntentDestination(moduleSet: moduleSet)
}
