```
   _____         _  __ _   _____                       _____ _                             
  / ____|       (_)/ _| | |  __ \                     / ____| |                            
 | (_____      ___| |_| |_| |__) |____      _____ _ _| (___ | |_ ___  _ __ __ _  __ _  ___ 
  \___ \ \ /\ / / |  _| __|  ___/ _ \ \ /\ / / _ \ '__\___ \| __/ _ \| '__/ _` |/ _` |/ _ \
  ____) \ V  V /| | | | |_| |  | (_) \ V  V /  __/ |  ____) | || (_) | | | (_| | (_| |  __/
 |_____/ \_/\_/ |_|_|  \__|_|   \___/ \_/\_/ \___|_| |_____/ \__\___/|_|  \__,_|\__, |\___|
                                                                                 __/ |     
                                                                                |___/      
```
> CoreData + Codable power for create a simply but powerful storage package.

## Installation
Add the package to Xcode usign following url

https://github.com/CodeNationDev/SwiftPowerStorage.git


## Definition & Interface

#### Main class 
```swift
public class SPSManager: NSObject
```
#### Functions

**Save**
```swift
public func saveParameter<T: Codable>(forKey: String, object: T, completionHandler: ((Bool, T?)->(Void))? = nil)
```
**Load**
```swift
public func loadParameter<T:Codable>(forKey: String, type: T.Type) -> T?
```
**Remove**
```swift
public func removeParameter(forKey: String) -> String?
```

## Usage example
### Create manager
```swift
//
import UIKit
import SwiftPowerStorage

class ViewController: UIViewController {

    let cdManager = SPSManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
```
### Save an object

For save an object, your object must conforms **Codable** protocol. Remember that all primitive types conforms Codable protocol in Swift :D .

```swift
//
import UIKit
import os.log

public struct TestOne: Codable {
    var name: String?
    var age: Int?
    var last: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let member = TestOne(name: "David", age: 39, last: "Martin Saiz")
        cdManager.saveParameter(forKey: "Member1", object: member) { (result, last) -> (Void) in
            if result {
                // do something when save is successful
            }
            if let last = last {
                // If the entity already exists and had been overwritten, here returns the last value.
            }
        }

    }
}
```
Use completionHandler for ensure that all activities related with save task   are executed  when the value is trully saved. All works about CoreDate are launched in an async DispatchQueue.

### Load object

Load an object is very easy, only call the function and provide the correct type for cast the object.

```swift
 if let value = cdManager.loadParameter(forKey: "Member1", type: TestOne.self) {
            print(value)
        } else {
            print("Object not found")
        }
```

### Remove object

You can remove an existing object calling the following function:
```swift
 if let removed = cdManager.removeParameter(forKey: "Member1") {
            print(removed)
        } else {
            print("Object not found")
        }
```
This function returns the value of the deleted object if the deletion was successful.

### Remove database

If you need reset database to init state, call following function
```swift
if cdManager.destroyPersistenStore() {
            // do something when deletion successful
        }
```
Function returns boolean as deletion result.

## iCloud Sync

The persistent container used by this product extends of NSPersistentCloudKitContainer, then, you can create an iCloud container, add iCloud capability and the database will shared with all your Apple products that using this feature.
```swift
public lazy var persistentContainer: NSPersistentCloudKitContainer
```

## Meta

David Martin Saiz – [@deividmarshall](https://twitter.com/deividmarshall) – davms81@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/CodeNationDev/](https://github.com/CodeNationDev)

## Version History
* 1.0.1
  * Bugfixes in removeParameter returned value.
  * Add unit tests.
* 1.0.0
  *  Refactor to SPSManager and bugfixes.
* 0.0.1
  * First implementation with main features.
