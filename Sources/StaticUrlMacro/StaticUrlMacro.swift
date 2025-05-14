import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct StaticUrlMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression,
              let literal = argument.as(StringLiteralExprSyntax.self),
              case .stringSegment(let segment) = literal.segments.first
        else {
            throw StaticUrlMacroError.notAStringLiteral
        }

        try checkURL(segment.content.text)
        try checkScheme(segment.content.text)
        try checkSpaces(segment.content.text)
        try checkCyrillic(segment.content.text)
    
        return "Foundation.URL(string: \(segment.content.text))!"
    }
    
    private static func checkURL(_ urlString: String) throws {
        guard URL(string: urlString) != nil else {
            throw StaticUrlMacroError.invalidURL
        }
    }
    
    private static func checkScheme(_ urlString: String) throws {
        guard let components = URLComponents(string: urlString),
              let scheme = components.scheme,
              !scheme.isEmpty else {
            throw StaticUrlMacroError.schemeMissing
        }
        
        let allowedSchemes: Set<String> = ["http", "https", "ws"]
        guard allowedSchemes.contains(scheme) else {
            throw StaticUrlMacroError.unsupportedScheme
        }
    }
    
    private static func checkSpaces(_ urlString: String) throws {
        guard !urlString.contains(" ") else {
            throw StaticUrlMacroError.spacesInURL
        }
    }
    
    private static func checkCyrillic(_ urlString: String) throws {
        let cyrillicCharset = CharacterSet(charactersIn: "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя")
        
        guard urlString.rangeOfCharacter(from: cyrillicCharset) == nil else {
            throw StaticUrlMacroError.cyrillicInURL
        }
    }
}

enum StaticUrlMacroError: String, Error, CustomStringConvertible {
    case notAStringLiteral = "Argument is not a string literal"
    case invalidURL = "Argument is not a valid URL"
    case schemeMissing = "URL scheme is missing"
    case unsupportedScheme = "Unsupported URL scheme"
    case spacesInURL = "URL contains spaces"
    case cyrillicInURL = "URL contains cyrillic characters"
    
    public var description: String { rawValue }
}

@main struct StaticUrlPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [StaticUrlMacro.self]
}
