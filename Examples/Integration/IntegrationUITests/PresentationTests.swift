import Integration
import XCTest
import TestCases

@MainActor
final class PresentationTests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    self.continueAfterFailure = false

    self.app = XCUIApplication()
    self.app.launch()
    self.app.collectionViews.buttons[TestCase.presentation.rawValue].tap()
  }

  func testChildDismiss() {
    self.app.buttons["Open child"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 0"].exists)

    self.app.buttons["Increment"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 1"].exists)
    self.app.buttons["Increment"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 2"].exists)

    self.app.buttons["Child dismiss"].tap()
    XCTAssertEqual(false, self.app.staticTexts["Count: 2"].exists)
  }

  func testParentDismiss() {
    self.app.buttons["Open child"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 0"].exists)

    self.app.buttons["Parent dismiss"].tap()
    XCTAssertEqual(false, self.app.staticTexts["Count: 0"].exists)
  }

  func testEffectsCancelOnDismiss() async throws {
    self.app.buttons["Open child"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 0"].exists)

    self.app.buttons["Start effect"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 1"].exists)

    self.app.buttons["Parent dismiss"].tap()
    XCTAssertEqual(false, self.app.staticTexts["Count: 1"].exists)

    self.app.buttons["Open child"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 0"].exists)
    try await Task.sleep(for: .seconds(3))
    XCTAssertEqual(false, self.app.staticTexts["Count: 999"].exists)
  }

  func testIdentityChange() async throws {
    self.app.buttons["Open child"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 0"].exists)

    self.app.buttons["Start effect"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 1"].exists)

    self.app.buttons["Reset identity"].tap()
    XCTAssertEqual(true, self.app.staticTexts["Count: 1"].exists)

    try await Task.sleep(for: .seconds(3))
    XCTAssertEqual(false, self.app.staticTexts["Count: 999"].exists)
  }
}
