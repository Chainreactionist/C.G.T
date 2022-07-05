C.G.T is a game template that aims to simplify the game prototyping and development process by providing a standardized development environment. 
C.G.T provides you with all the basic tools you would need to get started on new project and prevent you from shooting yourself in the foot by spending time on the non-prototyping related parts of the project.

!!! info
    Contribute to C.G.T. If you make a `Service` or `Controller` that you find very helpful and you think it should be included. Make a pull request or contact me or share it in the discord server.
[Contact](https://discord.com/users/518944765945839635){ .md-button  align=right }
[Github](https://github.com/Chainreactionist/C.G.T/){ .md-button  align=right }


!!! info
    C.G.T is still in beta. A lot of aspects are subject to change. 

## Services currently available

* `PlayerDataService` - A module to manage the loading and unloading of player data.
* `PlayerTempDataService` - A module to manage the loading and unloading of temporary player data.
* `CommandBarService` - A module that allows you to easily create admin commands using the CMDR module by Evaera❤️.
* `GameAnalyticsService` - Responsible for initializing the game analytics module.

## Controllers currently available
* `GameAnalyticsController` - Responsible for initializing the game analytics on the client.
* `CommandBarController` - Register's keybindings for opening the CommandBar.

## Services in the works
* `ProductService` - A module that allows you to manage all purchases that happen in the game and reports this to both `PlayerDataService` and `GameAnalyticsService`.
* `SettingsService` - A module to manage players settings and create events for settings changes.

## Controllers in the works
* `N/A` Currently non in the work but the eventual goal is to implement recommendations from the community.

[Get Started](getting-started.md){ .md-button }
