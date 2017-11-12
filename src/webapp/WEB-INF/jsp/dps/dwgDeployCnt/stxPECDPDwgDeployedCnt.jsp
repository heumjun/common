<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>도면 출도 건 수 조회</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">

    .ui-jqgrid tr.jqgrow td:nth-child(1),.ui-jqgrid tr.jqgrow td:nth-child(2){
        word-wrap: break-word; /* IE 5.5+ and CSS3 */
        white-space: pre-wrap; /* CSS3 */
        white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
        white-space: -pre-wrap; /* Opera 4-6 */
        white-space: -o-pre-wrap; /* Opera 7 */
        overflow: hidden;
        height: auto;
        vertical-align: middle;
        padding: 0px;
    }
</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		도면 출도 건 수 조회
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="dwgDepartmentCode" value="${loginUserInfo.dwg_deptcode}" />
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="3%"/>
				<col width="20%"/>
				<col width="2%"/>
				<col width="10%"/>
				<col width="2%"/>
				<col width="8%"/>
				<col width="5%"/>
				<col width="1%"/>
				<col width="*"/>
				<tr>
					<th>호선</th>
					<td>
						<input type="text" name="projectList" value="" onkeyup="checkInputAZ09(this);" onchange="onlyUpperCase(this);" id="p_project_no" style="width: 50%;"/>(입력시','로 구분)
						<input type="button" name="ProjectsButton" value="검색" class="btn_gray2" id="btn_project_no"/>
						<!-- 어드민옵션있음 나중에 추가-->
						<c:if test="${loginUserInfo.is_admin eq 'Y'}">
							<input type="button" name="" value="조회가능 호선관리" class="btn_gray2" id="btn_project_serach_able"/>
						</c:if>
					</td>
					<th>부서</th>
					<td>
						<select name="departmentList" style="width:250px;">
						<c:choose>
							<c:when test="${loginUserInfo.is_admin ne 'Y'}">
								 <option value="${loginUserInfo.dept_code}">${loginUserInfo.dept_code}&nbsp;&nbsp;&nbsp;&nbsp;${loginUserInfo.dept_name}</option>
							</c:when>
							<c:otherwise>
								<option value="">&nbsp;</option>
								<!-- 부서 목록 리스트 추가 -->
								<c:forEach var="item" items="${departmentList }">
									<option value="${item.dept_code }" <c:if test="${item.dept_code eq loginUserInfo.dept_code }">selected="selected"</c:if> >${item.dept_code } : ${item.dept_name }</option>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						</select>
					</td>
					<th>기간	</th>
					<td>
	                	<input type="text" id="p_created_date_start" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 65px;" readonly="readonly"/>
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 65px;"  readonly="readonly"/>
					</td>
					<td style="text-align: right;" colspan="2">
		                <input type="button" value='조 회' class="btn_blue" id="btn_search"/>
	            	</td>
				</tr>
				<tr>
					<td colspan="8">
		                <input type="checkbox" name="includeSeries" value="true">Series 포함&nbsp;&nbsp;&nbsp;
		                <input type="checkbox" name="includeEarlyRev" value="true">시공 전 개정도 포함
		            </td>
				</tr>
			</table>
		</div>
	</form>
	<form id="application_form1" name="application_form1">
		<div class="content">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
