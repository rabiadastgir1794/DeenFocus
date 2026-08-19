import Flutter
import Foundation

/// MethodChannel + EventChannel for downloadable Quran translations (ADR-009).
final class QuranTranslationChannelHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private let workQueue = DispatchQueue(label: "com.app.deenly.quran_translation", qos: .utility)

  func register(messenger: FlutterBinaryMessenger) {
    let method = FlutterMethodChannel(
      name: "com.app.deenly.deenly/quran_translations",
      binaryMessenger: messenger
    )
    let events = FlutterEventChannel(
      name: "com.app.deenly.deenly/quran_translation_events",
      binaryMessenger: messenger
    )
    events.setStreamHandler(self)
    method.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  private func emitProgress(_ progress: Double) {
    DispatchQueue.main.async { [weak self] in
      self?.eventSink?([
        "type": "downloadProgress",
        "progress": progress,
      ])
    }
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "listAvailableTranslations":
      workQueue.async {
        do {
          let args = call.arguments as? [String: Any]
          let forceRefresh = (args?["forceRefresh"] as? Bool) ?? true
          let entries: [TranslationCatalogEntry]
          if forceRefresh {
            do {
              entries = try TranslationCatalogCache.shared.translationEntries(forceRefresh: true)
            } catch {
              // Offline / transient — show last known catalog rather than empty.
              entries = (try? TranslationCatalogCache.shared.translationEntries(forceRefresh: false)) ?? []
            }
          } else {
            entries = try TranslationCatalogCache.shared.translationEntries(forceRefresh: false)
          }
          let payload = entries.map { entry -> [String: Any] in
            var row: [String: Any] = [
              "language": entry.language,
              "packId": entry.packId,
              "displayName": entry.displayName as Any,
              "installed": TranslationStore.shared.isAvailable(entry.language),
            ]
            if let size = entry.approxSizeBytes {
              row["approxSizeBytes"] = size
            }
            return row
          }
          DispatchQueue.main.async { result(payload) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "CATALOG_FAILED", message: error.localizedDescription, details: nil))
          }
        }
      }

    case "hasTranslationPack":
      guard let args = call.arguments as? [String: Any],
        let languageCode = args["languageCode"] as? String
      else {
        result(FlutterError(code: "INVALID_ARGS", message: "languageCode required", details: nil))
        return
      }
      workQueue.async {
        let has = (try? TranslationCatalogCache.shared.entry(forLanguage: languageCode)) != nil
        DispatchQueue.main.async { result(has) }
      }

    case "isTranslationAvailable":
      guard let args = call.arguments as? [String: Any],
        let languageCode = args["languageCode"] as? String
      else {
        result(FlutterError(code: "INVALID_ARGS", message: "languageCode required", details: nil))
        return
      }
      result(TranslationStore.shared.isAvailable(languageCode))

    case "getTranslationPath":
      guard let args = call.arguments as? [String: Any],
        let languageCode = args["languageCode"] as? String
      else {
        result(FlutterError(code: "INVALID_ARGS", message: "languageCode required", details: nil))
        return
      }
      let path = TranslationStore.shared.translationFileURL(languageCode)
      result(FileManager.default.fileExists(atPath: path.path) ? path.path : NSNull())

    case "ensureTranslation":
      guard let args = call.arguments as? [String: Any],
        let languageCode = args["languageCode"] as? String
      else {
        result(FlutterError(code: "INVALID_ARGS", message: "languageCode required", details: nil))
        return
      }
      workQueue.async { [weak self] in
        do {
          try TranslationStore.shared.ensureTranslation(languageCode: languageCode) { progress in
            self?.emitProgress(progress)
          }
          DispatchQueue.main.async { result(true) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "DOWNLOAD_FAILED", message: error.localizedDescription, details: nil))
          }
        }
      }

    case "refreshCatalog":
      workQueue.async {
        do {
          _ = try TranslationCatalogCache.shared.catalog(forceRefresh: true)
          DispatchQueue.main.async { result(true) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "CATALOG_FAILED", message: error.localizedDescription, details: nil))
          }
        }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
