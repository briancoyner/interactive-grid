import Foundation

protocol DragStateChangeTestRunProvider {

    func makeTestRuns() async throws -> [TestDescription]
}
