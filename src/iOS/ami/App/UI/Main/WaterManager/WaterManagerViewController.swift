//
//  WaterManagerViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import UIUtils
import DataManager

// MARK: - Builder

class WaterManagerViewControllerBuilder {
    
    static func build() -> WaterManagerViewController {
        let controller = WaterManagerViewController()
        controller.router = WaterManagerRouter(controller: controller)
        controller.waterManager = WaterManager()
        controller.weightManager = WeightManager()
        controller.errorParser = NetworkErrorParser()
        controller.errorParser.delegate = controller
        return controller
    }
    
}

// MARK: - Constants

private let cellNibName = "WaterCollectionViewCell"
private let reuseId = "WaterCellReusable"

class WaterManagerViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var drinkWaterButton: UIButton!
    @IBOutlet weak var waterEnoughLabel: UILabel!
    
    // MARK: - Dependenses
    
    fileprivate var router: WaterManagerRouter!
    fileprivate var waterManager: WaterManager!
    fileprivate var weightManager: WeightManager!
    fileprivate var errorParser: NetworkErrorParser!
    
    // MARK: - Properties
    
    private var waterHistory: [WaterInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                let waterInfoCount = self.waterHistory.count
                self.lastFilledGlassIndex = waterInfoCount >= self.glassCount ?
                    self.glassCount - 1 :
                    waterInfoCount - 1
                self.checkIsWaterEnough()
                self.collectionView.reloadData()
            }
        }
    }
    
    private var weight: WeightInfo? {
        didSet {
            DispatchQueue.main.async {
                if let weight = self.weight {
                    let weight = weight.amount.rounded(toPlaces: 2)
                    self.waterAmountLabel.text = "Количество воды расчитано на \(weight)кг"
                    self.drinkWaterButton.isHidden = false
                    self.drinkWaterButton.isEnabled = true
                } else {
                    self.waterAmountLabel.text = "Отсутствуют данные вашего веса"
                    self.drinkWaterButton.isHidden = true
                    self.drinkWaterButton.isEnabled = false
                }
                self.checkIsWaterEnough()
                self.collectionView.reloadData()
            }
        }
    }
    
    private var glassCount: Int {
        let weight = self.weight?.amount ?? 0
        return Int(weight * 30 / 200)
    }
    
    private var lastFilledGlassIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Configure
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                            target: self,
                                                            action: #selector(openHistory))
        navigationItem.rightBarButtonItem?.tintColor = R.color.ba2()
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: cellNibName, bundle: nil),
                                forCellWithReuseIdentifier: reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Actions

    @IBAction func drinkWater(_ sender: Any) {
        lastFilledGlassIndex += 1
        checkIsWaterEnough()
        fillGlass(for: lastFilledGlassIndex)
        saveWater(for: lastFilledGlassIndex)
    }
    
    // MARK: - Private
    
    @objc
    private func openHistory() {
        router.toHistory()
    }
    
    private func loadData() {
        weightManager.get { (result) in
            switch result {
            case .success(let history):
                self.weight = history
                    .sorted { $0.weighedAt > $1.weighedAt }
                    .first
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.localizedDescription)
            }
        }
        waterManager.get { (result) in
            switch result {
            case .success(let history):
                let calendar = Calendar.current
                self.waterHistory = history
                    .sorted { $0.drinkedAt > $1.drinkedAt }
                    .filter { calendar.isDateInToday($0.drinkedAt) }
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.localizedDescription)
            }
        }
    }
    
    private func saveWater(for index: Int) {
        waterManager.save(amount: 200, drinkedAt: Date()) { (result) in
            switch result {
            case .success(let info):
                self.waterHistory.append(info)
            case .failure(let error):
                self.fillGlass(for: index)
                self.showAlert(alertText: "Ошибка", alertMessage: error.localizedDescription)
            }
        }
    }
    
    private func fillGlass(for number: Int) {
        let index = IndexPath(row: number, section: 0)
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [index])
        }
    }
    
    private func checkIsWaterEnough() {
        guard weight != nil else { return }
        let isWaterEnough = lastFilledGlassIndex + 1 == glassCount
        drinkWaterButton.isEnabled = !isWaterEnough
        drinkWaterButton.isHidden = isWaterEnough
        waterEnoughLabel.isHidden = !isWaterEnough
    }
    
    private func fillGlass(_ cell: WaterCollectionViewCell, for indexPath: IndexPath) {
        let color = indexPath.row > lastFilledGlassIndex ?
            R.color.ffb547() :
            R.color.ba2()
        cell.setColor(color)
    }
    
}

// MARK: - Collection Flow Layout

extension WaterManagerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = GraphicHelper.calculateSizeOfSquaresInRectangle(rectangleSize: collectionView.bounds.size,
                                                                   squareCount: glassCount)
        return size.width >= 70 ? CGSize(width: 70, height: 70) : size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - Collection Data Source

extension WaterManagerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return glassCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                            for: indexPath) as? WaterCollectionViewCell else { fatalError() }
        fillGlass(cell, for: indexPath)
        return cell
    }
    
}

// MARK: - NetworkErrorParserDelegate

extension WaterManagerViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() {
        toMain()
    }
    
}
