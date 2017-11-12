<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" 						   %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" 						   %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<title>partFamily Type</title>
</head>
<body>
<div id="mainDiv" class="mainDiv">
	<form name="listForm" id="listForm">
	<input type="hidden" id="pageYn" name="pageYn" value="N">
	<input type="hidden" id="p_col_name" name="p_col_name"/>
	<input type="hidden" id="p_data_name" name="p_data_name"/>
	<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
	<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	<div class= "subtitle">
		Part Family Type
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
			<table class="searchArea conSearch">
			<col width="45px">
			<col width="160px">
			<col width="100px">
			<col width="160px">
			<col width="45px">
			<col width="160px">
			<col width="140px">
			<col width="160px">
			<col width="*" style="min-width:200px">

			<tr>
			<th>구분</th>
			<td>
				<input type="text" name="p_part_family_code" class="toUpper wid150">
			</td>

			<th>DESCRIPTION</th>
			<td><input type="text" name="p_part_family_desc" class="toUpper wid150"></td>

			<th>MEAN</th>
			<td>
				<input type="text" name="p_part_family_mean" class="toUpper wid150">
			</td>

			<th>CATEGORY TYPE</th>
			<td style="border-right:none;">
				<input type="text" name="p_category_type" class="toUpper wid60">
				<input type="button" class="btn_gray2" id="btnCategoryType" value="검색">
			</td>

			<td style="border-left:none;">
				<div class="button endbox">
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
					</c:if>
					
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
					</c:if>
					<c:if test="${userRole.attribute5 == 'Y'}">
						<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
					</c:if>
				</div>
			</td>
			</tr>
		</table>					

	<div class = "content">
		<table id="partFamilyTypeList"></table>
		<div id="btn_partFamilyTypeList"></div>
	</div>
	</form>
</div>
<script type="text/javascript">
var idRow;
var idCol;
var kRow;
var kCol;	
var tableId;
var resultData = [];
var lodingBox;
var row_selected = 0;

