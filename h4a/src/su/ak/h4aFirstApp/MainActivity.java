package su.ak.h4aFirstApp;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.content.Intent;
import android.view.View;
import android.widget.TextView;

import android.text.SpannableStringBuilder;
import android.text.method.LinkMovementMethod;
import android.text.method.MovementMethod;
import android.text.style.CharacterStyle;
import android.text.style.ClickableSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;
import android.text.style.UnderlineSpan;

public class MainActivity extends Activity
{

    private TextView mOutputView;

    public static int iHrbMod;
    public static String sHrbName;

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        mOutputView = (TextView)findViewById(R.id.output_view);

    }

    @Override
    protected void onResume() {
        super.onResume();

        CharSequence stext = setSpans( MainApp.harb.hrbOpen(), "**" );
        mOutputView.setText( stext );
    }
/*
    @Override
    protected void onDestroy() {
        super.onDestroy();
        //harb.vmQuit();
        //System.runFinalizersOnExit(true);
        //android.os.Process.killProcess(android.os.Process.myPid());
    }
*/
    private CharSequence setSpans( CharSequence text, String token )
    {
       int tokenLen = token.length();
       int start = text.toString().indexOf(token) + tokenLen;
       int end = text.toString().indexOf(token, start);
       int iNum = 0;

       SpannableStringBuilder ssb = new SpannableStringBuilder( text );
       MovementMethod m = mOutputView.getMovementMethod();
       if ((m == null) || !(m instanceof LinkMovementMethod))
       {
          mOutputView.setMovementMethod(LinkMovementMethod.getInstance());
       }

       while( start > -1 && end > -1 )
       {
          iNum ++;
 	  ssb.setSpan( new UnderlineSpan(), start, end, 0 );
 	  ssb.setSpan( new ForegroundColorSpan(0xFF4444FF), start, end, 0 );
 	  ssb.setSpan( new SpecSpan(iNum,ssb.toString().substring(start,end)), start, end, 0 );

          // Delete the tokens before and after the span
          ssb.delete(end, end + tokenLen);
          ssb.delete(start - tokenLen, start);

          start = ssb.toString().indexOf(token) + tokenLen;
          end = ssb.toString().indexOf(token, start);
       }
       return (CharSequence) ssb;
    }


    public class SpecSpan extends ClickableSpan {

        int iMod;
        String sTitle;

        public SpecSpan( int iNum, String title ){
             super();
             iMod = iNum;
             sTitle = title;
        }

        @Override
        public void onClick(View widget) {
           iHrbMod = iMod;
           sHrbName = sTitle;
           Intent intent = new Intent( MainActivity.this, DopActivity.class );
           startActivity(intent);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        menu.add(Menu.NONE, 1, Menu.NONE, "Exit");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
        case 1:
            android.os.Process.killProcess(android.os.Process.myPid());
            return true;

        default:
            return false;
      }
    }
}
