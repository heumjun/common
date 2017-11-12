<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC BOM</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		USC BOM<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
		<col width="60"/>
		<col width="180"/>
		<col width="*"/>
	<tr>
		<th>ECO NO.</th>
		<td>
			<input type="text" class="require" name="p_eco_no" id="p_eco_no" alt="ECO"  style="width:60px;" value=""/>
			<input type="button" class="btn_gray2" id="btnEco" name="btnEco" value="CREATE" />
		</td>
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
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
	var resultData = [];
	
	var jqGridObj = $("#jqGridMainList");	
	
	$(document).ready(function(){
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'STATE'		, name : 'state_flag'			, index : 'state_flag'				, width : 100, editable : false, align : "center"},
					{label:'MASTER'		, name : 'representative_pro_num', index : 'representative_pro_num'	, width : 100, editable : false, align : "center"},
					{label:'PROJECT'	, name : 'project_no'			, index : 'project_no'				, width : 100, editable : false, align : "center"},
					{label:'구역'			, name : 'area'					, index : 'area'					, width : 100, editable : false, align : "center"},
					{label:'BLOCK'		, name : 'block_no'				, index : 'block_no'				, width : 100, editable : false, align : "center"},
					{label:'STR'		, name : 'str_flag'				, index : 'str_flag'				, width : 100, editable : false, align : "center", hidden:true},
					{label:'BLOCK_STR'	, name : 'block_str_flag'		, index : 'block_str_flag'			, width : 100, editable : false, align : "center"},
					{label:'JOB_STR'	, name : 'job_str_flag'			, index : 'job_str_flag'			, width : 100, editable : false, align : "center"},
					{label:'JOB_TYPE'	, name : 'usc_job_type'			, index : 'usc_job_type'			, width : 100, editable : false, align : "center"},
					{label:'U_BLK'		, name : 'upper_block'			, index : 'upper_block'				, width : 100, editable : false, align : "center"},
					{label:'BK CODE'	, name : 'block_catalog'		, index : 'block_catalog'			, width : 100, editable : false, align : "center"},
					{label:'ACT CODE'	, name : 'activity_catalog'		, index : 'activity_catalog'		, width : 100, editable : false, align : "center"},
					{label:'JOB CODE'	, name : 'job_catalog'			, index : 'job_catalog'				, width : 100, editable : false, align : "center"},
					{label:'WORK DATE'	, name : 'work_date'			, index : 'work_date'				, width : 100, editable : false, align : "center"},
					{label:'WORK'		, name : 'work_yn'				, index : 'work_yn'					, width : 60, editable : false, align : "center"},
					{label:'ACT CODE'	, name : 'wip_act_code'			, index : 'wip_act_code'			, width : 100, editable : false, align : "center"},
					{label:'DEL GBN'	, name : 'delete_gbn'			, index : 'delete_gbn'				, width : 100, editable : false, align : "center", hidden:true},
					{label:'CRUD'		, name : 'oper'					, index : 'oper'					, width : 100, editable : false, align : "center", hidden:true}
				],
				gridview: true,
	             viewrecords: true,
	             autowidth: true,
	             cmTemplate: { title: false },
	             cellEdit : true,
	             cellsubmit : 'clientArray', // grid edit mode 2
				 scrollOffset : 17,
	             multiselect: false,
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
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
     	
     	var args = window.opener;
		var row_id = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		var jsonGridData = new Array();

		for(var i=0; i<row_id.length; i++) {						
			var item = args.jqGridObj.jqGrid( 'getRowData', row_id[i]);			
		
			jsonGridData.push({state_flag : item.state_flag
				             , representative_pro_num : item.representative_pro_num
				             , project_no : item.project_no
				             , area : item.area
				             , block_no : item.block_no				             
				             , str_flag : item.str_flag
				             , block_str_flag : item.block_str_flag
				             , job_str_flag : item.job_str_flag
				             , usc_job_type : item.usc_job_type
				             , upper_block : item.upper_block
				             , block_catalog : item.block_code
				             , activity_catalog : item.act_code
				             , job_catalog : item.job_code
				             , work_date : item.work_date
				             , work_yn : item.work_yn
				             , wip_act_code : item.wip_act_code
				             , delete_gbn : item.delete_gbn
				             , oper : 'I'});
		}
		
		jqGridObj.clearGridData(true);
		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
		
		//grid resize
	    fn_gridresize( $(window), jqGridObj, 0 );
		
		//Eco no 버튼 클릭 시 Ajax로 Eno no를 받아 넣는다.
		$("#btnEco").click(function(){
			var dialog = $( '<p>ECO를 연결합니다.</p>' ).dialog( {
				buttons : {
					"SEARCH" : function() {
						var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
								window,
								"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off" );

						if( rs != null ) {
							$( "#p_eco_no" ).val( rs[0] );
						}

						dialog.dialog( 'close' );
					},
					"CREATE" : function() {
						var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=&mainType=ECO",
								"ECONO",
								"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
						if( rs != null ) {
							$( "#p_eco_no" ).val( rs[0] );
						}
						dialog.dialog( 'close' );
					},
					"Cancel" : function() {
						dialog.dialog( 'close' );
					}
				}
			} );
		});
		
		//btnApply 버튼 클릭 시 Ajax로 eco no를 포험한 usc정보를 저장한다.
		$("#btnApply").click(function(){
			var args = window.opener;
			
			if(uniqeValidation()){
				jqGridObj.saveCell(kRow, idCol );
				var row_id = $( "#jqGridMainList" ).getDataIDs();
				
				if(confirm("적용 하시겠습니까?")) {
					var chmResultRows = [];

					//변경된 row만 가져 오기 위한 함수
					getChangedChmResultData( function( data ) {
						lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
						
						chmResultRows = data;
						var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
						var url = 'saveUscMainEco.do';
						var formData = fn_getFormData('#application_form');
						//객체를 합치기. dataList를 기준으로 formData를 합친다.
						var parameters = $.extend( {}, dataList, formData); 
						
						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								args.fn_search_bom();
								self.close();
							}
						}, "json" ).error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						}).always( function() {
					    	lodingBox.remove();	
						});
					});
				}
			}
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
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}

	function fn_search() {
		
		var sUrl = "uscMainList.do";
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
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".require").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}

</script>
</body>

</html>