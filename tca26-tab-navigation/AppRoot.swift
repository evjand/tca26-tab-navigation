import ComposableArchitecture2
import SwiftUI

@Feature enum AppPath {
  case child1(ChildOne)
  case child2(ChildTwo)
  case child3(ChildThree)
}

enum NavigationEvent: FeatureEventKey {
  typealias Value = AppPath.State
}

enum AppTab {
  case home
  case explore
  case search
}

@Feature struct AppRoot {
  struct State {
    var tab: AppTab = .home
    var home: TabNavigation<ChildOne>.State
    var explore: TabNavigation<ChildTwo>.State
    var search: TabNavigation<ChildThree>.State
  }
  
  enum Action {
    case home(TabNavigation<ChildOne>.Action)
    case explore(TabNavigation<ChildTwo>.Action)
    case search(TabNavigation<ChildThree>.Action)
  }
  
  var body: some Feature {
    let _ = Self._logChanges()
    Scope(state: \.home, action: \.home) {
      TabNavigation {
        ChildOne()
      }
    }
    Scope(state: \.explore, action: \.explore) {
      TabNavigation {
        ChildTwo()
      }
    }
    Scope(state: \.search, action: \.search) {
      TabNavigation {
        ChildThree()
      }
    }
  }
}

struct AppRootView: View {
  @Bindable var store: StoreOf<AppRoot>
  var body: some View {
    TabView(selection: $store.tab) {
      Tab(value: .home) {
        TabNavigationView(store: store.scope(state: \.home, action: \.home)) { store in
          ChildOneView(store: store)
        }
      } label: {
        Label("Home", systemImage: "house")
      }
      Tab(value: .explore) {
        TabNavigationView(store: store.scope(state: \.explore, action: \.explore)) { store in
          ChildTwoView(store: store)
        }
      } label: {
        Label("Explore", systemImage: "square.grid.2x2.fill")
      }
      Tab(value: .search, role: .search) {
        TabNavigationView(store: store.scope(state: \.search, action: \.search)) { store in
          ChildThreeView(store: store)
        }
      } label: {
        Label("Search", systemImage: "magnifyingglass")
      }
    }
  }
}

#Preview {
  @Previewable @State var store = Store(
    initialState: AppRoot.State(
      home: .init(root: .init(title: "Home")),
      explore: .init(root: .init(title: "Explore")),
      search: .init(root: .init(title: "Search"))
    )
  ) {
    AppRoot()
  }
  AppRootView(store: store)
}
