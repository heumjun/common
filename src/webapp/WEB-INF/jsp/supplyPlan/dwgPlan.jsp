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
설계계획물량관리
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
 
	<table class="searchArea conSearch" >
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="110">
		<col width="60">
		<col width="110">
		<col width="90">
		<col width="130">
		<col width="60">
		<col width="200">
		<col width="50">
		<col width="130">
		<col width="60">
		<col width="60">

		<tr>
			<th>PROJECT</th>
			<td>
				<input type="text" id="i_project" class="required" maxlength="5" name="i_project" style="width:70px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
			</td>

			<th>GROUP</th>
			<td>
				<input type="text" id="i_group1" name="i_group1" style="width:80px; text-align:center; text-transform: uppercase;" />
			</td>
			
			<th>직 종</th>
			<td>
				<input type="text" id="i_group2" name="i_group2" style="width:80px; text-align:center; text-transform: uppercase;" />
			</td>
			
			<th>DESCRIPTION</th>
			<td>
				<input type="text" id="i_description" name="i_description" style="width:100px; text-align:center; text-transform: uppercase;" />
			</td>
			
			<th>견적항목</th>
			<td>
				<select name="p_sel_join_data" id="p_sel_join_data" style="width:150px;" onchange="javascript:joinDataOnChange(this);" >
				</select>
				<input type="hidden" id="p_join_data" name="p_join_data" value=""  />
			</td>
			
			<th>DEPT</th>
			<td>
				<input type="text" id="i_dept" name="i_dept" style="width:100px; text-align:center; text-transform: uppercase;" />
			</td>

			<th>REASON</th>
			<td>
				<select name="i_reason" id="i_reason" style="width:40px">
				    <option value=""></option>
				    <option value="Y">Y</option>
				    <option value="N">N</option>
				</select>
			</td>

			<td class="bdl_no" colspan="2">
				<div class="button endbox">
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="조 회"  id="btnSearch"  class="btn_blue"/>
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="저 장" 	 id="btnSave"  class="btn_blue"/>
					</c:if>	
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="Excel출력" id="btnExport"  class="btn_blue" />
					</c:if>
				</div>
			</td>
		</tr>
		</table>
		
		<font size="2" color="red">(*) : 견적물량 미 존재, 사업계획물량 제공</font>
		
		<div class="content">
			<table id = "dwgPlanGrid"></table>
			<div   id = "p_dwgPlanGrid"></div>
		</div>	
	</div>	
</form>

<script type="text/javascript">

var change_plan_row 	= 0;
var change_plan_row_num = 0;
var change_plan_col  	= 0;

var tableId	   			= "#dwgPlanGrid";
var deleteData 			= [];

var resultData = [];

var searchIndex 		= 0;
var lodingBox; 
var win;	
var userid				= "${loginUser.user_id}";
var chkcell = {cellId:undefined, chkval:undefined};
var jqGridObj = $("#dwgPlanGrid");

getAjaxHtml($("#p_sel_join_data"),"commonSelectBoxDataList.do?sb_type=sel&sd_type=SUPPLY_PLAN_TRACK&p_query=getSupplyChartJoinDataList", null, null);

