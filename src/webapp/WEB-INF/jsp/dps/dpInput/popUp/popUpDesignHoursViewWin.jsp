<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<%
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>시수체크</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
/*Description 글자수 오버 시 Warp처리*/
    .ui-jqgrid tr.jqgrow td:nth-child(13){
        word-wrap: break-word; /* IE 5.5+ and CSS3 */
        white-space: pre-wrap; /* CSS3 */
        white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
        white-space: -pre-wrap; /* Opera 4-6 */
        white-space: -o-pre-wrap; /* Opera 7 */
        overflow: hidden;
        height: auto;
        vertical-align: middle;
        padding-top: 3px;
        padding-bottom: 3px
    }
</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		시수체크
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="designerID" value="${loginUserInfo.designerid}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="isManager" value="${loginUserInfo.is_manager}" />
		
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="4%"/>
				<col width="16%"/>
				<col width="4%"/>
				<col width="22%"/>
				<col width="3%"/>
				<col width="11%"/>
				<col width="4%"/>
				<col width="21%"/>
				<col width="5%"/>
				<col width="*"/>
				<tr>
					<th>부서</th>
					<td>
						<select name="departmentList" style="width: 80%;"  onchange="fn_departmentSelChanged();">
						<c:choose>
							<c:when test="${loginUserInfo.is_admin eq 'Y'}">
								<option value="">&nbsp;</option>
								<!-- 부서 목록 리스트 추가 -->
								<c:forEach var="item" items="${departmentList }">
									<option value="${item.dept_code }" <c:if test="${item.dept_code eq loginUserInfo.dept_code }">selected="selected"</c:if>>${item.dept_code } : ${item.dept_name }</option>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<option value="${loginUserInfo.dept_code }" selected="selected">${loginUserInfo.dept_code } : ${loginUserInfo.dept_name }</option>
							</c:otherwise>
						</c:choose>
						</select>
					</td>
					<th>일자</th>
					<td align="left">
						<input type="text" id="p_created_date_start" value="" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 30%;"  readonly="readonly"/>
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 30%;"  readonly="readonly"/>
						<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>호선</th>
					<td>
						<input type="text" name="projectNo" id="projectNo" value="" style="width: 80%;">
		                <input type="button" name="showprojectListBtn" value="+" style="width:20px;height:20px;font-weight:bold;" 
		                       onclick="fn_showProjectSel(this);">
					</td>
					<th>원인부서</th>
					<td>
						<select name="causeDepartmentList" style="width: 80%;">
							<option value="" selected="selected">&nbsp;</option>
							<!-- 부서 목록 리스트 추가 -->
							<c:forEach var="item" items="${departmentList }">
								<option value="${item.dept_code }">${item.dept_code } : ${item.dept_name }</option>
							</c:forEach>
						</select>
					</td>
					<td style="text-align: right;">
		                <input type="button" value='Search' class="btn_blue" id="btn_search"/>
	            	</td>
				</tr>
				<tr>
					<th>사번</th>
					<td>
						<select id="designerList" name="designerList" style="width: 80%;">
							<option value="">&nbsp;</option>
							<!-- 사번 목록 리스트 추가 -->
							<c:forEach var="item" items="${partPersonList }">
								<option value="${item.employee_no }"<c:if test="${item.employee_no eq loginUserInfo.designerid }">selected="selected"</c:if>>${item.employee_no }   ${item.employee_name }</option>
							</c:forEach>
							<c:if test="${partPersonList eq null }">
								<option value="${loginUserInfo.designerid}" selected="selected">${loginUserInfo.designerid}   ${loginUserInfo.name}</option>
							</c:if>
						</select>
					</td>
					<th>도면번호</th>
					<td>
						<input type="text" name="drawingNo1" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo2" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo3" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo4" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo5" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo6" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo7" value="" maxlength="1" style="width:5%;"   />
		                <input type="text" name="drawingNo8" value="" maxlength="1" style="width:5%;"   />
		                <input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>OP</th>
					<td> 
						<input type="text" name="opCode" value="" style="width: 80%;" >
                    </td>
                    <th>Event</th>
                    <td>
                    	E1<input type="checkbox" name="e1" value="e1" >
                    	E2<input type="checkbox" name="e2" value="e2" >
                    	E3<input type="checkbox" name="e3" value="e3" >
                    </td>
                    <td></td>
				</tr>
			</table>
		</div>
		<div class="content" id="dataListDiv">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
	<div class="content" style="text-align: right; color: #ff0000;" >
		상근 : <span id="normal_time_total">0</span> 연근 : <span id="overtime_total">0</span> 특근 : <span id="special_time_total">0</span>
	</div>
	<div class="content" style="text-align: right;">
		<input type="button" class="btn_blue" value="출력 & 엑셀" class="button_simple" onclick="printPage();">
	    <input type="button" class="btn_blue" value="확 인" class="button_simple" onclick="javascript:window.close();">
	</div>
