# 0.0.86 / 2013-08-27

* Adds page caching
* Fixes some jQuery shenanigans

# 0.0.85 / 2013-08-21

* Re-orders and defers script to render page earlier
* Makes web server run threaded on Heroku

# 0.0.84 / 2013-08-19

* Makes login lings more prominent

# 0.0.83 / 2013-08-17

* Resizes iFrames automatically to the max possible height

# 0.0.82 / 2013-08-12

* Adds getsentry.com exception tracking
* Adds request id tracker
* Updates client depencies

# 0.0.81 / 2013-08-06

* Fixes bug that caused games to be closed immediately when accessing over a link that used ``target="_blank"``
* shows app name rather then home in the top bar
* fixes bug where game shows through the sharing/about panes
* removes pre loader ad for all apps (for the time being)
* Adjusts canvas app colours to work better with EW

# 0.0.80 / 2013-07-17

* Adds current game URL to the qs info object

# 0.0.79 / 2013-07-12

* Fixes bug that caused people to have to delete their auth cookies

# 0.0.78 / 2013-07-04

* Adds firebase tokens to the QS info

# 0.0.77 / 2013-05-31

* Moves the login to a popout to fix [#50900917](https://www.pivotaltracker.com/story/show/50900917)

# 0.0.76 / 2013-05-30

* now promoting friendbar.us
* now with google tracking
* restored center align of flash games
* removed overlapping controls on the social bar

# 0.0.75 / 2013-05-27

* Fixed avatar width (collapsing on IE and friends)

# 0.0.74 / 2013-05-27

* Loads ads via HTTPS to avoid warning messages on IE
* Fixes FlXHR problems on production

# 0.0.73 / 2013-05-27

* Loads the IE8 EventShim for Flash games, too

# 0.0.72 / 2013-05-27

* Adds flXHR for IE8 compatibility and incompatiblity CSS support classes
* Adds EventShim for IE8 support
* Migrates to .ruby-version

# 0.0.71 / 2013-05-06

* Get rids of Flash movie reloads on section changes

# 0.0.70 / 2013-05-04

* Adds super simple facebook resizing
* Removes complicated facebook resizing mechanics

# 0.0.69 / 2013-04-19

* Fixes Facebook resizing

# 0.0.68 / 2013-04-19

* Adds Facebook resizing
* added link to privacy notice to the about section
* added link to terms of service to the about section
* now preventing flickering on load

# 0.0.67 / 2013-04-18

* Adopts IFrame size on window resizing for fluidly sized HTML5 games

# 0.0.66 / 2013-04-13

* Positions the non-facebook invite box close to the actual invite button
* Adds caching abilities
* Fixes hidden sharing section for games with embedding turned off

# 0.0.65 / 2013-04-10

* Uses HTTPS to include the Facebook JS API

# 0.0.64 / 2013-04-10

* Adds invite / login fake avatars
* Creates venue identities on spiral-galaxy and embedded game plays
* Moves player registration on game plays into fire and forget threads
* Fixed avatar alignment issue
* Adds in invite functionality using Facebook's and ShareThis' API

# 0.0.63 / 2013-04-07

* Updates SDK app testing dependency
* Fixes problem with non-JSON window.post messages
* Fixes authorization problem when registering players on embed venue

# 0.0.62 / 2013-04-07

* Fixes bug in JS share buttons plugin

# 0.0.61 / 2013-04-07

* Registers players from the embedded venue as well

# 0.0.60 / 2013-04-06

* Adds sharing options for games
* Improves game play tracking

# 0.0.59 / 2013-04-06

* Updates tracking-client

# 0.0.58 / 2013-04-06

* Fixes bug in canvas height for flash games

# 0.0.57 / 2013-04-06

* Adds game play tracking
* prepares canvas for friendbar.us, fixes browser issues

# 0.0.56 / 2013-04-04

* Does not display ads for games with paid subscriptions anymore

# 0.0.55 / 2013-04-03

* Updates test dependencies

# 0.0.54

* Adopts new embed code in canvas

# 0.0.53

* Fixed size games are now centered
* Fixed size games no longer show scroll bars in Firefox

# 0.0.52

* Updates dependencies

# 0.0.51

* Adds size defaults when no size is set on the game

# 0.0.50

* Obeys game's dimension configuration

# 0.0.49

* Fixes DOM SDK integration
* Rounds numeric friend badge values to 2 decimals
* Fixes bug when displaying avatar images with Angular

# 0.0.48

* Makes flash embeds work in Firefox

# 0.0.47

* Adds a pre-roll ad

# 0.0.46

* Fixes Facebook app authentication redirect
* now cloaking the promo block

# 0.0.45

* tweaked presentation of credits line

# 0.0.44

* Makes it possible to customize the delivered build per user
* Fixes (hopefully) the last flash embedder JS bug for now

# 0.0.43

* Adds credits of a game to it's about section

# 0.0.42

* Sets flash WMODE to direct
* Fixes another bug in the flash embedder JS

# 0.0.41

* Fixes bug in the flash embedder JS

# 0.0.40

* Bumps descanter
* Adds fix to make flash games work again with asynchronous SDK loading

# 0.0.39

* Improves Flash game load times with loading the SDK asynchroniously

# 0.0.38

* Fixed static links in cross promo section to point to new domains

# 0.0.37

* Updates devcenter-backend gem to add games' categories field

# 0.0.36

* Makes it possible to log into the canvas app

# 0.0.35

* Makes it possible to play games in spiral-galaxy while not being logged in

# 0.0.34

* Redirects flash embed to HTTPS when requested via HTTPS

# 0.0.33

* introduces promo bar

# 0.0.32

* Adds more information about the game to the DOM/qs info object
* Uses the embed code provided by the devcenter to show the sharing page

# 0.0.31

* Makes the canvas work on and adopt to different screen sizes
* Makes the friend bar look good when no friends are present
* Adds sharing section dummy
* Adds about section

# 0.0.30

* Adds support for the embed venue

# 0.0.29

* Fixes frame communication for QS data exchange with nested frames

# 0.0.28

* Adds meta data default values

# 0.0.27

* Adds Newrelic monitoring and ping middleware

# 0.0.26

* Adds dynamic friend bar filter and badges

# 0.0.25

* Removes dysfunctional friend bar filter

# 0.0.24

* Adds features to the Flash and HTML5 embedder needed by the new developer SDK

# 0.0.23

* Moves to Uglify JS compressor to avoid errors in the bootstrap js

# 0.0.22

* Fixes regression in the canvas layout template

# 0.0.21

* Removes fake data displayed in the friend bar
* Adds QS navigation

# 0.0.20

* Adds a minor workaround for

# 0.0.19

* Adds ability to parse signed requests from spiral-galaxy

# 0.0.18

* Adds the name back into the friends bar

# 0.0.17

* Fixes bug that makes it impossible to pass a body with a GET request in Angular
* Fixes small bug in the DOM exposed game UUID (not quoted before)

# 0.0.16

* Shows only friends that play the specific game

# 0.0.15

* Shows real friends in the friends bar
* Minor Angular refactorings (renames ``MyApp`` module etc.)

# 0.0.14

* Moves facebook friend creation in the background

# 0.0.13

* Bumps datastore-client to use the new API

# 0.0.12

* Refactors galaxy-spiral to spiral-galaxy

# 0.0.11

* Stores facebook friends in our graph each time a user plays a game on facebook

# 0.0.10

* Changed loyout to accomodate larger games (page now scrolls). Refined look and feel

# 0.0.9

* Passes QS data to games on facebook including all OAuth tokens (FB&QS)

# 0.0.8

* Small bug fix for Facebook authentication redirects #2

# 0.0.7

* Small bug fix for Facebook authentication redirects

# 0.0.6

* Adds a rough first facebook integration through the facebook-client gem

# 0.0.5

* Bumps auth-client to fix another severe bug in the OAuth token creation on Heroku

# 0.0.4

* Fixes auth connection bug when creating OAuth tokens on Heroku

# 0.0.3

* Adds OAuth authenticated connections for the backends

# 0.0.2

* Adds venues to the canvas app

# 0.0.1

* The beginning
