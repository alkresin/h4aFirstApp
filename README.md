# h4aFirstApp
First attempt to create working Harbour application for Android

<b> Attention! Since October 6, 2023 we are forced to use two-factor authentication to be able to
   update the repository. Because it's not suitable for me, I will probably use another place for projects.
   Maybe, https://gitflic.ru/, maybe, Sourceforge... Follow the news on my website, http://www.kresin.ru/

   Внимание! С 6 октября 2023 года нас вынуждают использовать двухфакторную идентификацию для того, чтобы
   продолжать работать над проектами. Поскольку для меня это крайне неудобно, я, возможно, переведу проекты
   на другое место. Это может быть https://gitflic.ru/, Sourceforge, или что-то еще. Следите за новостями
   на моем сайте http://www.kresin.ru/ </b>

#### Changelog:

2015-02-20:  h4a_getSysDir( cType ) Harbour function implemented, which returns some
   Android public directories.

2015-02-19:  h4a_Webload( cWebPage ) Harbour function added, which allows to load
   new web content into the WebView.

2015-02-18:  New Java source file added - MainApp.java, which subclasses the
   Application class and all Harbour VM initialization code is moved there.
   This allows to solve problem with closing an application after the user
   simply rotate the screen.
             Simple menu introduced on Java level.
             Added a prototype of a JavaScript -> Java -> Harbour bridge, i.e.
   the code, which allows to call Harbour functions from the Javascript in WebView.
   It is possible also to create a multiline prg strings and send them from WebView
   to Harbour VM for execution.
