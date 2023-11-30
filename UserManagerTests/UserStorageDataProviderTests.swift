import XCTest
@testable import UserManager

final class UserStorageDataProviderTests: XCTestCase {
    
    var provider: UserStorageDataProviderMock!
    
    override func setUpWithError() throws {
        provider = UserStorageDataProviderMock()
    }
    
    override func tearDownWithError() throws {
        provider = nil
    }
    
    func testSave() throws {
        let name = randomString(length: 10)
        let email = name.getRandomEmail(currentStringAsUsername: true)
        let userData = UserData(name: name, email: email)
        
        try provider.save(withData: userData)
        let localUsers = try provider.fetchAll()
        
        let isSaved = localUsers.contains {
            $0.name == name && $0.email == email
        }
        XCTAssertTrue(isSaved)
    }
    
    func testDelete() throws {
        let name = randomString(length: 10)
        let email = name.getRandomEmail(currentStringAsUsername: true)
        let userData = UserData(name: name, email: email)
        
        try provider.save(withData: userData)
        try provider.delete(withEmail: email)
        let localUsers = try provider.fetchAll()
        
        let isDeleted = !localUsers.contains {
            $0.name == name && $0.email == email
        }
        XCTAssertTrue(isDeleted)
    }
    
    func testSaveAlreadyExisting() throws {
        let name = randomString(length: 10)
        let email = name.getRandomEmail(currentStringAsUsername: true)
        let userData = UserData(name: name, email: email)
        
        try provider.save(withData: userData)
        if try !provider.checkIfAlreadyExists(withEmail: email) {
            try provider.save(withData: userData)
        }
        let localUsers = try provider.fetchAll()
        
        let moreThanOne = localUsers.filter {
            $0.name == name && $0.email == email
        }.count > 1
        
        XCTAssertFalse(moreThanOne)
    }
    
    func testFetchAll() throws {
        let (name1, name2, name3, name4, name5) = (
            randomString(length: 6),
            randomString(length: 7),
            randomString(length: 8),
            randomString(length: 9),
            randomString(length: 10)
        )
        let (email1, email2, email3, email4, email5) = (
            name1.getRandomEmail(currentStringAsUsername: true),
            name2.getRandomEmail(currentStringAsUsername: true),
            name3.getRandomEmail(currentStringAsUsername: true),
            name4.getRandomEmail(currentStringAsUsername: true),
            name5.getRandomEmail(currentStringAsUsername: true)
        )
        let (user1, user2, user3, user4, user5) = (
            UserData(name: name1, email: email1),
            UserData(name: name2, email: email2),
            UserData(name: name3, email: email3),
            UserData(name: name4, email: email4),
            UserData(name: name5, email: email5)
        )
        
        var actualFetch: [User] = []
        var expectedFetch: [UserData] = []
        
        // Test fetch from empty store
        actualFetch = try provider.fetchAll()
        try compareActualAndExpectedFetch(actual: actualFetch, expected: expectedFetch)
        
        // Test fetch after adding user1 and user2
        try applyChanges(
            usersToSave: [user1, user2],
            usersToDeleteByEmails: []
        )
        expectedFetch = [user1, user2]
        actualFetch = try provider.fetchAll()
        try compareActualAndExpectedFetch(actual: actualFetch, expected: expectedFetch)
        
        // Test fetch after adding user3 and user4 and deleting user2
        try applyChanges(
            usersToSave: [user3, user4],
            usersToDeleteByEmails: [email2]
        )
        expectedFetch = [user1, user3, user4]
        actualFetch = try provider.fetchAll()
        try compareActualAndExpectedFetch(actual: actualFetch, expected: expectedFetch)
        
        // Test fetch after adding user5 and deleting user1
        try applyChanges(
            usersToSave: [user5],
            usersToDeleteByEmails: [email1]
        )
        expectedFetch = [user3, user4, user5]
        actualFetch = try provider.fetchAll()
        try compareActualAndExpectedFetch(actual: actualFetch, expected: expectedFetch)
        
        // Test fetch after deleting all users
        try applyChanges(
            usersToSave: [],
            usersToDeleteByEmails: [email3, email4, email5]
        )
        expectedFetch = []
        actualFetch = try provider.fetchAll()
        try compareActualAndExpectedFetch(actual: actualFetch, expected: expectedFetch)
    }
}

private extension UserStorageDataProviderTests {
    func applyChanges(usersToSave toSave: [UserData], usersToDeleteByEmails toDeleteBy: [String]) throws {
        for user in toSave {
            try provider.save(withData: user)
        }
        for email in toDeleteBy {
            try provider.delete(withEmail: email)
        }
    }
    
    func compareActualAndExpectedFetch(actual: [User], expected: [UserData]) throws {
        XCTAssertEqual(actual.count, expected.count)
        
        var actualMatchesExpexted: Bool = true
        for userObject in actual {
            let data = UserData(userObject: userObject)
            guard expected.contains(data) else {
                actualMatchesExpexted = false
                break
            }
        }
        XCTAssertTrue(actualMatchesExpexted)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

fileprivate extension String {
    func getRandomEmail(currentStringAsUsername: Bool = false) -> String {
        let providers = ["gmail.com", "protonmail.com", "icloud.com", "live.com"]
        let randomProvider = providers.randomElement()!
        if currentStringAsUsername && self.count > 0 {
            return "\(self)@\(randomProvider)"
        }
        let username = UUID.init().uuidString.replacingOccurrences(of: "-", with: "")
        return "\(username)@\(randomProvider)"
    }
}
