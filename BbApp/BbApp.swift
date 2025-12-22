import SwiftUI
import UserNotifications
import Network

import BbAppAuthProviderSchema
import BbAppContentSourceSchema

import BbAppAuthProvider
import BbAppContent
import BbAppContentStore
import BbAppContentSource
import BbAppPush
import BbAppDelegate
import BbAppConfiguration
import BbAppIntent
import BbAppTask
import BbAppStatusBar
import BbAppView
import BbAppState
import BbAppRelativeDate
import BbAppPrompt
import BbAppModuleSet

import BbAppAuthProviderPlaintext

import BbAppContentSourceWordPress
import BbAppContentSourceBbPress

@main
struct BbApp: App {
    #if os(iOS) || os(tvOS)
    @UIApplicationDelegateAdaptor(BbAppUNDelegate.self) private var delegate
    #else
    @NSApplicationDelegateAdaptor(BbAppUNDelegate.self) private var delegate
    #endif

    private let contentSources: Array<any BbAppContentSourceProtocol.Type> = [
        BbAppContentSourceWordPressActor.self,
        BbAppContentSourceBbPressActor.self
    ]

    private let contentSourceStore: BbAppContentSourceStore
    private let contentStore: BbAppContentDataStore
    private let lastReadStore: BbAppContentLastReadStore
    private let pushTokenStore: BbAppPushTokenStore
    private let statusBar: BbAppStatusBarCoordinator
    private let relativeDateTimer: BbAppRelativeDateTimer
    private let prompt: BbAppPromptCoordinator
    private let state: BbAppStateCoordinator
    private let config: BbAppConfigurationStore
    private let intent: BbAppIntentCoordinator
    private let contentSource: BbAppContentSourceAbstract

    private let moduleSet: BbAppModuleSetData

    var body: some Scene {
        WindowGroup {
            BbAppSceneView(delegate: delegate, contentSources: contentSources, moduleSet: moduleSet)
                .onChange(of: moduleSet.contentSourceStore.options.containerId) { oldValue, newValue in
                    moduleSet.state.setIsLoading(true)
                    moduleSet.state.setHasLoaded(false)

                    contentStore.clearCache()
                    lastReadStore.clearCache()

                    contentSource.update(BbAppContentSourcesSource(
                        requestHeadersPreparer: BbAppContentRequestHeadersPrepaper(contentStore: contentStore),
                        contentSourceStore: contentSourceStore,
                        contentStore: contentStore,
                        contentSources: contentSources
                    ))
                }
                .task {
                    let options = moduleSet.contentSourceStore.options,
                        detachedOptions = await moduleSet.contentSource.detached.options

                    if options.containerId != detachedOptions.containerId {
                        moduleSet.contentSourceStore.setOptions(detachedOptions)
                    }
                }
        }
    }

    init() {
        let contentSourceStore = BbAppContentSourceStore(
            options: BbAppContentSourceOptionsBundle(),
            features: BbAppContentSourceFeaturesBundle(),
            constants: BbAppContentSourceConstantsBundle()
        )

        let contentStore = BbAppContentDataStore(),
            lastReadStore = BbAppContentLastReadStore(),
            pushTokenStore = BbAppPushTokenStore(),
            statusBar = BbAppStatusBarCoordinator(),
            relativeDateTimer = BbAppRelativeDateTimer(),
            prompt = BbAppPromptCoordinator(),
            state = BbAppStateCoordinator(),
            config = BbAppConfigurationStore(),
            intent = BbAppIntentCoordinator()

        let contentSource = BbAppContentSourceAbstract(
            BbAppContentSourcesSource(
                requestHeadersPreparer: BbAppContentRequestHeadersPrepaper(contentStore: contentStore),
                contentSourceStore: contentSourceStore,
                contentStore: contentStore,
                contentSources: contentSources
            ),

            contentSourceStore: contentSourceStore
        )

        let moduleSet: BbAppModuleSetData = .init(
            contentSourceStore: contentSourceStore,
            contentStore: contentStore,
            lastReadStore: lastReadStore,
            pushTokenStore: pushTokenStore,
            statusBar: statusBar,
            contentSource: contentSource,
            relativeDateTimer: relativeDateTimer,
            prompt: prompt,
            state: state,
            config: config,
            intent: intent
        )

        self.contentSourceStore = contentSourceStore
        self.contentStore = contentStore
        self.lastReadStore = lastReadStore
        self.pushTokenStore = pushTokenStore
        self.statusBar = statusBar
        self.relativeDateTimer = relativeDateTimer
        self.prompt = prompt
        self.state = state
        self.config = config
        self.intent = intent
        self.contentSource = contentSource
        self.moduleSet = moduleSet

        self.state.authProviders.append(contentsOf: getAuthProviders())

        loadModuleIntents()
    }

    private func getAuthProviders() -> Array<any BbAppAuthProviderProtocol> {
        [
            BbAppAuthProviderPlaintextActor(
                state: .init(),
                callbacks: BbAppAuthProviderCallbacks(moduleSet: moduleSet),
                moduleSet: moduleSet
            )
        ]
    }

    private func loadModuleIntents() -> Void {
        BbAppIntentDestination(moduleSet: moduleSet)
        BbAppIntentSheet(moduleSet: moduleSet)
        BbAppIntentRoute(moduleSet: moduleSet)
    }
}
