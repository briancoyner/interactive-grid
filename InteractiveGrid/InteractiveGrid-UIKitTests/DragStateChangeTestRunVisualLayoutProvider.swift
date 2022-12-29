import RegexBuilder
import XCTest

@testable import InteractiveGrid_UIKit

/// This was an experiment to play around with Swift's RegexBuilder. The goal was to have a single text file that provides a compact visual representation of
/// N number of tests. Each test has a "name", the initial model layout state, and the expected proposed layout model (along with various "lift" and "drop" designations.
///
/// In the end, the experiment worked ok, but this will be deleted in favor of the test case utilizing the `TestModel` data structure, which also helps provide
/// a compact visual representation.
final class DragStateChangeTestRunVisualLayoutProvider: DragStateChangeTestRunProvider {

    func makeTestRuns() throws -> [TestDescription] {
        var testRuns: [TestDescription] = []
        var state: ParserState = .initial

        for line in try lines().enumerated() {
            let string = line.element
            let lineNumber = line.offset + 1

            switch state {
            case .initial:
                state = nextState(forLine: string, lineNumber: lineNumber)
            case .buildingModel(let transientInput):
                state = try nextState(forLine: string, lineNumber: lineNumber, transientInput: transientInput)
            case .buildingExpectation(let input, let proposed):
                state = try nextState(forLine: string, lineNumber: lineNumber, input: input, transientProposedChange: proposed)
            case .captured(let testDescription):
                testRuns.append(testDescription)
                state = .initial
            }
        }

        if case .captured(let testDescription) = state {
            testRuns.append(testDescription)
        }

        return testRuns
    }
}

extension DragStateChangeTestRunVisualLayoutProvider {

    private func lines() throws -> [String] {
        let bundle = Bundle(for: DragStateChangeTestRunVisualLayoutProvider.self)
        let inputURL = try XCTUnwrap(bundle.url(forResource: "visualLayout", withExtension: "txt"))

        let data = try Data(contentsOf: inputURL)

        return try XCTUnwrap(String(data: data, encoding: .utf8))
            .replacing("\n", with: "\n\t") // Force preservation of blank lines when "splitting".
            .split(separator: /\n/)
            .map { String($0) + " " }
    }
}

extension DragStateChangeTestRunVisualLayoutProvider {

    private func nextState(forLine string: String, lineNumber: Int) -> ParserState {
        if let match = string.wholeMatch(of: Self.testNameCapture) {
            return .buildingModel(.init(name: String(match.output.1), startLine: lineNumber, models: []))
        } else {
            return .initial
        }
    }

    private func nextState(
        forLine string: String,
        lineNumber: Int,
        transientInput: ParserState.TransientInput
    ) throws -> ParserState {

        var updatedInput = transientInput
        let modelMatches = string.matches(of: Self.modelRegex)
        if modelMatches.isEmpty == false {
            for match in modelMatches {
                updatedInput.models.append(Model(value: match.output.2, style: match.output.1))

                let modelInteraction = match.output.3
                if modelInteraction == .lift {
                    guard transientInput.liftIndex == nil else {
                        throw ParserError.liftIndexAlreadyDeclared
                    }

                    updatedInput.liftIndex = updatedInput.models.count - 1
                } else if modelInteraction == .drop {
                    guard transientInput.dropIndex == nil else {
                        throw ParserError.dropIndexAlreadyDeclared
                    }

                    updatedInput.dropIndex = updatedInput.models.count - 1
                }
            }
            return .buildingModel(updatedInput)
        } else if string.contains(Self.testInputDelimiter) {
            guard let liftIndex = transientInput.liftIndex, let dropIndex = transientInput.dropIndex else {
                throw ParserError.dropIndexAlreadyDeclared
            }

            return .buildingExpectation(
                ParserState.Input(
                    name: updatedInput.name,
                    startLine: updatedInput.startLine,
                    models: updatedInput.models,
                    liftIndex: liftIndex,
                    dropIndex: dropIndex
                ), ParserState.TransientProposedChange(
                    proposedDropIndex: nil,
                    proposedDragModels: []
                )
            )
        } else {
            return .buildingModel(updatedInput)
        }
    }

