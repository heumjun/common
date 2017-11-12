<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Master Item 관리</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form name="listForm" id="listForm"  method="get">

<input type="hidden" id="p_item_code" name="p_item_code" value="" />



<div id="mainDiv" class="mainDiv">

<input type="hidden" id="p_col_name" name="p_col_name" value="" />
<input type="hidden" id="p_data_name" name="p_data_name" value="" />
<input type="hidden" id="page" name="page" value="" />
<input type="hidden" id="rows" name="rows" value="" />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
<input type="hidden" name="loginGubun" id="loginGubun"  value="${loginGubun}" />
<input type="hidden" name="p_Master"   id="p_Master" value=""/>
<input type="hidden" name="p_pjt"   id="p_pjt" value=""/>
<input type="hidden" name="p_Dwg_nos"   id="p_Dwg_nos" value=""/>
<input type="hidden" name="p_flag"   id="p_flag" value=""/>
<input type="hidden" name="p_Pr_state"   id="p_Pr_state" value=""/>
<input type="hidden" name="p_itemCd"   id="p_itemCd" value=""/>
<input type="hidden" name="p_itemCodes"   id="p_itemCodes" value=""/>
<input type="hidden" name="p_status"   id="p_status" value=""/>
<input type="hidden" name="pageYn" id="pageYn"  value="N" />
<input type="hidden" name="p_isexcel"   id="p_isexcel" value=""/>
<input type="hidden" name="p_filename"   id="p_filename" value=""/>

<div class= "subtitle">
Master Item 관리
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
		 
			<table class="searchArea conSearch">
				<col width="65">
				<col width="100">
				<col width="75">
				<col width="100">
				<col width="60">
				<col width="75">
				<col width="50">
				<col width="75">
				<col width="79">
				<col width="100">
				<col width="64">
				<col width="100">

				<tr>
					<th>기자재명</th>
					<td>
						<input type="text" id="p_equip_name" name="p_equip_name" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>
					
					<th>중분류 CODE</th>
					<td>
						<input type="text" id="p_middle_code" name="p_middle_code" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>
					
					<th>DWG No.</th>
					<td>
						<input type="text" id="p_dwg_code" name="p_dwg_code" style="width:50px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>
					 
					<th>Catalog</th>
					<td>
						<input type="text" id="p_catalog_code" name="p_catalog_code" style="width:50px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>
					
					<th>Catalog Desc.</th>
					<td>
						<input type="text" id="p_catalog_name" name="p_catalog_name" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>
					
					<th>Item Code</th>
					<td>
						<input type="text" id="p_item_code" name="p_item_code" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>

					<td style="border-left:none;">
						<div class="button endbox">							
							<input type="button" value="조회" id="btnSearch" class="btn_blue" />
							<input type="button" value="저장" id="btnSave"  class="btn_blue" />
							<input type="button" value="추가" id="btnAdd"  class="btn_blue" />							
							<input type="button" class="btn_blue" value="닫기" id="btnClose" />
						</div>
					</td>						
				</tr>
				
			</table>
			
			<table class="searchArea2">
				<col width="65">
				<col width="100">
				<col width="75">
				<col width="100">
				<col width="60">
				<col width="75">
				<col width="50">
				<col width="75">
				<col width="79">
				<col width="100">
				<col width="64">
				<col width="100">
				<col width="">

				<tr>
					<th>Item Desc.</th>
					<td style="height:30px;">
						<input type="text" id="p_item_desc" name="p_item_desc" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onChange="javascript:this.value=this.value.toUpperCase();"/>
					</td>
					
					<th>설계부서</th>
					<td>
						<input type="text" id="p_plan_part" name="p_plan_part" style="width:75px;"/>
					</td>
					
					<th>구매자</th>
					<td>
						<input type="text" id="p_buyer" name="p_buyer" style="width:50px;"/>
					</td>
					 
					<th>중요도</th>
					<td>
						<select name="p_importance" id="p_importance" style="width:50px;" >
							<option value="">ALL</option>
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="C">C</option>
						</select>
						
					</td>
					
					<th>납기기준</th>
					<td>
						<select name="p_equip" id="p_equip" style="width:50px;" >
							<option value="">ALL</option>
							<option value="PSE">PSE</option>
							<option value="EPS">EPS</option>
							<option value="EQU">EQU</option>
						</select>
					</td>
					
					<th>Status</th>
					<td>
						<select name="p_selStatus" id="p_selStatus" style="width:130px;" >
							<option value="">ALL</option>
							<option value="RAP">RAP:승인요청(설계)</option>
							<option value="RAD">RAD:승인요청(조달)</option>	
							<option value="S">S:승인완료</option>
							<option value="RCP">RCP:취소요청(설계)</option>
							<option value="RCD">RCD:취소요청(조달)</option>
							<option value="C">C:취소완료</option>
						</select>
					</td>
										
					<td style="border-left:none;">
						<div class="button endbox">
							<input type="button" value="요청/승인/반려" id="btnApprove" class="btn_blue" />
							<input type="button" value="적용 선종 선택" id="btnAppShip"  class="btn_blue" />
							<input type="button" value="선종 DP 관리" id="btnShipDp"  class="btn_blue" />							
						</div>
					</td>			
				</tr>

			</table>
		
			<div class="content">
			<table id = "MasterItemGrid"></table>
			<div   id = "btnitemTransList"></div>
		</div>	
	</div>	