$(document).ready(function(){
	fn_all_text_upper();
	
	var objectHeight = gridObjectHeight(1);
	
	
	$("#dwgPlanGrid").jqGrid({ 
             datatype	: 'json',              
             url		: '',
             postData   : '',
             colNames:['PROJECT','항목','GROUP','직종', 'DESCRIPTION', 'UOM', '부서', '견적항목', '견적물량(A)', '사업계획물량(B)', '설계목표물량(C)', '목표율(C/B)', '실적물량(D)', '계획달성률(D/B)', '목표달성율(D/C)', 'REASON', 'RESULT_YN', 'SUPPLY_CLOSE_FLAG','EDIT_YN', 'UNIT_YN', 'OPER', 'SUPPLY OVER'],
             colModel:[
				{name:'project', index:'project', width:40, align:'center', editable:false, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}, sortable:false},
				{name:'supply_id', index:'supply_id', width:30, align:'center', sortable:false},
				{name:'group1',index:'group1', width:50, align:'center', sortable:false},
				{name:'group2', index:'group2', width:50, align:'center', sortable:false},
				{name:'description', index:'description', width:200, sortable:false},
				{name:'uom', index:'uom', width:40, align:'center', sortable:false},
				{name:'dept', index:'dept', width:80, align:'center', sortable:false},
				{name:'join_data', index:'join_data', width:80, align:'center', sortable:false},
				{name:'estimate_supply', index:'estimate_supply', width:50, align:'center', editable : false, cellattr:jsFormatterCell, sortable:false},
				{name:'purpose_supply', index:'purpose_supply', width:70, align:'center', editable : true, sortable:false},
				{name:'correspond_supply', index:'correspond_supply', width:70, align:'center', editable : true, hidden:true, sortable:false},
				{name:'correspond_per', index:'correspond_per', width:70, align:'center', editable : false, hidden:true, sortable:false},
				//{name:'result_supply', index:'result_supply', width:40, align:'center', editable : true, formatter:'currency', formatoptions:{thousandsSeparator:",", decimalPlaces:0, defaultValue:''} },
				{name:'result_supply', index:'result_supply', width:70, align:'center', editable : true, sortable:false},
				{name:'purpose_rate', index:'purpose_rate', width:70, align:'center', sortable:false},
				{name:'result_per', index:'result_per', width:70, align:'center', sortable:false, hidden:true},
				{name:'reason', index:'reason', width:40, align:'center', sortable:false},
				{name:'result_yn', index:'result_yn', hidden:true},
				{name:'supply_close_flag', index:'supply_close_flag', hidden:true},
				{name:'edit_yn', index:'edit_yn', hidden:true},
				{name:'unit_yn', index:'unit_yn', hidden:true},
				{name:'oper', index:'oper', width:25, hidden:true},
				{name:'supply_over', index:'supply_over', width:50, align:'center', sortable:false, hidden:true},
             ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_dwgPlanGrid'),
	         pgbuttons : false,
             pgtext : false,
             pginput : false,
             viewrecords : false,
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         //rowList	: [100,500,1000],
			 rowNum		: 99999999999999, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changePlanEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "project_no") setUpperCase("#dwgPlanGrid",rowid,name);
            	
            	var unit_yn = $( "#dwgPlanGrid" ).getCell( rowid, "unit_yn" );
            	
            	if (name == "purpose_supply" && unit_yn == "Y") {
            		var key_group2 = $( "#dwgPlanGrid" ).getCell( rowid, "group2" );
            		var key_join_data = $( "#dwgPlanGrid" ).getCell( rowid, "join_data" );
            		var key_dept = $( "#dwgPlanGrid" ).getCell( rowid, "dept" );
            		var estimate_supply_str = $( "#dwgPlanGrid" ).getCell( rowid, "estimate_supply" );
            		var estimate_supply = "";
            		var sum_purpose_supply = 0;
            		
            		//estimate_supply 천단위 콤마(,) 제거
            		for ( var i = 0; i < estimate_supply_str.length; i++ ) {
            			if( estimate_supply_str[i] != ",") estimate_supply += estimate_supply_str[i];
            		}
            		estimate_supply = estimate_supply * 1;

            		var rows = $( "#dwgPlanGrid" ).getDataIDs();
    				for ( var i = 0; i < rows.length; i++ ) {
    					var temp_group2 = $( "#dwgPlanGrid" ).getCell( rows[i], "group2" );
    					var temp_join_data = $( "#dwgPlanGrid" ).getCell( rows[i], "join_data" );
                		var temp_dept = $( "#dwgPlanGrid" ).getCell( rows[i], "dept" );	
                		if(key_join_data == temp_join_data && key_dept == temp_dept && key_group2 == temp_group2){
                			sum_purpose_supply += $( "#dwgPlanGrid" ).getCell( rows[i], "purpose_supply" ) * 1;
                		}
    				}

   					for ( var i = 0; i < rows.length; i++ ) {
   						var temp_group2 = $( "#dwgPlanGrid" ).getCell( rows[i], "group2" );
       					var temp_join_data = $( "#dwgPlanGrid" ).getCell( rows[i], "join_data" );
                   		var temp_dept = $( "#dwgPlanGrid" ).getCell( rows[i], "dept" );	
                   		if(key_join_data == temp_join_data && key_dept == temp_dept && key_group2 == temp_group2){
                   			if(estimate_supply < sum_purpose_supply){
                   				$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'estimate_supply', '', { background : '#FF6666' } );
                       			$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#FF6666' } );	
                       			$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'supply_over', 'Y');
                   			}
                   			else{
                   				$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'estimate_supply', '', { background : '#DADADA' } );
                       			$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#6DFF6D' } );
                       			$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'supply_over', ' ');
                   			}
                   		}
       				}
   					if(estimate_supply < sum_purpose_supply){
   						alert("견적물량을 초과하였습니다.");
   					}
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
			 gridComplete : function() {
				var rows = $( "#dwgPlanGrid" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					
					//미입력 영역 회색 표시
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'project', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'supply_id', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'group1', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'group2', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'description', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'uom', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'join_data', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'dept', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'estimate_supply', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'correspond_per', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_rate', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'result_per', '', { background : '#DADADA' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#99DDFF' } );
					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'correspond_supply', '', { background : '#99DDFF' } );
	
					//RESULT_YN 체크 된 경우만 실적물량 입력 가능
					var result_yn = $( "#dwgPlanGrid" ).getCell( rows[i], "result_yn" );
					if(result_yn != "Y"){
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'result_supply', '', { background : '#DADADA' } );
					}
					else {
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'result_supply', '', { background : '#99DDFF' } );
					}
					
					//SUPPLY_CLOSE_FLAG 가 'N' 경우만 설계목표물량 입력 가능
					var supply_close_flag = $( "#dwgPlanGrid" ).getCell( rows[i], "supply_close_flag" );
					if(supply_close_flag == "Y"){
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#DADADA' } );
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'correspond_supply', '', { background : '#DADADA' } );
					}
					else {
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#99DDFF' } );
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'correspond_supply', '', { background : '#99DDFF' } );
					}
					
					//STX_DIS_SUPPLY_PLAN 테이블에 이미 저장된 내용은 수정 불가능
					var edit_yn = $( "#dwgPlanGrid" ).getCell( rows[i], "edit_yn" );
					if(edit_yn != "Y"){
						//$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#DADADA' } );
						$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'reason', '', { background : '#FFCCFF' } );
					}
				}
				
				var grid = this;
				$('td[name="cellRowspan"]', grid).each(function() {
					var spans = $('td[rowspanid="'+this.id+'"]',grid).length+1;
					if(spans > 1) {
						$(this).attr('rowspan', spans);
					} 
				});
				
			},
			onCellSelect: function( row_id, iCol, cellcontent, e ) {
				
            	var cm = $(this).jqGrid( "getGridParam", "colModel" );
 				var colName = cm[iCol];
 				var item = $(this).jqGrid( 'getRowData', row_id );
 				
 				//RESULT_YN 체크 된 경우만 실적물량 입력 가능
				var result_yn = $( "#dwgPlanGrid" ).getCell( row_id, "result_yn" );
				if(result_yn != "Y"){
					$(this).jqGrid( 'setCell', row_id, 'result_supply', '', 'not-editable-cell' );
				}
				
				//SUPPLY_CLOSE_FLAG 가 'N' 경우만 실적물량 입력 가능
				var supply_close_flag = $( "#dwgPlanGrid" ).getCell( row_id, "supply_close_flag" );
				if(supply_close_flag == "Y"){
					$(this).jqGrid( 'setCell', row_id, 'purpose_supply', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', row_id, 'correspond_supply', '', 'not-editable-cell' );
				}
 				
 				//STX_DIS_SUPPLY_PLAN 테이블에 이미 저장된 내용은 수정 불가능
				if ( item.edit_yn != "Y" ) {
					//$(this).jqGrid( 'setCell', row_id, 'purpose_supply', '', 'not-editable-cell' );
				}
 				
				if ( colName['index'] == "reason" && item.edit_yn == "N") {
					//window.showModalDialog("popUpDwgPlanReason.do?h_supplyId="+item.supply_id+"&h_project="+item.project , window, "dialogWidth:1400px; dialogHeight:900px; center:on; scroll:off; status:off");
					window.open("popUpDwgPlanReason.do?h_supplyId="+item.supply_id+"&h_project="+item.project, "","width=1400, height=900, scrollbars=no, resizable=no, directories=yes");
					window.focus();
				}					
             },
	         loadComplete : function (data) {
			  				  	
	        	chkcell = {cellId:undefined, chkval:undefined};
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
			    
				//조회시 견적물량(A)보다 사업계획물량(B)이 더 많은지 Validation Check
				var rows = $( "#dwgPlanGrid" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					if ( $( "#dwgPlanGrid" ).getCell( rows[i], "unit_yn" ) == "Y" ) {
						var key_group2 = $( "#dwgPlanGrid" ).getCell( rows[i], "group2" );
            			var key_join_data = $( "#dwgPlanGrid" ).getCell( rows[i], "join_data" );
            			var key_dept = $( "#dwgPlanGrid" ).getCell( rows[i], "dept" );
            			var estimate_supply_str = $( "#dwgPlanGrid" ).getCell( rows[i], "estimate_supply" );
            			var estimate_supply = "";
            			var sum_purpose_supply = 0;
            		
            			//견적물량(A) 천단위 콤마(,) 제거
            			for ( var j = 0; j < estimate_supply_str.length; j++ ) {
            				if( estimate_supply_str[j] != ",") estimate_supply += estimate_supply_str[j];
            			}
            			estimate_supply = estimate_supply * 1;
            		
            			//같은 견적항목,부서에 대하여 사업계획물량(B) 총 합 
    					for ( var j = 0; j < rows.length; j++ ) {
    						var temp_group2 = $( "#dwgPlanGrid" ).getCell( rows[j], "group2" );
    						var temp_join_data = $( "#dwgPlanGrid" ).getCell( rows[j], "join_data" );
                			var temp_dept = $( "#dwgPlanGrid" ).getCell( rows[j], "dept" );	
                			if(key_join_data == temp_join_data && key_dept == temp_dept && key_group2 == temp_group2){
                				sum_purpose_supply += $( "#dwgPlanGrid" ).getCell( rows[j], "purpose_supply" ) * 1;
                			}
    					}
            			
	       				if(estimate_supply < sum_purpose_supply){
	       					$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'estimate_supply', '', { background : '#FF6666' } );
	           				$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#FF6666' } );	
	           				$( "#dwgPlanGrid" ).jqGrid( 'setCell', rows[i], 'supply_over', 'Y');
	       				}
					}
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
	$("#dwgPlanGrid").navButtonAdd("#p_dwgPlanGrid",
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
    fn_gridresize($(window),$("#dwgPlanGrid"),35);
	
	//엑셀 export
	$("#btnExport").click(function() {
		fn_excelDownload();	
	});

	
	
	//fn_buttonDisabledUser(userid, ["#btnSave","#btnRevisionAdd"]);
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/

var joinDataOnChange = function(obj) {
	$("input[name=p_join_data]").val($(obj).find("option:selected").val());
	//$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
}

function numFormatter(cellvalue, options, rowObject ) {
	//if(cellvalue != 'undefined' && cellvalue != '') {
		
		var txtNumber = '' + cellvalue;    // 입력된 값을 문자열 변수에 저장합니다.

	    if (isNaN(txtNumber) || txtNumber == "") {    // 숫자 형태의 값이 정상적으로 입력되었는지 확인합니다.
	        //alert("숫자만 입력 하세요");
	        return '';
	    } else {
	        var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');    // 정규식 형태 생성
	        var arrNumber = txtNumber.split('.');    // 입력받은 숫자를 . 기준으로 나눔. (정수부와 소수부분으로 분리)
	        arrNumber[0] += '.'; // 정수부 끝에 소수점 추가

	        do {
	            arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2'); // 정수부에서 rxSplit 패턴과 일치하는 부분을 찾아 replace 처리
	        } while (rxSplit.test(arrNumber[0])); // 정규식 패턴 rxSplit 가 정수부 내에 있는지 확인하고 있다면 true 반환. 루프 반복.

	        if (arrNumber.length > 1) { // txtNumber를 마침표(.)로 분리한 부분이 2개 이상이라면 (즉 소수점 부분도 있다면)
	            return arrNumber.join(''); // 배열을 그대로 합칩. (join 함수에 인자가 있으면 인자를 구분값으로 두고 합침)
	        } else { // txtNumber 길이가 1이라면 정수부만 있다는 의미.
	            return arrNumber[0].split('.')[0]; // 위에서 정수부 끝에 붙여준 마침표(.)를 그대로 제거함.
	        }
	    }
}
	
function perFormatter(cellvalue, options, rowObject ) {
	//if(cellvalue != 'undefined' && cellvalue != '') {
		
		var txtNumber = '' + cellvalue;    // 입력된 값을 문자열 변수에 저장합니다.

	    if (isNaN(txtNumber) || txtNumber == "") {    // 숫자 형태의 값이 정상적으로 입력되었는지 확인합니다.
	        //alert("숫자만 입력 하세요");
	        return '';
	    } else {
	        var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');    // 정규식 형태 생성
	        var arrNumber = txtNumber.split('.');    // 입력받은 숫자를 . 기준으로 나눔. (정수부와 소수부분으로 분리)
	        arrNumber[0] += '.'; // 정수부 끝에 소수점 추가

	        do {
	            arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2'); // 정수부에서 rxSplit 패턴과 일치하는 부분을 찾아 replace 처리
	        } while (rxSplit.test(arrNumber[0])); // 정규식 패턴 rxSplit 가 정수부 내에 있는지 확인하고 있다면 true 반환. 루프 반복.

	        if (arrNumber.length > 1) { // txtNumber를 마침표(.)로 분리한 부분이 2개 이상이라면 (즉 소수점 부분도 있다면)
	            return arrNumber.join('') + '%'; // 배열을 그대로 합칩. (join 함수에 인자가 있으면 인자를 구분값으로 두고 합침)
	        } else { // txtNumber 길이가 1이라면 정수부만 있다는 의미.
	            return arrNumber[0].split('.')[0] + '%'; // 위에서 정수부 끝에 붙여준 마침표(.)를 그대로 제거함.
	        }
	    }
}

function jsFormatterCell(rowid, val, rowObject, cm, rdata) {
	var result = '';
	var data = rowObject.join_data + "" + rowObject.dept;

	if(chkcell.chkval != data) {

		var cellId = this.id + '_row_' + rowid + '-' + cm.name;
		result = 'rowspan="1" id="' + cellId + '" + name="cellRowspan"';
		chkcell = {cellId:cellId, chkval:data};
		
	} else {
		result = 'style="display:none" rowspanid="'+chkcell.cellId+'"';
	}
	return result;
}


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
	
	//견적 물량을 초과한 항목이 있는지 확인
// 	var rows = $( "#dwgPlanGrid" ).getDataIDs();
// 	for ( var i = 0; i < rows.length; i++ ) {
// 		if ( $( "#dwgPlanGrid" ).getCell( rows[i], "supply_over" ) == "Y" ) {
// 			alert("견적물량을 초과한 항목이 존재합니다.");
// 			return;
// 		}
// 	}
	
	if (!fn_checkPlanValidate(changePlanResultRows)) { 
		return;	
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
	
	var sUrl = "dwgPlanList.do";

	$( "#dwgPlanGrid" ).jqGrid( "clearGridData" );
	$( "#dwgPlanGrid" ).jqGrid( 'setGridParam', {
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
	location.href='dwgPlanExcelExport.do?i_project='+$("#i_project").val()
										+'&i_group1='+$("#i_group1").val()
										+'&i_group2='+$("#i_group2").val()
										+'&i_description='+$("#i_description").val()
										+'&p_join_data='+$("#p_join_data").val()
										+'&i_dept='+$("#i_dept").val()
										+'&i_reason='+$("#i_reason").val();
}
</script>
</body>
</html>