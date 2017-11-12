<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ECO 조회</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "mainDiv" class="mainDiv">
	<form id="application_form" name="application_form" >
		<% 
			String sSave = request.getParameter("save") == null ? "" : request.getParameter("save").toString(); // bom인경우 bomAddEco : eco 경우 reEco
			String sMaincode = request.getParameter("maincode") == null ? "" : request.getParameter("maincode").toString(); 
			String sEcotype = request.getParameter("ecotype") == null ? "" : request.getParameter("ecotype").toString(); 
		%>
		<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
		<input type="hidden" id="save" name="save" value="<%=sSave%>"/>
		<input type="hidden" id="sType" name="sType" value="ecoAddEcrRink"/>
		<input type="hidden" name="main_code" id="main_code" value="<%=sMaincode%>">
		<input type="hidden" name="main_type" id="main_type" value="ECO">
		<input type="hidden" name="eng_sub_type" id="eng_sub_type" value="ECO">
		<input type="hidden" name="eng_small_type" id="eng_small_type" value="RECO">
		<input type="hidden" name="secotype" id="secotype" value="<%=sEcotype%>">
		<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="ecr" />
		
		<div class="topMain" style="margin-top: 0px;">
			<div class = "conSearch">
				<span class="only_eco pop_tit">ECO No.</span>
				<input type="text" class="only_eco" id="main_name" name="main_name" style="text-transform: uppercase; width: 80px; height:25px; maxlength="10" />
				<span class="only_eco">&nbsp;</span>
				<span class="only_eco pop_tit">작성자</span>
				<input type="text" class="only_eco" id="created_by" name="created_by" style="width: 50px;height:25px; " onkeyup="fn_clear();" />
				<input type="text" class="notdisabled only_eco" id="created_by_name" name="created_by_name" readonly="readonly" style="width: 50px;height:25px;  margin-left: -5px;" />
				<input type="button" class="only_eco btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />
				<span class="hidden_ecr">&nbsp;</span>
				<span class="only_eco pop_tit">부서</span>
				<input type="text" class="only_eco" id="user_group" name="user_group" style="width: 50px;height:25px;" onkeyup="fn_clear2();" />
				<input type="text" class="notdisabled only_eco" id="user_group_name" name="user_group_name" readonly="readonly" style="margin-left: -5px;height:25px; " />
				<input type="button" class="only_eco btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색"  />
				<span class="only_eco">&nbsp;&nbsp;</span>
				<span class="only_eco pop_tit">ECO 생성일</span>
				<input type="text" id="created_date_start" name="created_date_start" class="datepicker only_eco" style="width: 70px;height:25px; "/>
				<span class="only_eco">~</span>
				<input type="text" id="created_date_end" name="created_date_end" class="datepicker only_eco" style="width: 70px;height:25px; "/>
				<span class="only_eco">&nbsp;&nbsp;</span>
				<span class="button">
				<input type="button" class="only_eco btn_blue" id="btnSelect" name="btnSelect" value="조회" />
				<input type="button" class="only_eco btn_blue" id="btnSave" name="btnSave" value="저장" />
				<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				<input type="hidden" value="${loginUser.user_id}" class="" id="loginid" name="loginid" style="text-transform: uppercase; width: 70px;" />
				</span>
			</div> 
		</div>
		<div class="content" >
			<table id="ecoList"></table>
			<div id="pecoList"></div>
		</div>
	</form>
</div>
<script type="text/javascript">

var tableId = '';
var resultData = [];
var enable_flag   = "";
var idRow = 0;
var idCol = 0;	
var nRow = 0;
var cmtypedesc;
var kRow = 0;
var kCol = 0;
var jqgHeight = $(window).height()*0.6;

$( function() {
	var dates = $( "#created_date_start, #created_date_end" ).datepicker( {
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
			var option = this.id == "created_date_start" ? "minDate" : "maxDate",
			instance = $( this ).data( "datepicker" ),
			date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
			dates.not( this ).datepicker( "option", option, date );
		}
	} );
	
	fn_weekDate( "created_date_start", "created_date_end" );
	
	//alert($("#created_date_start").val());
	
} );

