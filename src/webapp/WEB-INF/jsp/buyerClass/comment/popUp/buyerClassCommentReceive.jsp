<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 설계접수
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentReceive.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.CallableStatement"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%--========================== JSP =========================================--%>

<%!
	// 하나의 수신문서에 대한 타부서 정보를 얻어옴.
	private ArrayList getRevNoDept(String rev_no, String team_name) throws Exception
	{
		if (StringUtil.isNullString(rev_no)) throw new Exception("Rev No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

        try {
			conn = DBConnect.getDBConnection("SDPS");
            StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT SEND_RECEIVE_DEPT                                     \n"); 
            queryStr.append("  FROM STX_OC_RECEIVE_DOCUMENT                                \n");
            queryStr.append("  WHERE 1=1                                                   \n");
            queryStr.append("    AND REV_NO = '" + rev_no + "'                             \n");
		if(!"".equals(team_name))
			queryStr.append("    AND SEND_RECEIVE_DEPT NOT LIKE '" + team_name + "%'       \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
				java.util.HashMap resultMap = new java.util.HashMap();
				resultMap.put("SEND_RECEIVE_DEPT", rset.getString(1) == null ? "" : rset.getString(1));
				resultArrayList.add(resultMap);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return resultArrayList;
    }
%>

<%

String sSelect_seq_no = StringUtil.setEmptyExt(request.getParameter("select_seq_no"));
String sSelect_rev_no = StringUtil.setEmptyExt(request.getParameter("select_rev_no"));
String sWorkUser = StringUtil.setEmptyExt(request.getParameter("workUser"));
//String sUserName = StringUtil.setEmptyExt(request.getParameter("userName"));
String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("userName")),"UTF-8");
//String sTeamName = StringUtil.setEmptyExt(request.getParameter("teamName"));
String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("teamName")),"UTF-8");

ArrayList getRevNoDeptList = new ArrayList();
getRevNoDeptList = getRevNoDept(sSelect_rev_no, sTeamName);
String revNoDeptList = "";

%>



<%--========================== HTML HEAD ===================================--%>
<html>
<!-- <link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css> -->
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<head>
<title>수신문서 접수</title>
</head>
<%--========================== HTML BODY ===================================--%>
<body>

<form name="designReceiveForm">

<input type="hidden" name="select_seq_no" value="<%=sSelect_seq_no%>">
<input type="hidden" name="select_rev_no" value="<%=sSelect_rev_no%>">
<input type="hidden" name="workUser" value="<%=sWorkUser%>">
<input type="hidden" name="userName" value="<%=sUserName%>">
<input type="hidden" name="teamName" value="<%=sTeamName%>">

<div class="subtitle">
	수신문서 접수
</div>
<table class="searchArea conSearch">
   <tr height="30">
	   <td>
			<div class="button endbox">
				<input type="button" value='접 수' class="btn_blue2" onclick="designReceiveAction();">&nbsp;&nbsp;
				<input type="button" value="닫 기" class="btn_blue2" onclick="javascript:window.close();">
			</div>
	   </td>
   </tr>
</table>
<table class="insertArea">
	<tr height="25">
		<th width="25%">접수부서</th>
		<th width="25%">접수자</th>
		<th width="50%">접수NO.</th>
	</tr>
	<tr height="25">
		<td><%=sTeamName%></td>
		<td><%=sUserName%></td>
		<td><%=sSelect_rev_no%></td>
	</tr>
</table>

