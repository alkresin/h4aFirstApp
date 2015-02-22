
#define HRB_VERSION 6

FUNCTION FModList()
   RETURN "TestHrb v." + Ltrim(Str(HRB_VERSION)) + Chr(13)+Chr(10) + ;
          "Select from menu:" + Chr(13)+Chr(10) + Chr(13)+Chr(10) + ;
          "  **LetoDb state**" + Chr(13)+Chr(10) + ;
          "  **Test db functions**" + Chr(13)+Chr(10) + ;
          "  **Html test**" + Chr(13)+Chr(10) + ;
          "  **Get System Directories**" + Chr(13)+Chr(10) + ;
          "  **HDroidGUI news**" + Chr(13)+Chr(10) + ;
          "  **Update program**" + Chr(13)+Chr(10)

FUNCTION FModExec( iMod )

   IF iMod == 1
      RETURN FMod1()
   ELSEIF iMod == 2
      RETURN FMod2()
   ELSEIF iMod == 3
      RETURN FMod3()
   ELSEIF iMod == 4
      RETURN FModDirs()
   ELSEIF iMod == 5
      RETURN FModNews()
   ELSEIF iMod == 6
      RETURN FHrbUpdate()
   ENDIF

   RETURN "Unknown module"

FUNCTION FMod1()

   LOCAL sRet := "", cPath := "//95.80.77.43:2812/", aInfo, nSec, nDay, nHour

   IF !h4a_isInternetOn()
       RETURN "Internet connection is absent"
   ENDIF

   IF ( leto_Connect( cPath ) ) == -1
       RETURN "LetoDb server on " + cPath + " is currently unavailable"
   ENDIF

   IF ( aInfo := leto_MgGetInfo() ) == Nil
      Return ""
   ENDIF

   sRet += leto_GetServerVersion() + Chr(13)+Chr(10)
   sRet += "Users   current:" + Padl( aInfo[1],12 )
   sRet += "   Max: " + Padl( aInfo[2],12 ) + Chr(13)+Chr(10)
   sRet += "Tables  current:" + Padl( aInfo[3],12 )
   sRet += "   Max: " + Padl( aInfo[4],12 ) + Chr(13)+Chr(10)
   nSec := Val( aInfo[5] )
   nDay := Int(nSec/86400)
   nHour := Int((nSec%86400)/3600)
   sRet += "Time:   " + Padl(Ltrim(Str(nDay)) + Iif(nDay==1," day "," days ") + ;
               Ltrim(Str(nHour))+Iif(nHour==1," hour "," hours ") + ;
               Ltrim(Str(Int((nSec%3600)/60))) + " min",25) + Chr(13)+Chr(10)

   leto_DisConnect()

   RETURN sRet

FUNCTION FMod2()

   LOCAL sRet, cPath := "//95.80.77.43:2812/"

   IF !h4a_isInternetOn()
       RETURN "Internet connection is absent"
   ENDIF

   IF ( leto_Connect( cPath ) ) == -1
       RETURN "LetoDb server on " + cPath + " is currently unavailable"
   ENDIF

   RDDSETDEFAULT( "LETO" )
   
   //dbCreate( cPath+"testa", { {"NAME","C",10,0}, {"NUM","N",4,0}, {"INFO","C",32,0}, {"DINFO","D",8,0} } )

   USE ( cPath+"testa" ) New SHARED

   sRet := '<html><body>Reccount: ' + Str( RecCount() ) + '<br><br><table border="1" cellpadding="6">'

   GO TOP
   DO WHILE !Eof()
      sRet += "<tr><td>" + Str(NUM) + "</td><td>" + NAME + "</td></tr>"
      SKIP
   ENDDO

   dbCloseAll()
   leto_DisConnect()

   RETURN sRet + "</table></body></html>"

FUNCTION FMod3()

   LOCAL sRet, i

   SET DATE FORMAT "dd/mm/yyyy"

   sRet := '<html><head>' + ;
      '<script type="text/javascript">function r1(){document.getElementById("p1").innerHTML=(typeof jProxy!=="undefined")? jProxy.get("hb_version()") : "Error";}' + ;
      'function r2(){document.getElementById("p1").innerHTML=(typeof jProxy!=="undefined")? jProxy.get("function test1\r\n return [today is ]+dtoc(date())") : "Error";}</script>' + ;
      '</head><body><input type="submit" value="Get Harbour version" onclick="r1();"><input type="submit" value="Date" onclick="r2();">' + ;
      '<p id="p1"></p>Next 20 days<table border="1" cellpadding="6">'
   FOR i := 1 TO 20
      sRet += "<tr><td>" + Dtoc( Date() + i - 1 ) + ":</td><td><i>" + CDow( Date() + i - 1 ) + "</i></td></tr>"
   NEXT

   RETURN sRet + '</table></body></html>'


