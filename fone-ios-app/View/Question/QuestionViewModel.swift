//
//  QuestionViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/29.
//

import Foundation
import RxSwift

class QuestionViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var isKeyboardShowing = false
    var keyboardHeightBehaviorSubject = BehaviorSubject<CGFloat>(value: 0)
    var emailIsEmptySubject = BehaviorSubject<Bool>(value: true)
    var titleIsEmptySubject = BehaviorSubject<Bool>(value: true)
    var descriptionIsEmptySubject = BehaviorSubject<Bool>(value: true)
    var agreeButtonSelectedBehaviorSubject = BehaviorSubject<Bool>(value: false)
    
    lazy var submitButtonEnable: Observable<Bool> = {
        Observable.combineLatest(emailIsEmptySubject, titleIsEmptySubject, descriptionIsEmptySubject, agreeButtonSelectedBehaviorSubject) { (emailIsEmpty, titleIsEmpty, descriptionIsEmpty, agreed) -> Bool in
            
            return !emailIsEmpty && !titleIsEmpty && !descriptionIsEmpty && agreed
        }
    }()
    
    func submitQuestion(question: QuestionInfo) {
        questionInfoProvider.rx.request(.questions(questionInfo: question))
            .mapObject(SubmitQuestionModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                
                let toastMessage = response.result == "SUCCESS" ? "제출이 완료되었습니다." : "제출에 실패하였습니다. 다시 시도해주세요."
                toastMessage.toast(positionType: .withButton, isKeyboardShowing: owner.isKeyboardShowing)
            }, onError: { [weak self] _ in
                "제출에 실패하였습니다. 다시 시도해주세요.".toast(positionType: .withButton, isKeyboardShowing: self?.isKeyboardShowing ?? false)
            }).disposed(by: disposeBag)
    }
}