</div>
<!-- 호선 선택 div팝업 -->
<div id="projectListDiv" style="position:absolute;display:none; z-index: 9;">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="projectList" id="projectList" style="width:150px;background-color:#fff0f5" onchange="fn_projectChanged(this);">
            <option value="">&nbsp;</option>
            <option value="S000">S000</option>
            <c:forEach var="item" items="${selectedProjectList }">
            	<option value="<c:if test="${item.dl_effective eq null or item.dl_effective eq 'N'}">Z</c:if>${item.projectno }"><c:if test="${item.dl_effective eq null or item.dl_effective eq 'N'}">Z</c:if>${item.projectno }</option>
            </c:forEach>
        </select>
    </td></tr>
    </table>
</div>
<script type="text/javascript">
$(document).ready(function(){
	fn_weekDate("p_created_date_start","p_created_date_end");
	var dates = $( "#p_created_date_start, #p_created_date_end" ).datepicker( {
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames: ['일','월','화','수','목','금','토'],
		dayNamesShort: ['일','월','화','수','목','금','토'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		dateFormat: 'yy-mm-dd',
		showMonthAfterYear: true,
		yearSuffix: '년',
		changeYear : true, //년변경가능
		changeMonth : true, //년변경가능
		onSelect: function( selectedDate ,i) {
			if(this.id == "p_created_date_start"){
				var to_date_ary = selectedDate.split("-");
				$( "#p_created_date_end").val(to_date_ary[0]+"-"+to_date_ary[1]+"-"+( new Date( to_date_ary[0], to_date_ary[1], 0) ).getDate());
			} else {
				var start = $("#p_created_date_start").val().replace(/[^0-9]/g,"");
				var end = selectedDate.replace(/[^0-9]/g,"");
				if(start > end)
				{
					alert("종료날자가 시작날자보다 앞으로 갈 수 없습니다");
					$("#p_created_date_end").val(i.lastVal);					
				}
			}
		}
	} );
	//메뉴바 호선 선택 focus out시에 div 숨김처리
	$("#projectListDiv").focusout(function(e){
		e.preventDefault();
		e.stopPropagation();
		fn_hideProjectSel();
	});
	
	//조회 처리
	$("#btn_search").click(function(){
		if($.trim($("#p_created_date_start").val()) == "" || $.trim($("#p_created_date_end").val()) == ""){
			alert("기간을 정해주세요");
			return;
		}
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="popUpDesignHoursViewMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
	});
});
</script>
<script type="text/javascript">
	//메인 컨테르 jqgrid작업 시작
	//마스터 그리드
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		
		$( "#dataList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['공사번호',
			            '작업일자',
			            '요일',
			            '휴일',
			            '사번',
			            '성명',
			            '부서',
			            '도면번호',
			            'OP코드',
			            '원인파트',
			            '근거',
			            '업무내용',
			            '상근',
			            '연근',
			            '특근',
			            'E1',
			            'E2',
			            'E3'],
			colModel : [{name : 'project_no', index : 'project_no', width: 20, align : "center"},
			            {name : 'workday', index : 'workday', width: 30, align : "center"},
			            {name : 'weekday', index : 'weekday', width: 9, align : "center"},
			            {name : 'holidayyn', index : 'holidayyn', width: 9, align : "center"},
			            {name : 'employee_no', index : 'employee_no', width: 20, align : "center"},
			            {name : 'emp_name', index : 'emp_name', width: 20, align : "center"},
			            {name : 'emp_dept', index : 'emp_dept', width: 20, align : "center"},
			            {name : 'dwg_code', index : 'dwg_code', width: 20, align : "center"},
			            {name : 'op_code', index : 'op_code', width: 70, align : "left"},
			            {name : 'cause_depart', index : 'cause_depart', width: 20, align : "center"},
			            {name : 'basis', index : 'basis', width: 15, align : "center"},
			            {name : 'work_desc', index : 'work_desc', width: 110, align : "left"},
			            {name : 'normal_time', index : 'normal', width: 10, align : "center"},
			            {name : 'overtime', index : 'overtime', width: 10, align : "center"},
			            {name : 'special_time', index : 'special', width: 10, align : "center"},
			            {name : 'event1', index : 'event1', width: 7, align : "center"},
			            {name : 'event2', index : 'event2', width: 7, align : "center"},
			            {name : 'event3', index : 'event3', width: 7, align : "center"}
			           ],
	        gridview : true,
	   		cmTemplate: { title: false },
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true,
	   		height : objectHeight,	   		
	   		rowNum : -1,
	   		rownumbers: true,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pDataList'),
	   		cellEdit : true, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
			beforeProcessing : function(data, status, xhr){
				$("#normal_time_total").text(data.normal_time_total);
				$("#overtime_total").text(data.overtime_total);
				$("#special_time_total").text(data.overtime_total);
		    },
			loadComplete: function (data) {
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				for(var i=0; i<rows.length; i++){
				}
			}
		});
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 넘버링 표시
		$("#dataList").jqGrid("setLabel", "rn", "No");
		
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.58);
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		/* fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() ); */
		
	});	
	