FUNCTION FModDirs()

   RETURN h4a_getSysDir("ext") + Chr(13)+Chr(10) + h4a_getSysDir("doc") + Chr(13)+Chr(10) + ;
          h4a_getSysDir("pic") + Chr(13)+Chr(10) + h4a_getSysDir("mus") + Chr(13)+Chr(10) + ;
          h4a_getSysDir("down") + Chr(13)+Chr(10) + h4a_getSysDir("ring") + Chr(13)+Chr(10) + ;
          h4a_homedir()

FUNCTION FModNews()

   LOCAL oSock, cBuff, lRes := .F.

   IF !h4a_isInternetOn()
       RETURN "Internet connection is absent"
   ENDIF

   hb_inetInit()
   oSock := HHTTP():New()

   IF !Empty( cBuff := oSock:Get( "www.kresin.ru/en/hdgnews.html" ) )
      lRes := .T.
   ENDIF

   oSock:Close()
   hb_inetCleanup()

   IF lRes
      RETURN cBuff
   ENDIF

   RETURN "Can't get information"


FUNCTION FHrbUpdate()
   LOCAL oSock, cBuff, lRes := .F., cNewVer, lNoNewVer := .F.

   IF !h4a_isInternetOn()
       RETURN "Internet connection is absent"
   ENDIF

   hb_inetInit()
   oSock := HHTTP():New()

   cNewVer := oSock:Get( "www.kresin.ru/down/android/testhrb.ver" )
   IF !Empty( cNewVer ) 
      IF Val( cNewVer ) > HRB_VERSION
         IF !Empty( cBuff := oSock:Get( "www.kresin.ru/down/android/testhrb.hrb" ) )
            hb_memowrit( h4a_HomeDir()+"testhrb.hrb", cBuff )
            lRes := .T.
         ENDIF
      ELSE
         lNoNewVer := .T.
      ENDIF
   ENDIF

   oSock:Close()
   hb_inetCleanup()

   IF lRes
      hb_hrbUnLoad( m->hrbHandle )
      m->hrbHandle := Nil
      RETURN "Update successful, new version: " + cNewVer
   ENDIF

   RETURN Iif( lNoNewVer, "No new updates", "Connection failed." )

#include "hbclass.ch"
#define SOCKET_BUFFER_SIZE  8192

CLASS HSocket

   DATA hSock

   DATA nPort
   DATA cProto
   DATA cServer

   DATA nRecvTimeout    INIT -1
   DATA bCallBack
   DATA lCancel
   DATA lBackGround     INIT .F.
   DATA nError          INIT 0
   DATA cBuffer
   DATA crlf            INIT e"\r\n"

   METHOD New()
   METHOD Close()

   METHOD Connect( cUrl, nPort )

   METHOD SendString( cString )
   METHOD Recv()
   METHOD RecvLine()
   METHOD Wait()

   METHOD SetRecvTimeout( nMilliSec )
   METHOD SetCallBack( bBlock )
   METHOD SetCancel()   INLINE  ::lCancel := .T.

ENDCLASS


METHOD New() CLASS HSocket

   ::hSock := hb_InetCreate()
return Self

METHOD Close() CLASS HSocket
Local nRet := -1

   IF !Empty( ::hSock )
      nRet := hb_InetClose( ::hSock )
      ::hSock := Nil
   ENDIF
return nRet

METHOD Connect( cUrl, nPort ) CLASS HSocket
Local nPos, cServer

   IF ( nPos := At( "://", cUrl ) ) > 0
      ::cProto := Left( cUrl, nPos-1 )
      cUrl := Substr( cUrl, nPos+3 )
   ENDIF
   IF Empty( nPos := At( "/", cUrl ) )
      cServer := cUrl
   ELSE
      cServer := Left( cUrl, nPos-1 )
   ENDIF

   IF Empty( ::cServer ) .OR. !( ::cServer == cServer ) .OR. ::nPort != nPort

      ::cServer := cServer
      ::nPort := nPort

      hb_InetConnect( cServer, nPort, ::hSock )
      IF hb_InetErrorCode( ::hSock ) != 0
         Return .F.
      ENDIF
   ENDIF

Return .T.

METHOD SendString( cString ) CLASS HSocket

return ( hb_InetSendAll( ::hSock, cString ) > 0 )

METHOD Recv( cEnd, nBytes ) CLASS HSocket
Local cRet := "", nRet, nRead
Local cBuf := Space( SOCKET_BUFFER_SIZE )

   ::nError := 0

   IF !::lBackGround
      ::cBuffer := ""
   ENDIF
   DO WHILE ( nRet := ::Wait() ) > 0
      IF Empty( nRead := hb_InetRecv( ::hSock, @cBuf ) )
         EXIT
      ELSE
         cRet += Left( cBuf,nRead )
         IF ( nBytes != Nil .and. Len(::cBuffer)+Len(cRet) >= nBytes ) .or. ;
               ( cEnd != Nil .and. Right( cRet,Len(cEnd) ) == cEnd )
            EXIT
         ENDIF
      ENDIF
   ENDDO
   IF ::lBackGround
      ::cBuffer += cRet
   ELSE
      ::cBuffer := cRet
   ENDIF

