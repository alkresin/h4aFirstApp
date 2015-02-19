
#include <string.h>
#include <jni.h>

#include "hbvm.h"
#include "hbstack.h"
#include "hbapi.h"
#include "hbapiitm.h"

static char * szHomePath = NULL;
static char * szHrb = NULL;
static JNIEnv* h_env;
static jobject h_thiz;

HB_FUNC( H4A_HOMEDIR )
{
   hb_retc( szHomePath );
}

HB_FUNC( H4A_ISINTERNETON )
{

   jclass cls = (*h_env)->GetObjectClass( h_env, h_thiz );
   jmethodID mid = (*h_env)->GetStaticMethodID( h_env, cls, "isInternetOn", "()Z" );

   hb_retl( (*h_env)->CallStaticBooleanMethod( h_env, cls, mid ) );
}

HB_FUNC( H4A_WRLOG )
{

   jclass cls = (*h_env)->GetObjectClass( h_env, h_thiz );

   jmethodID mid = (*h_env)->GetStaticMethodID( h_env, cls, "hlog", "(Ljava/lang/String;)V" );

   if( mid )
      (*h_env)->CallStaticVoidMethod( h_env, cls, mid, (*h_env)->NewStringUTF( h_env, hb_parc(1) ) );

}

HB_FUNC( H4A_WEBLOAD )
{

   jclass cls = (*h_env)->GetObjectClass( h_env, h_thiz );

   jmethodID mid = (*h_env)->GetStaticMethodID( h_env, cls, "webload", "(Ljava/lang/String;)V" );

   if( mid )
      (*h_env)->CallStaticVoidMethod( h_env, cls, mid, (*h_env)->NewStringUTF( h_env, hb_parc(1) ) );

}

void Java_su_ak_h4aFirstApp_Harbour_vmInit( JNIEnv* env, jobject thiz )
{

    hb_vmInit( 0 );
    h_env = env;
    h_thiz = thiz;
}

void Java_su_ak_h4aFirstApp_Harbour_vmQuit( JNIEnv* env, jobject thiz )
{

    hb_vmQuit();
}

static char * sz_callhrb_sz( char * szName, char * szParam1 )
{
   PHB_DYNS pSym_onEvent = hb_dynsymFindName( szName );

   if( pSym_onEvent )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( pSym_onEvent ) );
      hb_vmPushNil();
      hb_vmPushString( szParam1, strlen( szParam1 ) );
      hb_vmDo( 1 );
      return (char *) hb_parc(-1);
   }
   else
      return "???";
}

static char * sz_callhrb_i( char * szName, int iParam1 )
{
   PHB_DYNS pSym_onEvent = hb_dynsymFindName( szName );

   if( pSym_onEvent )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( pSym_onEvent ) );
      hb_vmPushNil();
      hb_vmPushInteger( iParam1 );
      hb_vmDo( 1 );
      return (char *) hb_parc(-1);
   }
   else
      return "";
}

static void * p_callhrb( char * szName, char * szParam1 )
{
   PHB_DYNS pSym_onEvent = hb_dynsymFindName( szName );

   if( pSym_onEvent )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( pSym_onEvent ) );
      hb_vmPushNil();
      hb_vmPushString( szParam1, strlen( szParam1 ) );
      hb_vmDo( 1 );
      return (char *) hb_parptr(-1);
   }
   else
      return NULL;
}

jstring Java_su_ak_h4aFirstApp_Harbour_Calc( JNIEnv* env, jobject thiz, jstring js )
{
   char * s = (char *) (*env)->GetStringUTFChars( env, js, NULL );
   return (*env)->NewStringUTF( env, sz_callhrb_sz( "H4A_CALCEXP", s ) );
}

void Java_su_ak_h4aFirstApp_Harbour_setHomePath( JNIEnv* env, jobject thiz, jstring js )
{
   szHomePath = (char *) (*env)->GetStringUTFChars( env, js, NULL );   
}

void Java_su_ak_h4aFirstApp_Harbour_setHrb( JNIEnv* env, jobject thiz, jstring js )
{
   szHrb = (char *) (*env)->GetStringUTFChars( env, js, NULL );   
}

jstring Java_su_ak_h4aFirstApp_Harbour_hrbOpen( JNIEnv* env, jobject thiz )
{
   if( szHrb ) {
      return (*env)->NewStringUTF( env, sz_callhrb_sz( "H4A_HRBLOAD", szHrb ) );
   }
   else
      return (*env)->NewStringUTF( env, "" );
}

jstring Java_su_ak_h4aFirstApp_Harbour_hrbMod( JNIEnv* env, jobject thiz, jint iMod )
{
    h_env = env;
    h_thiz = thiz;

   if( szHrb )
      return (*env)->NewStringUTF( env, sz_callhrb_i( "H4A_HRBMOD", (int) iMod ) );
   else
      return (*env)->NewStringUTF( env, "" );
}
