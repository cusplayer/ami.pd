//
//  ArticlesViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager

// MARK: - Builder

class ArticlesViewControllerBuilder {
    
    static func build() -> ArticlesViewController {
        let controller = ArticlesViewController()
        controller.articleManager = ArticleManager()
        controller.router = ArticleRouter(controller: controller)
        controller.errorParser = NetworkErrorParser()
        controller.errorParser.delegate = controller
        return controller
    }
    
}

private let reuseIdentifier = "Cell"
private let cellNibName = "ArticleCollectionViewCell"
private let padding: CGFloat = 20

class ArticlesViewController: UIViewController {
    
    // MARK: - Dependenses
    
    fileprivate var articleManager: ArticleManager!
    fileprivate var router: ArticleRouter!
    fileprivate var errorParser: NetworkErrorParser!
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    private var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = self.view.bounds
    }
    
    // MARK: - Configure
    
    private func setupCollectionView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: layout)
        view.addSubview(collectionView)
        self.view = view
        
        collectionView.register(UINib(nibName: cellNibName,
                                      bundle: nil),
                                forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Private
    
    private func loadData() {
        articleManager.get { (result) in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
}

// MARK: - Collection Flow Layout

extension ArticlesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - padding * 3) / 2
        let height = collectionView.frame.width / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
}

// MARK: Collection Data Source

extension ArticlesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath)
            as? ArticleCollectionViewCell else { fatalError() }
        
        let article = articles[indexPath.row]
        cell.setTitle(article.title)
        switch indexPath.row % 3 {
        case 0: cell.setColor(R.color.a845())
        case 1: cell.setColor(R.color.ffb547())
        case 2: cell.setColor(R.color.bcb4())
        default: break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        router.toContentViewer(article: article)
    }

}

extension ArticlesViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() {
        toMain()
    }
    
}
