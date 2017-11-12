<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC V-BLK</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<input type="hidden" id="chk_series" name="chk_series" value="${chk_series}"/>
		<input type="hidden" id="rep_pro_num" name="rep_pro_num" value="${rep_pro_num}"/>
		<div class="subtitle">
		USC V-BLK<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
		<col width="40"/>
		<col width="80"/>
		<col width="50"/>
		<col width="80"/>
		<col width="50"/>
		<col width="80"/>
		<col width="50"/>
		<col width="80"/>
		<col width="70"/>
		<col width="80"/>
		<col width="70"/>
		<col width="80"/>
		<col width="*"/>
	<tr>
		<th>구역</th>
		<td>
			<select name="p_area" id="p_area" style="width:60px;">
				<option value="">ALL</option>
			</select>
		</td>
		<th>B_NAME</th>
		<td>
			<input type="text" name="p_block_no" style="width:60px;" />
		</td>
		<th>B_CATA</th>
		<td>
			<input type="text" name="p_block_catalog" style="width:60px;" />
		</td>		
		<th>B_STR</th>
		<td>
			<input type="text" name="p_block_str" style="width:60px;" />
		</td>
		<th>ACT CATA</th>
		<td>
			<input type="text" name="p_act_catalog" value="" style="width:60px;" />
		</td>
		<th>JOB CATA</th>
		<td>
			<input type="text" name="p_job_catalog" value="" style="width:60px;" />
		</td>
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				<input type="button" class="btn_blue2" value="APPLY" id="btnApply"/>
			</div>
		</td>	
		</tr>
		</table>
		
		
		<div class="content">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var err = true;
	var msg = "";
	
	var jqGridObj = $("#jqGridMainList");
	var resultData = [];
	
	$(document).ready(function(){
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'선종'				, name : 'model_type'			, index : 'model_type'			, width : 100, editable : false, align : "center"},
					{label:''				, name : 'construct_type'		, index : 'construct_type'		, width : 100, editable : false, align : "center", hidden:true},
					{label:'건조기지'			, name : 'construct_type_name'	, index : 'construct_type_name'	, width : 100, editable : false, align : "center"},
					{label:'가상Block여부'		, name : 'virtual_yn'			, index : 'virtual_yn'			, width : 100, editable : false, align : "center"},
					{label:'구역'				, name : 'area'					, index : 'area'				, width : 100, editable : false, align : "center"},
					{label:'B_NAME'			, name : 'block_no'				, index : 'block_no'			, width : 100, editable : false, align : "center"},
					{label:'B_CATA'			, name : 'block_catalog'		, index : 'block_catalog'		, width : 100, editable : false, align : "center"},
					{label:'B_STR'			, name : 'block_str_flag'		, index : 'block_str_flag'		, width : 100, editable : false, align : "center"},
					{label:'STR'			, name : 'job_str_flag'			, index : 'job_str_flag'		, width : 100, editable : false, align : "center"},
					{label:'ACT_CATA'		, name : 'activity_catalog'		, index : 'activity_catalog'	, width : 100, editable : false, align : "center"},
					{label:'JOB_CATA'		, name : 'job_catalog'			, index : 'job_catalog'			, width : 100, editable : false, align : "center"},
					{label:'ATTR'			, name : 'usc_job_type'			, index : 'usc_job_type'		, width : 100, editable : false, align : "center"},
					{label:'U_BLK'			, name : 'upper_block'			, index : 'upper_block'			, width : 100, editable : false, align : "center"},
					{label:''				, name : 'work_yn'				, index : 'work_yn'				, width : 100, editable : false, align : "center", hidden:true},
					{label:''				, name : 'project_no'			, index : 'project_no'			, width : 100, editable : false, align : "center", hidden:true},
					{label:''				, name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 100, editable : false, align : "center", hidden:true},
					{label:''				, name : 'oper'					, index : 'oper'				, width : 100, editable : false, align : "center", hidden:true}
				],
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cmTemplate: { title: false },
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
             multiselect: true,
             pgbuttons 	: false,
			 pgtext 	: false,
			 pginput 	: false,
             height: 420,
             pager: '#bottomJqGridMainList',
             rowNum:999999, 
	         recordtext: '전체 {2}',
        	 emptyrecords:'조회 내역 없음',
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow = rowid;
             	idCol = iCol;
             	kRow  = iRow;
             	kCol  = iCol;
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
				        //datatype: 'local',
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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj.getRowData(rowid);
					afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
				}
			},
			//afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
     	
     	// 구역 선택
     	$.post( "infoAreaList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_area").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
     	
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 0 );

		fn_search();
		
		//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			fn_search(); 
		});
		
		//Apply 버튼 클릭 시 Ajax로 리스트를 받아 넣어 메인 화면에 뿌린다.
		$("#btnApply").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			//var row_id = fromList;
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return;
			}
			
			for( var i = 0; i < row_id.length; i++ ) {
				jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'U');
			}
			
			var chmResultRows = [];

			//변경된 row만 가져 오기 위한 함수
			getChangedChmResultData( function( data ) {
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				chmResultRows = data;
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				var url = 'uscVirtualBlockImportCheck.do';
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend( {}, dataList, formData);
				
				$.post( url, parameters, function( data ) {
					if ( data.msg != '' ) {
						alert(data.msg);
						return;
					} else {
						if(confirm("적용 하시겠습니까?")) {
							var jsonGridData = new Array();		
							var project_no = ($("#chk_series").val()).split(",");
							var msg = "";
							
							for(a=0; a<project_no.length; a++) {
								for(var i=0; i<row_id.length; i++) {						
									var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
	
									jsonGridData.push({state_flag : 'A'
							              , representative_pro_num : $("#rep_pro_num").val()
							              , project_no : project_no[a]
							              , area : item.area
							              , area_name : item.area_name
							              , block_no : item.block_no
							              , str_flag : item.block_str_flag
							              , block_str_flag : item.block_str_flag
							              , job_str_flag : item.job_str_flag
							              //, str_name : item.str_name
							              , block_code : item.block_catalog
							              , act_code : item.activity_catalog
							              , job_code : item.job_catalog
							              , upper_block : item.upper_block
							              , work_yn : item.work_yn
							              , virtual_yn : item.virtual_yn
							              , usc_job_type : item.usc_job_type
							              , oper : 'I'});
								}
							}
							//window.returnValue = jsonGridData;							
							window.opener.setVBlock(jsonGridData);
							
							self.close();
						}				
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				}).always( function() {
			    	lodingBox.remove();	
				});	
			});
		});
	});
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {	
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
		});
				
		callback.apply( this, [ changedData.concat(resultData) ] );
	}

	function fn_search() {	
		var sUrl = "uscVirtualBlockImport.do?p_chk_series="+$("#chk_series").val();
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		printCheckSelectCnt();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		printCheckSelectCnt();
	}
	
	
	//체크 유무 validation
	var isChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}
	
</script>
</body>

</html>