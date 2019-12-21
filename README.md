# casting_manager

Casting app for the directors where they can see list of available actor/actresses for casting and add to their roster.

## Project Structure

- UI
  - add_new_actor_screen.dart
  - available_actors.dart
  - home_screen.dart
  - reusable_components
    - submit_button.dart
    - transparent_button.dart
  - roster_screen.dart
  - signup_page.dart
- core
  - helper.dart
- data
  - actor.dart
- main.dart
- services
  - database_service.dart
  - database_service_DONT_USE.dart
- shared_state
  - user.dart

### Services

For connecting to the outside world and storing data, our app uses Firestore.  
For that purpose we have a class DatabaseService which does the job of getting stream of data and also updating it.  
Now I have found two ways to model the data (one better than another).
Let's first look the queries we need
Queries

1. getAvailableActors -> Same for both ways
2. getRoster
3. addToRoster(actor)
4. removeFromRoster(actor)

#### The slow one

1. User -> username, List[ActorID] .
2. Actor -> name, cost, description, isAvialable .
   See database_service_DONT_USE.dart .
   Although this model looks more organized way but turns out it is not fast. Reason being, first we fetch user's subcollection which contains id's of actor. Then for each id fetch that actor in Actor collection which leads to many get requests.

#### The better option

1. User -> username .
2. Actor -> name, cost, description, isAvialable, userID .
   See database_service.dart .
   As queries in cloud firestore is fast. For each actor in roster we attach userID to it, then to get roster we use 'where' clause  
   db.collection('actor').where('user',isEqualTo: user).

addToRoster -> \_db .
.collection('actor')  
 .document(actorID)  
 .updateData({'user': user, 'isAvailable': false});

RemoveFromRoster -> \_db .
.collection('actor')  
 .document(actorID)  
 .updateData({'user': '', 'isAvailable': true}); .

GetAvailableActors -> \_db  
 .collection('actor')  
 .where('isAvailable', isEqualTo: true) .
.snapshots()  
 .map((snap) => Actor.actorsList(snap))  


### Shared State

We are sharing one state with our app and that is User, as we need to access user in many places. User with ChangeNotifier class contain logout and updateUser methods.

### Data

There is on model in app, Actor, which model data from map and from firestore into Actor that contains dart fields.

### Core

Helper methods such as username, name, cost validors are placed here.

- add_new_actor_screen.dart
  - available_actors.dart
  - home_screen.dart
  - reusable_components
    - submit_button.dart
    - transparent_button.dart
  - roster_screen.dart
  - signup_page.dart

### UI

#### Home Screen

Shows LoggedInPage if user logged in -> which is checked from User state by provider.  
Else, Shows AvailableActor, which is wrapped up by StreamProvider, having stream : db.availableActors, which is implemented in the db service.

#### SignUpPage

SignIn -> If the user exists from db (which is just a name), it provide User to app on sign in.  
SignUp -> Creates a user, update the db, and logIn to app.
If no user is present in db, on signIn it gives error.  
If user is already registeres in db, on signUp it gives error.

#### AvailableActors

Shows the list of available actors realtime, as data is showing from stream which gets automatically build on updation.

#### AddNewActors

Add new actors to db. Care has been taken to check if valid name and cost is provided to fields.

#### RosterScreen

Getting stream of actors from db.roster which returns Stream<List<Actor>>
