<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Registration Request</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	table {font-size:98%}
	.btn_common {width:50px; margin:2px; text-align:center}
</style>
<script type="text/javascript">
	var menuId = '';
	
	function emsDbMasterLink() {
		//메뉴ID를 가져오는 공통함수 
		getMenuId("emsDbMaster.do", callback_MenuId);
		
		location.href='emsDbMasterLink.do?etc=Y&menu_id='+menuId;
	}
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
</script>
</head>
<body>
<div id="mainDiv" class="mainDiv">
	<div class="subtitle">
		기준정보 등록요청
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
		
	</div>
	<form id="application_form">

	<input type="hidden" name="pageYn" id="pageYn" value="N">
	<input type="hidden" name="p_userId" id="p_userId" value="${loginUser.user_id}" />
	<input type="hidden" name="p_daoName"   id="p_daoName" value="TBC_ITEMTRANS"/>
	<input type="hidden" name="p_queryType" id="p_queryType"  value="select"/>
	<input type="hidden" name="p_process"   id="p_process" value="list"/>
	<input type="hidden" name="p_filename"  id="p_filename" value=""/>
	<input type="hidden" name="list_type"   id="list_type" />
	<input type="hidden" name="list_type_desc"   id="list_type_desc" />
	<input type="hidden" name="chk_create_date"  id="chk_create_date"  value=""/>
	<table class="searchArea conSearch">
		<tr>
			<td>
				<div class="button endbox">
					<input type="button" class="btn_blue" name="searchMode" value="부품표준서" onclick="location.href='itemStandardView.do'">
					<input type="button" class="btn_blue" name="searchMode" value="품목분류표" onclick="location.href='itemCategoryView.do'">
					<!-- menu_id=M00123 메뉴 ID 값 하드코딩 처리 2017-03-09 -->
					<input type="button" class="btn_blue" name="searchMode" value="기자재통합기준정보관리" onclick="javascript:emsDbMasterLink();">
<!-- 					<input type="button" class="btn_blue" name="searchMode" value="양식지&메뉴얼" onclick="location.href='documentView.do'"> -->
				</div>
			</td>
		</tr>
	</table>
	<table class="searchArea conSearch">
		<tr>
			<th width="60px">조회기간</th>
			<td width="190px">	<input type="text" class = "textBox" id="fromDate" name="fromDate" value = "" style="width: 80px;">
					~
					<input type="text" class = "textBox" id="ToDate" name="ToDate" value = "" style="width: 80px;"></td>
			<th width="50px">작성번호</th>
			<td width="70px"><input type="text" id="p_list_id" name="p_list_id" style="width: 50px;"></td>
			<th width="40px">유형</th>
			<td width="120px">	<select id="p_type" name="p_type" style="width: 100px;">
						<option value=''>ALL</option>
					</select></td>
			<th width="40px">TITLE</th>
			<td width="120px"><input type="text" id="p_request_title" name="p_request_title" style="width: 100px;"></td>
			<th width="40px">부서</th>
			<td width="120px"><input type="text" id="p_dept" name="p_dept" style="width: 100px;"></td>
			<th width="40px">상태</th>
			<td width="90px"><select id="p_state" name="p_state" style="width: 70px;">
						<option value=''>ALL</option>
					</select></td>
			<th width="50px">요청자</th>
			<td width="70px"><input type="text" id="p_requestor" name="p_requestor" style="width: 50px;"></td>
			<td>
				<div class="button">
					<input type="button" class="btn_blue" id="btnSearch" name="btnSearch" value="조회"  >
					<input type="button" class="btn_blue" id="btnWrite" name="btnWrite" value="글쓰기" >
					<input type="button" class="btn_blue" id="btnExcelExport" name="btnExcelExport" value="출력" />
				</div>
			</td>
		</tr>
	</table>
	<div id = "content"  class="content">
		<table id="itemTransList"></table>
		<div id="btnitemTransList"></div>
	</div>
	<%-- <jsp:include page="./tbc_CommonLoadingBox.jsp" flush="false"></jsp:include> --%>
	</form>
</div>
<script type="text/javascript">

var sUrl = 'standardInfoTransDbList.do';
var isHidden	= true;
var dt1, dt2;
var dtm;
var dtd;
var dt = new Date();
var dtb = new Date(Date.parse(dt) - 30 * 1000 * 60 * 60 * 24);

if(dtb.getMonth() + 1 < 10) {
	dtm = "0" + (dtb.getMonth() + 1);
} else {
	dtm = dtb.getMonth() + 1;
}
if(dtb.getDate() < 10) {
	dtd = "0" + (dtb.getDate());
} else {
	dtd = dtb.getDate();
}
dt1 = dtb.getFullYear() + "-" + dtm + "-" + dtd;

if(dt.getMonth() + 1 < 10) {
	dtm = "0" + (dt.getMonth() + 1);
} else {
	dtm = dt.getMonth() + 1;
}
if(dt.getDate() < 10) {
	dtd = "0" + (dt.getDate());
} else {
	dtd = dt.getDate();
}
dt2 = dt.getFullYear() + "-" + dtm + "-" + dtd;

