import Foundation
import Combine

@MainActor
final class ClassifiedAdDraftViewModel: ObservableObject {
    @Published var draft: ClassifiedAdDraft

    private let storage: ClassifiedAdDraftStorageProtocol

    init(storage: ClassifiedAdDraftStorageProtocol? = nil) {
        let storage = storage ?? ClassifiedAdDraftStorage(userDefaults: .standard)
        self.storage = storage
        self.draft = storage.loadDraft() ?? ClassifiedAdDraft()
    }

    func saveCurrentDraft() {
        save(draft)
    }

    func save(_ draft: ClassifiedAdDraft) {
        var updatedDraft = draft
        updatedDraft.updatedAt = Date()
        self.draft = updatedDraft
        storage.saveDraft(updatedDraft)
    }

    func resetDraft() {
        let emptyDraft = ClassifiedAdDraft()
        draft = emptyDraft
        storage.saveDraft(emptyDraft)
    }

    func discardDraft() {
        draft = ClassifiedAdDraft()
        storage.deleteDraft()
    }
}
