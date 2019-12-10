// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class AppTarget<SomeAnalytics: AnalyticsConvertible, SomeDevTools: DevToolsConvertible>: AppTargetConvertible {
    public let isProduction: Bool
    public let serverConfig: ServerConfig
    public let deeplinkConfig: DeeplinkConfig
    public let analytics: SomeAnalytics
    public let devTools: SomeDevTools

    public init() {
        isProduction = true
        serverConfig = nil
        deeplinkConfig = nil
        analytics = nil
        devTools = nil
    }

    /// <mark> Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isProduction = try container.decodeIfPresent(Bool.self, forKey: .isProduction) ?? true
        serverConfig = try container.decodeIfPresent(SomeServerConfig.self, forKey: .serverConfig) ?? nil
        deeplinkConfig = try container.decodeIfPresent(SomeDeeplinkConfig.self, forKey: .deeplinkConfig) ?? nil
        analytics = try container.decodeIfPresent(SomeAnalytics.self, forKey: .analytics) ?? nil
        devTools = try container.decodeIfPresent(SomeDevTools.self, forKey: .devTools) ?? nil
    }
}

extension AppTarget {
    public enum CodingKeys: String, CodingKey {
        case isProduction = "is_production"
        case serverConfig = "server_config"
        case deeplinkConfig = "deeplink_config"
        case analytics = "analytics"
        case devTools = "dev_tools"
    }
}

public protocol AppTargetConvertible: AnyObject, Decodable {
    associatedtype SomeServerConfig: ServerConfigConvertible
    associatedtype SomeDeeplinkConfig: DeeplinkConfigConvertible
    associatedtype SomeAnalytics: AnalyticsConvertible
    associatedtype SomeDevTools: DevToolsConvertible

    var isProduction: Bool { get }
    var serverConfig: SomeServerConfig { get }
    var deeplinkConfig: SomeDeeplinkConfig { get }
    var analytics: SomeAnalytics { get }
    var devTools: SomeDevTools { get }
}

extension AppTargetConvertible {
    var deviceOS: DeviceOS {
        #if os(iOS)
        return .iOS
        #elseif os(watchOS)
        return .watchOS
        #else
        mc_crash(.unsupportedDeviceOS)
        #endif
    }

    var deviceFamily: DeviceFamily {
        #if os(iOS)
        switch UIScreen.main.traitCollection.userInterfaceIdiom {
        case .unspecified:
            return .iPhone
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            mc_crash(.unsupportedDeviceFamily)
        }
        #elseif os(watchOS)
        return .watch
        #else
        mc_crash(.unsupportedDeviceFamily)
        #endif
    }
}

extension AppTargetConvertible {
    /// <note>
    /// - Config file must be in JSON format.
    /// - Config file must be saved in the 'main' bundle.
    /// - It is highly recommended for each target to have its own config file.
    /// - It is highly recommended to use the default values (target_config.json) for config file and extension.
    public static func load(fromResource name: String = "target", withExtension ext: String = "json") -> Self {
        guard let resourceUrl = Bundle.main.url(forResource: name, withExtension: ext) else {
            mc_crash(.targetNotFound)
        }
        do {
            let data = try Data(contentsOf: resourceUrl, options: Data.ReadingOptions.uncached)
            return try Self.decoded(data)
        } catch let err {
            mc_crash(.targetCorrupted(reason: err))
        }
    }
}

public enum DeviceOS {
    case iOS
    case watchOS
}

public enum DeviceFamily {
    case iPhone
    case iPad
    case watch
}
