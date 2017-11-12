<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Route</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
	<div id="wrap">
		<form id="application_form" name="application_form">
			<input type="hidden" id="main_code" name="main_code" />
			<input type="hidden" id="states_code" name="states_code" />
			<input type="hidden" id="states_desc" name="states_desc" />
			<input type="hidden" id="states_type" name="states_type" />
			<input type="hidden" id="states_main_category" name="states_main_category" />
			<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
			<input type="hidden" name="main_name" id="main_name" />
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			<div id="routeListDiv" style="margin-top: 10px;" >
				<table id="routeList"></table>
				<div id="prouteList"></div>
			</div>
		</form>
		</div>
		<script type="text/javascript">
			var resultData = [];
			var maincode = window.parent.$("#main_code").val();
			var states_code = window.parent.$("#states_code").val();
			var states_type = window.parent.$("#states_type").val();
			var states_main_category = window.parent.$("#states_main_category").val();
			var states_desc = window.parent.$("#states_desc").val();
			var main_name = window.parent.$("#ref_main_name").val();
			
			$("#main_code").val( maincode );
			$("#states_code").val( states_code );
			$("#states_type").val( states_type );
			$("#states_main_category").val( states_main_category );
			$("#states_desc").val( states_desc );
			$( "#main_name" ).val( main_name );
			
			$(document).ready( function() {
				$("#routeList").jqGrid( {
					datatype : 'json',
					mtype : '',
					url : '',
					editUrl : 'clientArray',
					colNames : [ '순서', 'User Name' ],
					colModel : [
									{ name : 'seq', index : 'seq', width : 85, editable : false, align : "center" },
									{ name : 'user_name', index : 'user_name', width : 500, editable : false, align : "left" },
								],
					gridview : true,
					cmTemplate: { title: false },
					toolbar : [ false, "bottom" ],
					viewrecords : true,
					autowidth : true,
					//shrinkToFit : false,
					height : parent.objectHeight-135,
					rowNum : -1,
					
					caption : "Route",
					hidegrid: false,
					emptyrecords : '데이터가 존재하지 않습니다. ',
					pager : jQuery('#prouteList'),
					pgbuttons : false,
					pgtext : false,
					pginput : false,
					cellEdit : true, // grid edit mode 1
					cellsubmit : 'clientArray', // grid edit mode 2
					jsonReader : {
						root : "rows",
						page : "page",
						total : "total",
						records : "records",
						repeatitems : false,
					},
					imgpath : 'themes/basic/images'
				} );
				
				//fn_jqGridsetHeight( $( "#divCloseFlag" ).val(), "routeList", screen.height );
				
				if( main_name == "" ) {
					$("#routeList").jqGrid( "setCaption", 'Route' );
				} else {
					$("#routeList").jqGrid( "setCaption", 'Route - ' + main_name );
				}
				fn_gridresize(parent.objectWindow, $( "#routeList" )  ,-100,0.5 );
			} );
			function fn_search() {
				if(window.parent.$("#main_code").val() == "") {
					alert('ECR 선택후 조회 바랍니다.');
				} else {
					$("#states_code").val(window.parent.$("#states_code").val());
					$("#states_desc").val(window.parent.$("#states_desc").val());
					$("#main_code").val(window.parent.$("#main_code").val());
					$("#routeList").jqGrid("setCaption", 'Route - ' + window.parent.$("#ref_main_name").val());
					var sUrl = "ecrRouteList.do"
					$("#routeList").jqGrid('setGridParam', {
						url : sUrl,
						mtype : 'POST',
						page : 1,
						postData : $("#application_form").serialize()
					}).trigger("reloadGrid");

					//재조회 후 promotedemmote 숨김
					//$("#promotedemmote").hide();
					//$("#ecoLifeCycleList").setGridHeight(295);
				}
			}
// 			function fn_jqGridsetHeight( divCloseFlag ){
// 				if( divCloseFlag == "true" ) {
// 					fn_setHeight( "routeList", screen.height * 0.48 );
// 			    }else{
// 			    	fn_setHeight( "routeList", screen.height * 0.08 );
// 			    }
// 			}

		</script>
	</body>
</html>
