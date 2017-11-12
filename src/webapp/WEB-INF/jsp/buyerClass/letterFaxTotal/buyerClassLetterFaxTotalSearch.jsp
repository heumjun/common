<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.sql.*"%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import="java.net.URLDecoder"%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<%--========================== JSP =========================================--%>
<%
    /* Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");
	//String languageStr 		= request.getHeader("Accept-Language");
	//String buyerClassLetterFaxInputHead = "";
	//String buyerClassLetterFaxInputBody	= "";
	//buyerClassLetterFaxInputHead = "stxPECBuyerClassLetterFaxTotalSearchHead.jsp";
	//buyerClassLetterFaxInputBody = "stxPECBuyerClassLetterFaxTotalSearchBody.jsp";
	//String framesetRows = "*,0,0";
	String adminYN = "N";
	java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	StringBuffer queryStr = new StringBuffer();
	queryStr.append("select 'X' 								     ");
	queryStr.append("  from CCC_SAWON A 							 ");
	queryStr.append("     , DCC_DEPTCODE B  						 ");
	queryStr.append("     , DCC_DWGDEPTCODE C						 ");
	queryStr.append(" where A.EMPLOYEE_NUM = '"+loginID+"' ");
	queryStr.append("   and A.DEPT_CODE = B.DEPTCODE				 ");
	queryStr.append("	and B.DWGDEPTCODE = C.DWGDEPTCODE 			 ");
	queryStr.append("	and C.DOCUMENTSECURITYYN in ('Y' , 'N')      ");

    java.sql.Statement stmt = conn.createStatement();
    java.sql.ResultSet rset = stmt.executeQuery(queryStr.toString());

	if (rset.next()) {
		adminYN = "Y";
	}
	
	boolean isAdmin = false; 
	try {
	    Map loginUserInfo = getEmployeeInfo(loginID);
	    if (loginUserInfo != null) 
	    {
	        // 시수조회 & 입력의 대상 설계자는 Login User를 초기값으로 한다
	        // 일반 사용자인 경우 설계자와 Login User가 동일. Admin.인 경우 대상 설계자를 변경 가능함
	        if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = true; 
	    }
	}
	catch (Exception e) {
		e.printStackTrace();
	} */
