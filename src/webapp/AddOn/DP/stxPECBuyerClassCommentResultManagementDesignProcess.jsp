<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적등록
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignProcess.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.CallableStatement"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%!
	private ArrayList getReceiveInfo(String seq_no) throws Exception
	{
		if (StringUtil.isNullString(seq_no)) throw new Exception("Seq No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

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
				java.util.HashMap resultMap = new java.util.HashMap();
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
String sSelect_seq_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_seq_no"));
String sSelect_rev_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_rev_no"));
String sWorkUser = StringUtil.setEmptyExt(emxGetParameter(request, "workUser"));
String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "userName")),"UTF-8");
String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "teamName")),"UTF-8");

/***
System.out.println("####### stxPECBuyerClassCommentResultManagementDesignProcess.jsp");
System.out.println("##  sSelect_seq_no  =  "+sSelect_seq_no);
System.out.println("##  sSelect_rev_no  =  "+sSelect_rev_no);
System.out.println("##  sWorkUser  =  "+sWorkUser);
System.out.println("##  sUserName  =  "+sUserName);
System.out.println("##  sTeamName  =  "+sTeamName);
***/

ArrayList getReceiveInfoList = new ArrayList();
getReceiveInfoList = getReceiveInfo(sSelect_seq_no);

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
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>



<%--========================== HTML BODY ===================================--%>
<body style="background-color:#eeeeee">

<form name="designProcessForm" method="post">

<input type="hidden" name="select_seq_no" value="<%=sSelect_seq_no%>">
<input type="hidden" name="select_rev_no" value="<%=sSelect_rev_no%>">
<input type="hidden" name="workUser" value="<%=sWorkUser%>">
<input type="hidden" name="userName" value="<%=sUserName%>">
<input type="hidden" name="teamName" value="<%=sTeamName%>">
<input type="hidden" name="project" value="<%=project%>">
<input type="hidden" name="processRunning" value="FALSE">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>
		<table width="100%">
		   <tr height="30">
			   <td width="60%" style="font-size: 15pt; font-weight: bold; text-align: center; color=blue;">&nbsp;&nbsp;실적 등록 </td>
			   <td width="40%" style="font-size: 15pt; font-weight: bold; text-align: center;">
				<input type="button" value='등 록' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="designProcessAction();">&nbsp;&nbsp;
				<input type="button" value="닫 기" style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="javascript:window.close();">
			   </td>
		   </tr>
		</table>
		<br>
		<br>
		<table width="100%" height="60" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="30">	</td>
				<td width="200" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">처리부서</td>
							<td class="td_timeselect" width="100" bgcolor="#cccccc">담당자</td>
						</tr>
						<tr height="25">
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><%=sTeamName%></td>
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><%=sUserName%></td>
						</tr>
					</table>

				</td>
				<td width="100"> </td>
				<td width="340" align="center">
					<table border="1" bordercolor="black"  style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">접수NO.</td>
							<td class="td_timeselect" width="240" bgcolor="#cccccc">제목</td>
						</tr>
						<tr height="25">
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><%=rev_no%></td>
							<td class="td_standard" width="240" bgcolor="#f5f5f5"><%=subject%></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br><br>

		<table width="100%" height="30" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="30">	</td>
				<td width="200" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">호선</td>
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><%=project%></td>
						</tr>
					</table>

				</td>
				<td width="100"> </td>
				<td width="270" align="center">
					<table border="1" bordercolor="black"  style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="70" bgcolor="#cccccc">Ref.No</td>
							<td class="td_timeselect" width="200" bgcolor="#f5f5f5"><input class="input_noBorder" name="send_ref_no" value="" style="text-align:center;width:170px;background-color:#FFFF99;font-size:10pt;font-weight:bold;"></td>
						</tr>
					</table>
				</td>
				<td width="70"><input type="button" value='찾기' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 25px; width: 60px;" onclick="searchRefNo();">
			</tr>
		</table>

		<br><br>

		<table width="100%" height="60" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="30">	</td>
				<td width="300" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">Comments</td>
							<td class="td_timeselect" width="100" bgcolor="#cccccc">Reply</td>
							<td class="td_timeselect" width="100" bgcolor="#cccccc">Short Notice</td>
						</tr>
						<tr height="25">
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><input class="input_noBorder" style="text-align:center;width:85px;background-color:#FFFF99;	font-size: 11pt;font-weight: bold;" name="comment_count" value="" onblur="checkNumber(this);"></td>
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><input class="input_noBorder" style="text-align:center;width:85px;background-color:#FFFF99; font-size: 11pt;font-weight: bold;" name="reply_count" value="" onblur="checkNumber(this);"></td>
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><input class="input_noBorder" style="text-align:center;width:85px;background-color:#FFFF99; font-size: 11pt;font-weight: bold;" name="short_notice_count" value="" onblur="checkNumber(this);"></td>
						</tr>
					</table>

				</td>
				<td width="340"> </td>
			</tr>
		</table>

		<br><br>

		<table width="100%" height="30" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="30">	</td>
				<td width="500" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">발신문서 첨부</td>
							<td class="td_timeselect" width="400" bgcolor="#f5f5f5">
								<input type="file" name="fileName" style="width:380;background-color:#FFFF99;" onKeyDown="return false">
							</td>
						</tr>
					</table>
				</td>
				<td width="140" align="left">
					<input type="button" value="CLEAR" style="cursor:hand; border: #000000 1px solid; font-size: 9pt; height: 25px; width: 70px;" onclick="javascript:clearFileName(this.form);">
				</td>
			</tr>
		</table>

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
		

		var url = "stxPECBuyerClassCommentResultManagementDesignPersonSearchRefNo.jsp?workUser="+workUser+"&project="+project;

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
            mainForm.action = "stxPECBuyerClassCommentResultManagementDesignProcessAction.jsp";
            mainForm.processRunning.value = "TRUE";
            mainForm.submit();    
        }
	}

</script>