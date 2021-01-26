import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Item API in Swift!"
    }

    
    try app.register(collection: ItemsController())
}
