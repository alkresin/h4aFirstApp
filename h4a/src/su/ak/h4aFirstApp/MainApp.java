package su.ak.h4aFirstApp;

import android.app.Application;

public class MainApp extends Application {

   public static Harbour harb;

   @Override
   public void onCreate() {
      super.onCreate();

      harb = new Harbour( this );

      harb.Init();

   }
}