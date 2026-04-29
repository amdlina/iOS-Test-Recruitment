import Foundation

protocol ClassifiedAdDraftStorageProtocol {
    func loadDraft() -> ClassifiedAdDraft?
    func saveDraft(_ draft: ClassifiedAdDraft)
    func deleteDraft()
}

final class ClassifiedAdDraftStorage: ClassifiedAdDraftStorageProtocol {
    private let userDefaults: UserDefaults
    private let storageKey = "classified_ad_draft"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadDraft() -> ClassifiedAdDraft? {
        guard let data = userDefaults.data(forKey: storageKey) else { return nil }
        return try? JSONDecoder().decode(ClassifiedAdDraft.self, from: data)
    }

    func saveDraft(_ draft: ClassifiedAdDraft) {
        guard let data = try? JSONEncoder().encode(draft) else { return }
        userDefaults.set(data, forKey: storageKey)
    }

    func deleteDraft() {
        userDefaults.removeObject(forKey: storageKey)
    }
}
