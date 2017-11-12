<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC Management</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	input[type=text] {text-transform: uppercase;}
	.ui-jqgrid .ui-jqgrid-htable th div {height:30px;} 
</style>

</head>

<body>
<form name="application_form" id="application_form" action="insertFileUpLoadAction.do" method="POST" enctype="multipart/form-data">
<div id="mainDiv" class="mainDiv">
                                      
	<input type="hidden" id="catalog_group_id" name="catalog_group_id" />
	<input type="hidden" id="reqDept" name="reqDept" value="${loginUser.insa_dept_code}"/>
	<input type="hidden" id="seq_id" name="seq_id" />
	
	<div class= "subtitle">
	부품표준서 업로드
	<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>

	<table class="searchArea conSearch" >
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="130">
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="130">
		
		<tr>
			<td>파일 정보</td>
			<td colspan="7">
				<input type="file" style="width:500px" id="uploadFile" name="uploadFile" accept=".pdf" />
			</td>
		</tr>
		<!-- <tr>
			<td>Catalog 기준</td>
			<td colspan="7">
				<input type="checkbox" id="fileNmChk" name="fileNmChk" value=""/>파일명 기준으로 전송
			</td>
		</tr> -->
		<tr>
			<td>Catalog</td>
			<td>
				<!-- <select name="catalog" id="catalog" style="width: 80px;" >		
				</select> -->
				<input type="text" id="catalog" name="catalog" style="width: 80px;" onkeydown="javascript:getCatalogs();"/>
			</td>
			<td>Name</td>
			<td colspan="3"><input type="text" id="catalogName" name="catalogName" style="width:400px;background:#EAEAEA;" readonly/></td>
			<td>Date</td>
			<td><input type="text"   id="catalogDate" name="catalogDate" class="datepicker h20Input" style="width: 80px;"/></td>
		</tr>
		<tr>
			<td>Rev No.</td>
			<td><input type="text" id="revNo" name="revNo" style="background:#EAEAEA;" readonly/></td>
			<td>요청자</td>
			<td>
				<!-- <select name="reqName" id="reqName">		
				</select> 
				<input type="text" id="reqInfo" name="reqInfo" value="${loginUser.user_name}:${loginUser.user_id}" style="width:200px;" onkeyup="javascript:getReqInfo(event);" />
				<input type="hidden" id="reqName" name="reqName" value="${loginUser.user_id}" /> -->
				<input type="text" class="only_eco" id="reqName" name="reqName" value="${loginUser.user_id}" maxlength="20" style="width: 50px;" onkeyup="fn_clear0();" />
				<input type="text" class="notdisabled only_eco" id="reqNameDes" name="reqNameDes" value="${loginUser.user_name}" readonly="readonly" style="width: 50px; margin-left: -5px;" />
				<input type="button" class="only_eco btn_gray2" id="btnEmpNo0" name="btnEmpNo0" value="검색" />
			</td>
			<td>요청자사번</td>
			<td><input type="text" id="reqId" name="reqId" value="${loginUser.user_id}" style="background:#EAEAEA;" readonly/></td>
			<td>요청부서</td>
			<td><input type="text" id="reqDeptNm" name="reqDeptNm" value="${loginUser.insa_dept_name}" style="background:#EAEAEA;width:150px;" readonly/>	</td>
		</tr>
		<tr>
			<td colspan="8">
				<div class="button endbox">
					<input type="button" class="btn_blue" id="btnSubmit" value="전송" onclick="uploadAction()"/>
					<!-- <input type="button" class="btn_blue" id="btnClose" value="종료" onclick="close()"/> -->
				</div>
			</td>
		</tr>
	</table>
	<br><br>
	<table class="searchArea conSearch">
		<col width="60">
		<col width="80">
		<col width="60">
		<col width="80">
		<col width="60">
		<col width="40">
		<col width="60">
		<col width="200">
		<col width="80">
		<tr>
			<th>Catalog</th>
			<td>
				<!-- <select name="catalog1" id="catalog1" style="width: 80px;">		
				</select> -->
				<input type="text" id="catalog1" name="catalog1" style="width: 80px;" onkeydown="javascript:getCatalogs1();"/>
			</td>
			<th>Name</th>
			<td>
				<input type="text" id="catalogDesc" name="catalogDesc" />
			</td>
			<th>REV</th>
			<td>
				<input type="text" id="revNo1" name="revNo1" style="width: 40px;" />
			</td>
			<th>요청자</th>
			<td>
				<!--<select name="reqName1" id="reqName1" style="width: 230px;">		
				</select>
				<input type="text" id="reqNameDesc" name="reqNameDesc" style="width: 100px;" />-->
				<input type="text" class="only_eco" id="reqName1" name="reqName1" maxlength="20" style="width: 50px;" onkeyup="fn_clear();" />
				<input type="text" class="notdisabled only_eco" id="reqNameDesc" name="reqNameDesc" readonly="readonly" style="width: 50px; margin-left: -5px;" />
				<input type="button" class="only_eco btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />
			</td>
			<td rowspan="2">
				<div class="button">
					<input type="button" id="btnSearch" name="" class="btn_blue" value="조회" />
					<input type="button" value="저장" id="btnSave" class="btn_blue" />
				</div>
			</td>
		</tr>
		<tr>
			<th>구분</th>
			<td>
				<input type="radio" value="A" id="btnUseOn" name="btnUse" checked />전체
				<input type="radio" value="N" id="btnUseOff" name="btnUse"  />미확정
			</td>			
			<th>요청일</th>
			<td colspan="3">
				<input type="text" id="reqFromDate" name="reqFromDate" class="datepicker h20Input" style="width: 80px;"/>
				~
				<input type="text" id="reqToDate" name="reqToDate" class="datepicker h20Input" style="width: 80px;"/>
			</td>
			<th>요청부서</th>
			<td>
				<!--<select name="reqDeptCmb" id="reqDeptCmb" style="width: 230px;">		
				</select>
				<input type="text" id="reqDeptDesc" name="reqDeptDesc" style="width: 100px;" />-->
				<input type="text" class="only_eco" id="reqDeptCd" name="reqDeptCd" maxlength="15" style="width: 50px;" onkeyup="fn_clear2();" />
				<input type="text" class="notdisabled only_eco" id="reqDeptDesc" name="reqDeptDesc" readonly="readonly" style="width: 80px; margin-left: -5px;" />
				<input type="button" class="only_eco btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색" />
			</td>
		</tr>
		</table>
		<div class="content">
			<table id="jqGridMainList"></table>
			<div id="jqGridMainListNavi"></div>
		</div>
	<div id="result"></div>
