//
//  SplashVC.swift
//  JobTask
//
//  Created by Selçuk İleri on 6.11.2024.
//

import UIKit

final class SplashVC: UIViewController {

    var timer: Timer?
    var animationDuration: TimeInterval
    var appIcon: UIImage

    public init(appIcon: UIImage, animationDuration: TimeInterval = 1) {
        self.animationDuration = animationDuration
        self.appIcon = appIcon
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setGradientBackground()
    }

    public override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: { [self] in
            adjustWindow()
        })
    }

    func createUI() {
        let appIconImage = UIImageView()
        appIconImage.image = UIImage(named: "icon")
        appIconImage.layer.masksToBounds = true
        appIconImage.contentMode = .scaleAspectFit
        view.addSubview(appIconImage)

        appIconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
    }

    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.systemYellow.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc func adjustWindow() {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
