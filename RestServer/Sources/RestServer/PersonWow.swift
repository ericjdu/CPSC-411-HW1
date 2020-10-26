//
//  PersonWow.swift
//  RestServer
//
//  Created by user923975 on 10/25/20.
//

import SQLite3
import Foundation

struct Claim : Codable {
    var id : String
    var title : String
    var date : String
    var isSolved = 0
    
    init(t : String, d : String, solv : Int?) {
        id = UUID().uuidString
        title = t
        date = d
        isSolved = 0
    }
}

class PersonWow {
   func addClaim(cObj : Claim) {
        let sqlStmt = String(format:"insert into claim (tite, date) values ('%@', '%@')", (cObj.title), (cObj.date))
        // get database connection
        let conn = Database.getInstance().getDbConnection()
        // submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Claim record due to error \(errcode)")
        }
        // close the connection
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select UUID, title, date, and isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW) {
                // Convert the record into a Person object
                // Unsafe_Pointer<CChar> Sqlite3
                let uid_val = sqlite3_column_text(resultSet, 0)
                let uid = String(cString: uid_val!)
                let title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                let isSolved_val = sqlite4_column_text(resultSet, 3)
                let isSolved = isSolved_val
                cList.append(Claim(uid:uid, t:title, d:date, isSolved:isSolved))
            }
        }
        return cList
    }
}
