import Foundation

struct ClassifiedAdDraft: Codable, Equatable {
    var title: String = ""
    var description: String = ""
    var price: String = ""
    var categoryId: Int? = nil
    var contactName: String = ""
    var contactEmail: String = ""
    var updatedAt: Date = Date()

    var isEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        categoryId == nil &&
        contactName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        contactEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
