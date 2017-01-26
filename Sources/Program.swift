import UIKit
import Result
import ReactiveSwift
import ReactiveAutomaton
import VTree

/// Wrapper of `VTree`, `Automaton`, and Reactive renderer.
public final class Program<Model, Msg: Message>
{
    private typealias _Automaton = ReactiveAutomaton.Automaton<Model, Msg>

    public let rootViewController = UIViewController()

    private let _diffScheduler = QueueScheduler(qos: .userInteractive, name: "com.inamiy.SwiftElm.diffScheduler")

    private let _automaton: _Automaton
    private let _rootView: MutableProperty<UIView?>
    private let _tree: MutableProperty<AnyVTree<Msg>>

    /// Beginner Program.
    public convenience init<T: VTree>(model: Model, update: @escaping _Automaton.Mapping, view: @escaping (Model) -> T)
        where T.MsgType == Msg
    {
        self.init(initial: (model, .empty), update: _compose(_toNextMapping, update), view: view)
    }

    /// Non-beginner Program.
    public init<T: VTree>(initial: (Model, Effect<Msg>), update: @escaping _Automaton.NextMapping, view: @escaping (Model) -> T)
        where T.MsgType == Msg
    {
        let (inputSignal, inputObserver) = Signal<Msg, NoError>.pipe()

        let initialState = initial.0
        self._automaton = Automaton(state: initialState, input: inputSignal, mapping: update)

        let initialTree = *view(initialState)
        self._tree = MutableProperty(*initialTree)

        let rootView = initialTree.createView()
        self._rootView = MutableProperty(rootView)
        self.rootViewController.view.addSubview(rootView)

        let updatedSignal = self._automaton.replies
            .observe(on: self._diffScheduler)
            .withLatest(from: self._rootView.producer)
            .flatMap(.merge) { reply, rootView -> SignalProducer<(Reply<Model, Msg>, UIView), NoError> in
                /// Early exit if `rootView` is nil.
                guard let rootView = rootView else {
                    return .empty
                }
                return .init(value: (reply, rootView))
            }
            .withLatest(from: self._tree.producer)
            .flatMap(.merge) { result, oldTree -> SignalProducer<(rootView: UIView, new: T, patch: Patch<Msg>), NoError> in
                let (reply, rootView) = result
                guard let newState = reply.toState else {
                    return .empty
                }
                let newTree = view(newState)
                let patch = diff(old: oldTree, new: newTree)
                return .init(value: (rootView, newTree, patch))
            }
            .observe(on: QueueScheduler.main)
            .flatMap(.merge) { rootView, newTree, patch -> SignalProducer<(AnyVTree<Msg>, UIView?), NoError> in
                let newView = apply(patch: patch, to: rootView)
                return .init(value: (*newTree, newView))
            }

        self._tree <~ updatedSignal.map { $0.0 }
        self._rootView <~ updatedSignal.map { $0.1 }

        // Handle messages sent from `VTree`.
        Messenger.shared.handler = { anyMsg in
            guard let msg = Msg(anyMsg) else { return }
            inputObserver.send(value: msg)
        }

        let initialEffect = initial.1
        initialEffect.startWithValues { msg in
            inputObserver.send(value: msg)
        }
    }
}

// MARK: Private

private func _compose<A, B, C>(_ g: @escaping (B) -> C, _ f: @escaping (A) -> B) -> (A) -> C
{
    return { x in g(f(x)) }
}

private func _toNextMapping<State, Input>(_ toState: State?) -> (State, SignalProducer<Input, NoError>)?
{
    if let toState = toState {
        return (toState, .empty)
    }
    else {
        return nil
    }
}
