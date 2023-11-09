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
    
    private var selections = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var images = [UIImage]()
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectionBlock: SelectionBlock!
    @IBOutlet weak var attachImageButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextView()
        setSelectionBlock()
        setCollectionView()
        nextButton.applyShadow(shadowType: .shadowBt)
    }
    
    func bindViewModel() {
        attachImageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPicker()
            }.disposed(by: rx.disposeBag)
    }
    
    private func setTextView() {
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainerInset = .zero
    }
    
    private func setSelectionBlock() {
        selectionBlock.setTitle("작품의 성격")
        selectionBlock.setSelections(Category.allCases)
    }
    
    private func setCollectionView() {
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self)
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
        }
    }
}

extension RecruitBasicInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ImageCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        
        return cell
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
