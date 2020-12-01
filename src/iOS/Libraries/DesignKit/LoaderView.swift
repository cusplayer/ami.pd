//
//  LoaderView.swift
//  DesignKit
//
//  Created by Artem Kufaev on 01.07.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

public class LoaderView: UIView {
    
    public static let instance = LoaderView()
    
    public var frameSize: CGFloat = 75
    public var padding: CGFloat = 40

    // MARK: - Subviews
    public private(set) lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()

    public private(set) lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.cornerRadius = cornerRadius
        return blurEffectView
    }()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    // MARK: - Configure
    private func setupLayout() {
        let windowFrame = UIScreen.main.bounds
        frame = CGRect(x: windowFrame.width / 2 - frameSize / 2,
                       y: windowFrame.height / 2 - frameSize / 2,
                       width: frameSize,
                       height: frameSize)
        addSubview(blurView)
        addSubview(indicatorView)
        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.blurView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.blurView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.blurView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            self.indicatorView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.indicatorView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    public func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows
                .filter({$0.isKeyWindow}).first else { return }
            window.addSubview(self)
            self.indicatorView.startAnimating()
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
}
