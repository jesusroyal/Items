import Fluent
import Vapor

struct ItemsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let item = routes.grouped("items")
        item.get(use: index)
        item.post(use: create)
        item.put(use: update)
        item.group(":itemID") { item in
            item.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Item]> {
        return Item.query(on: req.db).all()
    }
    
    func update(req:Request) throws -> EventLoopFuture<HTTPStatus> {
        let newItem = try req.content.decode(Item.self)
        
        return Item.find(newItem.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { item -> EventLoopFuture<Void> in
                item.name = newItem.name
                item.location = newItem.location
                item.description = newItem.description
                return item.update(on: req.db)
            }
            .transform(to: .ok)
        
    }

    func create(req: Request) throws -> EventLoopFuture<Item> {
        let item = try req.content.decode(Item.self)
        return item.save(on: req.db).map { item }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Item.find(req.parameters.get("itemID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