</form>

<script type="text/javascript">

var idRow = 0;
var idCol = 0;
var nRow = 0;
var kRow = 0;
var row_selected = 0;

var change_plan_row 	= 0;
var change_plan_row_num = 0;
var change_plan_col  	= 0;

var tableId	   			= "#MasterItemGrid";
var deleteData 			= [];

var resultData = [];

var searchIndex 		= 0;
var lodingBox; 
var win;	
var userid				= "${loginUser.user_id}";

var is_obtain_user = false;
if ("${loginGubun}" != "obtain") {
	is_obtain_user = true;
}

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'Status', name:'status' , index:'status' ,width:40 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'기자재명' ,name:'equip_name' , index:'equip_name' ,width:200 ,align:'left', sortable:false, title:false} );
	gridColModel.push({label:'DWG No.', name:'dwg_code' , index:'dwg_code' ,width:70 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'Sub DWG.', name:'sub_dwg_code' , index:'sub_dwg_code' ,width:70 ,align:'center', sortable:false, title:false, editable:true} );
	gridColModel.push({label:'Catalog', name:'catalog_code' , index:'catalog_code' ,width:60 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'ItemCode' ,name:'item_code' , index:'item_code' ,width:100 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'Item Description', name:'item_desc' , index:'item_desc' ,width:300 ,align:'left' , sortable:false, title:false} );
	gridColModel.push({label:'Mother Buy', name:'mother_buy' , index:'mother_buy' ,width:100 ,align:'center', sortable:false, title:false, editable:true} );
	gridColModel.push({label:'대표품', name:'is_owner_item' , index:'is_owner_item' ,width:45 ,align:'center', sortable:false, title:false, editable:true,
	                   edittype:'checkbox',
	                   editoptions:{
	                   value:"Y:N"
	                   },
	                   formatter:'checkbox',
	                   formatoptions:{
					   disabled: is_obtain_user
	                   },
	});
	gridColModel.push({label:'h_대표품', name:'h_is_owner_item' , index:'h_is_owner_item', hidden:true });
	gridColModel.push({label:'BOM', name:'use_ssc_type' , index:'use_ssc_type' ,width:70 ,align:'left', sortable:false, title:false, editable:true,
	                   edittype:'select', //SELECT BOX 옵션
	                   formatter:'select',
	                   editoptions:{
	                   value:'EQ:EQUIP;VA:VALVE;GE:GENERAL'
	                   }
	});
	gridColModel.push({label:'조달 L/T', name:'obtain_lt' , index:'obtain_lt' ,width:50 ,align:'center', formatter:formatOpt2, sortable:false, title:false} );
	gridColModel.push({label:'항차', name:'voyage_no' , index:'voyage_no' ,width:30 ,align:'center', sortable:false, title:false, editable:true} );
	gridColModel.push({label:'중요도', name:'importance' , index:'importance' ,width:40 ,align:'center', sortable:false, title:false, editable:true,
	                   edittype:'select', //SELECT BOX 옵션
	                   formatter:'select',
	                   editoptions:{
	                   value:'A:A;B:B;C:C'
	                   }
	});
	gridColModel.push({label:'M/A', name:'main_accessaries', index:'main_accessaries' ,width:50 ,align:'center', sortable:false, title:false, editable:true,
	                   edittype:'select', //SELECT BOX 옵션
	                   formatter:'select',
	                   editoptions:{
	                   value:'M:M;A:A'
	                   }
	});
	gridColModel.push({label:'납기기준', name:'equip' , index:'equip' ,width:50 ,align:'center', sortable:false, title:false, editable:true,
	                   edittype:'select', //SELECT BOX 옵션
	                   formatter:'select',
	                   editoptions:{
	                   value:'LON:LON;MID:MID;MRP:MRP'
	                   }            
	});
	gridColModel.push({label:'직투', name:'is_direct_input', index:'is_direct_input', width:40 ,align:'center', sortable:false, title:false, editable:true,
	                   edittype:'checkbox', //CHECK BOX 옵션
	                   formatter:'checkbox',
	                   editoptions:{
	                   value: "Y:N"
	                   },
	                   formatoptions:{
	                   disabled: is_obtain_user
	                   },
	});
	gridColModel.push({label:'h_직투', name:'h_is_direct_input', index:'h_is_direct_input', hidden:true });
	gridColModel.push({label:'단가계약', name:'unitcost_contract' , index:'unitcost_contract' ,width:70 ,align:'center', sortable:false, title:false, editable:true,
	                   edittype:'checkbox', //CHECK BOX 옵션
	                   formatter:'checkbox',
	                   editoptions:{
	                   value: "Y:N"
	                   },
	                   formatoptions:{
	                   disabled: is_obtain_user
	                   },
	});
	gridColModel.push({label:'h_단가계약', name:'h_unitcost_contract' , index:'h_unitcost_contract', hidden:true });
	gridColModel.push({label:'금액배분', name:'price_breakdown' , index:'price_breakdown' ,width:50 ,align:'center', sortable:false, title:false, editable:true} );
	gridColModel.push({label:'Sub DWG NO.', name:'' , index:'' ,width:90 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'Remark', name:'remark' , index:'remark' ,width:90 ,align:'center', sortable:false, title:false, editable:true} );
	gridColModel.push({label:'중분류Code', name:'middle_code' , index:'middle_code' ,width:70 ,align:'center', sortable:false, title:false} );  
	gridColModel.push({label:'설계부서', name:'plan_part' , index:'plan_part' ,width:120 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'구매자', name:'buyer' , index:'buyer' ,width:60 ,align:'center', sortable:false, title:false} );  
	gridColModel.push({label:'최초생성일', name:'creation_date' , index:'creation_date' ,width:70 ,align:'center', sortable:false, title:false} );            
	gridColModel.push({label:'최초생성자', name:'created_by' , index:'created_by' ,width:60 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'품목코드', name:'itemcode' , index:'itemcode' ,width:80 ,align:'center', sortable:false, hidden:true} );
	gridColModel.push({label:'품목명', name:'itemdesc' , index:'itemdesc' ,width:80 ,align:'center', sortable:false, hidden:true} );            
	gridColModel.push({label:'Catalog명', name:'catalog_name' , index:'catalog_name' ,width:250 ,align:'left', sortable:false, hidden:true} );
	gridColModel.push({label:'중분류명', name:'middle_name' , index:'middle_name' ,width:250 ,align:'center', sortable:false, hidden:true} );
	gridColModel.push({label:'DWG Desc.', name:'dwg_desc' , index:'dwg_desc' ,width:250 ,align:'center', sortable:false, hidden:true} );            
	gridColModel.push({label:'SHIP1', name:'ship1' , index:'ship1' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP2', name:'ship2' , index:'ship2' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP3', name:'ship3' , index:'ship3' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP4', name:'ship4' , index:'ship4' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP5', name:'ship5' , index:'ship5' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP6', name:'ship6' , index:'ship6' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP7', name:'ship7' , index:'ship7' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP8', name:'ship8' , index:'ship8' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP9', name:'ship9' , index:'ship9' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({label:'SHIP10', name:'ship10' , index:'ship10' ,width:50 ,align:'center', sortable:false, title:false} );
	gridColModel.push({name:'oper', index:'oper', hidden:true});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	fn_all_text_upper();

	var objectHeight = gridObjectHeight(1);
	
	$("#MasterItemGrid").jqGrid({ 
             datatype : 'json',              
             url      : '',
             mtype    : '',
             postData : fn_getFormData( "#listForm" ),
             colModel: gridColModel,
             		 multiselect: true,
	                 gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             scrollOffset : 0,
		             shrinkToFit:false,
		             cellEdit	: true,             // grid edit mode 1
			         cellsubmit	: 'clientArray',  	// grid edit mode 2
		             height: 610,
		             pager: jQuery('#btnitemTransList'),
		             rowList:[100,500,1000],
			         rowNum:100,
			         beforeSaveCell : chmResultEditEnd,
					 beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
		             	idRow=rowid;
		             	idCol=iCol;
		             	kRow = iRow;
		             	kCol = iCol;
		   			 },
					 jsonReader : {
		                 root: "rows",
		                 page: "page",
		                 total: "total",
		                 records: "records",  
		                 repeatitems: false,
		                },        
		             imgpath: 'themes/basic/images',
		             onPaging: function(pgButton) {
						$(this).jqGrid("clearGridData");
			 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid"); 		
					 },
					 afterSaveCell  : function(rowid,name,val,iRow,iCol) {
			            	if (name == "sub_dwg_code" || name == "mother_buy") setUpperCase('#MasterItemGrid',rowid,name);
					 },
		   			 loadComplete: function (data) {
		   				var rows = $( "#MasterItemGrid" ).getDataIDs();

		   				/******* 그리드 색깔 변경 *******/
		   				for (var i = 0; i < rows.length; i++) {
		   					//그리드 색깔 초기화
		   					$( "#MasterItemGrid" ).jqGrid( 'setCell', rows[i], false, { background : '#FFFFFF' } );
		   					
			   				//권한 : 설계 선택 시 색깔 변경
			   				if($("#loginGubun").val() == "plan"){
								$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'mother_buy', '', { background : '#FFFFCC' } );
								$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'sub_dwg_code', '', { background : '#FFFFCC' } );
								$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'remark', '', { background : '#FFFFCC' } );
			   				}
			   				//권한 : 생산or구매 선택 시 색깔 변경
			   				else if($("#loginGubun").val() == "obtain"){
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'use_ssc_type', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'voyage_no', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'importance', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'main_accessaries', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'equip', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'unitcost_contract', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'price_breakdown', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'remark', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'is_direct_input', '', { background : '#FFFFCC' } );
			   					$("#MasterItemGrid").jqGrid( 'setCell', rows[i], 'is_owner_item', '', { background : '#FFFFCC' } );
			   					
			   				}
		   				
		   				}
		   				
		   				/******* 그리드 편집 활성화, 비활성화 *******/
		   				//그리드 편집 권한 모두 비활성화
		   				changeEditableByContain($("#MasterItemGrid"), 'mother_buy','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'sub_dwg_code','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'remark','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'use_ssc_type','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'voyage_no','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'importance','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'main_accessaries','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'equip','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'unitcost_contract','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'price_breakdown','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'is_direct_input','', true);
					    changeEditableByContain($("#MasterItemGrid"), 'is_owner_item','', true);
					    
					    $("input[name=importance]").attr('disabled', 'true');
					    $("input[name=is_direct_input]").attr('disabled', 'true');
					    $("input[name=is_owner_item]").attr('disabled', 'true');
					    
					    
		   				//권한 : 설계 선택 시 편집 활성화
		   				if($("#loginGubun").val() == "plan"){
		   					changeEditableByContain($("#MasterItemGrid"), 'mother_buy','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'sub_dwg_code','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'remark','', false);
						    
		   				}
		   				//권한 : 구매 선택 시 편집 활성화
		   				else if($("#loginGubun").val() == "obtain"){
		   					changeEditableByContain($("#MasterItemGrid"), 'use_ssc_type','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'voyage_no','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'importance','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'main_accessaries','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'equip','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'unitcost_contract','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'price_breakdown','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'remark','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'is_direct_input','', false);
						    changeEditableByContain($("#MasterItemGrid"), 'is_owner_item','', false);
		   				}
		   				
		   				
					    var $this = $(this);
					    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
					        $this.jqGrid('setGridParam', {
					            datatype: 'local',
					            data: data.rows,
					            pageServer: data.page,
					            recordsServer: data.records,
					            lastpageServer: data.total
					        });
					        this.refreshIndex();					
					        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
					    
						
						
					 }
					 
						
     });

});  //end of ready Function 	

