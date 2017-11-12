<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PRE PAINTING TEAM</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.selected {
		font-weight : bold;
	}

</style>

</head>
<body>
<form id="list_form" name="list_form">
	<input type="hidden"  name="pageYn" value="N"/>
	<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>

	
	
		<div style="width: 100%;">
			<fieldset style="border:none;position:relative; float:left; width: 270px;">
				<legend class="sc_tit mgt10 sc_tit2">구분</legend>
				<div id="gubun" style="overflow-y:scroll; height:260px; overflow-x:hidden;">
					<ul class="ct_list">
						<c:forEach var="item" items="${gbnList}" varStatus="status">
							<li id="${item.id}" type="${item.addCodeFlag},${item.viewAreaFlag},${item.paingGbn}">
							<div style="width: 200px;">${item.gbnDesc}</div></li>
						</c:forEach>
					</ul>
				</div>
			</fieldset>
	
			<fieldset style="border:none;position:relative; width: 100%-270px;">
		  		<legend class="sc_tit mgt10 sc_tit2">ITEM</legend>
		  		<div id="wrap"  style="position: relative; float: left; width: 100%;">
		  		 	<table id="paintItemList"></table>
			  		<div id="p_paintItemList"></div>
			  		<div id="paintArea"  style="margin-top:2px;">
						면적 <input type="text" id="txtArea" name="area" style="width:150px; text-align:left; ime-mode:disabled; text-transform: uppercase;"  onKeyPress="return numbersonly(event, true)" />
						<c:if test="${userRole.attribute4 == 'Y'}">
						   <input type="button" value="저  장" id="btnSave" class="btn_gray" disabled/>
						</c:if>	
					</div>
				</div>
		  	</fieldset>
	</div>
