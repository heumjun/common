<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 메인 헤더
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementHead.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>
<html>
<head>
<title>문서접수 / 실적관리</title>
</head>
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.net.URLDecoder"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%
	response.setContentType("text/html; charset=UTF-8");
%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>



<%--========================== SCRIPT ======================================--%>
<script type="text/javascript" type="text/javascript"
	src="/js/stxPECDP_CommonScript.js"></script>
<script type="text/javascript" type="text/javascript"
	src="/js/stxPECDP_GeneralAjaxScript.js"></script>
<script type="text/javascript">
	$(function() {
		$(window).bind('resize', function() {
			 $('#buyerClassCommentList').css('height', $(window).height()-240);
	     }).trigger('resize');
		//메뉴바 호선 선택 focus out시에 div 숨김처리
		$("#projectListDiv").focusout(function(e){
			e.preventDefault();
			e.stopPropagation();
			fn_hideProjectSel();
		});
	});
    function dataSearch() {
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

        var urlStr = "buyerClassCommentList.do"
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
        
        $("#buyerClassCommentList").attr("src",urlStr);
        return;
    }

    // 엑셀 다운로드
    function excelDownload() {
       var mainForm = document.commentHeadForm;
       mainForm.action="buyerClassCommentExcelDownload.do";
       mainForm.target="_self";
       mainForm.submit();

    }
	

	// 설계접수  (수신부서 팀장/파트장)
    function designReceive() {
		var mainForm = frames['buyerClassCommentList'].commentBodyForm;
		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	
		var admin = document.commentHeadForm.admin.value;
		var part_manager = document.commentHeadForm.part_manager.value;		

		// 팀장, 파트장, 파트장 대행, 관리자만 접수 가능	
		if(!(jobName=="팀장" || jobName=="파트장" || admin=="Y" || part_manager=="Y")) 
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
        for(var i = 0; i < mainForm.elements.length; i++) {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkCount++;
				checkboxIndex = mainForm.elements[i].value;

                if(checkCount != 1) {
                    alert("접수는 1 개씩만 실행할 수 있습니다.");
                    return;
                }
				
				check_design_receive_flag = mainForm.elements['design_receive_flag'+checkboxIndex].value;

				if(check_design_receive_flag == "Y") {
					alert("해당 대상은 이미 접수 상태입니다.");
                    return;
				}

				check_send_receive_dept = mainForm.elements['send_receive_dept'+checkboxIndex].value;

				if(check_send_receive_dept != teamName && admin!="Y" ) {
					alert("해당 수신부서 인원만 접수가 가능합니다..");
                    return;
				}

				select_seq_no = mainForm.elements['seq_no'+checkboxIndex].value;
				select_rev_no = mainForm.elements['rev_no'+checkboxIndex].value;
            }
        }

        if(!someSelected) {
            var msg = "대상을 선택 바랍니다.";
            alert(msg);
            return;
        }


		var url = "buyerClassCommentReceive.do?select_seq_no=" + select_seq_no;
			url += "&select_rev_no="+select_rev_no;
			url += "&workUser="+workUser;
			url += "&userName="+escape(encodeURIComponent(userName));
			url += "&teamName="+escape(encodeURIComponent(teamName));

		var nwidth = 540;
		var nheight = 420;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);


    }

	// 담당자 변경  (수신부서 팀장/파트장)
    function designChangeProcesser() {
		
        var mainForm = frames['buyerClassCommentList'].commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	
		var admin = document.commentHeadForm.admin.value;
		var part_manager = document.commentHeadForm.part_manager.value;			

		// 팀장, 파트장, 파트장 대행, 관리자만 담당자 변경 가능
		if(!(jobName=="팀장" || jobName=="파트장" || admin=="Y" || part_manager=="Y")) 
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
        for(var i = 0; i < mainForm.elements.length; i++) {

            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true) {
                someSelected = true;
                checkCount++;
				checkboxIndex = mainForm.elements[i].value;
				
                if(checkCount != 1) {
                    alert("담당자 변경은 1 개씩만 실행할 수 있습니다.");
                    return;
                }
				//담당자 지정 체크
				if(mainForm.elements['design_process_person'+checkboxIndex].value == "") {
					alert("담당자지정이 완료된 항목만 담당자변경을 할 수 있습니다.");
                    return;
				}

				//실적 입력 여부 : 미입력시 진행
				//if(mainForm.elements['design_process_date'+checkboxIndex].value != "")
				//{
				//	alert("기존담당자가 이미 실적을 입력하였습니다.");
                //    return;
				//}
				
				//상태체크 : 접수 상태만 진행.
				//if(mainForm.elements['status'+checkboxIndex].value != "Open")
				//{
				//	alert("접수 상태일때만 가능합니다.");
                //    return;
				//}

				check_send_receive_dept = mainForm.elements['send_receive_dept'+checkboxIndex].value;

				if(check_send_receive_dept != teamName && admin!="Y" )
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
            var msg = "대상을 선택 바랍니다.";
            alert(msg);
            return;
        }

		var url = "buyerClassCommentChangeProcesser.do?select_seq_no=" + select_seq_no;
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

		var mainForm = frames['buyerClassCommentList'].commentBodyForm;
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
            var msg = "대상을 선택 바랍니다.";
            alert(msg);
            return;
        }


		var url = "buyerClassCommentProcess.do?select_seq_no=" + select_seq_no;
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
        var mainForm = frames['buyerClassCommentList'].commentBodyForm;

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
            var msg = "대상을 선택 바랍니다.";
            alert(msg);
            return;
        }


		var url = "buyerClassCommentProcessAddition.do?select_seq_no=" + select_seq_no;
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
        var mainForm = frames['buyerClassCommentList'].commentBodyForm;

		var workUser = document.commentHeadForm.workUser.value;
		var teamName = document.commentHeadForm.teamName.value;
		var userName = document.commentHeadForm.userName.value;	
		var jobName = document.commentHeadForm.jobName.value;	
		var admin = document.commentHeadForm.admin.value;
		var part_manager = document.commentHeadForm.part_manager.value;		

		// 팀장, 파트장, 파트장 대행, 관리자만 강제 CLOSE 가능
		if(!(jobName=="팀장" || jobName=="파트장" || admin=="Y" || part_manager=="Y"))
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
            var msg = "대상을 선택 바랍니다.";
            alert(msg);
            return;
        }

		if(confirm("선택한 항목을 강제 Closed 하시겠습니까?"))
		{
			var lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' });
			// GET 방식 전송
			var url = "buyerClassCommentForceClosed.do?select_seq_no=" + select_seq_no;

			$.post( url, "", function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					
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
							   + "&receivePerson=" + escape(encodeURIComponent(reloadreceivePerson))
							   + "&processDept=" + escape(encodeURIComponent(reloadprocessDept))
							   + "&processPerson=" + escape(encodeURIComponent(reloadprocessPerson))
							   + "&designProcessFromDate=" + reloaddesignProcessFromDate
							   + "&designProcessToDate=" + reloaddesignProcessToDate
							   + "&status=" + reloadstatus
							   + "&mode=search";
					
					$("#buyerClassCommentList").attr("src",urlStr);
				}
			}, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	lodingBox.remove();	
			} );
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
    
  //호선 검색 값 변경
    function fn_projectChanged(obj){
    	$("#project").val($(obj).val());
    	fn_hideProjectSel();
    }
    //호선 검색view show
    function fn_showProjectSel(obj){
    	var activeDivObj = $("#projectListDiv");
    	var activeSelectBox = $("#projectList");
    	activeDivObj.css("left",$(obj).prev().offset().left);
    	activeDivObj.css("top",$(obj).prev().offset().top);
    	activeDivObj.css("display","");
    	if($("#project").val() != '')activeSelectBox.val($("#project").val());
    	else activeSelectBox.find("option:eq(0)").attr("selected","true");
    	activeSelectBox.focus().click();
    }
    //호선 검색 view hide
    function fn_hideProjectSel(){
    	$("#projectListDiv").css("display","none");
    }
