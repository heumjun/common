<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적추가등록
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignProcessAddition.jsp
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
	private List<Map<String,Object>> getReceiveInfo(String seq_no) throws Exception
	{
		if (StringUtil.isNullString(seq_no)) throw new Exception("Seq No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        List<Map<String,Object>> resultArrayList = new ArrayList<Map<String,Object>>();

        try {
			conn = DBConnect.getDBConnection("SDPS");
            StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT SEQ_NO,                             \n"); 
            queryStr.append("       PROJECT,                            \n"); 
            queryStr.append("       REV_NO,                             \n");
            queryStr.append("       SUBJECT,                            \n"); 
			queryStr.append("       SEND_REF_NO,                        \n"); 
			queryStr.append("       COMMENT_COUNT,                      \n"); 
			queryStr.append("       REPLY_COUNT,                        \n"); 
			queryStr.append("       SHORT_NOTICE_COUNT,                 \n"); 
			queryStr.append("       STATUS                              \n"); 
            queryStr.append("  FROM STX_OC_RECEIVE_DOCUMENT             \n");
            queryStr.append("  WHERE 1=1                                \n");
            queryStr.append("    AND SEQ_NO = '" + seq_no + "'          \n");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
				Map<String,Object> resultMap = new java.util.HashMap<String,Object>();
				resultMap.put("SEQ_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("PROJECT", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("REV_NO", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("SUBJECT", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("SEND_REF_NO", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("COMMENT_COUNT", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("REPLY_COUNT", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("SHORT_NOTICE_COUNT", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("STATUS", rset.getString(9) == null ? "" : rset.getString(9));
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
String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("userName")),"UTF-8");
String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("teamName")),"UTF-8");

List<Map<String,Object>> getReceiveInfoList = getReceiveInfo(sSelect_seq_no);

String project = "";
String rev_no = "";
String subject = "";
String send_ref_no = "";
String comment_count = "";
String reply_count = "";
String short_notice_count = "";
String status = "";

for(int i=0; i<getReceiveInfoList.size(); i++)
{
	Map tempResultMap = (Map)getReceiveInfoList.get(i);
	project = (String)tempResultMap.get("PROJECT");
	rev_no = (String)tempResultMap.get("REV_NO");
	subject = (String)tempResultMap.get("SUBJECT");
	send_ref_no = (String)tempResultMap.get("SEND_REF_NO");
	comment_count = (String)tempResultMap.get("COMMENT_COUNT");
	reply_count = (String)tempResultMap.get("REPLY_COUNT");
	short_notice_count = (String)tempResultMap.get("SHORT_NOTICE_COUNT");
	status = (String)tempResultMap.get("STATUS");
}

%>



<%--========================== HTML HEAD ===================================--%>
<html>
<!-- <link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css> -->
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<head>
<title>실적 추가 등록</title>
</head>
<%--========================== HTML BODY ===================================--%>
<body>

<form name="designProcessForm" method="post">

<input type="hidden" name="select_seq_no" value="<%=sSelect_seq_no%>">
<input type="hidden" name="select_rev_no" value="<%=sSelect_rev_no%>">
<input type="hidden" name="workUser" value="<%=sWorkUser%>">
<input type="hidden" name="userName" value="<%=sUserName%>">
<input type="hidden" name="teamName" value="<%=sTeamName%>">
<input type="hidden" name="project" value="<%=project%>">
<input type="hidden" name="processRunning" value="FALSE">
<div class="subtitle">
	실적 추가 등록 <span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
</div>
<table class="searchArea conSearch">
   <tr height="30">
	   <td>
			<div class="button endbox">
				<input type="button" value='등 록' class="btn_blue2" onclick="designProcessAction();">&nbsp;&nbsp;
				<input type="button" value="닫 기" class="btn_blue2" onclick="javascript:window.close();">
			</div>
	   </td>
   </tr>
</table>
<table class="insertArea">
	<tr height="25">
		<th width="20%">처리부서</th>
		<th width="20%">담당자</th>
		<th width="20%">접수NO.</th>
		<th width="40%">제목</th>
	</tr>
	<tr height="25">
		<td><%=sTeamName%></td>
		<td><%=sUserName%></td>
		<td><%=rev_no%></td>
		<td><%=subject%></td>
	</tr>