</form>
<script type="text/javascript">
var row_selected, li_selected, li_selected_add_flag, li_view_area_flag, li_paing_gbn;
var change_paint_row = 0,change_paint_row_num = 0,change_paint_col = 0;
var tableId	   		 = "#paintItemList";
var selectItemCode;
$(document).ready(function(){
	
	$(window).bind('resize', function() {
		$("#gubun").css({'height':   $(window).height()-30});
	}).trigger('resize');
	// 물량 구분 list클릭시 호출하는 이벤트
	$("li").click( function(e) {
		
		if (parent.fn_ProjectNoCheck(false)) {
			
			$("li").each(function () {
				$("li").removeClass("selected");
			});
			
			$(this).addClass("selected");
			
			li_selected = $(this).attr("id");
			var li_flag = $(this).attr("type").split(",");
			li_selected_add_flag = li_flag[0];
			li_view_area_flag = li_flag[1];
			li_paing_gbn = li_flag[2];
			
			fn_setGridColumn();
			
			parent.fn_setSearchGbn(li_selected, li_paing_gbn);
		
			fn_search();
		}
	});
	
	// 물량 구분 list 마우스오브시 호출하는 이벤트
	$("li").mouseenter( function() {
		$(this).css("cursor","pointer");
	});
	
	$("#paintItemList").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames   : ['AREA','COUNT','PAINT CODE','PAINT DESC','QTY','THEORY QTY','CHECK',''],
             colModel	: [
		                	{name:'area_desc', 			index:'area_desc',  		width:150, 	sortable:false},
		                	{name:'paint_count',		index:'paint_count', 		width:50, 	sortable:false, align:'right'},
		                	{name:'paint_item', 		index:'paint_item',  		width:150, 	sortable:false, editable:true, editoptions: {maxlength : 25, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
		                	{name:'item_desc',			index:'item_desc', 			width:320, 	sortable:false},
		             		{name:'quantity', 			index:'quantity',  			width:80, 	sortable:false, align:'right', editable:true, editrules:{required:true,number:true}},
		             		{name:'theory_quantity', 	index:'theory_quantity',  	width:80, 	sortable:false, align:'right', hidden:true},
		                	{name:'chk', 				index:'chk',  				width:70, 	sortable:false, align:'center'},
		                
		                 	{name:'oper',		index:'oper', 				width:25, 	hidden:true}
		             		],
 
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             autowidth	: true,                  //사용자 화면 크기에 맞게 자동 조절
             height		: parent.objHeight,
            
             pager		: $('#p_paintItemList'),
             //shrinkToFit:false, 
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         	         
	         rowList	: [100,500,1000],
			 rowNum		: 100, 
	        // rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : paintItemEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
	        	 var item = $('#paintItemList').jqGrid('getRowData', rowid);
	            	if( item.oper == "I" ) {
	            		if ( name == "paint_item" ) {
	            			var item = $('#paintItemList').jqGrid('getRowData',rowid);		
	            			var args = {item_code : item.paint_item};
	            			
	            			var rs = window.showModalDialog("popupPaintCode.do",args,"dialogWidth:600px; dialogHeight:550px; center:on; scroll:off; status:off; location:no");
	            			
	            			if (rs != null) {
	            				item.paint_item = rs[0];
	            				item.item_desc = rs[1];
	            			} else {
	            				item.paint_item = '';
	            				item.item_desc = '';
	            			}
	            			$('#paintItemList').jqGrid("setRowData", rowid, item);
	            		}
	            	}

	            	
                 //searchItemCode("#paintItemList",'paint_item','item_desc',change_paint_row_num,change_paint_col);
	         },
	         onPaging: function(pgButton) {
   			 
   			 },
	         loadComplete : function (data) {
	        	 
			 },
			 gridComplete : function () {
				$("#paintItemList td:contains('+')").css("cursor","pointer");
				$("#paintItemList td:contains('─')").css("cursor","pointer");
				$("#paintItemList td:contains('삭제')").css("cursor","pointer");
				$("#paintItemList td:contains('삭제')").css("background","pink");
				
				var rows = $( "#paintItemList" ).getDataIDs();

				for ( var i = 0; i < rows.length; i++ ) {
					//수정 및 결재 가능한 리스트 색상 변경
					var oper = $( "#paintItemList" ).getCell( rows[i], "oper" );
					if (oper == "I"){
						$( "#paintItemList" ).jqGrid( 'setCell', rows[i], 'paint_item', '', { cursor : 'pointer', background : 'pink' } );
					}
					var paint_item = $( "#paintItemList" ).getCell( rows[i], "paint_item" );
					if (paint_item == selectItemCode) {
						$( "#paintItemList" ).jqGrid( 'editCell',rows[i], 2, false );
					}
					
				}
				//grid resize
				fn_insideGridresize($(window),$("#wrap"),$("#paintItemList"),-100);
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_paint_row 	 =	rowid;
             	change_paint_row_num =	iRow;
             	change_paint_col 	 =	iCol;		
   			 },
			 onCellSelect: function(rowid, colId) {
             	
             	if (rowid != null) {
             		
             		fn_applyData("#paintItemList",change_paint_row_num,change_paint_col);
	               	
	               	var ret = $("#paintItemList").getRowData(rowid);
	               	
	               	if ((ret.oper != "I")) {
             			$("#paintItemList").jqGrid('setCell', rowid, 'paint_item', '', 'not-editable-cell');
             			$("#paintItemList").jqGrid('setCell', rowid, 'quantity', '', 'not-editable-cell');
             		}
             		
             		if(colId == 6) {
			 		 	
			 		 	if (ret.chk == "+") {
				 		 	if ($.jgrid.isEmpty(ret.paint_item)) {
				 		 		alert("PAINT CODE is required");
				 		 	} else if (ret.quantity == 0 || $.jgrid.isEmpty(ret.quantity)) {
				 		 	 	alert("PAINT QUANTITY가 0이상이여야 합니다");
				 		 	} else {	
					 			
					 			parent.plusPaintItem("grid", ret.paint_item, ret.item_desc, ret.quantity, 0);	
					 		}	 	
			 		 	} else if (ret.chk == "─" || ret.chk == "삭제"){
			 		 		parent.minusPaintItem("grid", ret.paint_item, ret.item_desc, ret.quantity, 0);	
			 		 	}
	
					}
             		parent.selectItem(li_selected, ret.paint_item);
             	}
             },  	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images'
            
     });
	//grid resize
	fn_insideGridresize($(window),$("#wrap"),$("#paintItemList"),-100);
	
     // 그리드 버튼 설정
     $("#paintItemList").jqGrid('navGrid',"#p_paintItemList",{refresh:false,search:false,edit:false,add:false,del:false});
	 
     <c:if test="${userRole.attribute2 == 'Y'}">
	 // 그리드 Row 추가 함수 설정
	 $("#paintItemList").navButtonAdd('#p_paintItemList',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: fn_addPaintCode,
				position: "first", 
				title:"Add", 
				cursor: "pointer",
				id: "add_paintCode"
			} 
	 );
	 </c:if>
 	
 	 var $td = $('#add_paintCode');
	 $td.hide();
	 
	 /* 
	 Area 면적 저장
	 */
	$("#btnSave").click(function() {
		var val1 = $("#txtArea").val();
		if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
			alert("면적이 0이상이여야 합니다.");			
			return;
		}
		fn_areaSave();
	});
	 
	// Team의 Area불러오는 함수
	fn_searchOutfittingArea()
	
	if ("Y" == parent.isLastRev && parent.sState != "D") {
		fn_saveButtionEnable();
	} else {
		fn_saveButtionDisable();
	}
   	
});  //end of ready Function 	    

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//Team Group에 Item추가 저장하는 함수
function fn_areaSave() {
	
	if (!parent.fn_ProjectNoCheck(false)) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var url			= "saveOutfittingArea.do";
	parent.fn_setArea($("input[name=area]").val());
	var parameters  = parent.fn_getFormData('#listForm');
	
	$.post(url, parameters, function(data) {
			alert(data.resultMsg);
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
}
// Team의 Area불러오는 함수
function fn_searchOutfittingArea() {
	
	var url		    = "infoOutfittingArea.do";
 	var parameters  = parent.fn_getFormData('#listForm');
						
	$.post(url, parameters, function(data) {
					
	  	if (data != null) {
	  		fn_setOutfittingArea(data.area);
	  	} else {
	  		fn_setOutfittingArea("");
	  	}
	 
	},"json");  	

}
// paintCode 추가
function fn_addPaintCode(item){
	
	//grid 저장 처리
	fn_applyData("#paintItemList",change_paint_row_num,change_paint_col);
	
	var item = {};
	var colModel = $('#paintItemList').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	= 'I';
	item.chk 	= '+';
	
	var nRandId = $.jgrid.randId();
	
	$('#paintItemList').resetSelection();
	$('#paintItemList').jqGrid('addRowData', nRandId, item, 'last');
		
	//fn_jqGridChangedCell('#paintItemList', nRandId, 'chk', {background:'pink'});
	
	tableId = '#paintItemList';
	
	var $td = $('#add_paintCode');
	//$td.hide();	
}

// afterSaveCell oper 값 지정
function paintItemEditEnd(irowId, cellName, value, irow, iCol) {
	
	var item = $('#paintItemList').jqGrid('getRowData',irowId);
	
	$('#paintItemList').jqGrid("setRowData", irowId, item);
	
	$("input.editable,select.editable", this).attr("editable", "0");	
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드 초기화하는 함수
function resetGrid(){
	$("#paintItemList").clearGridData();
}

// 그리드 컬럼 show, hide하는 함수
function fn_setGridColumn() {
	if (li_view_area_flag == "Y") {
		$("#paintItemList").showCol("area_desc");
		$("#paintItemList").showCol("paint_count");
	}else {
		$("#paintItemList").hideCol("area_desc");
		$("#paintItemList").hideCol("paint_count");
	}
	//grid resize
	//fn_insideGridresize($(window),$("#wrap"),$("#paintItemList"),-100);
	
}

// save버튼 disabled로 설정하는 함수
function fn_saveButtionEnable() {
	fn_buttonEnable([ "#btnSave" ]);
}

// save버튼 able로 설정하는 함수
function fn_saveButtionDisable() {
	fn_buttonDisabled([ "#btnSave" ]);
}

// area값 설정하는 함수
function fn_setOutfittingArea(nArea) {
	$("input[name=area]").val(nArea);
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 해당Team에서 추가할수있는 Item항목 조회    
function fn_search(){
	
	var sUrl = "selectOutfittingList.do";
		
	var $td = $('#add_paintCode');
	
	if (!parent.fn_isEditable()) {
		$td.hide();	
		$("#paintItemList").hideCol("chk");
		fn_saveButtionDisable();
	} else {
		$("#paintItemList").showCol("chk");
		fn_saveButtionEnable();
		
		if (li_selected_add_flag == "Y") {
			$td.show(); 
		} else {
			$td.hide();
		}
	}
	
	$("#paintItemList").jqGrid('setGridParam',{url	   : sUrl
												 ,mtype		: 'POST'
												 ,page	   : 1
												 ,datatype : 'json'
												 ,postData : parent.fn_getParam()}).trigger("reloadGrid");
}

// Paint Item 조회하는 화면 호출
function searchItemCode(obj, sCode, sDesc, nRow, nCol) {
	
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData(tableId,nRow,nCol);
	
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	var args = {item_code : item.paint_item};
	
	var rs = window.showModalDialog("popupPaintCode.do",args,"dialogWidth:600px; dialogHeight:550px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
	}
}
function selectGbn(id,item) {
	selectItemCode = item;
	$("#"+id).click();
}
</script>
</body>
</html>