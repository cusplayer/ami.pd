//
//  ArticleRouter.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager

class ArticleRouter: BaseRouter {
    
    func toContentViewer(article: Article) {
        let contentVC = ArticleContentViewController(article: article)
        contentVC.modalPresentationStyle = .formSheet
        present(contentVC, animated: true)
    }
    
}
