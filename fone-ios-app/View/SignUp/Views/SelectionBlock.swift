//
//  SelectionBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then

/// 직업 or 관심사 선택 label + UICollectionView 영역
class SelectionBlock: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .font_m(15)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private var selectionList: [String] = ["aa","bb"]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.register(SelectionCell.self, forCellWithReuseIdentifier: SelectionCell.identifier)

        collectionView.dataSource = self
//        collectionView.delegate = self

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = .gray_F8F8F8
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [titleLabel, subtitleLabel, collectionView]
            .forEach { self.addSubview($0) }
    }
    
    private func setContraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
            $0.bottom.equalTo(titleLabel)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.greaterThanOrEqualTo(33) // TODO: 다른 높이 지정 방식 없는지 확인
            $0.bottom.equalToSuperview()
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitle(_ text: String) {
        subtitleLabel.text = text
    }
    
    func setSelections(_ list: [String]) {
        selectionList = list
    }
}

extension SelectionBlock {
    func bindViewModel() {
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.collectionView.cellForItem(at: indexPath) as? SelectionCell else { return }
                cell.changeSelectedState()
            }.disposed(by: rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }
}

extension SelectionBlock: UICollectionViewDataSource {
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionList.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SelectionCell.self)", for: indexPath) as? SelectionCell else {
            return UICollectionViewCell()
        }
        
        cell.label.text = selectionList[indexPath.row]
        cell.backgroundColor = .gray_EEEFEF
        cell.label.textColor = .gray_9E9E9E
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = collectionView.bounds.size
//        return CGSize(width: size.width * 0.8, height: size.height)
//    }

}


extension SelectionBlock: UICollectionViewDelegate {
    
    // MARK: selected
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("\(indexPath.item)번 Cell 클릭")
//        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectionCell else { return }
//
//        cell.changeSelectedState()
//
//    }
}

extension SelectionBlock: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    // TODO: 내부 contents 따라 유동적으로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 33.0
//        let size = SelectionCell.fittingSize(height: defaultHeight, name: selectionList[indexPath.row])
//
//        return CGSize(width: size.width, height: size.height)
        
        let collectionViewWidth = collectionView.bounds.width

        let cellItemForRow: CGFloat = 3
        let minimumSpacing: CGFloat = 2

        let width = (collectionViewWidth - (cellItemForRow - 1) * minimumSpacing) / cellItemForRow

        return CGSize(width: width, height: defaultHeight)
    }
    
    // MARK: minimumSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
