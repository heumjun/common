<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC ACTIVITY</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
.sscType {color:#324877;
			font-weight:bold; 
		}
</style>
<body>

<form id="application_form" name="application_form"  >
	<input type="hidden" id="projects" name="projects" value="" />
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		USC ACTIVITY<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
		<col width="100"/>
		<col width="100"/>
		<col width="130"/>
		<col width="130"/>
		<col width="*"/>
	<tr>
		<td class="sscType">
			구역 : 
			<input type="text" id="p_area" name="p_area" value="" style="width: 50px; text-align:center;">  
		</td>
		<td class="sscType">
			STR : 
			<input type="text" id="p_job_str_flag" name="p_job_str_flag" value="" style="width: 50px; text-align:center;">  
		</td>
		<td class="sscType">
			ACT_CATA : 
			<input type="text" id="p_activity_catalog" name="p_activity_catalog" value="" style="width: 50px; text-align:center;">  
		</td>
		<td class="sscType">
			JOB_CATA : 
			<input type="text" id="p_job_catalog" name="p_job_catalog" value="" style="width: 50px; text-align:center;">  
		</td>
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
				<!-- <input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/> -->
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
	
	var jqGridObj = $("#jqGridMainList");
	var resultData = [];
	
	$(document).ready(function(){
		jqGridObj.jqGrid({ 
			datatype: "local",
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'Project'		, name : 'project_no'			, index : 'project_no'			, width : 100, editable : false, align : "center", search:true },
					{label:'구역'			, name : 'area'					, index : 'area'				, width : 100, editable : false, align : "center"},
					{label:'B_NAME'			, name : 'block_no'				, index : 'block_no'			, width : 100, editable : false, align : "center"},
					{label:'B_CATA'			, name : 'block_catalog'		, index : 'block_catalog'		, width : 100, editable : false, align : "center"},	
					{label:'BLOCK_STR'		, name : 'block_str_flag'		, index : 'block_str_flag'		, width : 100, editable : false, align : "center", hidden:true},
					{label:'STR'			, name : 'job_str_flag'			, index : 'job_str_flag'		, width : 100, editable : false, align : "center"},
					{label:'U_BLK'		 	, name : 'upper_block'			, index : 'upper_block'			, width : 80,  editable : false, align : "center"},
					{label:'ACT_CATA'		, name : 'activity_catalog'		, index : 'activity_catalog'	, width : 100, editable : false, align : "center"},
					{label:'JOB_CATA'		, name : 'job_catalog'			, index : 'job_catalog'			, width : 100, editable : false, align : "center"},
					{label:'JOB_TYPE'		, name : 'usc_job_type'			, index : 'usc_job_type'		, width : 100, editable : false, align : "center"},
					{label:''				, name : 'work_yn'				, index : 'work_yn'				, width : 100, editable : false, align : "center", hidden:true},
					{label:''				, name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 100, editable : false, align : "center", hidden:true},
					{label:''				, name : 'oper'					, index : 'oper'				, width : 100, editable : false, align : "center", hidden:true}
				],
             gridview: true,
             search : true,
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
     	
     	// 그리드 헤더에 필터 추가 옵션
     	/* jqGridObj.jqGrid('filterToolbar', {
		    stringResult: true,
		    searchOnEnter: false,
		    defaultSearch: "cn"
		}); */
		
		$("#btnSearch").click(function() {

			var p_area = $("#p_area").val();
		    var p_job_str_flag = $("#p_job_str_flag").val();
		    var p_activity_catalog = $("#p_activity_catalog").val();
		    var p_job_catalog = $("#p_job_catalog").val();
		    var grid = $("#jqGridMainList"), f;

		    /* if (p_area.length === 0 && p_job_str_flag.length === 0 && p_activity_catalog.length === 0 && p_job_catalog.length === 0) {
		        grid[0].p.search = false;
		        $.extend(grid[0].p.postData,{filters:""});
		    } */
		    
		    if(p_area != "") {
		    	p_area = p_area.toUpperCase();
		    }
		    if(p_job_str_flag != "") {
		    	p_job_str_flag = p_job_str_flag.toUpperCase();
		    }
		    if(p_activity_catalog != "") {
		    	p_activity_catalog = p_activity_catalog.toUpperCase();
		    }
		    if(p_job_catalog != "") {
		    	p_job_catalog = p_job_catalog.toUpperCase();
		    }
		    
		    f = {groupOp:"AND",rules:[]};
		    
		    f.rules.push({field:"area", op:"cn", data:p_area});
		    f.rules.push({field:"job_str_flag", op:"cn", data:p_job_str_flag});
		    f.rules.push({field:"activity_catalog", op:"cn", data:p_activity_catalog});
		    f.rules.push({field:"job_catalog", op:"cn", data:p_job_catalog});
		    grid[0].p.search = true;
		    $.extend(grid[0].p.postData,{filters:JSON.stringify(f)});
		    grid.trigger("reloadGrid",[{page:1,current:true}]);
		});
     	
     	
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
		
		var chmResultRows = [];

		lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );			

		var dataList = { chmResultList : JSON.stringify( jsonGridData ) };
		var url = 'uscActivityImport.do';
		var formData = fn_getFormData('#application_form');
		//객체를 합치기. dataList를 기준으로 formData를 합친다.
		var parameters = $.extend( {}, dataList, formData); 
		
		$.post( url, parameters, function( data ) {
			var jsonGridData = new Array();
			$('#projects').val(data.projects);
			if(data.rows == null || data.rows.length == 0) {
				alert("추가 생성 JOB이 존재하지 않습니다.");
			} else {
				if(data.rows != null) {
					for(var i=0; i<data.rows.length; i++){
						var rows = data.rows[i];
			
						jsonGridData.push({model_type : rows.model_type
							             , construct_type : rows.construct_type
							             , construct_type_name : rows.construct_type_name
							             , virtual_yn : rows.virtual_yn
							             , area : rows.area
							             , area_name : rows.area_name
							             , block_no : rows.block_no
							             , block_catalog : rows.block_catalog
							             , block_str_flag : rows.block_str_flag
							             , job_str_flag : rows.str_flag
							             , str_name : rows.str_name
							             , upper_block : rows.upper_block
							             , activity_catalog : rows.activity_catalog
							             , job_catalog : rows.job_catalog
							             , usc_job_type : rows.usc_job_type
							             , work_yn : rows.work_yn
							             , project_no : rows.project_no
							             , representative_pro_num : rows.representative_pro_num
							             , msg : rows.msg
							             , oper : ''});			
					}
					
					//jqGridObj.clearGridData(true);
					jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
				}
			}
		}, "json" ).error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		}).always( function() {
	    	lodingBox.remove();	
		});
		
		//grid resize
	    fn_gridresize( $(window), jqGridObj, 0 );
		
		//Apply 버튼 클릭 시 Ajax로 리스트를 받아 넣어 메인 화면에 뿌린다.
		$("#btnApply").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
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
				var url = 'uscActivityImportCheck.do';
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend( {}, dataList, formData);
				
				$.post( url, parameters, function( data ) {
					if ( data.msg != '' ) {
						alert(data.msg);
						return false;
					} else {			
						if(confirm("적용 하시겠습니까?")) {
							var args = window.opener;
							var jsonGridData = new Array();	
							
							var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
							if(row_id == ""){
								alert("행을 선택하십시오.");
								return;
							}
							
							//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
							//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
							var row_id1 = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');
							var row_len = row_id1.length;					
							//I 인것들은 바로 없앰
							for(var i=0; i<row_len; i++){
								var item = args.jqGridObj.jqGrid( 'getRowData', row_id1[0]);					
								args.jqGridObj.jqGrid('delRowData',row_id1[0]);						
							}
							//I가 아닌 것들을 다시 row_id 구해서 'D' 값 처리
							row_id1 = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');
							
							for(var i=0; i<row_id1.length; i++){								
								args.jqGridObj.jqGrid('delRowData',row_id1[i]);								
							}
							
							var pjt = $('#projects').val().split(",");
								
							getChangedChmResultData( function( data ) {
								lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
								
								chmResultRows = data;
								var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
								var url = 'uscActivityImportCheck.do';
								var formData = fn_getFormData('#application_form');
								//객체를 합치기. dataList를 기준으로 formData를 합친다.
								var parameters = $.extend( {}, dataList, formData);								
								
								var sUrl = "uscActivityExportList.do";
								args.jqGridObj.jqGrid( "clearGridData" );
								args.jqGridObj.jqGrid( 'setGridParam', {
									url : sUrl,
									mtype : 'POST',
									datatype : 'json',
									page : 1,
									rows : 100,
									rowNum : 999999,
									postData : parameters
								} ).trigger( "reloadGrid" );

								self.close();
							});						
						}				
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				}).always( function() {
					var row_all = jqGridObj.getDataIDs();
					for( var i = 0; i < row_all.length; i++ ) {
						jqGridObj.jqGrid('setCell', row_all[i], 'oper', null);
					}
			    	lodingBox.remove();	
				});	
			});
		});
	});
	
	var callback = function(json){
		var jsonGridData = new Array();

		if(json.rows != null) {
			for(var i=0; i<json.rows.length; i++){
				var rows = json.rows[i];
	
				jsonGridData.push({model_type : rows.model_type
					             , construct_type : rows.construct_type
					             , construct_type_name : rows.construct_type_name
					             , virtual_yn : rows.virtual_yn
					             , area : rows.area
					             , area_name : rows.area_name
					             , block_no : rows.block_no
					             , block_catalog : rows.block_catalog
					             , job_str_flag : rows.job_str_flag
					             , block_str_flag : rows.block_str_flag
					             , str_name : rows.str_name
					             , upper_block : rows.upper_block
					             , activity_catalog : rows.activity_catalog
					             , job_catalog : rows.job_catalog
					             , usc_job_type : rows.usc_job_type
					             , work_yn : rows.work_yn
					             , project_no : rows.project_no
					             , representative_pro_num : rows.representative_pro_num
					             , msg : rows.msg
					             , oper : ''});			
			}
			
			//jqGridObj.clearGridData(true);
			jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
		}
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
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D' || obj.oper == 'N';
		});
				
		callback.apply( this, [ changedData.concat(resultData) ] );
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