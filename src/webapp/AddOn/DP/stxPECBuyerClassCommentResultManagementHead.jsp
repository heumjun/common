<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 메인 헤더
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementHead.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== SCRIPT ======================================--%>
<!-- <script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script> -->
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUIModal.js"></script>

<script language="JavaScript">

    function dataSearch()
    {
        
        if (commentHeadForm.fromDate.value == "") {
            alert("수신일자는 필수 조회 조건입니다.");
            return;
        }
        if (commentHeadForm.toDate.value == "") {
            alert("수신일자는 필수 조회 조건입니다.");
            return;
        }

        // 조회
		var project                = document.commentHeadForm.project.value;
		var ownerClass             = document.commentHeadForm.ownerClass.value;
		var fromDate               = document.commentHeadForm.fromDate.value;
		var toDate                 = document.commentHeadForm.toDate.value;
		var revNo                  = document.commentHeadForm.revNo.value;
		var subject                = document.commentHeadForm.subject.value;
		var receiveDept            = document.commentHeadForm.receiveDept.value;
		var refDept                = document.commentHeadForm.refDept.value;
		var designReceiveFlag      = document.commentHeadForm.designReceiveFlag.value;
		var designReceiveFromDate  = document.commentHeadForm.designReceiveFromDate.value;
		var designReceiveToDate    = document.commentHeadForm.designReceiveToDate.value;
		var receivePerson          = document.commentHeadForm.receivePerson.value;
		var processDept            = document.commentHeadForm.processDept.value;
		var processPerson          = document.commentHeadForm.processPerson.value;
		var designProcessFromDate  = document.commentHeadForm.designProcessFromDate.value;
		var designProcessToDate    = document.commentHeadForm.designProcessToDate.value;
		var status                 = document.commentHeadForm.status.value;		


		if(ownerClass=="All") ownerClass = "";
		if(designReceiveFlag=="All") designReceiveFlag = "";
		if(status=="All") status = "";

        var urlStr = "stxPECBuyerClassCommentResultManagementBody.jsp"
		           + "?project=" + project
				   + "&ownerClass=" + ownerClass
				   + "&fromDate=" + fromDate
				   + "&toDate=" + toDate
				   + "&revNo=" + revNo
				   + "&subject=" + subject
				   + "&receiveDept=" + escape(encodeURIComponent(receiveDept))
				   + "&refDept=" + escape(encodeURIComponent(refDept))
				   + "&designReceiveFlag=" + designReceiveFlag
				   + "&designReceiveFromDate=" + designReceiveFromDate
				   + "&designReceiveToDate=" + designReceiveToDate
				   + "&receivePerson=" + escape(encodeURIComponent(receivePerson))
				   + "&processDept=" + escape(encodeURIComponent(processDept))
				   + "&processPerson=" + escape(encodeURIComponent(processPerson))
				   + "&designProcessFromDate=" + designProcessFromDate
				   + "&designProcessToDate=" + designProcessToDate
				   + "&status=" + status
				   + "&mode=search";
        
        parent.COMMENT_RESULT_MANAGEMENT_BODY.location = urlStr;

        return;
    }

    // 엑셀 다운로드
    function excelDownload()
    {
       var mainForm = document.commentHeadForm;
       mainForm.action="stxPECBuyerClassCommentResultManagementExcelDownload.jsp";
       mainForm.target="_self";
       mainForm.submit();

    }
	

	// 설계접수  (수신부서 팀장/파트장)
    function designReceive()
    {

        var mainForm = parent.COMMENT_RESULT_MANAGEMENT_BODY.commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	

		// 2012-10-11 : 파트장 대행 이상호 과장(200031) 추가,   2012-10-23 : 파트장 대행 유세형 과장(202167) 추가,  2013-01-07 : 파트장 대행 박찬일 차장(200094) 추가, 2013-07-10 : 파트장 대행 권효준 차장(202160) 추가, 2015-02-03 : 파트장대행 육평수 차장(198019), 윤광민 과장(211867) 추가
		if(!(jobName=="팀장" || jobName=="파트장" || workUser=="202077" || workUser=="200031" || workUser=="202167" || workUser=="200094" || workUser=="202160" || workUser=="198019" || workUser=="211867")) 
		{
			alert("설계 접수는 팀장 혹은 파트장만 가능합니다.");
			return;
		}		
		

		var select_seq_no = "";
		var select_rev_no = "";
		var check_design_receive_flag = "";
		var check_send_receive_dept = "";

		var someSelected = false;
		var checkCount = 0;
        for(var i = 0; i < mainForm.elements.length; i++)
        {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkCount++;
				checkboxIndex = mainForm.elements[i].value;

                if(checkCount != 1)
                {
                    alert("접수는 1 개씩만 실행할 수 있습니다.");
                    return;
                }
				
				check_design_receive_flag = mainForm.elements['design_receive_flag'+checkboxIndex].value;

				if(check_design_receive_flag == "Y")
				{
					alert("해당 대상은 이미 접수 상태입니다.");
                    return;
				}

				check_send_receive_dept = mainForm.elements['send_receive_dept'+checkboxIndex].value;

				if(check_send_receive_dept != teamName && workUser!="202077" )
				{
					alert("해당 수신부서 인원만 접수가 가능합니다..");
                    return;
				}

				select_seq_no = mainForm.elements['seq_no'+checkboxIndex].value;
				select_rev_no = mainForm.elements['rev_no'+checkboxIndex].value;
            }
        }

        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }


		var url = "stxPECBuyerClassCommentResultManagementDesignReceive.jsp?select_seq_no=" + select_seq_no;
			url += "&select_rev_no="+select_rev_no;
			url += "&workUser="+workUser;
			url += "&userName="+escape(encodeURIComponent(userName));
			url += "&teamName="+escape(encodeURIComponent(teamName));

		var nwidth = 540;
		var nheight = 500;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);


    }

	// 담당자 변경  (수신부서 팀장/파트장)
    function designChangeProcesser()
    {
		
        var mainForm = parent.COMMENT_RESULT_MANAGEMENT_BODY.commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	

		// 2012-10-11 : 파트장 대행 이상호 과장(200031) 추가,   2012-10-23 : 파트장 대행 유세형 과장(202167) 추가,  2013-01-07 : 파트장 대행 박찬일 차장(200094) 추가,  2013-07-10 : 파트장 대행 권효준 차장(202160) 추가, 2015-02-03 : 파트장대행 육평수 차장(198019), 윤광민 과장(211867) 추가
		if(!(jobName=="팀장" || jobName=="파트장" || workUser=="202077" || workUser=="200031" || workUser=="202167" || workUser=="200094" || workUser=="202160" || workUser=="198019" || workUser=="211867")) 
		{
			alert("담당자 변경은 팀장 혹은 파트장만 가능합니다.");
			return;
		}		
		
		var processUser = "";
		var processUserName = "";
		var deptName = "";
		var select_seq_no = "";
		var select_rev_no = "";
		var check_design_receive_flag = "";
		var check_send_receive_dept = "";

		var someSelected = false;
		var checkCount = 0;
        for(var i = 0; i < mainForm.elements.length; i++)
        {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkCount++;
				checkboxIndex = mainForm.elements[i].value;
				
				
                if(checkCount != 1)
                {
                    alert("담당자 변경은 1 개씩만 실행할 수 있습니다.");
                    return;
                }
				//담당자 지정 체크
				if(mainForm.elements['design_process_person'+checkboxIndex].value == "")
				{
					alert("담당자지정이 완료된 항목만 담당자변경을 할 수 있습니다.");
                    return;
				}

				//실적 입력 여부 : 미입력시 진행
				if(mainForm.elements['design_process_date'+checkboxIndex].value != "")
				{
					alert("기존담당자가 이미 실적을 입력하였습니다.");
                    return;
				}
				
				//상태체크 : 접수 상태만 진행.
				if(mainForm.elements['status'+checkboxIndex].value != "Open")
				{
					alert("접수 상태일때만 가능합니다.");
                    return;
				}

				check_send_receive_dept = mainForm.elements['send_receive_dept'+checkboxIndex].value;

				if(check_send_receive_dept != teamName && workUser!="202077" )
				{
					alert("해당 수신부서 인원만 담당자 변경이 가능합니다..");
                    return;
				}

				select_seq_no = mainForm.elements['seq_no'+checkboxIndex].value;
				select_rev_no = mainForm.elements['rev_no'+checkboxIndex].value;
				
				processUser = mainForm.elements['design_process_person'+checkboxIndex].value;
				processUserName = mainForm.elements['design_process_person_name'+checkboxIndex].value;
				deptName = mainForm.elements['design_process_dept'+checkboxIndex].value;
				
            }
        }

        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }

		var url = "stxPECBuyerClassCommentResultManagementDesignReceiveChangeProcesser.jsp?select_seq_no=" + select_seq_no;
			url += "&select_rev_no="+select_rev_no;
			url += "&workUser="+workUser;
			url += "&userName="+escape(encodeURIComponent(userName));
			url += "&teamName="+escape(encodeURIComponent(teamName));
			url += "&processUser="+escape(encodeURIComponent(processUser));
			url += "&processUserName="+escape(encodeURIComponent(processUserName));
			url += "&deptName="+escape(encodeURIComponent(deptName));			
			

		var nwidth = 540;
		var nheight = 250;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);

    }


	// 실적 등록  (수신부서 지정된 처리 담당자)
    function designProcess()
    {

        var mainForm = parent.COMMENT_RESULT_MANAGEMENT_BODY.commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	

		var select_seq_no = "";
		var select_rev_no = "";
		var check_design_receive_flag = "";
		var check_design_process_person = "";
		var check_status = "";

		var someSelected = false;
		var checkCount = 0;
        for(var i = 0; i < mainForm.elements.length; i++)
        {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkCount++;
				checkboxIndex = mainForm.elements[i].value;

                if(checkCount != 1)
                {
                    alert("실적등록은 1 개씩만 실행할 수 있습니다.");
                    return;
                }

				
				check_design_receive_flag = mainForm.elements['design_receive_flag'+checkboxIndex].value;

				if(check_design_receive_flag == "N")
				{
					alert("실적등록은 접수 상태만 가능합니다.");
                    return;
				}

				check_status = mainForm.elements['status'+checkboxIndex].value;

				if(check_status != "Open")
				{
					alert("실적등록은 Open 상태만 가능합니다.");
					return;
				}

				check_design_process_person = mainForm.elements['design_process_person'+checkboxIndex].value;

				if(check_design_process_person != workUser)
				{
					alert("실적등록은 처리담당자로 지정된 사람만 가능합니다.");
                    return;
				}

				select_seq_no = mainForm.elements['seq_no'+checkboxIndex].value;
				select_rev_no = mainForm.elements['rev_no'+checkboxIndex].value;
            }
        }

        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }


		var url = "stxPECBuyerClassCommentResultManagementDesignProcess.jsp?select_seq_no=" + select_seq_no;
			url += "&select_rev_no="+select_rev_no;
			url += "&workUser="+workUser;
			url += "&userName="+escape(encodeURIComponent(userName));
			url += "&teamName="+escape(encodeURIComponent(teamName));

		var nwidth = 700;
		var nheight = 400;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);


    }


	// 실적 추가 등록
	function designProcessAddition()
	{
        var mainForm = parent.COMMENT_RESULT_MANAGEMENT_BODY.commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	

		var select_seq_no = "";
		var select_rev_no = "";
		var check_status = "";
		var check_design_process_person = "";

		var someSelected = false;
		var checkCount = 0;
        for(var i = 0; i < mainForm.elements.length; i++)
        {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkCount++;
				checkboxIndex = mainForm.elements[i].value;

                if(checkCount != 1)
                {
                    alert("실적추가는 1 개씩만 실행할 수 있습니다.");
                    return;
                }

				
				check_status = mainForm.elements['status'+checkboxIndex].value;

				if(check_status != "Progress")
				{
					alert("실적 추가는  Progress 상태만 가능합니다.");
					return;
				}

				check_design_process_person = mainForm.elements['design_process_person'+checkboxIndex].value;

				if(check_design_process_person != workUser)
				{
					alert("실적 등록은 처리담당자로 지정된 사람만 가능합니다.");
                    return;
				}

				select_seq_no = mainForm.elements['seq_no'+checkboxIndex].value;
				select_rev_no = mainForm.elements['rev_no'+checkboxIndex].value;
            }
        }

        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }


		var url = "stxPECBuyerClassCommentResultManagementDesignProcessAddition.jsp?select_seq_no=" + select_seq_no;
			url += "&select_rev_no="+select_rev_no;
			url += "&workUser="+workUser;
			url += "&userName="+escape(encodeURIComponent(userName));
			url += "&teamName="+escape(encodeURIComponent(teamName));

		var nwidth = 700;
		var nheight = 400;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);
	}


	function forceClosed()
	{
        var mainForm = parent.COMMENT_RESULT_MANAGEMENT_BODY.commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	

		// 2012-10-11 : 파트장 대행 이상호 과장(200031) 추가, 2012-10-23 : 파트장 대행 유세형 과장(202167) 추가,  2013-01-07 : 파트장 대행 박찬일 차장(200094) 추가,  2013-07-10 : 파트장 대행 권효준 차장(202160) 추가, 2015-02-03 : 파트장대행 육평수 차장(198019), 윤광민 과장(211867) 추가
		if(!(jobName=="팀장" || jobName=="파트장" || workUser=="200031" || workUser=="202167" || workUser=="200094" || workUser=="202160" || workUser=="198019" || workUser=="211867"))
		{
			alert("강제 Closed 는 팀장 혹은 파트장만 가능합니다.");
			return;
		}			
		

		var select_seq_no = "";
		var check_status = "";
		var check_send_receive_dept = "";

		var someSelected = false;
        for(var i = 0; i < mainForm.elements.length; i++)
        {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
				checkboxIndex = mainForm.elements[i].value;


				check_status = mainForm.elements['status'+checkboxIndex].value;

				if(!(check_status == "Open" || check_status == "Progress"))
				{
					alert("강제 Closed 는 Open, Progress 상태만 가능합니다.");
					return;
				}

				check_send_receive_dept = mainForm.elements['send_receive_dept'+checkboxIndex].value;

				if(check_send_receive_dept != teamName)
				{
					alert("해당 수신부서 인원만 강제 Closed가 가능합니다.");
                    return;
				}

				var tempSelect_seq_no = mainForm.elements['seq_no'+checkboxIndex].value;

				if(select_seq_no=="")
				{
					select_seq_no = tempSelect_seq_no;
				} else {
					select_seq_no = select_seq_no + "," + tempSelect_seq_no;
				}
            }
        }

        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }

		if(confirm("선택한 항목을 강제 Closed 하시겠습니까?"))
		{
			var xmlHttp;
			if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

			// GET 방식 전송
			var url = "stxPECBuyerClassCommentResultManagementForceClosed.jsp?select_seq_no=" + select_seq_no;

			xmlHttp.open("GET", url, false);
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
			}
			
			// 접수 처리 후 Page Reload
			var headForm = document.commentHeadForm;

			var reloadproject                = headForm.project.value;
			var reloadownerClass             = headForm.ownerClass.value;
			var reloadfromDate               = headForm.fromDate.value;
			var reloadtoDate                 = headForm.toDate.value;
			var reloadrevNo                  = headForm.revNo.value;
			var reloadsubject                = headForm.subject.value;
			var reloadreceiveDept            = headForm.receiveDept.value;
			var reloadrefDept                = headForm.refDept.value;
			var reloaddesignReceiveFlag      = headForm.designReceiveFlag.value;
			var reloaddesignReceiveFromDate  = headForm.designReceiveFromDate.value;
			var reloaddesignReceiveToDate    = headForm.designReceiveToDate.value;
			var reloadreceivePerson          = headForm.receivePerson.value;
			var reloadprocessDept            = headForm.processDept.value;
			var reloadprocessPerson          = headForm.processPerson.value;
			var reloaddesignProcessFromDate  = headForm.designProcessFromDate.value;
			var reloaddesignProcessToDate    = headForm.designProcessToDate.value;
			var reloadstatus                 = headForm.status.value;
			

			if(reloadownerClass=="All") reloadownerClass = "";
			if(reloaddesignReceiveFlag=="All") reloaddesignReceiveFlag = "";
			if(reloadstatus=="All") reloadstatus = "";


			var urlStr = "stxPECBuyerClassCommentResultManagementBody.jsp"
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
					   + "&receivePerson=" + escape(encodeURIComponent(reloadreceivePerson))
					   + "&processDept=" + escape(encodeURIComponent(reloadprocessDept))
					   + "&processPerson=" + escape(encodeURIComponent(reloadprocessPerson))
					   + "&designProcessFromDate=" + reloaddesignProcessFromDate
					   + "&designProcessToDate=" + reloaddesignProcessToDate
					   + "&status=" + reloadstatus
					   + "&mode=search";

			alert("SUCCESS");
			window.close();
			
			parent.COMMENT_RESULT_MANAGEMENT_BODY.location = urlStr;

		}
	}

	


    
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
</script>
<%@page import="java.net.URLDecoder"%>
<html>
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

	Calendar cal_today = Calendar.getInstance(); 
	Calendar cal_fromday = Calendar.getInstance(); 

	//SEND_RECEIVE_DATE <= TO_DATE('2012-08-26','YYYY-MM-DD') 조건에서 SEND_RECEIVE_DATE가 시분초를 가지고 있어서 하루를 더해줘야 오늘날짜를 포함한다.
	cal_today.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR));
	cal_fromday.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR) - 14);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  

	String toDate = sdf.format(cal_today.getTime());  // today
	String fromDate = sdf.format(cal_fromday.getTime());  // today - 14 (2Week)

	//String workUser = context.getUser();
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
   // String loginID = SessionUtils.getUserId();
    String workUser = (String)loginUser.get("user_id");			

	String userName = "";
	String teamName = "";
	String teamCode = "";
	String jobName = "";

	java.sql.Connection conn = null;
	java.sql.Statement stmt = null;
	java.sql.ResultSet rset = null;

	ArrayList resultArrayList = new ArrayList();

	try {
/***    DPS는 팀정보가 도면팀 정보라서 인사 DB에서 정보 가져오도록 변경.
		conn = DBConnect.getDBConnection("SDPS");

		StringBuffer queryStr = new StringBuffer();

		queryStr.append("SELECT A.NAME AS USER_NAME ,                                                  \n");
		queryStr.append("       A.DEPT_CODE AS PART_CODE ,                                             \n");
		queryStr.append("       (SELECT D.DWGDEPTNM                                                    \n");
		queryStr.append("          FROM DCC_DEPTCODE B ,                                               \n");
		queryStr.append("               DCC_DWGDEPTCODE C ,                                            \n");
		queryStr.append("               DCC_DWGDEPTCODE D                                              \n");
		queryStr.append("         WHERE A.DEPT_CODE = B.DEPTCODE                                       \n");
		queryStr.append("           AND B.DWGDEPTCODE = C.DWGDEPTCODE                                  \n");
		queryStr.append("           AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE) AS TEAM_NAME ,             \n");
		queryStr.append("       (SELECT D.DWGDEPTCODE                                                  \n");
		queryStr.append("          FROM DCC_DEPTCODE B ,                                               \n");
		queryStr.append("               DCC_DWGDEPTCODE C ,                                            \n");
		queryStr.append("               DCC_DWGDEPTCODE D                                              \n");
		queryStr.append("         WHERE A.DEPT_CODE = B.DEPTCODE                                       \n");
		queryStr.append("           AND B.DWGDEPTCODE = C.DWGDEPTCODE                                  \n");
		queryStr.append("           AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE) as TEAM_CODE               \n");
		queryStr.append("  FROM CCC_SAWON A                                                            \n");
		queryStr.append("  WHERE A.EMPLOYEE_NUM = '"+workUser+"'                                       \n");

		stmt = conn.createStatement();
		rset = stmt.executeQuery(queryStr.toString());

		while (rset.next()) {
			userName = rset.getString(1);
			partCode = rset.getString(2);
			teamName = rset.getString(3);
			teamCode = rset.getString(4);
		}
***/
		conn = DBConnect.getDBConnection("ERP_APPS");

		StringBuffer queryStr = new StringBuffer();

		queryStr.append("SELECT INSA.EMP_NO,                                              \n");
		queryStr.append("       INSA.USER_NAME,                                           \n");
		queryStr.append("       INSA.JOB_NAM,                                             \n");
		queryStr.append("       DEPT.TEAM_CODE,                                           \n");
		queryStr.append("       DEPT.TEAM_NAME                                            \n");
		queryStr.append("  FROM STX_COM_INSA_USER INSA,                                   \n");
		queryStr.append("       STX_COM_INSA_DEPT DEPT                                    \n");
		queryStr.append(" WHERE INSA.DEPT_CODE = DEPT.DEPT_CODE                           \n");
		queryStr.append("   AND INSA.DEL_DATE IS NULL                                     \n");
		queryStr.append("   AND INSA.EMP_NO = '"+workUser+"'                              \n");

		stmt = conn.createStatement();
		rset = stmt.executeQuery(queryStr.toString());

		while (rset.next()) {
			userName = rset.getString(2) == null ? "" : rset.getString(2);
			jobName  = rset.getString(3) == null ? "" : rset.getString(3);
			teamCode = rset.getString(4) == null ? "" : rset.getString(4);
			teamName = rset.getString(5) == null ? "" : rset.getString(5);
		}
	}
	finally {
		if (rset != null) rset.close();
		if (stmt != null) stmt.close();
		DBConnect.closeConnection(conn);
	}

