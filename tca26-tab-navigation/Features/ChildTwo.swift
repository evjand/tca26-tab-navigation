import ComposableArchitecture2
import SwiftUI

@Feature struct ChildTwo {
  struct State {
    var title: String
    @StoreTaskID var task // StoreTaskID + onChange = loop?
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
        try! store.post(key: NavigationEvent.self, value: .child1(.init(title: "1 from 2")))
      case .navigateToChild2:
        try! store.post(key: NavigationEvent.self, value: .child2(.init(title: "2 from 2")))
      case .navigateToChild3:
        try! store.post(key: NavigationEvent.self, value: .child3(.init(title: "3 from 2")))
      }
    }
    .onChange(of: store.title) { oldValue, state in
      // Looks like onChange is needed for loop
    }
  }
}

struct ChildTwoView: View {
  let store: StoreOf<ChildTwo>
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
    .background(Color.blue)
    .navigationTitle(store.title)
  }
}
