<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hull Paint</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.selected {
		font-weight : bold;
	}

</style>

</head>
<body>
<div id="wrap" style="">
<form id="list_form" name="list_form">
	<input type="hidden"  name="pageYn"     value="N"/>
	<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	
	<table>
			<tr>
			<td width="200px">
					<table  class="searchArea2">
						<tr>
						<td>
						<input type="text" id="txtCondition" name="txtCondition" style="width:120px;"/>
						<input type="button" value="필터" id="btnfilter" class="btn_blue"/>
						</td>
						</tr>			
					</table>
			</td>
			</tr>
		</table>
		<div class="content"  style="margin-top:5px;position:relative; float: left; width: 14.5%;">
			<div id="divSearch">
				<table id = "codeList"></table>
			</div>
		</div>
		<div class="content"  style="margin-top:5px;position:relative; float: right; width: 84.5%;">
			<div id="divList">
		  		<table id="paintItemList"></table>
		  		<div id="p_paintItemList"></div>
			</div>
		</div>
	
</form>
</div>
<script type="text/javascript">
var row_selected, li_selected;
var change_paint_row = 0,change_paint_row_num = 0,change_paint_col = 0;
var tableId	   		 = "#paintItemList";

$(document).ready(function(){
	
	$("#codeList").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames   : ['HULL',''],
             colModel	: [
		                	//{name:'chk', 			index:'chk', 		 width:40,		align:'center',	sortable:false, formatter:formatOpt1},
		                	{name:'discription',	index:'discription', width:130, 	align:'right',	sortable:false},
		                	{name:'code',			index:'code', 		 hidden:true},
		             	  ],
		     cmTemplate: { title: false },
             gridview	 : true,
             toolbar	 : [false, "bottom"],
             viewrecords : false,                	//하단 레코드 수 표시 유무
             width		 : 200,                     //사용자 화면 크기에 맞게 자동 조절
             height		 : parent.objectHeight-90,
             multiselect : true,
	         rowNum		 : 99999, 
	        
	        // rownumbers : true,          	// 리스트 순번
	        // beforeSaveCell : paintItemEditEnd,
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	
	         },
	         onPaging: function(pgButton) {
						
				$(this).jqGrid("clearGridData");

				$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y',filters:""}}).triggerHandler("reloadGrid");  
			},
			loadComplete: function (data) {
					
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
					} );
					this.updatepager(false, true);
				}
			 },
			 gridComplete : function () {
				
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	
   			 },
			 onCellSelect: function(rowid, colId) {
             
			
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
	
	$("#paintItemList").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames   : ['Area Code','Area Desc','제작처','S/P Area','Paint Area',''],
             colModel	: [
		                	{name:'area_code', 			index:'area_code',  		width:50, 	sortable:false},
		                	{name:'area_desc',			index:'area_desc', 			width:200, 	sortable:false, align:'left'},
		                	{name:'make_name',			index:'make_name', 			width:80, 	sortable:false, align:'left'},
		                	{name:'sp_area',			index:'sp_area', 			width:100, 	sortable:false, align:'right'},
		                	{name:'paint_area', 		index:'paint_area',  		width:100, 	sortable:false, align:'right'},
		                	
		                 	{name:'group_id',		    index:'group_id', 			width:25, 	hidden:true}
		             		],
		     cmTemplate: { title: false },
             gridview	: true,
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: parent.objectHeight-75,
            
             pager		: $('#p_paintItemList'),
           	 rowNum		: 99999,
           
             pgbuttons	: false,
			 pgtext		: false,
			 pginput	: false,
	         //rowList	: [100,500,1000],
			 //rowNum		: 100, 
	 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	
	         },
	         onPaging: function(pgButton) {
						
				$(this).jqGrid("clearGridData");

				$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  
			 },
			 loadComplete: function (data) {
					
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
					} );
					this.updatepager(false, true);
				}
			 },
			 gridComplete : function () {
				
				var $this= $(this);
				var rows = $this.getDataIDs(); 
			    
			    for (var i = 0; i < rows.length; i++) {
			     	
			     	var group_id = $this.getCell(rows[i],"group_id");
			    	
			        if(group_id == "1") {
			            $this.jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#FDE9D9'});            
			        } 
			    }
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_paint_row 	 =	rowid;
             	change_paint_row_num =	iRow;
             	change_paint_col 	 =	iCol;		
   			 },
			 onCellSelect: function(rowid, colId) {
            
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
     
     // 그리드 버튼 설정
     $("#paintItemList").jqGrid('navGrid',"#p_paintItemList",{refresh:false,search:false,edit:false,add:false,del:false});
		 
     <c:if test="${userRole.attribute1 == 'Y'}">
	 $("#paintItemList").navButtonAdd("#p_paintItemList",
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
	 
	 // Code Grid 필터 버튼 이벤트
	 $( '#btnfilter' ).click( function() {
					
					var $grid = $("#codeList");
					
					var groups = [], groups2 = [];
					var val	   = $("input[name=txtCondition]").val();
					
					if (!$.jgrid.isEmpty(val)) {					
						
						var arrVal = val.split(",");					
						
						for(var i=0; i<arrVal.length; i++) {
						
							var arrBetween = arrVal[i].split("-");		
							
							if (arrBetween.length == 2) {	
								groups2.push({field:"discription",op: "ge", data: arrBetween[0] });
								groups2.push({field:"discription",op: "le", data: arrBetween[1] });
							} else {
								groups.push({field:"discription",op: "bw", data: arrVal[i] });
							}
						}
					}
													
					$.extend($grid.jqGrid("getGridParam", "postData"), {
					    filters: JSON.stringify({
					       "groupOp": "OR",
						   "rules": [],
						   "groups": [
						        {
						            "groupOp": "OR",
						            "rules"  : groups
						        }
						        ,
						        {
						        	 "groupOp": "AND",
						             "rules"  : groups2
						        }
						    ]
						    

					    })
					});
					
					$grid.jqGrid("setGridParam", {search: true})
					     .trigger('reloadGrid', [{current: true, page: 1}]);
				
				
				} );
		fn_insideGridresize($(window),$("#divSearch"),$("#codeList"),-137);
		fn_insideGridresize($(window),$("#divList"),$("#paintItemList"),-111);
});  //end of ready Function 	    

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 입력된 값이 숫자,소숫점인지 체크하는 함수
function onlyNumber(decimal) {
	event.returnValue = numbersonly(event,decimal);
} 