Return ( nRet == 1 )

METHOD RecvLine() CLASS HSocket
Local nRet, cRet := ""

   ::nError := 0

   nRet := ::Wait()

   IF nRet == 1
      cRet := hb_InetRecvLine( ::hSock )
   ELSEIF nRet == -1
      ::nError := hb_inetErrorCode( ::hSock )
   ENDIF
   ::cBuffer := cRet

Return ( nRet == 1 )

METHOD Wait() CLASS HSocket
Local nRet, nMsSec0 := Seconds()

   IF ::lBackGround
      nRet := hb_InetDataReady( ::hSock )
   ELSE
      ::lCancel := .F.
      DO WHILE ( nRet := hb_InetDataReady( ::hSock ) ) >= 0
         IF nRet > 0
            EXIT
         ELSE  // Wait - the data isn't ready
            IF ::bCallBack != Nil
               Eval( ::bCallBack )
               IF ::lCancel
                  ::nError := -2
                  EXIT
               ENDIF
            ENDIF
            IF ::nRecvTimeout != -1 .AND. ( Seconds() - nMsSec0 ) > ::nRecvTimeout
               ::nError := -1
               EXIT
            ENDIF
         ENDIF
      ENDDO
   ENDIF
Return nRet

METHOD SetRecvTimeout( nMilliSec ) CLASS HSocket

   ::nRecvTimeout := Iif( nMilliSec == Nil .OR. nMilliSec <= 0, -1, nMilliSec / 1000 )
Return Nil

METHOD SetCallBack( bBlock ) CLASS HSocket

   ::bCallBack := bBlock
Return Nil


CLASS HHTTP INHERIT HSocket

   DATA   cHeader
   DATA   nAnsCode    INIT -1
   DATA   cAnsCode    INIT ""
   DATA   nLength
   DATA   bChunked

   METHOD Get( cUrl )
   METHOD Post( cUrl )
   METHOD recvChunked()
ENDCLASS

METHOD Get( cUrl ) CLASS HHTTP
Local cLine, nPos

   IF !( "://" $ cUrl )
      cUrl := "http://" + cUrl
   ENDIF

   IF !::Connect( cUrl,80 )
      Return Nil
   ENDIF

   cUrl := "GET " + cUrl + " HTTP/1.1" + ::crlf
   cURL += "Host: " + ::cServer + ::crlf
   cUrl += ::crlf

   ::bChunked := .F.
   ::nLength  := -1

   IF !::SendString( cUrl )
      Return Nil
   ENDIF
   ::cHeader := ""
   DO WHILE ::recvLine() .AND. !Empty( ::cBuffer )
      ::cHeader += ::cBuffer+::crlf
      IF Left( cLine := Lower( ::cBuffer ),5 ) == "http/"
         IF ( nPos := At( " ", cLine ) ) != 0
            ::nAnsCode := Val( Substr( cLine,nPos+1 ) )
            ::cAnsCode := Substr( cLine,nPos+5 )
         ENDIF
      ELSEIF Left( cLine,14 ) == "content-length" .AND. ! ::bChunked
         ::nLength := Val( SubStr( cLine, 16 ) )
      ELSEIF Left( cLine,17 ) == "transfer-encoding"
         IF "chunked" $ cLine
            ::bChunked := .T.
            ::nLength := -1
         ENDIF
      ENDIF
   ENDDO
   IF ::nError != 0 .OR. ::nAnsCode >= 300
      Return Nil
   ENDIF

   IF ::bChunked
      IF ::recvChunked()
         Return ::cBuffer
      ENDIF
   ELSE
      IF ::recv( , Iif( ::nLength>0,::nLength,Nil ) )
         Return ::cBuffer
      ENDIF
   ENDIF

Return Nil

METHOD Post( cUrl ) CLASS HHTTP

   IF !( "://" $ cUrl )
      cUrl := "http://" + cUrl
   ENDIF

   IF !::Connect( cUrl,80 )
      Return Nil
   ENDIF

Return Nil

METHOD recvChunked() CLASS HHTTP
Local cLine, cRet := "", nRet, nLen
Local cBuf

   ::nError := 0

   IF !::lBackGround
      ::cBuffer := ""
   ENDIF

   DO WHILE ( nRet := ::Wait() ) > 0
      cLine := hb_InetRecvLine( ::hSock )
      IF Empty( cLine )
         IF hb_inetErrorCode( ::hSock ) != 0
            Return .F.
         ELSE
            LOOP
         ENDIF
      ELSEIF cLine == "0"
         EXIT
      ELSE
         nLen := hb_HexToNum( cLine )
         cBuf := Space( nLen )
         IF Empty( hb_InetRecvAll( ::hSock, @cBuf ) )
            EXIT
         ELSE
            cRet += cBuf
         ENDIF
      ENDIF
   ENDDO
   IF ::lBackGround
      ::cBuffer += cRet
   ELSE
      ::cBuffer := cRet
   ENDIF

Return .T.
