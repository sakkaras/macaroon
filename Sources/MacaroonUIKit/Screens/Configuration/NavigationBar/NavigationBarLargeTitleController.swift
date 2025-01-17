// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class NavigationBarLargeTitleController<SomeScreen: NavigationBarLargeTitleConfigurable> {
    public var title: String? {
        didSet { setNeedsTitleAppearanceUpdate() }
    }

    public var additionalScrollEdgeOffset: LayoutMetric = 0

    public var titleAttributes: [AttributedTextBuilder.Attribute] = []
    public var largeTitleAttributes: [AttributedTextBuilder.Attribute] = []

    public unowned let screen: SomeScreen

    private var scrollingObservation: NSKeyValueObservation?
    private var runningTitleVisibilityAnimator: UIViewPropertyAnimator?

    private var minContentOffsetYForVisibleLargeTitle: CGFloat {
        let scrollView = screen.navigationBarScrollView
        let largeTitleView = screen.navigationBarLargeTitleView
        let finalScrollEdgeOffset = largeTitleView.scrollEdgeOffset + additionalScrollEdgeOffset

        if !largeTitleView.isDescendant(
               of: scrollView
            ) {
            return -finalScrollEdgeOffset
        }

        return
            largeTitleView.frame.maxY -
            finalScrollEdgeOffset
    }

    private var isTitleVisible = true

    public init(
        screen: SomeScreen
    ) {
        self.screen = screen
    }

    deinit {
        deactivate()
    }
}

extension NavigationBarLargeTitleController {
    public func setNeedsTitleAppearanceUpdate() {
        screen.navigationBarTitleView.title =
            title.unwrap {
                .attributedString(
                    $0.attributed(
                        titleAttributes
                    )
                )
            }
        screen.navigationBarLargeTitleView.title =
            title.unwrap {
                .attributedString(
                    $0.attributed(
                        largeTitleAttributes
                    )
                )
            }

        screen.navigationItem.titleView = screen.navigationBarTitleView
    }
}

extension NavigationBarLargeTitleController {
    public func activate() {
        scrollingObservation =
            screen.navigationBarScrollView.observe(
                \.contentOffset,
                options: .new
            ) { [weak self] _, change in

                guard let self = self else {
                    return
                }

                let contentOffsetY = change.newValue?.y ?? 0

                self.updateLargeTitleLayoutIfNeeded(
                    forScrollAtPoint: contentOffsetY)
                self.toggleTitleVisibilityIfNeeded(
                    forScrollAtPoint: contentOffsetY,
                    animated: self.screen.isNavigationBarAppeared
                )
            }
    }

    public func deactivate() {
        scrollingObservation?.invalidate()
        scrollingObservation = nil
    }
}

extension NavigationBarLargeTitleController {
    public func scrollViewWillEndDragging(
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>,
        contentOffsetDeltaYBelowLargeTitle: CGFloat
    ) {
        let largeTitleView = screen.navigationBarLargeTitleView
        let contentOffset = targetContentOffset.pointee

        if contentOffset.y > minContentOffsetYForVisibleLargeTitle {
            return
        }

        targetContentOffset.pointee =
            CGPoint(
                x: contentOffset.x,
                y: min(contentOffset.y, contentOffset.y + largeTitleView.frame.minY)
            )
    }
}

extension NavigationBarLargeTitleController {
    private func updateLargeTitleLayoutIfNeeded(
        forScrollAtPoint point: CGFloat
    ) {
        let scrollView = screen.navigationBarScrollView
        let largeTitleView = screen.navigationBarLargeTitleView

        if largeTitleView.isDescendant(
               of: scrollView
           ) {
            return
        }

        largeTitleView.snp.updateConstraints {
            $0.top == -(point + scrollView.contentInset.top)
        }
    }
}

extension NavigationBarLargeTitleController {
    private func toggleTitleVisibilityIfNeeded(
        forScrollAtPoint point: CGFloat,
        animated: Bool
    ) {
        let isLargeTitleVisible =
            point < minContentOffsetYForVisibleLargeTitle
        let isTitleVisible = !isLargeTitleVisible

        if self.isTitleVisible == isTitleVisible {
            return
        }

        self.isTitleVisible = isTitleVisible

        if !animated {
            setTitleVisible(isTitleVisible)
            return
        }

        if let runningTitleVisibilityAnimator = runningTitleVisibilityAnimator,
           runningTitleVisibilityAnimator.isRunning {
            runningTitleVisibilityAnimator.isReversed.toggle()
            return
        }

        if isTitleVisible {
            showTitleAnimated()
        } else {
            hideTitleAnimated()
        }
    }

    private func showTitleAnimated() {
        runningTitleVisibilityAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [],
            animations: {
                [unowned self] in
                self.setTitleVisible(true)
            },
            completion: { [weak self] position in
                guard let self = self else { return }

                switch position {
                case .start:
                    self.setTitleVisible(false)
                case .end:
                    self.isTitleVisible = true
                default:
                    break
                }
            }
        )
    }

    private func hideTitleAnimated() {
        runningTitleVisibilityAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                [unowned self] in
                self.setTitleVisible(false)
            },
            completion: { [weak self] position in
                guard let self = self else { return }

                switch position {
                case .start:
                    self.setTitleVisible(true)
                case .end:
                    self.isTitleVisible = false
                default:
                    break
                }
            }
        )
    }

    private func setTitleVisible(
        _ visible: Bool
    ) {
        screen.navigationBarTitleView.titleAlpha = visible ? 1 : 0
        screen.navigationBarLargeTitleView.alpha = visible ? 0 : 1
    }
}
