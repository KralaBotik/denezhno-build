import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private var privacyCover: UIView?

  override func sceneWillResignActive(_ scene: UIScene) {
    if let window = window {
      let cover = Self.makePrivacyCover(frame: window.bounds)
      window.addSubview(cover)
      privacyCover?.removeFromSuperview()
      privacyCover = cover
    }
    super.sceneWillResignActive(scene)
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    if UIApplication.shared.isProtectedDataAvailable {
      privacyCover?.removeFromSuperview()
      privacyCover = nil
    }
  }

  /// Opaque cover for the app switcher snapshot, Control Center, notifications.
  /// It must stay OPAQUE (no blur/transparency): app content must not be
  /// recoverable from the snapshot. The icon and name only show that the
  /// screen is hidden on purpose.
  private static func makePrivacyCover(frame: CGRect) -> UIView {
    let cover = UIView(frame: frame)
    cover.backgroundColor = .systemBackground
    cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    cover.accessibilityElementsHidden = true

    let icon = UIImageView(image: UIImage(systemName: "rublesign.circle.fill"))
    icon.tintColor = .systemBlue
    icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 64)

    let title = UILabel()
    title.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)
      ?? "Денежно"
    title.font = .preferredFont(forTextStyle: .title2)
    title.textColor = .secondaryLabel

    let stack = UIStackView(arrangedSubviews: [icon, title])
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    cover.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: cover.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: cover.centerYAnchor),
    ])
    return cover
  }
}
