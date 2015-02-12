package su.ak.h4aFirstApp;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ScrollView;
import android.widget.TextView;
import android.webkit.WebView;
import android.webkit.WebSettings;
import android.webkit.WebViewClient;

public class DopActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        String sText = MainActivity.harb.hrbMod(MainActivity.iHrbMod);

        setTitle(MainActivity.sHrbName);
        if( sText.length() > 4 && sText.substring( 0,5 ).equals( "<html" ) ) {

           WebView mWebView = new WebView(this);

           WebSettings websettings = mWebView.getSettings();
           websettings.setBuiltInZoomControls(true);
           websettings.setJavaScriptEnabled(true);

           mWebView.setWebViewClient( new MyWebViewClient() );

           mWebView.loadDataWithBaseURL(null, sText, "text/html", "utf-8", null);
           setContentView(mWebView);

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

}
