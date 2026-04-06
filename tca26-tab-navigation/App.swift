import ComposableArchitecture2
import SwiftUI

@main
struct NavigationDemoApp: App {
  static let store: StoreOf<AppRoot> = .init(
    initialState: .init(
      home: .init(root: .init(title: "Home")),
      explore: .init(root: .init(title: "Explore")),
      search: .init(root: .init(title: "Search"))
    )
  ) {
    AppRoot()
  }
  var body: some Scene {
    WindowGroup {
      AppRootView(store: Self.store)
    }
  }
}
