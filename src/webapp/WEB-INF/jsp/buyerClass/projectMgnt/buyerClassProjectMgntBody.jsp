<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "java.util.StringTokenizer" %>
<%@ page import ="com.stx.common.interfaces.DBConnect"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<%--========================== JSP =========================================--%>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<%--========================== SCRIPT ======================================--%>
<script language="JavaScript">
	function clearList()
	{
		$("input[name='drawingType']").val("");
		$("input[name='refType']").val("");
		$("input[name='workRank']").val("");
		$("input[name='mailList']").val("");
		$("input[name='position']").val("");
		$("input[name='companyName']").val("");
		$("input[name='address']").val("");
		$("input[name='faxNum']").val("");
		$("input[name='eMailAddr']").val("");
		$("input[name='phoneNum']").val("");
		$("input[name='mailListFlag']").val("");
		$("input[name='companyNameFlag']").val("");
		$("input[name='addressFlag']").val("");
		$("input[name='faxNumFlag']").val("");
		$("input[name='department']").val("");
		$("input[name='refBasis']").val("");
	}
	
	function saveList()
	{
		
		var project			= $("input[name='project']").val();
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= $("input[name='drawingType']").val();
		var refType 		= $("input[name='refType']").val();
		var workRank 		= $("input[name='workRank']").val();
		var mailList 		= $("input[name='mailList']").val();		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		if(mailList == ""){
			alert("수신자를 입력해 주십시오.");
			return;
		}
		
		var position 		= $("input[name='position']").val();
		var companyName 	= $("input[name='companyName']").val();
		var address 		= $("input[name='address']").val();
		var faxNum 			= $("input[name='faxNum']").val();
		var eMailAddr 		= $("input[name='eMailAddr']").val();
		var phoneNum 		= $("input[name='phoneNum']").val();
		var mailListFlag 	= $("input[name='mailListFlag']").val();
		var companyNameFlag = $("input[name='companyNameFlag']").val();
		var addressFlag 	= $("input[name='addressFlag']").val();
		var faxNumFlag 		= $("input[name='faxNumFlag']").val();
		var department 		= $("input[name='department']").val();
		var refBasis 		= $("input[name='refBasis']").val();
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "save");
		
	}
	$.fn.center = function () {
	    this.css("position","absolute");
	    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
	    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
	    return this;
	}
	function addClose() {
		$.unblockUI();
	}
	function addSave()
	{
		var project			= $("input[name='project']").val();
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= $("input[name='drawingType']").val();
		var refType 		= $("input[name='refType']").val();
		var workRank 		= $("input[name='workRank']").val();
		var mailList 		= $("input[name='mailList']").val();
		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		if(mailList == ""){
			alert("수신자를 입력해 주십시오.");
			return;
		}
		
		var position 		= $("input[name='position']").val();
		var companyName 	= $("input[name='companyName']").val();
		var address 		= $("input[name='address']").val();
		var faxNum 			= $("input[name='faxNum']").val();
		var eMailAddr 		= $("input[name='eMailAddr']").val();
		var phoneNum 		= $("input[name='phoneNum']").val();
		var mailListFlag 	= $("input[name='mailListFlag']").val();
		var companyNameFlag = $("input[name='companyNameFlag']").val();
		var addressFlag 	= $("input[name='addressFlag']").val();
		var faxNumFlag 		= $("input[name='faxNumFlag']").val();
		var department 		= $("input[name='department']").val();
		var refBasis 		= $("input[name='refBasis']").val();
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "add");
	}
	function addList()
	{
		$.blockUI({message : $('#addDiv')
	  		,css : {width  : '1100px'
		  	,cursor:'pointer'}
		});
		$('.blockUI.blockMsg').center();
		/* var project			= document.projectReceiveListForm.project.value;
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= document.projectReceiveListForm.drawingType.value;
		var refType 		= document.projectReceiveListForm.refType.value;
		var workRank 		= document.projectReceiveListForm.workRank.value;
		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		
		var mailList 		= document.projectReceiveListForm.mailList.value;
		var position 		= document.projectReceiveListForm.position.value;
		var companyName 	= document.projectReceiveListForm.companyName.value;
		var address 		= document.projectReceiveListForm.address.value;
		var faxNum 			= document.projectReceiveListForm.faxNum.value;
		var eMailAddr 		= document.projectReceiveListForm.eMailAddr.value;
		var phoneNum 		= document.projectReceiveListForm.phoneNum.value;
		var mailListFlag 	= document.projectReceiveListForm.mailListFlag.value;
		var companyNameFlag = document.projectReceiveListForm.companyNameFlag.value;
		var addressFlag 	= document.projectReceiveListForm.addressFlag.value;
		var faxNumFlag 		= document.projectReceiveListForm.faxNumFlag.value;
		var department 		= document.projectReceiveListForm.department.value;
		var refBasis 		= document.projectReceiveListForm.refBasis.value;
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "add"); */
	}
	
	function delList()
	{
		var project			= $("input[name='project']").val();
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= $("input[name='drawingType']").val();
		var refType 		= $("input[name='refType']").val();
		var workRank 		= $("input[name='workRank']").val();
		var mailList 		= $("input[name='mailList']").val();
		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		if(mailList == ""){
			alert("수신자를 입력해 주십시오.");
			return;
		}
		
		var position 		= $("input[name='position']").val();
		var companyName 	= $("input[name='companyName']").val();
		var address 		= $("input[name='address']").val();
		var faxNum 			= $("input[name='faxNum']").val();
		var eMailAddr 		= $("input[name='eMailAddr']").val();
		var phoneNum 		= $("input[name='phoneNum']").val();
		var mailListFlag 	= $("input[name='mailListFlag']").val();
		var companyNameFlag = $("input[name='companyNameFlag']").val();
		var addressFlag 	= $("input[name='addressFlag']").val();
		var faxNumFlag 		= $("input[name='faxNumFlag']").val();
		var department 		= $("input[name='department']").val();
		var refBasis 		= $("input[name='refBasis']").val();
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "del");
	}
	
	var xmlHttp;
    function dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , processType) {
		/* if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp = new XMLHttpRequest();     
        } */
        var url = "buyerClassProjectMgntProcess.do"
                + "?project="+project;
                
        var parameters = {
        		drawingType : drawingType,
                refType : refType,
                workRank : workRank,
                mailList : mailList,
                position : position,
                companyName : companyName,
                address : address,
                faxNum : faxNum,
                eMailAddr : eMailAddr,
                phoneNum : phoneNum,
                mailListFlag : mailListFlag,
                companyNameFlag : companyNameFlag,
                addressFlag : addressFlag,
                faxNumFlag : faxNumFlag,
                department : department,
                refBasis : refBasis,
                processType : processType,
    		};
        
        $.post( url, parameters, function( data ) {
        	alert(data.resultMsg);
        	document.projectReceiveListForm.action = "buyerClassProjectMgntBody.do?selectProject="+project;
        	document.projectReceiveListForm.submit();
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        
        /* xmlHttp.open("GET", url, false);
        xmlHttp.onreadystatechange = callback;
        xmlHttp.send(null);
        
        var url2 = "stxPECBuyerClassProjectManagerBody.jsp?selectProject="+project;
        
        //document.projectReceiveListForm.action = fnEncode(url2);
		document.projectReceiveListForm.action = encodeURI(url2);
        document.projectReceiveListForm.submit(); */
    }
    
    function callback() {
    	if (xmlHttp.readyState == 4) {
        	if (xmlHttp.status == 200) {
        		//var result = xmlHttp.responseText;
	            //result = result.replace(/\s/g, ""); // 공백제거
	            //alert(result);
	            //setNames2(result);
	            
            } else{// if (xmlHttp.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
    
    function selectDrawing(count)
    {
    	$("input[name='drawingType']").val(			$("input[name='drawingType"+count+"']").val());
		$("input[name='refType']").val( 			$("input[name='receiveType"+count+"']").val());
		$("input[name='workRank']").val( 			$("input[name='priority"+count+"']").val());
		$("input[name='mailList']").val( 			$("input[name='receiver"+count+"']").val());
		$("input[name='position']").val( 			$("input[name='position"+count+"']").val());
		$("input[name='companyName']").val( 		$("input[name='company"+count+"']").val());
		$("input[name='address']").val( 			$("input[name='address"+count+"']").val());
		$("input[name='faxNum']").val( 				$("input[name='fax"+count+"']").val());
		$("input[name='eMailAddr']").val( 			$("input[name='eMail"+count+"']").val());
		$("input[name='phoneNum']").val( 			$("input[name='phone"+count+"']").val());
		$("input[name='mailListFlag']").val( 		$("input[name='receiverFlag"+count+"']").val());
		$("input[name='companyNameFlag']").val( 	$("input[name='companyFlag"+count+"']").val());
		$("input[name='addressFlag']").val( 		$("input[name='addressFlag"+count+"']").val());
		$("input[name='faxNumFlag']").val( 			$("input[name='faxFlag"+count+"']").val());
		$("input[name='department']").val( 			$("input[name='department"+count+"']").val());
		$("input[name='refBasis']").val( 			$("input[name='basis"+count+"']").val());
		
		$.blockUI({message : $('#addDiv')
	  		,css : {width  : '1000px'
		  	,cursor:'pointer'}
		});
		$('.blockUI.blockMsg').center();
    }
    
    function changeFlag(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "N")
    		obj.value = "Y";
    	else if(objValue == "Y")
    		obj.value = "N";
    }
    
    function changeDwgType(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "비도면")
    		obj.value = "도면";
    	else if(objValue == "도면")
    		obj.value = "비도면";
    }
    
    function changeRefType(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "참조")
    		obj.value = "수신";
    	else if(objValue == "수신")
    		obj.value = "참조";
    }
</script>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<%
String selectProject = request.getParameter("selectProject")==null?"":request.getParameter("selectProject");
//String seriesFlag = request.getParameter("seriesFlag");
//String noSendFlag = request.getParameter("noSendFlag");
%>
<form name="projectReceiveListForm" method="post" action="stxPECBuyerClassProjectManagerBody.jsp">
	<!-- 하단 (수신처관리) 시작 -->
	<table class="searchArea2 conSearch">
		<tr>
			<th width="200px">선주수신목록(<input class="input_noBorder" style="width:40px;background-color:#D8D8D8;" value="<%=selectProject%>" name="project"/>)</th>
			<td>
				<div  id="buttonTable" class="button endbox">
					<input type="button" class="btn_blue" value="추가" onclick="addList()"/>
				</div>
			</td>
		</tr>
	</table>
	<div style="border: #00bb00 1px solid;padding:5px;margin-top:10px;">
		<div id="list_head" style="overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">	
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="3%">
				<col width="9%">
				<col width="8%">
				<col width="3%">
				<col width="8%">
				<col width="3%">
				<col width="8%">
				<col width="3%">
				<col width="8%">
				<col width="8%">
				<col width="8%">
				<col width="8%">
				<col width="8%">
				<tr>
					<th>구분</th>
					<th>수신</th>
					<th>우선순위</th>
					<th>&nbsp;</th>
					<th>수신자</th>
					<th>직책</th>
					<th>&nbsp;</th>
					<th>회사명</th>
					<th>&nbsp;</th>
					<th>주소</th>
					<th>&nbsp;</th>
					<th>팩스</th>
					<th>이메일</th>
					<th>전화</th>
					<th>해당부서</th>
					<th>관련근거</th>
				</tr>
			</table>
		</div>
		<div id="list_body" style="height:100px;overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<col width="5%">
				<col width="5%">
				<col width="5%">
				<col width="3%">
				<col width="9%">
				<col width="8%">
				<col width="3%">
				<col width="8%">
				<col width="3%">
				<col width="8%">
				<col width="3%">
				<col width="8%">
				<col width="8%">
				<col width="8%">
				<col width="8%">
				<col width="8%">
			<%
			if(selectProject!=null && !"null".equals(selectProject)){
				
				java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
				java.sql.Statement stmt = conn.createStatement();
				
				StringBuffer selectDataSQL = new StringBuffer();
				selectDataSQL.append("select * ");
				selectDataSQL.append("  from STX_OC_PROJECT_RECEIVE_LIST ");
				selectDataSQL.append(" where project = '"+selectProject+"' ");
				selectDataSQL.append(" order by PROJECT , DRAWING_TYPE , RECEIVE_TYPE , PRIORITY ");
				
				
				java.sql.ResultSet selectDataRset = stmt.executeQuery(selectDataSQL.toString());
				
				int count = 0 ;
				while(selectDataRset.next()){
					
					String projectNo 		= selectDataRset.getString(1)==null?"":selectDataRset.getString(1);
					String drawingType 		= selectDataRset.getString(2)==null?"":selectDataRset.getString(2);
					String receiveType		= selectDataRset.getString(3)==null?"":selectDataRset.getString(3);
					String priority			= selectDataRset.getString(4)==null?"":selectDataRset.getString(4);
					String receiver			= selectDataRset.getString(5)==null?"":selectDataRset.getString(5);
					String position			= selectDataRset.getString(6)==null?"":selectDataRset.getString(6);
					String company			= selectDataRset.getString(7)==null?"":selectDataRset.getString(7);
					String address			= selectDataRset.getString(8)==null?"":selectDataRset.getString(8);
					String fax				= selectDataRset.getString(9)==null?"":selectDataRset.getString(9);
					String eMail			= selectDataRset.getString(10)==null?"":selectDataRset.getString(10);
					String phone			= selectDataRset.getString(11)==null?"":selectDataRset.getString(11);
					String receiverFlag		= selectDataRset.getString(12)==null?"":selectDataRset.getString(12);
					String companyFlag		= selectDataRset.getString(13)==null?"":selectDataRset.getString(13);
					String addressFlag		= selectDataRset.getString(14)==null?"":selectDataRset.getString(14);
					String faxFlag			= selectDataRset.getString(15)==null?"":selectDataRset.getString(15);
					String department		= selectDataRset.getString(16)==null?"":selectDataRset.getString(16);
					String basis			= selectDataRset.getString(17)==null?"":selectDataRset.getString(17);
					
					if(count==0){
						%>
						
						<%
					}
					
					%>
						<tr>
							<td>
								<input type="text" size=4 value="<%=drawingType%>" name="drawingType<%=count%>" onclick="selectDrawing('<%=count%>')">
		                    </td>
							<td>
								<input type="text" size=4 value="<%=receiveType%>" name="receiveType<%=count%>">
							</td>
							<td>
								<input type="text" size=6 value="<%=priority%>" name="priority<%=count%>">
							</td>											
							<td>
								<input type="text" size=2 value="<%=receiverFlag%>" name="receiverFlag<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=receiver%>" name="receiver<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=position%>" name="position<%=count%>">
							</td>
							<td>
								<input type="text" size=2 value="<%=companyFlag%>" name="companyFlag<%=count%>">
							</td>
							<td>
								<input type="text" size=14 value="<%=company%>" name="company<%=count%>">
							</td>
							<td>
								<input type="text" size=2 value="<%=addressFlag%>" name="addressFlag<%=count%>">
							</td>
							<td>
								<input type="text" size=14 value="<%=address%>" name="address<%=count%>">
							</td>
							<td>
								<input type="text" size=2 value="<%=faxFlag%>" name="faxFlag<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=fax%>" name="fax<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=eMail%>" name="eMail<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=phone%>" name="phone<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=department%>" name="department<%=count%>">
							</td>
							<td>
								<input type="text" size=12 value="<%=basis%>" name="basis<%=count%>">
							</td>
						</tr>
					<%
					count++;
				}
			}
			%>
			</table>
		</div>
	</div>
	<div id="addDiv" style="background:white; display:none; padding:5px; ">
	<div class="ex_upload">선주수신목록 추가</div>
	<table class="searchArea2">
		<tr>
			<td>
				<div  id="buttonTable" class="button endbox">
					<input type="button" class="btn_blue" value="CLEAR" onclick="clearList()"/>
					<input type="button" class="btn_blue" value="추가" onclick="addSave()"/>
					<input type="button" class="btn_blue" value="수정" onclick="saveList()"/>
					<input type="button" class="btn_blue" value="삭제" onclick="delList()"/>
					<input type="button" class="btn_blue" value="닫기" onclick="addClose()"/>
				</div>
			</td>
		</tr>
	</table>
	<table class="insertArea">
		<col width="5%">
		<col width="5%">
		<col width="5%">
		<col width="3%">
		<col width="9%">
		<col width="8%">
		<col width="3%">
		<col width="8%">
		<col width="3%">
		<col width="8%">
		<col width="3%">
		<col width="8%">
		<col width="8%">
		<col width="8%">
		<col width="8%">
		<col width="8%">
		<tr>
			<th>구분</th>
			<th>수신</th>
			<th>우선순위</th>
			<th>&nbsp;</th>
			<th>수신자</th>
			<th>직책</th>
			<th>&nbsp;</th>
			<th>회사명</th>
			<th>&nbsp;</th>
			<th>주소</th>
			<th>&nbsp;</th>
			<th>팩스</th>
			<th>이메일</th>
			<th>전화</th>
			<th>해당부서</th>
			<th>관련근거</th>
		</tr>
		<tr>
			<td>
				<input type="text" size=4 name="drawingType" onclick="changeDwgType(this)">
           	</td>
			<td>
				<input type="text" size=4 name="refType" onclick="changeRefType(this)">
			</td>
			<td>
				<input type="text" size=6 name="workRank">
			</td>
			<td>
				<input type="text" size=2 name="mailListFlag" onclick="changeFlag(this)">
			</td>
			<td>
				<input type="text" size=12 name="mailList">
			</td>
			<td>
				<input type="text" size=12 name="position">
			</td>
			<td>
				<input type="text" size=2 name="companyNameFlag" onclick="changeFlag(this)">
			</td>
			<td>
				<input type="text" size=14 name="companyName">
			</td>
			<td>
				<input type="text" size=2 name="addressFlag" onclick="changeFlag(this)">
			</td>
			<td>
				<input type="text" size=14 name="address">
			</td>
			<td>
				<input type="text" size=2 name="faxNumFlag" onclick="changeFlag(this)">
			</td>
			<td>
				<input type="text" size=12 name="faxNum">
			</td>
			<td>
				<input type="text" size=12 name="eMailAddr">
			</td>
			<td>
				<input type="text" size=12 name="phoneNum">
			</td><td>
				<input type="text" size=12 name="department">
			</td>
			<td>
				<input type="text" size=12 name="refBasis" >
			</td>
		</tr>
	</table>
	</div>
</form>
</html>