</script>
<%
	Calendar cal_today = Calendar.getInstance();
	Calendar cal_fromday = Calendar.getInstance();

	//SEND_RECEIVE_DATE <= TO_DATE('2012-08-26','YYYY-MM-DD') 조건에서 SEND_RECEIVE_DATE가 시분초를 가지고 있어서 하루를 더해줘야 오늘날짜를 포함한다.
	cal_today.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR));
	cal_fromday.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR) - 14);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String toDate = sdf.format(cal_today.getTime()); // today
	String fromDate = sdf.format(cal_fromday.getTime()); // today - 14 (2Week)

	//String workUser = context.getUser();
	Map loginUser = (Map) request.getSession().getAttribute("loginUser");
	// String loginID = SessionUtils.getUserId();
	String workUser = (String) loginUser.get("user_id");

	String userName = "";
	String teamName = "";
	String teamCode = "";
	String jobName = "";
	String admin = "";
	String part_manager = "";

	java.sql.Connection conn = null;
	java.sql.Statement stmt = null;
	java.sql.ResultSet rset = null;

	ArrayList resultArrayList = new ArrayList();

	try {

		conn = DBConnect.getDBConnection("ERP_APPS");

		StringBuffer queryStr = new StringBuffer();

		queryStr.append("SELECT INSA.EMP_NO,                                              \n");
		queryStr.append("       INSA.USER_NAME,                                           \n");
		queryStr.append("       INSA.JOB_NAM,                                             \n");
		queryStr.append("       NVL(DEPT.TEAM_CODE,DEPT.DEPT_CODE) AS TEAM_CODE,          \n");
		queryStr.append("       NVL(DEPT.TEAM_NAME,DEPT.DEPT_NAME) AS TEAM_NAME,          \n");
		queryStr.append("       NVL((SELECT 'Y'                                           \n");
		queryStr.append("              FROM STX_OC_RECEIVE_DOCUMENT_USER@STXDP A          \n");
		queryStr.append("             WHERE GROUP_TYPE = 'ADMIN'                          \n");
		queryStr.append("               AND A.EMP_NO = INSA.EMP_NO), 'N') AS ADMIN,       \n");
		queryStr.append("       NVL((SELECT 'Y'                                           \n");
		queryStr.append("              FROM STX_OC_RECEIVE_DOCUMENT_USER@STXDP A          \n");
		queryStr.append("             WHERE GROUP_TYPE = 'PART_MANAGER'                   \n");
		queryStr.append("               AND A.EMP_NO = INSA.EMP_NO), 'N') AS PART_MANAGER \n");
		queryStr.append("  FROM STX_COM_INSA_USER INSA,                                   \n");
		queryStr.append("       STX_COM_INSA_DEPT DEPT                                    \n");
		queryStr.append(" WHERE INSA.DEPT_CODE = DEPT.DEPT_CODE                           \n");
		queryStr.append("   AND INSA.DEL_DATE IS NULL                                     \n");
		queryStr.append("   AND INSA.EMP_NO = '" + workUser + "'                              \n");

		stmt = conn.createStatement();
		rset = stmt.executeQuery(queryStr.toString());

		while (rset.next()) {
			userName = rset.getString(2) == null ? "" : rset.getString(2);
			jobName = rset.getString(3) == null ? "" : rset.getString(3);
			teamCode = rset.getString(4) == null ? "" : rset.getString(4);
			teamName = rset.getString(5) == null ? "" : rset.getString(5);
			admin = rset.getString(6) == null ? "" : rset.getString(6);
			part_manager = rset.getString(7) == null ? "" : rset.getString(7);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rset != null)
			rset.close();
		if (stmt != null)
			stmt.close();
		DBConnect.closeConnection(conn);
	}
