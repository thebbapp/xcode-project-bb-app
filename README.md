# ``BbApp``

BbApp distribution for the Apple ecosystem including extendable dependency injection, starting application, and a copy of the framework.

## Getting Started

1. Clone and open XCode project `git clone -b release git@github.com:thebbapp/xcode-project-bb-app.git`
2. Set `Bundle Identifier` under `BbApp > Targets > BbApp > General > Identity`
3. Select your `Team` under `BbApp > Targets > BbApp > Signing & Capabilities Signging`
4. Set `BbAppHttpClientBaseURL` to your WordPress installation URL under `BbApp > BbApp > Info.plist`. If your content source, root section or root parent ID differ from their default, set them above.
5. Press `Run`!

### Notes

- For push notifications on production builds, under `BbApp` > `BbApp` > `BbApp.entitlements` set `APS Environment` and `APS Environment (macOS)` to `production`

## To keep BbApp development going, [donate here](https://thebbapp.com/donate)