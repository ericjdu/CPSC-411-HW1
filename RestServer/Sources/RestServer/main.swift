import Kitura
import Cocoa
import Foundation

let router = Router()

router.all("/PersonService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}
/*
router.post("/testPost"){
    request, response, next in
    print("Hitting the restPost service ...")
    let body = request.body
    if let jsonObj = body?.asJSON {
        if let jDict = jsonObj as? [String : String] {
            if let fn = jDict["FirstName"] {
                print("The input First Name : \(fn)")
                if let ln = jDict["LastName"] {
                    print("The input Last Name : \(ln)")
                }
            }
        }
        
    }
    response.send("Hello! Welcome to visit the /testPost service. ")
    next()
}
*/

router.get("PersonService/getAll"){
    request, response, next in
    let pList = PersonDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray 
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    // response.send("getAll service response data : \(pList.description)")
    next()
}

router.post("PersonService/add") {
    request, response, next in
    // JSON deserialization on Kitura server 
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let fn = jDict["firstName"],let ln = jDict["lastName"],let n = jDict["ssn"] {
            let pObj = Person(fn:fn, ln:ln, n:n)
            PersonDao().addPerson(pObj: pObj)
        }
    }
    response.send("The Person record was successfully inserted (via POST Method).")
    next()
}
router.get("/PersonService/add") {
    request, response, next in
    let fn = request.queryParameters["FirstName"]
    let ln = request.queryParameters["LastName"]
    //
    // let n = ....
    // if n != nil {
    // ... }
    if let n = request.queryParameters["SSN"] {
        let pObj = Person(fn:fn, ln:ln, n:n)
        PersonDao().addPerson(pObj: pObj)
        response.send("The Person record was successfully inserted.")
    } else {
        
    }
    next() 
}

router.post("/ClaimService/add") {
    request, response, next in
    // JSON deserialization on Kitura server
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let fn = jDict["title"],let ln = jDict["date"]{
            let cObj = Claim(title:title, date:date)
            PersonWow().addClaim(cObj: cObj)
        }
    }
    response.send("The Person record was successfully inserted (via POST Method).")
    next()}

router.get("/ClaimService/getAll") {
    request, response, next in
    let cList = PersonWow().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    // response.send("getAll service response data : \(pList.description)")
    next()}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

