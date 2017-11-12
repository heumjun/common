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
<title>실적 입력관리</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="loginID" value='<c:out value="${loginID }"/>'/>
				<table width="100%"cellSpacing="0" cellpadding="6" border="0">
					<tr>
						<td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
				            B<br>A<br>S<br>I<br>C<br>
				        </td>
				        <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
				            <input type="checkbox" name="ball" style="width:9pt;" onclick="toggleChecks(this);" />ALL<br>
				            <input type="checkbox" name="basic[0]" value="DWS" <c:if test="${fn:contains(slDWGTypeKind,'기본도|DWS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Design Start<br>
				            <input type="checkbox" name="basic[1]" value="DWF" <c:if test="${fn:contains(slDWGTypeKind,'기본도|DWF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true" />Design Finish<br>
				            <input type="checkbox" name="basic[2]" value="OWS" <c:if test="${fn:contains(slDWGTypeKind,'기본도|OWS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>OwnerApp.Submit<br>
				            <input type="checkbox" name="basic[3]" value="OWF" <c:if test="${fn:contains(slDWGTypeKind,'기본도|OWF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>OwnerApp.Receive<br>
				            <input type="checkbox" name="basic[4]" value="CLS" <c:if test="${fn:contains(slDWGTypeKind,'기본도|CLS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>ClassApp.Submit<br>
				            <input type="checkbox" name="basic[5]" value="CLF" <c:if test="${fn:contains(slDWGTypeKind,'기본도|CLF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>ClassApp.Receive<br>
				            <input type="checkbox" name="basic[6]" value="RFS" <c:if test="${fn:contains(slDWGTypeKind,'기본도|RFS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Issued for Working<br>
				            <input type="checkbox" name="basic[7]" value="WKS" <c:if test="${fn:contains(slDWGTypeKind,'기본도|WKS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Issued for Const<br>
				        </td>
				        <td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
				            M<br>A<br>K<br>E<br>R<br>
				        </td>
				        <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
				            <input type="checkbox" name="mall" style="width:9pt;" onclick="toggleChecks(this);" />ALL<br>
				            <input type="checkbox" name="maker[0]" value="DWS" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|DWS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>P.R.<br>
				            <input type="checkbox" name="maker[1]" value="DWF" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|DWF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Vender Selection<br>
				            <input type="checkbox" name="maker[2]" value="OWS" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|OWS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>P.O.<br>
				            <input type="checkbox" name="maker[3]" value="OWF" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|OWF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>VenderDwg.Receive<br>
				            <input type="checkbox" name="maker[4]" value="CLS" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|CLS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>OwnerApp.Submit<br>
				            <input type="checkbox" name="maker[5]" value="CLF" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|CLF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>OwnerApp.Receive<br>
				            <input type="checkbox" name="maker[6]" value="RFS" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|RFS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Issued for Working<br>
				            <input type="checkbox" name="maker[7]" value="WKS" <c:if test="${fn:contains(slDWGTypeKind,'MAKER|WKS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Issued for Const<br>
				        </td>
				        <td style="font-size:7pt;font-weight:bold;line-height:8px;background-color:#bbbbbb;padding-left:1px;width:8px;">
				            P<br>R<br>O<br>D<br>U<br>C<br>T
				        </td>
				        <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
				            <input type="checkbox" name="pall" style="width:9pt;" onclick="toggleChecks(this);" />ALL<br>
				            <input type="checkbox" name="product[0]" value="DWS" <c:if test="${fn:contains(slDWGTypeKind,'생설도|DWS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Design Start<br>
				            <input type="checkbox" name="product[1]" value="DWF" <c:if test="${fn:contains(slDWGTypeKind,'생설도|DWF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Design Finish<br>
				            <input type="checkbox" name="product[2]" value="OWS" <c:if test="${fn:contains(slDWGTypeKind,'생설도|OWS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>OwnerApp.Submit<br>
				            <input type="checkbox" name="product[3]" value="OWF" <c:if test="${fn:contains(slDWGTypeKind,'생설도|OWF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>OwnerApp.Receive<br>
				            <input type="checkbox" name="product[4]" value="CLS" <c:if test="${fn:contains(slDWGTypeKind,'생설도|CLS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>ClassApp.Submit<br>
				            <input type="checkbox" name="product[5]" value="CLF" <c:if test="${fn:contains(slDWGTypeKind,'생설도|CLF')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>ClassApp.Receive<br>
				            <input type="checkbox" name="product[6]" value="RFS" <c:if test="${fn:contains(slDWGTypeKind,'생설도|RFS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Issued for Working<br>
				            <input type="checkbox" name="product[7]" value="WKS" <c:if test="${fn:contains(slDWGTypeKind,'생설도|WKS')}">checked</c:if>  style="width:9pt;" onclick="checkboxAreaChanged = true"/>Issued for Const<br>
				        </td>
					</tr>
				</table>
				<div id="dataListDiv">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="확인"  id="btnOk" class="btn_blue" onclick="fn_saveProject('dataList');"/>
			<input type="button" value="취소"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