$(document).ready(function(){
	$("#ecoList").jqGrid({ 
         datatype: 'json', 
         mtype: '', 
         postData : $("#application_form").serialize(),
         colNames:['선택','MAIN CODE','ECO No.','ECO상태','Related ECR','Type','ECO Cause','생성자','결재자','부서', '','Project','ECO Description','생성일',''],
            colModel:[
            	{name:'enable_flag',index:'enable_flag',align : "center", width:30, editable:true, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
            	{name:'main_code',index:'main_code', width:52, hidden:true, editrules:{required:true}, editoptions:{size:5}},
                {name:'main_name',index:'main_name', classes : 'disables',width:70, editable:false,align:"center"},
                {name:'states_desc',index:'states_desc',classes : 'disables', width : 50 },
                {name:'eng_change_name',index:'eng_change_name', width:70, editable:false,align:"center"},
                {name:'permanent_temporary_flag',index:'permanent_temporary_flag', width:30,align:"center", editable:true, edittype:"select",editoptions:{value:"5:영구;7:잠정", defaultValue: '5:영구',
                	dataEvents : [ { type : 'change', fn : function( e ) { 
                		if( $(this).val() == "5" ) { //영구
                     		  $('#ecoList').editCell(s_row_id, 14, true); 
                		} else { //잠정일때
                		  jQuery("#ecoList").jqGrid('setCell', s_row_id, 14, '', 'not-editable-cell');

                 		}
                		
                		if(popupDiv == 'bomAddEco'){ //bom 일때 실행
              			  
                			var pEng_eco_project = $("#eng_eco_project").val();
                			var pEng_eco_project_Code = $("#eng_eco_project_Code").val();
                 		  
                			$("#ecoList").setRowData(s_row_id,{eng_eco_project:pEng_eco_project}); 
  							$("#ecoList").setRowData(s_row_id,{eng_eco_project_Code:pEng_eco_project_Code}); 
                			  
                		  }
               		}              		
               		 } ]
               		 }},    
                {name:'couse_desc',index:'couse_desc', width:140, editable:false},
                {name:'design_engineer',index:'design_engineer', width:60},
                {name:'manufacturing_engineer',index:'manufacturing_engineer', width:60},
                {name:'user_group_name', index : 'user_group_name', width : 220 }, 
          		{name:'user_group', index : 'user_group', width : 0, hidden : true, editoptions : { size : 30 } },
                {name:'eng_eco_project',index:'eng_eco_project',editable:true,width:50,  editoptions:{size:50}, hidden:true},
                {name:'main_description',index:'main_description', width:400, editable:false,edittype:"textarea", editoptions:{rows:"2",cols:"30"}},
                {name:'created_date',index:'created_date', width:0, hidden:false},
                {name:'oper',index:'oper', width:0, hidden:true}
         ],
         gridview: true,
         toolbar: [false, "bottom"],
         viewrecords: true,
         autowidth: true,
         //height: $("#ecoList").height(),
         height: 320,
         pager: jQuery('#pecoList'),
         pgbuttons: false,
		 pgtext: false,
		 pginput:false,
		 cellEdit: true,             // grid edit mode 1
         cellsubmit: 'clientArray',  // grid edit mode 2
         rowNum:100000000, 
		 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	idRow=rowid;
            	idCol=iCol;
            	kRow = iRow;
            	kCol = iCol;
		 },
		 beforeSaveCell : chmResultEditEnd,
         //afterSaveCell : chmResultEditEnd,
         jsonReader : {
             root: "rows",
             page: "page",
             total: "total",
             records: "records",  
             repeatitems: false,
         },        
         imgpath: 'themes/basic/images',
         ondblClickRow : function(rowId) {
         	 
         	 if(bSave == "bomAddEco"){
         		
				 var rowData = jQuery(this).getRowData(rowId);
				
				 var returnValue = new Array();
				 returnValue[0] = rowData['main_code'];
				 returnValue[1] = rowData['main_name'];
				 returnValue[2] = rowData['states_desc'];
				 returnValue[3] = rowData['design_engineer'];
				 window.returnValue = returnValue;
				 self.close();
			}
         }
     }); 
	
	var bSave = $("#save").val();
	if(bSave == "bomAddEco"){
		$("#btnSave").hide(); //bom 추가시 안보여주기
		$( "#ecoList" ).hideCol( "enable_flag" );
	}
	
	$("#ecoList").jqGrid('navGrid',"#pecoList",{search:false,edit:false,add:false,del:false});
	
	fn_gridresize($(window),$("#ecoList"));
	
	//조회 버튼
	$("#btnSelect").click(function() {
		fn_search();
	});	
	
	//사번 조회 팝업... 버튼
	$("#btnEmpNo").click( function() {
		var rs = window.showModalDialog( "popUpSearchCreateBy.do",
				"ECO",
				"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
		
		if( rs != null ) {
			$( "#created_by" ).val(rs[0]);
			$( "#created_by_name" ).val( rs[1] );
			$( "#user_group" ).val( rs[2] );
			$( "#user_group_name" ).val( rs[3] );
		}
	} );
	
	//사번 조회 팝업... 버튼
	$("#btnGroupNo").click( function() {
		var rs = window.showModalDialog( "popUpGroup.do",
				"ECO",
				"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );

		if( rs != null ) {
			$( "#user_group" ).val( rs[0] );
			$( "#user_group_name" ).val( rs[1] );
		}
	} );
	
	$("#btncancle").click( function() {
		self.close();
	});
	
	
	setTimeout(function(){
		fn_search();
	 }, 500);
	
});//end of ready Function
		
	//afterSaveCell oper 값 지정
	function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
		var item = $('#ecoList').jqGrid('getRowData',irowId);
		if(item.oper != 'I') item.oper = 'U';
		$('#ecoList').jqGrid("setRowData", irowId, item);
		$("input.editable,select.editable", this).attr("editable", "0");	
	};
		
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
		var changedData = $.grep($("#ecoList").jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D'; 
		});
		callback.apply(this, [changedData.concat(resultData)]);
	};
	
	
	//작성자 조회조건 삭제 시 작성자명, 부서코드, 부서명 초기화
	function fn_clear() {
		if( $("#created_by").val() == "" ) {
			$("#created_by_name").val( "" );
			$("#user_group").val( "" );
			$("#user_group_name").val( "" );
		}
	}
	
	function fn_search() {
		
		var sUrl = "infoECORelated.do";
		$( "#ecoList" ).jqGrid( 'setGridParam', {
			url : sUrl,
			mtype: 'POST',
			datatype : 'json',
			page : 1,
			postData : getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}
	
	
</script>
</body>
</html>
