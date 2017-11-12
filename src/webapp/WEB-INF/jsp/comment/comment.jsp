<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>COMMENT</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.totalEaArea {
		position: relative;
		margin-left: 10px;
		margin-right: 0px;
		padding: 4px 4px 6px 4px;
		font-weight: bold;
		border: 1px solid #ccc;
		background-color: #D7E4BC;
		vertical-align: middle;
	}
	.onMs {
		background-color: #FFFA94;
	}
	
	.sscType {
		color: #324877;
		font-weight: bold;
	}
	
	.grid-test {
		font : italic;
		color: #0000FF;
		font-weight: bold;
	}
	
	#jqGridList_receipt_no, #jqGridList_sub_no, #jqGridList_sub_title,
	#jqGridList_initials, #jqGridList_issue_date, #jqGridList_com_no, #jqGridList_builders_reply, #jqGridList_builder_user_name,
	#jqGridList_builder_date, #jqGridList_sub_att, #jqGridList_ref_no, #jqGridList_status, #jqGridList_confirm_user_name, #jqGridList_confirm_date {
		border-right-color: #807fd7;
	}
	
	#jqGridList_list_no {
		text-align: right;
	}
	#jqGridList_list_no {
		border-right: 0px; 
	}
	
	#jqGridList_sub_no {
		text-align: left;
	}
	
</style>
</head>
<body>
<form id="application_form" name="application_form" enctype="multipart/form-data" method="post">
	<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<input type="hidden" name="temp_project_no" id="temp_project_no"  value="" />
	<input type="hidden" name="p_auth_code" id="p_auth_code"  value="${loginUser.author_code}" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	<input type="hidden" name="upper_dwg_dept_code" id="upper_dwg_dept_code"  value="${loginUser.upper_dwg_dept_code}" />
	<input type="hidden" name="dwg_dept_code" id="dwg_dept_code"  value="${loginUser.dwg_dept_code}" />
	<input type="hidden" name="dwgabbr_eng" id="dwgabbr_eng"  value="${loginUser.dwgabbr_eng}" />
	<input type="hidden" name="confirm_user" id="confirm_user"  value="${loginUser.confirm_user}" />
	<input type="hidden" name="p_pcf_admin_page" id="p_pcf_admin_page"  value="" />
	<input type="hidden" name="h_my_dept_yn" id="h_my_dept_yn" value="Y" /> 

	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			COMMENT
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="780">
			<col width="200">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 
				Project
				<input type="text" class="required" id="p_project_no" maxlength="10" name="p_project_no" style="width:50px; ime-mode:disabled;"  onkeyup="javascript:getDwgNos();" onchange="javascript:this.value=this.value.toUpperCase();" alt="호선정보"/>
				DWG No
				<input type="text" id="p_dwg_no" name="p_dwg_no" style="width:75px; ime-mode:disabled;" class="required" onchange="javascript:this.value=this.value.toUpperCase();" alt="도면정보" />
				&nbsp;
				Issuer
				<select name="p_issuer" id="p_issuer" style="width:80px;" onchange="javascript:issuerChagne(this.value);" >
					<option value="O">BUYER</option>
					<option value="C">CLASS</option>
				</select>	
				&nbsp;
				수신 No
				<input type="text" id="p_receipt_no" maxlength="11" name="p_receipt_no" style="width:80px; ime-mode:disabled;" onchange="javascript:this.value=this.value.toUpperCase();" alt="호선정보"/>
				&nbsp;
				Sub No
				<input type="text" id="p_sub_no" name="p_sub_no" style="width:50px; ime-mode:disabled;" />
				&nbsp;
				Status
				<select name="p_status" id="p_status" style="width:80px;" >
					<option value="ALL">ALL</option>
					<option value="O">OPEN</option>
					<option value="C">CLOSED</option>
				</select>
			</td>	
			<td style="border-left:none;border-right:none;">	
				<div style="background-color: #F4B5A9;width:145px;padding:3px">
					<font><b>승인자</b></font>
					<select name="p_receipt_user_id" id="p_receipt_user_id" >
					</select>
				</div>
			</td>
			<td style="border-left:none;">
				<div class="button endbox">
					<input type="button" value="번역기" id="btnTranslate" class="btn_red2"/>
					<input type="button" value="PCF" id="btnPcf"  class="btn_red2" />
					<!-- <input type="button" value="IMPORT" id="btnExlImp"  class="btn_red2" /> -->
					<input type="button" value="C_Form" id="btnForm"  class="btn_red2" />
					<input type="button" value="R_Form" id="btnReplyForm"  class="btn_red2" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<%-- <c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="ADD" id="btnAdd"  class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="DELETE" id="btnDel"  class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="SAVE" id="btnSave"  class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="승인요청" id="btnConfirm" class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
					</c:if> --%>
						<input type="button" value="ADD" id="btnAdd"  class="btn_blue2" />
						<input type="button" value="DELETE" id="btnDel"  class="btn_blue2" />
						<input type="button" value="SAVE" id="btnSave"  class="btn_blue2" />
						<input type="button" value="승인요청" id="btnConfirm" class="btn_blue2" />
						<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
				</div>
			</td>						
			</tr>
		</table>
		
		<div id="jqGridListDiv" class="content">
			<table id="jqGridList"></table>
			<div id="btnjqGridList"></div>
		</div>
		
	</div> <!-- .mainDiv end -->
