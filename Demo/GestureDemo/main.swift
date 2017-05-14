import UIKit
import VTree
import VTreeDebugger
import SwiftElm

let initial = Model(message: "Initial", cursor: nil)

appMain {
    return Program(
        model: DebugModel(initial),
        update: debugUpdate(update),
        view: debugView(view)
    )
}
