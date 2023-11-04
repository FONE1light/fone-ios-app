//
//  RecruitBasicInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/1/23.
//

import UIKit

class RecruitBasicInfoViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var selectionBlock: SelectionBlock!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextView()
        setSelectionBlock()
        nextButton.applyShadow(shadowType: .shadowBt)
    }
    
    private func setTextView() {
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainerInset = .zero
    }
    
    private func setSelectionBlock() {
        selectionBlock.setTitle("작품의 성격")
        selectionBlock.setSelections(Category.allCases)
    }
}
