import Foundation
import UIKit
import wvlibSwift

if(HYCheck.setInfo("APP_ID", idInfo: "APP_KEY", dtStr: "2019-03-01 05:20:59", seed: 0)){
    UIApplicationMain(
        CommandLine.argc,
        UnsafeMutableRawPointer(CommandLine.unsafeArgv)
            .bindMemory(
                to: UnsafeMutablePointer<Int8>.self,
                capacity: Int(CommandLine.argc)),
        nil,
        NSStringFromClass(AppDelegate.self)
    )
}
