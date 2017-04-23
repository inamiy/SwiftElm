import UIKit
import Result
import ReactiveSwift
import ReactiveAutomaton
import VTree

/// Wrapper of `VTree`, `Automaton`, and Reactive renderer.
public final class Program<Model, Msg: Message>
{
    public let rootViewController = UIViewController()

    private let _diffScheduler = QueueScheduler(qos: .userInteractive, name: "com.inamiy.SwiftElm.diffScheduler")

    private let _automaton: Automaton<Model, Msg>
    private let _rootView: MutableProperty<UIView?>
    private let _tree: MutableProperty<AnyVTree<Msg>>

    /// Beginner Program.
    public convenience init<T: VTree>(model: Model, update: @escaping Automaton<Model, Msg>.Mapping, view: @escaping (Model) -> T)
        where T.MsgType == Msg
    {
        self.init(initial: (model, .empty), update: toEffectMapping(update), view: view)
    }

    /// Non-beginner Program.
    public init<T: VTree>(initial: (Model, Effect<Msg>), update: @escaping Automaton<Model, Msg>.EffectMapping, view: @escaping (Model) -> T)
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
