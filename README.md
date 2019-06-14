# LocateMyUsers
An convenient way to populate user location on map view with custom annotations and reverse geocoded location names.


# Installation & Testing
 
Steps to build and test the application
### PreRequisite (Xcode & internet connectivity)
* Unzip the LocateMyUsers.zip file. 
* Open LocateMyUsers Folder and then open the LocateMyUsers.xcodeproj file in Xcode.
* Compile the code by pressing following command on keyboard — Command/Windows + B 
* If there is no compilation error, press Command/Window+R or Select Play button from the top right corner.
* It should automatically run the simulator, otherwise select the simulator and you should be able to see the Splash screen (Opening screen).
* After couple of seconds you will be able to see the Landing page i.e Map view of users fetched from the API. (10 users at once) with Name and location marked with annotations on map.
* To get the full name & previous locations of any individual user, just select the annotation of user you want info for and then it will take you to next screen, which is also a map view but with previous locations of user marked on the map. 
* To get more info, just tap on any marked location (annotation), you will be prompted with following details.
```
 First Name & Last name
```
```
Location Name (Reverse geocoded)
```
* The Landing Page has another option to see alphabetically sorted list of all fetched users.
* To get the details of any specific user, just tap on the user and you will be taken to the all previous locations of that user marked on map.

### Built with

*Multiplatform binary framework (Kotlin)*
*Xcode (Swift)*

# API Reference

### API Models

```
User
```

Firstname : String

Lastname : String

LastLocation : Location

LastLocations : List **Location**

```
 Location
```

Latitude : Double

Longitude : Double

