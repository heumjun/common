<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Area</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<input type="hidden" id="cmd" name="cmd" />
	<input type="hidden" id="txtProjectNo"  name="project_no" 	value="${project_no}" />
	<input type="hidden" id="txtRevision"  	name="revision" 	value="${revision}" />
	
	<div id="mainDiv">
		<div  class = "topMain"  style="line-height:45px">
			
				<div class = "button" >
					<input type="button" value="저장" id="btnSave" class="btn_blue" />
					<input type="button" value="닫기" id="btnClose" class="btn_blue"/>
				</div>
			
		</div>
		<div>
			<fieldset>
			<legend>Excel Upload 정보</legend>
				<div>
					<div style="margin: 0px 5px 0px 5px">
						<table id = "excelUplodList"></table>
						<div   id = "pexcelUplodList"></div>
					</div>
				</div>
			</fieldset>
		</div>
	</div>
</form>
<script type="text/javascript">
	
var change_block_row 	= 0;
var change_block_row_num = 0;
var change_block_col  	= 0;

var uploadList = $.parseJSON('${uploadList}');

var lodingBox;

$(document).ready(function() {
		
	opener.resizeWin();

	$("#excelUplodList").jqGrid({ 
         datatype	: 'local', 
         mtype		: 'POST', 
         url		: '',
         colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','BLOCK','구분','Error MSG','',''],
             colModel:[
                 {name:'chk', 		  index:'chk', 		  width:20,	align:'center',formatter: formatOpt1},
                 {name:'block_code',  index:'block_code', width:60, editable : true, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                 {name:'in_ex_gbn',   index:'in_ex_gbn',  width:50, editoptions: { dataInit: function(elem) {$(elem).width(80);}}  // set the width which you need
                  ,editable : true,   align : 'left', 	  sortable : false, edittype : 'select', formatter : 'select', editrules : { required:true }},
                 {name:'error_msg',   index:'error_msg',  width:200},
      			 
      			 {name:'is_excel',    index:'is_excel',   hidden : true},
                 {name:'operId',      index:'operId', 	  hidden : true}
             ],
             
         gridview: true,
         cmTemplate: { title: false },
         toolbar: [false, "bottom"],
         //sortname: 'revision_no', 
         //sortorder: "asc", 
         viewrecords	: false,
         autowidth  	: true,
         height			: G_HEADER_PAGER - 20,
         pager			: $('#pexcelUplodList'),
         rowNum			: 1000, 
         cellEdit		: true,             // grid edit mode 1
       	 cellsubmit		: 'clientArray',  	// grid edit mode 2
       	 rownumbers 	: true,          	// 리스트 순번	
         
         pgbuttons		: false,
		 pgtext			: false,
		 pginput		: false,
         loadComplete	: function() {
            
		 },
		 afterSaveCell  : function(rowid,name,val,iRow,iCol) {
           	if (name == "block_code") setUpperCase('#excelUplodList',rowid,name);	
         },
		 gridComplete : function () {
			// ERROR표시를 위한 ROWID 저장
			var $grid = $("#excelUplodList");
			var ids  = $grid.jqGrid('getDataIDs');	
			
			for(var i=0; i<ids.length; i++) {
				//$('#excelUplodList').setCell(ids[i],'operId',ids[i]);
				var isExcel = $grid.jqGrid('getCell', ids[i], 'is_excel');
				if (isExcel == "N") $grid.jqGrid('setRowData', ids[i], false, {  color:'white',weightfont:'bold',background:'blue'}); 
			}
			
		 },
		 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	change_block_row 	=	rowid;
            	change_block_row_num =	iRow;
            	change_block_col 	=	iCol;
  			 },
            jsonReader : {
                root	: "rows",
                page	: "page",
                total	: "total",
                records : "records",  
                repeatitems: false,
               },        
            imgpath: 'themes/basic/images'
           
    	}); 
    
    var data2 = [{value:'사내',text:'사내'}
				,{value:'사외',text:'사외'}];
	$( '#excelUplodList' ).setObject( { value : 'value', text : 'text', name : 'in_ex_gbn', data : data2 } );
	
	/* var data3 =  {
           "page": "1",
           "rows": uploadList
       };
       
    // 업로드 데이터 그리드에 추가   
    $("#excelUplodList")[0].addJSONData(data3); */
    
 // 업로드 데이터 그리드에 추가  		
	$('#excelUplodList').setGridParam({
					page : 1,
					data : uploadList,
							}).trigger('reloadGrid');
    
    // 그리드 버튼 설정   	
    $("#excelUplodList").jqGrid('navGrid',"#pexcelUplodList",{refresh:false,search:false,edit:false,add:false,del:false});
	
	// 그리드 Row 삭제 함수 설정
	$("#excelUplodList").navButtonAdd('#pexcelUplodList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
    
    // 저장 버튼	
	$("#btnSave").click(function(){
		fn_save();					
	});
	
	// 닫기 버튼
	$("#btnClose").click(function(){
		self.close();					
	});
		
}); 

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
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

// 그리드 row삭제 함수 
function deleteRow() {
	
	fn_applyData("#excelUplodList",change_block_row_num,change_block_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		$('#excelUplodList').jqGrid('delRowData', selrow);
	}
	
	$('#excelUplodList').resetSelection();
	
	//var selrow = $('#excelUplodList').jqGrid('getGridParam', 'selrow');
			
	//$('#excelUplodList').jqGrid('delRowData', selrow);
	//$('#excelUplodList').resetSelection();
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 엑셀 데이터 validation체크하는 함수
function fn_checkBlockValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
	
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	if (result && arr1.length > 0) {
	
		ids = $("#excelUplodList").jqGrid('getDataIDs');
		
		for(var  i = 0; i < ids.length; i++) {
			var val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'block_code');
			if ($.jgrid.isEmpty(val1)) {
				result  = false;
				message = "Block Code Field is required";
				setErrorFocus("#excelUplodList",i+1,2,'block_code');
				break;
			}
			val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'in_ex_gbn');	
			if ($.jgrid.isEmpty(val1)) {
				result  = false;
				message = "구분  Field is required";
				setErrorFocus("#excelUplodList",i+1,3,'in_ex_gbn');
				break;
			}	
		}
	}
	
	/*
	if (result && arr1.length > 0) {
		ids = $("#excelUplodList").jqGrid('getDataIDs');

		for(var i=0; i < ids.length; i++) {
			var iRow = $("#excelUplodList").jqGrid('getRowData', ids[i]);
	
			for (var j = i+1; j <ids.length; j++) {
				var jRow = $("#excelUplodList").jqGrid('getRowData', ids[j]);
				if (iRow.block_code == jRow.block_code) {
					result  = false;
					message = $("#excelUplodList").jqGrid('getInd',ids[i]) +"ROW, "+ $("#excelUplodList").jqGrid('getInd',ids[j])+"ROW는  Block Code가 중복됩니다.";	
					break;	
				}
			}
			
			if (result == false) break;
		}
	}*/
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