// 그리드 초기화하는 함수 
function resetGrid(){
	$("#paintItemList").clearGridData();
}

// 그리드 컬럼 show, hide하는 함수 
function fn_setGridColumn() {
	$("#paintItemList").hideCol("area_desc");
	$("#paintItemList").hideCol("paint_count");
		
	if (li_selected == "eRoomCosmetic") {
		$("#paintArea").show();	
		$("#paintItemList").jqGrid('setGridHeight',245);
	}else {
		$("#paintArea").hide();	
		$("#paintItemList").jqGrid('setGridHeight',270);	
	}
}

// area값 설정하는 함수
function fn_setCosmeticArea(nArea) {
	$("input[name=area]").val(nArea);
}

// save버튼 disabled로 설정하는 함수 
function fn_saveButtionEnable() {
    $( "#btnSave" ).removeAttr( "disabled" );
}

// save버튼 able로 설정하는 함수
function fn_saveButtionDisable() {
    $( "#btnSave" ).attr( "disabled", true );
}

// 선택된 code list를 반환하는 함수 
function fn_getCodeList() {
	
	var selData   = $("#codeList").jqGrid('getGridParam','selarrrow');
	
	var code_list = ""; 
		
	for( var i = 0; i < selData.length; i++ ) {
		
		var item = $('#codeList').jqGrid('getRowData',selData[i]);
							
		if ( i > 0) code_list += "','";
		
		code_list += item.code;
	}
	
	return code_list;
}

// window에 resize 이벤트를 바인딩 한다.
function resizeJqGridWidth(){

    $(window).bind('resize', function() {

        $('#paintItemList').setGridWidth(0);

        $('#paintItemList').setGridWidth($('#divList').width()); //Resized to new width as per window

     }).trigger('resize');
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Paint Code 조회하는 함수
function fn_searchCodeList(){
	
	var sUrl = "selectPaintPlanCodeList.do";
	$("#codeList").jqGrid('setGridParam',{ url	    : sUrl
										  ,mtype	: 'POST'
										  ,page	    : 1
										  ,datatype : 'json'
										  ,postData : parent.fn_getParam()}).trigger("reloadGrid");
}

// Paint PlanArea 조회하는 함수
function fn_search(){
	
	var sUrl = "selectHullPaintAreaList.do";
		
	$("#paintItemList").jqGrid('setGridParam',{url	   : sUrl
											 ,page	   : 1
											 ,mtype	: 'POST'
											 ,datatype : 'json'
											 ,postData : parent.fn_getParam()}).trigger("reloadGrid");
}

</script>
</body>
</html>