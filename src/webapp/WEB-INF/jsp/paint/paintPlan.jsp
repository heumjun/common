<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Plan</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

<div class= "subtitle">
Paint Plan
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
		 
			<table class="searchArea conSearch">
					<col width="10%"><!--PROJECT NO-->
					<col width="">
					<col width="" style="min-width:200px">

					<tr>
					<th>PROJECT NO</th>
					<td style="border-right:none;">
					 <input type="text" id="txtProjectNo" maxlength="10" name="txt_project_no" style="width:150px; ime-mode:disabled; text-transform: uppercase;"  onKeyUp="javascript:this.value=this.value.toUpperCase();"/>
					 </td>

					<td style="border-left:none;">
						<div class="button endbox">
							<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" value="조회" id="btnSearch" class="btn_blue" />
							</c:if>
							<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" value="Rev 추가" id="btnRevisionAdd"  class="btn_blue" />
							</c:if>
							<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" value="저장" id="btnSave"  class="btn_blue" />
							</c:if>
						</div>
					</td>						
					</tr>
			</table>
							
		<table class="searchArea2" >
					<tr>
						<td width="">
							<div id="divSeries" style="float: left;  margin-right: 5px;"></div>
						</td>
						<th width="150px">복사 대상 PROJECT</th>
						<td width="180px">
							<input type="text" id="add_project"name="add_project" />
							<c:if test="${userRole.attribute2 == 'Y'}">
							<input type="button" id="btnSearchProject" value="검색" style="" class="btn_blue" />
							</c:if>
						</td>
						<td width="170px">
							<div class="button endbox">
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" value="Project 복사" id="btnProjectAdd" class="btn_blue"/>
							</c:if>
								
							</div>
						</td>
					</tr>
				</table>	
		
	<!--
	<div class = "topMain" style="line-height:45px">
		<div class = "conSearch">
			<span class = "spanMargin">
				PROJECT NO  <input type="text" id="txtProjectNo" maxlength="10" name="project_no" style="width:150px; ime-mode:disabled; text-transform: uppercase;"  onKeyUp="javascript:this.value=this.value.toUpperCase();"/>
			</span>
		</div>
		
		<div class = "button">
			<input type="button" value="조회" id="btnSearch" class="btn_blue" />
			<input type="button" value="저장" id="btnSave"  class="btn_gray"  disabled />
		</div>
	</div>
	-->
	<div class="content">
		<table id = "planGrid"></table>
		<div   id = "p_planGrid"></div>
	</div>	
</div>	
</form>

<script type="text/javascript">

var change_plan_row 	= 0;
var change_plan_row_num = 0;
var change_plan_col  	= 0;

var tableId	   			= "#planGrid";
var deleteData 			= [];

var resultData = [];

var searchIndex 		= 0;
var lodingBox; 
var win;	
var userid				= "${loginUser.user_id}";

