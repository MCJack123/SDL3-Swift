import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin
import SwiftDiagnostics

public enum SDLMacroError: Error {
    case declarationError
}

public struct EnumWrapper: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let baseType = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.as(MemberAccessExprSyntax.self)?.base else {
            throw SDLMacroError.declarationError
        }
        return [try ExtensionDeclSyntax("""
            internal extension \(type.trimmed) {
                static func sdl(_ value: \(baseType)) -> \(type.trimmed) {
                    return \(type.trimmed)(rawValue: UInt32(value.rawValue))!
                }
                var sdlValue: \(baseType) {
                    return \(baseType)(rawValue: \(baseType).RawValue(self.rawValue))
                }
            }
            """)]
    }
}

@main
struct SDL3Macros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [EnumWrapper.self]
}
