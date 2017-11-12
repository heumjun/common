<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>History</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
	<div id="wrap">
		<form id="application_form" name="application_form">
			<%-- <%
				String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString();
			%> --%>
			<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
			<input type="hidden" name="main_code" id="main_code" />
<!-- 			<input type="hidden" name="sTypeName" id="sTypeName" /> -->
			<input type="hidden" name="p_main_name" id="p_main_name" />
			<input type="hidden" name="p_main_type" id="p_main_type" />
			<%-- <input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag%>" /> --%>
<!-- 			<div class="searchArea"> -->
<!-- 			<span class="pop_tit">Action Type</span> &nbsp;&nbsp; -->
<!-- 			<input type="checkbox" name="historyConnect" value="Connect" checked /> -->
<!-- 			Connect -->
<!-- 			&nbsp; -->
<!-- 			<input type="checkbox" name="historyDisconnect" value="Disconnect" checked /> -->
<!-- 			Disconnect -->
<!-- 			&nbsp; -->
<!-- 			<input type="checkbox" name="historyCreate" value="Create" checked /> -->
<!-- 			Create -->
<!-- 			&nbsp; -->
<!-- 			<input type="checkbox" name="historyDelete" value="Delete" checked /> -->
<!-- 			Delete -->
<!-- 			&nbsp; -->
<!-- 			<input type="checkbox" name="historyModify" value="Modify" checked /> -->
<!-- 			Modify -->
<!-- 			&nbsp; -->
<!-- 			<input type="checkbox" name="historyPromote" value="Promote" checked /> -->
<!-- 			Promote -->
<!-- 			&nbsp; -->
<!-- 			<input type="checkbox" name="historyDemote" value="Demote" checked /> -->
<!-- 			Demote &nbsp;&nbsp; -->
<!-- 			<span class="pop_tit">Message</span> -->
<!-- 			<input type="text" id="val5" name="val5" style="width: 190px;" /> -->
<!-- 			<input type="button" id="btnfind" value="조회" class="btn_blue"/> -->
<!-- 			</div> -->

				<div id = "historyDiv" style="margin-top : 10px;" >
					<table id="history"></table>
					<div id="phistory"></div>
				</div>
		</form>
		</div>
		<script type="text/javascript">
		var maincode = window.parent.$("#main_code").val();
		var main_name = window.parent.$("#ref_main_name").val();
		var main_type = window.parent.$("#states_type").val();
		

