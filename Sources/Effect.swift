import Result
import ReactiveSwift

/// Mixture of Elm's `Task`, `Cmd`, `Sub`.
public typealias Effect<Msg> = SignalProducer<Msg, NoError>

/// Creates a simple, synchronous side-effect
/// that executes a closure (not cancellable).
public func simpleEffect<Msg>(_ exec: @escaping () -> ()) -> Effect<Msg>
{
    return Effect { observer, _ in
        exec()
        observer.sendCompleted()
    }
}

/// Creates a simple, synchronous side-effect
/// that executes a closure (not cancellable), and returns a next `Msg` (optional).
///
/// - Parameter exec:
///   A closure that runs when effect started, and returning `Msg`
///   will be sent as effect's "next value" before completed.
public func simpleMsgEffect<Msg>(_ exec: @escaping () -> Msg?) -> Effect<Msg>
{
    return Effect { observer, _ in
        let msg = exec()
        if let msg = msg {
            observer.send(value: msg)
        }
        observer.sendCompleted()
    }
}
