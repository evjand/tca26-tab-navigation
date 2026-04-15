import ComposableArchitecture2
import SwiftUI

@Feature struct Modal {
  struct State {
    var title: String
    var path: [AppPath.State] = []
  }
  
  enum Action {
    case path(AppPath.State.ID, AppPath.Action)
    case navigateToChild1
    case navigateToChild2
  }
  
  var body: some Feature {
    Update { state, action in
      switch action {
      case .path:
        break
      case .navigateToChild1:
        state.path.append(.child1(.init(title: "1 from modal")))
      case .navigateToChild2:
        state.path.append(.child2(.init(title: "2 from modal")))
      }
    }
    .forEach(\.path, action: \.path, dismissStyle: .stack) {
      AppPath.body
    }
    .onEvent(NavigationEvent.self, consume: true) { path, state in
      switch path {
      case .child1, .child2:
        state.path.append(path)
      default:
        store.addTask {
          try store.post(key: NavigationEvent.self, value: path)
        }
      }
    }
  }
}

struct ModalView: View {
  @Bindable var store: StoreOf<Modal>
  @Environment(\.dismiss) var dismiss
  @Environment(\.isPresented) var isPresented
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        Button {
          store.send(.navigateToChild1)
        } label: {
          Text("Navigate to child 1")
        }
        Button {
          store.send(.navigateToChild2)
        } label: {
          Text("Navigate to child 2")
        }
      }
      .navigationTitle(store.title)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button {
            dismiss()
          } label: {
            Text("Close")
          }
          
        }
      }
      .navigationDestination(for: AppPath.StoreEnumeration.self) { store in
        switch store {
        case .child1(let store):
          ChildOneView(store: store)
        case .child2(let store):
          ChildTwoView(store: store)
        default:
          EmptyView() // Should never happen
        }
      }
    }
  }
}
