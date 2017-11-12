<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Loss Code 등록/수정</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>

<form name="listForm" id="listForm"  method="get">
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden"  name="mod"       		   />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

<div id="mainDiv" style="display:block; float:none; " id="mainDiv">
	<div class = "topMain" style="line-height:45px">
		<div class = "conSearch">
			<span class = "spanMargin">
			<span class="pop_tit">Loss Code</span>
			<input type="text" id="txtLossCode" class = "required" name="lossCode" <%-- value="${loss_code}" --%> style="width:100px; height:25px; ime-mode:disabled; " onchange="javascript:this.value=this.value.toUpperCase();"/>
			</span>
		</div>
		
		<div class = "conSearch">
			<span class = "spanMargin">
			<span class="pop_tit">구획명</span>
			<input type="text" id="txtLossDesc" name="lossDesc" <%-- value="${loss_desc}" --%> style="width:240px; height:25px;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			</span>
		</div>
		
		<div class = "conSearch">
			<span class = "spanMargin">
			<span class="pop_tit">ORDER</span>
			<input type="text" id="txtOrderSeq" name="orderSeq" <%-- value="${order_seq}" --%> style="text-align:right;width:50px; height:25px;" onkeypress="return numbersonly(event, false);"/>
			</span>
		</div>
		
		<div class = "button">
			<c:if test="${userRole.attribute4 == 'Y'}">
			<input type="button" value="저 장" id="btnSave"  class="btn_blue"/>
			</c:if>
			<input type="button" value="닫 기" id="btnClose"  class="btn_blue"/>
		</div>
	</div>
	<div class="content">
		<table id = "lossGrid"></table>
		<div   id = "p_lossGrid"></div>
	</div>	
</div>	
</form>

<script type="text/javascript">

var change_loss_row 	= 0;
var change_loss_row_num = 0;
var change_loss_col  	= 0;

var tableId	   			= "#lossGrid";
var deleteData 			= [];

var searchIndex 		= 0;
var lodingBox; 
var win;	

var mod					= $.jgrid.isEmpty("${loss_code}") ? "I" : "U";
var lossDesc			= "";
var orderSeq			= "";