</div>
<script type="text/javascript">
	$( function() {
		
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
			changeMonth : true,			
			onSelect: function( selectedDate ) {
				var option = this.id == "p_created_date_start" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		} );
	});

	$(document).ready(function(){
		fn_weekDate("p_created_date_start","p_created_date_end" );
		//호선 검색 팝업 호출
		$("#btn_project_no").click(function() {
			
	        var paramStr = "selectedProjects=" + application_form.projectList.value;
	        paramStr += "&loginID=" + application_form.loginID.value;
	        paramStr += "&category=DEPLOY";
			
			var rs = window.showModalDialog("popUpProjectSelectWin.do?"+paramStr, 
					window, "dialogHeight:500px;dialogWidth:600px; center:on; scroll:off; status:off");
	
			if(rs != null || rs != undefined){
				$("#p_project_no").val(rs);
			}
		});
		
		// 조회가능 호선관리 창을 Show
		$("#btn_project_serach_able").click(function(){
			var sProperties = 'dialogHeight:500px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
		    var paramStr = "loginID=" + application_form.loginID.value;
		    paramStr += "&category=DEPLOY";
		    
		    var rs = window.showModalDialog("popUpProjectSelectMng.do?" + paramStr, "", sProperties);
		});
		
		//조회 실행처리
		$("#btn_search").click(function(){
			// 조회기간이 한 달 이내(Series 포함인 경우 1주일 이내)인지 체크
	        var sDateFrom = application_form.dateSelected_from.value;
	        var sDateTo = application_form.dateSelected_to.value;
	        var tempArray = sDateFrom.split("-");
	        var dateFromObj = new Date(tempArray[0], tempArray[1] - 1, tempArray[2]);
	        tempArray = sDateTo.split("-");
	        var dateToObj = new Date(tempArray[0], tempArray[1] - 1, tempArray[2]);
	        
	        if (dateToObj - dateFromObj < 0) {
	            var tempObj = dateFromObj;
	            dateFromObj = dateToObj;
	            dateToObj = tempObj;
	        }
	        var iDayDiff = (dateToObj - dateFromObj) / 86400000;
	        if (!application_form.includeSeries.checked && iDayDiff >= 31) {
	            alert("조회기간은 한 달(31일)을 초과할 수 없습니다!");
	            return;
	        }
	        else if (application_form.includeSeries.checked && iDayDiff >= 7) {
	            alert("Series 포함인 경우, 조회기간은 일주일(7일)을 초과할 수 없습니다!");
	            return;
	        }
	        change = false;
	      	//그리드 갱신을 위한 작업
			$( '#dataList' ).jqGrid( 'clearGridData' );
			//그리드 postdata 초기화 후 그리드 로드 
			$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
			$( '#dataList' ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : '<c:url value="dwgDeployCntMainGrid.do"/>',
				datatype : 'json',
				page : 1,
				postData :$('#application_form').serializeArray()
			} ).trigger( 'reloadGrid' );
		});
		
	});
	
	function checkInputAZ09(obj){
		var num_check=/^[A-Za-z0-9,]*$/;
		$(obj).val($(obj).val().toUpperCase());
		if(!num_check.test($(obj).val())){
			alert("Invalid Text. Ex.F9999;F9998 !");
			$(obj).val($(obj).val().substr(0,$(obj).val().length-1));
			return;
		}
	}
</script>

