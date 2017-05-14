import UIKit
import VTree

private var _programBuilder: (() -> ProgramProtocol)? = nil

/// App main entrypoint.
///
/// - Parameter programBuilder:
/// A `Program<Model, Msg>` builder that is evaluated **AFTER `application(_:didFinishLaunchingWithOptions)`**
/// to avoid [UIGestureGraphEdge Crash](https://forums.developer.apple.com/thread/61432).
public func appMain<Model, Msg: Message>(_ programBuilder: @escaping () -> Program<Model, Msg>)
{
    _programBuilder = programBuilder

    let unsafeArgv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
        to: UnsafeMutablePointer<Int8>.self,
        capacity: Int(CommandLine.argc)
    )
    UIApplicationMain(CommandLine.argc, unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
}

class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    private var _program: ProgramProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        guard let programBuilder = _programBuilder else { return false }

        let program = programBuilder()
        self._program = program
        self.window = program.window

        return true
    }
}
