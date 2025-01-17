// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public typealias LayoutMetric = CGFloat

extension LayoutMetric {
    public var isNoMetric: Bool {
        return self == .noMetric
    }

    public static var noMetric: CGFloat {
        return -1000000
    }

    public func reduce() -> LayoutMetric {
        return isNoMetric ? 0 : self
    }
}

public typealias PrioritizedLayoutMetric =
    (
        metric: LayoutMetric,
        priority: UILayoutPriority
    )

public typealias LayoutSize =
    (
        w: LayoutMetric,
        h: LayoutMetric
    )

public typealias PrioritizedLayoutSize =
    (
        w: PrioritizedLayoutMetric,
        h: PrioritizedLayoutMetric
    )

public typealias LayoutPaddings =
    (
        top: LayoutMetric,
        leading: LayoutMetric,
        bottom: LayoutMetric,
        trailing: LayoutMetric
    )

public typealias PrioritizedLayoutPaddings =
    (
        top: PrioritizedLayoutMetric,
        leading: PrioritizedLayoutMetric,
        bottom: PrioritizedLayoutMetric,
        trailing: PrioritizedLayoutMetric
    )

public typealias LayoutHorizontalPaddings =
    (
        leading: LayoutMetric,
        trailing: LayoutMetric
    )

public typealias PrioritizedLayoutHorizontalPaddings =
    (
        leading: PrioritizedLayoutMetric,
        trailing: PrioritizedLayoutMetric
    )

public typealias LayoutVerticalPaddings =
    (
        top: LayoutMetric,
        bottom: LayoutMetric
    )

public typealias PrioritizedLayoutVerticalPaddings =
    (
        top: PrioritizedLayoutMetric,
        bottom: PrioritizedLayoutMetric
    )

public typealias LayoutMargins =
    (
        top: LayoutMetric,
        leading: LayoutMetric,
        bottom: LayoutMetric,
        trailing: LayoutMetric
    )

public typealias PrioritizedLayoutMargins =
    (
        top: PrioritizedLayoutMetric,
        leading: PrioritizedLayoutMetric,
        bottom: PrioritizedLayoutMetric,
        trailing: PrioritizedLayoutMetric
    )

public typealias LayoutHorizontalMargins =
    (
        leading: LayoutMetric,
        trailing: LayoutMetric
    )

public typealias PrioritizedLayoutHorizontalMargins =
    (
        leading: PrioritizedLayoutMetric,
        trailing: PrioritizedLayoutMetric
    )

public typealias LayoutVerticalMargins =
    (
        top: LayoutMetric,
        bottom: LayoutMetric
    )

public typealias PrioritizedLayoutVerticalMargins =
    (
        top: PrioritizedLayoutMetric,
        bottom: PrioritizedLayoutMetric
    )

public typealias LayoutOffset =
    (
        x: LayoutMetric,
        y: LayoutMetric
    )

public typealias PrioritizedLayoutOffset =
    (
        x: PrioritizedLayoutMetric,
        y: PrioritizedLayoutMetric
    )

extension UILayoutPriority {
    public static func none() -> UILayoutPriority {
        return .custom(Float(CGFloat.noMetric))
    }

    public static func custom(
        _ rawValue: Float
    ) -> UILayoutPriority {
        return UILayoutPriority(rawValue)
    }
}


/// <mark>
/// New metrics

public struct NSDirectionalHorizontalEdgeInsets {
    public var leading: CGFloat = .noMetric
    public var trailing: CGFloat = .noMetric
    
    public init() {}
    
    public init(
        leading: CGFloat,
        trailing: CGFloat
    ) {
        self.leading = leading
        self.trailing = trailing
    }
}

extension NSDirectionalHorizontalEdgeInsets {
    public func reduce() -> CGFloat {
        return leading.reduce() + trailing.reduce()
    }
}