</div>
</form>	

<script>
$(document).ready(function(){
	/* history.pushState({"html":""},"",""); */
	$("#jqGridMainList").jqGrid({
		url: '',
		treedatatype: "json",
		mtype: "",
		postData : fn_getFormData("#application_form"),
		colNames : [ '', 'Catalog', 'Name','요청일', 'REV','요청부서','요청자','확정유무','','확정<br><input type="checkbox" id="itemChkHeader" onclick="itemCheckBoxHeader(event)"/>','','','','',''],
		colModel : [ 
					 { name : 'item_catalog_group_id', index : 'item_catalog_group_id', width : 25 , align : 'center', hidden:true},
					 { name : 'catalog_code'         , index : 'catalog_code'         , width : 50 , align : "center" },
		             { name : 'catalog_desc'         , index : 'catalog_desc'         , width : 200, align : "left" },
		             { name : 'req_date'             , index : 'req_date'             , width : 80 , align : "center"},
		             { name : 'rev_no'               , index : 'rev_no'               , width : 30 , align : "right" }, 
		             { name : 'req_dept_name'        , index : 'req_dept_name'        , width : 150, align : "left" },		             
		             { name : 'req_user_name'        , index : 'req_user_name'        , width : 60 , align : "center" },
		             { name : 'confirm_desc'         , index : 'confirm_desc'         , width : 40 , align : "center" },
		             { name : 'confirm_flag'         , index : 'confirm_flag'         , width : 30 , align : "center", hidden:true},
		             { name : 'confirm_flag_check'   , index : 'confirm_flag_check'   , width : 30 , align : "center", formatter : formatOptItem },
		             { name : 'confirm_flag_changed' , index : 'confirm_flag_changed' , width : 30 , align : "center", hidden:true},
		             { name : 'req_emp_no'           , index : 'req_emp_no'           , width : 25 , align : 'center', hidden:true},
		             { name : 'req_dept_no'          , index : 'req_dept_no'          , width : 25 , align : 'center', hidden:true},
		             { name : 'part_seq_id'          , index : 'part_seq_id'          , width : 25 , align : 'center', hidden:true},
		             { name : 'oper'                 , index : 'oper'                 , width : 80 , align : "center", hidden:true}
		           ],
		         rowNum : 100,
				 cmTemplate: { title: false },
				 rowList : [ 100, 500, 1000 ],
				 autowidth : true,
				 rownumbers : true,
				 pager : $( '#jqGridMainListNavi' ),
				 toolbar : [ false, "bottom" ],
				 viewrecords : true,
				 width		: $(window).width()  * 0.40,
				 height : $(window).height()-450,
		         hidegrid : false,

	    jsonReader : {
			root : "rows",
			page : "page",
			total : "total",
			records : "records",
			repeatitems : false,
		},
        gridComplete : function() {

		},
		onCellSelect : function( rowid, iCol, cellcontent, e ) {
			
		}
	});
	
	fn_gridresize( $(window), $("#jqGridMainList"), 220);
	
	// 오늘날짜 설정
	fn_addDate("catalogDate", "chk_create_date", "0" );
	
	// 달력 초기화 설정 
    $("#catalogDate").datepicker({
		dateFormat		: 'yy-mm-dd',
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNamesMin	: ['일','월','화','수','목','금','토'],
	
		changeMonth		  : true, //월변경가능
	    changeYear		  : true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
    });

    $("#reqFromDate").datepicker({
		dateFormat		: 'yy-mm-dd',
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNamesMin	: ['일','월','화','수','목','금','토'],
	
		changeMonth		  : true, //월변경가능
	    changeYear		  : true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
    });

    $("#reqToDate").datepicker({
		dateFormat		: 'yy-mm-dd',
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNamesMin	: ['일','월','화','수','목','금','토'],
	
		changeMonth		  : true, //월변경가능
	    changeYear		  : true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
    });
	
	//getAjaxHtml($("#reqName"),"uscSelectBoxDataList.do?sb_type=&p_query=selectRequestList&reqName="+$("input[name=reqId]").val(), null, null);
	
	$("#uploadFile").change(function(){
	    var fileValue = $(this).val().split("\\");
	    var fileName = fileValue[fileValue.length-1];
	    var fileNm = fileName.split(".");
	    var splitNm = fileNm[0].split("-");
	   
	    var reg = /([0-9]|[A-Z]){5}/;
	    var rst = reg.test(fileNm[0]);
	    
	    if(!rst || !(fileNm[1] == 'pdf' || fileNm[1] == 'PDF')) {
	    //if(!rst) {
	    	alert("올바른 파일을 첨부하여 주십시오.");
			return;
	    } else {
	    	//$("#catalog").val(splitNm[0]);
	    	$("#catalog").val(fileNm[0].substring(0,5));
	    	$("#revNo").val(Number(splitNm[1]));
	    	SearchCallback();
	    }
	    
	});
	
	$("#fileNmChk").change(function(){
	   if($("#fileNmChk").is(":checked")) {
		   $("#catalog").prop("disabled", true);
	   } else {
		   $("#catalog").prop("disabled", false);
	   }
	});
	
	//사번 조회 팝업... 버튼
	$( "#btnEmpNo0" ).click( function() {
		if($('#catalog').val() == '' || $('#catalog').val() == undefined){
			alert("Catalog를 먼저 입력하십시오.");
			$('#catalog').focus();
			return;
		}
	
		var rs = window.showModalDialog( "popUpItemStandardUploadUser.do?flag=Y",
				"",
				"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
		
		if( rs != null ) {
			$( "#reqName" ).val(rs[0]);
			$( "#reqNameDes" ).val( rs[1] );
			SearchCallback1();
		}
	} );
	
	//사번 조회 팝업... 버튼
	$( "#btnEmpNo" ).click( function() {
		var rs = window.showModalDialog( "popUpItemStandardUploadUser.do",
				"",
				"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
		
		if( rs != null ) {
			$( "#reqName1" ).val(rs[0]);
			$( "#reqNameDesc" ).val( rs[1] );
			//$( "#user_group" ).val( rs[2] );
			//$( "#user_group_name" ).val( rs[3] );
		}
	} );

	//부서조회 팝업... 버튼
	$( "#btnGroupNo" ).click( function() {
		var rs = window.showModalDialog( "popUpItemStandardUploadDept.do",
				"",
				"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );

		if( rs != null ) {
			$( "#reqDeptCd" ).val( rs[0] );
			$( "#reqDeptDesc" ).val( rs[1] );
		}
	} );
	// 조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	});
	// 저장 버튼
	$('#btnSave').click(function() {
		fn_save();
	});	
	
	getAjaxTextPost(null, "selectCatalogList.do?catalog=", null, getCatalogCallback);
	getAjaxTextPost(null, "selectCatalogList.do?catalog=", null, getCatalogCallback1);

});

var getCatalogs = function(){	

	//모두 대문자로 변환
	$("input[type=text]").each(function(){
		$(this).val($(this).val().toUpperCase());
	});
	if($("#catalog").val().length > 0 && $("#catalog").val().length < 5) {
		getAjaxTextPost(null, "selectCatalogList.do?catalog="+$("#catalog").val(), null, getCatalogCallback);
	}
}
//카탈로그 받아온 후
var getCatalogCallback = function(txt){
	var arr_txt = txt.split("|");
    $("#catalog").autocomplete({
		source: arr_txt,
		minLength:1,
		matchContains: true, 
		max: 30,
		autoFocus: true,
		selectFirst: true,
		select: function(event, ui){
			$("#catalog").val(ui.item.value);
			SearchCallback();
		},
		open: function () {
			$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
		},
		close: function () {
		    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
	    }
	});
}

var getCatalogs1 = function(){	
	//모두 대문자로 변환
	$("input[type=text]").each(function(){
		$(this).val($(this).val().toUpperCase());
	});
	if($("#catalog1").val().length > 0 && $("#catalog1").val().length < 5) {
		getAjaxTextPost(null, "selectCatalogList.do?catalog="+$("#catalog1").val(), null, getCatalogCallback1);
	}
}
//도면번호 받아온 후
var getCatalogCallback1 = function(txt){
	var arr_txt = txt.split("|");
    $("#catalog1").autocomplete({
		source: arr_txt,
		minLength:1,
		matchContains: true, 
		max: 30,
		autoFocus: true,
		selectFirst: true,
		select: function(event, ui){
			$("#catalog1").val(ui.item.value);
		},
		open: function () {
			$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
		},
		close: function () {
		    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
	    }
	});
}

var SearchCallback = function(){
	
	if(!$('#catalog').val() ==''){
		$.post("selectCatalogName.do", fn_getFormData("#application_form"), function(data) {
			$("#catalogName").val(data.catalog_name);
			$("#catalog_group_id").val(data.item_catalog_group_id);

			if(!$('#catalog_group_id').val() ==''){
				$.post("selectCatalogRevNo.do", fn_getFormData("#application_form"), function(data) {
					$("#revNo").val(data.part_rev_no);
				}, "json").error(function() {
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				});
			}
		}, "json").error(function() {
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		});
	}
}

var SearchCallback1 = function(){
	if(!$('#catalog').val() ==''){
		$.post("selectRequestInfo.do", fn_getFormData("#application_form"), function(data) {
			$("#reqId").val(data.emp_no);
			$("#reqDept").val(data.dept_code);
			$("#reqDeptNm").val(data.dept_name);
		}, "json").error(function() {
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		});
	}
}

function uploadAction() {
	var mainForm = document.application_form;

    if (mainForm.revNo.value == "") {
        alert("Rev No.는 필수입니다.");
        return;
    }
	
	var fileName = mainForm.uploadFile.value;
	if(fileName == "" || fileName==null) {
		alert("첨부문서가 없습니다.");
		return;
	}
	
	var fileValue = mainForm.uploadFile.value.split("\\");
    var fileName = fileValue[fileValue.length-1];
    var fileNm = fileName.split(".");
    var file1 = fileNm[0];
    var file2 = fileNm[1];
    var reg = /([0-9]|[A-Z]){5}/;
    var rst = reg.test(file1);
    if(!rst || !(fileNm[1] == 'pdf' || fileNm[1] == 'PDF')) {
    //if(!rst) {
    	alert("올바른 파일을 첨부하여 주십시오.");
		return;
    }
	
	$.post("selectSeqId.do", fn_getFormData("#application_form"), function(data) {
		$("#seq_id").val(data.part_seq_id);
		fn_upload();
	}, "json").error(function(e) {
		fn_upload();	
		//alert(JSON.stringify(e));
		//alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	});    
	
	
}

function fn_upload() {
	var mainForm = document.application_form;
	
	if(confirm("업로드 하시겠습니까?"))
    {
		$('#application_form').ajaxForm( {
			// 반환할 데이터의 타입. 'json'으로 하면 IE 에서만 제대로 동작하고 크롬, FF에서는 응답을 수신하지
			// 못하는 문제점을 발견하였다. dataType을 정의하지 않을 경우 기본 값은 null 이다.
			dataType : 'text',
			beforeSerialize : function() {
				// form을 직렬화하기전 엘레먼트의 속성을 수정할 수도 있다.
			},
			beforeSubmit : function() {
				$('#result').html('uploading...');
			},
			success : function( data ) {
				data.replace(/(<([^>]+)>)/ig,"");
				var jData = JSON.parse(data);
				alert(jData.resultMsg);
				document.location.reload();
				$('#result').html('');
			}
		} );
		$('#application_form').submit();
    }
}

function fn_search(){
	$("#jqGridMainList").clearGridData(true);
	var sUrl = "itemStandardUpload.do";
	jQuery("#jqGridMainList").jqGrid('setGridParam', {
		url : sUrl,
		mtype : 'POST',
		page : 1,
		datatype : "json",
		postData : getFormData("#application_form")
	}).trigger("reloadGrid");	
}

function fn_save() {
	
	var fromList = $( "#jqGridMainList" ).getDataIDs();
	//변경된 체크 박스가 있는지 체크한다.
	for( var i = 0; i < fromList.length; i++ ) {
		var item = $( '#jqGridMainList' ).jqGrid( 'getRowData', fromList[i] );
		if( item.confirm_flag_changed != item.confirm_flag ) {
			item.oper = 'U';
		} else {
			item.oper = '';
		}
		
		$('#jqGridMainList').jqGrid( "setRowData", fromList[i], item );
	}

	var changedData1 = $.grep($("#jqGridMainList").jqGrid('getRowData'), function(obj) {
		return obj.oper == 'U';
	});

	if(changedData1.length ==0) {
		alert("변경된 내용이 없습니다.");
		return;
	}
	
	if (confirm('저장 하시겠습니까?') == 0) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {
		classOveride : 'blue-loader',
		bgColor : '#000',
		opacity : '0.3'
	});
	//var changedData = $.merge(changedData1);
	var dataList = {
			chmResultList : JSON.stringify(changedData1)
		};
	var formData = getFormData('#application_form');

	var parameters = $.extend({}, dataList, formData );
	//시리즈 배열 받음
	var ar_series = new Array();
	for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
		ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
	}

	var url = "saveItemStandardUpload.do?p_chk_series="+ar_series;
	
	$.post(url,
			parameters,
			function(data) {
					alert(data.resultMsg);
					if ( data.result == 'success' ) {
						fn_search();
					}

			}).fail(function() {
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	}).always(function() {
		lodingBox.remove();
	});
}

function formatOptItem(cellvalue, options, rowObject){
	var rowid = options.rowId;

	if(rowObject.confirm_flag == "Y") {
		return "<input type='checkbox' id='item"+rowid+"_confirm_flag' checked onclick='chkClickItem(" + rowid + ")'/>";	
	} else {
		return "<input type='checkbox' id='item"+rowid+"_confirm_flag' onclick='chkClickItem(" + rowid + ")'/>";	
	}	

}

function chkClickItem( rowid ) {
	if( ( $( "#item" + rowid + "_confirm_flag" ).is( ":checked" ) ) ) {
		$("#jqGridMainList").setRowData( rowid, { confirm_flag : "Y" } );
	} else {
		$("#jqGridMainList").setRowData( rowid, { confirm_flag : "N" } );
	}
}

//header checkbox action 
function itemCheckBoxHeader(e) {
	e = e || event;/* get IE event ( not passed ) */
	e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if (($("#itemChkHeader").is(":checked"))) {
		var rows = $( "#jqGridMainList" ).getDataIDs();
		for ( var i = 0; i < rows.length; i++ ) {
			var item = $( '#jqGridMainList' ).jqGrid( 'getRowData', rows[i] );
			item.confirm_flag = 'Y';
			$( '#grdFromList' ).jqGrid( "setRowData",rows[i], item );
			$( "#item" + rows[i] + "_confirm_flag" ).prop("checked", true);
		}
		
	} else {
		var rows = $( "#jqGridMainList" ).getDataIDs();
		for ( var i = 0; i < rows.length; i++ ) {
			var item = $( '#jqGridMainList' ).jqGrid( 'getRowData', rows[i] );			
			item.confirm_flag = 'N';
			$( '#jqGridMainList' ).jqGrid( "setRowData",rows[i], item );
			$( "#item" + rows[i] + "_confirm_flag" ).prop("checked", false);			
		}
	}
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

//요청자 조회조건 삭제 시 작성자명 초기화
function fn_clear0() {
	if( $( "#reqName" ).val() == "" ) {
		$( "#reqNameDes" ).val( "" );
	}
}

function fn_clear() {
	if( $( "#reqName1" ).val() == "" ) {
		$( "#reqNameDesc" ).val( "" );
	}
}

//부서 조회조건 삭제 시 부서명 초기화
function fn_clear2() {
	if( $( "#reqDeptCd" ).val() == "" ) {
		$( "#reqDeptDesc" ).val( "" );
	}
}

var getReqInfo = function(event){
	if($("input[name=reqInfo]").val() != ""){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		
		//if(!(event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40)) {		
			getAjaxTextPost(null, "uscSelectBoxDataList.do?p_query=selectRequestList", form.serialize(), getReqInfoCallback);
		//}		
		
	}
}
//도면번호 받아온 후
var getReqInfoCallback = function(txt){
	var arr_txt = decodeURIComponent(txt).split("|");
	
    $("#reqInfo").autocomplete({
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
	    },
	    focus : function(event, ui) {
	    	return false;
	    },
	    select : function(event, ui) {
	    	var x = ui.item.value.split(":");
			var y = x[1];
			$("#reqName").val(y);

			SearchCallback1();
	    }
    });
}

</script>
</body>
</html>