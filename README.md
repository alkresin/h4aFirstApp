# h4aFirstApp
First attempt to create working Harbour application for Android


#### Changelog:

2015-02-18:  New Java source file added - MainApp.java, which subclasses the
   Application class and all Harbour VM initialization code is moved there.
   This allows to solve problem with closing an application after the user
   simply rotate the screen.
             Simple menu introduced on Java level.
             Added a prototype of a JavaScript -> Java -> Harbour bridge, i.e.
   the code, which allows to call Harbour functions from the Javascript in WebView.