</form>
</body>
<script type="text/javascript">

var idRow;
var idCol;
var kRow;
var kCol;

var jqGridObj = $('#jqGridList');

var getDwgNos = function(){
	if($("input[name=p_project_no]").val() != ""){
		
		var chk_project_no = $("input[name=p_project_no]").val();
		if(chk_project_no.length != 5)
		{
			return;
		}
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		$.ajaxSetup({async: false});
		getAjaxTextPost(null, "commentAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
		$.ajaxSetup({async: true});
	}
}

//도면번호 받아온 후
var getdwgnoCallback = function(txt){
	var arr_txt = txt.split("|");
    $("#p_dwg_no").autocomplete({
		source: arr_txt,
		minLength:1,
		matchContains: true, 
		max: 30,
		autoFocus: true,
		selectFirst: true,
		open: function () {
			$(this).removeClass( 'ui-corner-all' ).addClass( 'ui-corner-top' );
		},
		close: function () {
			$(this).removeClass( 'ui-corner-top' ).addClass( 'ui-corner-all' );
	    }
    });
}

//발신문서 승인자 선택
if(typeof($("#p_receipt_user_id").val()) !== 'undefined'){
	getAjaxHtml($("#p_receipt_user_id"),"commonSelectBoxDataList.do?sb_type=N&p_query=getCommentConfirmUserList&p_dept_code="+$("input[name=dwg_dept_code]").val() + "&confirm_user="+$("input[name=confirm_user]").val(), null, null);	
}

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'수신 ID' ,name:'receipt_id' , index:'receipt_id' ,width:100 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 DETAIL_ID' ,name:'receipt_detail_id' , index:'receipt_detail_id' ,width:100 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 No.' ,name:'receipt_no' , index:'receipt_no' ,width:70 ,align:'center', sortable:false,  title:false, editable:true,
		edittype : "select",
  		editrules : { required : false },
  		cellattr: function (){return 'class="required_cell"';},
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "commentReceiptNoList.do?p_project_no=" + $("#p_project_no").val() + "&p_dwg_no=" + $("#p_dwg_no").val() + "&p_issuer=" + $("#p_issuer").val();
				return url;
			},
  			buildSelect: function(data){
  				if(typeof(data)=='string'){
     				data = $.parseJSON(data);
    			}
 				var rtSlt = '<select id="selectReceiptNo" name="selectReceiptNo" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="'+data[idx].object+'" name="'+data[idx].receipt_detail_id+'">'+data[idx].object+'</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    var attr = $(e.target).find("option:selected").attr('name');
                    jqGridObj.setCell(rowId, 'receipt_detail_id', attr);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    var attr = $(e.target).find("option:selected").attr('name');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.setCell(rowId, 'receipt_detail_id', attr);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    var attr = $(e.target).find("option:selected").attr('name');
            		jqGridObj.setCell(rowId, 'receipt_detail_id', attr);
                    
            	}
            }]
  		 }
	});
	gridColModel.push({label:'Sub' ,name:'list_no' , index:'list_no' ,width:20 ,align:'center', sortable:false,  title:false, frozen: true});
	gridColModel.push({label:'No.' ,name:'sub_no' , index:'sub_no' ,width:20 ,align:'center', sortable:false, title:false, frozen: true});
	gridColModel.push({label:'BUYER\'S COMMENT' ,name:'sub_title' , index:'sub_title' ,width:300 ,align:'left', sortable:false, title:true, editable:true,
		edittype: "textarea",
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return 'colspan=8';
			}
		}
	});
	gridColModel.push({label:'INITIAL' ,name:'initials' , index:'initials' ,width:60 ,align:'center', sortable:false, title:false, editable:true,
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		}
	});
	gridColModel.push({label:'DATE' ,name:'issue_date' , index:'issue_date' ,width:60 ,align:'center', sortable:false, title:false,
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		}
	});
	gridColModel.push({label:'Com No.' ,name:'com_no' , index:'com_no' ,width:60, align:'center', sortable:false, title:false,
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		}
	});
	gridColModel.push({label:'BUILDER\'S REPLY' ,name:'builders_reply' , index:'builders_reply' ,width:300 ,align:'left', sortable:false, title:true, editable:true,
		edittype: "textarea",
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		}
	});
	gridColModel.push({label:'BUILDER' ,name:'builder_user_name' , index:'builder_user_name' ,width:40 ,align:'center', sortable:false, title:false, editable:true,
		edittype : "select",
  		editrules : { required : false },
  		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		},
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "commentReceiptGridUserList.do?sb_type=all&p_dept_code=" + $("#dwg_dept_code").val();
				return url;
			},
  			buildSelect: function(data){

  				data = $.parseJSON(data);
  				
 				var rtSlt = '<select id="selectbuilderUserName" name="selectbuilderUserName" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="' + data[idx].sb_value + '"' + data[idx].selected + '>' + data[idx].sb_name + '</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    jqGridObj.setCell(rowId, 'builder_user_id', e.target.value);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.setCell(rowId, 'builder_user_id', e.target.value);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.setCell(rowId, 'builder_user_id', e.target.value);
                    
            	}
            }]
  		 }
	});
	gridColModel.push({label:'BUILDER ID' ,name:'builder_user_id' , index:'builder_user_id' ,width:60 ,align:'center', sortable:false, title:false, hidden: true,
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		}
	});
	gridColModel.push({label:'DATE' ,name:'builder_date' , index:'builder_date' ,width:60 ,align:'center', sortable:false, title:false, editable:true,
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		},
		editoptions: { 
			dataInit: function(el) { 
				$(el).datepicker({
			    	dateFormat: 'yy-mm-dd',
			    	prevText: '이전 달',
				    nextText: '다음 달',
				    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				    dayNames: ['일','월','화','수','목','금','토'],
				    dayNamesShort: ['일','월','화','수','목','금','토'],
				    dayNamesMin: ['일','월','화','수','목','금','토'],
				    showMonthAfterYear: true,
				    yearSuffix: '년'
				    /* onSelect: function () {
                        $("#jqGridList").jqGrid("saveCell", idRow, idCol);
                    } */
	  			}); 
			} 
		}
	});
	gridColModel.push({label:'첨부' ,name:'sub_att' , index:'sub_att' ,width:40 ,align:'center', sortable:false, title:false,
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return ' style="display:none;"';
			}
		}
	});
	gridColModel.push({label:'Ref No.' ,name:'ref_no' , index:'ref_no' ,width:100 ,align:'center', sortable:false, title:false, editable:true,
		edittype : "select",
  		editrules : { required : false },
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "commentRefNoList.do?sb_type=all&p_project_no=" + $("#p_project_no").val() + "&p_dept_code=" + $("#dwg_dept_code").val() + "&p_issuer=" + $("#p_issuer").val();
				return url;
			},
  			buildSelect: function(data){

  				data = $.parseJSON(data);
  				
 				var rtSlt = '<select id="selectRefNo" name="selectRefNo" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="' + data[idx].ref_no + '" name="' + data[idx].send_id + '" >' + data[idx].ref_no + '</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    jqGridObj.setCell(rowId, 'send_id', $(e.target).find("option:selected").attr('name'));
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.setCell(rowId, 'send_id', $(e.target).find("option:selected").attr('name'));
            		}
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
            		jqGridObj.setCell(rowId, 'send_id', $(e.target).find("option:selected").attr('name'));
            	}
            }]
  		 }
	});
	gridColModel.push({label:'BUYER STATUS' ,name:'status' , index:'status' ,width:70 ,align:'center', sortable:false, title:false, editable:true,
		formatter : 'select', edittype : 'select', editoptions : { value : "O:OPEN;A:NOACT;N:NOTICE;C:CLOSED" },
		cellattr: function(rowId, tv, rawObject, cm, rdata) {  
			if (rawObject.sub_no == '0') { 
				return 'disabled = disabled';
			}
		}
	});
	gridColModel.push({label:'승인자' ,name:'confirm_user_name' , index:'confirm_user_name' ,width:50 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'승인자ID' ,name:'confirm_user_id' , index:'confirm_user_id' ,width:50 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'승인일자' ,name:'confirm_date' , index:'confirm_date' ,width:50 ,align:'center', sortable:false, title:false});
	gridColModel.push({label:'발신 ID' ,name:'send_id' , index:'send_id' ,width:50 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'Dwg No' ,name:'dwg_no' , index:'dwg_no' ,width:50 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'복호화NAME' ,name:'dec_sub_att_name' , index:'dec_sub_att_name' ,width:60 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'복호화' ,name:'dec_sub_att' , index:'dec_sub_att' ,width:60 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'COMMENT_SUB_ID', name:'comment_sub_id', width:50, index:'comment_sub_id', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'DELETE_ENABLE_FLAG', name:'delete_enable_flag', width:50, index:'delete_enable_flag', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'EDIT_ENABLE_FLAG', name:'edit_enable_flag', width:50, index:'edit_enable_flag', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'ADD_ENABLE_FLAG', name:'add_enable_flag', width:50, index:'add_enable_flag', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'ACTION', name:'action', width:50, index:'action', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden: true} );
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).keydown(function (e) { 
	if (e.keyCode == 27) { 
		e.preventDefault();
	} // esc 막기
	if(e.target.nodeName != "INPUT"){
		if(e.keyCode == 8) {
			return false;
		}
	}
});

