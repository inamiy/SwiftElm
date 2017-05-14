import UIKit
import VTree
import VTreeDebugger
import SwiftElm

let initial = Model(count: 0)

appMain {
    return Program(
        model: DebugModel(initial),
        update: debugUpdate(update),
        view: debugView(view)
    )
}
