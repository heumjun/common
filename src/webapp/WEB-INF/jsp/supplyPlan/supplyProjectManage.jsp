<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>설계계획물량관리</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

<div class= "subtitle">
호선관리
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
 
	<table class="searchArea conSearch" >
		<col width="60">
		<col width="100">
		<col width="*">

		<tr>
			<th>PROJECT</th>
			<td>
				<input type="text" id="i_project" class="required" maxlength="5" name="i_project" style="width:70px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
			</td>

			<td class="bdl_no" colspan="2">
				<div class="button endbox">
					<input type="button" value="조 회"  id="btnSearch"  class="btn_blue"/>
					<input type="button" value="저 장" 	 id="btnSave"  class="btn_blue"/>
				</div>
			</td>
		</tr>
		</table>
		
		<div class="content">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>	
	</div>	
</form>

<script type="text/javascript">

var change_plan_row 	= 0;
var change_plan_row_num = 0;
var change_plan_col  	= 0;

var tableId	   			= "#jqGridMainList";
var deleteData 			= [];

var resultData = [];

var searchIndex 		= 0;
var lodingBox; 
var win;	
var userid				= "${loginUser.user_id}";

$(document).ready(function(){
	fn_all_text_upper();
	
	var objectHeight = gridObjectHeight(1);
	
	
	$("#jqGridMainList").jqGrid({ 
             datatype	: 'json',              
             url		: '',
             postData   : '',
             colNames:['호선', '마감유무' ,'생성자', '생성일', '수정자', '수정일', 'OPER'],
             colModel:[
				{name:'project_no', index:'project_no', width:100, align:'center', editable:false, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
				{name:'close_flag', index:'close_flag', width:100, align:'center'},
				{name:'create_by',index:'create_by', width:100, align:'center'},
				{name:'create_date', index:'create_date', width:100, align:'center'},
				{name:'modify_by', index:'modify_by', width:100},
				{name:'modify_date', index:'modify_date', width:100, align:'center'},
				{name:'oper', index:'oper', width:25, hidden:true},
             ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#bottomJqGridMainList'),
	         pgbuttons : false,
             pgtext : false,
             pginput : false,
             viewrecords : false,
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList:[100,500,1000],
	         rowNum:100, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changePlanEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "project_no") setUpperCase("#jqGridMainList",rowid,name);	
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
			 gridComplete : function() {
				
			},
			onCellSelect: function(row_id, colId) {
            	var cm = $(this).jqGrid( "getGridParam", "colModel" );
 				var colName = cm[colId];
 				var item = $(this).jqGrid( 'getRowData', row_id );
 				
             },
	         loadComplete : function (data) {
			  				  	
			  	$("#chkHeader").prop("checked", false);	
			    deleteArrayClear();
			  
			    var $this = $(this);
			    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			        // because one use repeatitems: false option and uses no
			        // jsonmap in the colModel the setting of data parameter
			        // is very easy. We can set data parameter to data.rows:
			        $this.jqGrid('setGridParam', {
			            datatype: 'local',
			            data: data.rows,
			            pageServer: data.page,
			            recordsServer: data.records,
			            lastpageServer: data.total
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
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_plan_row 	=	rowid;
             	change_plan_row_num =	iRow;
             	change_plan_col 	=	iCol;
   			 },
			   	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root	: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page	: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total	: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
     }); 

	<c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정
	$("#jqGridMainList").navButtonAdd("#bottomJqGridMainList",
			{
				caption:"",
				buttonicon:"ui-icon-refresh",
				onClickButton: function(){
					fn_search();
				},
				position:"first",
				title:"",
				cursor:"pointer"
			}
	);
	</c:if>	

	$("#btnSave").click(function() {
		fn_save();
	});
	
	// 조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	});

	//grid resize
    fn_gridresize($(window),$("#jqGridMainList"),35);
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/

// afterSaveCell oper 값 지정
function changePlanEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#dwgPlanGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#dwgPlanGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#dwgPlanGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}


/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드 포커스 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

// 그리드에 변경된 데이터Validation체크하는 함수	
function fn_checkPlanValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	/*
	if (result && arr1.length > 0) {
		ids = $("#dwgPlanGrid").jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $("#dwgPlanGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#dwgPlanGrid").jqGrid('getCell', ids[i], 'project_no');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Project No Field is required";
					
					setErrorFocus("#dwgPlanGrid",ids[i],1,'project_no');
					break;
				}
				
			}
		}
	}
	*/
	if (!result) {
		alert(message);
	} else {
		if (confirm('변경된 데이터를 저장하시겠습니까?') == 0) {
			result = false;
		}
	}
	
	return result;	
}

// 폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// 그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	

// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.resizeTo(550, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {
	
	fn_applyData("#dwgPlanGrid",change_plan_row_num,change_plan_col);
	
	var changePlanResultRows =  getChangedGridInfo("#dwgPlanGrid");;
	
	if (!fn_checkPlanValidate(changePlanResultRows)) { 
		return;	
	}
		
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#dwgPlanGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#dwgPlanGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "saveDwgPlan.do";
	var dataList    = {chmResultList:JSON.stringify(changePlanResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
			
		lodingBox.remove();
		
		var msg = '';
		var result = '';
		
		for( var key in data ) {
			if( key == 'resultMsg' ) {
				msg = data[key];
			}
			if( key == 'result' ) {
				result = data[key];
			}
		}
		
		alert(msg);
		
		if ( result == 'success' ) {
			fn_search();
		}
	}, 'json' ).error( function() {
		alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
	} ).always( function() {
		lodingBox.remove();			
	});
}

// 프로젝트 Plan 정보를 조회
function fn_search() {
				
	if( $("#i_project").val() == "" ) {
		alert("PROJECT는 필수입력사항 입니다.");
		return;
	}			
	
	var sUrl = "supplyProjectManageList.do";

	$( "#jqGridMainList" ).jqGrid( "clearGridData" );
	$( "#jqGridMainList" ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : sUrl,
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#listForm" )
	} ).trigger( "reloadGrid" );
	
} 

function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#dwgPlanGrid" ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	} );
	
	callback.apply( this, [ changedData.concat(resultData) ] );
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	location.href='dwgPlanExcelExport.do?i_project='+$("#i_project").val()+'&i_group1='+$("#i_group1").val()+'&i_group2='+$("#i_group2").val()+'&i_description='+$("#i_description").val()+'&i_dept='+$("#i_dept").val()+'&i_reason='+$("#i_reason").val();
}
</script>
</body>
</html>