var loginGubun = $("#loginGubun").val();
var str001 = "";var str002 = "";var str003 = "";var str004 = "";var str005 = "";var str006 = "";
var str007 = "";var str008 = "";var str009 = "";var str010 = "";var str011 = "";var str012 = "";
$(document).ready(function(){

	search();
	
	//key evant 
	$("input[type=text]").keypress(function(event) {
	  if (event.which == 13) {
	        event.preventDefault();
	        $('#btnSearch').click();
	    }
	});	

});

//########  닫기버튼 ########//
$("#btnClose").click(function() {
	window.close();
});

//그리드 내 입력시 대문자 자동 변환 함수
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

//afterSaveCell oper 값 지정
function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $( '#MasterItemGrid' ).jqGrid( 'getRowData', irowId );
	

		item.oper = 'U';
		$('#MasterItemGrid').jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		
	
	$( '#MasterItemGrid' ).jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );

	/* //변경 된 row 이면 색 변경
	var ids = $( '#modelMgntList' ).jqGrid( 'getDataIDs' );

	if( item.oper == "U" ) {
		$( '#modelMgntList' ).jqGrid('setCell', ids[irow], ids[iCol - 1], '', { 'background' : '#6DFF6D' } );
	} */
}


//######## 조회 버튼 클릭 시 ########//
$("#btnSearch").click(function(){			
	search();					
});	