$(document).ready(function(){
	
	if("" != "${p_project_no}" && "" != "${p_dwg_no}") {
		$("#p_project_no").val("${p_project_no}");
		$("#p_dwg_no").val("${p_dwg_no}");
		$("#p_issuer").val("${p_issuer}");

		setTimeout(function(){
			$("#btnSearch").click();
		 }, 500);
	}
	
	fn_buttonDisabled2([ "#btnAdd", "#btnPcf", "#btnSave", "#btnForm", "#btnReplyForm" ]);
	//fn_buttonDisabled2([ "#btnAdd", "#btnPcf", "#btnSave" ]);
	
	jqGridObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'',
	    postData : fn_getFormData('#application_form'),
	    colModel: gridColModel,
	    gridview: true,
	    cellEdit : true,
	    cellsubmit : 'clientArray', // grid edit mode 2
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit: true,
	    multiselect: true,
	    //pager: $('#btnjqGridList'),
	    rowList:[1000],
	    recordtext: '내용 {0} - {1}, 전체 {2}',
	    emptyrecords:'조회 내역 없음',
	    rowNum:1000, 
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
	    onPaging: function(pgButton) {
	    	
	    		var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt(jqGridObj.getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt(jqGridObj.getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 1000;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnjqGridList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
		 },		
		 loadComplete: function (data) {
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
				
				var rows = $(this).getDataIDs();
				var columnModels = $(this).getGridParam().colModel;
				
				for ( var i = 0; i < rows.length; i++ ) {
					
					var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
					
					if(item.edit_enable_flag == 'N') {
						jqGridObj.setRowData(rows[i], false, {background : "#dfdfdf"});
						for (var j = 0; j < columnModels.length; j++) {
							
							var model = columnModels[j];
							jqGridObj.setCell(rows[i], model.name, '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
							
							if(item.add_enable_flag != 'Y') {
								$("tr#" + rows[i] + ".jqgrow > td > input.cbox").attr("disabled", true);	
							}
							
						}
						
					}
					
					
					if(item.sub_no == '0') {
						$('#jqGridList tr[id=' + rows[i] + ']').addClass('grid-test');
						//$("tr#" + rows[i] + ".jqgrow > td > input.cbox").attr("disabled", true);
						jqGridObj.setCell(rows[i], 'receipt_no', '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
						jqGridObj.setCell(rows[i], 'ref_no', '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
					}
					
				}
				
		 },
		 beforeSelectRow:function(rowid, e) {   
			 var cbs = $("tr#"+rowid+".jqgrow > td > input.cbox:disabled", jqGridObj[0]);
			 if (cbs.length === 0) 
			 {
			 	return true;    // allow select the row    
			 }
			 else 
			 { 
			 	return false;   // not allow select the row  
			 }
		 },
		 onSelectAll: function(aRowids,status) {
			if (status) {                  
				var rows = jqGridObj.getDataIDs();
				for(var i=0; i<rows.length; i++){
					var cbs = $("tr#" + rows[i] + ".jqgrow > td > input.cbox:disabled", jqGridObj[0]);
					cbs.removeAttr("checked");
				}
			}
		 },
		 onCellSelect : function( rowid, iCol, cellcontent, e ) {
			jqGridObj.saveCell(kRow, idCol );

			var item = $(this).jqGrid( 'getRowData', rowid );
			
			var cm = jqGridObj.jqGrid( "getGridParam", "colModel" );
			var colName = cm[iCol];
			var myDeptYn = $("#h_my_dept_yn").val();
			
			if ( colName['index'] == "sub_att" ) {

				var sURL = "popUpCommentMainAttach.do?row_selected="+rowid + "&comment_sub_id="+item.comment_sub_id +"&view_flag="+myDeptYn + "&edit_enable_flag=" + item.edit_enable_flag;
				var popOptions = "dialogWidth:800px; dialogHeight: 380px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
				
				/* var popOptions = "width=350, height=380, resizable=yes, scrollbars=no, status=yes"; 
				var win = window.open(sURL, "bomStatus", popOptions); 
				
				setTimeout(function(){
					win.focus();
				 }, 1000); */
				
			}
				
		 },
		 afterSaveCell : chmResultEditEnd
	}); //end of jqGrid
	
	fn_gridresize( $(window), $( "#jqGridList" ), -20 );
	
	//jqGrid 크기 동적화
	jqGridObj.jqGrid('setLabel','receipt_no', '', {'background':'#E6B8B7'});
	
	jqGridObj.jqGrid('setLabel','list_no', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','sub_no', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','sub_title', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','initials', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','issue_date', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','com_no', '', {'background':'#D8E4BC'});
	
	jqGridObj.jqGrid('setLabel','builders_reply', '', {'background':'#CCC0DA'});
	jqGridObj.jqGrid('setLabel','builder_user_name', '', {'background':'#CCC0DA'});
	jqGridObj.jqGrid('setLabel','builder_date', '', {'background':'#CCC0DA'});
	jqGridObj.jqGrid('setLabel','sub_att', '', {'background':'#CCC0DA'});
	jqGridObj.jqGrid('setLabel','ref_no', '', {'background':'#CCC0DA'});
	jqGridObj.jqGrid('setLabel','status', '', {'background':'#CCC0DA'});
	
	jqGridObj.jqGrid('setLabel','confirm_user_name', '', {'background':'#FCD5B4'});
	jqGridObj.jqGrid('setLabel','confirm_date', '', {'background':'#FCD5B4'});
	
	
	/* var newWidth = $("#jqGridList_list_no").width() + $("#jqGridList_sub_no").outerWidth(true);
	jqGridObj.jqGrid("setLabel", "list_no", "Sub No.", "", {
	        style: "width: " + newWidth + "px; background : #D8E4BC;",
	        colspan: "2"
	});
	jqGridObj.jqGrid('setLabel','sub_no', '', '', {style: "display : none"}); */
	
	//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
	$("#btnSearch").click(function(){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		if(uniqeValidation()){
			fn_search();
		}
	});
	
	//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
	$("#btnAdd").click(function(){
		
		var date = new Date();
	    
        var year  = date.getFullYear();
        var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
        var day   = date.getDate();
     
        if (("" + month).length == 1) { month = "0" + month; }
        if (("" + day).length   == 1) { day   = "0" + day;   }
		
        var today = year + "-" + month + "-" + day;
		
		jqGridObj.saveCell(kRow, idCol );
		
        var ids = jqGridObj.jqGrid('getDataIDs');
        //get first id
        var cl = ids[ids.length-1];
        var rowData = jqGridObj.getRowData(cl);
        
		var item = {};
		var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
		
		for ( var i in colModel ) {
			item[colModel[i].name] = '';
		}
		
		item.builder_user_id = "${loginUser.user_id}";
		item.builder_user_name = "${loginUser.user_name}";
		item.builder_date = today;
		item.oper = 'I';
		item.action = 'NEW';
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');

		if(ids.length == 0) {
			item.list_no = '1';
			item.sub_no = '0';	
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
			
			item.list_no = '1';
			item.sub_no = '1';
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
			
		} else if(selarrrow.length == 1) {
			
			var id = parseInt(jqGridObj.jqGrid('getGridParam','selrow') ) +1;
			var selTmp = jqGridObj.jqGrid('getGridParam','selrow');
			
			var item1 = jqGridObj.jqGrid("getRowData", selTmp);
			
			if( item1.add_enable_flag != 'Y') {
				
				if(item1.status == 'C' || item1.status == 'A') {
					alert("COMMENT가 CLOSE 되었습니다.");
					return false;
				} else {
					alert("상위 COMMENT가 진행중입니다.");
					return false;
				}
				
			}
			
			var data = [];
			for (var i = 0; i < ids.length; i++) 
			{
			    var rowId = ids[i];
			    var rowData1 = jqGridObj.jqGrid ('getRowData', rowId);
			    if(rowData1.list_no == item1.list_no) {
			    	data.push(rowData1.sub_no);
			    }
			}
			var maxSubNo = Math.max.apply(null, data);
			
			item.list_no = item1.list_no;
			item.sub_no = maxSubNo + 1;
			

			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'after', id-1 );
			
		} else if(selarrrow.length > 1) {
			alert("2EA 이상 선택 되었습니다. 1EA만 선택 바랍니다.");
			return false;
		} else {
			item.list_no = parseInt(rowData['list_no']) +1;
			item.sub_no = '0';
			
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last');
			
			item.sub_no = '1';
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last');
			
		}
		
		jqGridObj.saveCell(kRow, idCol );
		var rows = jqGridObj.getDataIDs();
		for ( var i = 0; i < rows.length; i++ ) {
			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
			if(item.sub_no == '0') {
				jqGridObj.setCell(rows[i], 'receipt_no', '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
				jqGridObj.setCell(rows[i], 'ref_no', '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
			}
		}
		
	});
	
	// DELETE 버튼 클릭 시
	$("#btnDel").click(function() {
		jqGridObj.saveCell(kRow, idCol );
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		var ids = $( "#jqGridList" ).getDataIDs();
		
		for(var i=selarrrow.length-1; i>=0; i--) {
			
			var item = jqGridObj.jqGrid("getRowData", selarrrow[i]);
			
			if( item.oper == 'I' ) {
				if(item.sub_no == "0" || item.sub_no == "1"){
					for(var j=0; j<ids.length; j++){
						var item2 = jqGridObj.jqGrid( 'getRowData', ids[j]);
						if(item.list_no == item2.list_no){
						      jqGridObj.jqGrid('delRowData',ids[j]);
						}
					}
				}
			} else {
				//삭제 하면 안되는 조건
				if(item.delete_enable_flag == 'Y') {
					jqGridObj.setCell (selarrrow[i], 'oper','D', '');
					jqGridObj.setRowData(selarrrow[i], false, {background: '#FF0000'});
					
					if(item.sub_no == "0" || item.sub_no == "1") {
						
						for(var j=0; j<ids.length; j++){
							var item2 = jqGridObj.jqGrid( 'getRowData', ids[j]);
							if(item.list_no == item2.list_no){
								jqGridObj.setCell (selarrrow[i], 'oper','D', '');
								jqGridObj.setRowData(selarrrow[i], false, {background: '#FF0000'});
							}
						}
						
					}
				}
			}
			
		}
		
		fn_buttonEnable2(["#btnSave"]);
		
	});
	
	// SAVE 버튼 클릭 시
	$("#btnSave").click(function() {
		jqGridObj.saveCell(kRow, idCol );

		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		if(confirm("Save 하시겠습니까?")){
			
			var rtn = true;
			var changeResultRows =  getChangedGridInfo("#jqGridList");
			
			for(i=0; i < changeResultRows.length; i++) {
				
				if(changeResultRows[i].sub_no != '0' ) {
					if(changeResultRows[i].receipt_no == ""){
						alert("수신NO는 필수 입니다.");
						rtn = false;
						return false;
					}
				}
				
				if(changeResultRows[i].sub_title == ""){
					
					if(changeResultRows[i].sub_no == '0') {
						alert("BUYER'S COMMENT TITLE은 필수 입니다.");
						rtn = false;
						return false;
					} else {
						alert("BUYER'S COMMENT는 필수 입니다.");
						rtn = false;
						return false;
					}
					
					
				}
				
			}
			if(!rtn){
				return false;
			} 
			
			var url			= "commentMainSaveAction.do";
			var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({},dataList,formData);
			
			lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
			
			$.post(url, parameters, function(data)
			{	
				var msg = '';
				var result = '';

				for ( var key in data) {
					if (key == 'resultMsg') {
						msg = data[key];
					}
					if (key == 'result') {
						result = data[key];
					}
				}
				
				alert(msg);
				
			},"json").error(function() {
				alert('시스템 오류입니다.\n전산담당자에게 문의해주세요.');
			}).always(function() {
				lodingBox.remove();
				fn_search();
			});

		}
	});
	
	// 승인요청 버튼 클릭 시 
	$("#btnConfirm").click(function(){
		
		var formData = fn_getFormData('#application_form');
		var rows = jqGridObj.getDataIDs();
		var rnt = true;
		
		for ( var i = 0; i < rows.length; i++ ) {
			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
			
			
			
			if(item.oper != '') {
				alert("진행중인 작업이 있습니다.\nSAVE 후 승인요청 하세요.");
				rnt = false;
				return false;
			}
			
			if(item.sub_no != '0') {	
				
				if(item.builder_user_name == '') {
					alert("BUILDER 필수 입니다.");
					rtn = false;
					return false;
				}
				
				if(item.status == 'O') {
					
					if(item.builders_reply == "") {
						alert("BUILDER\'S REPLY 필수 입니다.");
						rtn = false;
						return false;
					}
					
					if(item.ref_no == "") {
						alert("Ref No. 필수 입니다.");
						rtn = false;
						return false;
					}
					 
				}
				
				if(item.status == 'N') {
					if(item.builders_reply == "") {
						alert("BUILDER\'S REPLY 필수 입니다.");
						rtn = false;
						return false;
					}
				}
			}
			
			
		}
		
		if(!rnt) {
			return false;
		}
		
		//승인 로직
		if(confirm('승인요청 하시겠습니까?')){
			
			$.post("commentReqeustApplyAction.do", formData, function(data) {
				alert(data.resultMsg);
			},"json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			}).always( function() {
				fn_search();
			});
			
		}
		//}
		
	});
	
	// Excel 버튼 클릭 시 
	$("#btnPcf").click(function(){
		
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		form = $('#application_form');

		//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
		form.attr("action", "commentPCFExcelExport.do");
		form.attr("target", "_self");
		form.attr("method", "post");
		form.submit();
	});
	
	//Excel Form 클릭 다운로드	
	/* $("#btnForm").click(function(){
		$.download('fileDownload.do?fileName=commentImportForm.xls', null, 'post');
	}); */
	
	//Excel Import 클릭
	$("#btnForm").click(function(){
		
		/* var ids = jqGridObj.getDataIDs();
		if(ids.length > 0) {
			alert("진행중인 COMMENT가 존재합니다.");
			return false;
		}	 */	

		var sURL = "popUpCommentExcel.do?p_project_no=" + $("#p_project_no").val() + "&p_dwg_no=" + $("#p_dwg_no").val() + "&p_issuer=" + $("#p_issuer").find("option:selected").val();
		var popOptions = "dialogWidth:1000px; dialogHeight: 800px; center: yes; resizable: no; status: no; scroll: no;"; 
		window.showModalDialog(sURL, window, popOptions);

		jqGridObj.saveCell(kRow, idCol );
		
	});
	
	//Excel Import 클릭
	$("#btnReplyForm").click(function(){
		
		var sURL = "popUpCommentReplyExcel.do?p_project_no=" + $("#p_project_no").val() + "&p_dwg_no=" + $("#p_dwg_no").val() + "&p_issuer=" + $("#p_issuer").find("option:selected").val();
		var popOptions = "dialogWidth:1000px; dialogHeight: 800px; center: yes; resizable: no; status: no; scroll: no;"; 
		window.showModalDialog(sURL, window, popOptions);

		jqGridObj.saveCell(kRow, idCol );
		
	});
	
	$("#btnTranslate").click(function(){
		/* form = $('#application_form');

		//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
		form.attr("action", "http://translate.naver.com/#/en/ko");
		form.attr("target", "_blank");	
		form.attr("method", "post");	
		form.submit(); */
		
		// 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음
		var popupX = (window.screen.width / 2) - (1000 / 2);
		// 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음
		var popupY= (window.screen.height /2) - (800 / 2);

		window.open('http://translate.naver.com/#/en/ko', '', ',location=yes, resizable=yes, scrollbars=yes, status=yes, height=800, width=1000, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		
	});
	
});

//필수 항목 Validation
var uniqeValidation = function(){
	var rnt = true;
	$(".required").each(function(){
		if($(this).val() == ""){
			$(this).focus();
			alert($(this).attr("alt")+ "가 누락되었습니다.");
			rnt = false;
			return false;
		}
	});
	return rnt;
}

//검색
function fn_search() {
	
	//모두 대문자로 변환
	$("input[type=text]").each(function(){
		$(this).val($(this).val().toUpperCase());
	});
	
	//검색 시 스크롤 깨짐현상 해결
	jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
	
	var sUrl = "commentList.do";
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
	
	if( $("#p_project_no").val() != '' && $("#p_dwg_no").val() != '') {
		fn_buttonEnable2(["#btnAdd", "#btnPcf", "#btnForm", "#btnReplyForm"]);
		//fn_buttonEnable2(["#btnAdd", "#btnPcf"]);
		fn_buttonDisabled2([ "#btnSave" ]);
	}
}

//그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	return changedData;
}


//afterSaveCell oper 값 지정
function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
	
	var item = jqGridObj.jqGrid( 'getRowData', irow );
	if (item.oper != 'I') {
		item.oper = 'U';
	} 
	
	fn_buttonEnable2(["#btnSave"]);

	jqGridObj.jqGrid( "setRowData", irow, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
	
	//입력 후 대문자로 변환
	//jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
}

function issuerChagne(obj) {
	
	if(obj == 'O') {
		jqGridObj.jqGrid('setLabel','sub_title', 'Buyer\'s Comment', {'background':'#D8E4BC'});
		jqGridObj.jqGrid('setLabel','status', 'Buyer Status', {'background':'#CCC0DA'});
	} else {
		jqGridObj.jqGrid('setLabel','sub_title', 'Class\'s Comment', {'background':'#D8E4BC'});
		jqGridObj.jqGrid('setLabel','status', 'Class Status', {'background':'#CCC0DA'});
	}
	
	$("#btnSearch").click();
}

</script>
</html>