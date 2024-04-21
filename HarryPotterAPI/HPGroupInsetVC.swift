//
//  HPGroupInsetVC.swift
//  HarryPotterAPI
//
//  Created by 井本智博 on 2024/04/20.
//

import UIKit

class HPGroupInsetVC: UIViewController {

    private enum Section: CaseIterable {
       case Gryffindor, Slytherin, Hufflepuff, Ravenclaw

        var houseName: String {
            switch self {
            case.Gryffindor:
                return "Gryffindor"
            case .Slytherin:
                return "Slytherin"
            case .Hufflepuff:
                return "Hufflepuff"
            case .Ravenclaw:
                return "Ravenclaw"
            }
        }
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, HPModel>!
    private var items: [HPModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHiarachy()
        configureDataSource()

        Task {
            items = await API.shared.getData()
            var snapshot = NSDiffableDataSourceSnapshot<Section, HPModel>()
            snapshot.appendSections(Section.allCases)

            Section.allCases.forEach { section in
                let itemsForSection = items.filter { $0.house == section.houseName }
//                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
                snapshot.appendItems(itemsForSection, toSection: section)
//                sectionSnapshot.append([section.houseName], to: section.houseName)
            }
            await dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

private extension HPGroupInsetVC {
    func configureHiarachy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
}

private extension HPGroupInsetVC {
    func configureDataSource() {

        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HPModel> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.house
            cell.contentConfiguration = content
            //ここもう少し深掘りする
            cell.accessories = [.outlineDisclosure()]
        }
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HPModel> { (cell, indexPath, item) in

            var content = cell.defaultContentConfiguration()
            content.text = item.name
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.row == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
    }
}

private extension HPGroupInsetVC {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
}