<script type="text/javascript">
	var change = false;
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
			colNames : ['팀','파트',
			            <c:forEach var="item" items="${reasonCodeList}" varStatus="status">
						'<c:out value="${item.eco_code}"/>'<c:if test="${not status.last }">,</c:if>
						</c:forEach>
			            ,'계'],
			colModel : [{name : 'up_dept_name', index : 'up_dept_name', width: 10, align : "center"},
			            {name : 'dept_name', index : 'dept_name', width: 20, align : "center"},
			            <c:forEach var="item" items="${reasonCodeList}" varStatus="status">
			            {name : '<c:out value="${item.eco_code }"/>', index : '<c:out value="${item.eco_code }"/>', width: 15, align : "center", formatter:'integer',summaryType:'sum'},
						</c:forEach>
			            {name : 'sum', index : 'sum', width: 20, align : "center",formatter:'integer',summaryType:'sum'}
			           ],
	        gridview : true,
	   		cmTemplate: { title: false },
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true, //autowidth: true,
	   		height : objectHeight,
	   		pager: "#jqGridPager",
	   		rowNum : -1,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pDataList'),
	   		cellEdit : false, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
		    footerrow:true,
		    userDataOnFooter:true,
	   		beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
	   		},
	   		beforeProcessing : function (data, status, xhr){
	   			
	   		},
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
			ondblClickRow : function(rowId,iRow,colId) {
			},
			onCellSelect : function( rowId, colId, content, event) {
				/* var rowData = jQuery(this).getRowData(rowId);
				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				
				var deptcode = $( "#dataList" ).getCell( rowId, cm[colId].name );
				alert(deptcode); */
			},
			loadComplete: function (data) {
				//데이터를 그리드에 맞게 변경처리
				var $this = $(this);
	   			var refreshObj = [];
	   			var temp_up_dept_name = '';
	   			var temp_dept_name = '';
	   			var rowObj = {};
	   			var rowArray = {};
	   			$.each(data.rows,function(index){
	   				
	   				if(temp_up_dept_name != data.rows[index].up_dept_name && temp_dept_name != data.rows[index].dept_name){
	   					if(!$.isEmptyObject(rowObj)){
	   						refreshObj.push(rowObj);
	   						rowObj = {};
	   					}
	   					
	   					temp_up_dept_name = data.rows[index].up_dept_name;
	   					temp_dept_name = data.rows[index].dept_name;
	   					rowObj['up_dept_name'] = data.rows[index].up_dept_name;
	   					rowObj['dept_name'] = data.rows[index].dept_name;
	   					
	   				}
	   				rowObj[data.rows[index].reason_code.trim()] = data.rows[index].cnt;
	   				
   				});
	   			if(!$.isEmptyObject(rowObj)){
						refreshObj.push(rowObj);
				}
	   			data.rows = refreshObj;
	   			
	   			change = true;
	   			$( "#dataList" )[0].addJSONData(data.rows);
			},
			gridComplete : function() {
				//DataSum 합계 구하는 처리
				if(!change) return;
				var rows = $( "#dataList" ).getDataIDs();
				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				for( var i = 0; i < rows.length; i++ ) {
					var sum = 0;
					for(var c = 0; c < cm.length; c++){
						if(c > 1 && c != (cm.length-1)){
							if(!isNaN(parseInt($( "#dataList" ).getCell( rows[i], cm[c].name ))))
							sum += parseInt($( "#dataList" ).getCell( rows[i], cm[c].name ));
						}
					}
					$('#dataList').jqGrid('setCell',rows[i], 'sum', sum);
				}
				var totalSum = $("#dataList").jqGrid('getCol', 'sum',false,'sum');
				<c:forEach var="item" items="${reasonCodeList}" varStatus="status">
					var total<c:out value="${item.eco_code }"/> = $("#dataList").jqGrid('getCol', '<c:out value="${item.eco_code }"/>',false,'sum');
				</c:forEach>
				var totalB1 = $("#dataList").jqGrid('getCol', 'B1',false,'sum');
				$('#dataList').jqGrid('footerData','set',{dept_name:"합계 :", 
					<c:forEach var="item" items="${reasonCodeList}" varStatus="status">
					<c:out value="${item.eco_code }"/>:total<c:out value="${item.eco_code }"/>,
					</c:forEach>
					sum:totalSum});
				
			}
		});
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() );
		//그룹헤더 3단 처리
		$("#dataList").jqGrid('setGroupHeaders', {
			  useColSpanStyle: true, 
			  groupHeaders:[
				<c:set var="group_code" value="" />
                <c:forEach var="item" items="${reasonCodeList}" varStatus="status">
                	<c:if test="${item.eco_group != group_code}">
               			{startColumnName: '<c:out value="${item.eco_code }"/>', numberOfColumns: '<c:out value="${item.code_cnt }"/>', titleText: '<c:out value="${item.eco_group }"/>'}<c:if test="${not status.last }">,</c:if>
                		<c:set var="group_code" value="${item.eco_group}"/>
                	</c:if>
				</c:forEach>
			  ]
		});
	});	
</script>
</body>
</html>