//######## 추가 버튼 클릭 시 ########//
$("#btnAdd").click(function(){
	
	$("#jqGridDbMasterList").saveCell(kRow, idCol );
	
	var row_id = jQuery("#MasterItemGrid").jqGrid('getGridParam', 'selarrrow');
	
	var pos_no = document.getElementsByName("chkbox");
	var catalog_code = "";
	var catalog_name = "";
	var item_code = "";
	var item_name = "";
	
	if(row_id.length > 1){
		alert("하나의 행만 선택해주십시오.");
		return false;
	}
	
	for(var i = 0; i < row_id.length; i++) {
		catalog_code = $('#MasterItemGrid').jqGrid('getRowData', row_id[i]).catalog_code;
		catalog_name = $('#MasterItemGrid').jqGrid('getRowData', row_id[i]).catalog_name;
		item_code = $('#MasterItemGrid').jqGrid('getRowData', row_id[i]).itemcode;
		item_name = $('#MasterItemGrid').jqGrid('getRowData', row_id[i]).item_desc;
	}

	if (win != null){
   		win.close();
   	}
	var args = { menu_id : $("#menu_id").val()
			    ,user_name : $("#user_name").val()
			    ,user_id : $("#user_id").val()
			    ,loginGubun : $("#loginGubun").val()
			   };
	win = window.showModalDialog("popUpDbMasterAdd.do?loginGubun="+$("#loginGubun").val()
			+ "&p_catalog_code="+catalog_code
			+ "&p_catalog_name="+catalog_name
			+ "&p_itemcode="+item_code
			+ "&p_itemname="+item_name
			, $("#listForm").val(),"dialogWidth:810px; dialogHeight:500px; center:on; scroll:off; status:off; location:no");				
});			

