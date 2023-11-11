import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let engine = DIContainer.shared.resolve(type: UsersEngine.self)
        let router = Router(engine: engine)
        window?.rootViewController = router.navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}