%>
<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="JavaScript">
    
	function doneMethod() {		
		parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
		parent.window.close();
	}

	function cancelMethod(){
		parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
		parent.window.close();
	}		

	var topX = "";
	var topY = "";
	
	function getPoint(){
		topX = event.clientX;
		topY = event.clientY;
	}
	
	function searchDetailDialog()
	{
		alert("상세검색은 퍼포먼스 문제로 해당기능을 사용할 수 없습니다.");
		return;
		//alert("open detail search");
		detailSearchDIV.style.left = 10;
		detailSearchDIV.style.top = 10;
		
		if(detailSearchDIV.style.display == "none")
			detailSearchDIV.style.display = "";
		else
			detailSearchDIV.style.display = "none";
	}
	
	function viewDetailDialog(divNum)
	{
		/* var divDisplay = document.getElementById(divNum).style.display;
		
		var layers = document.getElementsByTagName("div");
		for(var i=0;i<layers.length;i++)
			layers[i].style.display = "none";
	
		//document.getElementById(divNum).style.left = 0;
		//document.getElementById(divNum).style.top = topY-130;
		
		dataDIV.style.display = "";
		
		if(divDisplay == "none")
			document.getElementById(divNum).style.display = "";
		else
			document.getElementById(divNum).style.display = "none"; */
		$.blockUI({message : $('#'+divNum)
	  		,css : {width  : '800px'
		  	,cursor:'pointer'}
		});
		$('.blockUI.blockMsg').center();
	}
	
	function addRefObj(divNum)
	{
		document.getElementById(divNum).style.left = 5;
		document.getElementById(divNum).style.top = topY-125;		
		if(document.getElementById(divNum).style.display == "none")
			document.getElementById(divNum).style.display = "";
		else
			document.getElementById(divNum).style.display = "none";

	}
	
	function searchList()
	{
		//검색 시 호선 필수값 제외
		var project = document.totalSearchForm.project.value.toUpperCase();
		document.totalSearchForm.project.value = project;
		//if(project == ""){
		//	alert("호선을 입력하세요.");
		//	document.totalSearchForm.project.focus();
		//	return;
		//}
		
		var includeSeries = document.totalSearchForm.includeSeries.checked;
		var refNoType = document.totalSearchForm.refNoType.value;
		var refNo = document.totalSearchForm.refNo.value.toUpperCase();
		document.totalSearchForm.refNo.value = refNo;
		var subject = document.totalSearchForm.subject.value.toUpperCase();
		document.totalSearchForm.subject.value = subject;
		var originator = document.totalSearchForm.originator.value;
		var fromDate = document.totalSearchForm.fromDate.value;
		var toDate = document.totalSearchForm.toDate.value;
		var departmentType = document.totalSearchForm.departmentType.value;
		var department = document.totalSearchForm.department.value;
		var ownerClass;
		for(i=0 ; i<document.totalSearchForm.ownerClass.length ; i++){
			if(document.totalSearchForm.ownerClass[i].checked){
				ownerClass = document.totalSearchForm.ownerClass[i].value;
			}
		}
		var sendReceive;
		for(i=0 ; i<document.totalSearchForm.sendReceive.length ; i++){
			if(document.totalSearchForm.sendReceive[i].checked){
				sendReceive = document.totalSearchForm.sendReceive[i].value;
			}
		}
		
		var url = "buyerClassLetterFaxTotalSearch.do?mode=search";
        
        //document.totalSearchForm.action = fnEncode(url);
		document.totalSearchForm.action = encodeURI(url);
        document.totalSearchForm.submit(); 
        
        return;
	}
	
	/* function searchDetailList()
	{
		var project = document.totalSearchForm.detailProject.value;
		var subject = document.totalSearchForm.detailSubject.value;
		var exSubject = document.totalSearchForm.excludeDetailSubject.value;
		
		if(subject == "(검색단어 띄어쓰기로 구분)"){
			subject = "";
		}
		
		var detailSendReceiveAll = document.totalSearchForm.detailReceive.checked;
		
		var detailReceive = document.totalSearchForm.detailReceive.checked;
		var detailSend = document.totalSearchForm.detailSend.checked;
		var detailOwner = document.totalSearchForm.detailOwner.checked;
		var detailClass = document.totalSearchForm.detailClass.checked;
		
		var detailAndOr;
		for(i=0 ; i<document.totalSearchForm.detailAndOr.length ; i++){
			if(document.totalSearchForm.detailAndOr[i].checked){
				detailAndOr = document.totalSearchForm.detailAndOr[i].value;
			}
		}
		
		var subjectType = document.totalSearchForm.detailSubjectType.checked;
		var keyWord = document.totalSearchForm.detailKeyWord.checked;
		var dwgNo = document.totalSearchForm.detailDwgNo.checked;
		var originator = document.totalSearchForm.detailOriginator.checked;
		
		//alert(subject);
		
		var detailDate;
		for(i=0 ; i<document.totalSearchForm.detailDate.length ; i++){
			if(document.totalSearchForm.detailDate[i].checked){
				detailDate = document.totalSearchForm.detailDate[i].value;
			}
		}
		var fromDate = document.totalSearchForm.detailFromDate.value;
		var toDate = document.totalSearchForm.detailToDate.value;
		
		var url = "stxPECBuyerClassLetterFaxTotalSearchHead.jsp"
			    + "?project=" + project 
			    + "&subject=" + escape(encodeURIComponent(subject))
			    + "&exSubject=" + escape(encodeURIComponent(exSubject))
			    + "&detailDate=" + detailDate
			    + "&fromDate=" + fromDate
			    + "&toDate=" + toDate
			    + "&receiveCheck=" + detailReceive
			    + "&sendCheck=" + detailSend
			    + "&ownerCheck=" + detailOwner
			    + "&classCheck=" + detailClass
			    + "&detailAndOr=" + detailAndOr
			    + "&subjectType=" + subjectType
			    + "&keyWord=" + keyWord
			    + "&dwgNo=" + dwgNo
			    + "&originator=" + originator
			    + "&mode=detailsearch"
			    ;
        
        //document.totalSearchForm.action = fnEncode(url);
		document.totalSearchForm.action = encodeURI(url);
        document.totalSearchForm.submit(); 
        
        return;
	} */
	
	function viewRefNo(obj)
	{
		if(obj.value == ""){
			alert("Ref. No. 가 없습니다.");
			return;
		}
	
		var attURL = "buyerClassLetterFaxViewFileOpen.do";
	    attURL += "?refNo=" + obj.value;
	
	    //var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	    var nwidth = 680;
		var nheight = 340;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;
	    //window.showModalDialog(attURL,"",sProperties);
	    window.open(attURL,"",sProperties);
	}
	
	function viewRevNo(obj)
	{
		if(obj.value == ""){
			alert("Rev. No. 가 없습니다.");
			return;
		}
		
		/* var attURL = "stxPECBuyerClassLetterFaxViewFileOpen.jsp";
	    attURL += "?revNo=" + obj.value;
	
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	    //window.showModalDialog(attURL,"",sProperties);
	    window.open(attURL,"",sProperties); */
		var attURL = "buyerClassLetterFaxViewFileOpen.do";
	    attURL += "?revNo=" + obj.value;
	
	    //var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
		var nwidth = 680;
		var nheight = 340;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;
	    //window.showModalDialog(attURL,"",sProperties);
	    window.open(attURL,"",sProperties);
	}
	
	function viewRefDoc(refNo)
	{
		var attURL = "buyerClassLetterFaxViewFileDialog.do";
	    attURL += "?refNo=" + refNo;
	    
		//showModalDialog(attURL, 400, 400);
	    var sProperties = 'dialogHeight:400px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
	    showModalDialog (attURL,"",sProperties);	 
	}
	
	/* function modRefDoc(count)
	{
		var sendReceiveType = document.totalSearchForm.elements["sendReceiveType"+count].value;
		var refNo 			= document.totalSearchForm.elements["refNo"+count].value;
		var revNo 			= document.totalSearchForm.elements["revNo"+count].value;
		var subject 		= document.totalSearchForm.elements["subject"+count].value;
		var sendReceiveDept = document.totalSearchForm.elements["sendReceiveDept"+count].value;
		var refDept			= document.totalSearchForm.elements["refDept"+count].value;
		
		if (window.ActiveXObject) {
        	xmlHttp8 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp8 = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
        		+ "?refNo=" + refNo.replace("&","%26")
				+ "&revNo=" + revNo
				+ "&subject=" + subject
				+ "&sendReceiveType=" + sendReceiveType
				+ "&sendReceiveDept=" + sendReceiveDept
				+ "&refDept=" + refDept
				+ "&mode=modDoc"
				;
        
        xmlHttp8.open("GET", url, false);
        xmlHttp8.onreadystatechange = callbackModifyDoc;
        xmlHttp8.send(null);
        
        alert("저장되었습니다.");
		
	} */
	
	/* function callbackModifyDoc() {
    	if (xmlHttp8.readyState == 4) {
        	if (xmlHttp8.status == 200) {
        		var result = xmlHttp8.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp8.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    } */
	
	function delRefDoc(refNo , teamCode, ownerClassType)
	{
		//alert("Delete "+refNo+" document.");
		
		if(teamCode == "000002"){
			alert("담당자만 삭제 가능합니다.");
		}
		
		if(confirm("문서번호 "+refNo+" 공문 및 첨부파일이 삭제됩니다.\n해당 도면에 대한 승인발송 실적이 삭제되오니,유의 바랍니다.\n\n삭제 하시겠습니까?")){
			/* if (window.ActiveXObject) {
	        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	        }
	        else if (window.XMLHttpRequest) {
	        	xmlHttp = new XMLHttpRequest();     
	        } */
	        var url = "buyerClassLetterFaxDocumentDeleteProcess.do"
	        		+ "?refNo="+refNo.replace("&","%26")
	        		+ "&ownerClassType="+ownerClassType
	        		;
	        
	        $.post( url, "", function( data ) {
	        	alert(data.resultMsg);
	        	var url = "buyerClassLetterFaxTotalSearch.do";
		        
		        //document.totalSearchForm.action = fnEncode(url);
				document.totalSearchForm.action = encodeURI(url);
		        document.totalSearchForm.submit();
	        }, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
			} );
	        
	        /* xmlHttp.open("GET", url, false);
	        xmlHttp.onreadystatechange = callbackDocDelete;
	        xmlHttp.send(null);
	        
	        alert("삭제되었습니다."); */
	        
	        //var url = "stxPECBuyerClassLetterFaxTotalSearchHead.jsp";
	        
	        //document.totalSearchForm.action = fnEncode(url);
			//document.totalSearchForm.action = encodeURI(url);
	        //document.totalSearchForm.submit(); 
	        
	        return;
		}
	}
	
	/* function callbackDocDelete() {
    	if (xmlHttp.readyState == 4) {
        	if (xmlHttp.status == 200) {
        		var result = xmlHttp.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    } */
    
	function delRefObj(refNo , revNo , objNo , sendReceiveType, ownerClassType, projectNo, objectType)
	{
		var confirmMsg = "관련문서(도면)이 삭제됩니다. 삭제하시겠습니까?";
		if(objectType && objectType == "drawing")
		{
			confirmMsg = "해당 도면에 대한 승인발송 실적이 삭제되오니, 유의 바랍니다. 삭제하시겠습니까?";
		}
		if(confirm(confirmMsg)){
			/* if (window.ActiveXObject) {
	        	xmlHttp4 = new ActiveXObject("Microsoft.XMLHTTP");
	        }
	        else if (window.XMLHttpRequest) {
	        	xmlHttp4 = new XMLHttpRequest();     
	        } */
	        var url = "buyerClassLetterFaxDocumentSaveProcess.do"
	        		+ "?refNo=" + refNo.replace("&","%26")
	        		+ "&revNo=" + revNo
					+ "&objectNo=" + objNo
					+ "&ownerClassType=" + ownerClassType
					+ "&sendReceiveType=" + sendReceiveType
					+ "&project=" + projectNo
					+ "&objectType=" + objectType
					+ "&mode=deleteObject"
					;
	        $.post( url, "", function( data ) {
	        	alert(data.resultMsg);
	        	searchList();
	        }, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
			} );
	        /* xmlHttp4.open("GET", url, false);
	        xmlHttp4.onreadystatechange = callbackDeleteRefObj;
	        xmlHttp4.send(null);
	        
	        alert("삭제되었습니다."); */
		}
	}
	
	function callbackDeleteRefObj() {
    	if (xmlHttp4.readyState == 4) {
        	if (xmlHttp4.status == 200) {
        		var result = xmlHttp4.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp4.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
	
	function detailAllCheck(obj)
	{
		document.totalSearchForm.detailReceive.checked = obj.checked;
		document.totalSearchForm.detailSend.checked = obj.checked;
		document.totalSearchForm.detailMasterProject.checked = obj.checked;
		document.totalSearchForm.detailOwner.checked = obj.checked;
		document.totalSearchForm.detailClass.checked = obj.checked;
		document.totalSearchForm.detailSubjectType.checked = obj.checked;
		document.totalSearchForm.detailKeyWord.checked = obj.checked;
		document.totalSearchForm.detailDwgNo.checked = obj.checked;
		document.totalSearchForm.detailComment.checked = obj.checked;
		document.totalSearchForm.detailOriginator.checked = obj.checked;
		document.totalSearchForm.detailReceiveDept.checked = obj.checked;
		document.totalSearchForm.detailSendDept.checked = obj.checked;
		//document.totalSearchForm.detailAnd.checked = obj.checked;
		//document.totalSearchForm.detailOr.checked = obj.checked;
	}
	
	function execType(etype,attribute) {
		
		//if( etype=='PROJECT' ) {
		//	showDialog("stxPECBOMProjectSelectedFS.jsp?emxSuiteDirectory=engineeringcentral&relId=&parentOID=&jsTreeID=&suiteKey=EngineeringCentral&objectId=&itemAction=FIND_PROJECT&selId=&curid=1&attr=");
    	//} else if( etype=='DATE' ) {
    	//	showCalendar('totalSearchForm',attribute,'',false,manualPRPNDCheck);
		//} 
	}
	
	function manualPRPNDCheck(){
		alert("1");
	}
	
	function saveKeyword(refNo , revNo , sendReceiveType , count)
	{
		//var keyword = document.totalSearchForm.elements["docKeyWord"+count].value;
		var keyword = $("input[name='docKeyWord"+count+"']").val();
		//alert(refNo + " keyword save process. - "+keyword);
		
		/* if (window.ActiveXObject) {
        	xmlHttp2 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp2 = new XMLHttpRequest();     
        } */
        var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?refNo=" + refNo.replace("&","%26")
        		+ "&revNo=" + revNo
        		+ "&sendReceiveType=" + sendReceiveType
				+ "&keyword=" + keyword
				+ "&mode=keyword"
				;
        $.post( url, "", function( data ) {
        	alert(data.resultMsg);
        	searchList();
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        /* xmlHttp2.open("GET", url, false);
        xmlHttp2.onreadystatechange = callbackKeywordSave;
        xmlHttp2.send(null);
        
        alert("저장되었습니다."); */
	}
	
	function saveSubject(refNo , revNo , sendReceiveType , count)
	{
		//var subject = document.totalSearchForm.elements["docSubject"+count].value.toUpperCase();
		var subject = $("input[name='docSubject"+count+"']").val().toUpperCase();
		//alert(refNo + " keyword save process. - "+keyword);
		
		/* if (window.ActiveXObject) {
        	xmlHttp2 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp2 = new XMLHttpRequest();     
        } */
        var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?refNo=" + refNo.replace("&","%26")
        		+ "&revNo=" + revNo
        		+ "&sendReceiveType=" + sendReceiveType
				+ "&subject=" + subject
				+ "&mode=subject"
				;
        $.post( url, "", function( data ) {
        	alert(data.resultMsg);
        	searchList();
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
       /*  xmlHttp2.open("GET", url, false);
        xmlHttp2.onreadystatechange = callbackKeywordSave;
        xmlHttp2.send(null);
        
        alert("저장되었습니다."); */
	}
	
	function callbackKeywordSave() {
    	if (xmlHttp2.readyState == 4) {
        	if (xmlHttp2.status == 200) {
        		var result = xmlHttp2.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp2.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
	
	function refDocSave(refNo , revNo , sendReceiveType , count)
	{
		//var refDocProject 	= document.totalSearchForm.elements["refDocProject"+count].value;
		//var refDocNo 		= document.totalSearchForm.elements["refDocNo"+count].value;
		//var refDocComment 	= document.totalSearchForm.elements["refDocComment"+count].value;
		
		var refDocProject = $("input[name='refDocProject"+count+"']").val();
		var refDocNo = $("input[name='refDocNo"+count+"']").val();
		var refDocComment = $("input[name='refDocComment"+count+"']").val();
		
		/* if (window.ActiveXObject) {
        	xmlHttp6 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp6 = new XMLHttpRequest();     
        } */
        
		var url2 = "buyerClassLetterFaxDocumentInfo.do?project="+refDocProject+"&document="+refDocNo;
        
        $.post( url2, "", function( data ) {
        	var result = data.result;
        	if(result == "||||||"){
        		alert("Not exist document data");
        		return;
        	} else {
        		var url = "buyerClassLetterFaxDocumentSaveProcess.do"
            		+ "?project=" + refDocProject
    				+ "&refNo=" + refNo
    				+ "&revNo=" + revNo
    				+ "&sendReceiveType=" + sendReceiveType
    				+ "&objectType=document"
    				+ "&objectNo=" + refDocNo
    				+ "&objectComment=" + refDocComment
    				+ "&mode=refdoc"
    				;
	            $.post( url, "", function( data ) {
	            	alert(data.resultMsg);
	            	searchList();
	            }, "json").error( function () {
	    			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
	    		} ).always( function() {
	    		} );
        	}
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        
        
        /* xmlHttp6.open("GET", url2, false);
        xmlHttp6.onreadystatechange = callbackDocInfo;
        xmlHttp6.send(null);
    	
    	var result = xmlHttp6.responseText.replace(/\s/g, "");;
    	
    	if(result == "||||||"){
    		alert("Not exist document data");
    		return;
    	}
	
		if (window.ActiveXObject) {
        	xmlHttp3 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp3 = new XMLHttpRequest();     
        }
		
		var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
        		+ "?project=" + refDocProject
				+ "&refNo=" + refNo.replace("&","%26")
				+ "&revNo=" + revNo
				+ "&sendReceiveType=" + sendReceiveType
				+ "&objectType=document"
				+ "&objectNo=" + refDocNo
				+ "&objectComment=" + refDocComment
				+ "&mode=refdoc"
				;
        
        xmlHttp3.open("GET", url, false);
        xmlHttp3.onreadystatechange = callbackDocSave;
        xmlHttp3.send(null);
	        
		alert("저장되었습니다."); */
	}
	
	/* function callbackDocSave() {
    	if (xmlHttp3.readyState == 4) {
        	if (xmlHttp3.status == 200) {
        		var result = xmlHttp3.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp3.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    } */
    
    /* function callbackDocInfo() {
    	if (xmlHttp6.readyState == 4) {
        	if (xmlHttp6.status == 200) {
        		var result = xmlHttp6.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp6.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    } */
    
    function refDwgSave(refNo , revNo , sendReceiveType , count, ownerClassType, sendReceiveDate)
    {
    	//var refDwgProject 	= document.totalSearchForm.elements["refDwgProject"+count].value;
    	//var refDwgNo		= document.totalSearchForm.elements["refDwgNo"+count].value;
    	var refDwgProject = $("input[name='refDwgProject"+count+"']").val();
    	var refDwgNo = $("input[name='refDwgNo"+count+"']").val();
    	
    	/* if (window.ActiveXObject) {
        	xmlHttp7 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp7 = new XMLHttpRequest();     
        } */
        var url2 = "buyerClassLetterFaxDrawingInfo.do?project="+refDwgProject+"&drawing="+refDwgNo;
        $.post( url2, "", function( data ) {
        	if(data.result == "|||||||||||||||"){
        		alert("Not exist document data");
        		return;
        	} else {
        		var url = "buyerClassLetterFaxDocumentSaveProcess.do"
            		+ "?project=" + refDwgProject
    				+ "&refNo=" + refNo
    				+ "&revNo=" + revNo
    				+ "&sendReceiveType=" + sendReceiveType
    				+ "&objectType=drawing"
    				+ "&objectNo=" + refDwgNo
    				+ "&objectComment="
    				+ "&mode=refdoc"
    				;
    		 $.post( url, "", function( data ) {
    	        	alert(data.resultMsg);
    	        	searchList();
    	        }, "json").error( function () {
    				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
    			} ).always( function() {
    			} );
        	}
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        /* xmlHttp7.open("GET", url2, false);
        xmlHttp7.onreadystatechange = callbackDwgInfo;
        xmlHttp7.send(null);
    	
    	var result = xmlHttp7.responseText.replace(/\s/g, "");;
    	
    	if(result == "|||||||||||||||"){
    		alert("Not exist document data");
    		return;
    	}
    	
    	if (window.ActiveXObject) {
        	xmlHttp5 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp5 = new XMLHttpRequest();     
        }
		var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
        		+ "?project=" + refDwgProject
				+ "&refNo=" + refNo.replace("&","%26")
				+ "&revNo=" + revNo
				+ "&ownerClassType=" + ownerClassType
				+ "&sendReceiveType=" + sendReceiveType
				+ "&sendReceiveDate=" + sendReceiveDate
				+ "&objectType=drawing"
				+ "&dwgAppSubmit=true"
				+ "&objectNo=" + refDwgNo
				+ "&objectComment="
				+ "&mode=refdoc"
				;
        
        xmlHttp5.open("GET", url, false);
        xmlHttp5.onreadystatechange = callbackDwgSave;
        xmlHttp5.send(null);
	        
		alert("저장되었습니다."); */
    }
    
    function callbackDwgSave() {
    	if (xmlHttp5.readyState == 4) {
        	if (xmlHttp5.status == 200) {
        		var result = xmlHttp5.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp5.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
    
    /* function callbackDwgInfo() {
    	if (xmlHttp7.readyState == 4) {
        	if (xmlHttp7.status == 200) {
        		var result = xmlHttp7.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp7.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    } */
    
    var hintcontainer = null;   
    function showhint(obj , type) {   
       	if (hintcontainer == null) {   
          	hintcontainer = document.createElement("div");   
          	hintcontainer.className = "hintstyle";   
          	document.body.appendChild(hintcontainer);   
       	}   
       	obj.onmouseout = hidehint;   
       	obj.onmousemove = movehint;   
       	if(type == 'subject')
			hintcontainer.innerHTML = obj.value;
		else if(type == 'type')
			hintcontainer.innerHTML = 'L:LETTER , F:FAX , E:E-MAIL';
		else if(type == 'date')
			hintcontainer.innerHTML = 'YYYY-MM-DD';
    }   
    function movehint(e) {   
        if (!e) e = event; // line for IE compatibility   
        hintcontainer.style.top =  (e.clientY + document.documentElement.scrollTop + 2) + "px";   
        hintcontainer.style.left = (e.clientX + document.documentElement.scrollLeft + 10) + "px";   
        hintcontainer.style.display = "";   
    }   
    function hidehint() {   
       hintcontainer.style.display = "none";   
    }
    
    function fnSetDateFrom()
    {
    	totalSearchForm.fromDate.value = formatDateStr(totalSearchForm.fromDate.value);
    }
    function fnSetDateTo()
    {
    	
    	totalSearchForm.toDate.value = formatDateStr(totalSearchForm.toDate.value);
    }
    
    function formatDateStr(dateStr)
	{
		if (dateStr.indexOf(".") > 0) { 
			var returnStr = dateStr.substring(0, 4);
			dateStr = dateStr.substring(6, dateStr.length);
			var dateStr2 = dateStr.substring(0, dateStr.indexOf("."));
			if (dateStr2.length == 1) dateStr2 = "0" + dateStr2;
			returnStr += "-" + dateStr2;
			dateStr = dateStr.substring(dateStr.indexOf(".") + 2, dateStr.length);
			dateStr2 = dateStr.substring(0, dateStr.indexOf("."));
			if (dateStr2.length == 1) dateStr2 = "0" + dateStr2;
			returnStr += "-" + dateStr2;
			return returnStr;
		}
		else return dateStr;
	}
    
    function fnOnload()
    {
    	if(totalSearchForm.toDate.value == '')totalSearchForm.toDate.value = fnSetIntialDate();
    	if(totalSearchForm.fromDate.value == '')totalSearchForm.fromDate.value = fnSetBefoerDate();
    }
    
    function fnSetIntialDate()
    {
    	/* 화면(기능)이 실행되면 초기 상태를 오늘 날짜를 기준으로 설정 */
	    var today = new Date();
	    var y = today.getFullYear().toString();
	    var m = (today.getMonth()+1).toString();
	    if (m.length == 1) m = 0 + m;
	    var d = today.getDate().toString();
	    if (d.length == 1) d = 0 + d;
	    var ymd = y + "-" + m + "-" + d;
	    return ymd;
    }
    
    function fnSetBefoerDate()
    {
    	var today = new Date();
    	var beforeDay = new Date();
    	beforeDay.setTime(today.getTime() - ( 14 * 24 * 60 * 60 * 1000 ));
    	var y = beforeDay.getFullYear().toString();
	    var m = (beforeDay.getMonth()+1).toString();
	    if (m.length == 1) m = 0 + m;
	    var d = beforeDay.getDate().toString();
	    if (d.length == 1) d = 0 + d;
	    var ymd = y + "-" + m + "-" + d;
	    return ymd;
    }
    $.fn.center = function () {
	    this.css("position","absolute");
	    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
	    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
	    return this;
	}
    function viewDetailDialogClose(divNum) {
		$.unblockUI();
	}
</script>

<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE>   
    .hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
    }   
</STYLE> 

<%
//Search Condition
String searchProject 		= (request.getParameter("project")==null?"":request.getParameter("project").replaceAll("-",""));
String searchSeries 		= request.getParameter("includeSeries");
String searchRefNoType		= request.getParameter("refNoType");
String searchRefNo 			= request.getParameter("refNo");
//String searchRevNo 			= request.getParameter("revNo");
String searchSubject 		= URLDecoder.decode((request.getParameter("subject")==null?"":request.getParameter("subject")),"UTF-8");
String searchOriginator 	= URLDecoder.decode((request.getParameter("originator")==null?"":request.getParameter("originator")),"UTF-8");
String searchFromDate 		= request.getParameter("fromDate");
String searchToDate 		= request.getParameter("toDate");
String searchDeptType 		= request.getParameter("departmentType");
String searchDepartment		= request.getParameter("department");
String searchOwnerClass 	= request.getParameter("ownerClass");
String searchSendReceive 	= request.getParameter("sendReceive");

String searchReceiveCheck 	= request.getParameter("receiveCheck");
String searchSendCheck 		= request.getParameter("sendCheck");
String searchOwnerCheck 	= request.getParameter("ownerCheck");
String searchClassCheck 	= request.getParameter("classCheck");
String searchAndOr	 		= request.getParameter("detailAndOr");
//String searchOrCheck 		= request.getParameter("orCheck");
String searchExSubject		= URLDecoder.decode((request.getParameter("exSubject")==null?"":request.getParameter("exSubject")),"UTF-8");
String searchDetailDate		= request.getParameter("detailDate");
String searchSubjectType	= request.getParameter("subjectType");
String searchKeyWord		= request.getParameter("keyWord");
String searchDwgNo			= request.getParameter("dwgNo");

String mode					= request.getParameter("mode");

// 수신일자가 Index로 되어 있는데.. 아무 조건 없으면 너무 느려서 최신 1달을 기본 조회 조건으로 함.
if(("".equals(searchFromDate) || searchFromDate==null) || ("".equals(searchToDate) || searchToDate==null))
{
	Calendar cal_today = Calendar.getInstance(); 
	Calendar cal_fromday = Calendar.getInstance(); 
	cal_today.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR));
	cal_fromday.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR) - 30);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  

	searchToDate = sdf.format(cal_today.getTime());  // today
	searchFromDate = sdf.format(cal_fromday.getTime());  // today - 30 day
}

//System.out.println(searchProject);
//System.out.println(searchRefNo);
//System.out.println(searchRevNo);
//System.out.println(searchSubject);
//System.out.println(searchOriginator);
//System.out.println(searchFromDate);
//System.out.println(searchToDate);
//System.out.println(searchReceiveDept);
//System.out.println(searchRefDept);
//System.out.println(searchOwnerClass);
//System.out.println(searchSendReceive);

//System.out.println(searchReceiveCheck);
//System.out.println(searchSendCheck);
//System.out.println(searchOwnerCheck);
//System.out.println(searchClassCheck);
//System.out.println(searchAndCheck);
//System.out.println(searchOrCheck);
//System.out.println(searchExSubject);
//System.out.println(searchDetailDate);
//System.out.println(searchSubjectType);
//System.out.println(searchKeyWord);
//System.out.println(searchDwgNo);

//System.out.println(mode);
Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
String workUser = (String)loginUser.get("user_id");
//String workUser = context.getUser();
String userName = "";
String teamCode = "";
java.sql.Connection conn = null;
java.sql.Statement stmt = null;
java.sql.ResultSet rset = null;
try{
	conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	
	StringBuffer queryStr = new StringBuffer();
	queryStr.append("select A.NAME  ");
	queryStr.append("     , (select B.DWGDEPTCODE   ");
	queryStr.append("          from DCC_DEPTCODE B ");
	queryStr.append("         where A.DEPT_CODE = B.DEPTCODE) as TEAMCODE ");
	queryStr.append("  from CCC_SAWON A  ");
	queryStr.append(" where a.EMPLOYEE_NUM = '"+workUser+"' ");
	
	stmt = conn.createStatement();
   	java.sql.ResultSet rset2 = stmt.executeQuery(queryStr.toString());
	while (rset2.next()) {
		userName = rset2.getString(1) == null ? "" : rset2.getString(1);
		teamCode = rset2.getString(2) == null ? "" : rset2.getString(2);
	}
}catch(Exception e){
	
}finally{
	if(conn!=null)
		conn.close();
}

%>
<script language="javascript">
$(function() {
		$("#fromDate").datepicker({
			dateFormat : 'yy-mm-dd',
			monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
	
			changeMonth : true, //월변경가능
			changeYear : true, //년변경가능
			showMonthAfterYear : true, //년 뒤에 월 표시
		});
		$("#toDate").datepicker({
			dateFormat : 'yy-mm-dd',
			monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
	
			changeMonth : true, //월변경가능
			changeYear : true, //년변경가능
			showMonthAfterYear : true, //년 뒤에 월 표시
		});
		$(window).bind('resize', function() {
			$('#list_body').css('height', $(window).height()-250);
		}).trigger('resize');
		
	});
</script>
<body onload="fnOnload()">
<form name=totalSearchForm method="post" action="">
<div id="mainDiv" class="mainDiv">
	<div class="subtitle">
		수신 / 발신 문서조회
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<table class="searchArea conSearch">
		<tr>
			<th>호선</th>
			<td>
				<input type="text" style="ime-mode:disabled;width:96px;" name="project" value="<%=("search".equals(mode)&&searchProject!=null&&!"null".equals(searchProject))?searchProject:""%>">
				<input type="checkbox" name="includeSeries" checked="checked">시리즈포함
			</td>
			<th>대상</th>
			<td>
				<input type="radio" name="ownerClass" value="all" checked="checked">전체
				<input type="radio" name="ownerClass" value="owner">선주
				<input type="radio" name="ownerClass" value="class">선급
			</td>
			<th>구분</th>
			<td>
				<input type="radio" name="sendReceive" value="all" checked="checked">전체
				<input type="radio" name="sendReceive" value="send">발신
				<input type="radio" name="sendReceive" value="receive">수신
			</td>
			<th>문서</th>
			<td>
				<select name="refNoType" style="background-color:#FFFF99">
					<option value="refNo">
						Ref No.
					</option>
					<option value="revNo">
						Rev No.
					</option>
				</select>
				<input  type="text" style="ime-mode:disabled;width:128px;" name="refNo" value="<%=("search".equals(mode)&&searchRefNo!=null&&!"null".equals(searchRefNo))?searchRefNo:""%>">
			</td>
			<td>
				<div  id="buttonTable" class="button endbox">
					<input type="button" class="btn_blue" value="검색" onclick="searchList()"/>
					<input type="button" class="btn_blue" value="상세검색" onclick="searchDetailDialog()"/>
				</div>
			</td>
		</tr>
	</table>
	<table class="searchArea2">
		<tr>
			<th>제목</th>
			<td>
				<input  type="text" style="ime-mode:disabled;width:280px;" name="subject" value="<%=("search".equals(mode)&&searchSubject!=null&&!"null".equals(searchSubject))?searchSubject:""%>">
			</td>
			<th>담당자</th>
			<td>
				<input  type="text" style="width:80px;" name="originator" value="<%=("search".equals(mode)&&searchOriginator!=null&&!"null".equals(searchOriginator))?searchOriginator:userName%>">
			</td>
			<th>검색일자</th>
			<td>
				<input type="text" id = "fromDate" name="fromDate" value="<%=("search".equals(mode)&&searchFromDate!=null&&!"null".equals(searchFromDate))?searchFromDate:""%>" style="width:80px;" readonly="readonly">
           		<input type="text" id = "toDate" name="toDate" value="<%=("search".equals(mode)&&searchToDate!=null&&!"null".equals(searchToDate))?searchToDate:""%>" style="width:80px;" readonly="readonly">
			</td>
			<th>부서</th>
			<td>
				<select name="departmentType" style="background-color:#FFFF99">
					<option value="all">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전체&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</option>
					<option value="receiveDept">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발신/수신부서&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</option>
					<option value="refDept">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;참조부서&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</option>
				</select>
				<input  type="text" style="width:192px;" name="department" value="<%=("search".equals(mode)&&searchDepartment!=null&&!"null".equals(searchDepartment))?searchDepartment:""%>">
			</td>
		</tr>
	</table>
	<font color="blue">&clubs;Ref No. 클릭 시 해당 공문 View&nbsp;&clubs;제목 클릭 시 관련 도면&amp;문서 View</font>
	<!-- 상단 검색 조건 끝 -->
	<!-- 하단 검색 결과 시작 -->
	<div style="border: #00bb00 1px solid;padding:5px;margin-top:10px;">
		<div id="list_head" style="overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<tr>
					<th width="4%">호선</th>
					<th width="4%">대상</th>
					<th width="4%">수신<br>발신</th>
					<th width="2%">문서<br>종류</th>
					<th width="15%">Ref. No.</th>
					<th width="15%">Rev. No.</th>
					<th width="15%">제목</th>
					<th width="8%">담당자</th>
					<th width="9%">수신일자<br>발송일자</th>
					<th width="9%">수신부서<br>발송부서</th>
					<th width="9%">참조부서</th>
					<th width="3%">첨부</th>
					<th width="3%">삭제</th>
				</tr>
			</table>
		</div>
		<div id="list_body" style="height:600px;overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
			
				<%
				
				StringBuffer selectDataSQL = new StringBuffer();
				selectDataSQL.append("select sodl.PROJECT ");
				selectDataSQL.append("     , sodl.OWNER_CLASS_TYPE ");
				selectDataSQL.append("     , sodl.SEND_RECEIVE_TYPE ");
				selectDataSQL.append("     , sodl.DOC_TYPE ");
				selectDataSQL.append("     , sodl.REF_NO ");
				selectDataSQL.append("     , sodl.REV_NO ");
				selectDataSQL.append("     , sodl.SUBJECT ");
				selectDataSQL.append("     , sodl.SENDER ");
				selectDataSQL.append("     , TO_CHAR(sodl.SEND_RECEIVE_DATE, 'YYYY-MM-DD') ");
				selectDataSQL.append("     , sodl.SEND_RECEIVE_DEPT ");
				selectDataSQL.append("     , sodl.REF_DEPT ");
				selectDataSQL.append("     , sodl.KEYWORD ");
				selectDataSQL.append("     , sodl.VIEW_ACCESS ");
				selectDataSQL.append("     , sodl.SENDER_NO ");
				selectDataSQL.append("  from stx_oc_document_list sodl ");
				if(mode!=null && "search".equals(mode)){
					String whereSQL = "";
					if(searchProject!=null && !"".equals(searchProject)){
						if("true".equals(searchSeries)){
							String seriesSQL = " project in (select projectno "
											 + "			   from lpm_newproject "
											 + "              where caseno = '1' "
											 + "                and DWGSERIESPROJECTNO = (SELECT DWGSERIESPROJECTNO "
											 + "  			   							 FROM LPM_NEWPROJECT a "
											 + "		      							WHERE a.CASENO = '1' "
											 + "			    						  AND a.projectno = '"+searchProject+"'))";
							whereSQL += (whereSQL.equals("")?"":" and ") + seriesSQL;
						}else if(!"true".equals(searchSeries)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " project = '"+searchProject+"'";
						}
					}
					if(searchOwnerClass!=null && !"".equals(searchOwnerClass) && !"all".equals(searchOwnerClass) && !"undefined".equals(searchOwnerClass)){
						whereSQL += (whereSQL.equals("")?"":" and ") + " owner_class_type = '"+searchOwnerClass+"'";
					}
					if(searchSendReceive!=null && !"".equals(searchSendReceive) && !"all".equals(searchSendReceive) && !"undefined".equals(searchSendReceive)){
						whereSQL += (whereSQL.equals("")?"":" and ") + " send_receive_type = '"+searchSendReceive+"'";
					}
					if(searchRefNo!=null && !"".equals(searchRefNo)){
						if(searchRefNoType!=null && !"".equals(searchRefNoType) && "refNo".equals(searchRefNoType)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " ref_no = '"+searchRefNo+"'";
						}else if(searchRefNoType!=null && !"".equals(searchRefNoType) && "refNo".equals(searchRefNoType)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " rev_no = '"+searchRefNo+"'";
						}
					}
					if(searchSubject!=null && !"".equals(searchSubject)){
						StringTokenizer searchSubjectToken = new StringTokenizer(searchSubject , " ");
						String subjectSQL = "";
						while(searchSubjectToken.hasMoreTokens()){
							String tempSubject = searchSubjectToken.nextToken();
							subjectSQL += (subjectSQL.equals("")?"( ":" or ") + " subject like '%"+tempSubject+"%' " ;
						}
						subjectSQL += subjectSQL.equals("")?"":" ) ";
						if(!subjectSQL.equals(""))
							whereSQL += (whereSQL.equals("")?"":" and ") + subjectSQL;
					}
					if(searchOriginator!=null && !"".equals(searchOriginator)){
						whereSQL += (whereSQL.equals("")?"":" and ") + " sender = '"+searchOriginator+"'";
					}
					if(searchDepartment!=null && !"".equals(searchDepartment)){
						if(searchDeptType!=null && !"".equals(searchDeptType) && "all".equals(searchDeptType)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " (send_receive_dept like '%"+searchDepartment+"%' or ref_dept like '%"+searchDepartment+"%')";
						}else if(searchDeptType!=null && !"".equals(searchDeptType) && "receiveDept".equals(searchDeptType)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " send_receive_dept like '%"+searchDepartment+"%'";
						}else if(searchDeptType!=null && !"".equals(searchDeptType) && "refDept".equals(searchDeptType)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " ref_dept like '%"+searchDepartment+"%'";
						}
					}
					if(searchFromDate!=null && !"".equals(searchFromDate)){
						//whereSQL += (whereSQL.equals("")?"":" and ") + " TO_CHAR(send_receive_date,'YYYY-MM-DD') >= '"+searchFromDate+"'";
						whereSQL += (whereSQL.equals("")?"":" and ") + " SEND_RECEIVE_DATE >= TO_DATE('"+searchFromDate+"','YYYY-MM-DD')";
					}
					if(searchToDate!=null && !"".equals(searchToDate)){
						//whereSQL += (whereSQL.equals("")?"":" and ") + " TO_CHAR(send_receive_date,'YYYY-MM-DD') <= '"+searchToDate+"'";
						whereSQL += (whereSQL.equals("")?"":" and ") + " SEND_RECEIVE_DATE < TO_DATE('"+searchToDate+"','YYYY-MM-DD')+1";
					}
					
					if(!whereSQL.equals("")){
						selectDataSQL.append(" where "+whereSQL);
					}
				}else if(mode!=null && "detailsearch".equals(mode)){}else{
					Calendar baseDate = Calendar.getInstance();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.US);
					
					searchToDate = sdf.format(baseDate.getTime());
					baseDate.set(Calendar.DAY_OF_YEAR, baseDate.get(Calendar.DAY_OF_YEAR) - 14);
					searchFromDate = sdf.format(baseDate.getTime());
					
					//selectDataSQL.append(" where TO_CHAR(send_receive_date,'YYYY-MM-DD') >= '"+searchFromDate+"' ");
					selectDataSQL.append(" where SEND_RECEIVE_DATE >= TO_DATE('"+searchFromDate+"','YYYY-MM-DD')");
					selectDataSQL.append(" 	 and SEND_RECEIVE_DATE < TO_DATE('"+searchToDate+"','YYYY-MM-DD')+1");
					selectDataSQL.append("   and sender_no = '"+workUser+"' ");
				}
				
				selectDataSQL.append(" order by send_receive_date desc , project , owner_class_type , send_receive_type , ref_no ");
				
				//System.out.println(selectDataSQL.toString());
				
				StringBuffer selectRefDataSQL = new StringBuffer();
				selectRefDataSQL.append("select soro.PROJECT ");
				selectRefDataSQL.append("     , soro.OBJECT_NO ");
				selectRefDataSQL.append("     , soro.OBJECT_COMMENT ");
				selectRefDataSQL.append("  from stx_oc_ref_object soro ");
				selectRefDataSQL.append(" where soro.PROJECT = ? ");
				selectRefDataSQL.append("   and soro.REF_NO = ? ");
				selectRefDataSQL.append("   and soro.OBJECT_TYPE = ? ");
				selectRefDataSQL.append(" order by object_no ");
				
				CallableStatement cstmt = conn.prepareCall(selectRefDataSQL.toString());
				
				stmt = conn.createStatement();
				System.out.println(selectDataSQL.toString());
				java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDataSQL.toString());
				
				int count = 0 ;
				while(selectDateRset.next()){
					
					String projectNo 		= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
					String ownerClassType 	= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
					String sendReceiveType	= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
					sendReceiveType = sendReceiveType.toLowerCase(); 
					String docType			= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
					String refNo			= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
					String revNo			= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
					String subject			= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
					String sender			= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
					String sendReceiveDate	= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
					String sendReceiveDept	= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
					String refDept			= selectDateRset.getString(11)==null?"":selectDateRset.getString(11);
					String keyword			= selectDateRset.getString(12)==null?"":selectDateRset.getString(12);
					String viewAccess		= selectDateRset.getString(13)==null?"":selectDateRset.getString(13);
					String senderNo			= selectDateRset.getString(14)==null?"":selectDateRset.getString(14);
					
					//System.out.println(count+" - "+projectNo+"|"+refNo+"|"+revNo);
					
					//viewAccess - team , all , null
					
					String bgColor = "";
					if("receive".equals(sendReceiveType)){
						bgColor = "#FFFFFF";
					}else if("send".equals(sendReceiveType)){
						bgColor = "#D8BFD8";
					}
					
					String sendUserTeamCode = "";
					
					try{
						conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
						
						StringBuffer queryStr2 = new StringBuffer();
						queryStr2.append("select (select B.DWGDEPTCODE   ");
						queryStr2.append("          from DCC_DEPTCODE B ");
						queryStr2.append("         where A.DEPT_CODE = B.DEPTCODE) as TEAMCODE ");
						queryStr2.append("  from CCC_SAWON A  ");
						queryStr2.append(" where a.EMPLOYEE_NUM = '"+senderNo+"' ");
						
						java.sql.Statement stmt3 = conn.createStatement();
			           	java.sql.ResultSet rset3 = stmt3.executeQuery(queryStr2.toString());
						while (rset3.next()) {
							sendUserTeamCode = rset3.getString(1) == null ? "" : rset3.getString(1);
						}
						
					}catch(Exception e){
						
					}finally{
						if(conn!=null)
							conn.close();
					}
					%>
					<tr style="background-color:<%=bgColor%>;">
						<td width="4%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=projectNo%>" readonly="readonly">
		            	</td>
						<td width="4%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=4 value="<%=ownerClassType%>" readonly="readonly">
						</td>
						<td width="4%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=4 value="<%=sendReceiveType%>" name="sendReceiveType<%=count%>" readonly="readonly">
						</td>
						<td width="2%">
							<span onmouseover="showhint(this , 'type');"><%=docType%></span>
						</td>
						<td width="15%">
							<%if("send".equals(sendReceiveType)){ %>
								<%if("team".equals(viewAccess) && !teamCode.equals(sendUserTeamCode)){ %>
									<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=refNo%>" name="refNo<%=count%>" readonly="readonly" onclick="alert('해당 팀만 볼 수 있습니다.')" onmouseover="showhint(this , 'subject');">
								<%}else{ %>
									<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=refNo%>" name="refNo<%=count%>" readonly="readonly" onclick="viewRefNo(this)" onmouseover="showhint(this , 'subject');">
								<%} %>													
							<%}else if("receive".equals(sendReceiveType)){ %>
								<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=refNo%>" name="refNo<%=count%>" onclick="viewRevNo(revNo<%=count%>)" onmouseover="showhint(this , 'subject');">
							<%} %>
						</td>
						<td width="15%">
							<%if("send".equals(sendReceiveType)){ %>
								<%if("team".equals(viewAccess) && !teamCode.equals(sendUserTeamCode)){ %>
									<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=revNo%>" name="revNo<%=count%>" readonly="readonly" onclick="alert('해당 팀만 볼 수 있습니다.')" onmouseover="showhint(this , 'subject');">
								<%}else{ %>
									<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=revNo%>" name="revNo<%=count%>" readonly="readonly" onclick="viewRefNo(refNo<%=count%>)" onmouseover="showhint(this , 'subject');">
								<%} %>
							<%}else if("receive".equals(sendReceiveType)){ %>
								<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=revNo%>" name="revNo<%=count%>" readonly="readonly" onclick="viewRevNo(this)" onmouseover="showhint(this , 'subject');">
							<%} %>
						</td>
						<td width="15%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:blue" size=40 value="<%=subject%>" name="subject<%=count%>" onclick="viewDetailDialog('refObjectDIV<%=count%>')" onmousedown="getPoint()" onmouseover="showhint(this , 'subject');">
						</td>
						<td width="8%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=sender%>" readonly="readonly">
						</td>
						<td width="9%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=10 value="<%=sendReceiveDate%>" readonly="readonly">
						</td>
						<td width="9%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=sendReceiveDept%>" name="sendReceiveDept<%=count%>" <%="receive".equals(sendReceiveType)?"":"readonly=\"readonly\""%> onmouseover="showhint(this , 'subject');">
						</td>
						<td width="9%">
							<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=20 value="<%=refDept%>" name="refDept<%=count%>" <%="receive".equals(sendReceiveType)?"":"readonly=\"readonly\""%>>
						</td>
						<td width="3%">
							<%if("send".equals(sendReceiveType) && "team".equals(viewAccess) && !teamCode.equals(sendUserTeamCode)){ %>
								<a onclick="alert('해당 팀만 볼 수 있습니다.')">X</a>
							<%}else{ %>
								<input type="button" class="btn_gray2" value="보기" onclick="viewRefDoc('<%=refNo%>')">
							<%} %>
						</td>
						<td width="3%">
							<%
							if(("send".equals(sendReceiveType) && ((userName!=null && userName.equals(sender))) ) || ("send".equals(sendReceiveType)&&"000002".equals(teamCode))){ 
							   // if(("send".equals(sendReceiveType) && userName!=null && userName.equals(sender)) || ("000002".equals(teamCode))){ %>
								<input  type="button" class="btn_gray2" value="삭제" onclick="delRefDoc('<%=refNo%>','<%=teamCode%>','<%=ownerClassType%>')">
							<%}else if("receive".equals(sendReceiveType)){ %>
								&nbsp;
							<%} else{ %>
							<a onclick="alert('담당자만 삭제 가능합니다.')">X</a>
							<%} %>
						</td>
						<!-- <td style="border: #000000 1px solid;">
							<input class="input_noBorder" style="background-color:<%//=bgColor%>; color:#000000" size=3 value="O" onclick="modRefDoc('<%//=count %>')">
						</td> -->
					</tr>
					<!-- 관련도면/관련공문 TR 시작 -->
					<tr>
						<td colspan="13" style="height:0">
							<div id="refObjectDIV<%=count%>" style="background:white; display:none; padding:5px; ">
								<div class="ex_upload">관련 도면/문서</div>
								<table class="searchArea2">
									<tr>
										<td>
											<div  id="buttonTable" class="button endbox">
												<input type="button" class="btn_blue" value="ADD" onclick="getPoint();addRefObj('refObjectAddDIV<%=count%>');"/>
												<input type="button" class="btn_blue" value="CLOSE" onclick="viewDetailDialogClose('refObjectDIV<%=count%>')"/>
											</div>
										</td>
									</tr>
								</table>
								<div class="sc_tit sc_tit2" style="margin-top:5px">관련도면</div>
									<!-- 관련도면 시작 -->
									<table class="insertArea">
										<%
										cstmt.setString(1, projectNo);
										if("send".equals(sendReceiveType))
											cstmt.setString(2, refNo);
										else if("receive".equals(sendReceiveType))
											cstmt.setString(2, revNo);
										cstmt.setString(3, "drawing");
										
										rset = cstmt.executeQuery();
										
										int dwgCount = 0;
										int docCount = 0;
										
										while(rset.next()){
											String objectProject	= rset.getString(1)==null?"":rset.getString(1);
											String objectNo 		= rset.getString(2)==null?"":rset.getString(2);
											String objectComment 	= rset.getString(3)==null?"":rset.getString(3);
											
											if(dwgCount==0){
												%>
												<tr>
													<th>
														Project
								                	</th>
													<th>
														Dwg. No
													</th>
													<th>
														Title
													</th>
													<th>
														Rev
													</th>
													<th>
														-
													</th>
													<th>
														Dwg. Start
													</th>
													<th>
														Dwg. Finish
													</th>
													<th>
														Owner/Class<br>
														App.Submit
													</th>
													<th>
														Owner/Class<br>
														App.Receive
													</th>
													<th>
														Delete
													</th>
												</tr>
												<%
											}
											//objectProject , objectNo
											
											java.sql.Statement dwgStmt = conn.createStatement();
											
											StringBuffer selectDwgDataSQL = new StringBuffer();
											selectDwgDataSQL.append("SELECT DW.PROJECTNO, ");
											selectDwgDataSQL.append("    SUBSTR(DW.ACTIVITYCODE, 1, 8) AS DWGCODE, ");
											selectDwgDataSQL.append("    DW.DWGTITLE, ");
											selectDwgDataSQL.append("    CASE WHEN (HC.DEPLOY_DATE IS NULL) THEN NULL ");
											selectDwgDataSQL.append("         ELSE (F_GET_HARDCOPY_MAX_REV(DW.PROJECTNO, SUBSTR(DW.ACTIVITYCODE, 1, 8), HC.DEPLOY_DATE)) ");
											selectDwgDataSQL.append("    END AS MAX_REVISION, ");
											selectDwgDataSQL.append("    TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");
											selectDwgDataSQL.append("    TO_CHAR(DW.PLANFINISHDATE, 'YYYY-MM-DD') AS DW_PLAN_F, ");
											selectDwgDataSQL.append("    TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S, ");
											selectDwgDataSQL.append("    TO_CHAR(DW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS DW_ACT_F, ");
											selectDwgDataSQL.append("    TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S, ");
											selectDwgDataSQL.append("    TO_CHAR(OW.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F, ");
											selectDwgDataSQL.append("    TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S, ");
											selectDwgDataSQL.append("    TO_CHAR(OW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F, ");
											selectDwgDataSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S, ");
											selectDwgDataSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F, ");
											selectDwgDataSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S, ");
											selectDwgDataSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F ");
											selectDwgDataSQL.append("  FROM PLM_ACTIVITY DW, ");
											selectDwgDataSQL.append("    DCC_DWGDEPTCODE DEPT, ");
											selectDwgDataSQL.append("    (SELECT A.PROJECTNO, A.ACTIVITYCODE, A.PLANSTARTDATE, A.PLANFINISHDATE, ");
											selectDwgDataSQL.append("            A.ACTUALSTARTDATE, A.ACTUALFINISHDATE, A.DWGCATEGORY ");
											selectDwgDataSQL.append("       FROM PLM_ACTIVITY A ");
											selectDwgDataSQL.append("      WHERE A.WORKTYPE = 'OW' ");
											selectDwgDataSQL.append("    ) OW, ");
											selectDwgDataSQL.append("    (SELECT B.PROJECTNO, B.ACTIVITYCODE, B.PLANSTARTDATE, B.PLANFINISHDATE, ");
											selectDwgDataSQL.append("            B.ACTUALSTARTDATE, B.ACTUALFINISHDATE, B.DWGCATEGORY ");
											selectDwgDataSQL.append("       FROM PLM_ACTIVITY B ");
											selectDwgDataSQL.append("      WHERE B.WORKTYPE = 'CL' ");
											selectDwgDataSQL.append("    ) CL, ");
											selectDwgDataSQL.append("    (SELECT C.PROJECTNO, C.ACTIVITYCODE, C.PLANSTARTDATE, C.PLANFINISHDATE, ");
											selectDwgDataSQL.append("            C.ACTUALSTARTDATE, C.ACTUALFINISHDATE, C.DWGCATEGORY ");
											selectDwgDataSQL.append("       FROM PLM_ACTIVITY C ");
											selectDwgDataSQL.append("      WHERE C.WORKTYPE = 'RF' ");
											selectDwgDataSQL.append("    ) RF, ");
											selectDwgDataSQL.append("    (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.PLANFINISHDATE, ");
											selectDwgDataSQL.append("            D.ACTUALSTARTDATE, D.ACTUALFINISHDATE, D.DWGCATEGORY, D.REFEVENT2 ");
											selectDwgDataSQL.append("       FROM PLM_ACTIVITY D ");
											selectDwgDataSQL.append("      WHERE D.WORKTYPE = 'WK' ");
											selectDwgDataSQL.append("    ) WK, ");
											selectDwgDataSQL.append("    ( ");
											selectDwgDataSQL.append("    SELECT PROJECT_NO, DWG_CODE, MAX(REQUEST_DATE) AS DEPLOY_DATE ");
											selectDwgDataSQL.append("      FROM PLM_HARDCOPY_DWG ");
											selectDwgDataSQL.append("     GROUP BY PROJECT_NO, DWG_CODE ");
											selectDwgDataSQL.append("    ) HC, ");
											selectDwgDataSQL.append("    (SELECT STATE FROM PLM_SEARCHABLE_PROJECT ");
											selectDwgDataSQL.append("      WHERE CATEGORY = 'PROGRESS' AND PROJECTNO = '"+objectProject+"' ");
											selectDwgDataSQL.append("    ) PP ");
											selectDwgDataSQL.append(" WHERE DW.PROJECTNO = '"+objectProject+"' ");
											selectDwgDataSQL.append("   AND DW.PROJECTNO = OW.PROJECTNO(+) ");
											selectDwgDataSQL.append("   AND DW.PROJECTNO = CL.PROJECTNO(+) ");
											selectDwgDataSQL.append("   AND DW.PROJECTNO = RF.PROJECTNO(+) ");
											selectDwgDataSQL.append("   AND DW.PROJECTNO = WK.PROJECTNO(+) ");
											selectDwgDataSQL.append("   AND DW.DWGDEPTCODE = DEPT.DWGDEPTCODE(+) ");
											selectDwgDataSQL.append("   AND DW.WORKTYPE = 'DW' ");
											selectDwgDataSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(OW.ACTIVITYCODE(+), 1, 8) ");
											selectDwgDataSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(CL.ACTIVITYCODE(+), 1, 8) ");
											selectDwgDataSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(RF.ACTIVITYCODE(+), 1, 8) ");
											selectDwgDataSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8) ");
											selectDwgDataSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) like '"+objectNo+"' ");
											selectDwgDataSQL.append("   AND (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE DW.DWGCATEGORY END) = ");
											selectDwgDataSQL.append("       (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE PP.STATE END) ");
											selectDwgDataSQL.append("   AND DW.PROJECTNO = HC.PROJECT_NO(+) ");
											selectDwgDataSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = HC.DWG_CODE(+) ");
											
											java.sql.ResultSet selectDwgDataRset = dwgStmt.executeQuery(selectDwgDataSQL.toString());
	
											while(selectDwgDataRset.next()){
											
												String dwgProjectNo			= selectDwgDataRset.getString(1)==null?"":selectDwgDataRset.getString(1);
												String drawingNo			= selectDwgDataRset.getString(2)==null?"":selectDwgDataRset.getString(2);
												String drawingTitle			= selectDwgDataRset.getString(3)==null?"":selectDwgDataRset.getString(3);
												String drawingRev			= selectDwgDataRset.getString(4)==null?"":selectDwgDataRset.getString(4);
												String drawingPlanStart 	= selectDwgDataRset.getString(5)==null?"":selectDwgDataRset.getString(5);
												String drawingPlanFinish	= selectDwgDataRset.getString(6)==null?"":selectDwgDataRset.getString(6);
												String drawingActStart		= selectDwgDataRset.getString(7)==null?"":selectDwgDataRset.getString(7);
												String drawingActFinish		= selectDwgDataRset.getString(8)==null?"":selectDwgDataRset.getString(8);
												
												String planStart = "";
												String planFinish = "";
												String actStart = "";
												String actFinish = "";
												if("owner".equals(ownerClassType)){
													planStart		= selectDwgDataRset.getString(9)==null?"":selectDwgDataRset.getString(9);
													planFinish		= selectDwgDataRset.getString(10)==null?"":selectDwgDataRset.getString(10);
													actStart		= selectDwgDataRset.getString(11)==null?"":selectDwgDataRset.getString(11);
													actFinish		= selectDwgDataRset.getString(12)==null?"":selectDwgDataRset.getString(12);
												}else if("class".equals(ownerClassType)){
													planStart		= selectDwgDataRset.getString(13)==null?"":selectDwgDataRset.getString(13);
													planFinish		= selectDwgDataRset.getString(14)==null?"":selectDwgDataRset.getString(14);
													actStart		= selectDwgDataRset.getString(15)==null?"":selectDwgDataRset.getString(15);
													actFinish		= selectDwgDataRset.getString(16)==null?"":selectDwgDataRset.getString(16);
												}
												// 2014-04-04 Kang seonjung : Vendor Drawing(도면번호 첫자리가 V인도면) 일 경우 CL 관련일자 VIEW
												if(drawingNo.startsWith("V"))
												{
													planStart		= selectDwgDataRset.getString(13)==null?"":selectDwgDataRset.getString(13);
													planFinish		= selectDwgDataRset.getString(14)==null?"":selectDwgDataRset.getString(14);
													actStart		= selectDwgDataRset.getString(15)==null?"":selectDwgDataRset.getString(15);
													actFinish		= selectDwgDataRset.getString(16)==null?"":selectDwgDataRset.getString(16);
												}
												
												%>
												<tr>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=5 value="<%=dwgProjectNo%>">
								                   	</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=10 value="<%=drawingNo%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=50 value="<%=drawingTitle%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=2 value="<%=drawingRev%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														&nbsp;&nbsp;P&nbsp;&nbsp;<br><br>
														&nbsp;&nbsp;A&nbsp;&nbsp;
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=10 value="<%=drawingPlanStart%>"><br>
														<input style="border:0" type="text" size=10 value="<%=drawingActStart%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=10 value="<%=drawingPlanFinish%>"><br>
														<input style="border:0" type="text" size=10 value="<%=drawingActFinish%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=10 value="<%=planStart%>"><br>
														<input style="border:0" type="text" size=10 value="<%=actStart%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input style="border:0" type="text" size=10 value="<%=planFinish%>"><br>
														<input style="border:0" type="text" size=10 value="<%=actFinish%>">
													</td>
													<%if((userName!=null && userName.equals(sender)) ){ %>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input type="button" class="btn_gray2" value="삭제" onclick="delRefObj('<%=refNo%>','<%=revNo%>','<%=objectNo%>','<%=sendReceiveType%>','<%=ownerClassType%>','<%=dwgProjectNo%>','drawing')">
														</td>
													<%}else{ %>
														<td style="border: #000000 1px solid; color:#0000ff">
															<a onclick="alert('담당자만 삭제 가능합니다.');">X</a>
														</td>
													<%} %>
												</tr>
											<%
											}
											dwgCount++;
										}
										if(dwgCount == 0) {
										%>
											<tr>
												<td colspan="10">
													관련 도면 없음
												</td>
											</tr>
												
										<%}%>
									</table>
									<!-- 관련도면 끝 -->
									<!-- 관련문서 시작 -->
									<div class="sc_tit2" style="margin-top:5px">관련문서</div>
										<table id="refDwgTable1" class="insertArea">
											<%
											cstmt.setString(1, projectNo);
											if("send".equals(sendReceiveType))
												cstmt.setString(2, refNo);
											else if("receive".equals(sendReceiveType))
												cstmt.setString(2, revNo);
											cstmt.setString(3, "document");
											
											java.sql.ResultSet rset2 = cstmt.executeQuery();
											
											while(rset2.next()){
												String objectProject	= rset2.getString(1)==null?"":rset2.getString(1);
												String objectNo 		= rset2.getString(2)==null?"":rset2.getString(2);
												String objectComment 	= rset2.getString(3)==null?"":rset2.getString(3);
												
												if(docCount==0){
													%>
													<tr>
														<th>참조되는 공문번호</th>
														<th>비고</th>
														<th>제목</th>
														<th>일자</th>
														<th>발송(수신)부서</th>
														<th>참조부서</th>
														<th>발신자</th>
														<th>View</th>
														<th>Delete</th>
													</tr>
													<%
												}
												//objectProject , objectNo
												
												java.sql.Statement docStmt = conn.createStatement();
												
												StringBuffer selectDocDataSQL = new StringBuffer();
												selectDocDataSQL.append("select sodl.subject  ");
												selectDocDataSQL.append("     , sodl.send_receive_date  ");
												selectDocDataSQL.append("     , sodl.send_receive_dept  ");
												selectDocDataSQL.append("     , sodl.ref_dept  ");
												selectDocDataSQL.append("     , sodl.sender ");
												selectDocDataSQL.append("  from stx_oc_document_list sodl ");
												selectDocDataSQL.append(" where sodl.ref_no = '"+objectNo+"' ");
												
												java.sql.ResultSet selectDocDataRset = docStmt.executeQuery(selectDocDataSQL.toString());
												
												while(selectDocDataRset.next()){
												
													String docSubject			= selectDocDataRset.getString(1)==null?"":selectDocDataRset.getString(1);
													String docSendReceiveDate	= selectDocDataRset.getString(2)==null?"":selectDocDataRset.getString(2);
													String docSendReceiveDept	= selectDocDataRset.getString(3)==null?"":selectDocDataRset.getString(3);
													String docRefDept			= selectDocDataRset.getString(4)==null?"":selectDocDataRset.getString(4);
													String docSender		 	= selectDocDataRset.getString(5)==null?"":selectDocDataRset.getString(5);
													%>
													<tr>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0;color:blue" type="text" size=20 value="<%=objectNo%>" onclick="viewRefNo(this)" >
							                               </td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0" type="text" size=25 value="<%=objectComment%>">
														</td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0" type="text" size=30 value="<%=docSubject%>">
														</td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0" type="text" size=10 value="<%=docSendReceiveDate%>">
														</td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0" type="text" size=10 value="<%=docSendReceiveDept%>">
														</td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0" type="text" size=10 value="<%=docRefDept%>">
														</td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input style="border:0" type="text" size=6 value="<%=docSender%>">
														</td>
														<td style="border: #000000 1px solid; color:#0000ff">
															<input type="button" class="btn_gray2" value="보기" onclick="viewRefDoc('<%=objectNo%>')">
														</td>
														<%if((userName!=null && userName.equals(sender))){ %>
															<td style="border: #000000 1px solid; color:#0000ff">
																<input type="button" class="btn_gray2" size=4 value="삭제 " onclick="delRefObj('<%=refNo%>','<%=revNo%>','<%=objectNo%>','<%=sendReceiveType%>')">
															</td>
														<%}else{ %>
															<td style="border: #000000 1px solid; color:#0000ff">
																<input type="text" size=4 value="X" onclick="alert('담당자만 삭제 가능합니다.');">
															</td>
														<%} %>
													</tr>
												<%
												}
												docCount++;
											}
											if(docCount == 0) {
												%>
												<tr>
													<td colspan="10">
														관련 문서 없음
													</td>
												</tr>
													
											<%}%>
										</table>
										<div id="refObjectAddDIV<%=count%>" style="display:none;z-index:1000;">
											<div class="sc_tit2" style="margin-top:5px">등록</div>
											<table class="insertArea">
												<tr>
													<th>
														Key Word 등록
													</th>
													<td width="395" style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="width:395px;background-color:#D8D8D8;" name="docKeyWord<%=count%>" value="<%=keyword%>" />
													</td>
													<td width="50" style="border: #000000 1px solid; color:#0000ff">
														<input type="button" class="btn_gray2" value="SAVE" onclick="saveKeyword('<%=refNo%>' , '<%=revNo%>' , '<%=sendReceiveType %>' , '<%=count%>')"/>
													</td>
												</tr>
												<tr>
													<th>
														Subject
													</th>
													<td width="395" style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="width:395px;background-color:#D8D8D8;" name="docSubject<%=count%>" value="<%=subject%>" />
													</td>
													<td width="50" style="border: #000000 1px solid; color:#0000ff">
														<input type="button" class="btn_gray2" value="SAVE" onclick="saveSubject('<%=refNo%>' , '<%=revNo%>' , '<%=sendReceiveType %>' , '<%=count%>')"/>
													</td>
												</tr>
												<tr>
													<th>
														관련공문서 등록
													</th>
													<td style="text-align: left">
														<input style="width:96px;" value="PROJECT" name="refDocProject<%=count%>" onfocus="this.value=''"/>
														<input style="width:128px;" value="DOC NO" name="refDocNo<%=count%>" onfocus="this.value=''"/>
														<input style="width:252px;" value="COMMENT" name="refDocComment<%=count%>" onfocus="this.value=''"/>
													</td>
													<td>
														<input type="button" class="btn_gray2" value="SAVE" onclick="refDocSave('<%=refNo%>' , '<%=revNo%>' , '<%=sendReceiveType%>' , '<%=count%>')"/>
													</td>
												</tr>
												<tr>
													<th>
														관련도면 등록
													</th>
													<td style="text-align: left">
														<input style="width:96px;" value="PROJECT" name="refDwgProject<%=count %>" onfocus="this.value=''"/>
														<input style="width:128px;" value="DWG NO" name="refDwgNo<%=count %>" onfocus="this.value=''"/>
													</td>
													<td>
														<input type="button" class="btn_gray2" value="SAVE" onclick="refDwgSave('<%=refNo%>' , '<%=revNo%>' , '<%=sendReceiveType%>' , '<%=count%>')"/>
													</td>
												</tr>
												
											</table>
										</div>
									</div>
									<!-- 관련문서 끝 -->
								</td>
							</tr>
							<%
							count++;
						}
						%>
					</table>
				</div>
			</div>		
	<!-- 하단 검색결과 끝 -->
	<!-- 상세검색 페이지 시작 -->
	<!-- <div id="detailSearchDIV" style="position:absolute;display:none;width:1100px;height:150px;z-index:1000;background-color:#D8D8D8;border-style:solid;border-width:1px; border-color:#000000;">
		<table>
			<tr>
				<td>
					문서검색
				</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>
								호선
							</td>
							<td width="96" style="border: #000000 1px solid; color:#0000ff">
								<input style="width:96px;background-color:#D8D8D8;" name="detailProject">
							</td>
							<td width="64" align="right">
								검색단어
							</td>
							<td width="256" style="border: #000000 1px solid; color:#0000ff">
								<input style="width:256px;background-color:#D8D8D8;" name="detailSubject" value="(검색단어 띄어쓰기로 구분)" onclick="this.value=''">
							</td>
							<td width="64">
								
							</td>
							<td width="64" align="right">
								제외단어
							</td>
							<td width="256" style="border: #000000 1px solid; color:#0000ff">
								<input style="width:256px;background-color:#D8D8D8;" name="excludeDetailSubject">
							</td>
							<td width="64">
								
							</td>
							<td width="64">
								
							</td>
							<td width="75" style="border: #000000 1px solid; color:#0000ff" align="right">
								<input type="button" style="width:75px;background-color:#D8D8D8;" value="검색" onclick="searchDetailList()"/>
							</td>
						</tr>
						<tr>
							<td>
								
							</td>
							<td width="96">
								
							</td>
							<td width="64">
								
							</td>
							<td>
								<input type="radio" name="detailAndOr" value="and" checked="checked">모든 단어포함
								<input type="radio" name="detailAndOr" value="or">1개 이상포함
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>
								검색조건 : 
							</td>
							<td>
								<input type="checkbox" name="detailSendReceiveAll" onclick="detailAllCheck(this)" checked="checked">전체
							</td>
							<td>
								<input type="checkbox" name="detailReceive" checked="checked">수신
							</td>
							<td>
								<input type="checkbox" name="detailSend" checked="checked">발신
							</td>
							<td>
								<input type="checkbox" name="detailMasterProject" checked="checked">대표호선
							</td>
							<td>
								<input type="checkbox" name="detailOwner" checked="checked">선주
							</td>
							<td>
								<input type="checkbox" name="detailClass" checked="checked">선급
							</td>
							<td>
								<input type="checkbox" name="detailSubjectType" checked="checked">제목
							</td>
							<td>
								<input type="checkbox" name="detailKeyWord" checked="checked">키워드
							</td>
							<td>
								<input type="checkbox" name="detailDwgNo" checked="checked">도면
							</td>
							<td>
								<input type="checkbox" name="detailComment" checked="checked">비고
							</td>
							<td>
								<input type="checkbox" name="detailOriginator" checked="checked">작성자
							</td>
							<td>
								<input type="checkbox" name="detailReceiveDept" checked="checked">수신부서
							</td>
							<td>
								<input type="checkbox" name="detailSendDept" checked="checked">발신부서
							</td>
						</tr>
						<tr>
							<td>
								검색기간 : 
							</td>
							<td>
								<input type="radio" name="detailDate" value="all" checked="checked">전체
							</td>
							<td>
								<input type="radio" name="detailDate" value="week">1주일
							</td>
							<td>
								<input type="radio" name="detailDate" value="month">1개월
							</td>
							<td>
								<input type="radio" name="detailDate" value="3month">3개월
							</td>
							<td>
								<input type="radio" name="detailDate" value="6month">6개월
							</td>
							<td>
								<input type="radio" name="detailDate" value="keyIn">직접입력
							</td>
							<td width="80" style="border: #000000 1px solid; color:#0000ff">
								<input style="width:80px;background-color:#D8D8D8;" name="detailFromDate">
							</td>
							<td align="center">
								~
							</td>
							<td width="80" style="border: #000000 1px solid; color:#0000ff">
								<input style="width:80px;background-color:#D8D8D8;" name="detailToDate">
							</td>
							<td>
								
							</td>
							<td>
								
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div> -->
	<!-- 상세검색 페이지 끝 -->
	</div>
</form>
</body>
</html>