$(document).ready(function(){
	
	fn_all_text_upper();
	
	var objectHeight = gridObjectHeight(1);
	
	$("#partFamilyTypeList").jqGrid({ 
             datatype : 'json', 
             mtype	  : '', 
             url	  : '',
             postData : getFormData("#listForm"),
             colNames:['Part Family 구분','Part Family 구분 Desc','의미','ITEM 채번  DESC','ITEM 채번규칙','Category Type','Category Type Desc','구분','사용유무','Ship Type','Weight','design_register_flag_changed','enable_flag_changed','shiptype_flag_changed','weight_flag_changed','org1','org2','crud'],
                colModel:[
                    {name:'part_family_code',index:'part_family_code', width:25, editable:true, editrules:{required:true}, editoptions: {dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }} },
                    {name:'part_family_desc',index:'part_family_desc', width:40, editable:true},
                    {name:'part_family_mean',index:'part_family_mean', width:30, editable:true},
                    {name:'item_value_rule',index:'item_value_rule', width:80, editable:false},
                    /* {name:'action', index:'action', width:5, align:'center', sortable : false}, */
                    {name:'item_rule_desc',index:'item_rule_desc', width:20/* ,hidden:true */ },
                    {name:'category_type',index:'category_type', width:20, editable:false, align:'center'}, 
                    {name:'category_type_desc',index:'category_type_desc', width:45, editable:false },
                    {name:'design_register_flag',index:'design_register_flag',align:"center", width:20, editable:true, sortable : false, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
                    {name:'enable_flag',index:'enable_flag',align:"center", width:20, editable:true, sortable : false, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
                    {name:'shiptype_flag',index:'shiptype_flag',align:"center", width:20, editable:true, sortable : false, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
                    {name:'weight_flag',index:'weight_flag',align:"center", width:20, editable:true, sortable : false, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
                    {name:'design_register_flag_changed',index:'design_register_flag_changed',hidden:true},
                    {name:'enable_flag_changed',index:'enable_flag_changed',hidden:true},
                    {name:'shiptype_flag_changed',index:'shiptype_flag_changed',hidden:true},
                    {name:'weight_flag_changed',index:'weight_flag_changed',hidden:true},
                    
                    {name:'o_part_family_code',index:'o_part_family_code', hidden:true},
                    {name:'o_category_type',   index:'o_category_type',    hidden:true},
                    {name:'oper',index:'oper', hidden:true},
                ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,
             autowidth  : true,
             rowList	: [100,500,1000],
			 rowNum		: 100, 
			 rownumbers : true,

             height 	: objectHeight,
             pager		: $('#btn_partFamilyTypeList'),
			 cellEdit	: true,           // grid edit mode 1
	         cellsubmit	: 'clientArray',  // grid edit mode 2
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow=rowid;
             	idCol=iCol;
             	kRow = iRow;
             	kCol = iCol;
   			 },
   			 afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "part_family_code" || name == "category_type") setUpperCase("#partFamilyTypeList",rowid,name);
	         },
			 beforeSaveCell : partFamilyTypeResultEditEnd,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },   		  
			 loadComplete : function (data) {			
				var $this = $(this);
			    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			        // because one use repeatitems: false option and uses no
			        // jsonmap in the colModel the setting of data parameter
			        // is very easy. We can set data parameter to data.rows:
			        $this.jqGrid('setGridParam', {
			            datatype		: 'local',
			            data			: data.rows,
			            pageServer		: data.page,
			            recordsServer	: data.records,
			            lastpageServer 	: data.total
			        });
					
			        // because we changed the value of the data parameter
			        // we need update internal _index parameter:
			        this.refreshIndex();
			
			        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
			            // we need reload grid only if we use sortname parameter,
			            // but the server return unsorted data
			            $this.triggerHandler('reloadGrid');
			        }
			       
			    } else {
			        $this.jqGrid('setGridParam', {
			            page: $this.jqGrid('getGridParam', 'pageServer'),
			            records: $this.jqGrid('getGridParam', 'recordsServer'),
			            lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
			        });
			        this.updatepager(false, true);
			    }
			  },
			  
			  onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },		       
             imgpath: 'themes/basic/images',
             onCellSelect: function( rowId, iCol, content, event) {
           		row_selected = rowId;
				
				var colList = $("#partFamilyTypeList").jqGrid("getGridParam", "colModel");
				var colName = colList[iCol];
										
				if ( colName['index'] == "item_value_rule" ) {
					fn_itemValueRule(rowId);
				} else if ( colName['index'] == "part_family_code" ) {
					
					var ret	= jQuery("#partFamilyTypeList").getRowData(rowId);
					
					if (ret.oper != "I") $("#partFamilyTypeList").jqGrid('setCell', rowId, colName['index'], '', 'not-editable-cell');
				} else if( colName['index'] == "category_type" ) {
					
					var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoCategoryType.do", 
							window,
							"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

					if ( rs != null ) {
						
						$("#partFamilyTypeList").setCell(rowId,'category_type',rs[0]);
						$("#partFamilyTypeList").setCell(rowId,'category_type_desc',rs[1]); 
					}
				}
			},
			 gridComplete : function() {
					var rows = $( "#partFamilyTypeList" ).getDataIDs();

					for ( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var oper = $( "#partFamilyTypeList" ).getCell( rows[i], "oper" );
						$( "#partFamilyTypeList" ).jqGrid( 'setCell', rows[i], 'item_value_rule', '', { cursor : 'pointer', background : 'pink' } );
						$( "#partFamilyTypeList" ).jqGrid( 'setCell', rows[i], 'category_type', '', { cursor : 'pointer', background : 'pink' } );
						if( oper == "" ) {
							$( "#partFamilyTypeList" ).jqGrid( 'setCell', rows[i], 'part_family_code', '', { color : 'black', background : '#DADADA' } );
							$( "#partFamilyTypeList" ).jqGrid( 'setCell', rows[i], 'category_type_desc', '', { color : 'black', background : '#DADADA' } );
						}
					}
					
					//팝업버튼 표시
					$("#partFamilyTypeList td:contains('...')").css("background","pink").css("cursor","pointer");
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
     }); 
	
	//grid resize
    fn_gridresize( $(window), $( "#partFamilyTypeList" ) );
     
   
	$("#partFamilyTypeList").jqGrid('navGrid',"#btn_partFamilyTypeList",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	$("#partFamilyTypeList").navButtonAdd("#btn_partFamilyTypeList",
			{
				caption:"",
				buttonicon:"ui-icon-refresh",
				onClickButton: function(){
					fn_search();
				},
				position: "first",
				title:"",
				cursor:"pointer"
			}
	);
	</c:if>
	
	<c:if test="${userRole.attribute3 == 'Y'}">
	$("#partFamilyTypeList").navButtonAdd('#btn_partFamilyTypeList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute2 == 'Y'}">
 	$("#partFamilyTypeList").navButtonAdd('#btn_partFamilyTypeList',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addPartFamilyTypeResultRow,
				position: "first", 
				title:"", 
				cursor: "pointer"
			} 
	);
 	</c:if>
	
	//categoryType 조회한다.
	$("#btnCategoryType").click(function() {
		fn_searchCategoryType();
	});
	
	//조회 버튼
	$("#btnSearch").click(function() {
		fn_search(); 
	});
			
	//저장버튼
	$("#btnSave").click(function(){	
		fn_save();
	});
	
	//엑셀 export 버튼
	$("#btnExcelExport").click(function() {
		fn_downloadStart();
		fn_excelDownload();	
	});
	
});  //end of ready Function 

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//Del 버튼
function deleteRow(){
	if(row_selected==0){
		return;
	}
	$('#partFamilyTypeList').saveCell(kRow, kCol);
	
	var selrow = $('#partFamilyTypeList').jqGrid('getGridParam', 'selrow');
	var item = $('#partFamilyTypeList').jqGrid('getRowData',selrow);
	
	if(item.oper == 'I') {
		$('#partFamilyTypeList').jqGrid('delRowData', selrow);
	}else{
		alert('저장된 데이터는 삭제할 수 없습니다.');
	}
	
	$('#partFamilyTypeList').resetSelection();
}