//######## 적용 선종 선택 버튼 클릭 시 ########//
$("#btnAppShip").click(function(){
	
	$("#jqGridDbMasterList").saveCell(kRow, idCol );
	
	var row_id = jQuery("#MasterItemGrid").jqGrid('getGridParam', 'selarrrow');
	
	var pos_no = document.getElementsByName("chkbox");
	var catalog_code = "";
	var catalog_name = "";
	var item_code = "";
	var item_code_first = "";
	var item_name = "";
	
	if(row_id == ""){
		alert("행을 선택해 주십시오.");
		return;
	}

	for(var i = 0; i < row_id.length; i++) {
		status = $('#MasterItemGrid').jqGrid('getRowData',row_id[i]).status;
		if(status != 'S') {
			alert("승인된 데이터만 선택 가능합니다.");
			return;
		}
		itemcode = $('#MasterItemGrid').jqGrid('getRowData',row_id[i]).item_code;
		item_code = item_code + itemcode + "','";
	}
	//첫번째 item_code 가져옴
	item_code_first = $('#MasterItemGrid').jqGrid('getRowData',row_id[0]).item_code;
	//체크한 모든 item_code 가져옴
	item_code = item_code + "'";	
	
	if (win != null){
   		win.close();
   	}
	var args = {};
	win = window.showModalDialog("popUpDbMasterShipApp.do?p_itemCodes="+item_code+"&p_itemCodeFirst="+item_code_first, args,"dialogWidth:377px; dialogHeight:500px; center:on; scroll:off; status:off; location:no");				
});			

