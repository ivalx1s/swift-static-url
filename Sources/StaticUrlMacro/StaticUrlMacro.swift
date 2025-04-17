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

        guard URL(string: segment.content.text) != nil else {
            throw StaticUrlMacroError.invalidURL
        }
        return "Foundation.URL(string: \(argument))!"
    }
}

enum StaticUrlMacroError: String, Error, CustomStringConvertible {
    case notAStringLiteral = "Argument is not a string literal"
    case invalidURL = "Argument is not a valid URL"

    public var description: String { rawValue }
}

@main struct StaticUrlPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [StaticUrlMacro.self]
}