//Add 버튼 
function addPartFamilyTypeResultRow(item) {
	$('#partFamilyTypeList').saveCell(kRow, idCol);
	
	var item = {};
	var colModel = $('#partFamilyTypeList').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 		 = 'I';
	item.enable_flag = 'Y';
	item.action = '...';
	
	$('#partFamilyTypeList').resetSelection();
	$('#partFamilyTypeList').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
	tableId = '#partFamilyTypeList';	
};

//afterSaveCell oper 값 지정
function partFamilyTypeResultEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#partFamilyTypeList').jqGrid('getRowData',irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#partFamilyTypeList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
	$('#partFamilyTypeList').jqGrid("setRowData", irowId, item);
	$("input.editable,select.editable", this).attr("editable", "0");	
};
/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//변경된 Part Family데이터를 가져온다.
function getChangedPartFamilyTypeResultData(callback) {
	var changedData = $.grep($("#partFamilyTypeList").jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D'; 
	});
	callback.apply(this, [changedData.concat(resultData)]);
}

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {

    var unindexed_array = $(form).serializeArray();
    var indexed_array   = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// 변경된 Part Family데이터 Validation 체크한다.
function fn_checkPartFamilyTypeValidate() {
	var result  	= true;
	var message 	= "";
	var nChangedCnt = 0;
	var ids     	= $("#partFamilyTypeList").jqGrid('getDataIDs');
		
	for (var i = 0; i < ids.length; i++) {
		
		var oper = $("#partFamilyTypeList").jqGrid('getCell', ids[i], 'oper');
		
		if (oper == 'I' || oper == 'U') {
			
			nChangedCnt++;
					
			var val1 = $("#partFamilyTypeList").jqGrid('getCell', ids[i], 'part_family_code');
			var val2 = $("#partFamilyTypeList").jqGrid('getCell', ids[i], 'category_type');
			
			// Part Family Code 는 필수항목이다.
			if ($.jgrid.isEmpty(val1)) {
				result  = false;
				message = "Part Family Code Field is required";
				
				setErrorFocus("#partFamilyTypeList",ids[i],0,'part_family_code');
				break;
			}
			
			//  Category Type 는 필수항목이다.
			if ($.jgrid.isEmpty(val2)) {
				result  = false;
				message = "Category Type Field is required";
				
				setErrorFocus("#partFamilyTypeList",ids[i],5,'category_type');
				break;
			}
			
		}	
	}

	if (nChangedCnt == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";
	}	
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

//그리드 대문자 변환
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		$grid.jqGrid("setCell", rowId, "block_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
	}
}

//그리드의 컬럼 Button 생성
function formatBtn(cellvalue, options, rowObject){
		
	return "<input type='button' id='"+options.rowId+"' value='' onclick=fn_itemValueRule(this)  />"; 
}

//그리드 포커스 이동한다.
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
//Part Family 리스트를 조회한다.
function fn_search() {
	//$("#partFamilyTypeList").jqGrid("clearGridData");
	var sUrl = "partFamilyTypeList.do";
	$("#partFamilyTypeList").jqGrid('setGridParam',{url:sUrl
													,mtype : 'POST'
													,page:1
													,datatype:'json'
													,postData: getFormData("#listForm")
													 }).trigger("reloadGrid");
}

//Part Family 변경된 내용 저장한다. 
function fn_save() {
	
	$('#partFamilyTypeList').saveCell(kRow, idCol);
		
	var changedData = $("#partFamilyTypeList").jqGrid('getRowData');
	// 변경된 체크 박스가 있는지 체크한다.
	for(var i=1; i<changedData.length+1; i++)
	{
		var item = $('#partFamilyTypeList').jqGrid('getRowData',i);
		if ( item.oper != 'I' && item.oper != 'U' ) {
				
				if(item.enable_flag_changed != item.enable_flag){
					item.oper = 'U';
			    }
			    
			    if(item.design_register_flag_changed != item.design_register_flag){
					item.oper = 'U';
			    }
			    
			    if(item.weight_flag_changed != item.weight_flag){
					item.oper = 'U';
			    }
			    
			    if(item.shiptype_flag_changed != item.shiptype_flag){
					item.oper = 'U';
			    }
			    
				if (item.oper == 'U') {
					// apply the data which was entered.
					$('#partFamilyTypeList').jqGrid("setRowData", i, item);
				}
		}	
	}
	
	if (!fn_checkPartFamilyTypeValidate()) {
		return;
	}
	
	if (confirm('변경된 데이터를 저장하시겠습니까?')!=0) {
		
		var chmResultRows=[];		
		
		getChangedPartFamilyTypeResultData(function(data){
			
			chmResultRows = data;
			lodingBox 	  = new ajaxLoader($('#wrap'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
			
			var dataList  = {chmResultList:JSON.stringify(chmResultRows)};
			var url 	  = 'savePartFamilyType.do';
			//$('#frmChmProcess').find('select[class="ronly"]').removeAttr('disabled');
			var formData = getFormData('#listForm');
			//$('#frmChmProcess').find('select[class="ronly"]').attr('disabled','disabled');
			var parameters = $.extend({},dataList,formData);
			$.post(url, parameters, function(data) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	lodingBox.remove();	
			});
			
		});
	}else{
		return;
	}
}

//CategoryType 조회 팝업창을 띄운다.
function fn_searchCategoryType() {
	
	var args = {p_code_find : $("input[name=p_category_type]").val()};
		
	var rs=window.showModalDialog("popUpCodeInfo.do?cmd=infoCategoryType.do",args,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$("input[name=p_category_type]").val(rs[0]);
	}
}

//아이템 채번 규직 정의하는 팝업창 띄운다.
function fn_itemValueRule(searchIndex)
{
	
	tableId 		= "#partFamilyTypeList";
	
	$(tableId).saveCell(kRow,kCol);
	
	var item = $(tableId).jqGrid('getRowData',searchIndex);
   	var item_value_rule = item.item_value_rule;
   	var item_rule_desc  = item.item_rule_desc;
    	
    var args = new Array();
    args["item_value_rule"] = item_value_rule;
    args["item_rule_desc"]  = item_rule_desc;
   	
	//var rs = window.showModalDialog("popUpBaseInfo.do?cmd=itemValueRule&item_value_rule="+item_value_rule+"&item_rule_desc="+item_rule_desc,"view","dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	var rs = window.showModalDialog("popUpItemValueRule.do",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,'item_value_rule',rs[0] == "" ? null : rs[0]);
		$(tableId).setCell(searchIndex,'item_rule_desc', rs[1] == "" ? null : rs[1]); 
		
		var item = $(tableId).jqGrid('getRowData',searchIndex);
		if(item.oper != 'I') $(tableId).setCell(searchIndex,"oper","U");
	}
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	//그리드의 label과 name을 받는다.
	//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
	var colName = new Array();
	var dataName = new Array();
	
	var cn = $( "#partFamilyTypeList" ).jqGrid( "getGridParam", "colNames" );
	var cm = $( "#partFamilyTypeList" ).jqGrid( "getGridParam", "colModel" );
	for(var i=1; i<cm.length; i++ ){
		
		if(cm[i]['hidden'] == false) {
			colName.push(cn[i]);
			dataName.push(cm[i]['index']);	
		}
	}
	$( '#p_col_name' ).val(colName);
	$( '#p_data_name' ).val(dataName);
	
	var f    = document.listForm;
	f.action = "partFamilyTypeExcelExport.do";
	f.method = "post";
	f.submit();
}

/* 사용안함 */
/* //아이템 채번규칙 cell
function itemValueRule(obj,nCode,nData,nRow,nCol){
   	searchIndex = $(obj).closest('tr').get(0).id;
   	
	$(tableId).saveCell(nRow,nCol);
	var item = $('#partFamilyTypeList').jqGrid('getRowData',searchIndex);
   	var item_value_rule = item.item_value_rule;
   	var item_rule_desc  = item.item_rule_desc;
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=itemValueRule&item_value_rule="+item_value_rule+"&item_rule_desc="+item_rule_desc,window,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,nData,rs[0] == "" ? null : rs[0]);
		$(tableId).setCell(searchIndex,nCode,rs[1] == "" ? null : rs[1]); 
		var item = $(tableId).jqGrid('getRowData',searchIndex);
		if(item.oper != 'I') $(tableId).setCell(searchIndex,"oper","U");
	}
} */

/* //아이템 채번규칙 cell
function getCategoryType(obj,nCode,nData,nRow,nCol){
   	searchIndex = $(obj).closest('tr').get(0).id;
   	
	$(tableId).saveCell(nRow,nCol);
	
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.category_type};
	
	var rs=window.showModalDialog("popUpCodeInfo.do?cmd=infoCategoryType.do",args,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,nCode,rs[0]);
		$(tableId).setCell(searchIndex,nData,rs[1]); 
		var item = $(tableId).jqGrid('getRowData',searchIndex);
		if(item.oper != 'I') $(tableId).setCell(searchIndex,"oper","U");
	}
} */
</script>
</body>
</html>