</script>
<script type="text/javascript">
	//관리자 모드에서 부서가 변경되면 사번과 관련된 항목들을 모두 초기화
	function fn_departmentSelChanged(){
		var sabunTagObj = $("#designerList");
	    sabunTagObj.empty();
	    
	    $.ajax({
	    	url:'<c:url value="getPartPersons.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"dept_code" : application_form.departmentList.value},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		sabunTagObj.append("<option value=''>&nbsp;</option>");
	    		for(var i=0; i<jsonData.rows.length; i++){
	    			var rows = jsonData.rows[i];
	    			sabunTagObj.append("<option value='"+rows.employee_no+"'>"+rows.employee_no+" "+rows.employee_name+"</option>");
	    		}
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
	//호선 검색 값 변경
	function fn_projectChanged(obj){
		$("#projectNo").val($(obj).val());
		fn_hideProjectSel();
	}
	//호선 검색view show
	function fn_showProjectSel(obj){
		var activeDivObj = $("#projectListDiv");
		var activeSelectBox = $("#projectList");
		activeDivObj.css("left",$(obj).prev().offset().left);
		activeDivObj.css("top",$(obj).prev().offset().top);
		activeDivObj.css("display","");
		activeSelectBox.find("option:eq(0)").attr("selected","true");
		activeSelectBox.focus().click();
	}
	//호선 검색 view hide
	function fn_hideProjectSel(){
		$("#projectListDiv").css("display","none");
	}
	
	//선택 영역 안 전체 input type text 들 값 제거 
	function clearData(obj){
		var parent = $(obj).closest("td");
		parent.find("input[type=text]").val("");
	}
	//프린트(리포트 출력)
	function printPage()
	{
	    var designerIDSel = application_form.designerList.value;
	    var dateSelectedFrom = application_form.dateSelected_from.value;
	    var dateSelectedTo = application_form.dateSelected_to.value;
	    var projectSel = application_form.projectNo.value;
	    var causeDeptCode = application_form.causeDepartmentList.value;
	    var departmentSel = application_form.departmentList.value;
	    
	    if (projectSel == "" && (dateSelectedFrom == "" || dateSelectedTo == "")) 
	    {
	        alert("조회일자 또는 호선 중 적어도 하나는 지정이 되어야 합니다!");
	        return;
	    }
	
	    /*
	    if (projectSel != "")
	    {
	        application_form.projectSel.options.selectedIndex = 0;
	        for (var i = 0; i < application_form.projectSel.options.length; i++) {
	            if (application_form.projectSel.options[i].value == projectSel) {
	                application_form.projectSel.options.selectedIndex = i;
	                break;
	            }
	        }
	        if (application_form.projectSel.value == "") {
	            alert("올바른 호선이름을 선택하십시오.");
	            return false;
	        }
	    }
	    */
	
		var drawingNo = "";
	    drawingNo += application_form.drawingNo1.value == "" ? "_" : application_form.drawingNo1.value;
	    drawingNo += application_form.drawingNo2.value == "" ? "_" : application_form.drawingNo2.value;
	    drawingNo += application_form.drawingNo3.value == "" ? "_" : application_form.drawingNo3.value;
	    drawingNo += application_form.drawingNo4.value == "" ? "_" : application_form.drawingNo4.value;
	    drawingNo += application_form.drawingNo5.value == "" ? "_" : application_form.drawingNo5.value;
	    drawingNo += application_form.drawingNo6.value == "" ? "_" : application_form.drawingNo6.value;
	    drawingNo += application_form.drawingNo7.value == "" ? "_" : application_form.drawingNo7.value;
	    drawingNo += application_form.drawingNo8.value == "" ? "_" : application_form.drawingNo8.value;
	    if (drawingNo == "________") drawingNo = "";
	    else drawingNo = "%" + drawingNo + "%";
	
	    var opCode = application_form.opCode.value;
	    var e1 = application_form.e1.checked ? "Y" : "N";
	    var e2 = application_form.e2.checked ? "Y" : "N";
	    var e3 = application_form.e3.checked ? "Y" : "N";
	
	    var paramStr = designerIDSel + ":::" + 
	                   dateSelectedFrom + ":::" + 
	                   dateSelectedTo + ":::" + 
	                   projectSel + ":::" + 
	                   causeDeptCode + ":::" + 
	                   drawingNo + ":::" +  
	                   opCode + ":::" +  
	                   e1 + ":::" +  
	                   e2 + ":::" +  
	                   e3 + ":::" +  
	                   departmentSel; 
	                   
	    // TEST는 STXDPDEV/WebReport.jsp로 잡아줘야할듯.
	    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInputNew_InputListView.mrd&param=" + paramStr; //LIVE
	    window.open(urlStr);
	}
</script>
</body> 
</html>