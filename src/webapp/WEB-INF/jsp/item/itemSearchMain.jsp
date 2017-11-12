<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Item Search Main</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="wrap">
			<form id="application_form" name="application_form">
				<%
					String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString();
				%>
				<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag%>" />
				<input type="hidden" id="main_code" name="main_code" />
				<input type="hidden" id="item_code" name="item_code" />
				<input type="hidden" id="rev_no" name="rev_no" />
				<input type="hidden" id="states_desc" name="states_desc" />
				<table id="itemSearchMainList"></table>
			</form>
		</div>
		<script type="text/javascript">
		var main_code = window.parent.$( "#main_code" ).val();
		var item_code = window.parent.$( "#item_code" ).val();
		var rev_no = window.parent.$( "#rev_no" ).val();
		var states_desc = window.parent.$( "#states_desc" ).val();
		
		$( "#main_code" ).val( main_code );
		$( "#item_code" ).val( item_code );
		$( "#rev_no" ).val( rev_no );
		$( "#states_desc" ).val( states_desc );
		
		$(document).ready( function() {
			$( "#itemSearchMainList" ).jqGrid( {
				url : 'itemSearchMainList.do',
				datatype : 'json',
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ '속성', '속성값', '속성', '속성값' ],
				colModel : [ { name : 'key1', index : 'key1', width : 10, editable : true }, 
				             { name : 'value1', index : 'value1', width : 50, editable : true }, 
				             { name : 'key2', index : 'key2', width : 10, editable : true },
				             { name : 'value2', index : 'value2', width : 50, editable : true } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
// 				multiselect : true,
				autowidth : true,
				height : screen.height * 0.1,
				caption : "Item Attribute",
			    hidegrid: false,
				rowNum : -1,
				//loadonce:true,
				//pager: jQuery('#dwgInformationList'),
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
				imgpath : 'themes/basic/images'
			} );

			fn_jqGridsetHeight($("#divCloseFlag").val(), "itemSearchMainList", screen.height);
			
			if( item_code == "" ) {
				$( "#itemSearchMainList" ).jqGrid( "setCaption", 'Item Attribute' );
			} else {
				var titles = "Item Attribute - " + item_code;
				
				if( rev_no != "" )
					titles += " (" + rev_no + ")";
				
				if( states_desc != "" )
					titles += " (" + states_desc + ")";
				
				$( "#itemSearchMainList" ).jqGrid( "setCaption", titles );
			}

		} ); //end of ready function

// 		function fn_jqGridsetHeight( divCloseFlag ) {
// 			if ( divCloseFlag == "true" ) {
// 				fn_setHeight( "itemSearchMainList", screen.height * 0.48 );
// 			} else {
// 				fn_setHeight( "itemSearchMainList", screen.height * 0.08 );
// 			}
// 		}
		</script>
	</body>
</html>