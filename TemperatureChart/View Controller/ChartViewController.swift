//
//  ChartViewController.swift
//  TemperatureChart
//
//  Created by Triet Le on 13.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    // MARK: - Dependencies
    var viewModel: ChartViewModel!
    
    // MARK: - Private properties
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        label.text = "TODAYS TEMPERATURE"
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    lazy private var containerView: UIView = {
        let containerView = UIView()
        
        containerView.backgroundColor = .clear
        
        return containerView
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        addSubViews()
        bindingViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData(with: containerView.bounds)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Private methods
    private func bindingViewModel() {
        viewModel.viewCallback = { [weak self] view in
            DispatchQueue.main.async {
                self?.updateView(with: view)
            }
        }
    }
    
    private func updateView(with newView: UIView) {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.containerView.addSubview(newView)
            self?.containerView.bringSubviewToFront(newView)
        })
    }
    
    private func configUI() {
        view.setGradientBackground(colorTop: Color.topColor, colorBottom: Color.bottomColor)
    }
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