//########  승인버튼 ########//
$("#btnApprove").click(function(){

	//체크 된 row id 받음				
	//jqGrid의 rowData를 받아옴.		
	var row_id = jQuery("#MasterItemGrid").jqGrid('getGridParam', 'selarrrow');
	
	if(row_id == ""){
		alert("행을 선택해 주십시오.");
		return false;
	}
	
	var logingubun = $('#loginGubun').val();
	var itemcode = "";
	var item_code = "'";
	var statuss = "";

	for(var i = 0; i < row_id.length; i++) {
		itemcode = $('#MasterItemGrid').jqGrid('getRowData',row_id[i]).item_code;
		status = $('#MasterItemGrid').jqGrid('getRowData',row_id[i]).status;			
		if(statuss != "" && status != statuss) {
			alert("STATUS가 다른 데이터는 선택할 수 없습니다.");
			return;
		}
		statuss = status;
		
		if(row_id.length-1 != i) item_code = item_code + itemcode + "','";
		else item_code = item_code + itemcode + "'";
	}
	//item_code = item_code + "'";
	
	$("input[name=p_daoName]").val("EMS_DBMASTER");
	$("input[name=p_queryType]").val("update");
	$("input[name=p_process]").val("mod_flag");
	$("input[name=p_itemCodes]").val(item_code);
	
	var sUrl = "popUpEmsDbMasterItemApprove.do";
	
	if(statuss == 'S') {
		$("input[name=p_status]").val("C");
		if(confirm("선택한 아이템에 대하여 삭제요청 하시겠습니까?")) {
			//필수 파라미터 E	
			$(".loadingBoxArea").show();
			$.post(sUrl,$("#listForm").serialize(),function(json)
			{
				alert(json.resultMsg);
				if ( json.result == 'success' ) {
					search();
				}
				$(".loadingBoxArea").hide();
			},"json");
		}
	} else {

		$.jQueryAlert("선택한 아이템에 대하여 승인 또는 반려 하시겠습니까?", statuss, sUrl);
	}

});