<table class="insertArea">
	<tr height="25">
		<th width="50%">조치사항</th>
		<th width="50%">타부서 수신정보</th>
	</tr>
	<tr>
		<td style="text-align: left">
			&nbsp;<input type="radio" name="processFlag" value="1">&nbsp; 설계접수<br>
		 	&nbsp;<input type="radio" name="processFlag" value="2">&nbsp; 처리/회신 불필요<br>
		 	&nbsp;<input type="radio" name="processFlag" value="3">&nbsp; 반송<br>
		 	&nbsp;<input type="radio" name="processFlag" value="4">&nbsp; 타부서 추가 전달
		</td>
		<td style="border-left:none;" >
			<div STYLE="height:130; overflow-y:auto; position:relative;">
					<table class="insertArea">
				<%
					for(int i=0; i<getRevNoDeptList.size(); i++)
					{
						Map tempResultMap = (Map)getRevNoDeptList.get(i);
						String tempRevNoDept = (String)tempResultMap.get("SEND_RECEIVE_DEPT");
						if("".equals(revNoDeptList))
						{
							revNoDeptList += tempRevNoDept;
						}else {
							revNoDeptList += ", "+tempRevNoDept;
						}
				%>
						<tr height="20">
							<td align="center"><%=tempRevNoDept%>
							</td>
						</tr>
				<%	}  %>
					</table>
					<input type="hidden" name="revNoDeptList" value="<%=revNoDeptList%>">
				</div>
		</td>
		
	</tr>
</table>
<table class="insertArea">
	<tr height="25">
		<th width="50%">처리 담당자 <input type="button" value='담당자지정' class="btn_gray2" onclick="searchProcessPerson();"></th>
		<th width="50%">Comment 사항</th>
	</tr>
	<tr>
		<td style="height:100px;">
			<textarea style="height:100%;width:100%" name="processPersonInfo" readonly></textarea>
			<input type="hidden" name="processPerson" value="">
		</td>
		<td style="height:100px;">
			<textarea name="commentMsg"  style="height:100%;width:100%" ></textarea>
		</td>
	</tr>
