//
//  RegisterBasicInfoViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

class RegisterBasicInfoViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterBasicInfoViewModel!
    
    var disposeBag = DisposeBag()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let stepIndicator = StepIndicator(index: 1, totalCount: 6)
    
    private let titleLabel = UILabel().then {
        $0.text = "기본 정보를 입력해주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
        $0.numberOfLines = 0
    }
    
    private let nameBlock = LabelTextField(
        label: "이름",
        placeholder: "실명을 입력해주세요",
        isRequired: true
    )
    private let hookingBlock = LabelTextView(
        label: "후킹멘트",
        placeholder: "당신을 표현하는 한 줄을 적어주세요",
        isRequired: true
    )
    
    // MARK: - 이미지 첨부
    private let attachImageLabelBlock = UIView()
    private let attachImagelabel = UILabel().then {
        $0.text = "이미지 첨부"
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(resource: .star)
    }

    private let attachedImagesView = UIView()
    
    private let imageCountView = UIView().then {
        $0.backgroundColor = .gray_C5C5C5
        $0.cornerRadius = 5
    }
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(named: "Camera")
    }
    private let imageCountLabel = UILabel().then {
        $0.text = "0 / 9"
        $0.font = .font_r(13)
        $0.textColor = .white
    }
    
    private let attachImageButton = UIButton()
    
    var attachImageButtonTap: ControlEvent<Void> {
        attachImageButton.rx.tap
    }
    
    var selections = [String: PHPickerResult]()
    var selectedAssetIdentifiers = [String]()
    private var images = [UIImage]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private let descriptionLabel = UILabel().then {
        $0.text = "갤러리에 있는 사진만 올릴 수 있습니다."
        $0.font = .font_m(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let nextButton = CustomButton("다음", type: .bottom)
    
    func bindViewModel() {
        setNavigationBar() // viewModel 바인딩 된 후 navigationBar의 title 설정
        
        attachImageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPicker()
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.uploadImages(images: owner.images) { imageUrls in
                    owner.viewModel.validate(
                        name: owner.nameBlock.textField?.text,
                        hookingComment: owner.hookingBlock.text,
                        profileImages: imageUrls
                    )
                }
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "\(viewModel.jobType?.koreanName ?? "") 등록하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .backWithAlert,
            viewController: self
        )
    }
    
    private func addSubviews() {
        view.backgroundColor = .white_FFFFFF
        
        [
            stepIndicator,
            stackView,
            nextButton
        ]
            .forEach { view.addSubview($0) }
        
        [
            titleLabel,
            EmptyView(height: 12),
            nameBlock,
            EmptyView(height: 30),
            hookingBlock,
            EmptyView(height: 30),
            
            attachImageLabelBlock,
            EmptyView(height: 8),
            attachedImagesView, // 하위 뷰 포함
            EmptyView(height: 4),
            descriptionLabel
        ]
            .forEach { stackView.addArrangedSubview($0) }
        
        [
            attachImagelabel,
            starImageView
        ]
            .forEach { attachImageLabelBlock.addSubview($0) }
        [
            imageCountView, // 하위 뷰 포함
            collectionView
        ]
            .forEach { attachedImagesView.addSubview($0) }
        [
            cameraImageView,
            imageCountLabel,
            attachImageButton
        ]
            .forEach { imageCountView.addSubview($0) }
        
    }
    
    private func setConstraints() {
        stepIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(stepIndicator.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(stackView)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
        
        // attachImageLabelBlock 내부
        attachImagelabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalTo(attachImagelabel)
            $0.leading.equalTo(attachImagelabel.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        // attachedImagesView 내부
        imageCountView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(imageCountView.snp.trailing).offset(8)
        }
        
        // imageCountView 내부
        cameraImageView.snp.makeConstraints {
            $0.size.equalTo(45)
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
        
        imageCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        attachImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

extension RegisterBasicInfoViewController {
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 9
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
}

extension RegisterBasicInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var newSelections = [String: PHPickerResult]()
        for result in results {
            if let identifier = result.assetIdentifier {
                newSelections[identifier] = selections[identifier] ?? result
            }
        }
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        setImageArray()
    }
}


extension RegisterBasicInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ImageCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        cell.dimView.isHidden = indexPath.row != 0
        cell.thumbnailLabel.isHidden = indexPath.row != 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        images.remove(at: index)
        selectedAssetIdentifiers.remove(at: index)
        collectionView.reloadData()
        updateImageCountLabel()
    }
}

extension RegisterBasicInfoViewController {
    private func updateImageCountLabel() {
        let formattedString = NSMutableAttributedString()
        formattedString.setAttributeText("\(images.count) / ", .font_r(13), UIColor.white_FFFFFF)
        let color = images.count == 0 ? UIColor.gray_EEEFEF : UIColor.violet_AFA3CA
        formattedString.setAttributeText("9", .font_r(13), color)
        imageCountLabel.attributedText = formattedString
        
        if images.count == 0 {
            imageCountView.backgroundColor = UIColor.gray_C5C5C5
        } else {
            imageCountView.backgroundColor = UIColor.violet_362C4C
        }
    }
    
    private func setImageArray() {
        let dispatchGroup = DispatchGroup()
        var imagesDict = [String: UIImage]()
        
        for (identifier, result) in selections {
            
            dispatchGroup.enter()
            
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.images = []
            for identifier in self.selectedAssetIdentifiers {
                guard let image = imagesDict[identifier] else { return }
                self.images.append(image)
            }
            collectionView.reloadData()
            updateImageCountLabel()
        }
    }
}