$(document).ready(function(){
	
    //유형 콤보박스
    fn_set_type();
    //상태 콤보박스
    fn_set_state();
     
    //달력 일자 찍은뒤 그리드 그리기
    //fn_weekDate( "fromDate", "ToDate" );
    //fn_addDate("fromDate", "chk_create_date", "-30" );
    //fn_addDate("ToDate", "chk_create_date", "0" );
    $("#fromDate").val(dt1);
    $("#ToDate").val(dt2);

    fn_makeGrid();    

	$("*").keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			fn_search();
		}
	});
   
	fn_gridresize($(window) ,$("#itemTransList"));

	fn_search();

});  //end of ready Function
	//출력
	$("#btnExcelExport").click(function(){
		form = $('#application_form');
		$("#p_filename").val("ITEM_PROCESS");
		//필수 파라미터 S
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("mainListExport");				
				
		//필수 파라미터 E	
		form.attr("action", "standardInfoTransMainExcelPrint.do");
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	});
	
	//조회
	$("#btnSearch").click(function(){
		fn_search();		
	});
	
	//글쓰기 
	$("#btnWrite").click(function() {
		var rs = window.showModalDialog("standardInfoTransModifyView.do?p_process=modifyView&process_type=00", window, "dialogWidth:900px; dialogHeight:900px; center:on; scroll:off; status:off");
		if(rs == "OK"){
			fn_search();
		}
	});
	
	//유형  콤보박스 구성
	function fn_set_type() {
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectListType");
		$("#list_type").val("LIST_TYPE");
		$("#list_type_desc").val("LIST_TYPE");
		var formData = getFormData('#application_form');
		$.post( sUrl, formData, function( data ) {
			for( var i = 0; i < data.length; i++ ){
				$("#p_type").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
			}
		}, "json" );
	}
	//상태  콤보박스 구성
	function fn_set_state() {
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectListType");
		$("#list_type").val("PROCESS_TYPE");
		$("#list_type_desc").val("PROCESS_TYPE");
		var formData = getFormData('#application_form');
		$.post( sUrl, formData, function( data ) {
			for( var i = 0; i < data.length; i++ ){
				$("#p_state").append("<option value='"+data[i].sb_value+"'>"+data[i].sb_name+"</option>");
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
	
	$( function() {
		var dates = $( "#fromDate, #ToDate" ).datepicker( {
			prevText: '이전 달',
			nextText: '다음 달',
			monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			dayNames: ['일','월','화','수','목','금','토'],
			dayNamesShort: ['일','월','화','수','목','금','토'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			dateFormat: 'yy-mm-dd',
			showMonthAfterYear: true,
			yearSuffix: '년',
			onSelect: function( selectedDate ) {
				var option = this.id == "fromDate" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		} );
	} );
	
	
	function fn_search()
	{
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("list");
		
		jQuery("#itemTransList").jqGrid('setGridParam',{url:"standardInfoTransList.do"
														 ,datatype:'json'
														 ,mtype: 'POST'
														 ,page:1
														 ,postData: getFormData('#application_form')}).trigger("reloadGrid");  
	}
	
	function onlyUpperCase(obj) {
			obj.value = obj.value.toUpperCase();	
	}
	
	/* function fn_weekDate( date_start, date_end ) {
	
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("selectWeekList");
		
		var formData = getFormData('#application_form');
		$.post( sUrl, formData, function( data ) {
		  	$( "#" + date_start ).val( data[0].created_date_start );
		  	$( "#" + date_end ).val( data[0].created_date_end );
		  	fn_makeGrid();
		}, "json" );
	} */
	
	function fn_makeGrid(){
	
		$("input[name=p_daoName]").val("TBC_ITEMTRANS");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("list");
		
		$("#itemTransList").jqGrid({ 
             datatype: 'json', 
             mtype: '', 
             url:'',
             postData : getFormData('#application_form'),
             colNames:['작성번호','유형','TITLE','부서','요청자','emp_no','상태','요청일','조치일','list_type','list_status'],
                colModel:[
                	{name:'list_id'			, index:'list_id'				,width:30	,align:'center', sortable:false, formatter:'integer' },
                	{name:'list_type_desc'	, index:'list_type_desc'		,width:60	,align:'center', sortable:false,},
                    //{name:'description'		, index:'description'			,width:150	,align:'center'},
                    {name:'request_title'	, index:'request_title'			,width:170	,align:'center', sortable:false,},
                    {name:'dept_name'		, index:'dept_name'				,width:50	,align:'center', sortable:false,},
                    {name:'user_name'		, index:'user_name'				,width:25	,align:'center', sortable:false,},
                    {name:'emp_no'			, index:'emp_no'				,width:20	,align:'center', hidden : isHidden},
                    {name:'list_status_desc', index:'list_status_desc'		,width:30	,align:'center', sortable:false,},
                    {name:'request_date'	, index:'request_date'			,width:30	,align:'center', sortable:false,},
                    {name:'jochi_date'		, index:'jochi_date'			,width:30	,align:'center', sortable:false,},
                    {name:'list_type'		, index:'list_type'				,width:30	,align:'center', hidden : isHidden},
                    {name:'list_status'		, index:'list_status'			,width:30	,align:'center', hidden : isHidden},
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 630,
             pager: jQuery('#btnitemTransList'),
             rowList:[100,500,1000],
	         rowNum:100, 
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
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
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
			        });
			        this.updatepager(false, true);
			    }
			 },			 
			 ondblClickRow : function( rowid, cellname, value, iRow, iCol ) {
				var item 		= $( '#itemTransList' ).jqGrid( 'getRowData', rowid );
				var list_id		= item.list_id;
				var list_type 	= item.list_type;
				var list_status	= item.list_status;
				var request_date= item.request_date;
				var list_status_desc = item.list_status_desc;
				var url = "standardInfoTransModifyView.do?p_process=modifyView&list_id="+list_id;
				
				var rs = window.showModalDialog(url, window, "dialogWidth:900px; dialogHeight:900px; center:on; scroll:off; status:off");
				if(rs == "OK"){
					fn_search();
				}
			 }			 
        }); //end of jqGrid
	}
	
	function delay(num) {
		var now = new Date();
	    var stop = now.getTime() + num;
	    while(true){
		    now = new Date();
		    if(now.getTime() > stop)
			    return;
	    }
	}
</script>
</body>
</html>