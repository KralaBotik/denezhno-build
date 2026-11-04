import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "app.denezhno/storage",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "prepareStorage" || call.method == "verifyStorage" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard UIApplication.shared.isProtectedDataAvailable else {
        result(FlutterError(code: "protected_data_unavailable", message: nil, details: nil))
        return
      }
      // Diagnostic label only: where the failure happened. Fixed strings, never paths.
      var stage = "app_support_dir"
      do {
        let manager = FileManager.default
        var directory = try manager.url(for: .applicationSupportDirectory,
          in: .userDomainMask, appropriateFor: nil, create: true)
          .appendingPathComponent("Denezhno", isDirectory: true)
        stage = "create_directory"
        try manager.createDirectory(at: directory, withIntermediateDirectories: true,
          attributes: [.protectionKey: FileProtectionType.complete])
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        stage = "set_backup_exclusion"
        try directory.setResourceValues(values)
        stage = "list_directory"
        let files = try manager.contentsOfDirectory(at: directory,
          includingPropertiesForKeys: nil)
        for url in [directory] + files {
          stage = "set_file_protection"
          try manager.setAttributes([.protectionKey: FileProtectionType.complete],
            ofItemAtPath: url.path)
          stage = "read_file_attributes"
          let attributes = try manager.attributesOfItem(atPath: url.path)
          let raw = attributes[.protectionKey]
          #if targetEnvironment(simulator)
          // The iOS Simulator has no Data Protection: the attribute is absent
          // (observed in CI: protection_mismatch=absent). Owner-approved R1.5
          // exception: only absence is accepted, only in simulator builds; any
          // other value still fails. This does NOT verify protection; that stays
          // an on-device check. Device builds compile without this exception.
          let simulatorWithoutProtection = raw == nil
          #else
          let simulatorWithoutProtection = false
          #endif
          guard simulatorWithoutProtection
            || raw as? String == FileProtectionType.complete.rawValue else {
            // Same failure condition as before; the label records what was observed.
            let observed = raw == nil ? "absent" : ((raw as? String) ?? "nonstring")
            stage = "protection_mismatch=\(observed)"
            throw NSError(domain: "DenezhnoStorage", code: 1)
          }
        }
        stage = "read_backup_exclusion"
        guard try directory.resourceValues(forKeys: [.isExcludedFromBackupKey])
          .isExcludedFromBackup == true else {
          throw NSError(domain: "DenezhnoStorage", code: 2)
        }
        result(call.method == "prepareStorage" ? directory.path : nil)
      } catch {
        let nsError = error as NSError
        // Do not leak filesystem paths or native exception messages: only the
        // stage label, error domain and numeric code are reported.
        result(FlutterError(code: "storage_protection_failed", message: nil,
          details: "\(stage);\(nsError.domain);\(nsError.code)"))
      }
    }
  }
}
