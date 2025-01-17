// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIScrollView {
    public var isScrollable: Bool {
        return contentSize.height > bounds.height
    }
}

extension UIScrollView {
    public var isScrollOnTop: Bool {
        return contentOffset.y <= -adjustedContentInset.top
    }

    public func calculateContentOffsetForScrollOnTop() -> CGPoint {
        return CGPoint(x: contentOffset.x, y: -contentInset.top)
    }
}

extension UIScrollView {
    public var isBouncingOnTop: Bool {
        return contentOffset.y < -adjustedContentInset.top
    }
}

extension UIScrollView {
    public func setContentInset(
        _ contentInset: LayoutPaddings
    ) {
        setContentInset(
            horizontal: (contentInset.leading, contentInset.trailing)
        )
        setContentInset(
            vertical: (contentInset.top, contentInset.bottom)
        )
    }

    public func setContentInset(
        horizontal: LayoutHorizontalPaddings
    ) {
        setContentInset(
            left: horizontal.leading
        )
        setContentInset(
            right: horizontal.trailing
        )
    }

    public func setContentInset(
        vertical: LayoutVerticalPaddings
    ) {
        setContentInset(
            top: vertical.top
        )
        setContentInset(
            bottom: vertical.bottom
        )
    }

    public func setContentInset(
        top: LayoutMetric
    ) {
        if top.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.top = top
        contentInset = mContentInset
    }

    public func setContentInset(
        left: LayoutMetric
    ) {
        if left.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.left = left
        contentInset = mContentInset
    }

    public func setContentInset(
        bottom: LayoutMetric
    ) {
        if bottom.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.bottom = bottom
        contentInset = mContentInset
    }

    public func setContentInset(
        right: LayoutMetric
    ) {
        if right.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.right = right
        contentInset = mContentInset
    }
}

extension UIScrollView {
    public func setContentOffset(
        x: LayoutMetric
    ) {
        if x.isNoMetric {
            return
        }

        var mContentOffset = contentOffset
        mContentOffset.x = x
        contentOffset = mContentOffset
    }

    public func setContentOffset(
        y: LayoutMetric
    ) {
        if y.isNoMetric {
            return
        }

        var mContentOffset = contentOffset
        mContentOffset.y = y
        contentOffset = mContentOffset
    }
}

extension UIScrollView {
    public func scrollToTop(
        animated: Bool = true
    ) {
        setContentOffset(
            calculateContentOffsetForScrollOnTop(),
            animated: animated
        )
    }

    public func scrollToBottom(
        force: Bool = false,
        animated: Bool = true
    ) {
        let height = bounds.height
        let contentHeight = contentSize.height + adjustedContentInset.y

        if force ||
           height < contentHeight {
            setContentOffset(
                CGPoint(x: contentOffset.x, y: contentHeight - height),
                animated: animated
            )
        }
    }
}