//########  선종 DP 관리 버튼 ########//
$("#btnShipDp").click(function(){
	
	var url = "popUpDbMasterShipDp.do";					

	var nwidth = 350;
	var nheight = 500;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";

	var win = window.open(url,"",sProperties);					
	win.focus();
	
});

jQuery.jQueryAlert = function (msg, statuss, sUrl) {
    var $messageBox = $.parseHTML('<div id="alertBox"></div>');
    $("body").append($messageBox);
    $($messageBox).dialog({
    	open: $($messageBox).append(msg),
        title: "경고창", 
        autoOpen: true,   
        modal: true,  
        buttons: {  
        	승인: function () { 
        						//if($("#user_id").val() != "211524" && $("#user_id").val() != "208071" && $("#user_id").val() != "211055" && $("#user_id").val() != "206285"){
        						//	alert("승인 권한이 없습니다. \n운영 담당자[유의동 대리, 송경근 과장]에게 문의바랍니다.");
        						//	return false;
        						//}
        						if(statuss=="C"){
        							alert("선택한 아이템은 수정 불가합니다. 시스템 관리자에 문의바랍니다.");
        							return false;
        						}
        						
	        					$(".loadingBoxArea").show();
	        					
	        					$("input[name=p_status]").val(statuss);
	        					$("input[name=p_flag]").val("APP");
								$.post(sUrl,$("#listForm").serialize(),function(json)
								{									
									alert(json.resultMsg);
									search();
								},"json");
								$("#alertBox").dialog("close");
								$("#alertBox").remove();
							},
        	반려: function () {
        						$(".loadingBoxArea").show();
        						
        						$("input[name=p_status]").val(statuss);
	        					$("input[name=p_flag]").val("REJ");
								$.post(sUrl,$("#listForm").serialize(),function(json)
								{										
									alert(json.resultMsg);
									search();
								},"json");
								$("#alertBox").dialog("close");
								$("#alertBox").remove();
							},
        	취소: function () {
        						$("#alertBox").dialog("close");
        						$("#alertBox").remove(); 
        						}
        }
    });
};

//######## 도움말 버튼 클릭 시 ########//
$("#btnHelp").click(function(){							
	$.download('/download/doc_equip_standard_r0.pdf',null,'post','_blank' ); //새창에서 열기
	//$.download('fileDownload.do?fileName=doc_equip_standard_r0.pdf',null,'post'); //다운로드
});	

//######## Export 버튼 클릭 시 ########//
$("#btnExport").click(function(){				
	//그리드의 label과 name을 받는다.
	//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
	var colName = new Array();
	var dataName = new Array();
	
	for(var i=0; i<gridColModel.length; i++ ){
		if(gridColModel[i].hidden){
			continue;
		}
		colName.push(gridColModel[i].label);
		dataName.push(gridColModel[i].name);
	}
	
	form = $('#listForm');

	$("input[name=p_is_excel]").val("Y");
	//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.
	
	$("#p_col_name").val(colName);
	$("#p_data_name").val(dataName);
	$("#rows").val($("#MasterItemGrid").getGridParam("rowNum"));
	$("#page").val($("#MasterItemGrid").getGridParam("page"));
	
	form.attr("action", "emsDbMasterExcelExport.do?");
	
	form.attr("target", "_self");	
	form.attr("method", "post");	
	form.submit();
});			

