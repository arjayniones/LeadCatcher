#To fetch data in database

RealmStore.model(YourModel.self).filter("username = 'user' and password = 'pass'")

#To add or insert an object in database

let username = YourModel() // created model that override the protocol Model.swift
user.id = "your id"
user.add()


#to update a model and database 

if let user = RealmStore.model(type: YourModel.self, query: "id = 'the_row_to_update'") {
	try! RealmStore.write {
                user.password = "new_password"
        }
}

#to delete data

if let data = RealmStore.model(type: YourModel.self, query: "id = 'id_to_delete'") {
            RealmStore.delete(model: data)
}
