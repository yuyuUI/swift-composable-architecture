import ComposableArchitecture
import SwiftUI

struct NavigationStackBindingTestCase: ReducerProtocol {
  struct State: Equatable {
    var path: [Destination] = []
    enum Destination: Equatable {
      case child
    }
  }
  enum Action: Equatable, Sendable {
    case goToChild
    case navigationPathChanged([State.Destination])
  }

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .goToChild:
        state.path.append(.child)
        return .none
      case let .navigationPathChanged(path):
        state.path = path
        return .none
      }
    }
  }
}

struct NavigationStackBindingTestCaseView: View {
  let store: StoreOf<NavigationStackBindingTestCase>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationStack(
        path: viewStore.binding(
          get: \.path,
          send: NavigationStackBindingTestCase.Action.navigationPathChanged
        )
      ) {
        VStack {
          Text("Root")
          Button("Go to child") {
            viewStore.send(.goToChild)
          }
        }
        .navigationDestination(
          for: NavigationStackBindingTestCase.State.Destination.self
        ) { destination in
          switch destination {
          case .child: Text("Child")
          }
        }
      }
    }
  }
}
