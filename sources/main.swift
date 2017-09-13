import CoreLocation
import Foundation

var arguments = CommandLine.arguments.dropFirst()
guard let flag = arguments.popFirst() else {
    exitWithUsage()
}

let commands = [
    "-c": coordinate,
    "-q": findLocation,
    "-p": path,
]

guard let command = commands[flag] else {
    exitWithUsage()
}

switch command(Array(arguments)) {
    case .coordinate(let coordinate) where coordinate.isValid:
        do {
            postNotification(for: coordinate, to: try getBootedSimulators())
            print("Setting location to \(coordinate.latitude) \(coordinate.longitude)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.rawValue)
        }
    case .coordinate(let coordinate):
        exitWithUsage(error: "Coordinate: \(coordinate) is invalid")
    case .fileURL(let fileURL):
        do {
            postNotification(for: fileURL, to: try getBootedSimulators())
            print("Setting location based on \(fileURL.path)")
        } catch let error as SimulatorFetchError {
            exitWithUsage(error: error.rawValue)
        }
    case .failure(let error):
        exitWithUsage(error: error)
}
