//
//  QuestionViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/29.
//

import UIKit

enum QuestionType: Int, CaseIterable {
    case USE_QUESTION = 1
    case ALLIANCE
    case VOICE_OF_THE_CUSTOMER
}

class QuestionViewController: UIViewController, ViewModelBindableType {
    var viewModel: QuestionViewModel!
    var selectedButtonTag: Int = 1
    var questionTypeString = "\(QuestionType.ALLIANCE)"
    let placeholerString = "요청에 관한 세부 정보를 입력하세요. 저희 에프원이 가능한 빨리 답변을 드리도록 하겠습니다."
    /// 해당 화면 진입 전 navigationBar hidden 상태
    var navigationBarHiddenOriginalState: Bool?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func toggleAgreeButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.agreeButtonSelectedBehaviorSubject.onNext(sender.isSelected)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let allButtonTags = [1, 2, 3]
        selectedButtonTag = sender.tag
        
        allButtonTags.filter { $0 != selectedButtonTag }.forEach { tag in
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.borderColor = UIColor.gray_D9D9D9
                button.setTitleColor(UIColor.gray_D9D9D9, for: .normal)
            }
        }
        
        sender.borderColor = UIColor.red_F43663
        sender.setTitleColor(UIColor.red_F43663, for: .normal)
        
        QuestionType.allCases.forEach {
            if $0.rawValue == selectedButtonTag {
                questionTypeString = "\($0)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.applyShadow(shadowType: .shadowIt2)
        agreeButton.setImage(UIImage(named: "checkboxes_off"), for: .normal)
        agreeButton.setImage(UIImage(named: "checkboxes_on"), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarHiddenOriginalState = navigationController?.navigationBar.isHidden
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = navigationBarHiddenOriginalState ?? false
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
                owner.viewModel.isKeyboardShowing = (keyboardHeight != 0)
            }).disposed(by: rx.disposeBag)
        
        emailTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind(to: viewModel.emailIsEmptySubject)
            .disposed(by: rx.disposeBag)
        
        titleTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind(to: viewModel.titleIsEmptySubject)
            .disposed(by: rx.disposeBag)
        
        descriptionTextView.rx.text.orEmpty
            .map { $0 == self.placeholerString ? "" : $0 }
            .map { $0.isEmpty }
            .bind(to: viewModel.descriptionIsEmptySubject)
            .disposed(by: rx.disposeBag)
        
        viewModel.submitButtonEnable
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isEnabled) in
                owner.submitButton.setEnabled(isEnabled: isEnabled)
            }).disposed(by: rx.disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.sceneCoordinator.close(animated: true)
            }).disposed(by: rx.disposeBag)
        
        submitButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let email = owner.emailTextField.text ?? ""
                let type = owner.questionTypeString
                let title = owner.titleTextField.text ?? ""
                let description = owner.descriptionTextView.text == owner.placeholerString ? "" : owner.descriptionTextView.text
                let agreeToPersonalInformation = owner.agreeButton.isSelected
                let question = QuestionInfo(email: email, type: type, title: title, description: description ?? "", agreeToPersonalInformation: agreeToPersonalInformation)
                owner.viewModel.submitQuestion(question: question)
            }.disposed(by: rx.disposeBag)
    }
}

extension QuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetPlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text == "" {
            textViewSetPlaceHolder()
        }
    }
    
    func textViewSetPlaceHolder() {
        if descriptionTextView.text == placeholerString {
            descriptionTextView.text = ""
            descriptionTextView.textColor = .black
        } else if descriptionTextView.text == "" {
            descriptionTextView.text = placeholerString
            descriptionTextView.textColor = .gray_9E9E9E
        }
    }
}