%>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css
	title=stxPECDP_css>
<STYLE>
.hintstyle {
	position: absolute;
	background: #EEEEEE;
	border: 1px solid black;
	padding: 2px;
}
</STYLE>

<body>
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			문서접수 / 실적관리
			<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include> 
			<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
		</div>
		<form name=commentHeadForm method="post"
			action="buyerClassCommentList.do">
			<input type="hidden" name="workUser" value="<%=workUser%>"> <input
				type="hidden" name="userName" value="<%=userName%>"> <input
				type="hidden" name="teamName" value="<%=teamName%>"> <input
				type="hidden" name="jobName" value="<%=jobName%>"> <input
				type="hidden" name="admin" value="<%=admin%>"> <input
				type="hidden" name="part_manager" value="<%=part_manager%>">
			<table class="searchArea conSearch">
				<tr>
					<th>호선</th>
					<td width="100" align="center">
						<input type="text" name="project" id="project" value="" class = "required" id="projectNo" style="width:70px;"/>
						<input type="button" name="showprojectListBtn" value="+" style="width:20px;height:20px;font-weight:bold;" onclick="fn_showProjectSel(this);">
					</td>
					<th>대상</th>
					<td width="100" align="center"><select name="ownerClass"
						style="width: 80px">
							<option value="All">전체</option>
							<option value="owner">선주</option>
							<option value="class">선급</option>
					</select></td>
					<th>선주/선급 발송일자</th>
					<td width="120" align="center"><input
						style="width: 80px; height: 16px; background-color: #FFFF99;" name="fromDate"
						value="<%=fromDate%>" onmouseover="showhint(this , 'date');">
						~ <input style="width: 80px; height: 16px; background-color: #FFFF99;"
						name="toDate" value="<%=toDate%>"
						onmouseover="showhint(this , 'date');"></td>
					<th>접수 NO.</th>
					<td width="120" align="center"><input
						style="ime-mode: disabled; width: 110px; height: 16px;" name="revNo" value="">
					</td>
					<th>제목</th>
					<td width="230" align="center"><input
						style="ime-mode: disabled; width: 220px; height: 16px;" name="subject" value="">
					</td>
					<th>수신부서</th>
					<td width="100" align="center"><input
						style="width: 90px; height: 16px; background-color: #FFFF99;" name="receiveDept"
						value="<%=teamName%>"></td>
					<th>참조부서</th>
					<td width="100" align="center"><input style="width: 90px; height: 16px;"
						name="refDept" value=""></td>
				</tr>
			</table>
			<table class="searchArea2 conSearch">
				<tr>
					<th>접수여부</th>
					<td width="100" align="center"><select
						name="designReceiveFlag" style="width: 80px">
							<option value="All">전체</option>
							<option value="Y">접수</option>
							<option value="N">미접수</option>
					</select></td>
					<th>접수일자</th>
					<td width="120" align="center"><input style="width: 80px; height: 16px;"
						name="designReceiveFromDate" value=""
						onmouseover="showhint(this , 'date');"> ~ <input
						style="width: 80px; height: 16px;" name="designReceiveToDate" value=""
						onmouseover="showhint(this , 'date');"></td>
					<th>접수자</th>
					<td width="100" align="center"><input style="width: 90px; height: 16px;"
						name="receivePerson" value=""></td>
					<th>담당부서</th>
					<td width="100" align="center"><input style="width: 90px; height: 16px;"
						name="processDept" value=""></td>
					<th>담당자</th>
					<td width="100" align="center"><input style="width: 90px; height: 16px;"
						name="processPerson" value=""></td>
					<th>실적등록일</th>
					<td width="120" align="center"><input style="width: 80px; height: 16px;"
						name="designProcessFromDate" value=""
						onmouseover="showhint(this , 'date');"> ~ <input
						style="width: 80px; height: 16px;" name="designProcessToDate" value=""
						onmouseover="showhint(this , 'date');"></td>
					<th>STATUS</th>
					<td width="100" align="center"><select name="status"
						style="width: 80px">
							<option value="All">전체</option>
							<option value="Open">Open</option>
							<option value="Progress">Progress</option>
							<option value="Closed(F)">Closed(F)</option>
							<option value="Closed">Closed</option>
					</select></td>
				</tr>
			</table>

			<table class="searchArea2 conSearch">
				<tr height="30">
					<td width="50%" style="color: #0000ff; font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						※ 접수 NO. 및 발송문서 NO. 클릭 시 문서 열람 가능</td>
					<td width="50%" align="left">
						<div class="button endbox">
							<input type="button" value=' 검 &nbsp;&nbsp;&nbsp;색 ' class="btn_blue" onclick="dataSearch();"> 
							<input type="button" value=' 접 &nbsp;&nbsp;&nbsp;수 ' class="btn_blue" onclick="designReceive();">
							<input type="button" value='담당자변경' class="btn_blue" onclick="designChangeProcesser();"> 
							<input type="button" value='실적 등록' class="btn_blue" onclick="designProcess();">
							<input type="button" value='실적 추가' class="btn_blue" onclick="designProcessAddition();"> 
							<input type="button" value='강제Closed' class="btn_blue" onclick="forceClosed();">
							<input type="button" value='Excel출력' class="btn_blue" onclick="excelDownload();">
						</div>
					</td>
				</tr>
			</table>
		</form>
		<iframe id="buyerClassCommentList" name="buyerClassCommentList"
			src="buyerClassCommentList.do" frameborder=0 marginwidth=0
			marginheight=0 scrolling=no width=100%
			style="margin-top: 10px; width: 100%; height: 650px; background-color: #fcffff; border: 1px solid #c3c3c3;"></iframe>
	</div>
	
	<!-- 호선 선택 div팝업 -->
	<div id="projectListDiv" style="position:absolute;display:none; z-index: 9;">
	    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
	    <tr><td>
	        <select name="projectList" id="projectList" style="width:150px;background-color:#fff0f5" onchange="fn_projectChanged(this);">
	            <option value="&nbsp;"></option>
	            <c:forEach var="item" items="${projectList }">
	            	<option value="${item.projectno }">${item.projectno }</option>
	            </c:forEach>
	        </select>
	    </td></tr>
	    </table>
	</div>
</body>
</html>