//그리드에  checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// 그리드의 모든 Row 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return true;
	});
			
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
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

// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/	
// 엑셀 데이터 저장 서버스 호출 함수		
function fn_save() {
	
	fn_applyData("#excelUplodList",change_block_row_num,change_block_col);
	
	if (confirm('저장 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var changeBlockResultRows =  getChangedGridInfo("#excelUplodList");;
	if (!fn_checkBlockValidate(changeBlockResultRows)) { 
		lodingBox.remove();
		return;	
	}
		
	var url			= "saveExcelPaintPRBlock.do";
	var dataList    = {blockList:JSON.stringify(changeBlockResultRows)};
	var formData 	= getFormData('#listForm');
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			if (data.result == "success") {
				$("#excelUplodList").clearGridData(true);
				opener.fn_search();
				self.close();
			} 
				/*
				if (obj.length >  1) {
					for (var i=1; i<obj.length; i++) {
						
						if (obj[i].error_yn == "Y") {
							$("#excelUplodList").jqGrid('setRowData', obj[i].operId, false, {  color:'black',weightfont:'bold',background:'red'}); 
							$("#excelUplodList").setCell(obj[i].operId,'error_msg',obj[i].error_msg);
							$("#"+data.peList[i].operId+"_chkBoxOV").prop("checked", true);
						} else {
							$("#excelUplodList").jqGrid('setRowData', obj[i].operId, false, {  color:'black',weightfont:'',background:''}); 
							$("#excelUplodList").setCell(obj[i].operId,'error_msg',"");
						}	
					}
				}*/	
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
}

//function fn_applyData(gridId, nRow, nCol) {
//	$(gridId).saveCell(nRow, nCol);
//}

// Loss Code 조회하는 화면 호출 
/* function searchLossCode(obj,sCode,sDesc) {
	
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#excelUplodList",change_block_row_num,change_block_col);
		
	var item = $("#excelUplodList").jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.loss_code};
		
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupLossCode",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$("#excelUplodList").setCell(searchIndex,sCode,rs[0]);
	}
} */

</script>
</body>
</html>