$(document).ready(function(){
	$("input[name=lossCode]").val(window.dialogArguments["loss_code"]);
	$("input[name=lossDesc]").val(window.dialogArguments["loss_desc"]);
	$("input[name=orderSeq]").val(window.dialogArguments["order_seq"]);
	$("input[name=mod]").val(mod);
		
	$("#lossGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : getFormData("#listForm"),
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Set','Count','선행 Loss','후행 Loss','선행(%)','후행(%)','도료TYPE','Stage','Remark',''],
                colModel:[
                	{name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt1},
                	//{name:'loss_code',index:'loss_code', width:80, sortable:false},
                   	//{name:'loss_desc',index:'loss_desc', width:140, sortable:false},
                   	{name:'set_name', index:'set_name', width:50,  editable:true, sortable:false, editoptions: {maxlength : 5, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'paint_count',index:'paint_count', width:50,  editable:true, sortable:false, editrules:{number:true}, align:"right"},
                    {name:'pre_loss',index:'pre_loss', width:50,   editable:true, sortable:false, editrules:{number:true, maxValue:99}, align:"right", classes:'yellow'},
                    {name:'post_loss',index:'post_loss', width:50,  editable:true, sortable:false, editrules:{number:true, maxValue:99}, align:"right", classes:'yellow'},
                    {name:'pre_loss_rate',index:'pre_loss_rate', width:50, sortable:false, align:"right"},
                    {name:'post_loss_rate',index:'post_loss_rate', width:50, sortable:false, align:"right"},
                    {name:'paint_type',index:'paint_type' , editoptions: { dataInit: function(elem) {$(elem).width(100);}}   // set the width which you need
                     ,editable : true, align :'left',  width:100, sortable : false , edittype : 'select', formatter : 'select' },
                    {name:'stage_desc',index:'stage_desc', editoptions: { dataInit: function(elem) {$(elem).width(40);}}  // set the width which you need
                     ,editable : true, align :'center',  width:30, sortable : false, edittype : 'select', formatter : 'select'}, 
                    {name:'remark',index:'remark', width:160, editable:true, sortable:false, align:"left", editable : true, edittype : "textarea", editoptions : { rows : "3", cols : "50" }},
                    {name:'oper',index:'oper', width:25, hidden:true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
                       
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: G_HEADER_PAGER,
             pager		: $('#p_lossGrid'),
             pgbuttons  : false,
			 pgtext     : false,
			 pginput    : false,
			 viewrecords: false, 
			
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowNum		: -1, 
	         beforeSaveCell : changeLossEditEnd, 
	         imgpath		: 'themes/basic/images',
	         
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {	
             	//var grid = this;
             	//var  xPer = Math.floor(10000 / (100 - Number(val)) * 10) / 10;
             	var  xPer = Math.round(10000 / (100 - Number(val))) ;
             	
             	if (name == "pre_loss") {
             		$("#lossGrid").jqGrid("setCell", rowid, 'pre_loss_rate', xPer);	
             	} else if (name == "post_loss") {
             		$("#lossGrid").jqGrid("setCell", rowid, 'post_loss_rate', xPer);
             	} else if (name == "set_name") {
             		setUpperCase('#lossGrid',rowid,name);
             	}   
             	
             	fn_jqGridChangedCell('#lossGrid', rowid, 'chk', {background:'pink'});	
	         },
	         
			 gridComplete : function () {
				 var rows = $("#lossGrid").getDataIDs(); 
				    for (var i = 0; i < rows.length; i++) {
				    	
				    	var oper = $("#lossGrid").getCell(rows[i],"oper");
				    	if ( oper != "I" ) {
				    		$( "#lossGrid" ).jqGrid( 'setCell', rows[i], 'set_name', '', { background : '#DADADA' } );
							$("#lossGrid" ).jqGrid('setCell', rows[i], 'set_name', '', 'not-editable-cell');
							$( "#lossGrid" ).jqGrid( 'setCell', rows[i], 'paint_count', '', { background : '#DADADA' } );
							$("#lossGrid" ).jqGrid('setCell', rows[i], 'paint_count', '', 'not-editable-cell');
				    	}
				    }
		 	 	//미입력 영역 회색 표시
				$("#lossGrid .yellow").css( "background", "yellow" );	
			 },
			 
	         loadComplete : function (data) {
			  			  
			    deleteArrayClear();
			  
			    if (mod == "U") {
			    	/* $("#txtLossDesc").val(data[0].loss_desc);
			    	$("#txtOrderSeq").val(data[0].order_seq); */
			    	//$("#txtLossDesc").attr("disabled",true);
			    	$("#txtLossCode").attr("readonly",true);
			    	
			    	/* lossDesc = data[0].loss_desc;
			    	orderSeq = data[0].order_seq; */
			    	lossDesc = $("#txtLossDesc").val();
			    	orderSeq = $("#txtOrderSeq").val();
			  	} else {
			  		$("#txtLossDesc").val("");
			  		$("#txtOrderSeq").val("");
			  		//$("#txtLossDesc").removeAttr("disabled");
			  		$("#txtLossCode").removeAttr("readonly");
			  		lossDesc = "";
			  		orderSeq = "";
			  	}
	
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_loss_row 	=	rowid;
             	change_loss_row_num =	iRow;
             	change_loss_col 	=	iCol;
   			 },
			   	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root	: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page	: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total	: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },  
                      
            
             onCellSelect: function(row_id, colId) {
             	if(row_id != null) 
                {
                	var ret 	= jQuery("#lossGrid").getRowData(row_id);
                	
	               	if (colId == 2 && ret.oper != "I") jQuery("#lossGrid").jqGrid('setCell', row_id, 'loss_code', '', 'not-editable-cell');
                } 
             }
    }); 
	
	// 그리드 초기화하는 함수 
	$("#lossGrid").jqGrid('navGrid',"#p_lossGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	// 그리드 초기화 함수 설정
	$("#lossGrid").navButtonAdd("#p_lossGrid",
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
	
	// 그리드 Row 삭제 함수 설정
	$("#lossGrid").navButtonAdd('#p_lossGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	
	// 그리드 Row 추가 함수 설정
 	$("#lossGrid").navButtonAdd('#p_lossGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
	
	//PAINT TYPE
	$.post( "infoComboCodeMaster.do", {sd_type:'PAINT_TYPE'}, function( data ) {
		//var data2 = $.parseJSON( data );
		
		$( '#lossGrid' ).setObject( { value : 'value', text : 'text', name : 'paint_type', data : data } );
		
		fn_search();
	} );
	
	//Stage Desc
	var data = [{value:"B", text:"B"},
				{value:"H", text:"H"}		
			   ];
	$( '#lossGrid' ).setObject( { value : 'value', text : 'text', name : 'stage_desc', data : data } );
	
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	//닫기	
	$("#btnClose").click(function() {
		self.close();
	});
	
	/* //조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	}); */
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Del 버튼
function deleteRow() {
	
	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		var item   = $('#lossGrid').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#lossGrid').jqGrid("setRowData", selrow, item);
			var colModel = $( '#lossGrid' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#lossGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
			//deleteData.push(item);
		} else if(item.oper == 'I') {
			$('#lossGrid').jqGrid('delRowData', selrow);	
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		}
	}
	
	$('#lossGrid').resetSelection();
}

//Add 버튼 
function addRow(item) {

	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
	
	var item = {};
	var colModel = $('#lossGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
	
	var nRandId = $.jgrid.randId();
	$('#lossGrid').resetSelection();
	$('#lossGrid').jqGrid('addRowData', nRandId, item, 'last');
	fn_jqGridChangedCell('#lossGrid', nRandId, 'chk', {background:'pink'});
	tableId = '#lossGrid';	
}

// afterSaveCell oper 값 지정
function changeLossEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#lossGrid').jqGrid('getRowData', irowId);
	if (item.oper != 'I')
		item.oper = 'U';

	// apply the data which was entered.
	$('#lossGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}

//header checkbox action 
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
// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

// 그리드포커스 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드에 변경된 데이터 Validation체크하는 함수	
function fn_checkLossValidate(arr1) {
	
	var ids ;
		
	if ($.jgrid.isEmpty($("#txtLossCode").val())) {
		alert("Loss Code is required");	
		$("#txtLossCode").focus()
		return false;
	}
	if (arr1.length == 0) {
		if (mod == "I" || (mod == "U" && lossDesc == $("#txtLossDesc").val() && orderSeq == $("#txtOrderSeq").val())) {
			alert("변경된 내용이 없습니다.");
			return false;
		}
	} else if (arr1.length > 0) {
		ids = $("#lossGrid").jqGrid('getDataIDs');
		
		for(var i=0; i < ids.length; i++) {
		
			var iRow = $('#lossGrid').jqGrid('getRowData', ids[i]);
									
			for (var j = i+1; j <ids.length; j++) {
				var jRow = $('#lossGrid').jqGrid('getRowData', ids[j]);
				
				if (iRow.set_name == jRow.set_name && iRow.paint_count == jRow.paint_count) {
					alert((i+1)+"ROW, "+(j+1)+"ROW는 중복됩니다.");	
					return false;
				}
			}
		}

		ids = $("#lossGrid").jqGrid('getDataIDs');
		for(var  i = 0; i < ids.length; i++) {
			var oper = $("#lossGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#lossGrid").jqGrid('getCell', ids[i], 'set_name');
				if ($.jgrid.isEmpty(val1)) {
					alert("SET Field is required");
					setErrorFocus("#lossGrid",ids[i],1,'set_name');
					return false;
				}
				
				val1 = $("#lossGrid").jqGrid('getCell', ids[i], 'paint_count');
				if ($.jgrid.isEmpty(val1)) {
					alert("회차 Field is required");
					setErrorFocus("#lossGrid",ids[i],2,'paint_count');
					return false;
				}
				
				val1 = $("#lossGrid").jqGrid('getCell', ids[i], 'paint_type');
				if ($.jgrid.isEmpty(val1)) {
					alert("도료 Field is required");
					setErrorFocus("#lossGrid",ids[i],7,'paint_type');
					return false;
				}
				
				val1 = $("#lossGrid").jqGrid('getCell', ids[i], 'pre_loss');
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					alert("Pre Loss Field is a numerical format");
					setErrorFocus("#lossGrid",ids[i],3,'pre_loss');
					return false;
				}
				
				val1 = $("#lossGrid").jqGrid('getCell', ids[i], 'post_loss');
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					alert("Post Loss Field is a numerical format");
					setErrorFocus("#lossGrid",ids[i],4,'post_loss');
					return false;
				}
			}
		}
	}
	return true;	
}

//폼데이터를 Json Arry로 직렬화
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
		return obj.oper == 'I' || obj.oper == 'U' ||  obj.oper == 'D';
	});
	
	//changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.resizeTo(550, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

//그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {
	
	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
	
	var changeLossResultRows =  getChangedGridInfo("#lossGrid");;
	
	if (!fn_checkLossValidate(changeLossResultRows)) { 
		return;	
	}
	
	//$("#txtLossDesc").removeAttr("disabled");
	
	// ERROR표시를 위한 ROWID 저장
	//var ids = $("#lossGrid").jqGrid('getDataIDs');
	//for(var  j = 0; j < ids.length; j++) {	
		//$('#lossGrid').setCell(ids[j],'operId',ids[j]);
	//}
	
	var url			= "savePaintLoss.do";
	var dataList    = {lossList:JSON.stringify(changeLossResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
		alert(data.resultMsg);
		if (data.result == "success") {
			 	$("input[name=mod]").val("U");
			 	
			 	parent.fn_search();
			 	
			 	self.close();
			}
	}, "json" ).error( function () {
		alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
	} ).always( function() {
    	lodingBox.remove();	
	});
}

// 선택한 LossCode 조회
function fn_search() {
				
	var sUrl = "infoPaintLossCode.do";
	$("#lossGrid").jqGrid('setGridParam',{url		: sUrl
										,mtype		: 'POST'
									    ,page		: 1
									    ,datatype	: 'json'
									    ,postData   : getFormData("#listForm")}).trigger("reloadGrid");
} 

/* // Paint Item 조회하는 화면 호출
function searchAreaCode(obj,sCode,sDesc,sTypeCode) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.area_code};
		
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupLossCode",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
	}
} */

//엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
			   									
	win = window.open("./lossExcelUpload.do?gbn=paintLossExcelUpload","listForm","height=260,width=650,top=200,left=200");
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	location.href='./lossExcelExport.do?lossCode='+$("input[name=lossCode]").val();
}

</script>
</body>
</html>