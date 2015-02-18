package su.ak.h4aFirstApp;

import android.app.Activity;
import android.os.Bundle;
import android.content.Context;
import android.widget.ScrollView;
import android.widget.TextView;
import android.webkit.WebView;
import android.webkit.WebSettings;
import android.webkit.WebViewClient;
import android.webkit.JavascriptInterface;

public class DopActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        String sText = MainApp.harb.hrbMod(MainActivity.iHrbMod);

        setTitle(MainActivity.sHrbName);
        if( sText.length() > 4 && sText.substring( 0,5 ).equals( "<html" ) ) {

           WebView web = new WebView(this);

           WebSettings settings = web.getSettings();
           settings.setBuiltInZoomControls(false);
           settings.setJavaScriptEnabled(true);

           web.setWebViewClient( new MyWebViewClient() );

           web.addJavascriptInterface(new JSProxy(this), "jProxy");

           web.loadDataWithBaseURL(null, sText, "text/html", "utf-8", null);
           setContentView(web);

        } else {
           ScrollView sv = new ScrollView(this);

           TextView textView = new TextView(this);
           textView.setTextSize(18);
           textView.setText( sText );

           sv.addView(textView);

           setContentView(sv);
        }

    }

    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView webView, String url) {
            return false;
        }
    }

    private class JSProxy {

       private Context context = null;

       public JSProxy(Context c) {
           context = c;
       }

       @JavascriptInterface
       public String get(String message) {
           return MainApp.harb.Calc(message);
       }
    }
}
