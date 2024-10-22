//
//  RecruitWorkInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/4/23.
//

import UIKit

class RecruitWorkInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var produceTextField: LabelTextField!
    @IBOutlet weak var titleTextField: LabelTextField!
    @IBOutlet weak var directorTextField: LabelTextField!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var privateButton: CustomButton!
    @IBOutlet weak var loglineTextView: LetterCountedTextView!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitWorkInfoViewModel!
    var jobType = Job.actor
    private let genres: [Genre] = [.ACTION, .DRAMA, .THRILLER, .MUSICAL, .ROMANCE, .FANTASY, .DOCUMENTARY, .ETC]
    private let placeholder = "이야기의 방향을 알 수 있는 요약된 줄거리를 적어주세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.allowsMultipleSelection = true
        genreCollectionView.register(GenreCell.self)
    }
    
    func bindViewModel() {
        keyboardHeight()
            .bind(to: viewModel.keyboardHeightBehaviorSubject)
            .disposed(by: rx.disposeBag)
        
        viewModel.keyboardHeightBehaviorSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, keyboardHeight) in
                owner.scrollView.contentInset.bottom = keyboardHeight
                owner.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            }).disposed(by: rx.disposeBag)
        
        loglineTextView.textView?.rx.text
            .withUnretained(self)
            .bind { owner, text in
                guard let text else {
                    owner.privateButton.isActivated = true
                    return
                }
                if text.isEmpty {
                    owner.privateButton.isActivated = true
                } else if text == owner.placeholder {
                    owner.privateButton.isActivated = true
                } else {
                    owner.privateButton.isActivated = false
                }
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let produce = owner.produceTextField.textField?.text
                let workTitle = owner.titleTextField.textField?.text
                let director = owner.directorTextField.textField?.text
                let genres = (owner.genreCollectionView.indexPathsForSelectedItems ?? []).map { owner.genres[$0.row].rawValue }
                let logline = owner.loglineTextView.textView?.text == owner.placeholder ? nil : owner.loglineTextView.textView?.text
                let recruitWorkInfo = RecruitWorkInfo(produce: produce, workTitle: workTitle, director: director, genres: genres, logline: logline)
                owner.viewModel.validateProject(recruitWorkInfo: recruitWorkInfo)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "\(jobType.koreanName) 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.xibInit(index: 3, totalCount: 7)
        produceTextField.xibInit(label: "제작", placeholder: "제작 주체(회사, 학교, 단체 등의 이름)", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 54)
        titleTextField.xibInit(label: "제목", placeholder: "작품 제목", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 54)
        directorTextField.xibInit(label: "연출", placeholder: "연출자 이름", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 54)
        privateButton.xibInit("비공개", type: .clear)
        loglineTextView.xibInit(placeholder: placeholder, textViewHeight: 187, maximumLetterCount: 200)
        nextButton.applyShadow(shadowType: .shadowBt)
    }
}

extension RecruitWorkInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genre = genres[indexPath.row]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GenreCell
        cell.configure(genre: genre)
        return cell
    }
}

extension RecruitWorkInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return collectionView.indexPathsForSelectedItems?.count ?? 0 < 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GenreCell {
            cell.isSelected.toggle()
        }
    }
}


extension RecruitWorkInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 59, height: 80)
    }
}
