import UIKit
import VTree
import VTreeDebugger
import SwiftElm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var program: Any?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
//        let program = Program(initial: (.initial, .empty), update: update, view: view)
        let program = Program(
            model: DebugModel(.initial),
            update: debugUpdate(update),
            view: debugView(view)
        )
        self.program = program

        self.window = UIWindow()
        self.window?.rootViewController = program.rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }
}

// MARK: VTreeDebugger

extension Model: VTreeDebugger.DebuggableModel
{
    var description: String
    {
        return "\(self.message)"
    }
}
