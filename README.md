GitHubDM: GitHub Direct Messaging
========

![platform](https://img.shields.io/badge/platform-iOS-0b96b5.svg)  ![Language](https://img.shields.io/badge/language-Swift%205-orange.svg)  ![Design](https://img.shields.io/badge/design-MVVM%20C-purple.svg)

**GitHubDM** is a direct messaging application that focuses solely on chatting experience with the followers of any individual. While there is nothing much about the presentation of the application's feature right now, it's good to have some implementation idea behind the application. 

## Design Pattern
**MVVM-C**: Model-View-View Model-Coordinator

### Why MVVM-C?
**MVVM** is widely used in the iOS application development. It takes presentation and buisness logic of showing data to **View** out of **ViewController** making it clean and small. 

In conjuction with **Coordinator** (the `C` in the `MVVM-C`), this pattern allows us to distribute heavy lifting of works that a **ViewController** in **MVC** usually does. **Coordinator** is the object that handles the navigation logic / screen flow of an application. The **Coordinator** encapsulates a part of the application. It knows nothing of its parent Coordinator, but it can start its **Child Coordinators**.

### Benefits of MVVM-C
* Avoids Massive-ViewControllers
* Keeps UI as dumb as possible
* Define single responsibility to each module

(note: though MVVM-C works best with [Reactive Frameworks](https://github.com/ReactiveX), this application is prohibited from using any 3rd party frameworks.)

## Implementation of MVVM-C in GitHubDM: 

### Models:
* At this point there are only 2 model types for representing domain specific data: `User` & `Message`. 
* These are backed by another 2 database entity type models: `UserData` & `MessageData`. They are used only for the conversion between **Model - Entity** in both ways. This is to ensure thread safety and to minimize the risk of potential race conditions as the entity type models, in standard iOS SDK, are _**reference**_ types.

### Views: 
* The views (`FollowerListViewController`, `FollowerTableViewCell`, `MessagingViewController`, `OutgoingMessageTableViewCell`, `IncomingMessageTableViewCell`) are solely responsible with visually presenting data (ready data to be shown) to the UI. They just request their designated view model objects for data. 

>There is an exception though: The way the table views are in iOS and cells are generated, there is potentially no other option instead of creating view models for those cells from inside the view controllers. This could be a point of improvement to be made. 

* Views dispatch user initiated events to interested objects. Like, when transition to another screen is needed, view delegates the work to the associated `Coordinator`. Again, if anything related to processing of data is concerned, view tells its `ViewModel` to process the data and take appropriate action. 
* Basically they are just dumb objects that don't know anything about data processing. The thing they only know is _how to display data_. Anything other than displaying, they just let the other objects know of that action. 

### ViewModels:
* Currently there are 5 view models in total: `FollowerListViewModel`, `MessagingViewModel`, `FollowerTableViewCellViewModel`, `OutgoingMessageTableViewCellViewModel`, `IncomingMessageTableViewCellViewModel`
* `FollowerListViewModel`: Fetches followers with the help of the network client object & stores them in a storage space with the help of a data storage object. It prepares and provides view-ready data to its view from the storage. Any change in the data is notified to the view so that view can act accordingly. If there is any error that needs to be shown to the user, it notifies the view counterpart. 
* `MessagingViewModel`: Fetches messages from local storage space with the help of data storage object. It prepares and provides view-ready data to its view upon request from the view. For outgoing messages, it takes send message event from the view and relays the message with the help of the network client. In case of any incoming message, it notifies the view. Sending/Receiving message imitates a dummy post and response operation.
* `FollowerTableViewCellViewModel`: Prepares view-ready data from model type and provide it to its view. 
* `OutgoingMessageTableViewCellViewModel`: Prepares view-ready data from model type and provide it to its view. 
* `IncomingMessageTableViewCellViewModel`: Prepares view-ready data from model type and provide it to its view. 
* Any change in the viewable data doesn't go directly to model layer. Instead view models, by being triggered by the views, take the responsibility to update the model layer. And after the change is done they notify the corresponding views that there had been some changes in the data (that was previously being showed) and they should update themselves to reflect the changes.

### Coordinators:
* A starting Coordinator (`AppCoordinator`) triggers the start of the flow. 
* 2 screens = 2 Coordinators (`FollowerListCoordinator` & `MessagingCoordinator`)
* Each coordinator is responsible to create it's associated screen by injecting dependencies (i.e. service/network client object, view model)
* They also react as the delegate of their screen when any transitioning is needed. At the time of the transition, coordinator just starts its child coordinator.

### Networking: 
* Networking or webservice related logics are distributed in two categories: **Networking** & **Client**. 
* _Networking_: This category is generic. This section isn't tightly coupled with any other section. Basically the members here are: `GenericAPIClient`, `EndPoint` & `APIError`. Together they can handle REST API method (GET, only at this time) request and response. 
* _Client_: The concrete type of the networking layer which only knows domain specific informations. The `GitHubClient` acts as the object which can talk with the https://api.github.com domain. The `GitHubAPIError` encapsulates the domain specific error types with option available for general HTTP error. 

### Persistence:
* Core Data is used for local storage to persist data. 
* `CoreDataManager` is a shared object that abstracts out the implementation details of creating database, initializing entity objects, saving the current state and fetching records from database. 
* `CoreDataError` type defines application specific core data errors. 
* `UserStorage` shared object deals with synchronization of users fetched from the webservice with local storage. 
* `MessageStorage` shared object is concerned with storing/fetching messages into/from local storage. 

### Protocols+Extensions: 
* To enforce having various required capabilities, some **Protocols** are defined. Some of them have default implementations through **Protocol Extensions**. 
* For increasing reusablity of common behaviors of some object types accross the whole project, some **Extensions** are declared. 

## Hypothetical improvement sections

* In this implemenation of the project, the **View Model** object is associated with more than one responsibility if not a lot. But it doesn't fully address the issue, we have with classic **MVC** pattern, of ___too many responsibilities of view controller___ or the joke ___massive view controller___. If you just search in the google with [massive view controller ios](https://www.google.com/search?client=safari&sxsrf=ACYBGNQMW3TryTl-bLXOOvTzwYTu-uy9GQ:1568799522292&source=hp&ei=IvuBXbnXD5Lt9QP4qYq4Cw&q=massive+view+controller+ios&oq=&gs_l=psy-ab.1.0.35i362i39l10.0.0..3315...0.0..0.97.97.1......0......gws-wiz.....10.KqSdFeNOkQY) you'll find a tons of results that all are not expected to read. But it was a huge point of consideration when patterns like **MVVM** or **VIPER** emerged to be good choices. 
* If the above point is valid (surely it is though), we are not too far from ___fat view model___. When the scope of the application will increase we are likely to end up with view models that are too fat. In order to address this issue there are some propositions from different advocates of software engineering that propose to: 

> "not associate view models with any kind of state"

that being said, it means that view models should not deal with any networking operation. Even if we stuffed out the networking codes to different object (`client` in this case) it doesn't mean that view model is not being associated with networking. Actually view model initiates the process of calling service and behaves as soon as there is any output from the network side. To opt out of this dilemma, we need to design **View Models** as _value types_ instead of _refernce types_. This will allow view models not to behave differently for different states. The ***processing & presentation logic*** should be the only concern of the view model. They will have some inputs and outputs that should be the source of truth. This effectively means that same inputs should always produce same outputs no matter what. This construct is relative to **Pure function**. 
* Being said enough, a theoritical thought is 

>"We should take the network related layer out of the view model. This will allow us to define view models as value types. Then we have a `Data Provider` object and a `Model Controller` object that both in conjuction will concentrate with the retrieval of models from the network and provide them to the view model."

but how the workflow has to be done is yet to be found out.