//########  저장버튼 ########//
$("#btnSave").click(function(){
	
	$( '#MasterItemGrid' ).saveCell( kRow, idCol );
	
	var changedData = $( "#MasterItemGrid" ).jqGrid( 'getRowData' );

	// 변경된 체크 박스가 있는지 체크한다.
	for( var i = 1; i < changedData.length + 1; i++ ) {
		var item = $( '#MasterItemGrid' ).jqGrid( 'getRowData', i );
		if( item.oper != 'I' && item.oper != 'U' ) {
			if( item.is_owner_item != item.h_is_owner_item ) {
				item.oper = 'U';
			}
			
			if( item.is_direct_input != item.h_is_direct_input ) {
				item.oper = 'U';
			}
			
			if( item.unitcost_contract != item.h_unitcost_contract ) {
				item.oper = 'U';
			}
			if (item.oper == 'U') {
				// apply the data which was entered.
				$( '#MasterItemGrid' ).jqGrid( "setRowData", i, item );
			}
		}
	}

	//변경 사항 Validation
	if( !fn_checkValidate() ) {
		return;
	}

	if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
		var chmResultRows = [];
		
		getChangedChmResultData(function( data ) {
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'popUpEmsDbMasterItemSave.do';
			var formData = fn_getFormData( '#listForm' );
			var parameters = $.extend( {}, dataList, formData );

			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					search();
				}
			}, "json").error( function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				loadingBox.remove();
			} );
		} );
	}
		
});


//변경 사항 Validation 
function fn_checkValidate() {
	var result = true;
	var message = "";
	var nChangedCnt = 0;
	var ids = $( "#MasterItemGrid" ).jqGrid( 'getDataIDs' );

	var logingubun = $('#loginGubun').val(); //권한

	for( var i = 0; i < ids.length; i++ ) {
		var oper = $( "#MasterItemGrid" ).jqGrid( 'getCell', ids[i], 'oper' );
		if( oper == 'U') {
			nChangedCnt++;
		}
	}

	if ( nChangedCnt == 0 ) {
		result = false;
		alert( "변경된 내용이 없습니다." );
	}

	return result;
}


//그리드 변경된 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#MasterItemGrid" ).jqGrid( 'getRowData' ), function( obj ) {
		return  obj.oper == 'U';
	} );
	
	callback.apply(this, [ changedData.concat(resultData) ]);
};

//######## 메시지 Call ########//
var afterDBTran = function(json){

 	var msg = "";
	for(var keys in json)
	{
		for(var key in json[keys])
		{
			if(key=='Result_Msg')
			{
				msg=json[keys][key];
			}
		}
	}
	alert(msg);
	
	if(msg.indexOf('정상적') > -1) {
	
		search();			
		
	}
}

function search() {
	var sUrl = "popUpEmsDbMasterItemList.do";		
			
	jQuery("#MasterItemGrid").jqGrid('setGridParam',{url		: sUrl
		,mtype    : 'POST' 
		,page		: 1
		,datatype	: 'json'
		,postData : getFormData("#listForm")}).trigger("reloadGrid");

	//그리드의 ship1 ~ 10 칼럼에 각각 맞는 선종DP를 매칭 시킴
	$.post( "popUpEmsDbMasterShipDpList.do", "", function( data ) {
		var dp_list = data.rows;
		for(var i=0; i < 10; i++){
			if(typeof dp_list[i].ship_order == "undefined"){
				$('#MasterItemGrid').jqGrid('setLabel', "ship"+(i+1), "SHIP"+(i+1));
			} else {
				$('#MasterItemGrid').jqGrid('setLabel', "ship"+(i+1), dp_list[i].ship_size + dp_list[i].ship_type);	
			}
			
		}
		
	}, "json" );
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

function formatOpt2(cellvalue, options, rowObject){
	
	var str = "";
	if(cellvalue > 0) {
		str = cellvalue;
	}
		
		return str;		 	 
}



</script>
</body>
</html>