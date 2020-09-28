module IHP.LoginSupport.Helper.View
( currentUser
, currentUserOrNothing
)
where

import IHP.Prelude

currentUser :: (?viewContext :: viewContext, HasField "user" viewContext (Maybe user)) => user
currentUser = fromMaybe (error "Application.Helper.View.currentUser: Not logged in") currentUserOrNothing

currentUserOrNothing :: (?viewContext :: viewContext, HasField "user" viewContext (Maybe user)) => Maybe user
currentUserOrNothing = getField @"user" ?viewContext 

currentAdmin :: (?viewContext :: viewContext, HasField "admin" viewContext (Maybe admin)) => admin
currentAdmin = fromMaybe (error "Application.Helper.View.currentAdmin: Not logged in") currentAdminOrNothing

currentAdminOrNothing :: (?viewContext :: viewContext, HasField "admin" viewContext (Maybe admin)) => Maybe admin
currentAdminOrNothing = getField @"admin" ?viewContext