    private func nextState(
        forLine string: String,
        lineNumber: Int,
        input: ParserState.Input,
        transientProposedChange: ParserState.TransientProposedChange
    ) throws -> ParserState {

        var foo = transientProposedChange

        let matches = string.matches(of: Self.modelRegex)
        if matches.isEmpty == false {
            for match in string.matches(of: Self.modelRegex) {
                foo.proposedDragModels.append(Model(value: match.output.2, style: match.output.1))
                let modelInteraction = match.output.3
                if modelInteraction == .drop {
                    guard foo.proposedDropIndex == nil else {
                        throw ParserError.dropIndexAlreadyDeclared
                    }

                    foo.proposedDropIndex = foo.proposedDragModels.count - 1
                }
            }

            return .buildingExpectation(input, foo)
        } else if string.contains(Self.testEndDelimiter) {
            return .captured(TestDescription(
                name: input.name,
                inputFileLines: input.startLine...lineNumber,
                models: input.models,
                liftIndex: input.liftIndex,
                dropIndex: input.dropIndex,
                proposedDropIndex: foo.proposedDropIndex ?? input.dropIndex,
                proposedLayoutModels: foo.proposedDragModels
            ))
        } else {
            throw ParserError.dropIndexAlreadyDeclared
        }
    }
}

extension DragStateChangeTestRunVisualLayoutProvider {

    private enum ParserState {
        case initial
        case buildingModel(TransientInput)
        case buildingExpectation(Input, TransientProposedChange)
        case captured(TestDescription)

        struct TransientInput {
            let name: String
            let startLine: Int
            var models: [Model]
            var liftIndex: Int?
            var dropIndex: Int?
        }

        struct Input {
            let name: String
            let startLine: Int
            var models: [Model]
            var liftIndex: Int
            var dropIndex: Int
        }

        struct TransientProposedChange {
            var proposedDropIndex: Int?
            var proposedDragModels: [Model]
        }
    }

    private enum ParserError: Error {
        case liftIndexAlreadyDeclared
        case dropIndexAlreadyDeclared
    }

    private enum Interaction: String {
        case lift = "^"
        case drop = "-"
    }
}

extension DragStateChangeTestRunVisualLayoutProvider {

    /// A collection of `RegexBuilder` data structures used to parse and capture the visual grid layout expectations.

    private static let styleCapture = TryCapture {
        ChoiceOf {
            "C"
            "R"
        }
    } transform: {
        Model.Style($0)
    }

    private static let testNameCapture = Regex {
        ZeroOrMore(.whitespace)
        "###"
        Capture {
            OneOrMore(.any)
        }
    }

    private static let testInputDelimiter = Regex {
        OneOrMore("=")
    }

    private static let testEndDelimiter = Regex {
        OneOrMore("-")
    }

    private static let interactionCapture = TryCapture {
        ChoiceOf {
            "^"
            "-"
        }
    } transform: {
        Interaction(rawValue: String($0))
    }

    private static let valueCapture = TryCapture {
        OneOrMore(.digit)
    } transform: {
        Int($0)
    }

    private static let modelRegex = Regex {
        Optionally(OneOrMore(.whitespace))
        "|"
        Optionally(OneOrMore(.whitespace))
        styleCapture
        valueCapture
        Optionally(interactionCapture)
        Optionally(OneOrMore(.whitespace))
    }

    private static let endOfRegex = Regex {
        Optionally(OneOrMore(.whitespace))
        "|"
        Optionally(OneOrMore(.whitespace))
        styleCapture
        valueCapture
        Optionally(interactionCapture)
        Optionally(OneOrMore(.whitespace))
    }
}

extension Model.Style {

    fileprivate init?(_ stringValue: some StringProtocol) {
        switch stringValue {
        case "C":
            self = .compact
        case "R":
            self = .regular
        default:
            return nil
        }
    }
}
