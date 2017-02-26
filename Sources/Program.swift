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

        let treesSignal = self._automaton.replies
            .flatMap(.merge) { reply -> SignalProducer<T, NoError> in
                /// Early exit if transition failed.
                guard let newState = reply.toState else {
                    return .empty
                }

                // NOTE:
                // `newTree` needs be created and stored **synchronously** so that
                // every diffing will be possible even when `replies` values are rapidly sent.
                let newTree = view(newState)
                return .init(value: newTree)
            }
            .withLatest(from: self._tree.producer)

        let newRootViewProducer = treesSignal
            .observe(on: self._diffScheduler)
            .flatMap(.merge) { newTree, oldTree -> SignalProducer<Patch<Msg>, NoError> in
                let patch = diff(old: oldTree, new: newTree)
                return .init(value: patch)
            }
            .observe(on: QueueScheduler.main)
            .withLatest(from: self._rootView.producer)
            .flatMap(.merge) { patch, rootView -> SignalProducer<UIView?, NoError> in
                /// Early exit if `rootView` is nil.
                guard let rootView = rootView else {
                    return .init(value: nil)
                }

                let newView = apply(patch: patch, to: rootView)
                return .init(value: newView)
            }

        self._tree <~ treesSignal.map { AnyVTree($0.0) }
        self._rootView <~ newRootViewProducer

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
