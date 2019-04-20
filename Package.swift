// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
	name: "MongoDBStORM",
	dependencies: [
		.Package(url: "https://github.com/SwiftORM/StORM.git", from: "3.0.0"),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", from: "3.0.0"),
		.Package(url: "https://github.com/iamjono/SwiftRandom.git", from: "1.0.0"),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-MongoDB.git", from: "3.0.0"),
	],
	targets: []
)
