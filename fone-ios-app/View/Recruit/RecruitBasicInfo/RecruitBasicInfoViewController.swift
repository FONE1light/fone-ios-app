//
//  RecruitBasicInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/1/23.
//

import UIKit
import PhotosUI

class RecruitBasicInfoViewController: UIViewController, ViewModelBindableType {
    var viewModel: RecruitBasicInfoViewModel!
    
    private var placeholderString = "모집 제목을 입력하세요"
    private var selections = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var images = [UIImage]()
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectionBlock: SelectionBlock!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var alwaysButton: UIButton!
    @IBOutlet weak var attachImageButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var imageCountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTextView()
        setSelectionBlock()
        setCollectionView()
        nextButton.applyShadow(shadowType: .shadowBt)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false // 스와이프백 안 되게
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true // 스와이프백 다시 가능하게
    }
    
    func bindViewModel() {
        titleTextView.rx.text.orEmpty
            .map { $0 == self.placeholderString ? "" : $0 }
            .map { $0.count }
            .map { String($0) }
            .map ({ count -> NSMutableAttributedString in
                let formattedString = NSMutableAttributedString()
                formattedString.setAttributeText("\(count)", .font_r(12), UIColor.gray_555555)
                formattedString.setAttributeText("/50", .font_r(12), UIColor.gray_C5C5C5)
                return formattedString
            })
            .bind(to: titleCountLabel.rx.attributedText)
            .disposed(by: rx.disposeBag)
        
        startDateButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = DatePickerViewController()
                vc.resultLabel = owner.startDateLabel
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }.disposed(by: rx.disposeBag)
        
        endDateButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = DatePickerViewController()
                vc.resultLabel = owner.endDateLabel
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }.disposed(by: rx.disposeBag)
        
        alwaysButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.startDateLabel.text = "시작일"
                owner.startDateLabel.textColor = .gray_9E9E9E
                owner.endDateLabel.text = "마감일"
                owner.endDateLabel.textColor = .gray_9E9E9E
                owner.alwaysButton.backgroundColor = .violet_362C4C
            }.disposed(by: rx.disposeBag)
        
        attachImageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPicker()
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.moveToNextStep()
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "배우 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .backWithAlert,
            viewController: self
        )
    }
    
    private func setTextView() {
        titleTextView.delegate = self
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainerInset = .zero
    }
    
    private func setSelectionBlock() {
        selectionBlock.setSelections(Category.allCases)
    }
    
    private func setCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self)
    }
    
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
            self.imageCollectionView.reloadData()
            updateImageCountLabel()
        }
    }
}

extension RecruitBasicInfoViewController: DateTimePickerVCDelegate {
    func updateDateTime(_ dateTime: String, label: UILabel?) {
        label?.text = dateTime
        label?.textColor = .gray_161616
        alwaysButton.backgroundColor = .gray_C5C5C5
    }
}

extension RecruitBasicInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension RecruitBasicInfoViewController: PHPickerViewControllerDelegate {
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

extension RecruitBasicInfoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetPlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextView.text == "" {
            textViewSetPlaceHolder()
        }
    }
    
    func textViewSetPlaceHolder() {
        if titleTextView.text == placeholderString {
            titleTextView.text = ""
            titleTextView.textColor = .black
        } else if titleTextView.text == "" {
            titleTextView.text = placeholderString
            titleTextView.textColor = .gray_9E9E9E
        }
    }
}
