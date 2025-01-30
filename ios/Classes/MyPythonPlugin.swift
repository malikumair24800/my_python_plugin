import Flutter
import UIKit
import PythonKit

public class MyPythonPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "python_script_channel", binaryMessenger: registrar.messenger())
        let instance = MyPythonPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "runPythonScript" {
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing username or password", details: nil))
                return
            }

            let username = args["username"] as? String ?? ""
            let password = args["password"] as? String ?? ""
            
            let messages = self.runPythonScript(username: username, password: password)
            result(messages)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func runPythonScript(username: String, password: String) -> String {
        let sys = Python.import("sys")
        let os = Python.import("os")
        let json = Python.import("json")

        // Get the script path
        let scriptPath = Bundle.main.path(forResource: "instagram_client", ofType: "py")!
        
        do {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
            process.arguments = [scriptPath, username, password]
            
            let outputPipe = Pipe()
            process.standardOutput = outputPipe
            try process.run()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let outputString = String(data: outputData, encoding: .utf8) ?? "{}"
            
            return outputString
        } catch {
            return json.dumps(["error": "Failed to run script"])
        }
    }
}
