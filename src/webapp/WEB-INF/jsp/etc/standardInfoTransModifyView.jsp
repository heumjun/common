<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
	table {font-size:98%}
	.btnRel{margin:2px;}
	.btnCommonStyle{margin:2px;}
	.menu_title{margin:8px 0px 4px 4px; font-weight:bold;}
	.comment_disabled{background-color: #F5F4EA}
	.disablefield{border:1px solid #ccc;}
	.subTitle {font-size:12pt; font-weight:bold; margin-bottom:10px;}
	.subTitle .titleImg{font-size:8pt; color:#bbbbbb;}
	
</style>
<title>Registration Request</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id="mainDiv" class="mainDiv">
	<div class="subtitle">
		기준정보 요청<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	<form id="application_form">
	<input type="hidden" name="user_id" 		id="user_id" value="${loginUser.user_id}" />
	<input type="hidden" name="dept_code"   	id="dept_code"	value="${loginUser.insa_dept_code}"	/>
	<input type="hidden" name="p_daoName"		id="p_daoName"   	/>
	<input type="hidden" name="p_queryType" 	id="p_queryType"	/>
	<input type="hidden" name="p_process"   	id="p_process"		/>
	<input type="hidden" name="p_filename"   	id="p_filename"		/>
	<input type="hidden" name="list_type"   	id="list_type"		value="01"	/>
	<input type="hidden" name="list_status"   	id="list_status"	value="01"	/>
	<input type="hidden" name="process_type"  	id="process_type"				value="<c:out value="${process_type}"/>"	/>
	<input type="hidden" name="request_emp_no"  id="request_emp_no"	 />
	<input type="hidden" name="admin_chk" 		id="admin_chk"	 />
	<input type="hidden" name="grantor_chk" 	id="grantor_chk"	 />
	<input type="hidden" name="grantor_jodal_chk" 	id="grantor_jodal_chk"	 />
	<input type="hidden" name="excelHeaderName" id="excelHeaderName" value=""/>
	<input type="hidden" name="excelHeaderKey" id="excelHeaderKey" value=""/>
			
	<table class="searchArea conSearch">
		<tr>
			<td>
				<div id = "d_receive" class="button">
					<input type="button" class="btn_blue" id="" name="btnExcelExport" value="출력" />
					<input type="button" class="btn_blue" id="" name="btnAdminDel" value="삭제"  />
					<input type="button" class="btn_receive btn_gray" id="btnAccept" name="btnAccept" value="접수" style="" disabled >
					<input type="button" class="btn_receive btn_gray" id="btntemporary" name="btntemporary" value="임시저장" style="" disabled>
					<input type="button" class="btn_blue" id="" name="btnCancel" value="취소" style="" >
				</div>
				<div id = "d_approve" class="button">
						<input type="button" class="btn_blue" id="" name="btnExcelExport" value="출력" />
						<input type="button" class="btn_blue" id="" name="btnAdminDel" value="삭제" />
						<input type="button" class="btn btn_gray" id="btnApprove" name="btnApprove" value="승인" style="" disabled>
						<input type="button" class="btn btn_gray" id="btnReturn"  name="btnReturn"  value="반려" style="" disabled >
						<input type="button" class="btn_gray" id="btnretract" name="btnretract" value="철회" style="" disabled>
						<input type="button" class="btn_blue" id="" name="btnCancel" value="취소" style="" >
				</div>
				<div id = "d_success" class="button">
						<input type="button" class="btn_blue" id="" name="btnExcelExport" value="출력" />
						<input type="button" class="btn_blue" id="" name="btnAdminDel" value="삭제" />
						<input type="button" class="btn_gray" id="btnComplete" name="btnComplete" value="등록완료" style="" disabled>
						<input type="button" class="btn_blue" name="btnCancel" value="목록" style="">
				</div>
					
			</td>
		</tr>
	</table>
	<div style="height:50px; margin-top:10px">
		<div style="width:290px; float: left;">
			<div>
				<input type="text" class="disablefield" id="" name="" value="작성 번호" readonly="readonly" />
				<input type="text" id="list_id" name="list_id" value="<c:out value="${list_id}"/>"  style="text-align: center;width: 150px;" readonly="readonly" />
			</div>
			<div style="margin-top:5px">
				<input type="text" class="disablefield" id="" name="" value="유형"  readonly="readonly" />
				<select id="list_type_desc1" name="list_type_desc" style="width: 154px;"></select>
				<input type="text" id="list_type_desc2" name="list_type_desc" value="" style="text-align: center;width: 150px;" readonly="readonly"/>
			</div>
		</div>
		<div style="width: 290px; float: left;">
			<div style="text-align: center">
				<input type="text" class="disablefield" id="" name="" value="요청일" readonly="readonly"/>
				<input type="text" id="request_date" name="request_date"  value=""  style="text-align: center" readonly="readonly"/>
			</div>
			<div style="text-align: center;margin-top:5px">
				<input type="text" class="disablefield" id="" name="" value="부서"  readonly="readonly"/>
				<input type="text" id="" name="" value="<c:out value="${loginUser.insa_dept_name}" />" style="text-align: center" readonly="readonly"	/>
			</div>		
		</div>
		<div style="width: 290px; float: left;">
			<div style="text-align: center">
				<input type="text" class="disablefield" id="" name="" value="상태"  readonly="readonly"/>
				<input type="text" id="list_status_desc" name="list_status_desc" value=""  style="text-align: center" readonly="readonly"	/>
			</div>
			<div style="text-align: center;margin-top:5px">
				<input type="text" class="disablefield" id="" name="" value="요청자"  readonly="readonly"/> 
				<input type="text" id="request_user_name" name="request_user_name" value="" style="text-align: center"  readonly="readonly"/>
			</div>	
		</div>
	</div>
	<div>
		<fieldset style="display: inline float: left; position:relative;" >
	  	<legend class = "menu_title">Title</legend>
		<div>
			<input type="text" name="sub_title" id="sub_title" style="width: 99%;"/>
		</div>
	  	</fieldset>		
	</div>
	<br/>	
	<div>
		<fieldset style="display: inline float: left; position:relative;" >
	  	<legend class = "menu_title">Description</legend>
		<div id="d_catalog">
			<table id = "catalogList" style="width:99%;"></table>
			<div id="btncatalogList"></div>
			<TEXTAREA name="request_desc" id= "request_desc_ta" ROWS="3" style="width:99%; margin-top:5px;"></TEXTAREA>
		</div>
		</fieldset>
	</div>
	<br/>	
	<div>
		<fieldset style="display: inline float: left; position:relative;" >
  		<legend class = "menu_title">검토자</legend>
		<div id = "d_grantor0" 	style="margin-top: 2px; clear:both;">
			<select id="grantor_dept0" name="grantor_dept0" style="width: 50px;" disabled class="dept_disabled"></select>
			<select id="grantor_emp0" name="grantor_emp0" style="width: 100px;" disabled	class="emp_disabled"></select>
			<input type="text" name="grantor_comment0" id="grantor_comment0" class="comment_disabled" style="margin-left:10px; width:700px;"  readonly="readonly" />
		</div>
		<div id = "d_grantor1">
			<select id="grantor_dept1" name="grantor_dept1" style="width: 50px;" disabled class="dept_disabled"></select>
			<select id="grantor_emp1" name="grantor_emp1" style="width: 100px;" disabled class="emp_disabled"></select>
			<input type="text" name="grantor_comment1" id="grantor_comment1" class="comment_disabled"	style="margin-left:10px; width:700px;" readonly="readonly"/>
		</div>
		<div id = "d_grantor2">
			<select id="grantor_dept2" name="grantor_dept2" style="width: 50px;" disabled class="dept_disabled"></select>
			<select id="grantor_emp2" name="grantor_emp2" style="width: 100px;" disabled class="emp_disabled"></select>
			<input type="text" name="grantor_comment2" id="grantor_comment2" class="comment_disabled" style="margin-left:10px; width:700px;" readonly="readonly"/> 
		</div>
		<div id = "d_grantor3" >
			<select id="grantor_dept3" name="grantor_dept3" style="width: 50px;" disabled class="dept_disabled"></select>
			<select id="grantor_emp3" name="grantor_emp3" style="width: 100px;" disabled class="emp_disabled"></select>
			<input type="text" name="grantor_comment3" id="grantor_comment3"  class="comment_disabled" style="margin-left:10px; width:700px;" readonly="readonly"/>
			
		</div>
		<div id = "d_grantor4">
			<select id="grantor_dept4" name="grantor_dept4" style="width: 50px;" disabled class="dept_disabled"></select>
			<select id="grantor_emp4" name="grantor_emp4" style="width: 100px;" disabled class="emp_disabled"></select>
			<input type="text" name="grantor_comment4" id="grantor_comment4"  class="comment_disabled" style="margin-left:10px; width:700px;" readonly="readonly" />
		</div>
		</fieldset>
	</div>
	<br/>
	<div>

		<fieldset style="display: inline float: left; position:relative;" >
  		<legend class = "menu_title">관련자</legend>
		<div>
			<input type="button" id="btnAdd" name="btnAdd" value="Add" disabled class="btnRel btn_blue"/>
			<input type="button" id="btnDel" name="btnDel" value="Del" disabled class="btnRel btn_blue"/>
		</div>
		<div>
			<table id="ref_user"></table>
		</div>
		</fieldset>

	</div>
	<br/>
	<div>
		<fieldset style="display: inline float: left; position:relative;" >
  		<legend class = "menu_title">문서첨부</legend>
		<div>
			<table id="docList" ></table>
			<div id="pdocList"></div>
		</div>
		</fieldset>
	</div>
	</form>
</div>
<script type="text/javascript">
var sListUrl = 'standardInfoTransDbList.do';
var sDataUrl = 'standardInfoTransDbData.do';
var row_selected = 0;
var kRow		 = 0;
var idCol		 = 0;
var kCol		 = 0;
var idRow		 = 0;
var resultData 	 = [];
var tableId		 = "";
var isHidden	 = true;
var admin_user	 = "";
var win			 = null;

$(document).ready(function(){
	fn_GrantorSearch();
	//approve 버튼 숨기기
	$("#d_approve").hide();
	$("#d_success").hide();
	$("#d_catalog").show();
	$("#list_type_desc1").show();
	$("#list_type_desc2").hide();
	/* $( ".btn" ).prop( "disabled", true ); */
	fn_buttonDisabled([ "#btnApprove", "#btnReturn" ]);
   	$("input[name=btnAdminDel]").hide();
   	$("input[name=btnExcelExport]").hide();
	$(".dept_disabled").prop("disabled",true);
   	
   	//관련자 그리드 그리기
   	ref_user();
   	//upload 파일 그리기
   	uploadGrid();
   	
});  //end of ready Function

	//관리자 삭제
	$("input[name=btnAdminDel]").click(function(){
		var quest = confirm('삭제 하시겠습니까?');
		if ( quest ) {
			$(".loadingBoxArea").show();
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("AdminDelete");
			
			$( ".dept_disabled" ).prop( "disabled", false );
			$( ".emp_disabled" ).prop( "disabled", false );
			var formData = getFormData('#application_form');
			$.post(sDataUrl, formData, function(data2) {
				/* $(".loadingBoxArea").hide(); */
				var msg 				= data2.resultMsg;
				var result  			= data2.result;
				alert( msg );
				if ( result == 'success' ) {
					window.returnValue = "OK";
					self.close();
				} else{
					$( ".dept_disabled" ).prop( "disabled", true );
				}
			}, "json" );
		}
	});
	

	//Add버튼
	$("#btnAdd").click(function(){   
		$("input[name=p_daoName]").val("");
		$("input[name=p_queryType]").val("");
		$("input[name=p_process]").val("userSearch");
		win=window.open("popUpDwgUserSearch.do?p_process=userSearch","popupDwgUserSearch","height=560,width=600,top=200,left=900,location=no,scrollbars=no");
	});
	//Del버튼
	$("#btnDel").click(function(){   
		$('#ref_user').saveCell(kRow, kCol);
		
		var selarrrow = $('#ref_user').jqGrid('getGridParam', 'selarrrow');
		for(var i=selarrrow.length;i>-1;i--){
			var selrow = selarrrow[i];	
	    	$('#ref_user').jqGrid('delRowData', selrow);
		}
		$('#ref_user').resetSelection();
	});
	
	function insertRow(selDatas){
	
		var ids 		= $('#ref_user').getDataIDs();
		var user_id 	= selDatas.print_user_id;
		var isduplication = false;
		for (var i = 0; i < ids.length; i++) {
			var ret 		 = jQuery("#ref_user").getRowData(ids[i]);
	    	var grid_user_id = ret.print_user_id;
			if(user_id==grid_user_id){
	    		isduplication=true;
	    		break;
	    	}
		}
		if(!isduplication){
			var nRandId = $.jgrid.randId();
    		$('#ref_user').jqGrid('addRowData',nRandId,selDatas);
			//jQuery("#ref_user").jqGrid('setRowData',nRandId,{dwg_project_no:chked_val,project_no:projectNo[j],drawing_status:'RE'});
		}
	};

	//철회
	$("#btnretract").click(function(){   
		/* $(".loadingBoxArea").show(); */
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("updateRetract");
		
		$( ".dept_disabled" ).prop( "disabled", false );
		$( ".emp_disabled" ).prop( "disabled", false );
		var formData = getFormData('#application_form');
		$.post(sDataUrl, formData, function(data2) {
			/* $(".loadingBoxArea").hide(); */
			var msg 				= data2.resultMsg;
			var result  			= data2.result;
			alert( msg );
			if ( result == 'success' ) {
				window.returnValue = "OK";
				self.close();
			} else{
				$( ".dept_disabled" ).prop( "disabled", true );
			}
		}, "json" );
	});

	//반려
	$("#btnReturn").click(function(){   
		/* $(".loadingBoxArea").show(); */
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("updateReturn");
		
		$( ".dept_disabled" ).prop( "disabled", false );
		$( ".emp_disabled" ).prop( "disabled", false );
		var formData = getFormData('#application_form');
		$.post(sDataUrl, formData, function(data2) {
			/* $(".loadingBoxArea").hide(); */
			var msg 				= data2.resultMsg;
			var result  			= data2.result;
			alert( msg );
			if ( result == 'success' ) {
				window.returnValue = "OK";
				self.close();
			} else{
				$( ".dept_disabled" ).prop( "disabled", true );
			}
		}, "json" );
	});
	
	//승인
	$("#btnApprove").click(function(){   
		$('#catalogList').saveCell(kRow, idCol);
		
		if (!fn_ApproveValidate()) { 
			return;	
		}
		var chmResultRows=[];
		var refUserResultRows = [];
		var list_status = $("#list_status").val();
		if(list_status<'04'){
			$( ".dept_disabled" ).prop( "disabled", false );
			$( ".emp_disabled" ).prop( "disabled", false ); 
			/* $(".loadingBoxArea").show(); */
		}
		getChangedRefUserResultData( function(data){
			refUserResultRows = data;
		});
		getChangedChmResultData( function( data ) { //입력된 모든 row 가져오기
			/* $(".loadingBoxArea").show(); */
			chmResultRows = data;
			var dataList = {chmResultList :JSON.stringify(chmResultRows)};
			var dataList2 = {refUserResultList :JSON.stringify(refUserResultRows)};
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("updateInfoList");
			var formData = getFormData('#application_form');
			var parameters = $.extend({},dataList,formData,dataList2); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
			$.post(sDataUrl, parameters, function(data2) {
				/* $(".loadingBoxArea").hide(); */
				var msg 				= data2.resultMsg;
				var result  			= data2.result;
				alert( msg );
				if ( result == 'success' ) {
					window.returnValue = "OK";
					self.close();
				} else{
					$( ".dept_disabled" ).prop( "disabled", true );
					$( ".emp_disabled" ).prop( "disabled", true );
				}
			}, "json" );
		});
		
	});

	//grid의 +,- 버튼 붙이기
	function fn_set_gridButton(){
    	$("#catalogList").jqGrid('navGrid',"#btncatalogList",{refresh:false,search:false,edit:false,add:false,del:false});
		$("#catalogList").navButtonAdd("#btncatalogList",
				{ 	caption:"", 
					buttonicon:"ui-icon-minus", 
					onClickButton: deleteRow,
					position: "first", 
					title:"Del", 
					cursor: "pointer"
				} 
		);
	 	$("#catalogList").navButtonAdd('#btncatalogList',
				{ 	caption:"", 
					buttonicon:"ui-icon-plus", 
					onClickButton: addChmResultRow,
					position: "first", 
					title:"Add", 
					cursor: "pointer"
				} 
		);
    }
	//Grid_Del 버튼
	function deleteRow(){
		$('#catalogList').saveCell(kRow, kCol);
		
		var selarrrow = $('#catalogList').jqGrid('getGridParam', 'selarrrow');
		for(var i=selarrrow.length;i>-1;i--){
			var selrow = selarrrow[i];	
			
	    	$('#catalogList').jqGrid('delRowData', selrow);
		}
		
		$('#catalogList').resetSelection();
	}
	
	//Grid_Add 버튼 
	function addChmResultRow() {
		$('#catalogList').saveCell(kRow, idCol);
		var item = {};
		
		$('#catalogList').resetSelection();
		$('#catalogList').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
		tableId = '#catalogList';	
	};

	//유형 selectbox change 이벤트
	$( "#list_type_desc1" ).change( function () {
		var list_type_desc =	$("#list_type_desc1").val();
		
		if(list_type_desc=='01'){
			//catalog
			$("#list_type").val("01");
			$("#d_catalog").show();
			$("#catalogList").jqGrid('GridUnload');
			catalogGrid();
			addChmResultRow();
			//catalogGrid 버튼 생성
			fn_set_gridButton();
			$("#request_desc_ta").prop("rows","3");
		}else if(list_type_desc=='02'){
			$("#list_type").val("02");
			$("#d_catalog").show();
			$("#catalogList").jqGrid('GridUnload');
			itemGrid();
			addChmResultRow();
			//catalogGrid 버튼 생성
			fn_set_gridButton();
			$("#request_desc_ta").prop("rows","3");
		}else if(list_type_desc=='03'){
			$("#catalogList").jqGrid('GridUnload');
			$("#list_type").val("03");
			$("#d_catalog").show();
			$("#request_desc_ta").prop("rows","10");
		}
		fn_set_all_approver();
	} );
	
	function hideBox(){
		$("#d_grantor0").hide();
		$("#d_grantor1").hide();
		$("#d_grantor2").hide();
		$("#d_grantor3").hide();
		$("#d_grantor4").hide();
		$("#grantor_dept0").empty().data('options');
		$("#grantor_dept1").empty().data('options');
		$("#grantor_dept2").empty().data('options');
		$("#grantor_dept3").empty().data('options');
		$("#grantor_dept4").empty().data('options');
		$("#grantor_emp0").empty().data('options');
		$("#grantor_emp1").empty().data('options');
		$("#grantor_emp2").empty().data('options');
		$("#grantor_emp3").empty().data('options');
		$("#grantor_emp4").empty().data('options');
	}
	
	//검토자 그리드 그리기
	function ref_user(){
		$("#ref_user").jqGrid({
			 datatype: 'local', 
             mtype: '', 
             url:'',
             postData : getFormData('#application_form'),
             colNames:['사번','관련자'
             		  ],
                colModel:[
                	{name:'print_user_id'			, index:'print_user_id'		,width:30	,align:'center' , editable:false},
                    {name:'print_user_name'			, index:'print_user_name'	,width:30	,align:'center' , editable:false}
                ],
             multiselect: true,
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             //rownumbers:true,
             autowidth: true,
             //shrinkToFit : false,
             height: 50,
             //pager: jQuery('#btnref_user'),
	         rowNum:-1, 
			 cellEdit: true,             // grid edit mode 1
	         cellsubmit: 'clientArray',  // grid edit mode 2
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
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
   			 loadComplete: function (data) {
   			 	
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
	                            row_selected = row_id;
                             }
                          }
             
           
	     });// end of jqgrid
		//Grid button
		$("#ref_user").setGridParam({datatype: 'json'});
	}
	
	//file 첨부 그리드 그리기
	function uploadGrid(){
		$("#docList").jqGrid( {
				url : '',
				datatype : 'json',
				mtype : '',
				postData : fn_getFormData( "#application_form" ),
				//editurl:'saveCatalogMgnt.do',
				//editUrl: 'clientArray',
				//cellSubmit: 'clientArray',
				colNames : [ '선택', 'document_id', '파일명', 'document_data', 'oper' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } }, 
				             { name : 'document_id', index : 'document_id', hidden : true }, 
				             { name : 'document_name', states_desc : 'document_name', width : 300, editable : false, editoptions : { size : 290 } }, 
				             { name : 'document_data', index : 'document_data', width : 400, editable : false, editoptions : { size : 399 } , hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				//height: $("#docList").height(),
				height : 50,
				hidegrid : false,
				pager : jQuery('#pdocList'),
				sortname: 'filename',
				sortorder: "desc",
 				pgbuttons : false,
 				pgtext : false,
 				pginput : false,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowNum : -1,
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				beforeSaveCell : chmResultEditEnd,
				//afterSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function( rowid, cellname, value, iRow, iCol ) {
					if ( value == 2 ) { //document  값 넣기
						var item = $('#docList').jqGrid( 'getRowData', rowid );
						var document_id = item.document_id;
						fn_downLoadFile(document_id);
					}
				},
				
			} );//end of jqGrid  
			
			$( "#docList" ).jqGrid( 'navGrid', "#pdocList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			//afterSaveCell oper 값 지정
			function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
				var item = $('#docList').jqGrid( 'getRowData', irowId );
				
				if ( item.oper != 'I' )
					item.oper = 'U';
				
				$('#docList').jqGrid( "setRowData", irowId, item );
				$( "input.editable,select.editable", this ).attr( "editable", "0" );
			}
			
	}
	
	//첨부파일 그리드 버튼 세팅
	function fn_set_doc_GridButton(){
		$("#docList").navButtonAdd('#pdocList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteDocRow,
				position : "first",
				title : "Del",
				cursor : "pointer"
		});
		$("#docList").navButtonAdd('#pdocList', {
			caption : "",
			buttonicon : "ui-icon-plus",
			onClickButton : addDocResultRow,
			position : "first",
			title : "Add",
			cursor : "pointer"
		});
	}
	
	//첨부파일 그리드 Add 버튼
	function addDocResultRow() {
		$("input[name=p_daoName]").val("");
		$("input[name=p_queryType]").val("");
		$("input[name=p_process]").val("itemPopupUpload");
		var list_id = $("#list_id").val();
		var args = {list_id 	: list_id,
					p_process 	: "itemPopupUpload"
				   };
		//var rs = window.showModalDialog( sUrl+"?list_id="+list_id+"&p_process=itemPopupUpload", args, "dialogWidth:800px; dialogHeight:460px; center:on; scroll:off; status:off" );
		if (win != null){
	   		win.close();
	   	}
		win = window.open( "popUpTransItemDoc.do"+"?list_id="+list_id+"&p_process=itemPopupUpload", "view", "height=200,width=290,top=200,left=900,location=no,scrollbars=no" );		
	}
	
	//첨부파일 그리드 Del 버튼
	function deleteDocRow() {
		var quest = confirm('삭제 하시겠습니까?');
		
		
		if ( quest ) {
			$('#docList').saveCell( kRow, idCol );

			var chmResultRows = [];
			getCheckDocListData( function( data ) {
				/* $(".loadingBoxArea").show(); */
				chmResultRows = data;

				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				$("input[name=p_daoName]").val("TBC_ITEMTRANS");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("deleteDocList");
				
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );
				$.post(sDataUrl, parameters, function(data) {
					/* $(".loadingBoxArea").hide(); */
					var msg 				= data.resultMsg;
					var result  			= data.result;
					alert( msg );
					if ( result == 'success' ) {
						fn_DocSearch();
					}
				}, "json" );
			} );
		}
	}
	
	//catalog 그리드 그리기 
	function catalogGrid(){
		$("#catalogList").jqGrid({ 
             datatype: 'local', 
             mtype: '', 
             url:'',
             postData : getFormData('#application_form'),
             colNames:['id','Category','Catalog','Description','UOM','BOM 구성예정','ATTR1','ATTR2','ATTR3'	,'ATTR4','ATTR5'
             		   ,'ATTR6','ATTR7','ATTR8','ATTR9','ATTR10'
             		   ,'ATTR11','ATTR12','ATTR13','ATTR14','ATTR15'
             		   ,'구매요청 기준','구매요청 대표품목코드','VenDor Drawing NO'
             		   ,'대분류','대중분류','중분류'/*,'특수선 여부'*/
             		   ,'THECH,SPEC 품목유무','선종구분','구매자','구매자이름','공정관리자','공정관리자이름','표준 리드타임'
             		   ,'MRP계획 대상여부','페깅여부','물류담당자','F.ORDER(취소)','F.ORDER(납기)'
             		  ],
                colModel:[
	                {name:'id'				, index:'id'				,width:80	,align:'center' , editable:true , sortable:false , hidden:isHidden},
                	{name:'category'			, index:'category'			,width:60	,align:'center' , editable:true , sortable:false, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'catalog'				, index:'catalog'			,width:60	,align:'center' , editable:true	, sortable:false, },
                    {name:'description'			, index:'description'		,width:120	,align:'center' , editable:true , sortable:false},
                    {name:'uom'					, index:'uom'				,width:60	,align:'center' , editable:true , sortable:false , edittype:"select", formatoptions: {disabled : false}, editoptions:{value:"MM:MM;TON:TON;SH:SH;SET:SET;RL:RL;PCS:PCS;MIN:MIN;M3:M3;"+
                    																																											   "M2:M2;M:M;LOT:LOT;LIT:LIT;KG:KG;HR:HR;EA:EA;DAY:DAY;CM:CM;"+
                    																																											   "CAN:CAN;BOX:BOX;BAG:BAG;AMT:AMT"}},
                    {name:'bom_create_date'		, index:'bom_create_date'	,width:90	,align:'center' , editable:true , sortable:false , edittype:"select", formatoptions: {disabled : false}, editoptions:{value:":;Y:Y;N:N"}},
                    {name:'attibute_01'			, index:'attibute_01'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_02'			, index:'attibute_02'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_03'			, index:'attibute_03'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_04'			, index:'attibute_04'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_05'			, index:'attibute_05'		,width:40	,align:'center' , editable:true , sortable:false},
                    
                    {name:'attibute_06'			, index:'attibute_06'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_07'			, index:'attibute_07'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_08'			, index:'attibute_08'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_09'			, index:'attibute_09'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_10'			, index:'attibute_10'		,width:40	,align:'center' , editable:true , sortable:false},
                    
                    {name:'attibute_11'			, index:'attibute_11'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_12'			, index:'attibute_12'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_13'			, index:'attibute_13'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_14'			, index:'attibute_14'		,width:40	,align:'center' , editable:true , sortable:false},
                    {name:'attibute_15'			, index:'attibute_15'		,width:40	,align:'center' , editable:true , sortable:false},
                    
                    {name:'po_request_type'		, index:'po_request_type'	,width:100	,align:'center' , editable:true , sortable:false , edittype:"select", formatoptions: {disabled : false}, editoptions:{value:"MRP:MRP;Tech.SPEC.품목:Tech.SPEC.품목;Manual PR:Manual PR"}},
                    {name:'po_delegate_item'	, index:'po_delegate_item'	,width:90	,align:'center' , editable:true , sortable:false},
                    {name:'vendor_drawing_no'	, index:'vendor_drawing_no'	,width:90	,align:'center' , editable:true , sortable:false},
                    
                    {name:'level_01'			, index:'level_01'			,width:70	,align:'center' , editable:true , sortable:false},
                    {name:'level_02'			, index:'level_02'			,width:70	,align:'center' , editable:true , sortable:false},
                    {name:'level_03'			, index:'level_03'			,width:70	,align:'center' , editable:true , sortable:false},
                    /*{name:'n_ship_flag'			, index:'n_ship_flag'		,width:70	,align:'center' , editable:true , sortable:false , edittype:"select", formatoptions: {disabled : false}, editoptions:{value:":;Y:Y;N:N"}},*/
                    
                    {name:'tech_spec_flag'		, index:'tech_spec_flag'	,width:126	,align:'center' , editable:true , sortable:false , edittype:"select", formatoptions: {disabled : false}, editoptions:{value:":;Y:Y;N:N"}},
                    {name:'ship_type'			, index:'ship_type'			,width:70	,align:'center' , editable:true , sortable:false, edittype:"select", formatoptions: {disabled : false}, editoptions:{value:"상선:상선;특수:특수;해양:해양"}},
                    {name:'buyer_emp_no'		, index:'buyer_emp_no'		,width:70	,align:'center' , editable:true , sortable:false, hidden:isHidden},
                    {name:'buyer_user_name'		, index:'buyer_user_name'	,width:70	,align:'center' , editable:true , sortable:false, editoptions:{maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }, dataEvents: [{
																																				                        	type: 'keydown', 
																																				                            fn: function(e){
																																					                                var key = e.charCode || e.keyCode;
																																					                                //if(key == 13 || key == 9){//enter,tab
																																					                                    searchInsaUser(this,'buyer_emp_no','buyer_user_name');
																																					                                    tableId = '#catalogList';	 
																																				                                	//}
																																				                            	}
																																				                        	}
																																				                        	,
																																				                        		{type: 'click',
																																							                       fn: function (e) {
																																							                           searchInsaUser(this,'buyer_emp_no','buyer_user_name');
																																					                                   tableId = '#catalogList';	 
																																							                       }
																																							                     }
																																				                        	]
																				            	}
                    
                    },
                    {name:'process_emp_no'		, index:'process_emp_no'	,width:70	,align:'center' , editable:true , sortable:false, hidden:isHidden},
                    {name:'process_user_name'	, index:'process_user_name'	,width:90	,align:'center' , editable:true , sortable:false, editoptions:{maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }, dataEvents: [{
																																				                        	type: 'keydown', 
																																				                            fn: function(e){
																																					                                var key = e.charCode || e.keyCode;
																																					                                //if(key == 13 || key == 9){//enter,tab
																																					                                    searchInsaUser(this,'process_emp_no','process_user_name');
																																					                                    tableId = '#catalogList';	 
																																				                                	//}
																																				                            	}
																																				                        	}
																																				                        	,
																																				                        		{type: 'click',
																																							                       fn: function (e) {
																																							                           searchInsaUser(this,'process_emp_no','process_user_name');
																																					                                   tableId = '#catalogList';	 
																																							                       }
																																							                     }
																																				                        	]
																				            	}
                    
                    },
                    {name:'standar_lead_time'	, index:'standar_lead_time'	,width:90	,align:'center' , editable:true , sortable:false},
                    
                    {name:'mrp_planning_flag'	, index:'mrp_planning_flag'	,width:100	,align:'center' , editable:true , sortable:false, edittype:"select", formatoptions: {disabled : false}, editoptions:{value:"MRP PLANED:MRP PLANED;NOT PLANED:NOT PLANED"}},
                    {name:'pegging_flag'		, index:'pegging_flag'		,width:70	,align:'center' , editable:true , sortable:false, edittype:"select", formatoptions: {disabled : false}, editoptions:{value:"NON PEGGING:NON PEGGING;HARD PEGGING:HARD PEGGING;SOFT PEGGING:SOFT PEGGING;"}},
                    {name:'distributor_emp_no'	, index:'distributor_emp_no',width:70	,align:'center' , editable:true , sortable:false},
                    {name:'f_order_cancel'		, index:'f_order_cancel'	,width:90	,align:'center' , editable:true , sortable:false, edittype:"select", formatoptions: {disabled : false}, editoptions:{value:":;Y:Y;N:N"}},
                    {name:'f_order_open'		, index:'f_order_open'		,width:90	,align:'center' , editable:true , sortable:false, edittype:"select", formatoptions: {disabled : false}, editoptions:{value:":;Y:Y;N:N"}},
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             //rownumbers:true,
             multiselect: true,
             autowidth: true,
             shrinkToFit : false,
             height: 90,
             pager: jQuery('#btncatalogList'),
	         rowNum:-1, 
			 cellEdit: true,             // grid edit mode 1
	         cellsubmit: 'clientArray',  // grid edit mode 2
	         pgbuttons : false,
			 pgtext : false,
			 pginput : false,
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow=rowid;
             	idCol=iCol;
             	kRow = iRow;
             	kCol = iCol;
   			 },
   			 afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	setUpperCase("#catalogList",rowid,name);	
	         },
			 jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
   			 loadComplete: function (data) {
   			 	var list_id = $("#list_id").val();
   			 	var list_type = $("#list_type").val();
  			 	if(list_id != ''){
  			 		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
					$("input[name=p_queryType]").val("select");
					$("input[name=p_process]").val("selectGrantorChk");
					var formData = getFormData('#application_form');
					$.post( sDataUrl, formData, function( data ) {
						if(data.length != 0 ) {
							//접속자가 Grantor인 경우 grantor_chk = 'Y'
							var grnatorCnt =data.cnt;
							if(grnatorCnt!=0){
								$("#grantor_chk").val("Y");
							}
							
						}
					}, "json" );
	   			 	var list_status = $("#list_status").val();
   			 	}
			 },
			 	 
			 onCellSelect: function (rowid, colId) {
					row_selected=rowid;
					if(rowid != null) 
                	{
                		var list_status = $("#list_status").val();
                		var list_type = $("#list_type").val();
	                	var ret = $("#catalogList").getRowData(rowid);
	                	var request_emp_no	= $("#request_emp_no").val();
	                	var user_id = $("#user_id").val();
	                	var admin_chk 	= $("#admin_chk").val();
		   			 	var grantor_chk 	= $("#grantor_chk").val();
	                	if(list_status=='01' && list_type=='01'){
	   			 			jQuery("#catalogList").jqGrid('setCell', rowid, 'level_01', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'level_02', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'level_03', '', 'not-editable-cell');
							//jQuery("#catalogList").jqGrid('setCell', rowid, 'n_ship_flag', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'tech_spec_flag', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'ship_type', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'buyer_emp_no', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'buyer_user_name', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'process_emp_no', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'process_user_name', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'standar_lead_time', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'mrp_planning_flag', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'pegging_flag', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'distributor_emp_no', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'f_order_cancel', '', 'not-editable-cell');
							jQuery("#catalogList").jqGrid('setCell', rowid, 'f_order_open', '', 'not-editable-cell');
	   			 		}
	   			 		//if(list_status>'01' && (request_emp_no==user_id)){
	   			 		//	jQuery("#catalogList").jqGrid('setCell', rowid, 'level_01', '', 'editable-cell');
	   			 		//}
	   			 		if((list_status<'06') && list_status>'01' && admin_chk!='Y' && grantor_chk!='Y' ){
	   			 			//grid edit모드 없애기
							fn_notEdit(rowid);	
	   			 		}
                	} 
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
	                            row_selected = row_id;
                             }
                          }
             
           
	     });// end of jqgrid
	     
		
	    var requiredCulumnCss = {'background':'#0094C2', 'color':'#fff'};
	    var disableCulumnCss = {'background':'#cccccc', 'color':'#888888'};
	    var apprCulumnCss = {'background':'#E2FFB1', 'color':'#30684C'};	    
	    var apprReqCulumnCss = {'background':'#579837', 'color':'#fff'};	    
	    
	    //header 색 입력 시작 : 필수값
		$("#catalogList").jqGrid('setLabel','category', '', requiredCulumnCss);
		$("#catalogList").jqGrid('setLabel','catalog', '', requiredCulumnCss);
		$("#catalogList").jqGrid('setLabel','description', '', requiredCulumnCss);
		$("#catalogList").jqGrid('setLabel','uom', '', requiredCulumnCss);
		$("#catalogList").jqGrid('setLabel','attibute_01', '', requiredCulumnCss);
		$("#catalogList").jqGrid('setLabel','bom_create_date', '', requiredCulumnCss);
		
		var list_status = $("#list_status").val();
        var list_type = $("#list_type").val();
                		
		if(list_status=='01' && list_type=='01'){ //요청자 입력 
			$("#catalogList").jqGrid('setLabel','level_01', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','level_02', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','level_03', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','tech_spec_flag', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','ship_type', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','buyer_user_name', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','process_user_name', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','standar_lead_time', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','mrp_planning_flag', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','pegging_flag', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','distributor_emp_no', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','f_order_cancel', '', disableCulumnCss);
			$("#catalogList").jqGrid('setLabel','f_order_open', '', disableCulumnCss);
		}else{ //요청자 이외
			$("#catalogList").jqGrid('setLabel','level_01', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','level_02', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','level_03', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','tech_spec_flag', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','ship_type', '', apprCulumnCss);			
			$("#catalogList").jqGrid('setLabel','buyer_user_name', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','process_user_name', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','standar_lead_time', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','mrp_planning_flag', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','pegging_flag', '', apprReqCulumnCss);
			$("#catalogList").jqGrid('setLabel','distributor_emp_no', '', apprCulumnCss);
			$("#catalogList").jqGrid('setLabel','f_order_cancel', '', apprCulumnCss);
			$("#catalogList").jqGrid('setLabel','f_order_open', '', apprCulumnCss);
		}
		
		//header 색 입력 끝
		//grid header colspan
		$( "#catalogList" ).jqGrid( 'setGroupHeaders', {
			useColSpanStyle : true, 
			groupHeaders : [
								{ startColumnName : 'category', numberOfColumns : 23, titleText : '신규 품목 등록 요청자 입력란' },
								{ startColumnName : 'level_01', numberOfColumns : 16, titleText : '구매담당자 입력란' }
			  				]
		} );
		$("#catalogList").setGridParam({datatype: 'json'});

		
	}
	
	
	function itemGrid(){
		$("#catalogList").jqGrid({ 
             datatype: 'local', 
             mtype: '', 
             url:'',
             postData : getFormData('#application_form'),
             colNames:['id','list_id','Name','Description','Weight'
             		   ,'Attr0','Attr1','Attr2','Attr3','Attr4'
             		   ,'Attr5' ,'Attr6','Attr7','Attr8','Attr9'
             		   ,'Attr10','Attr11','Attr12','Attr13','Attr14'
             		   ,'Cable Outdia','Can Size','STXSVR','Thinner Code'
             		   ,'Paint Code','Cable Type','Cable Length','STXStandard'
             		  ],
                colModel:[
	                {name:'id'				, index:'id'				,width:30	,align:'center' , editable:true , hidden:isHidden},
	                {name:'list_id'				, index:'list_id'			,width:30	,align:'center' , editable:true , hidden:isHidden},
                	{name:'part_no'				, index:'part_no'			,width:80	,align:'center' , editable:true},
                    {name:'description'			, index:'description'		,width:100	,align:'center' , editable:true},
                    {name:'weight'				, index:'weight'			,width:50	,align:'center' , editable:true , editoptions:{
																													            size: 15, maxlengh: 10,
																													            dataInit: function(element) {
																													             $(element).keyup(function(){
																													              var val1 = element.value;
																													              var num = new Number(val1);
																													              if(isNaN(num)){
																													               alert("Please enter a valid number");
																													               element.value = '';
																													              }
																													             })
																													            }
																													           }}, 

                    {name:'attr00'				, index:'attibute_01'		,width:40	,align:'center' , editable:true},
                    {name:'attr01'				, index:'attibute_02'		,width:40	,align:'center' , editable:true},
                    {name:'attr02'				, index:'attibute_03'		,width:40	,align:'center' , editable:true},
                    {name:'attr03'				, index:'attibute_04'		,width:40	,align:'center' , editable:true},
                    {name:'attr04'				, index:'attibute_05'		,width:40	,align:'center' , editable:true},
                    
                    {name:'attr05'				, index:'attibute_06'		,width:40	,align:'center' , editable:true},
                    {name:'attr06'				, index:'attibute_07'		,width:40	,align:'center' , editable:true},
                    {name:'attr07'				, index:'attibute_08'		,width:40	,align:'center' , editable:true},
                    {name:'attr08'				, index:'attibute_09'		,width:40	,align:'center' , editable:true},
                    {name:'attr09'				, index:'attibute_10'		,width:40	,align:'center' , editable:true},
                    
                    {name:'attr10'				, index:'attibute_11'		,width:40	,align:'center' , editable:true},
                    {name:'attr11'				, index:'attibute_12'		,width:40	,align:'center' , editable:true},
                    {name:'attr12'				, index:'attibute_13'		,width:40	,align:'center' , editable:true},
                    {name:'attr13'				, index:'attibute_14'		,width:40	,align:'center' , editable:true},
                    {name:'attr14'				, index:'attibute_14'		,width:40	,align:'center' , editable:true},
                    
                    {name:'cable_outdia'		, index:'cable_outdia'		,width:80	,align:'center' , editable:true},
                    {name:'cable_size'			, index:'cable_size'		,width:50	,align:'center' , editable:true},
                    {name:'stxsvr'				, index:'stxsvr'	,width:60	,align:'center' , editable:true},
                    {name:'thinner_code'		, index:'thinner_code'	,width:80	,align:'center' , editable:true},
                    
                    {name:'paint_code'			, index:'paint_code'	,width:100	,align:'center' , editable:true},
                    {name:'cable_type'			, index:'cable_type'			,width:80	,align:'center' , editable:true},
                    {name:'cable_length'		, index:'cable_length'			,width:80	,align:'center' , editable:true},
                    {name:'stxstandard'			, index:'stxstandard'			,width:80	,align:'center' , editable:true}
                ],
             multiselect: true,
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             shrinkToFit : false,
             height: 100,
             pager: jQuery('#btncatalogList'),
             pgbuttons : false,
			 pgtext : false,
			 pginput : false,
	         rowNum:-1, 
			 cellEdit: true,             // grid edit mode 1
	         cellsubmit: 'clientArray',  // grid edit mode 2
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
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

   			 loadComplete: function (data) {
   			 	var list_id = $("#list_id").val();
  			 	if(list_id != ''){
  			 		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
					$("input[name=p_queryType]").val("select");
					$("input[name=p_process]").val("selectGrantorChk");
					var formData = getFormData('#application_form');
					//$.post( sListUrl, formData, function( data ) {
					$.post( sDataUrl, formData, function( data ) {
						if(data.length != 0 ) {
							//접속자가 Grantor인 경우 grantor_chk = 'Y'
							var grnatorCnt =data.cnt;
							if(grnatorCnt!=0){
								$("#grantor_chk").val("Y");
							}
						}
					}, "json" );
   			 	}
			 },
			 onCellSelect: function (rowid, colId) {
					row_selected=rowid;
					if(rowid != null) 
                	{
                		var list_status = $("#list_status").val();
                		var list_type = $("#list_type").val();
	                	var ret = $("#catalogList").getRowData(rowid);
	                	var request_emp_no	= $("#request_emp_no").val();
	                	var user_id = $("#user_id").val();
	                	var admin_chk 	= $("#admin_chk").val();
		   			 	var grantor_chk 	= $("#grantor_chk").val();
	   			 		if((list_status<'06') && list_status>'01' && admin_chk!='Y' && grantor_chk!='Y' ){
	   			 			//grid edit모드 없애기
							fn_notEdit(rowid);	
	   			 		}
                	} 
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
	                            row_selected = row_id;
                             }
                          }
             
           
	     });// end of jqgrid
		//grid header colspan
		$( "#catalogList" ).jqGrid( 'setGroupHeaders', {
			useColSpanStyle : true, 
			groupHeaders : [
								{ startColumnName : 'part_no', numberOfColumns : 1, titleText : 'ITEM 구분' },
								{ startColumnName : 'description', numberOfColumns : 1, titleText : '' },
								{ startColumnName : 'weight', numberOfColumns : 16, titleText : '물성값' },
								{ startColumnName : 'cable_outdia', numberOfColumns : 8, titleText : 'ITEM 부가속성' }
			  				]
		} );
		
		$("#catalogList").setGridParam({datatype: 'json'});

		

	}

	//요청서 작성 일시 유형 list 가져오기
	function fn_set_list_type(){
		if($("#process_type").val()!='00'){ //list_id가 있을경우
			fn_set_info_list();
		}
		else{	//글쓰기 경우
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("selectListType");
			$("#list_type_desc2").val("LIST_TYPE"); 
			$("#list_type_desc1").append("<option value='LIST_TYPE'></option>");
			var formData = getFormData('#application_form'); 
			$.post( sListUrl, formData, function( data ) {
				$("#list_type_desc1").children("[value='LIST_TYPE']").remove();
				for( var i = 0; i < data.length; i++ ){
					$("#list_type_desc1").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
				}
				
			   	fn_set_all_approver(); //모든 검토자 세팅
			   	
			}, "json" );
			fn_set_doc_GridButton();
			//catalogGrid
			catalogGrid();
			//catalog grid에 한줄 자동 생성
			addChmResultRow();
			//catalogGrid 버튼 생성
			fn_set_gridButton();
		}
	}
	
	//검토자일경우 승인/반려 버튼 활성화
	function fn_set_grantor(){
		$(".emp_disabled").prop( "disabled", false );
		var grantor_emp0 = $("#grantor_emp0").val();
		var grantor_emp1 = $("#grantor_emp1").val();
		var grantor_emp2 = $("#grantor_emp2").val();
		var grantor_emp3 = $("#grantor_emp3").val();
		var grantor_emp4 = $("#grantor_emp4").val();
		var user_id	   	 = $("#user_id").val();
		var list_status	 = $("#list_status").val(); 
		var list_type	 = $("#list_type").val(); 
		var admin_chk	 = $("#admin_chk").val();
		if(user_id == grantor_emp0){
			grnator_state("0");
		}
		if(user_id == grantor_emp1){
			grnator_state("1");
		}
		if(user_id == grantor_emp2){
			grnator_state("2");
		}
		if(user_id == grantor_emp3){
			grnator_state("3");
		}
		if(user_id == grantor_emp4){
			grnator_state("4");
		}
		if(admin_chk!='Y'){
			$("#sub_title").prop("readonly",true);
			$("#sub_title").css("background-color","#F5F4EA");
			$("#request_desc_ta").prop("readonly",true);
			$("#request_desc_ta").css("background-color","#F5F4EA");
		}
		$(".emp_disabled").prop( "disabled", true );
		
	}
	
	//검토자일 경우 풀어줘야하는 권한
	function grnator_state(num){
		var list_status = $("#list_status").val();
		var list_type 	= $("#list_type").val();
		/* $( ".btn" ).prop( "disabled", false ); */
		fn_buttonEnable([ "#btnApprove", "#btnReturn" ]);
		/* $( "#btnComplete" ).prop( "disabled", false ); */
		fn_buttonEnable([ "#btnComplete"]);
		
		if(list_status > '01' && list_status < '05'){
			$("#grantor_comment"+num).prop("readonly",false);
			$("#grantor_comment"+num).css("background-color","white");	
		}
	}
	
	function fn_set_all_approver(){
		var list_id = $("#list_id").val();
		var list_type = $("#list_type").val();
		var list_status = $("#list_status").val();
		
		$("#grantor_emp0").empty().data('options');
		$("#grantor_emp1").empty().data('options');
		$("#grantor_emp2").empty().data('options');
		$("#grantor_emp3").empty().data('options');
		$("#grantor_emp4").empty().data('options');
		
		//disabled
	   	$( ".emp_disabled" ).prop( "disabled", false );
	   	$( ".btnRel" ).prop( "disabled", false );
	   	/* $( ".btn_receive" ).prop( "disabled", false ); */
	   	fn_buttonEnable([ "#btnAccept", "#btntemporary"]);
		hideBox();
		$(".comment_disabled").css("background-color","#F5F4EA");
		
 		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectApproverList");
		var formData = getFormData('#application_form');
		$.post( sListUrl, formData, function( data ) {
			for( var i = 0; i < data.length; i++ ){
				if(data[i].aprove_type=='01'){
					$("#grantor_emp0").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept0").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					//alert(data[i].confirm_comment);
					if(data[i].confirm_comment != ""){
						$("#grantor_comment0").val(data[i].confirm_comment);
					}
					$("#d_grantor0").show();
				}
				if(data[i].aprove_type=='02'){
					$("#grantor_emp1").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept1").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					if(data[i].confirm_comment != ""){
						$("#grantor_comment1").val(data[i].confirm_comment);
					}
					$("#d_grantor1").show();
				}
				if(data[i].aprove_type=='03'){
					$("#grantor_emp2").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept2").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					if(data[i].confirm_comment != ""){
						$("#grantor_comment2").val(data[i].confirm_comment);
					}
					$("#d_grantor2").show();
				}
				if(data[i].aprove_type=='04'){
					$("#grantor_emp3").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept3").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					if(data[i].confirm_comment != ""){
					$("#grantor_comment3").val(data[i].confirm_comment);
						}
					$("#d_grantor3").show();
				}
				if(data[i].aprove_type=='05'){
					$("#grantor_emp4").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept4").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					if(data[i].confirm_comment != ""){
						$("#grantor_comment4").val(data[i].confirm_comment);
					}
					$("#d_grantor4").show();
				}
			}
			
		}, "json" );
		
	}
	
	
	//검토자 콤보박스 세팅
	function fn_set_approver() {
		var list_id = $("#list_id").val();
		var list_type = $("#list_type").val();
		var list_status = $("#list_status").val();
		var user_id		= $("#user_id").val();
		$("#grantor_emp0").empty().data('options');
		$("#grantor_emp1").empty().data('options');
		$("#grantor_emp2").empty().data('options');
		$("#grantor_emp3").empty().data('options');
	 	$("#grantor_emp4").empty().data('options');
	 	hideBox();
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectApproverListId");
		var formData = getFormData('#application_form');
		$.post( sListUrl, formData, function( data ) {
			for( var i = 0; i < data.length; i++ ){
				if(user_id==data[i].sb_value){
					$("#grantor_chk").val("Y");
				}
				
				if(data[i].aprove_type=='01'){
					$("#grantor_emp0").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept0").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					$("#grantor_comment0").val(data[i].confirm_comment);
					$("#d_grantor0").show();
				}
				if(data[i].aprove_type=='02'){
					$("#grantor_emp1").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept1").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					$("#grantor_comment1").val(data[i].confirm_comment);
					$("#d_grantor1").show();
					//접속자가 조달 검토자인 경우
					if(user_id==data[i].sb_value){
						$("#grantor_jodal_chk").val("Y");
					}
				}
				if(data[i].aprove_type=='03'){
					$("#grantor_emp2").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept2").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					$("#grantor_comment2").val(data[i].confirm_comment);
					$("#d_grantor2").show();
				}
				if(data[i].aprove_type=='04'){
					$("#grantor_emp3").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept3").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					$("#grantor_comment3").val(data[i].confirm_comment);
					$("#d_grantor3").show();
				}
				if(data[i].aprove_type=='05'){
					$("#grantor_emp4").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
					$("#grantor_dept4").append("<option value='"+data[i].aprove_type+"'>"+data[i].common_name+"</option>");
					$("#grantor_comment4").val(data[i].confirm_comment);
					$("#d_grantor4").show();
				}
			}
			fn_set_grantor();
		}, "json" );
		
	}
	
	//엑셀 Export
	$("input[name=btnExcelExport]").click(function() {
		fn_excelDownload();	
	});
	
	//등록완료 버튼
	$("input[name=btnComplete]").click(function(){   
		$('#catalogList').saveCell(kRow, idCol);
		
		if (!fn_ApproveValidate()) { 
			return;	
		}
		var chmResultRows=[];
		var refUserResultRows = [];
		var list_status = $("#list_status").val();
		if(list_status<'04'){
			$( ".dept_disabled" ).prop( "disabled", false );
			$( ".emp_disabled" ).prop( "disabled", false ); 
			/* $(".loadingBoxArea").show(); */
		}
		getChangedRefUserResultData( function(data){
			refUserResultRows = data;
		});
		getChangedChmResultData( function( data ) { //입력된 모든 row 가져오기
			/* $(".loadingBoxArea").show(); */
			chmResultRows = data;
			var dataList = {chmResultList :JSON.stringify(chmResultRows)};
			var dataList2 = {refUserResultList :JSON.stringify(refUserResultRows)};
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("updateInfoList");
			var formData = getFormData('#application_form');
			var parameters = $.extend({},dataList,formData,dataList2); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
			$.post(sDataUrl, parameters, function(data2) {
				/* $(".loadingBoxArea").hide(); */
				var msg 				= data2.resultMsg;
				var result  			= data2.result;
				alert( msg );
				if ( result == 'success' ) {
					window.returnValue = "OK";
					self.close();
				} else{
					$( ".dept_disabled" ).prop( "disabled", true );
					$( ".emp_disabled" ).prop( "disabled", true );
				}
			}, "json" );
		});
	});
	
	//취소 버튼
	$("input[name=btnCancel]").click(function(){
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("btnCancel");
		var formData = getFormData('#application_form');
		var parameters = $.extend({},formData); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
		$.post(sDataUrl, parameters, function(data2) {
			var msg 				= data2.resultMsg;
			var result  			= data2.result;
			if ( result == 'success' ) {
				window.returnValue = "OK";
				self.close();
			}
		}, "json" );
	});
	
	
	//접수
	$("#btnAccept").click(function(){   
		$('#catalogList').saveCell(kRow, idCol);
		
		if (!fn_checkValidate()) { 
			return;	
		}
		
		var chmResultRows=[];
		var refUserResultRows = [];
		
		$( ".dept_disabled" ).prop( "disabled", false );
		$( ".emp_disabled" ).prop( "disabled", false ); 
		/* $(".loadingBoxArea").show(); */
		getChangedRefUserResultData( function(data){
			refUserResultRows = data;
		});
		getChangedChmResultData( function( data ) { //입력된 모든 row 가져오기
		
			chmResultRows = data;
			var dataList = {chmResultList :JSON.stringify(chmResultRows)};
			var dataList2 = {refUserResultList :JSON.stringify(refUserResultRows)};
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("itemreceive");
			$("#list_status").val("02"); //임시저장 코드가 01번이다.
			var formData = getFormData('#application_form');
			var parameters = $.extend({},dataList,formData,dataList2); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
			$.post(sDataUrl, parameters, function(data2) {
				/* $(".loadingBoxArea").hide(); */
				var msg 				= data2.resultMsg;
				var result  			= data2.result;
				alert( msg );
				if ( result == 'success' ) {
					window.returnValue = "OK";
					self.close();
				} else {
					$( ".dept_disabled" ).prop( "disabled", true );
				}
			}, "json" );
		});
	});
	
	//임시저장
	$("#btntemporary").click(function(){   
		$('#catalogList').saveCell(kRow, idCol);
		
		if($("#sub_title").val() == ""){
			alert("Title을 입력하십시오.");
			$("#sub_title").focus();
			return false;
		}
		
		
		if (!fn_checkValidate()) { 
			return;	
		}
		$( ".dept_disabled" ).prop( "disabled", false );
		$( ".emp_disabled" ).prop( "disabled", false ); 
		
		var chmResultRows=[];
		var refUserResultRows = [];
		
		/* $(".loadingBoxArea").show(); */
		
		getChangedRefUserResultData( function(data){
			refUserResultRows = data;
		});
		
		getChangedChmResultData( function( data ) { //입력된 모든 row 가져오기
			chmResultRows = data;
			
			var dataList = {chmResultList :JSON.stringify(chmResultRows)};
			var dataList2 = {refUserResultList :JSON.stringify(refUserResultRows)};
			
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("temporarystorage");
			$("#list_status").val("01"); //임시저장 코드가 01번이다.
			
			var formData = getFormData('#application_form');
			var parameters = $.extend({},dataList,formData,dataList2); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
			
			$.post(sDataUrl, parameters, function(data2) {
				/* $(".loadingBoxArea").hide(); */
				$( ".dept_disabled" ).prop( "disabled", true );
				
				var msg 				= data2.resultMsg;
				var result  			= data2.result;
				var list_id 			= data2.list_id;
				var list_type			= data2.list_type;
				var list_type_desc		= data2.list_type_desc;
				var list_status			= data2.list_status;
				var list_status_desc 	= data2.list_status_desc;
				var request_date		= data2.request_date;
				alert( msg );
				if ( result == 'success' ) {
					window.returnValue = "OK";
					self.close();
					/* location.href= "tbcItemTrans.tbc"; */
				}
			}, "json" );
		});
		


	});
	
	
	//폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	
	function getChangedChmResultData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var changedData = $.grep($("#catalogList").jqGrid('getRowData'), function (obj) {
			return obj; 
		});
		callback.apply(this, [changedData.concat(resultData)]);
	};
	
	function getCheckDocListData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var changedData = $.grep($("#docList").jqGrid('getRowData'), function (obj) {
			return obj.enable_flag=='Y'; 
		});
		callback.apply(this, [changedData.concat(resultData)]);
	};
	
	function getChangedRefUserResultData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var changedData = $.grep($("#ref_user").jqGrid('getRowData'), function (obj) {
			return obj; 
		});
		callback.apply(this, [changedData.concat(resultData)]);
	};
	
	
	function onlyUpperCase(obj) {
			obj.value = obj.value.toUpperCase();	
	}
	function fn_set_info_list(){
		
		var list_id = $("#list_id").val();
		var user_id = $("#user_id").val();
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectDetail");
		var formData = getFormData('#application_form');
		$.post( sDataUrl, formData, function( data2 ) {
			/* var data2 = $.parseJSON(data); */
			var request_emp_no = data2.request_emp_no;
			$("#list_type").val(data2.list_type);
			$("#list_type_desc2").val(data2.list_type_desc);
			$("#list_status").val(data2.list_status);
			$("#list_status_desc").val(data2.list_status_desc);
			$("#request_date").val(data2.request_date);
			$("#request_desc_ta").val(data2.request_desc);
			$("#request_emp_no").val(data2.request_emp_no);
			$("#request_user_name").val(data2.user_name);
			$("#sub_title").val(data2.request_title);
			var list_type = $("#list_type").val();
			var list_status = $("#list_status").val();

		    //관련자 list 가져오기
		    $("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("selectRefUser");
			jQuery("#ref_user").jqGrid('setGridParam',{url:sListUrl
															 ,datatype:'json'
															 ,mtype : 'POST'
															 ,page:1
															 ,postData: getFormData('#application_form')}).trigger("reloadGrid"); 
															 
			//첨부파일 조회
		    $("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("selectDocList");
			jQuery("#docList").jqGrid('setGridParam',{url:sListUrl
															 ,datatype:'json'
															 ,mtype : 'POST'
															 ,page:1
															 ,postData: getFormData('#application_form')}).trigger("reloadGrid"); 
		    
			//list_type 이 catalog 신규 등록일 경우
			if(list_type=='01'){
				$("#d_catalog").show();
				$("input[name=btnExcelExport]").show();
				$("#catalogList").jqGrid('GridUnload');
				catalogGrid();
				$("input[name=p_daoName]").val("TBC_ITEMTRANS");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("selectCatalogList");
				$("input[name=p_filename]").val("CATALOG_LIST");
				jQuery("#catalogList").jqGrid('setGridParam',{url:sListUrl
																 ,datatype:'json'
																 ,mtype : 'POST'
																 ,page:1
																 ,postData: getFormData('#application_form')}).trigger("reloadGrid");  
				$("#request_desc_ta").prop("rows","3");
			}
			//list_type 이 Item 속성 update일 경우
			else if(list_type=='02'){ 
				$("#d_catalog").show();
				$("input[name=btnExcelExport]").show();
				$("#catalogList").jqGrid('GridUnload');
				itemGrid();
				$("input[name=p_daoName]").val("TBC_ITEMTRANS");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("selectItemList");
				$("input[name=p_filename]").val("ITEM_LIST");
				jQuery("#catalogList").jqGrid('setGridParam',{url:sListUrl
																 ,datatype:'json'
																 ,mtype : 'POST'
																 ,page:1
																 ,postData: getFormData('#application_form')}).trigger("reloadGrid");
				$("#request_desc_ta").prop("rows","3");
			}
			//list_type 이 기타 기준정보 수정일 경우
			else if(list_type=='03'){
				$("#catalogList").jqGrid('GridUnload');
				$("#d_catalog").show();
				$("#request_desc_ta").val(data2.request_desc);
				$("#request_desc_ta").prop("rows","10");
			}
			
			//상태에 따라 버튼,selectbox,검토자 list 권한
			if(list_status == '01'){
				$("#d_receive").show();
				$("#d_approve").hide();
				$("#d_success").hide();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//접속자가 요청자일경우 임시저장상태에서만 삭제 가능하게
				if(user_id==request_emp_no){
					$("input[name=btnAdminDel]").show();
				}
				//검토자 세팅
				fn_set_all_approver();
				//임시저장 상태일때만 첨부파일 수정가능한 버튼 세팅
				fn_set_doc_GridButton();
				if(list_type!='03'){
					fn_set_gridButton();
				}
				
			}else if(list_status == '02'){
				$("#d_receive").hide();
				$("#d_approve").show();
				$("#d_success").hide();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//검토자 세팅
			    fn_set_approver();
			    //접수 중일때 ( 검토중으로 안넘어갔을때) 철회 가능하게 버튼 활성화 (요청자와 접속자가 같은경우)
			    if(user_id == request_emp_no){
			    	/* $("#btnretract").prop("disabled",false); */
			    	fn_buttonEnable([ "#btnretract"]);
			    }
				
			}else if(list_status == '03'){
				$("#d_receive").hide();
				$("#d_approve").show();
				$("#d_success").hide();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//검토자 세팅
			    fn_set_approver();
				
			    //상태가 검토중일 때 한번 승인한사람은 버튼 비활성화
				$("input[name=p_daoName]").val("TBC_ITEMTRANS");
				$("input[name=p_queryType]").val("select");
				$("input[name=p_process]").val("selectConfirmList");
				var formData = getFormData('#application_form');
				$.post( sDataUrl, formData, function( data ) {
					/* if(data==null){
						return;
					}
					var data2 = $.parseJSON(data); */
					if(data.confirm_flag=='Y'){
						$( ".btn" ).prop( "disabled", true );
						fn_buttonDisabled([ "#btnApprove", "#btnReturn" ]);
						$(".comment_disabled").prop("readonly",true);
						$(".comment_disabled").css("background-color","#F5F4EA");
					} else {
						return;
					}
				});
			}else if(list_status == '04'){
				$("#d_receive").hide();
				$("#d_approve").show();
				$("#d_success").hide();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//검토자 세팅
			    fn_set_approver();
			}else if(list_status == '05'){
				$("#d_receive").hide();
				$("#d_approve").hide();
				$("#d_success").show();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//검토자 세팅
			    fn_set_approver();
				
			}else if(list_status == '06'){
				$("#d_receive").hide();
				$("#d_approve").hide();
				$("#d_success").show();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//검토자 세팅
			    fn_set_approver();
			    $("#btnComplete").hide();
			    $("#sub_title").prop("readonly",true);
				$("#sub_title").css("background-color","#F5F4EA");
				$("#request_desc_ta").prop("readonly",true);
				$("#request_desc_ta").css("background-color","#F5F4EA");
			}else{
				$("#d_receive").show();
				$("#d_approve").hide();
				$("#d_success").hide();
				$("#list_type_desc1").hide();
				$("#list_type_desc2").show();
				//검토자 세팅
				fn_set_all_approver();
			}
			
			//접속자가 요청자일경우
			if(user_id==request_emp_no){
				/* $(".btn_receive").prop("disabled",false); */
				fn_buttonEnable([ "#btnAccept", "#btntemporary" ]);
			}else{
				fn_buttonDisabled([ "#btnAccept", "#btntemporary" ]);
				fn_buttonDisabled([ "#btnApprove", "#btnReturn" ]);
				/* $(".btn_receive").prop("disabled",true);
				$(".btn").prop("disabled",true); */
				
			}
			
			
		}); //end of $.post
	}

	function fn_search(){
		var list_type = $("#list_type").val();
		//list_type 이 catalog 신규 등록일 경우
		if(list_type=='01'){
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("selectCatalogList");
			
			jQuery("#catalogList").jqGrid('setGridParam',{url:sListUrl
															 ,datatype:'json'
															 ,page:1
															 ,postData: getFormData('#application_form')}).trigger("reloadGrid");  
		}
		//list_type 이 Item 속성 update일 경우
		else if(list_type=='02'){ 
		
		}
		//list_type 이 기타 기준정보 수정일 경우
		else if(list_type=='03'){
		
		}
	}
	
	function fn_DocSearch(){
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectDocList");
		
		jQuery("#docList").jqGrid('setGridParam',{url:sListUrl
														 ,datatype:'json'
														 ,mtype : 'POST'
														 ,page:1
														 ,postData: getFormData('#application_form')}).trigger("reloadGrid"); 
	}
	
	function fn_ApproveValidate()
	{
		var result   = true;
		var message  = "";
		var $grid	 = $("#catalogList");
		var ids ;
		var list_type = $("#list_type").val();
		
		if(list_type=='01'){
			ids = $grid.jqGrid('getDataIDs');	
			for(var i=0; i < ids.length; i++) {
				var iRow = $grid.jqGrid('getRowData', ids[i]);
				if (iRow.category == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"번째 ROW의 CATEGORY는 필수입니다";	
					break;	
				}
				if (iRow.catalog == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 CATALOG는 필수입니다";	
					break;	
				}
				if (iRow.description == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 Description는 필수입니다";	
					break;	
				}
				if (iRow.uom == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 UOM는 필수입니다";	
					break;	
				}
				if (iRow.attibute_01 == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 ATTR1은 필수입니다";	
					break;	
				}
				/*
				if (iRow.po_request_type == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 구매요청는 필수입니다";	
					break;	
				}*/
				if (iRow.bom_create_date == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 BOM 구성 예정는 필수입니다";	
					break;	
				}
				//조달 관리자인경우에만 필수 체크
				if($("#grantor_jodal_chk").val()=='Y'){
				/*
					if (iRow.n_ship_flag == '') {
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"번째 ROW의 특수선 여부는 필수입니다";	
						break;	
					}
					*/
					if (iRow.tech_spec_flag == '') {
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 TECH_SPEC_FLAG는 필수입니다";	
						break;	
					}
					/*
					if (iRow.ship_type == '') {
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 선종 구분는 필수입니다";	
						break;	
					}*/
					
					if (iRow.buyer_emp_no==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 구매자는 필수입니다";	
						break;	
					}
					if (iRow.process_emp_no==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 공정관리자는 필수입니다";	
						break;	
					}
					if (iRow.mrp_planning_flag==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 MRP계획 대상여부는 필수입니다";	
						break;	
					}
					/*
					if (iRow.f_order_cancel==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 F.ORDER(취소)는 필수입니다";	
						break;	
					}
					if (iRow.f_order_open==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 F.ORDER(납기)는 필수입니다";	
						break;	
					}
					*/
					if (iRow.standar_lead_time==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 표준 리드타임는 필수입니다";	
						break;	
					}
					if (iRow.pegging_flag==''){
						result  = false;
						message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 페깅여부는 필수입니다";	
						break;	
					}
				}
				
				
			}
		}
		
		if(list_type=='02'){
			ids = $grid.jqGrid('getDataIDs');	
			for(var i=0; i < ids.length; i++) {
				var iRow = $grid.jqGrid('getRowData', ids[i]);
				if (iRow.part_no==''){
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 Name는 필수입니다";	
					break;	
				}
			}
		}
		if (!result) {
			alert(message);
		}
		
		return result;	
	}
	
	//접수시 필수값 체크
	function fn_checkValidate()
	{
		if($("#sub_title").val() == ""){
			mssage = "Title을 입력하십시오."
			$("#sub_title").focus();
			result  = false;
		}
		var result   = true;
		var message  = "";
		var $grid	 = $("#catalogList");
		var ids ;
		var list_type = $("#list_type").val();
		
		if(list_type=='01'){
			ids = $grid.jqGrid('getDataIDs');	
			for(var i=0; i < ids.length; i++) {
				var iRow = $grid.jqGrid('getRowData', ids[i]);
				if (iRow.category == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"번째 ROW의 CATEGORY는 필수입니다";	
					break;	
				}
				if (iRow.catalog == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 CATALOG는 필수입니다";	
					break;	
				}
				if (iRow.description == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 Description는 필수입니다";	
					break;	
				}
				if (iRow.uom == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 UOM는 필수입니다";	
					break;	
				}
				if (iRow.attibute_01 == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 ATTR1은 필수입니다";	
					break;	
				}
				/*
				if (iRow.po_request_type == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 구매요청는 필수입니다";	
					break;	
				}
				*/
				if (iRow.bom_create_date == '') {
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 BOM 구성 예정는 필수입니다";	
					break;	
				}
			}
		}
		if(list_type=='02'){
			ids = $grid.jqGrid('getDataIDs');	
			for(var i=0; i < ids.length; i++) {
				var iRow = $grid.jqGrid('getRowData', ids[i]);
				if (iRow.part_no==''){
					result  = false;
					message =  $grid.jqGrid('getInd',ids[i]) +"ROW의 Name는 필수입니다";	
					break;	
				}
			}
		}
		
		if (!result) {
			alert(message);
		}
		
		return result;	
	}
	
	function fn_excelDownload()
	{
		form = $('#application_form');
		var p_filename = $("#p_filename").val();
		
		var url = "";
		
		if(p_filename=='CATALOG_LIST'){
			url = "standardInfoTransDetailExcelPrint.do"; 
			
			//필수 파라미터 S
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("catalogExcelPrint");				
		}
		else if(p_filename=='ITEM_LIST'){		
			url = "standardInfoTransDetailExcelPrintItem.do"; 
		
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("itemExcelPrint");			
			
			// ITEM 속성업데이트 엑셀 출력 시 헤더 컬럼이 4줄로 표현.. 스크립트 단에서 컬럼 명 정의해서 넘겨준다. (속성업데이트 업로드 엑셀 양식으로 사용 가능)
			var headerNames = [];			
			
			var headerRow0 = [];
			headerRow0.push({"name":"STX조선 아이템 물성값 UP-DATE TABLE(PLM/ERP SYSTEM)","row_to":0,"start_index":0,"end_index":26});
			var row0 = {"row":0,"rowvalue":headerRow0};
			
			var headerRow1 = [];
			headerRow1.push({"name":"ITEM 구분","row_to":1,"start_index":0,"end_index":0});
			headerRow1.push({"name":"","row_to":1,"start_index":1,"end_index":1});
			headerRow1.push({"name":"","row_to":1,"start_index":2,"end_index":2});
			headerRow1.push({"name":"물성값","row_to":1,"start_index":3,"end_index":17});
			headerRow1.push({"name":"ITEM 부가속성","row_to":1,"start_index":18,"end_index":26});
			var row1 = {"row":1,"rowvalue":headerRow1};
			
			var headerRow2 = [];
			headerRow2.push({"name":"Name","row_to":2,"start_index":0,"end_index":0});
			headerRow2.push({"name":"Description","row_to":2,"start_index":1,"end_index":1});
			headerRow2.push({"name":"Weight","row_to":2,"start_index":2,"end_index":2});
			headerRow2.push({"name":"Attr0","row_to":2,"start_index":3,"end_index":3});
			headerRow2.push({"name":"Attr1","row_to":2,"start_index":4,"end_index":4});
			headerRow2.push({"name":"Attr2","row_to":2,"start_index":5,"end_index":5});
			headerRow2.push({"name":"Attr3","row_to":2,"start_index":6,"end_index":6});
			headerRow2.push({"name":"Attr4","row_to":2,"start_index":7,"end_index":7});
			headerRow2.push({"name":"Attr5","row_to":2,"start_index":8,"end_index":8});
			headerRow2.push({"name":"Attr6","row_to":2,"start_index":9,"end_index":9});
			headerRow2.push({"name":"Attr7","row_to":2,"start_index":10,"end_index":10});
			headerRow2.push({"name":"Attr8","row_to":2,"start_index":11,"end_index":11});
			headerRow2.push({"name":"Attr9","row_to":2,"start_index":12,"end_index":12});
			headerRow2.push({"name":"Attr10","row_to":2,"start_index":13,"end_index":13});
			headerRow2.push({"name":"Attr11","row_to":2,"start_index":14,"end_index":14});
			headerRow2.push({"name":"Attr12","row_to":2,"start_index":15,"end_index":15});
			headerRow2.push({"name":"Attr13","row_to":2,"start_index":16,"end_index":16});
			headerRow2.push({"name":"Attr14","row_to":2,"start_index":17,"end_index":17});
			
			headerRow2.push({"name":"Cable Outdia","row_to":2,"start_index":18,"end_index":18});
			headerRow2.push({"name":"Can Size","row_to":2,"start_index":19,"end_index":19});
			headerRow2.push({"name":"STXSVR","row_to":2,"start_index":20,"end_index":20});
			headerRow2.push({"name":"Thinner Code","row_to":2,"start_index":21,"end_index":21});
			headerRow2.push({"name":"Paint Code","row_to":2,"start_index":22,"end_index":22});
			headerRow2.push({"name":"Cable Type","row_to":2,"start_index":23,"end_index":23});
			headerRow2.push({"name":"Cable Length","row_to":2,"start_index":24,"end_index":24});
			headerRow2.push({"name":"STXStandard","row_to":2,"start_index":25,"end_index":25});
			headerRow2.push({"name":"TBC PAINT CODE","row_to":2,"start_index":26,"end_index":26});		

			var row2 = {"row":2,"rowvalue":headerRow2};
			
			var headerRow3 = [];
			headerRow3.push({"name":"CODE","row_to":3,"start_index":0,"end_index":0});
			headerRow3.push({"name":"DESCRIPTION","row_to":3,"start_index":1,"end_index":1});
			headerRow3.push({"name":"단중(KG)","row_to":3,"start_index":2,"end_index":2});
			headerRow3.push({"name":"물성값1","row_to":3,"start_index":3,"end_index":3});
			headerRow3.push({"name":"물성값2","row_to":3,"start_index":4,"end_index":4});
			headerRow3.push({"name":"물성값3","row_to":3,"start_index":5,"end_index":5});
			headerRow3.push({"name":"물성값4","row_to":3,"start_index":6,"end_index":6});
			headerRow3.push({"name":"물성값5","row_to":3,"start_index":7,"end_index":7});
			headerRow3.push({"name":"물성값6","row_to":3,"start_index":8,"end_index":8});
			headerRow3.push({"name":"물성값7","row_to":3,"start_index":9,"end_index":9});
			headerRow3.push({"name":"물성값8","row_to":3,"start_index":10,"end_index":10});
			headerRow3.push({"name":"물성값9","row_to":3,"start_index":11,"end_index":11});
			headerRow3.push({"name":"물성값10","row_to":3,"start_index":12,"end_index":12});
			headerRow3.push({"name":"물성값11","row_to":3,"start_index":13,"end_index":13});
			headerRow3.push({"name":"물성값12","row_to":3,"start_index":14,"end_index":14});
			headerRow3.push({"name":"물성값13","row_to":3,"start_index":15,"end_index":15});
			headerRow3.push({"name":"물성값14","row_to":3,"start_index":16,"end_index":16});
			headerRow3.push({"name":"물성값15","row_to":3,"start_index":17,"end_index":17});
			
			headerRow3.push({"name":"CABLE OUTDIA","row_to":3,"start_index":18,"end_index":18});
			headerRow3.push({"name":"CAN SIZE","row_to":3,"start_index":19,"end_index":19});
			headerRow3.push({"name":"SVR(고형율)","row_to":3,"start_index":20,"end_index":20});
			headerRow3.push({"name":"신나 연계코드","row_to":3,"start_index":21,"end_index":21});
			headerRow3.push({"name":"PAINT 동하절기 연계코드","row_to":3,"start_index":22,"end_index":22});
			headerRow3.push({"name":"CABLE TYPE 약어","row_to":3,"start_index":23,"end_index":23});
			headerRow3.push({"name":"CABLE 표준 DRUM 길이","row_to":3,"start_index":24,"end_index":24});
			headerRow3.push({"name":"표준품 여부","row_to":3,"start_index":25,"end_index":25});
			headerRow3.push({"name":"TBC PAINT CODE","row_to":3,"start_index":26,"end_index":26});			
			
			var row3 = {"row":3,"rowvalue":headerRow3};		
			
			headerNames.push(row0);
			headerNames.push(row1);
			headerNames.push(row2);
			headerNames.push(row3);
			
			application_form.excelHeaderName.value = "";
			application_form.excelHeaderName.value = JSON.stringify(headerNames);			
		}
		

		
		//필수 파라미터 E	
		form.attr("action", url);
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	}
	
	//유저 팝업
	function searchInsaUser(obj,sCode,sDesc) {
		var searchIndex = $(obj).closest('tr').get(0).id;
		$('#catalogList').saveCell(kRow, idCol);
			
		var item = $(tableId).jqGrid('getRowData',searchIndex);		
		var buyer_emp_no = item.buyer_emp_no;
		var buyer_user_name = item.buyer_user_name;
		var args = {
					p_code_find : buyer_emp_no
		};
			
		var rs = window.showModalDialog("popUpItemTransUserSearch.do?p_process=userSearch",args,"height=560,width=600,top=200,left=900,location=no,scrollbars=no");
		if (rs != null) {
			$('#catalogList').setCell(searchIndex,sCode,rs[0]);
			$('#catalogList').setCell(searchIndex,sDesc,rs[1]);
		}
		
	}
	
	function fn_GrantorSearch(){
		//ADMIN 권한 관리
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectAdminUser");
		var user_id = $("#user_id").val();
		var formData = getFormData('#application_form');
		$.post( sListUrl, formData, function( data ) {
			for( var i = 0; i < data.length; i++ ){
				if(user_id == data[i].common_code){
					/* $(".btn_receive").prop("disabled",false);
					$(".btn").prop("disabled",false); */
					fn_buttonEnable([ "#btnApprove", "#btnReturn" ]);
					fn_buttonEnable([ "#btnAccept", "#btntemporary" ]);
					/* $("#btnComplete").prop("disabled",false); */
					fn_buttonEnable([ "#btnComplete"]);
					$("input[name=btnAdminDel]").show();
					$("#admin_chk").val("Y");
				}
			}
			//요청서 작성 일시 유형 list 가져오기
			fn_set_list_type();
		}, "json" );
	}
	
	function setUpperCase(gridId, rowId, colNm){
		if (rowId != 0 ) {
			
			var $grid  = $(gridId);
			var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
					
			$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
			//$grid.jqGrid("setCell", rowId, "pe_desc", $('input[name=project_no]').val()+"_"+sTemp.toUpperCase());
		}
	}
	function fn_setListId(list_id){
		$("#list_id").val(list_id);
		alert('업로드 성공');
		fn_DocSearch();
	}
	function fn_downLoadFile(document_id){
		//var attURL = "tbcItemTrans.tbc?";
		var attURL = "itemTransDownload.do?";
    	attURL += "document_id="+document_id;
    	attURL += "&p_process=fileDownload";
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
		window.open(attURL,"",sProperties);
	}
	
	function fn_notEdit(rowid){
			jQuery("#catalogList").jqGrid('setCell', rowid, 'category', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'catalog', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'description', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'uom', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_01', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_02', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_03', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_04', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_05', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_06', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_07', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_08', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_09', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_10', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_11', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_12', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_13', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_14', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attibute_15', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'po_request_type', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'po_delegate_item', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'vendor_drawing_no', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'bom_create_date', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'level_01', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'level_02', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'level_03', '', 'not-editable-cell');
//			jQuery("#catalogList").jqGrid('setCell', rowid, 'n_ship_flag', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'tech_spec_flag', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'ship_type', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'buyer_emp_no', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'buyer_user_name', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'process_emp_no', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'process_user_name', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'standar_lead_time', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'mrp_planning_flag', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'pegging_flag', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'distributor_emp_no', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'f_order_cancel', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'f_order_open', '', 'not-editable-cell');
			
			
			jQuery("#catalogList").jqGrid('setCell', rowid, 'part_no', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'description', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'weight', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr00', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr01', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr02', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr03', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr04', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr05', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr06', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr07', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr08', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr09', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr10', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr11', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr12', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr13', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'attr14', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'cable_outdia', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'cable_size', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'stxsvr', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'thinner_code', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'paint_code', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'cable_type', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'cable_length', '', 'not-editable-cell');
			jQuery("#catalogList").jqGrid('setCell', rowid, 'stxstandard', '', 'not-editable-cell');
	}
	
		
</script>
</body>
</html>