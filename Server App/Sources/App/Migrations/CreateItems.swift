import Fluent

struct CreateItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("items")
            .id()
            .field("name", .string, .required)
            .field("location", .string)
            .field("description", .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("items").delete()
    }
}