<script type="text/javascript">
var checkboxAreaChanged = false;
//체크항목을 모두 체크 or 모두 체크 해제
function toggleChecks(obj)
{
	var checked =$(obj).is(":checked"); 
	$(obj).nextAll().prop("checked",checked);
}
</script>
<script type="text/javascript">
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			url:'progressProjectDateChange.do',
			datatype: "json",
			postData : fn_getFormData( "#application_form" ),
			colNames : ['호선','MAKER','기본도','생설도','oper'],
			colModel : [{name : 'projectno', index : 'projectno', width: 220, align : "center" },
			            {name : 'm_kind', index : 'm_kind', width: 120, align : "center"},
						{name : 'b_kind', index : 'b_kind', width: 120, align : "center"},
						{name : 'p_kind', index : 'p_kind', width: 120, align : "center"},
						{name : 'oper', index : 'oper', width: 120, align : "center", hidden:true}
			           ],
			gridview : true,
			cmTemplate: { title: false,sortable: false },
			toolbar : [ false, "bottom" ],
			hidegrid: false,
			viewrecords : true,
			caption : '선택 호선',
			autowidth : true, //autowidth: true,
			height : objectHeight,
			rowNum : -1,
			emptyrecords : '데이터가 존재하지 않습니다. ',
			pager : jQuery('#pDataList'),
			cellEdit : false, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			},
			jsonReader : {
				//id : "item_code",
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
			},
			ondblClickRow : function(rowId,irow,icol,e) {
				var rowData = jQuery(this).getRowData(rowId);
				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				var colName = cm[icol].name;
				var kind = rowData[colName];
				
		        if (kind == "OPENED")$( "#dataList" ).jqGrid( 'setCell', rowId, colName,"CLOSED",{background : "#fff0f5"});
		        else if (kind == "CLOSED") $( "#dataList" ).jqGrid( 'setCell', rowId, colName,"OPENED",{background : "#ffffff"});
		        $( "#dataList" ).jqGrid( 'setCell', rowId, 'oper', 'U');
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				for(var i=0; i<rows.length; i++){
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					var ableColor = "#fff0f5";
	                var disableColor = "#ffffff";
	                
	                var colorB = disableColor;
	                var colorM = disableColor;
	                var colorP = disableColor;
	                
	                var textB = "OPENED";
	                var textM = "OPENED";
	                var textP = "OPENED";
	                
	                if(rowData.b_kind != null && $.trim(rowData.b_kind) != "")
	                {
	                	textB = "CLOSED";
	                	colorB = ableColor;
	                }
	                if(rowData.m_kind != null && $.trim(rowData.m_kind) != "")
	                {
	                	textM = "CLOSED";
	                	colorM = ableColor;
	                }
	                if(rowData.p_kind != null && $.trim(rowData.p_kind) != "")
	                {
	                	textP = "CLOSED";
	                	colorP = ableColor;
	                }
	                $( "#dataList" ).jqGrid( 'setCell', rows[i], 'b_kind', textB, { color : 'black', background : colorB } );
	                $( "#dataList" ).jqGrid( 'setCell', rows[i], 'm_kind', textM, { color : 'black', background : colorM } );
	                $( "#dataList" ).jqGrid( 'setCell', rows[i], 'p_kind', textP, { color : 'black', background : colorP } );
				}
			}
		});
		//grid resize
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//기본도 전체 변경(open -> close, close -> open)
		$("#dataList_b_kind").dblclick(function(){
			fn_changedState("b_kind");
        });
		//MAKER 전체 변경(open -> close, close -> open)
		$("#dataList_m_kind").dblclick(function(){
			fn_changedState("m_kind");
        });
		//생설도 전체 변경(open -> close, close -> open)
		$("#dataList_p_kind").dblclick(function(){
			fn_changedState("p_kind");
        });
		
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.50);
	});
	function fn_changedState(kind){
		var rows = $( "#dataList" ).getDataIDs();
		for(var i=0; i<rows.length; i++){
			var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
			var targetData = rowData[kind];
	        
			if (targetData == "OPENED")$( "#dataList" ).jqGrid( 'setCell', rows[i], kind,"CLOSED",{background : "#fff0f5"});
	        else if (targetData == "CLOSED") $( "#dataList" ).jqGrid( 'setCell', rows[i], kind,"OPENED",{background : "#ffffff"});
	        $( "#dataList" ).jqGrid( 'setCell', rows[i], 'oper', 'U');
		}
	}
	function fn_saveProject(saveGrid){
		var loadingBox  = new ajaxLoader( $( '#mainDiv' ));
		var formData = fn_getFormData('#application_form');
		
		getGridChangedData($( "#"+saveGrid ),function(data) {
			changeRows = data;
			
			if (changeRows.length == 0 && !checkboxAreaChanged) {
				alert("저장할 데이터가 없습니다.");
				loadingBox.remove();
				return;
			}
			
			var dataList = { chmResultList : JSON.stringify(changeRows) };
			var parameters = $.extend({}, dataList, formData);
		
			if(confirm('저장하시겠습니까?')){
				
				$.post("progressProjectDateChangeMainGridSave.do",parameters ,function(data){
					alert("저장완료하였습니다");
					window.close();
				},"json").error( function() {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
					loadingBox.remove();
				} );
			}
		});
	}
</script>
</body>
</html>