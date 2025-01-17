// Copyright © 2019 hipolabs. All rights reserved.

/// <src>
/// https://danielgauthier.me/2020/02/24/vctransitions1.html

import Foundation
import UIKit

open class BottomSheetTransitionController:
    NSObject,
    UIViewControllerTransitioningDelegate {
    public var presentationConfiguration: BottomSheetPresentationConfiguration

    public let interactor: BottomSheetInteractor?

    public init(
        presentingViewController: UIViewController,
        presentationConfiguration: BottomSheetPresentationConfiguration =
            BottomSheetPresentationConfiguration(),
        completion: (() -> Void)? = nil
    ) {
        self.presentationConfiguration = presentationConfiguration
        
        if presentationConfiguration.isInteractable {
            self.interactor = BottomSheetInteractor(
                presentingViewController: presentingViewController,
                completion: completion
            )
        } else {
            self.interactor = nil
        }

        super.init()
    }

    /// <mark>
    /// UIViewControllerTransitioningDelegate
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return BottomSheetPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting,
            interactor: interactor,
            configuration: presentationConfiguration
        )
    }

    open func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimator(isPresenting: true)
    }

    open func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimator(isPresenting: false)
    }

    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        let isInteracting = interactor?.inProgress ?? false
        return isInteracting ? interactor : nil
    }
}
