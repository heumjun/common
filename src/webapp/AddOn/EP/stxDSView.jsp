<script language="javascript" src="scripts/SecurePM3AX2.js"></script>
<script language="javascript" src="http://dwgprint.stxons.com/dsv/DSViewerAX.js"></script>
<script type="text/javascript" src="scripts/stxAjax.js"></script>

<script type="text/javascript">
	SecurePM3AXControl();
	DSViewerAXControl();	
</script>

<script language="javascript" type="text/javascript">


	function go_pdfView(vloginID,view_flag,PART_SEQ_ID,item_catalog_group_id)
    {
    	DSViewerAXCtl.Language = 'AUTO';
    	if(view_flag && view_flag == 'Y')
    	{
    		var objAjax = new stxAjax("stxViewDocXMLAjax.jsp?loginID="+vloginID+"&p_PART_SEQ_ID="+PART_SEQ_ID+"&p_ITEM_CATALOG_GROUP_ID="+item_catalog_group_id);
			var vReturn = objAjax.executeSync();
			
			DSViewerAXCtl.ClearOptions(); //기존에 설정된 값들은 제거한다.
			 
			DSViewerAXCtl.SetOption( "XML", vReturn ); //XML 값 설정
		 
			DSViewerAXCtl.SetOption( "MnuOpenFiles", "enable" ); // "Open Files" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuOpenXml", "enable" );   // "Open XML" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuDocInfo", "enable" );   // "Document Information" 메뉴 제어( enable, diable )
		 
			DSViewerAXCtl.SetOption( "MnuPrint", "enable" );     // "Print" 메뉴 제어 ( enable, diable )
			DSViewerAXCtl.SetOption( "MaxCopies", "3" );         // 최대 복사 매수 설정 ( -1이면 복사매수 제한 없음 )
		 
			DSViewerAXCtl.SetOption( "MnuBookmark", "enable" );  // "Bookmark" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuFileList", "enable" );  // "File List" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuThumbnail", "enable" ); // "Thumbnail" 메뉴 제어( enable, diable ) 
		 
			DSViewerAXCtl.ShowViewer();
    	} else {
    		//alert("도면 View 권한이 없습니다.");
    		alert("no authority");
    	}
    }

</script>


