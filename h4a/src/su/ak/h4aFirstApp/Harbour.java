package su.ak.h4aFirstApp;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.io.FileOutputStream;
import android.content.Context;
import android.widget.Toast;

import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import android.util.Log;


public class Harbour {

    private final static String HRB = "testhrb.hrb";
    public static Context context;
    public static String cHomePath;

    public Harbour( Context cont ) {
       context = cont;
       cHomePath = context.getFilesDir() + "/";
       setHomePath( cHomePath );
    }

    public native void vmInit();
    public native void vmQuit();
    public native String Calc( String js );
    public native void setHomePath( String js );
    public native void setHrb( String js );
    public native String hrbOpen();
    public native String hrbMod( int iMod );

    public void CopyFromAsset() {

       String sFile = cHomePath + HRB;

       setHrb( HRB );

       if( ! (new File(sFile).isFile()) ) {
          try {
               InputStream myInput = context.getAssets().open(HRB);
               OutputStream myOutput = new FileOutputStream( sFile );

               byte[] buffer = new byte[myInput.available()];
               int read;
               while ((read = myInput.read(buffer)) != -1) {
                   myOutput.write(buffer, 0, read);
               }

               myOutput.flush();
               myOutput.close();
               myInput.close();

          } catch (IOException e) {
               Toast.makeText( context, "copyDataBase Error : " + e.getMessage(),
                   Toast.LENGTH_SHORT ).show();
          }
       }
    }

    public static boolean isInternetOn() {

       ConnectivityManager connectivity = 
          (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

       if(connectivity != null) {

          NetworkInfo[] info = connectivity.getAllNetworkInfo();
          if(info != null)
             for (int i = 0; i < info.length; i++)
                if(info[i].getState() == NetworkInfo.State.CONNECTED) {
                   return true;
                }
       }
       return false;
    }

    public static void hlog( String message ) {

       Log.i("Harbour", message);
    }

    static {
        System.loadLibrary("harbour");
        System.loadLibrary("harb4andr");
    }

}