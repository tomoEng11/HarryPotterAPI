//
//  ViewController.swift
//  HarryPotterAPI
//
//  Created by 井本智博 on 2024/03/31.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {

    enum Section {
        case main
    }

    var datasource: UICollectionViewDiffableDataSource<Section, HPModel>!
    var collectionView: UICollectionView!
    var items: [HPModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        DLog()
//        API.shared.getData() { result in
//            switch result {
//            case.success(let items):
//                DLog()
//                self.items = items
//
//            case.failure(let error):
//                print(error)
//            }
//            DLog()
//            Task {
//                var snapshot = NSDiffableDataSourceSnapshot<Section, HPModel>()
//                snapshot.appendSections([.main])
//                snapshot.appendItems(self.items)
//                //async-version
//                await self.datasource.apply(snapshot, animatingDifferences: true)
//            }
//            DLog()
//        }
        Task {
            self.items = await API.shared.getData()
            var snapshot = NSDiffableDataSourceSnapshot<Section, HPModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.items)
            //async-version
            await self.datasource.apply(snapshot, animatingDifferences: true)
        }
        DLog()
    }
}

extension ViewController {
    //flowLayoutの設定(List)
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ViewController {
    private func configureHierarchy() {
        //collectionViewの初期化とオートレイアウト
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
}

extension ViewController {
    private func configureDataSource() {
        //cellの登録とcellの内容設定
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HPModel> {
            (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            cell.contentConfiguration = content
        }

        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            //cellRegistrationを使ってcellの再利用
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
}