// 		var item_code = window.parent.$("#item_code").val();
// 		var rev_no = window.parent.$("#rev_no").val();
// 		var states_desc = window.parent.$("#states_desc").val();

		$("#main_code").val(maincode);
		$("#p_main_name").val(main_name);
		$("#p_main_type").val(main_type);

		$(document).ready( function() {
			$( "#history" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'ecrHistoryList.do',
				postData : fn_getFormData("#application_form"),
				editUrl : 'clientArray',
				colNames : [ 'INSERT_DATE', '수정자', 'ACTION_TYPE', 'NAME', 
				             'Related ECR', 'ECO Cause', '생성자', '결재자', '상태', 'Project', 'ECO Description', '',
				             '상태', 'Related Project', '기술변경내용', '관련자', '기술변경원인', '평가자', '결재자', '작업자', '작성자',
				             'MAIN_TYPE' ],
				colModel : [ { name : 'insert_date', index : 'insert_date', width : 110, align : 'center', sortable : false },
				             { name : 'insert_empno', index : 'insert_empno', width : 220, sortable : false},
				             { name : 'action_type', index : 'action_type', width : 100, sortable : false, hidden : true },
				             { name : 'main_name', index : 'main_name', width : 70, align : 'center', sortable : false },
				             
				             { name : 'eco_attr1', index : 'eco_attr1', width : 70, align : 'center', sortable : false },
				             //{ name : 'eco_attr2', index : 'eco_attr2', width : 50, align : 'center', sortable : false },
				             { name : 'eco_attr3', index : 'eco_attr3', width : 200, sortable : false },
				             { name : 'eco_attr4', index : 'eco_attr4', width : 220, sortable : false },
				             { name : 'eco_attr5', index : 'eco_attr5', width : 220, sortable : false },
				             { name : 'eco_attr6', index : 'eco_attr6', width : 70, sortable : false },
				             { name : 'eco_attr7', index : 'eco_attr7', width : 70, sortable : false },
				             { name : 'eco_attr8', index : 'eco_attr8', width : 220, sortable : false },
				             { name : 'eco_attr9', index : 'eco_attr9', width : 100, sortable : false },
				             
				             { name : 'ecr_attr1', index : 'ecr_attr1', width : 70, sortable : false },
				             { name : 'ecr_attr2', index : 'ecr_attr2', width : 120, sortable : false },
				             { name : 'ecr_attr3', index : 'ecr_attr3', width : 250, sortable : false },
				             { name : 'ecr_attr4', index : 'ecr_attr4', width : 220, sortable : false },
				             { name : 'ecr_attr5', index : 'ecr_attr5', width : 200, sortable : false },
				             { name : 'ecr_attr6', index : 'ecr_attr6', width : 220, sortable : false },
				             { name : 'ecr_attr7', index : 'ecr_attr7', width : 220, sortable : false },
				             { name : 'ecr_attr8', index : 'ecr_attr8', width : 220, sortable : false },
				             { name : 'ecr_attr9', index : 'ecr_attr9', width : 220, sortable : false },
				             
				             { name : 'main_type', index : 'main_type', width : 100, sortable : false, hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				//shrinkToFit:false,
				autowidth : true,
				height : parent.objectHeight-135,
				rowNum : -1,
				caption : "History",
				pager : $('#phistory'),
				hidegrid : false,
// 				pager : $('#mainHistoryList'),
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					var rowData = $(this).getRowData( rowid );
					
					var emp_no = rowData['emp_no'];
					var user_name = rowData['user_name'];

					var returnValue = new Array();
					returnValue[0] = emp_no;
					returnValue[1] = user_name;
					window.returnValue = returnValue;
					self.close();
				}
			} );
			
			//fn_jqGridsetHeight( $("#divCloseFlag").val(), "history", screen.height );
			
			var titles = "";
			if( main_name != "" ) {
				titles = "History - " + main_name;
			} else {
				titles = "History";
			}
				
// 			if ( item_code != undefined ) {
// 				var titles = "History - " + item_code;

// 				if ( rev_no != "" )
// 					titles += " (" + rev_no + ")";

// 				if ( states_desc != "" )
// 					titles += " (" + states_desc + ")";

// 				$( "#history" ).jqGrid( "setCaption", titles );
// 			} else if( main_name != undefined ) {
// 				$( "#history" ).jqGrid( "setCaption", 'History - ' + main_name );
// 			} else {
				$( "#history" ).jqGrid( "setCaption", titles );
// 			}


			fn_setGridCol();

			$( '#btnfind' ).click( function() {
				fn_search();
			} );
			
			fn_gridresize( parent.objectWindow, $( "#history" ),-100,0.5 );
		} );
		
		function fn_search() {
// 			var maincode = parent.document.getElementById("main_code").value;
// 			var sTypeName = parent.document.getElementById("sTypeName").value;

// 			$("#main_code").val(maincode);
// 			$("#sTypeName").val(sTypeName);
			if(window.parent.$("#main_code").val() == "") {
				//alert('ECO 선택후 조회 바랍니다.');
			} else {
				$("#main_code").val(window.parent.$("#main_code").val());
				$("#p_main_name").val(window.parent.$("#ref_main_name").val());
				$("#p_main_type").val(window.parent.$("#states_type").val());
				$("#history").jqGrid("setCaption", 'History - ' + window.parent.$("#ref_main_name").val());
				var sUrl = "ecrHistoryList.do";
				$( "#history" ).jqGrid( 'setGridParam', {
					mtype : 'POST',
					url : sUrl,
					page : 1,
					postData : fn_getFormData("#application_form")
				} ).trigger( "reloadGrid" );
			}
		}
		
		function fn_setGridCol( objId ) {
			
			if( $( "#p_main_type" ).val() == "ECO" ) {
				$( "#history" ).showCol( "eco_attr1" );
				$( "#history" ).showCol( "eco_attr2" );
				$( "#history" ).showCol( "eco_attr3" );
				$( "#history" ).showCol( "eco_attr4" );
				$( "#history" ).showCol( "eco_attr5" );
				$( "#history" ).showCol( "eco_attr6" );
				$( "#history" ).showCol( "eco_attr7" );
				$( "#history" ).showCol( "eco_attr8" );
				$( "#history" ).hideCol( "eco_attr9" );
				$( "#history" ).hideCol( "ecr_attr1" );
				$( "#history" ).hideCol( "ecr_attr2" );
				$( "#history" ).hideCol( "ecr_attr3" );
				$( "#history" ).hideCol( "ecr_attr4" );
				$( "#history" ).hideCol( "ecr_attr5" );
				$( "#history" ).hideCol( "ecr_attr6" );
				$( "#history" ).hideCol( "ecr_attr7" );
				$( "#history" ).hideCol( "ecr_attr8" );
				$( "#history" ).hideCol( "ecr_attr9" );
			} else {
				$( "#history" ).showCol( "ecr_attr1" );
				$( "#history" ).showCol( "ecr_attr2" );
				$( "#history" ).showCol( "ecr_attr3" );
				$( "#history" ).showCol( "ecr_attr4" );
				$( "#history" ).showCol( "ecr_attr5" );
				$( "#history" ).showCol( "ecr_attr6" );
				$( "#history" ).showCol( "ecr_attr7" );
				$( "#history" ).showCol( "ecr_attr8" );
				$( "#history" ).showCol( "ecr_attr9" );
				$( "#history" ).hideCol( "eco_attr1" );
				$( "#history" ).hideCol( "eco_attr2" );
				$( "#history" ).hideCol( "eco_attr3" );
				$( "#history" ).hideCol( "eco_attr4" );
				$( "#history" ).hideCol( "eco_attr5" );
				$( "#history" ).hideCol( "eco_attr6" );
				$( "#history" ).hideCol( "eco_attr7" );
				$( "#history" ).hideCol( "eco_attr8" );
				$( "#history" ).hideCol( "eco_attr9" );
			}
			
			//resizeJqGridWidth();
		}
		
		function resizeJqGridWidth() {
			// window에 resize 이벤트를 바인딩 한다. 
			$(window).bind( 'resize', function() {
				// 그리드의 width 초기화
// 				$( '#history' ).setGridWidth(0);
				// 그리드의 width를 div 에 맞춰서 적용
				$( '#history' ).setGridWidth( $( '.content' ).width()-10 );
				//Resized to new width as per window
			} ).trigger( 'resize' );
		}
		</script>
	</body>
</html>
