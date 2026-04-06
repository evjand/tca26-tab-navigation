import ComposableArchitecture2
import SwiftUI

@Feature struct TabNavigation<Root: FeatureProtocol> where Root.State: DebugSnapshotConvertible {
  struct State {
    var root: Root.State
    var path: [AppPath.State] = []
  }

  enum Action {
    case root(Root.Action)
    case path(AppPath.State.ID, AppPath.Action)
  }

  let root: () -> Root

  init(feature: @escaping () -> Root) {
    self.root = feature
  }

  var body: some Feature {
    Scope(state: \.root, action: \.root) {
      root()
    }
    EmptyFeature()
    .forEach(\.path, action: \.path, dismissStyle: .stack) {
      AppPath.body
    }
    .onEvent(NavigationEvent.self) { value, state in
      state.path.append(value)
    }
  }
}


struct TabNavigationView<Root: FeatureProtocol, RootView: View>: View where Root.State: DebugSnapshotConvertible {
  @Bindable var store: StoreOf<TabNavigation<Root>>
  let root: RootView
  init(store: StoreOf<TabNavigation<Root>>, @ViewBuilder root: (StoreOf<Root>) -> RootView) {
    self.store = store
    self.root = root(store.scope(state: \.root, action: \.root))
  }
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      root
        .navigationDestination(for: AppPath.StoreEnumeration.self) { store in
          switch store {
          case .child1(let store):
            ChildOneView(store: store)
          case .child2(let store):
            ChildTwoView(store: store)
          case .child3(let store):
            ChildThreeView(store: store)
          }
        }
    }
  }
}
