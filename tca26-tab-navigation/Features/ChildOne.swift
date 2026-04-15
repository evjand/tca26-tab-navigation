import ComposableArchitecture2
import SwiftUI

@Feature struct ChildOne {
  struct State {
    var title: String
  }
  
  enum Action {
    case navigateToChild1
    case navigateToChild2
    case navigateToChild3
  }
  
  var body: some Feature {
    Update { state, action in
      switch action {
      case .navigateToChild1:
        store.addTask {
          try store.post(key: NavigationEvent.self, value: .child1(.init(title: "1 from 1")))
        }
      case .navigateToChild2:
        store.addTask {
          try store.post(key: NavigationEvent.self, value: .child2(.init(title: "2 from 1")))
        }
      case .navigateToChild3:
        store.addTask {
          try store.post(key: NavigationEvent.self, value: .child3(.init(title: "3 from 1")))
        }
      }
    }
  }
}

struct ChildOneView: View {
  let store: StoreOf<ChildOne>
  @Environment(\.dismiss) var dismiss
  @Environment(\.isPresented) var isPresented
  var body: some View {
    List {
      Button {
        dismiss()
      } label: {
        Text("Go back")
      }
      .disabled(!isPresented)
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
      Button {
        store.send(.navigateToChild3)
      } label: {
        Text("Navigate to child 3")
      }
    }
    .scrollContentBackground(.hidden)
    .background(.yellow)
    .navigationTitle(store.title)
  }
}