</table>
<table class="insertArea">
	<tr height="25">
		<th width="40%">호선</th>
		<th width="60%">Ref.No</th>
	</tr>
	<tr height="25">
		<td><%=project%></td>
		<td>
			<input type="text" name="send_ref_no" value="" style="text-align:center;width:170px;background-color:#FFFF99;font-size:10pt;font-weight:bold;">
			<input type="button" value='찾기' class="btn_gray2" onclick="searchRefNo();">
		</td>
	</tr>
</table>
<table class="insertArea">
	<tr height="25">
		<th width="33%">Comments</th>
		<th width="33%">Reply</th>
		<th width="34%">Short Notice</th>
	</tr>
	<tr height="25">
		<td><input style="text-align:center;width:85px;background-color:#FFFF99;	font-size: 11pt;font-weight: bold;" name="comment_count" value="" onblur="checkNumber(this);"></td>
		<td><input style="text-align:center;width:85px;background-color:#FFFF99; font-size: 11pt;font-weight: bold;" name="reply_count" value="" onblur="checkNumber(this);"></td>
		<td><input style="text-align:center;width:85px;background-color:#FFFF99; font-size: 11pt;font-weight: bold;" name="short_notice_count" value="" onblur="checkNumber(this);"></td>
	</tr>
</table>


<table class="insertArea">
	<tr height="25">
		<th width="100%">발신문서 첨부</th>
	</tr>
	<tr height="25">
		<td>
			<input type="file" name="fileName" style="width:380;background-color:#FFFF99;" onKeyDown="return false">
			<input type="button" value="CLEAR" class="btn_gray2" onclick="javascript:clearFileName(this.form);">	
		</td>
	</tr>
</table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="JavaScript">

	function searchRefNo()
	{
		var workUser = document.designProcessForm.workUser.value; 
		var project = document.designProcessForm.project.value; 		

		var url = "buyerClassCommentPersonSearchRefNo.do?workUser="+workUser+"&project="+project;

		var nwidth = 700;
		var nheight = 500;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);

	}

	// 숫자만 사용 가능.
	function checkNumber(obj)
	{
		var attVal = obj.value;
		var chars = "0123456789";
		for (var index = 0; index < attVal.length; index++) {
		   if (chars.indexOf(attVal.charAt(index)) == -1) {
			   alert("only Number is possible");
			   obj.focus();
			   break;
		   }
		}
	}

	function clearFileName(form)
	{
		form.fileName.select();
		document.selection.clear();
	}	

	function designProcessAction()
	{
		var mainForm = document.designProcessForm;
		
        var isDone = mainForm.processRunning.value;
        if (isDone == "TRUE")
        {
            alert("진행중입니다.");
            return;
        }

        if (mainForm.send_ref_no.value == "") {
            alert("Ref No.를 입력하십시오.");
            return;
        }
        if (mainForm.comment_count.value == "") {
            alert("Comments를 입력하십시오.");
            return;
        }
        if (mainForm.reply_count.value == "") {
            alert("Reply.를 입력하십시오.");
            return;
        }
        if (mainForm.short_notice_count.value == "") {
            alert("Short Notice를 입력하십시오.");
            return;
        }
 
		var restrictedChars = "\"&";
		
		var fileName = mainForm.fileName.value;
		if(fileName == "" || fileName==null)
		{
			alert("첨부문서가 없습니다.");
			return;
		}

		for(var index=0; index < fileName.length; index++)
		{
			if(restrictedChars.indexOf(fileName.charAt(index)) != -1)
			{
				alert("첨부 파일명에 &(Shift+7) 과 \" 를 사용할 수 없습니다.");
				return;
			}
		}

        if(confirm("실적 등록을 진행하시겠습니까?"))
        {
            mainForm.encoding = "multipart/form-data";
            mainForm.action = "buyerClassCommentProcessAdditionAction.do";
            mainForm.processRunning.value = "TRUE";
            mainForm.submit();    
        }
	}

</script>