%>

<body>
<form name=commentHeadForm method="post" action="stxPECBuyerClassCommentResultManagementBody.jsp">

    <input type="hidden" name="workUser" value="<%=workUser%>">
	<input type="hidden" name="userName" value="<%=userName%>">
    <input type="hidden" name="teamName" value="<%=teamName%>">
	<input type="hidden" name="jobName" value="<%=jobName%>">


    <table width="100%" cellSpacing="0" border="0" align="center">
    <tr height="40">
        <td width="100%" style="font-size: 15pt; font-weight: bold;	text-align: center; color=darkblue;" > 
            문서 접수 및 실적 관리
        </td>
	</tr>
	</table>

	<table width="100%" cellSpacing="0" border="0" align="center">
		<tr>
			<td style="border: #00bb00 1px solid;">
				<table cellpadding="0" cellspacing="0" style="border-collapse: collapse;">
					<tr height="30">
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							호선
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							대상
						</td>
						<td width="120" style="color:#0000ff; font-weight: bold;" align="center">
							선주/선급<br>발송일자
						</td>
						<td width="120" style="color:#0000ff; font-weight: bold;" align="center">
							접수 NO.
						</td>
						<td width="230" style="color:#0000ff; font-weight: bold;" align="center">
							제목
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							수신부서
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							참조부서
						</td>
						<td width="10" style="color:#0000ff; font-weight: bold;" align="center">
							&nbsp;
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							접수여부
						</td>
						<td width="120" style="color:#0000ff; font-weight: bold;" align="center">
							접수일자
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							접수자
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							담당부서
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							담당자
						</td>
						<td width="120" style="color:#0000ff; font-weight: bold;" align="center">
							실적등록일
						</td>
						<td width="100" style="color:#0000ff; font-weight: bold;" align="center">
							STATUS
						</td>
					</tr>

					<tr height="30">
						<td width="100" align="center">
							<input style="ime-mode:disabled;width:90px;" name="project" value="">
						</td>
						<td width="100"align="center">
							<select name="ownerClass" style="width:80px">
								<option value="All">전체</option>
								<option value="owner">선주</option>
								<option value="class">선급</option>
							</select>
						</td>
						<td width="120" align="center">
							<input style="width:80px;background-color:#FFFF99;" name="fromDate" value="<%=fromDate%>" onmouseover="showhint(this , 'date');"> ~
						</td>
						<td width="120" align="center">
							<input style="ime-mode:disabled;width:140px;" name="revNo" value="">
						</td>
						<td width="230" align="center">
							<input style="ime-mode:disabled;width:290px;" name="subject" value="">
						</td>
						<td width="100" align="center">
							<input style="width:90px;background-color:#FFFF99;" name="receiveDept" value="<%=teamName%>">
						</td>
						<td width="100" align="center">
							<input  style="width:90px;" name="refDept" value="">
						</td>
						<td width="10" align="center">
							&nbsp;
						</td>
						<td width="100" align="center">
							<select name="designReceiveFlag" style="width:80px">
								<option value="All">전체</option>
								<option value="Y">접수</option>
								<option value="N">미접수</option>
							</select>
						</td>
						<td width="120" align="center">
							<input style="width:80px;" name="designReceiveFromDate" value="" onmouseover="showhint(this , 'date');"> ~
						</td>
						<td width="100" align="center">
							<input style="width:90px;" name="receivePerson" value="">
						</td>
						<td width="100" align="center">
							<input style="width:90px;" name="processDept" value="">
						</td>
						<td width="100" align="center">
							<input style="width:90px;" name="processPerson" value="">
						</td>
						<td width="120" align="center">
							<input style="width:80px;" name="designProcessFromDate" value="" onmouseover="showhint(this , 'date');"> ~
						</td>
						<td width="100" align="center">
							<select name="status" style="width:80px">
								<option value="All">전체</option>
								<option value="Open">Open</option>
								<option value="Progress">Progress</option>
								<option value="Closed(F)">Closed(F)</option>
								<option value="Closed">Closed</option>
							</select>
						</td>
					</tr>

					<tr height="30">
						<td width="100">

						</td>
						<td width="100">

						</td>
						<td width="120" align="center" >
							<input style="width:80px;background-color:#FFFF99;" name="toDate" value="<%=toDate%>" onmouseover="showhint(this , 'date');">
						</td>
						<td width="150">

						</td>
						<td width="300">

						</td>
						<td width="100">

						</td>
						<td width="100">

						</td>
						<td width="10" style="color:#0000ff" align="center">

						</td>
						<td width="100">

						</td>
						<td width="120" align="center">
							<input style="width:80px;" name="designReceiveToDate" value="" onmouseover="showhint(this , 'date');">
						</td>
						<td width="100">

						</td>
						<td width="100">

						</td>
						<td width="100">
	
						</td>
						<td width="120" align="center">
							<input style="width:80px;" name="designProcessToDate" value="" onmouseover="showhint(this , 'date');">
						</td>
						<td width="100">

						</td>
					</tr>

				</table>
			</td>
		</tr>
	</table>

	<table width="100%" cellSpacing="0" border="0" align="center">
		<tr height="10">
			<td>&nbsp;</td>
		</tr>
	</table>

    <table width="100%" cellSpacing="0" border="0" align="center">
    <tr height="30">
		<td width="50%" style="color:#0000ff; font-weight: bold;">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ※ 접수 NO. 및 발송문서 NO. 클릭 시 문서 열람 가능
		</td>
        <td width="50%" align="left"> 
			<input type="button" value='검 색' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 80px;" onclick="dataSearch();"> &nbsp;&nbsp;&nbsp;
			<input type="button" value='접 수' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 80px;" onclick="designReceive();"> &nbsp;&nbsp;&nbsp;
			<input type="button" value='담당자 변경' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 100px;" onclick="designChangeProcesser();"> &nbsp;&nbsp;&nbsp;
			<input type="button" value='실적 등록' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 80px;" onclick="designProcess();"> &nbsp;&nbsp;&nbsp;
			<input type="button" value='실적 추가' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 80px;" onclick="designProcessAddition();"> &nbsp;&nbsp;&nbsp;
			<input type="button" value='강제 Closed' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 100px;" onclick="forceClosed();"> &nbsp;&nbsp;&nbsp;
			<input type="button" value='Excel' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="excelDownload();">
		</td>
	</tr>
	</table>
</form>
</body>
</html>
