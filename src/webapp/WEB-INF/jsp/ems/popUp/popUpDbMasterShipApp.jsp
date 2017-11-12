<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>EMS 적용 호선 선택</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">

<input type="hidden" name="p_daoName"   id="p_daoName" value=/>
<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
<input type="hidden" name="p_process"   id="p_process" value=""/>
<input type="hidden" name="p_filename"  id="p_filename" value=""/>
<input type="hidden" name="list_type"   id="list_type" />
<input type="hidden" name="list_type_desc"   id="list_type_desc" />
<input type="hidden" name="userId" id="userId"  value="<c:out value="${UserName}" />" />
<input type="hidden" name="p_itemCodes" id="p_itemCodes"  value="${p_itemCodes}" />
<input type="hidden" name="p_itemCodeFirst" id="p_itemCodeFirst"  value="${p_itemCodeFirst}" />
<input type="hidden" name="p_spec_seq" id="p_spec_seq" /> 
<input type="hidden" name="p_item_seq" id="p_item_seq" />
<input type="hidden" name="p_itemseq" id="p_itemseq" />
<input type="hidden" name="p_specseq" id="p_specseq" />
<input type="hidden" name="p_ship_kind"   id="p_ship_kind" />
<input type="hidden" name="p_ship_kind1"   id="p_ship_kind1" />
<div id="hiddenArea"></div>

<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="button">
		<input type="button" id="btnSave" value="저장" class="btn_blue"/>
		<input type="button" class="btn_blue" value="닫기" id="btnClose" />
	</div>
</div>
<div class="content">
	<table id="itemTransList"></table>
	<div id="btnitemTransList"></div>
</div>
		
</form>

<script type="text/javascript">
var item_code = $("#p_itemcode").val();

var row_selected;

var idRow = 0;
var idCol = 0;
var nRow = 0;
var kRow = 0;

$(document).ready(function() {
	
	var objectHeight = gridObjectHeight(1);
	
	//부모창에서 ship_category 가져와 p_ship_category 값 설정
	var openerObj = window.dialogArguments;
	
	$("#itemTransList").jqGrid({ 
        datatype: 'json', 
        mtype: 'post', 
        url : 'popUpEmsDbMasterShipAppList.do',	
        postData : fn_getFormData('#application_form'),
        colNames:['적용','선종','선형', 'use_yn_temp', 'oper'],
        colModel:[
        	{name:'use_yn'		, index:'use_yn'		,width:40	,align:'center', sortable:false, formatter:formatOpt1, sortable:false},
       		{name:'ship_type'	, index:'ship_type'		,width:150	,align:'center', sortable:false},
       		{name:'ship_size'	, index:'ship_size'		,width:152	,align:'left',   sortable:false},
       		{name:'use_yn_temp'	, index:'use_yn_temp'	,hidden:true },
       		{name:'oper'		, index:'oper'			,hidden:true }
        ],
        gridview: true,
        toolbar: [false, "bottom"],
        viewrecords: true,
        autowidth: true,
        height: objectHeight,
        pager: jQuery('#btnitemTransList'),
        rowNum:999999,
        pgbuttons : false,
		pgtext : false,
		pginput : false,
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
			$(this).jqGrid("clearGridData");
			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid"); 		
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
		 },
      
		 
	}); //end of jqGrid
	//jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#itemTransList" ), -90 );
	
	$("#btnitemTransList_left").css( "width", 0 );
   
	search();
});

//########  등록버튼 ########//
$("#btnSave").click(function(){
	$("#itemTransList").saveCell(idRow, idCol );
	
	var pos_no = document.getElementsByName("chkbox");				
	var ship_kind = "'";
	var ship_kind1 = "'";

	for(var i = 0; i < pos_no.length; i++) {
		if(pos_no[i].checked) {
			ship_kind = ship_kind + pos_no[i].value + "','";
		} else {
			ship_kind1 = ship_kind1 + pos_no[i].value + "','";
		}
	}
	
	ship_kind = ship_kind + "'";
	ship_kind1 = ship_kind1 + "'";
					
	$("input[name=p_process]").val("mod_shipApp");
	
	$("input[name=p_ship_kind]").val(ship_kind);
	$("input[name=p_ship_kind1]").val(ship_kind1);
	

	var url = "popUpEmsDbMasterShipAppSave.do?";

	if(confirm("저장하시겠습니까?")) {
		//필수 파라미터 E	
// 		$(".loadingBoxArea").show();
// 		$.post(sUrl,$("#application_form").serialize(),function(json)
// 		{
// 			afterDBTran(json);
// 			$(".loadingBoxArea").hide();
// 		},"json");
		var chmResultRows = $( "#MasterItemGrid" ).jqGrid( 'getRowData' )
		var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
		var formData = fn_getFormData( '#application_form' );
		var parameters = $.extend( {}, dataList, formData );

		var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
		
		$.post( url, parameters, function(json) {			
			alert(json.resultMsg);
			if ( json.result == 'success' ) {
				search();
			}
		}, "json").error( function() {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
			loadingBox.remove();
		} );
		
	}					
});	

//########  닫기버튼 ########//
$("#btnClose").click(function(){
	window.close();					
});

//######## 메시지 Call ########//

var afterDBTran = function(json){
	$(".loadingBoxArea").hide();
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
		opener.$("#btnSearch").click();					
		search();
	}
}

function search() {											
	$("#itemTransList").jqGrid("clearGridData");
	
	var sUrl = "popUpEmsDbMasterShipAppList.do";		
			
	jQuery("#itemTransList").jqGrid('setGridParam',{url	: sUrl
		,mtype    : 'POST' 
		,page		: 1
		,datatype	: 'json'
		,postData : fn_getFormData("#application_form")}).trigger("reloadGrid");
}

//######## Input text 부분 숫자만 입력 ########//
function onlyNumber(event) {
    var key = window.event ? event.keyCode : event.which;    

    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
    || key  == 8  || key  == 46 ) // del, back space
    ) {
        return true;
    }else {
        return false;
    }    
};

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
		
	var rowid = options.rowId;

	var ship_type = rowObject.ship_type;
	var ship_size = rowObject.ship_size;
	var use_yn = rowObject.use_yn;
	 
		var str ="<input type=\"checkbox\" name=\"chkbox\" id=\"check_"+rowid+"\" class=\"chkboxItem\" value=\""+ship_type+"_"+ship_size+"\"";
		if(use_yn == 'Y') {
			str+= " checked";
		}	   		
		str += "/>";
	         
	 	return str;
	 
}
</script>
</body>
</html>