$(document).ready(function(){
	fn_all_text_upper();
	
	var objectHeight = gridObjectHeight(1);
	
	$("#planGrid").jqGrid({ 
             datatype	: 'json',              
             url		: '',
             postData   : '',
             colNames:['선택', 'Project No','Revision','Description','상태', '','생성자', ''],
                colModel:[
                	{ name : 'enable_flag', index : 'enable_flag', align : "center", width : 10, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				    {name:'project_no', index:'project_no', 	width:60,  editable:false, editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'revision',   index:'revision', 		width:40, align:'center'},
                    {name:'description',index:'description',    width:150, editable:true},
                    {name:'state_desc', index:'state_desc', 	width:100},
                    {name:'state',      index:'state', 	   		width:25, hidden:true },
                    {name:'create_by', index:'create_by', 	width:100},
                    {name:'oper',       index:'oper',      		width:25, hidden:true },
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_planGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changePlanEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "project_no") setUpperCase("#planGrid",rowid,name);	
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
				var rows = $( "#planGrid" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = $( "#planGrid" ).getCell( rows[i], "oper" );
					if( oper != "I" ) {
						//미입력 영역 회색 표시
						$( "#planGrid" ).jqGrid( 'setCell', rows[i], 'project_no', '', { background : '#DADADA' } );
						$( "#planGrid" ).jqGrid( 'setCell', rows[i], 'revision', '', { background : '#DADADA' } );
						$( "#planGrid" ).jqGrid( 'setCell', rows[i], 'state_desc', '', { background : '#DADADA' } );
					} else {
						$(this).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : 'pink' } );	
					}
				}
				
			},
			onCellSelect: function(row_id, colId) {
            	
            	var cm = $(this).jqGrid( "getGridParam", "colModel" );
 				var colName = cm[colId];
 				var item = $(this).jqGrid( 'getRowData', row_id );
 				if( item.oper == "I" ) {
 					if ( colName['index'] == "project_no" ) {
 						var rs = window.showModalDialog( "popUpProjectNo.do?p_delegate_project_no=none",
 								window,
 								"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
 						
 						if ( rs != null ) {
 							
 							$(this).setRowData( row_id, { project_no : rs[0] } );
 							var item = $(this).jqGrid( 'getRowData', row_id );
 						}
 					}	
 				}
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
	
	// 그리드 버튼 설정
	$("#planGrid").jqGrid('navGrid',"#p_planGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정
	$("#planGrid").navButtonAdd("#p_planGrid",
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
	
	<c:if test="${userRole.attribute3 == 'Y'}">
	// 그리드 Row 삭제 함수 설정
	$("#planGrid").navButtonAdd('#p_planGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute2 == 'Y'}">	
	// 그리드 Row 추가 함수 설정
 	$("#planGrid").navButtonAdd('#p_planGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if>
/***삭제?	
	//AF CODE
	$.post( "selectPaintCode.do", {addCode:'Not',main_category:'PAINT',states_type:'AF CODE'}, function( data ) {
		var data2 = $.parseJSON( data );
		
		$( '#planGrid' ).setObject( { value : 'value', text : 'text', name : 'af_code', data : data2 } );
	} );
****/	
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	// 조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	});
	
	$("#btnRevisionAdd").click(function() {
		fn_revision_add();
	} );
	
	$("#btnProjectAdd").click(function() {
		fn_project_add();
	} );
	
	$("#btnSearchProject").click(function() {
		var rs = window.showModalDialog( "popUpProjectNo.do?p_delegate_project_no=none",
				window,
				"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
		
		if ( rs != null ) {
			$("#add_project").val(rs[0]);
		}
	} );
	
	
	//grid resize
    fn_gridresize($(window),$("#planGrid"),35);
	
	//fn_buttonDisabledUser(userid, ["#btnSave","#btnRevisionAdd"]);
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Del 버튼
function deleteRow(){
	
	fn_applyData("#planGrid",change_plan_row_num,change_plan_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var selrow = $('#planGrid').jqGrid('getGridParam', 'selrow');
	var item   = $('#planGrid').jqGrid('getRowData',    selrow);
	
	if(item.oper == 'I') {
		$('#planGrid').jqGrid('delRowData', selrow);
	}else{
		alert('저장된 데이터는 삭제할 수 없습니다.');
	}
		
	$('#planGrid').resetSelection();
}

// Add 버튼 
function addRow(item) {

	fn_applyData("#planGrid",change_plan_row_num,change_plan_col);
	
	var item = {};
	var colModel = $('#planGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
		
	$('#planGrid').resetSelection();
	$('#planGrid').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
	tableId = '#planGrid';	
}

// afterSaveCell oper 값 지정
function changePlanEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#planGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#planGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#planGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}

// header checkbox action 
function checkBoxHeader(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
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
	
	if (result && arr1.length > 0) {
		ids = $("#planGrid").jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $("#planGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#planGrid").jqGrid('getCell', ids[i], 'project_no');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Project No Field is required";
					
					setErrorFocus("#planGrid",ids[i],1,'project_no');
					break;
				}
				
			}
		}
	}
	
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

// 그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" onclick='chkClick("+rowid+")'/>";
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
	
	fn_applyData("#planGrid",change_plan_row_num,change_plan_col);
	
	var changePlanResultRows =  getChangedGridInfo("#planGrid");;
	
	if (!fn_checkPlanValidate(changePlanResultRows)) { 
		return;	
	}
		
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#planGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#planGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintPlan.do";
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
				
	var sUrl = "paintPlanList.do";
	jQuery("#planGrid").jqGrid('setGridParam',{url		: sUrl
		                                      ,mtype    : 'POST' 
											  ,page		: 1
											  ,datatype	: 'json'
											  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
} 


function fn_revision_add() {
	fn_applyData("#planGrid",change_plan_row_num,change_plan_col);

	var chmResultRows = [];
	getChangedChmResultData( function( data ) {
		chmResultRows = data;
		
		if( chmResultRows.length == 0 ) {
			alert( "PROJECT를 선택해주세요." );
			return;
		}

		var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

		var url = 'savePlanRevAdd.do';
		var formData = fn_getFormData( '#application_form' );
		var parameters = $.extend( {}, dataList, formData );
		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post( url, parameters, function( data ) {
			var msg = "";
			var result = "";

			for( var key in data ) {
				if( key == 'resultMsg' ) {
					msg = data[key];
				}
				if( key == 'result' ) {
					result = data[key];
				}
			}			
			
			alert( msg );
// 			if ( result == 'success' ) {
				fn_search();
// 			}
		}, "json" ).error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
	    	loadingBox.remove();	
		} );
	} );
}

function fn_project_add() {
	fn_applyData("#planGrid",change_plan_row_num,change_plan_col);

	var chmResultRows = [];
	getChangedChmResultData( function( data ) {
		chmResultRows = data;
		if( chmResultRows.length == 0 ) {
			alert( "PROJECT를 선택해주세요." );
			return;
		}

		if( $("#add_project").val() == "" ) {
			alert( "복사 대상 PROJECT를 선택해주세요." );
			return;
		}
		
		var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

		var url = 'savePlanProjectAdd.do';
		var formData = fn_getFormData( '#listForm' );
		var parameters = $.extend( {}, dataList, formData );
		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post( url, parameters, function( data ) {
			var msg = "";
			var result = "";

			for( var key in data ) {
				if( key == 'resultMsg' ) {
					msg = data[key];
				}
				if( key == 'result' ) {
					result = data[key];
				}
			}			
			
			alert( msg );
// 			if ( result == 'success' ) {
				fn_search();
// 			}
		}, "json" ).error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
	    	loadingBox.remove();	
		} );
	} );
}

function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#planGrid" ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.enable_flag == 'Y';
	} );
	
	callback.apply( this, [ changedData.concat(resultData) ] );
}
</script>
</body>
</html>