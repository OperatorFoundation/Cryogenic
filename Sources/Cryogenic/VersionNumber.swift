//
//  VersionNumber.swift
//
//
//  Created by Dr. Brandon Wiley on 4/3/24.
//

import Foundation

import Text

public struct VersionNumber: Codable
{
    public let major: UInt
    public let minor: UInt
    public let patch: UInt
    public let tag: String?

    public var string: String
    {
        if let tag
        {
            return "\(self.major).\(self.minor).\(self.patch)\(tag)"
        }
        else
        {
            return "\(self.major).\(self.minor).\(self.patch)"
        }
    }

    public init(major: UInt, minor: UInt, patch: UInt, tag: String? = nil)
    {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.tag = tag
    }

    public init?(string: String)
    {
        self.init(text: string.text)
    }

    public init?(text: Text)
    {
        let parts = text.split(".")
        guard parts.count == 3 else
        {
            return nil
        }

        let major = UInt(string: parts[0].string)
        let minor = UInt(string: parts[1].string)

        let patch: UInt
        let tag: String?
        if parts[2].containsSubstring("-")
        {
            let subparts = parts[2].split("-")
            patch = UInt(string: subparts[0].string)
            tag = subparts[1].string
        }
        else
        {
            patch = UInt(string: parts[2].string)
            tag = nil
        }

        self.init(major: major, minor: minor, patch: patch, tag: tag)
    }
}

extension VersionNumber: Equatable
{
    public static func == (lhs: VersionNumber, rhs: VersionNumber) -> Bool
    {
        if lhs.major == rhs.major
        {
            if lhs.minor == rhs.minor
            {
                if lhs.patch == rhs.patch
                {
                    if let ltag = lhs.tag
                    {
                        // lhs has tag

                        if let rtag = rhs.tag
                        {
                            // lhs has tag, rhs has tag

                            return ltag == rtag
                        }
                        else
                        {
                            // lhs has tag, rhs has no tag

                            return false
                        }
                    }
                    else
                    {
                        // lhs has no tag

                        if rhs.tag != nil
                        {
                            // lhs has no tag, rhs has tag

                            return false
                        }
                        else
                        {
                            // lhs has no tag, rhs has no tag

                            return true
                        }
                    }
                }
            }
        }

        return false
    }
}

extension VersionNumber: Comparable
{
    public static func < (lhs: VersionNumber, rhs: VersionNumber) -> Bool
    {
        if lhs.major < rhs.major
        {
            return true // lhs < rhs
        }
        else if lhs.major > rhs.major
        {
            return false // lhs > rhs
        }

        // lhs.major == lhs.major

        if lhs.minor < rhs.minor
        {
            return true // lhs < rhs
        }
        else if lhs.minor > rhs.minor
        {
            return false // lhs > rhs
        }

        // lhs.minor == rhs.minor

        if lhs.patch < rhs.patch
        {
            return true // lhs < rhs
        }
        else if lhs.patch > rhs.patch
        {
            return false // lhs > rhs
        }

        // lhs.patch == rhs.patch

        if let ltag = lhs.tag
        {
            // lhs has tag

            if let rtag = rhs.tag
            {
                // lhs has tag, rhs has tag

                return ltag < rtag // lhs <=?=> rhs
            }
            else
            {
                // lhs has tag, rhs has no tag

                return true // lhs < rhs
            }
        }
        else
        {
            // lhs has no tag

            if rhs.tag == nil
            {
                // lhs has no tag, rhs has no tag

                return false // lhs == rhs
            }
            else
            {
                // lhs has no tag, rhs has tag

                return false // lhs > rhs
            }
        }
    }
}

public enum VersionNumberError: Error
{
    case badVersionNumber(String)
}