</table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="JavaScript">

	function searchProcessPerson()
	{
		var workUser = document.designReceiveForm.workUser.value; 

		var url = "buyerClassCommentReceiveSearchProcessPerson.do?workUser="+workUser;

		var nwidth = 700;
		var nheight = 500;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);

	}


	function designReceiveAction()
	{
		var mainForm = document.designReceiveForm;


		var processFlag="";
		var confirmMsg;
		var processPersonCheck = true;
		var commentsCheck = true;

		for(i=0 ; i < mainForm.processFlag.length ; i++){
			if(mainForm.processFlag[i].checked){
				processFlag = mainForm.processFlag[i].value;
			}
		}

		if(processFlag=="")
		{
			alert("조치사항을 선택하십시오.");
			return;
		}

		if(processFlag=="1")
		{
			commentsCheck = false;
			confirmMsg = "설계 접수로 진행하시겠습니까?";
		} else 	if(processFlag=="2")
		{			
			processPersonCheck = false;
			commentsCheck = false;
			confirmMsg = "처리/회신 불필요로 진행하시겠습니까?";
		} else 	if(processFlag=="3")
		{
			processPersonCheck = false;
			confirmMsg = "반송 (기술계획 접수담당자에게 반송통보) 상태로 진행하시겠습니까?";
		} else if(processFlag=="4")
		{
			confirmMsg = "타부서 추가전달 (설계 접수 후 기술계획 접수 담당자에게 Comment 통보) 상태로 진행하시겠습니까?";
		}

        if (processPersonCheck && mainForm.processPerson.value == "") {
            alert("처리 담당자를 선택하십시오.");
            return;
        }

        if (commentsCheck && mainForm.commentMsg.value == "") {
            alert("기술기획 수신문서 접수담당자(강미숙)에게 전달할 Comments 내용을 입력하십시오. ");
            return;
        }

		var restrictedChars = "\"&\'";
		
		var commentMsg = mainForm.commentMsg.value;

		for(var index=0; index < commentMsg.length; index++)
		{
			if(restrictedChars.indexOf(commentMsg.charAt(index)) != -1)
			{
				alert("Comments 내용에 &(Shift+7) 과 \" 과 \' 를 사용할 수 없습니다.");
				return;
			}
		}


		if(confirm(confirmMsg))
		{
			var xmlHttp;
			if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

			// GET 방식 전송
			var select_seq_no = mainForm.select_seq_no.value;
			var select_rev_no = mainForm.select_rev_no.value;
			var workUser = mainForm.workUser.value;
			var userName = mainForm.userName.value;
			var teamName = mainForm.teamName.value;
			var processPerson = mainForm.processPerson.value;
			var revNoDeptList = mainForm.revNoDeptList.value;
			var commentMsg = mainForm.commentMsg.value;


			var url = "buyerClassCommentReceiveAction.do?select_seq_no=" + select_seq_no;
				url += "&select_rev_no="+select_rev_no;
				url += "&workUser="+workUser;
				url += "&userName="+escape(encodeURIComponent(userName));
				url += "&teamName="+escape(encodeURIComponent(teamName));
				url += "&processFlag="+processFlag;
				url += "&processPerson="+processPerson;
				url += "&revNoDeptList="+escape(encodeURIComponent(revNoDeptList));
				url += "&commentMsg="+escape(encodeURIComponent(commentMsg));

				var rs = window.showModalDialog( url, 
						window,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
				if ( rs != null ) {
					
				
			/* xmlHttp.open("GET", url, false);
			xmlHttp.send(null);


			if (xmlHttp.readyState == 4)
			{
				if (xmlHttp.status == 200)
				{
					var resultMsg = xmlHttp.responseText;
	
					resultMsg = resultMsg.replace(/\s/g, "");   

					if (resultMsg != "SUCCESS")
					{
						alert(resultMsg);                
						return;
					}
				}
			} */

			
			// 접수 처리 후 Page Reload
			var parentHeadForm = opener.document.commentHeadForm;
	
			var reloadproject                = parentHeadForm.project.value;
			var reloadownerClass             = parentHeadForm.ownerClass.value;
			var reloadfromDate               = parentHeadForm.fromDate.value;
			var reloadtoDate                 = parentHeadForm.toDate.value;
			var reloadrevNo                  = parentHeadForm.revNo.value;
			var reloadsubject                = parentHeadForm.subject.value;
			var reloadreceiveDept            = parentHeadForm.receiveDept.value;
			var reloadrefDept                = parentHeadForm.refDept.value;
			var reloaddesignReceiveFlag      = parentHeadForm.designReceiveFlag.value;
			var reloaddesignReceiveFromDate  = parentHeadForm.designReceiveFromDate.value;
			var reloaddesignReceiveToDate    = parentHeadForm.designReceiveToDate.value;
			var reloadprocessDept            = parentHeadForm.processDept.value;
			var reloadprocessPerson          = parentHeadForm.processPerson.value;
			var reloaddesignProcessFromDate  = parentHeadForm.designProcessFromDate.value;
			var reloaddesignProcessToDate    = parentHeadForm.designProcessToDate.value;
			var reloadstatus                 = parentHeadForm.status.value;
	
			if(reloadownerClass=="All") reloadownerClass = "";
			if(reloaddesignReceiveFlag=="All") reloaddesignReceiveFlag = "";
			if(reloadstatus=="All") reloadstatus = "";
	
	
	        var urlStr = "buyerClassCommentList.do"
			           + "?project=" + reloadproject
					   + "&ownerClass=" + reloadownerClass
					   + "&fromDate=" + reloadfromDate
					   + "&toDate=" + reloadtoDate
					   + "&revNo=" + reloadrevNo
					   + "&subject=" + reloadsubject
					   + "&receiveDept=" + escape(encodeURIComponent(reloadreceiveDept))
					   + "&refDept=" + escape(encodeURIComponent(reloadrefDept))
					   + "&designReceiveFlag=" + reloaddesignReceiveFlag
					   + "&designReceiveFromDate=" + reloaddesignReceiveFromDate
					   + "&designReceiveToDate=" + reloaddesignReceiveToDate
					   + "&processDept=" + escape(encodeURIComponent(reloadprocessDept))
					   + "&processPerson=" + escape(encodeURIComponent(reloadprocessPerson))
					   + "&designProcessFromDate=" + reloaddesignProcessFromDate
					   + "&designProcessToDate=" + reloaddesignProcessToDate
					   + "&status=" + reloadstatus
					   + "&mode=search";
	
			alert("SUCCESS");
			window.close();
			opener.$("#buyerClassCommentList").attr("src",urlStr);
	        //opener.parent.COMMENT_RESULT_MANAGEMENT_BODY.location = urlStr;
	
			}
		}
	}
</script>