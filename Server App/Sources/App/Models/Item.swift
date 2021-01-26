import Fluent
import Vapor

final class Item: Model, Content {
    static let schema = "items"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    

    init() { }

    init(id: UUID? = nil, name: String, location: String, description: String) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
    }
}
