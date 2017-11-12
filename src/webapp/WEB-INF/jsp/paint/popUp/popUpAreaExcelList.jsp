<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Area</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<input type="hidden" id="cmd" name="cmd" />
	<div id="mainDiv">
		<div  class = "topMain" style="line-height:45px">
			
				<div class = "button" >
					<input type="button" value="저장" id="btnSave" />
					<input type="button" value="닫기" id="btnClose" />
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
	
var change_area_row 	= 0;
var change_area_row_num = 0;
var change_area_col  	= 0;

var uploadList = $.parseJSON('${uploadList}');

var lodingBox;

$(document).ready(function() {
		
	opener.resizeWin();

	$("#excelUplodList").jqGrid({ 
         datatype	: 'local', 
         mtype		: 'POST', 
         url		: '',
         colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Area Code','Area Name','Loss Code','AF Code','Error MSG',''],
             colModel:[
                 {name:'chk', index:'chk', width:25,align:'center',formatter: formatOpt1},
                 {name:'area_code',index:'area_code', width:50,  editable : true, editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                 {name:'area_desc',index:'area_desc', width:120, editable : true},
                 {name:'loss_code',index:'loss_code', width:50, editable : true, editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                 {name:'af_code',  index:'af_code',   width:110, editoptions: { dataInit: function(elem) {$(elem).width(150);}}  // set the width which you need
                 		,editable : true, align :'left', sortable : false, edittype : 'select', formatter : 'select', editrules : { required:true } },
                 {name:'error_msg',index:'error_msg',width:75},
                 {name:'operId',  index:'operId', hidden : true}
             ],
             
         gridview	 : true,
         cmTemplate: { title: false },
         toolbar	 : [false, "bottom"],
         //sortname: 'revision_no', 
         //sortorder: "asc", 
         viewrecords : false,
         autowidth 	 : true,
         height		 : G_HEADER_PAGER - 20,
         pager		 : $('#pexcelUplodList'),
         rowNum		 : 99999, 
         cellEdit	 : true,             // grid edit mode 1
       	 cellsubmit	 : 'clientArray',  	// grid edit mode 2
       	 rownumbers  : true,          	// 리스트 순번	
         pgbuttons	 : false,
		 pgtext		 : false,
		 pginput	 : false,
		 loadComplete : function (data) {
		 },	   
		 afterSaveCell  : function(rowid,name,val,iRow,iCol) {
           	if (name == "area_code" || name == "loss_code") setUpperCase('#excelUplodList',rowid,name);	
         },
		 gridComplete : function () {
		
		 },
		 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	change_area_row 	=	rowid;
            	change_area_row_num =	iRow;
            	change_area_col 	=	iCol;
  			 },
         jsonReader : {
             root		: "rows",
             page		: "page",
             total		: "total",
             records 	: "records",  
             repeatitems: false,
            },        
         imgpath: 'themes/basic/images'
           
    	}); 
	
    
   	$.post( "infoComboCodeMaster.do?sd_type=PAINT_AF_CODE", "", function( data2 ) {
		$( '#excelUplodList' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'af_code',
			data : data2
		} );
		// 업로드 데이터 그리드에 추가  		
		$('#excelUplodList').setGridParam({
						page : 1,
						data : uploadList,
								}).trigger('reloadGrid');
	}, "json" );
   	
   /*  //AF CODE
	$.post( "selectPaintCodeList.do", {addCode:'Not',main_category:'PAINT',states_type:'AF CODE'}, function( data ) {
		$( '#excelUplodList' ).setObject( { value : 'value', text : 'text', name : 'af_code', data : data } );
		
		 var data3 =  {
            "page": "1",
            "rows": uploadList
        };
       	$("#excelUplodList")[0].addJSONData(data3); 	
	} );   */
    	
    $("#excelUplodList").jqGrid('navGrid',"#pexcelUplodList",{refresh:false,search:false,edit:false,add:false,del:false});

	$("#excelUplodList").navButtonAdd('#pexcelUplodList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
    
    // 엑셀데이터 저장 버튼 이벤트	
	$("#btnSave").click(function(){
		fn_save();					
	});
	
	// 닫기 버튼 이벤트
	$("#btnClose").click(function(){
		self.close();					
	});
	/* var gridData =  {
   	       	"page": "1",
   	        "rows": uploadList
   	       }; */
   	   
 	
	//$("#excelUplodList")[0].addJSONData(data);
	
	
	});
	/***********************************************************************************************																
	 * 이벤트 함수 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	// 그리드 row삭제 함수 
	function deleteRow() {

		fn_applyData("#excelUplodList", change_area_row_num, change_area_col);

		//가져온 배열중에서 필요한 배열만 골라내기 
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi, po) {
			chked_val += po.value + ",";
		});

		var selarrrow = chked_val.split(',');

		for (var i = 0; i < selarrrow.length - 1; i++) {
			var selrow = selarrrow[i];
			$('#excelUplodList').jqGrid('delRowData', selrow);
		}

		$('#excelUplodList').resetSelection();

	}

	//header checkbox action 
	function checkBoxHeader(e) {
		e = e || event;/* get IE event ( not passed ) */
		e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
		if (($("#chkHeader").is(":checked"))) {
			$(".chkboxItem").prop("checked", true);
		} else {
			$("input.chkboxItem").prop("checked", false);
		}
	}

	/***********************************************************************************************																
	 * 기능 함수 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	// 엑셀 데이터 validation체크하는 함수
	function fn_checkAreaValidate(arr1) {
		var result = true;
		var message = "";
		var ids;

		if (arr1.length == 0) {
			result = false;
			message = "변경된 내용이 없습니다.";
		}

		if (result && arr1.length > 0) {
			ids = $("#excelUplodList").jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {

				//if (oper == 'I' || oper == 'U') {

				var val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'area_code');
				if ($.jgrid.isEmpty(val1)) {
					result = false;
					message = "Area Code Field is required";

					setErrorFocus("#excelUplodList", ids[i], 2, 'area_code');
					break;
				}

				val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'loss_code');

				if ($.jgrid.isEmpty(val1)) {
					result = false;
					message = "Loss Code Field is required";

					setErrorFocus("#excelUplodList", ids[i], 4, 'loss_code');
					break;
				}

				val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'af_code');

				if ($.jgrid.isEmpty(val1)) {
					result = false;
					message = "AF Code Field is required";

					setErrorFocus("#excelUplodList", ids[i], 5, 'af_code');
					break;
				}
				//}
			}
		}

		if (result && arr1.length > 0) {
			ids = $("#excelUplodList").jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {
				var iRow = $("#excelUplodList").jqGrid('getRowData', ids[i]);

				for (var j = i + 1; j < ids.length; j++) {
					var jRow = $("#excelUplodList").jqGrid('getRowData', ids[j]);
					if (iRow.area_code == jRow.area_code) {
						result = false;
						message = $("#excelUplodList").jqGrid('getInd', ids[i]) + "ROW, "
								+ $("#excelUplodList").jqGrid('getInd', ids[j]) + "ROW는  Area Code가 중복됩니다.";
						break;
					}
				}

				if (result == false)
					break;
			}
		}

		if (!result) {
			alert(message);
		}

		return result;
	}

	// 그리드 변경된 데이터를 가져오는 함수
	function getChangedGridInfo(gridId) {
		var changedData = $.grep($(gridId).jqGrid('getRowData'), function(obj) {
			return true;
		});

		return changedData;
	}

	// 포커스 이동
	function setErrorFocus(gridId, rowId, colId, colName) {
		$("#" + rowId + "_" + colName).focus();
		$(gridId).jqGrid('editCell', rowId, colId, true);
	}

	//폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
		var unindexed_array = $(form).serializeArray();
		var indexed_array = {};

		$.map(unindexed_array, function(n, i) {
			indexed_array[n['name']] = n['value'];
		});

		return indexed_array;
	}

	// 그리드 편집시 대분자로 변환하는 함수
	function setUpperCase(gridId, rowId, colNm) {

		if (rowId != 0) {

			var $grid = $(gridId);
			var sTemp = $grid.jqGrid("getCell", rowId, colNm);

			$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
		}
	}

	//그리드에 checkbox 생성
	function formatOpt1(cellvalue, options, rowObject) {
		var rowid = options.rowId;

		return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
	}

	/***********************************************************************************************																
	 * 서비스 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	// 엑셀 데이터 저장 서버스 호출 함수
	function fn_save() {

		fn_applyData("#excelUplodList", change_area_row_num, change_area_col);

		lodingBox = new ajaxLoader($('#mainDiv'), {
			classOveride : 'blue-loader',
			bgColor : '#000',
			opacity : '0.3'
		});

		// ERROR표시를 위한 ROWID 저장
		var ids = $("#excelUplodList").jqGrid('getDataIDs');

		for (var j = 0; j < ids.length; j++) {
			$('#excelUplodList').setCell(ids[j], 'operId', ids[j]);
		}

		var changeAreaResultRows = getChangedGridInfo("#excelUplodList");
		;

		if (!fn_checkAreaValidate(changeAreaResultRows)) {
			lodingBox.remove();
			return;
		}

		var url = "saveExcelPaintArea.do";
		var dataList = {
			areaList : JSON.stringify(changeAreaResultRows)
		};
		var formData = getFormData('#listForm');

		var parameters = $.extend({}, dataList, formData);

		$.post(
				url,
				parameters,
				function(data) {

					alert(data.resultMsg);
					if (data.result == "success") {
						$("#excelUplodList").clearGridData(true);
						opener.fn_search();
						self.close();
					} else if (data.result == "fail") {
						if (data.areaList.length > 0) {
							for (var i = 0; i < data.areaList.length; i++) {

								if (data.areaList[i].error_yn == "Y") {
									$("#excelUplodList").jqGrid('setRowData', data.areaList[i].operId, false, {
										color : 'black',
										weightfont : 'bold',
										background : 'red'
									});
									$("#"+data.areaList[i].operId+"_chkBoxOV").prop("checked", true);
									$("#excelUplodList").setCell(data.areaList[i].operId, 'error_msg',
											data.areaList[i].error_msg);
								} else {
									$("#excelUplodList").jqGrid('setRowData', data.areaList[i].operId, false, {
										color : 'black',
										weightfont : '',
										background : ''
									});
									$("#excelUplodList").setCell(data.areaList[i].operId, 'error_msg', "");
								}
							}
						}
					}
				}).fail(function() {
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
			lodingBox.remove();
		});
	}
	/* 
	 // lossCode 조회하는 함숨
	 function searchLossCode(obj,sCode,sDesc) {
	
	 var searchIndex = $(obj).closest('tr').get(0).id;
	
	 fn_applyData("#excelUplodList",change_area_row_num,change_area_col);
	
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