//
//  CustomizationViewController.swift
//  FSPopoverView_Example
//
//  Created by Sheng on 2023/12/2.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import FSPopoverView

class CustomizationViewController: UIViewController {
    
    private var hiddenArrow = false
    private var showsDimBackground = false
    private var shouldDismissOnTapOutside = true
    private var transition: FSPopoverViewAnimatedTransitioning?
    private weak var transitioning: FSPopoverViewAnimatedTransitioning?
    
    private lazy var ghostView: UIView = {
        let label = UILabel()
        label.text = "👻"
        label.font = .systemFont(ofSize: 120.0)
        label.textAlignment = .center
        return label
    }()
    
    private func p_createPopoverView() -> FSPopoverView {
        let popoverView = FSPopoverView()
        popoverView.dataSource = self
        popoverView.showsArrow = !hiddenArrow
        popoverView.showsDimBackground = showsDimBackground
        popoverView.transitioningDelegate = transitioning
        do {
            // border
//            popoverView.borderWidth = 1.0
//            popoverView.borderColor = .red
        }
        do {
            // shadow
//            popoverView.shadowColor = .green
//            popoverView.shadowRadius = 3.0
//            popoverView.shadowOpacity = 0.6
        }
        return popoverView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition = FSPopoverViewTransitionScale()
        transitioning = transition
    }
    
    @IBAction func changeHiddenArrow(_ sender: UISwitch) {
        hiddenArrow = sender.isOn ? true : false
    }
    
    @IBAction func changeShowsDimBackground(_ sender: UISwitch) {
        showsDimBackground = sender.isOn ? true : false
    }
    
    @IBAction func changeDismissOnTapOutside(_ sender: UISwitch) {
        shouldDismissOnTapOutside = sender.isOn ? true : false
    }
    
    @IBAction func onDidTapRightBarItem(_ sender: UIBarButtonItem) {
        let popoverView = p_createPopoverView()
        popoverView.present(fromBarItem: sender, offset: .init(x: 0.0, y: 20.0))
    }
    
    @IBAction func onDidTapPrecentButton(_ sender: UIButton) {
        let popoverView = p_createPopoverView()
        popoverView.present(fromRect: sender.frame.insetBy(dx: 0.0, dy: -6.0), in: view, displayIn: view)
    }
    
    @IBAction func onDidTapPrecentDownButton(_ sender: UIButton) {
        let popoverView = p_createPopoverView()
        popoverView.arrowDirection = .down
        popoverView.autosetsArrowDirection = false
        popoverView.present(fromView: sender, offset: .init(x: 0.0, y: -10.0))
    }
    
    @IBAction func onDidTapPrecentUpButton(_ sender: UIButton) {
        let popoverView = p_createPopoverView()
        popoverView.arrowDirection = .up
        popoverView.autosetsArrowDirection = false
        popoverView.present(fromView: sender, displayIn: view)
    }
    
    @IBAction func onDidTapChangeTransitionButton(_ sender: UIButton) {
        let items: [FSPopoverListItem] = ["Scale", "Fade", "Translate", "Custom", "None"].map { text in
            let item = FSPopoverListTextItem()
            item.title = text
            item.isSeparatorHidden = false
            item.contentInset = .init(top: 8.0, left: 18.0, bottom: 8.0, right: 18.0)
            item.separatorInset = item.contentInset
            item.selectedHandler = { [unowned self] item in
                guard let item = item as? FSPopoverListTextItem else { return }
                switch item.title {
                case "Scale":
                    self.transition = FSPopoverViewTransitionScale()
                    self.transitioning = self.transition
                case "Fade":
                    self.transition = FSPopoverViewTransitionFade()
                    self.transitioning = self.transition
                case "Translate":
                    self.transition = FSPopoverViewTransitionTranslate()
                    self.transitioning = self.transition
                case "Custom":
                    /// ⚠️ Here can not set `transition` to `self`, or it will cause
                    /// a memory leak. Because `self` retains `transition`.
                    self.transition = nil
                    self.transitioning = self
                case "None":
                    self.transition = nil
                    self.transitioning = nil
                default:
                    self.transition = FSPopoverViewTransitionScale()
                    self.transitioning = self.transition
                }
            }
            item.updateLayout()
            return item
        }
        items.last?.isSeparatorHidden = true
        
        let listView = FSPopoverListView(scrollDirection: .vertical)
        listView.items = items
        listView.showsArrow = !hiddenArrow
        listView.arrowDirection = .down
        listView.showsDimBackground = showsDimBackground
        listView.transitioningDelegate = transitioning
        listView.autosetsArrowDirection = false
        listView.shouldDismissOnTapOutside = shouldDismissOnTapOutside
        listView.present(
            fromRect: sender.frame.insetBy(dx: 0.0, dy: -6.0),
            in: sender.superview,
            displayIn: view
        )
    }
}

extension CustomizationViewController: FSPopoverViewDataSource {
    
    func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }
    
    func contentView(for popoverView: FSPopoverView) -> UIView? {
        return ghostView
    }
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize {
        return ghostView.sizeThatFits(.init(width: 1000.0, height: 1000.0))
    }
    
    func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        var insets = view.safeAreaInsets
        insets.left = 10.0
        insets.right = 10.0
        return insets
    }
    
    func popoverViewShouldDismissOnTapOutside(_ popoverView: FSPopoverView) -> Bool {
        return shouldDismissOnTapOutside
    }
}

extension CustomizationViewController: FSPopoverViewAnimatedTransitioning {
    
    func animateTransition(transitionContext context: FSPopoverViewTransitionContext) {
        
        let popoverView = context.popoverView
        let dimBackgroundView = context.dimBackgroundView
        
        switch context.scene {
        case .present:
            popoverView.transform = .init(scaleX: 1.1, y: 1.1)
            dimBackgroundView.alpha = 0.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.transform = .identity
                dimBackgroundView.alpha = 1.0
            } completion: { _ in
                context.completeTransition()
            }
        case .dismiss(_):
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.alpha = 0.0
                popoverView.transform = .init(scaleX: 0.9, y: 0.9)
                dimBackgroundView.alpha = 0.0
            } completion: { _ in
                popoverView.alpha = 1.0
                popoverView.transform = .identity
                dimBackgroundView.alpha = 1.0
                context.completeTransition()
            }
        }
    }
}
