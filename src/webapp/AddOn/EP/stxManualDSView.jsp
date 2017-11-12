<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script language="javascript" src="scripts/SecurePM3AX2.js"></script>
<script language="javascript" src="http://172.16.2.152/dsv/DSViewerAX.js"></script>
<script type="text/javascript" src="scripts/stxAjax.js"></script>

<script type="text/javascript">
	SecurePM3AXControl();
	DSViewerAXControl();	
</script>

<script language="javascript" type="text/javascript">
	
	function go_fileView(downloadPath, downloadname, vloginID)
    {
		var view_flag = 'Y';
    	DSViewerAXCtl.Language = 'AUTO';
    	if(view_flag && view_flag == 'Y')
    	{
    		// 중요 :: 서버별로 DS VIEW 등록 되어야함.  DIMS_MENU : 172.16.2.111,   DIMS_MENU2 : 172.16.2.112,  test2:test서버
    		downloadPath = "test2:" + downloadPath.replace("&", "&amp;");
    		var objAjax = new stxAjax("stxViewDocXMLAjax1.jsp?loginID="+vloginID+"&downloadPath="+encodeURIComponent(downloadPath)+"&downloadname="+encodeURIComponent(downloadname));
			var vReturn = objAjax.executeSync();
			
			DSViewerAXCtl.ClearOptions(); //ê¸°ì¡´ì ì¤ì ë ê°ë¤ì ì ê±°íë¤.
			 
			DSViewerAXCtl.SetOption( "XML", vReturn ); //XML ê° ì¤ì 
		 
			DSViewerAXCtl.SetOption( "MnuOpenFiles", "diable" ); // "Open Files" ë©ë´ ì ì´( enable, diable )
			DSViewerAXCtl.SetOption( "MnuOpenXml", "enable" );   // "Open XML" ë©ë´ ì ì´( enable, diable )
			DSViewerAXCtl.SetOption( "MnuDocInfo", "enable" );   // "Document Information" ë©ë´ ì ì´( enable, diable )
		 
			DSViewerAXCtl.SetOption( "MnuPrint", "diable" );     // "Print" ë©ë´ ì ì´ ( enable, diable )
			DSViewerAXCtl.SetOption( "MaxCopies", "3" );         // ìµë ë³µì¬ ë§¤ì ì¤ì  ( -1ì´ë©´ ë³µì¬ë§¤ì ì í ìì )
		 
			DSViewerAXCtl.SetOption( "MnuBookmark", "enable" );  // "Bookmark" ë©ë´ ì ì´( enable, diable )
			DSViewerAXCtl.SetOption( "MnuFileList", "enable" );  // "File List" ë©ë´ ì ì´( enable, diable )
			DSViewerAXCtl.SetOption( "MnuThumbnail", "enable" ); // "Thumbnail" ë©ë´ ì ì´( enable, diable ) 
		 
			DSViewerAXCtl.ShowViewer();
    	} else {
    		alert("no authority");
    	}
    }

</script>


