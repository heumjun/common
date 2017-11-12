<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC ADD Main</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.totalEaArea {position:relative; margin-right:40px; padding:4px 0 6px 2px; font-weight:bold; border:1px solid #ccc; background-color:#D7E4BC; vertical-align:middle; }	
	
	/*.itemInput {text-transform: uppercase;} */
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
	.header .searchArea .buttonArea #btnForm{float:left;}
	.required_cell{background-color:#F7FC96}	
</style>
</head>
<body> 
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			SSC ADD -
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_isPaging" value="" />
		<input type="hidden" name="p_in_job_cd" value="<c:out value="${p_job_cd}"/>" />
		<input type="hidden" name="p_master_no" value="<c:out value="${p_master_no}"/>" />
		<input type="hidden" name="p_item_type_cd" value="<c:out value="${p_item_type_cd}"/>" />		
		<input type="hidden" name="p_row_standard" value="" />
		<input type="hidden" name="p_work_key" value="" />
		<input type="hidden" name="p_work_flag" value="ADD" />
		<input type="hidden" name="p_excel" id="p_excel" value="" />
		<input type="hidden" value="1" id="stepState" name="p_stepstate"/>	
		<input type="hidden" value="H" id="mode" name="mode"/>
		<input type="hidden" value="" id="NextCheck" name="NextCheck"/>
		<input type="hidden" id="p_params" name="p_params" value="<c:out value="${params}"/>" />
		<input type="hidden" name="p_arrDistinct" value="${p_arrDistinct}" />	
		<table class="searchArea conSearch">
			<col width="80"/>
			<col width="90"/>
			<col width="80"/>
			<col width="130"/>
			<col width="80"/>
			<col width="150"/>
			<col width="80"/>
			<col width="80"/>
			<col width="*"/>
			<tr>
				<th>PROJECT</th>
				<td>
				<input type="text" name="p_project_no" class = "required"  style="width:50px;" value="${p_project_no}" readonly="readonly"/>
				</td>
			
				<th>DWG NO.</th>
				<td>
				<input type="text" name="p_dwg_no"  class = "required" style="width:60px;" value="<c:out value="${p_dwg_no}" />" readonly="readonly"/>
				</td>

				<th>DEPT.</th>
				<td>
				<input type="text" name="p_dept_name" class="commonInput readonlyInput" style="width:130px;" readonly="readonly" value="<c:out value="${p_dept_name}" />" />
				<input type="hidden" name="p_dept_code" class="commonInput readonlyInput" style="width:70px;" readonly="readonly" value="<c:out value="${p_dept_code}" />" />
				</td>
				<th>USER</th>
				<td>
				<input type="text" name="p_user_name" class="commonInput readonlyInput" style="width:50px;" readonly="readonly" value="<c:out value="${loginUser.user_name}" />" />
				</td>
				<td class="bdr_no" style="border-right:none;">
					<c:choose>
						<c:when test="${p_item_type_cd != 'GE' and p_item_type_cd != 'EQ'}">
							<input type="button" class="btn_blue2" value="BUY-BUY" id="btnBuybuy" />
						</c:when>
					</c:choose>		
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="STAGE" id="btnStage" />				
						<input type="button" class="btn_blue2" value="BACK" id="btnBack" style="display:none;"/>
						<input type="button" class="btn_blue2" value="NEXT" id="btnNext" />
						<input type="button" class="btn_blue2" value="CLOSE" id="btnClose"/>
					</div>
				</td>	
			</tr>
		</table>
		<table class="searchArea2">
			<tr>
				<td>
					<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
				</td>
			</tr>
		</table>
		<table class="searchArea2">
			<col width="300"/>
			<col width="*"/>
			<tr>
				<td class="bdl_no" style="border-right:none;">
					<input type="button" class="btn_red2" value="FORM" id="btnForm" />
					<span class="totalEaArea" style="padding-left:5px; padding-right:5px; margin-left:10px">
						Total EA <input type="text" id="totalEa" style="width:50px; height:15px;" readonly="readonly"/>
					</span>
				</td>
				<td class="bdl_no" style="border-left:none;">
					<div class="button endbox">
						<c:choose>
						<c:when test="${p_item_type_cd != 'VA' && p_item_type_cd != 'EQ'  && p_item_type_cd != 'PA' && p_item_type_cd != 'GE' }">
							<input type="button" class="btn_red2" value="TRIBON" id="btnTribon"/>
						</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${p_item_type_cd == 'EQ'}">
								<input type="button" class="btn_red2" value="EMS" id="btnEms"/>
							</c:when>
							<c:when test="${p_item_type_cd == 'VA'}">
								<!-- <input type="button" class="btn_red2" value="VIM" id="btnVim"/> -->
							</c:when>
						</c:choose>				
						
						<input type="button" class="btn_red2" value="IMPORT" id="btnExlImp"/>
						<input type="button" class="btn_red2" value="+" id="btnAdd" style="width:28px; font-size:16px;"/>
						<input type="button" class="btn_red2" value="-" id="btnDel" style="width:28px; font-size:16px;"/>
					</div>
				</td>
			</tr>
		</table>
				
							
		<div class="content">
			<table id="jqGridAddMainList"></table>
			<div id="bottomJqGridAddMainList"></div>
		</div>
		<!-- loadingbox -->
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" src="/js/getGridColModel${p_item_type_cd}.js" charset='utf-8'></script>
<script type="text/javascript" >
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	var selectAttr = '';
	var backList = '';
	
	//필수 입력 값의 배경 색 지정
	var jqGridObj = $("#jqGridAddMainList");
	var uniqCellBgColor = {'background-color':'#F7FC96'};
	var noUniqCellBgColor = {'background-color':'white'};
	

	//필수 입력 컬럼 값 배열 : 아이템이 입력되면 필수 입력 해제되는 컬럼
	if($("input[name=p_item_type_cd]").val() == "SU"){
		uniq_ColName = new Array("key_no", "item_weight", "attr02", "attr04", "paint_code1");
	}else if($("input[name=p_item_type_cd]").val() == "CA"){
		uniq_ColName = new Array("attr01", "attr02", "attr03");
	}else if($("input[name=p_item_type_cd]").val() == "OU"){
		uniq_ColName = new Array("attr01", "item_weight", "paint_code1");
	}else if($("input[name=p_item_type_cd]").val() == "SE"){
		uniq_ColName = new Array("item_category_code", "key_no", "item_weight", "temp01", "paint_code1", "temp03");
	}else if($("input[name=p_item_type_cd]").val() == "TR"){
		uniq_ColName = new Array("item_category_code", "item_weight", "temp02", "paint_code1");
	}else{
		uniq_ColName = null;
	}
	
	$(document).ready(function(){
		
		//시리즈 호선 받기		
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y", null, getDeliverySeriesCallback);
		
		//Rev 받기.
		//getAjaxHtml($("#revArea"),"sscCommonRevTextBox.do?p_master_no="+$("input[name=p_master_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null);

		var vItemTypeCd = $("input[name=p_item_type_cd]").val();

		///js/getGridColModelMain.js에서 그리드의 colomn을 받아온다.
		var gridColModel = getAddGridColModel();
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'sscAddList.do',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit : false,
            height: 560,
            pager: $("#bottomJqGridAddMainList"),
	        rowNum: 100, 
            rowList:[100,500,1000],
            recordtext: '내용 {0} - {1}, 전체 {2}',
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
 				//$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
 	 			//$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");
		    	
            	var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt($("#jqGridAddMainList").getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt($("#jqGridAddMainList").getGridParam("lastpage"));  
 	   			var pages = 1;
 	   			var rowNum 			  = 100;

 	   			/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
 	   			* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
 	   			* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
 	   			*/ 
 	   			/* this is to make the grid to fetch data from server on page click*/
 	   			if (pgButton == "user") {
 	   				if (pageIndex > lastPageX) {
 	   			    	pages = lastPageX
 	   			    } else pages = pageIndex;
 	   				
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'next_bottomJqGridAddMainList'){
 	   				pages = currentPageIndex+1;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			} 
 	   			else if(pgButton == 'last_bottomJqGridAddMainList'){
 	   				pages = lastPageX;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'prev_bottomJqGridAddMainList'){
 	   				pages = currentPageIndex-1;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'first_bottomJqGridAddMainList'){
 	   				pages = 1;
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
 	   			//$(this).jqGrid("clearGridData");
 	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");
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
				        lastpageServer: data.total,
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
				
				var cbs = $(".cbox", jqGridObj[0]);
  				if($("#stepState").val() != "1") {
	   		        cbs.attr("disabled", "disabled");
	   		        cbs.attr("readonly", true);
  				}
				
				if($("#p_excel").val() != "Y") {
					//Validation 이후 셀 색깔 변경 및 TITLE TOOLTOP 설정
					var rows = $(this).getDataIDs();
					var err_style = { color : '#FFFFFF', background : 'red'};
					
					//필수 필드 배열 세팅
					var necessary_err_field;
					
					//필수 에러 필드 세팅
					
					if($("input[name=p_item_type_cd]").val() == "SU"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','item_weight','key_no','paint_code1','buy_mother_item_code');	
					}else if($("input[name=p_item_type_cd]").val() == "CA"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','item_weight','key_no','buy_mother_item_code');
					}else if($("input[name=p_item_type_cd]").val() == "OU"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','buy_mother_item_code','modify_item_code','item_code','bom_qty','item_weight','key_no');
					}else if($("input[name=p_item_type_cd]").val() == "SE"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','item_weight','key_no','buy_mother_item_code');
					}else if($("input[name=p_item_type_cd]").val() == "TR"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','item_weight','key_no','buy_mother_item_code');
					}else if($("input[name=p_item_type_cd]").val() == "VA"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','key_no','buy_mother_item_code');
					}else if($("input[name=p_item_type_cd]").val() == "PA"){
						necessary_err_field = new Array('project_no','dwg_no','job_cd','mother_code','item_code','bom_qty','buy_mother_item_code');
					}else if($("input[name=p_item_type_cd]").val() == "PI"){
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','buy_mother_item_code','key_no');
					}else{
						necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','buy_mother_item_code');
					}
					
					//필수 입력 컬럼 값 배열 : 아이템이 입력되면 필수 입력 해제되는 컬럼
					if($("input[name=p_item_type_cd]").val() == "SU"){
						uniq_ColName = new Array("key_no", "item_weight", "attr02", "attr04", "paint_code1");
					}else if($("input[name=p_item_type_cd]").val() == "CA"){
						uniq_ColName = new Array("attr01", "attr02", "attr03");
					}else if($("input[name=p_item_type_cd]").val() == "OU"){
						uniq_ColName = new Array( "item_weight", "paint_code1");
					}else if($("input[name=p_item_type_cd]").val() == "SE"){
						uniq_ColName = new Array("item_category_code", "key_no", "item_weight", "temp01", "paint_code1", "temp03");
					}else if($("input[name=p_item_type_cd]").val() == "TR"){
						uniq_ColName = new Array("item_category_code", "item_weight", "temp02", "paint_code1");
					}
					
					//모든 행 loop
					for ( var i = 0; i < rows.length; i++ ) {
						
						syncClassByContainRow($this, i, 'item_code','', false,'required_cell');
						
						if(necessary_err_field != null){
							//필수 오류 체크 loop
							for(var j=0; j<necessary_err_field.length; j++){
								//에러 필드 값
								var err_feild_val = $(this).getCell( rows[i], "error_msg_" + necessary_err_field[j]);
								//에러 필드의 값이 있으면 에러 표시 
								if(err_feild_val != ""){
									//수정 및 결재 가능한 리스트 색상 변경
									if($("input[name=p_item_type_cd]").val() == "OU" && necessary_err_field[j] == 'key_no'){
										$(this).setCell (rows[i], 'attr01','', err_style, {title : err_feild_val});
									} else if($("input[name=p_item_type_cd]").val() == "PI" && necessary_err_field[j] == 'key_no'){
										$(this).setCell (rows[i], 'attr13','', err_style, {title : err_feild_val});
									} else {
										$(this).setCell (rows[i], necessary_err_field[j],'', err_style, {title : err_feild_val});
									}
								}
							}
							
						}
						
						var nomal_err_field;
						//일반 에러 필드 정의 (WORK 테이블의 ERROR_MSG_01, ERROR_MSG_02, ...)
						//error_msg_01,error_msg_02 ... 순으로 컬럼명 세팅
						for(var j=0; j<10; j++){                   
							var numStr = j+1;
							if(numStr < 10){
								numStr = "0" + numStr;
							}
							//에러 필드 값	l
							var err_feild_val = $(this).getCell( rows[i], "error_msg_"+numStr);
							//에러 필드의 값이 있으면 에러 표시 
							if(err_feild_val != ""){
								if($("input[name=p_item_type_cd]").val() == "SU"){
									if(numStr == '01') $(this).setCell (rows[i], 'paint_code1','', err_style, {title : err_feild_val});
								}else if($("input[name=p_item_type_cd]").val() == "CA"){
									if(numStr == '01') $(this).setCell (rows[i], 'attr01','', err_style, {title : err_feild_val});
									if(numStr == '02') $(this).setCell (rows[i], 'attr02','', err_style, {title : err_feild_val});
								}else if($("input[name=p_item_type_cd]").val() == "OU"){
									if(numStr == '01') $(this).setCell (rows[i], 'bom_item_detail','', err_style, {title : err_feild_val});
									if(numStr == '02') $(this).setCell (rows[i], 'paint_code1','', err_style, {title : err_feild_val});
									if(numStr == '03') $(this).setCell (rows[i], 'paint_code2','', err_style, {title : err_feild_val});
								}else if($("input[name=p_item_type_cd]").val() == "SE"){
									if(numStr == '01') $(this).setCell (rows[i], 'temp01','', err_style, {title : err_feild_val});
									if(numStr == '02') $(this).setCell (rows[i], 'temp02','', err_style, {title : err_feild_val});
									if(numStr == '03') $(this).setCell (rows[i], 'temp03','', err_style, {title : err_feild_val});
									if(numStr == '04') $(this).setCell (rows[i], 'paint_code1','', err_style, {title : err_feild_val});
								}else if($("input[name=p_item_type_cd]").val() == "TR"){
									if(numStr == '01') $(this).setCell (rows[i], 'temp01','', err_style, {title : err_feild_val});
									if(numStr == '02') $(this).setCell (rows[i], 'temp02','', err_style, {title : err_feild_val});
									if(numStr == '03') $(this).setCell (rows[i], 'paint_code1','', err_style, {title : err_feild_val});
								}
								
								if(numStr == '10') $(this).setCell (rows[i], 'usc_job_type','', err_style, {title : err_feild_val});
							}
						}
					}
					
					
					//Column 필수 입력 Edit 세팅
					setAllEditColumn();                                                                                                                                                                             
	  			}
				
				//Total 수량 출력
				totalEaAction();
			},		
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
			},
			afterSaveCell : chmResultEditEnd
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 90 );

    	//초기 job 셋팅
    	//getJobCode('','','');
    	
    	$("#btnBuybuy").click(function(){
    		
    		var mode = $("#mode").val();
    		var p_item_type_cd = $("input[name=p_item_type_cd]").val();
    		
    		
    		if(mode == "H") {
    			
    			if(p_item_type_cd == 'EQ') {
					jqGridObj.jqGrid('showCol',["buy_mother_item_code", "buy_mother_item_desc", "buy_mother_item_weight"]);
    			} else {
    				jqGridObj.jqGrid('showCol',["buy_mother_item_code", "buy_mother_key_no", "buy_mother_item_desc", "buy_mother_item_weight"]);
    			}
				$("#mode").val("S");
    		} else {
    			jqGridObj.jqGrid('hideCol',["buy_mother_item_code", "buy_mother_key_no", "buy_mother_item_desc", "buy_mother_item_weight"]);
    			$("#mode").val("H");
    		}
		});
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){ 
			history.go(-1);
		});
		
		//Tribon 버튼 클릭
		$("#btnTribon").click(function(){
			if(jqGridObj.jqGrid('getDataIDs') != ""){
				if(!confirm("기존 Data가 삭제 됩니다.\n계속 진행하시겠습니까?")){
					return false;
				}
			}
			
			jqGridObj.jqGrid("clearGridData");
			
			var sURL = "sscAddTribonInterfaceMain.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_master_no="+$("input[name=p_master_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_dept_name="+$("input[name=p_dept_name]").val();
			var popOptions = "dialogWidth: 1350px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;";
			
			if($("input[name=p_item_type_cd]").val() == "OU"){
				popOptions = "dialogWidth: 1070px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;";
			} else if ($("input[name=p_item_type_cd]").val() == "SU") {
				popOptions = "dialogWidth: 1200px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;";
			} else if ($("input[name=p_item_type_cd]").val() == "CA") {
				popOptions = "dialogWidth: 970px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;";
			} else if ($("input[name=p_item_type_cd]").val() == "TR") {
				popOptions = "dialogWidth: 1300px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;";
			} else if ($("input[name=p_item_type_cd]").val() == "GE") {
				popOptions = "dialogWidth: 970px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;";
			}
			window.showModalDialog(sURL, window, popOptions);
			
			//Total 수량 출력
			totalEaAction();
		});
		
		//EMS 버튼 클릭
		$("#btnEms").click(function(){

			var sURL = "sscAddEmsInterfaceMain.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_master_no="+$("input[name=p_master_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val();
			var popOptions = "dialogWidth: 1200px; dialogHeight: 700px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
			
// 			var sURL = "sscAddEmsInterfaceMain.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_master_no="+$("input[name=p_master_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val();
// 			var popOptions = "width=1230, height=700, resizable=yes, scrollbars=yes, status=yes"; 
// 			window.open(sURL, "", popOptions);

			//var popOptions = "width=1230, height=700, resizable=yes, status=no, menubar=no, toolbar=no, scrollbars=yes, location=no"
			//window.open(sURL,'emsPopup', popOptions).focus();
			
		});
		//VIM 버튼 클릭
		$("#btnVim").click(function(){
			if($("#InputArea").text()!=""){
				if(!confirm("기존 Data가 삭제 됩니다.\n계속 진행하시겠습니까?")){
					return false;
				}
			}
			/*
			SearchInit();
			var sURL = "/ematrix/tbcItemAddVim.tbc?p_project="+$("input[name=p_project]").val()+"&p_dwgno="+$("input[name=p_dwgno]").val()+"&p_master="+$("input[name=p_master]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val();
			var popOptions = "dialogWidth: 1230px; dialogHeight: 700px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
			
			
			var sURL = "sscAddVimInterfaceMain.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_master_no="+$("input[name=p_master_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val();
			var popOptions = "dialogWidth: 1230px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
			*/
		});
		
		//Stage 입력
		$("#btnStage").click(function(){
			
			var rtn = true;
			var NextCheck = false;
			
			jqGridObj.saveCell(kRow, idCol );
		
			var formData = fn_getFormData('#application_form');
				
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			$("input[type=hidden]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			
			$("#p_selrev").attr("disabled", false);
			
			//LIST Validation
			//if($("#InputArea").text() == "" && $("#SearchArea").text() == ""){
			var ids = jqGridObj.jqGrid('getDataIDs');
			if(ids.length < 1) {
				alert("추가된 항목이 없습니다.");
				return false;	
			}
			
			//시리즈 체크 유무 판단.
			if(isSeriesChecked() == false){
				return false;
			}
			
			//Project Validation
			if($("#p_project").val() == ""){
				alert("Project를 입력하십시오.");
				return false;
			}
			//DWG_NO Validation
			if($("#p_dwgno").val() == ""){
				alert("도면번호를 입력하십시오.");
				return false;
			}
			
			$("input[name=p_nowpage]").val(1);
			
			//호선 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			var changeRows = [];
			getGridChangedData(jqGridObj,function(data) {
				
				changeRows = data;
				if (changeRows.length == 0) {
					alert("내용이 없습니다.");
					return false;
				}
				
				// Stage에서 필수값 해제(block_no, stage_no, str_flag, usc_job_type, job_cd)
				for(var i=0; i<changeRows.length; i++){
					syncClassByContainRow(jqGridObj, i, "block_no", '', false, 'required_cell');
					syncClassByContainRow(jqGridObj, i, "stage_no", '', false, 'required_cell');
					syncClassByContainRow(jqGridObj, i, "str_flag", '', false, 'required_cell');
					syncClassByContainRow(jqGridObj, i, "usc_job_type", '', false, 'required_cell');
					syncClassByContainRow(jqGridObj, i, "job_cd", '', false, 'required_cell');
				}
				
				$(".required_cell").each(function(){
					if($(this).text().trim() == ""){
						alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
						rtn = false;
						return false;
					}
				});
				
				if(!rtn){
					return false;
				}
				
				var sURL = "sscItemAddStageSetting.do?p_series=" + ar_series
						+ "&p_project_no=" + $("input[name=p_project_no]").val()
						+ "&p_dwg_no="+$("input[name=p_dwg_no]").val() 
						+ "&p_item_type_cd="+$("input[name=p_item_type_cd]").val();
				
				var popOptions = "dialogWidth: 730px; dialogHeight: 500px; center: yes; resizable: yes; status: no; scroll: yes;"; 
				var rs = window.showModalDialog(sURL, window, popOptions);
				
				//$( jqGridObj).jqGrid( "clearGridData" );
				var rows = jqGridObj.jqGrid('getDataIDs');
				var vItemGroup = 0;
				if( rs != null ) {
					
					for ( var idx = 0; idx < rows.length; idx++ ) {
						
						vItemGroup++;
						
						for(i=0; i< rs.length; i++) {
							
							var item = {};
							
							for(var j=0; j<gridColModel.length; j++ ){
								//if(gridColModel[j].hidden != true){
				
									if(gridColModel[j].name == 'project_no') {
										item.project_no = rs[i].project_no;
									} else if(gridColModel[j].name == 'dwg_no') {
										item.dwg_no = rs[i].dwg_no;
									} else if(gridColModel[j].name == 'block_no') {
										item.block_no = rs[i].block_no;
									} else if(gridColModel[j].name == 'stage_no') {
										item.stage_no = rs[i].stage_no;
									} else if(gridColModel[j].name == 'str_flag') {
										item.str_flag = rs[i].str_flag;
									} else if(gridColModel[j].name == 'usc_job_type') {
										item.usc_job_type = rs[i].usc_job_type;
									} else if(gridColModel[j].name == 'job_cd') {
										item.job_cd = rs[i].job_cd;
									} else if(gridColModel[j].name == 'job_state') {
										item.job_state = rs[i].job_state;
									} else {
										item[gridColModel[j].name] = jqGridObj.jqGrid('getCell', rows[idx], gridColModel[j].name);
									}
									
									item["oper"] = "I";
									item["item_group"] = vItemGroup;
								//}
							}
							//merge
							//alert(JSON.stringify(item));
							jqGridObj.jqGrid("addRowData", i+1, item, 'last');
						}
						jqGridObj.jqGrid('delRowData', rows[idx]);
					}
				}
				
			});
			
			jqGridObj.saveCell(kRow, idCol );
			
			if($("#NextCheck").val() == 'Next') {
				stageNextClick();
			} else {
				return false;
			}
			
		});
		
		//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
		$("#btnAdd").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
			// 첫 행 구함.
			var ids = jqGridObj.jqGrid('getDataIDs');
            //get first id
            var cl = ids[ids.length-1];
            var rowData = jqGridObj.getRowData(cl);

            var item = {};
			var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
			var item_type_cd = $("input[name=p_item_type_cd]").val();
			
			for ( var i in colModel )
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.master_ship = $( "input[name=p_master_no]" ).val();
			item.dwg_no = $( "input[name=p_dwg_no]" ).val();
			var vJobCd = $("input[name=p_in_job_cd]").val();
			
			if(vJobCd == ""){
				vJobCd = rowData['job_cd'];
			}
			
			//첫행에 받은 정보들을 다음 행에 복사
			item.block_no = rowData['block_no'];
			item.stage_no = rowData['stage_no'];
			item.str_flag = rowData['str_flag'];
			item.usc_job_type = rowData['usc_job_type'];
			item.job_cd = vJobCd;
			
			if(item_type_cd == "VA"){
				item.supply_type = "N";
				item.bom_qty = "1";
			}
			else if(item_type_cd == "CA"){
				item.bom_qty = "1";
			} else if(item_type_cd == "PI") {
				item.bom_qty = "1";
			}
			
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
			
			//Total 수량 출력
			totalEaAction();
		});
		
		//del 버튼  클릭
		$("#btnDel").click(function(){
		
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
			//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
			var row_len = row_id.length;					
			
			for(var i=0; i<row_len; i++){
				jqGridObj.jqGrid('delRowData',row_id[0]);
			}
			
			//Total 수량 출력
			totalEaAction();
			
		});
		
		//Next 클릭
		$("#btnNext").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
 			
			//Body에 ProjectNo가 있으면 시리즈 Validation 제외
			
			//시리즈 체크 유무 판단.
			if(isSeriesChecked() == false){
				return false;
			}
		    
			var rows = jqGridObj.getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				if( jqGridObj.getCell( rows[i], 'job_cd') == "선택" ){
					alert("선택하지 않은 JOB 항목이 있습니다.");
					return;
				}
			}
			
			var item_type_cd = $("input[name=p_item_type_cd]").val();
			var formData = fn_getFormData('#application_form');
			
			if($("#stepState").val() == "1"){
				var changeRows = [];
				var rtn = true;
				
				getGridChangedData(jqGridObj,function(data) {
					changeRows = data;
					if (changeRows.length == 0) {
						alert("내용이 없습니다.");
						return;
					}
					
					$(".required_cell").each(function(){
						
						if($(this).text().trim() == ""){
							alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
							$(this).context.style.backgroundColor = "#ff9999";
							rtn = false;
							return false;
						}
						else{
							$(this).context.style.backgroundColor = "#F7FC96";
						}
					});
					
					$(".required_cell edit-cell ui-state-highlight").each(function(){
						if($(this).text().trim() == ""){
							alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
							$(this).context.style.backgroundColor = "#ff9999";
							rtn = false;
							return false;
						}
						else{
							$(this).context.style.backgroundColor = "#F7FC96";
						}
					});
					
					if(!rtn){
						return false;
					}
					
					if(item_type_cd == 'SU' || item_type_cd == 'OU' || item_type_cd == 'SE' || item_type_cd == 'TR' || item_type_cd == 'CA'){
						var result = 0;
						for(var i=0; i<rows.length; i++){
							var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
							if(item_type_cd == 'SU'){
								result += fnChkByte(item.key_no, 30);
								result += fnChkByte(item.item_weight, 30);
								result += fnChkByte(item.attr02, 30);
								result += fnChkByte(item.attr04, 30);
							}else if(item_type_cd == 'OU'){
								result += fnChkByte(item.attr01, 30);
							}else if(item_type_cd == 'SE'){
								result += fnChkByte(item.key_no, 30);
								result += fnChkByte(item.temp01, 30);
								result += fnChkByte(item.temp03, 30);
							}else if(item_type_cd == 'TR'){
								result += fnChkByte(item.key_no, 30);
								result += fnChkByte(item.temp01, 30);
								result += fnChkByte(item.temp02, 30);
							}else if(item_type_cd == 'CA'){
								result += fnChkByte(item.attr01, 30);
								result += fnChkByte(item.attr02, 30);
								result += fnChkByte(item.attr03, 30);
							}
							
							if(result != 0){
								return false;
							}
						}
					}
					
					
					//시리즈 배열 받음
					var ar_series = new Array();
					for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
						ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
					}
					
					//back버튼 클릭시 필요한 리스트
					backList = changeRows;
					
					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var parameters = $.extend({}, dataList, formData);

					$(".loadingBoxArea").show();
					$("input[name=p_isPaging]").val("Y");
				
					//검색 시 스크롤 깨짐현상 해결
					jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
					getJsonAjaxFrom("sscAddValidationCheck.do?p_chk_series="+ar_series ,parameters,null,callback_next);
					
				});

			}else if($("#stepState").val() == "2"){
				
				//프로세스가 NO 이면 진행 불가
				if(!chkgridProcess()){
					return false;
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);

				$(".loadingBoxArea").show();
				$("input[name=p_isPaging]").val("Y");
				
				//검색 시 스크롤 깨짐현상 해결
				jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
				
				getJsonAjaxFrom("sscAddItemCreate.do",parameters,null,callback_next);
				
			}else if($("#stepState").val() == "3"){
				
				//프로세스가 NO 이면 진행 불가
				if(!chkgridProcess()){
					return false;
				}
				
				//승인 로직
				if(confirm('적용하시겠습니까?')){
					$(".loadingBoxArea").show();
					$.post("sscAddApplyAction.do",formData ,function(data){
	 							$(".loadingBoxArea").hide();
	 							alert(data.resultMsg);
	 							$("#btnClose").click();
	 						},"json");
				}
				
			}
			
		});
		
		function fnChkByte(obj, maxByte){

			var str = obj;
			var str_len = str.length;

			var rbyte = 0;
			var rlen = 0;
			var one_char = "";
			var str2 = "";

			for(var i=0; i<str_len; i++){

				one_char = str.charAt(i).charCodeAt(0);                               

				if (one_char <= 0x00007F) {
					rbyte += 1; 
				} else if (one_char <= 0x0007FF) {
					rbyte += 2; 
				} else if (one_char <= 0x00FFFF) {
					rbyte += 3;
				} else {
					rbyte += 4;
				}

				if(rbyte <= maxByte){
					rlen = i+1;                                         //return할 문자열 갯수
				}
	
			}

			if(rbyte > maxByte){
				alert("한글 "+(maxByte/3)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.\n최대 자릿수 " + maxByte + "Byte 이하 입력 제약입니다.(현재 입력 : " + rbyte + "Byte)");
				str2 = str.substr(0,rlen);                                  //문자열 자르기
				obj.value = str2;
				//fnChkByte(obj, maxByte);
				return 1;
			} else{
				return 0;
				//document.getElementById('byteInfo').innerText = rbyte;
			}

		}
		
		//Excel Import 클릭
		$("#btnExlImp").click(function(){
			
			//$("#p_excel").val("Y");
			
			var sURL = "popUpSscAddExcelImport.do";
			var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
			
			//팝업 주석 처리
			//var popOptions = "width=400, height=100, resizable=no, status=no, menubar=no, toolbar=no, scrollbars=no, location=no"
			//window.open(sURL,'ExlImpPopup', popOptions).focus();
			
			//Total 수량 출력
			totalEaAction();
			jqGridObj.saveCell(kRow, idCol );
			
			var itemtype = $("input[name=p_item_type_cd]").val();
			
			if(itemtype != "OU") {
				//필수값 체크(key_no 입력체크)
				var row_id = jqGridObj.getDataIDs();
				for(var i=0; i<row_id.length; i++){
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
					if(item.attr01 != "") cellAttrUniqAction(row_id[i], "attr01", item.attr01, i);
				}
				
				//필수값 체크(item_code 입력체크)
				setAllEditColumn();
			}
			
		});
		
		//Excel Form 클릭 다운로드	
		$("#btnForm").click(function(){
			var itemtype = $("input[name=p_item_type_cd]").val();
			$.download('fileDownload.do?fileName=SSCExcelImportFormat'+itemtype+'.xls',null,'post');
		});
	
		//Back 기능
		$("#btnBack").click(function(){
			
			var jsonGridData = new Array();
			var itemtype = $("input[name=p_item_type_cd]").val();
			
			if(confirm('뒤로 돌아가시겠습니까?')){	
				$( jqGridObj).jqGrid( "clearGridData" );
				
					for ( var i = 0; i < backList.length; i++ ) {
						if(itemtype == "EQ") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , item_desc : backList[i].item_desc
					             , bom_qty : backList[i].bom_qty
					             , temp01 : backList[i].temp01
					             , temp02 : backList[i].temp02
					             , temp03 : backList[i].temp03
					             , rev_no : backList[i].rev_no
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "PI") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , attr13 : backList[i].attr13
					             , bom_qty : backList[i].bom_qty
					             , item_weight : backList[i].item_weight
					             , attr01 : backList[i].attr01
					             , attr02 : backList[i].attr02
					             , attr03 : backList[i].attr03
					             , attr04 : backList[i].attr04
					             , attr05 : backList[i].attr05
					             , attr06 : backList[i].attr06
					             , attr07 : backList[i].attr07
					             , attr08 : backList[i].attr08
					             , attr09 : backList[i].attr09
					             , attr10 : backList[i].attr10
					             , attr11 : backList[i].attr11
					             , attr12 : backList[i].attr12
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "CA") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , attr01 : backList[i].attr01
					             , bom_qty : backList[i].bom_qty             
					             , attr02 : backList[i].attr02
					             , temp01 : backList[i].temp01
					             , attr03 : backList[i].attr03
					             , item_weight : backList[i].item_weight
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "GE") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_item_desc : backList[i].buy_mother_item_desc
					             , buy_mother_item_weight : backList[i].buy_mother_item_weight
					             , item_code : backList[i].item_code
					             , item_desc : backList[i].item_desc
					             , bom_qty : backList[i].bom_qty             
					             , item_weight : backList[i].item_weight
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "OU") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , attr01 : backList[i].attr01
					             , bom_qty : backList[i].bom_qty             
					             , item_weight : backList[i].item_weight
					             , bom_item_detail : backList[i].bom_item_detail
					             , paint_code1 : backList[i].paint_code1
					             , paint_code2 : backList[i].paint_code2
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "SE") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , item_category_code : backList[i].item_category_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty             
					             , item_weight : backList[i].item_weight
					             , temp01 : backList[i].temp01
					             , temp02 : backList[i].temp02
					             , paint_code1 : backList[i].paint_code1
					             , temp03 : backList[i].temp03
					             , temp04 : backList[i].temp04
					             , temp05 : backList[i].temp05
					             , rev_no : backList[i].rev_no
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "SU") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty             
					             , item_weight : backList[i].item_weight
					             , attr01 : backList[i].attr01
					             , attr02 : backList[i].attr02
					             , attr04 : backList[i].attr04
					             , paint_code1 : backList[i].paint_code1
					             , paint_code2 : backList[i].paint_code2
					             , rev_no : backList[i].rev_no
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "TR") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , item_category_code : backList[i].item_category_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty             
					             , item_weight : backList[i].item_weight
					             , temp01 : backList[i].temp01
					             , paint_code1 : backList[i].paint_code1
					             , temp02 : backList[i].temp02
					             , temp03 : backList[i].temp03
					             , rev_no : backList[i].rev_no
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						} else if(itemtype == "VA") {
							jsonGridData.push({state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , mother_code : backList[i].mother_code
					             , buy_mother_item_code : backList[i].buy_mother_item_code
					             , buy_mother_key_no : backList[i].buy_mother_key_no
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty             
					             , item_weight : backList[i].item_weight
					             , supply_type : backList[i].supply_type
					             , paint_code1 : backList[i].paint_code1
					             , temp01 : backList[i].temp01
					             , temp02 : backList[i].temp02
					             , temp03 : backList[i].temp03
					             , temp04 : backList[i].temp04
					             , temp05 : backList[i].temp05
					             , temp06 : backList[i].temp06
					             , temp07 : backList[i].temp07
					             , rev_no : backList[i].rev_no
					             , process : backList[i].process
					             , error_msg_project_no : backList[i].error_msg_project_no
					             , error_msg_dwg_no : backList[i].error_msg_dwg_no
					             , error_msg_block_no : backList[i].error_msg_block_no
					             , error_msg_stage_no : backList[i].error_msg_stage_no
					             , error_msg_str_flag : backList[i].error_msg_str_flag
					             , error_msg_job_cd : backList[i].error_msg_job_cd
					             , error_msg_buy_mother_item_code : backList[i].error_msg_buy_mother_item_code
					             , error_msg_mother_code : backList[i].error_msg_mother_code
					             , error_msg_item_code : backList[i].error_msg_item_code
					             , error_msg_bom_qty : backList[i].error_msg_bom_qty
					             , error_msg_item_weight : backList[i].error_msg_item_weight
					             , error_msg_key_no : backList[i].error_msg_key_no
					             , error_msg_01 : backList[i].error_msg_01
					             , error_msg_02 : backList[i].error_msg_02
					             , error_msg_03 : backList[i].error_msg_03
					             , error_msg_04 : backList[i].error_msg_04
					             , error_msg_05 : backList[i].error_msg_05
					             , error_msg_06 : backList[i].error_msg_06
					             , error_msg_07 : backList[i].error_msg_07
					             , error_msg_08 : backList[i].error_msg_08
					             , error_msg_09 : backList[i].error_msg_09
					             , error_msg_10 : backList[i].error_msg_10
					             , cad_sub_id : backList[i].cad_sub_id
					             , oper : backList[i].oper});
						}
					}
					
					jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
					callback_back();

					//BACK 했을때 ITEM_CODE 값이 있으면 속성값을 제거
					//ITEM_CODE 값이 없으면 ITEM_CODE 셀 비활성화
					var row_id = jqGridObj.getDataIDs();
					for(var i=0; i<row_id.length; i++){
						var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
						if(item.item_code != ""){
							cellItemCodeUniqAction(row_id[i], "", item.item_code, i);
						}
						else{
							if(itemtype == 'OU' || itemtype == 'CA'){
								cellAttrUniqAction(row_id[i], null, item.attr01, i);
							}else if(itemtype == 'TR'){
								cellAttrUniqAction(row_id[i], null, item.item_category_code, i);
							}else{
								cellAttrUniqAction(row_id[i], null, item.key_no, i);
							}
						}
					}
				}
			//검색 시 스크롤 깨짐현상 해결
			jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
		});
		
		$(document).keydown(function (e) { 
			
			if (e.keyCode == 27) { 
				e.preventDefault();
			} // esc 막기
			
			if(e.target.nodeName != "input" || e.target.nodeName != "textarea"){
				if(e.keyCode == 8) {
					return false;
				}
			}
			
		}); 
		
		
	});
	
// 	//Block, STR 입력 완료 시 job 코드 셋팅
// 	function getJobCode(rowId, block_no, str_flag){
// 		//그리드 내 콤보박스 바인딩
// 		$.ajax({			
// 			url : "sscGetJobCodeList.do?p_master_no="+$("input[name=p_master_no]").val()+"&p_block_no="+block_no.toUpperCase()+"&p_str_flag="+str_flag.toUpperCase(),
// 			async : false,
// 			cache : false, 
// 			dataType : "json",
// 			success : function(data){
// 				//select box 초기화
// 				jqGridObj.setColProp('job_cd', { editoptions: { value: false} });
// 				jqGridObj.setObject( {
// 					name  : 'job_cd',
// 					value : 'value',
// 					text  : 'text',
// 					data  : data
// 				} );
// 			}
// 		});		
// 	}
    
    function getDeliverySeriesCallback(){
    	$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
			var deliverySeries = data;
    		for(var i=0; i<$("input[name=p_series]").length; i++){
    			var id = $("input[name=p_series]")[i].id;
    			for(var j=0; j<deliverySeries.length; j++){
    				if($("input[name=p_series]")[i].id == "p_series_"+deliverySeries[j].project_no){
    					$("#" + id).attr("disabled", true); 
        				$("input:checkbox[id='"+id+"']").prop("checked", false);
        				break;
    				}
    				else{
    					$("#" + id).attr("disabled", false);
        				$("input:checkbox[id='"+id+"']").prop("checked", true);
    				}
    			}
    		}	
		},"json");
    }

	function setJobCode(rowId){

		jqGridObj.saveCell(kRow, idCol );
		
		//초기화
		//jqGridObj.jqGrid('setCell', rowId, 'job_cd', "&nbsp;");
		
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
		
// 		if(item.str_flag.toUpperCase() == 'IN') {
// 			alert("'IN'구조에는 생성할 수 없습니다. \n'IM' 또는 'IG'로 생성 바랍니다. ");
// 			jqGridObj.jqGrid('setCell', rowId, 'str_flag', '&nbsp;');
// 			return;
// 		}
		//속도 문제로 block No가 들어왔을 때만 실행.
		if(item.block_no != "" && item.str_flag != "") {

			if(item.usc_job_type == '') {
				item.usc_job_type = '';
			} else {
				item.usc_job_type = item.usc_job_type.toUpperCase();
			}
		    $.ajax({
				url : "sscGetJobCodeList.do?p_master_no="+$("input[name=p_master_no]").val()+"&p_block_no="+item.block_no.toUpperCase()
						+"&p_str_flag="+item.str_flag.toUpperCase()+"&p_usc_job_type="+item.usc_job_type+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val(),
				async : false,
				cache : false, 
				dataType : "json",
				success : function(data){
					if(data.length != 0){
						jqGridObj.jqGrid('setCell', rowId, 'usc_job_type', data[0].sb_value);
						jqGridObj.saveCell(kRow, idCol );
					}else{
						jqGridObj.jqGrid('setCell', rowId, 'usc_job_type', '&nbsp;');
						jqGridObj.saveCell(kRow, idCol );
					}
				}
			});
		}
		jqGridObj.saveCell(kRow, idCol );
	}
	
	// 모든 행 job 코드 구함
	// Tribon, Excel Import에서 사용
	function setAllJobCode(){
		var rows = jqGridObj.getDataIDs();
		if($("#p_excel").val() != 'Y') {
			for ( var i = 0; i < rows.length; i++ ) {
				setJobCode(rows[i]);
			}
		}
	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//BOM_QTY 수정 시 전체 수량 필드 변경 
		if(cellName == "bom_qty"){
			totalEaAction();
		}
		if(val == null) val = "";
		//입력 후 대문자로 변환
		jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
		
	}
	
	//모든 행 Edit Column 재세팅
	function setAllEditColumn(){
		var rows = jqGridObj.getDataIDs();		
		for ( var i = 0; i < rows.length; i++ ) {
			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );	
			cellItemCodeUniqAction(rows[i], "", item.item_code, i);
		}
	}
	
	
	//필수 입력 필드 조정
	//아이템 코드가 입력 되면 실행.
	//SE일 경우 표준품, 비표준품에 대한 필드가 구분되어야 함
	function cellItemCodeUniqAction(irow, cellName, cellValue, rowIdx){
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		var item_type_cd = $("input[name=p_item_type_cd]").val();
		//선택한 행의 rowIdx 구함
		if(typeof(rowIdx) == "undefined" && kRow > 0){
			rowIdx = kRow-1;
		}


		if(item_type_cd != "EQ"){
			var str = "";
			if(cellValue != undefined) {
				var str = cellValue.substring(0,1);
			}
			
			if(str == "T" || str == "t") {
				alert("SSC Equipment 에서만 T코드 입력이 가능합니다.");
				$("#" + kRow + "_item_code").val("");
				cellValue = "";
			}
		}

		//무조건 모든 행을 복구
		if(uniq_ColName != null){
 			for (var i=0; i<uniq_ColName.length; i++){
 				//컬럼 색상 변경 (필수값)
 				//jQuery(jqGridObj).setCell (irow, uniq_ColName[i],'', 'uniqCell');
 				syncClassByContainRow(jqGridObj, rowIdx, uniq_ColName[i],'', true, 'required_cell');
 				//컬럼 editable 설정 해제
	 			changeEditableByContainRow(jqGridObj, rowIdx, uniq_ColName[i],'',false);	
 			}
		}
		
		//아이템 코드가 있으면 필수 입력값 해제
		if(cellValue != ""){
			
			if(item_type_cd == "SE"){
				// Z가 0번째 자리에 있으면, 즉 비표준품이면	색 변경 및 Text Box 없앰
				if(cellValue.toUpperCase().indexOf("Z") != 0){ //표준품이면
					//표준품에서 남겨질 컬럼 배열에서 삭제 
					if(uniq_ColName[1] == "key_no"){
						uniq_ColName.splice(1, 1); //key_no의 index
					}
				}else{
					if(uniq_ColName[1] != "key_no"){
						uniq_ColName.splice(1, 0, 'key_no');
					}
				}
			}
			
			if(item_type_cd == "OU"){
				// Z가 0번째 자리에 있으면, 즉 비표준품이면	색 변경 및 Text Box 없앰
				if(cellValue.toUpperCase().indexOf("Z") != 0){ //표준품이면
					//표준품에서 남겨질 컬럼 배열에서 삭제 
					uniq_ColName = new Array("attr01", "item_weight", "paint_code1");
					if(uniq_ColName[0] == "attr01"){
						uniq_ColName.splice(0, 1); //key_no의 index
						syncClassByContainRow(jqGridObj, rowIdx, 'attr01','', false, 'required_cell');
						jqGridObj.setCell (irow, 'attr01','', {'background-color':'#F7FC96'});
						jqGridObj.setCell (irow, 'attr01','', '', {title : "해당 표준품은 MARK NO 선택입력"});
						
					}
				}else{//비표준
					if(uniq_ColName[1] != "attr01"){
						uniq_ColName.splice(0, 0, 'attr01');
						syncClassByContainRow(jqGridObj, rowIdx, 'attr01','', true, 'required_cell');
						jqGridObj.setCell (irow, 'attr01','', {'background-color':''});
						jqGridObj.setCell (irow, 'attr01','', '', {title : ""});
					}
				}
			}
			
			//아이템 코드가 입력 될때 비활성 대상 항목의 값을 제거
			if($("#stepState").val() == "1" && item.item_code.indexOf("1,999999") == -1 && item.item_code != ""){
				if(uniq_ColName != null){
					for (var i=0; i<uniq_ColName.length; i++){
						jqGridObj.jqGrid('setCell', irow, uniq_ColName[i], '&nbsp;');
					}
				}
			}
			
			//uniq_ColName(전역) : 필수 입력 값 배열로 세팅
			if(uniq_ColName != null){
	 			for (var i=0; i<uniq_ColName.length; i++){
	 				//컬럼 색상 변경
	 				//jQuery(jqGridObj).setCell (irow, uniq_ColName[i],'', 'notUniqCell');
	 				syncClassByContainRow(jqGridObj, rowIdx, uniq_ColName[i],'', false, 'required_cell');
	 				//컬럼 editable 설정
		 			changeEditableByContainRow(jqGridObj, rowIdx, uniq_ColName[i],'',true);	
	 			}
			}
 		}
		if(item_type_cd == "OU" && cellValue == "" && item.attr01 != ""){
			changeEditableByContainRow(jqGridObj, rowIdx, 'item_code','',true);
		}
		
		//TR일때 표준품이면 필수값 해제, 표준품이 아니면 필수값 지정
		if(item_type_cd == "TR"){
			
			var str = "";
			if(cellValue != undefined) {
				var str = cellValue.substring(0,1);
			}
			
			var catalog_code = "";
			var formData = fn_getFormData('#application_form');
			var count = 0;
			if(str == "1" || str == "2" || str == "3" || str == "4" || str == "5" || str == "9") {
				//표준품일떄 입력받은 아이템코드나 카탈로그가 5자리 이상이면 TRAY EA체크
				if(cellValue.length >= 5){
					for(var i=0; i<5; i++){
						catalog_code += cellValue[i];
					}
				}
				$.post("getCatalogDesign.do?catalog_code=" + catalog_code.toUpperCase() + "&design_code=TRAY EA", formData, function(data)
				{	
					if(data.cnt != "0"){
						syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', true, 'required_cell');
						jqGridObj.setCell (irow, 'key_no','', '', {title : "해당 표준품은 TRAY NO 필수입력"});
					}
					else{
						syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', false, 'required_cell');
						jqGridObj.setCell (irow, 'key_no','', {'background-color':'#F7FC96'});
						jqGridObj.setCell (irow, 'key_no','', '', {title : "해당 표준품은 TRAY NO 선택입력"});
					}
				},"json");		
			}
			else {
				syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', true, 'required_cell');
				jqGridObj.setCell (irow, 'key_no','', '', {title : "비표준품은 TRAY NO 필수입력"});
			}
		}
		
		//VA일때 VALVE NO. 필수값 지정
		if(item_type_cd == "VA"){
			var catalog_code = "";
			var formData = fn_getFormData('#application_form');
			var count = 0;

			if(cellValue.length >= 5 && $("#stepState").val() == "1"){
				for(var i=0; i<5; i++){
					catalog_code += cellValue[i];
				}

				$.post("getCatalogDesign.do?catalog_code=" + catalog_code.toUpperCase() + "&design_code=VALVE NO", formData, function(data)
				{	
					if(data.cnt != "0"){
						syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', true, 'required_cell');
						jqGridObj.setCell (irow, 'key_no','', '', {title : "해당 표준품은 VALVE NO 필수입력"});
					}
					else{
						syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', false, 'required_cell');
						jqGridObj.setCell (irow, 'key_no','', {'background-color':'#F7FC96'});
						jqGridObj.setCell (irow, 'key_no','', '', {title : "해당 표준품은 VALVE NO 선택입력"});
					}
				},"json");		
			}
		}
	}
	
	
	//필수 입력 필드 조정
	//다른 필드 값이 입력되면
	function cellAttrUniqAction(irow, cellName, cellValue, i){
		//jqGridObj.saveCell(kRow, idCol );
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		var item_type_cd = $("input[name=p_item_type_cd]").val();

		//선택한 행의 rowIdx 구함
		var rowIdx = kRow-1;
		if(typeof(i) != "undefined"){
			rowIdx = i;
		}
		//부가 속성 코드에 값이 들어오면 item code 비활성화	
		//모든 부가속성 값이 없으면 item code 비활성화
		var vFlag = false;
		if(uniq_ColName != null){
			if(cellValue != "" && cellValue != undefined){
				vFlag = true;
			}
		}

		if(vFlag){
			//컬럼 색상 변경 
			//jQuery(jqGridObj).setCell (irow, 'item_code','', noUniqCellBgColor);
			syncClassByContainRow(jqGridObj, rowIdx, 'item_code','', false,'required_cell');
			//컬럼 editable 설정
			changeEditableByContainRow(jqGridObj, rowIdx, 'item_code','',true);
		}else{
			//컬럼 색상 변경 (필수값)
			//jQuery(jqGridObj).setCell (irow, 'item_code','', uniqCellBgColor);
			syncClassByContainRow(jqGridObj, rowIdx, 'item_code','', true,'required_cell');
			//컬럼 editavle 설정 해제
			changeEditableByContainRow(jqGridObj, rowIdx, 'item_code','',false);
		}
	
		//TR일때 표준품이면 필수값 해제, 표준품이 아니면 필수값 지정
		if(item_type_cd == "TR"){
			
			var str = "";
			if(cellValue != undefined) {
				var str = cellValue.substring(0,1);
			}
			
			var catalog_code = "";
			var formData = fn_getFormData('#application_form');
			var count = 0;
			if(str == "1" || str == "2" || str == "3" || str == "4" || str == "5" || str == "9") {
				//표준품일떄 입력받은 아이템코드나 카탈로그가 5자리 이상이면 TRAY EA체크
				if(cellValue.length >= 5){
					for(var i=0; i<5; i++){
						catalog_code += cellValue[i];
					}
				}
				$.post("getCatalogDesign.do?catalog_code=" + catalog_code.toUpperCase() + "&design_code=TRAY EA", formData, function(data)
				{	
					if(data.cnt != "0"){
						syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', true, 'required_cell');
						changeEditableByContainRow(jqGridObj, rowIdx, 'bom_qty', item.bom_qty, true);
						jqGridObj.setCell (irow, 'key_no','', '', {title : "해당 표준품은 Tray No 필수입력"});
					}
					else{
						syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', false, 'required_cell');
						changeEditableByContainRow(jqGridObj, rowIdx, 'bom_qty',item.bom_qty,false);
						jqGridObj.setCell (irow, 'key_no','', {'background-color':'#F7FC96'});
						jqGridObj.setCell (irow, 'key_no','', '', {title : "해당 표준품은 Tray No 선택입력"});
					}
				},"json");		
			}
			else {
				syncClassByContainRow(jqGridObj, rowIdx, 'key_no','', true, 'required_cell');
				changeEditableByContainRow(jqGridObj, rowIdx, 'bom_qty',item.bom_qty,false);
				jqGridObj.setCell (irow, 'key_no','', '', {title : "비표준품은 Tray No 필수입력"});
			}
		}
	}
	
	//Series 체크 유무 validation
	var isSeriesChecked = function(){
		if($(".chkSeries:checked").length == 0){
			alert("적용 할 시리즈를 체크하십시오.");
			return false;
		}else{
			return true;
		}
	}
	
	//Next Validation
	var FieldValidation = function($obj){
		var rtn;
		$obj.each(function(){
			if(!$(this).is(":hidden")){
				if($(this).val() == ""){
					rtn = $(this);
					return false;
				}
			}
		});
		return rtn;
	}
	
	//CallBack Next 이후 버튼 상태 변경
	var callback_next = function(json){
		$("#btnBack").show();
		//Work Key 넘겨줌 
		$("input[name=p_work_key]").val(json.p_work_key);
		//그리드 초기화
		$( jqGridObj).jqGrid( "clearGridData" );
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : 'sscWorkValidationList.do',
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			rowNum : $('.ui-pg-selbox option:selected').val(),
			postData : fn_getFormData('#application_form'),
			cellEdit : false
		} ).trigger( "reloadGrid" );
		
		//그리드 초기화 이후 Select Box 해제 
		//jqGridObj.setColProp('job_cd', { editable : false, edittype : false });
		
		$("#btnStage").hide();
		
		$("#btnTribon").attr("disabled", "disabled");		
		$("#btnExlImp").attr("disabled", "disabled");		
		$("#btnAdd").attr("disabled", "disabled");		
		$("#btnDel").attr("disabled", "disabled");		
		$("#btnEms").attr("disabled", "disabled");
		$('#btnBuybuy').attr("disabled", "disabled");
		
		$("#SerieschkAll").attr("disabled", "disabled");		
		$("input[name=p_series]").attr("disabled", "disabled")
		$("select[name=p_selrev]").attr("disabled", "disabled")
		$("input[name=p_selrev]").attr("disabled", "disabled")

		//job 상태 확인
		if($("#stepState").val() == "1"){
			if((Number($("input[name=p_job_warning_cnt]").val())) > 0){
				if(!(confirm("JOB 상태가 [릴리즈됨,완료,마감]된 항목이 있습니다. 계속 진행하시겠습니까?"))){
					alert("데이터 확인 이후 Back 버튼을 이용하여 진행하십시오.");
				}
			}
		}
		
		if($("#stepState").val() == "1"){
			$("#stepState").val("2");
		}else if($("#stepState").val() == "2"){
			$("#stepState").val("3");
		}
		
		if($("#stepState").val() == "3"){
			$("#btnNext").attr("value", "APPLY");
			$("#btnBack").hide();
		}
		
		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
		
		$(".loadingBoxArea").hide();
	}
	
	var callback_back = function(){
		$(".loadingBoxArea").hide();
		$("#btnBack").hide();
		$("#btnStage").show();
		$("#stepState").val("1");
		$("input[name=p_selrev]").val("");
		
		$("#btnTribon").removeAttr("disabled");
		$("#btnExlImp").removeAttr("disabled");
		$("#btnAdd").removeAttr("disabled");
		$("#btnDel").removeAttr("disabled");
		$("#btnEms").removeAttr("disabled");
		$('#btnBuybuy').removeAttr("disabled");

		$("#SerieschkAll").removeAttr("disabled");
		$("input[name=p_series]").removeAttr("disabled");
		$("select[name=p_selrev]").removeAttr("disabled");
		$("input[name=p_selrev]").removeAttr("disabled");
		
		$("#AddPagingArea").text("");
		$("#btnNext").attr("value", "NEXT");
		
		if($("#NextCheck").val() == 'Next') {
			setTimeout(function(){
				jqGridObj.jqGrid("clearGridData");
			}, 300);
		}
		
		//Total 수량 출력
		totalEaAction();
		
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : '',
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData('#application_form'),
			cellEdit : true
		} ).trigger( "reloadGrid" );
		
		//검색 시 스크롤 효과 없애기
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
		
	}
	
	//ITEM Code 입력 시 발생 이벤트 : Circuit, Type, Length TextBox 숨김
	var evtItemCode = function(obj){
		var parentobj = $(obj).parent().parent();
		if($(obj).val() == ""){
			$(parentobj).find(".itemGroup").find("input").show();
		}else{
			$(parentobj).find(".itemGroup").find("input").hide();
		}
	}
	//ITEMCODE 입력 시 RAW Material의 MotherCode에 입력 	
	var evtMotherCode = function(obj){
		var parentNo = $(obj).parent().parent().attr("id").replace("tr_", "");
		
		$(".rawTr_"+parentNo).find("input[name=p_mothercode]").val($(obj).val().toUpperCase());
		$(".rawTr_"+parentNo).find(".classMother").text($(obj).val().toUpperCase());
	}
	
	
	//Block, Stage, Str 입력 시 Raw Material의 Block에 입력
	var evtUpperInput = function(obj){
		var parentNo = $(obj).parent().parent().attr("id").replace("tr_", "");
		$(".rawTr_"+parentNo).find("input[name="+$(obj).attr("name")+"]").val($(obj).val().toUpperCase());
	}
	
	//Block, Stage, Str 입력 시 MotherCode 입력 창 숨김
	var evtMotherCodeHide = function(obj){
	
		var bss = $(obj).parent().parent().find(".motherGroup").find("input[type=text]");
		var bss_val = true;
		for(var i=0; i < bss.length; i++){
			if($(bss[i]).val() != ""){
				bss_val = false;
			}
		}
		
		if(bss_val){
			$(obj).parent().parent().find("input[name=p_mothercode]").show();
		}else{
			$(obj).parent().parent().find("input[name=p_mothercode]").hide();
		}	
	}
		
	//Mothder Code 입력 시 Block, Stage, STR 입력 숨김
	var evtBlockHide = function(obj){
		if($(obj).val() == ""){
			$(obj).parent().parent().find(".motherGroup").find("input[type=text]").show();
		}else{
			$(obj).parent().parent().find(".motherGroup").find("input[type=text]").hide();
		}
		
		//$(obj).parent().parent().find(".motherGroup").find("inpdlfut[type=text]").hide();

	}
	
	//ITEM Code를 관련한 그 외  입력 시 발생 이벤트 : ITEM CODE TextBox 숨김
	var evtItemETC = function(obj){
		var parentobj = $(obj).parent().parent();
		var result = false;
		$(parentobj).find(".itemGroup").find("input").each(function(){
			if($(this).val() != ""){
				result = true;
			}
		});		
		
		if(result == true){
			$(parentobj).find("input[name=p_itemCode]").hide();
		}else{
			$(parentobj).find("input[name=p_itemCode]").show();
		}
	}
	
	//대문자 변경
	var evtUpper = function(obj){
		$(obj).val().toUpperCase();
	}
	
	//MotherGroup과 각 항목의 NO. 중복 체크로직임.
	var validationDuplicate = function(obj){
		var cnt = 0;
		var chkParentValue = "";
		var chkParentValueOther = "";
		
		//자기의 Mother_Code 결정Pram들 받아오기		
		$(obj).parent().parent().find(".motherGroup").find("input").each(function(){
			chkParentValue += $(this).val();
		});
		
		chkParentValue += $.trim($(obj).val());
		
		$("input[name="+$(obj).attr("name")+"]").each(function(){	
		
			chkParentValueOther = "";
			//모든 Mother_Code 결정Pram들 받아오기
			$(this).parent().parent().find(".motherGroup").find("input").each(function(){
				chkParentValueOther += $(this).val();
			});
			
			chkParentValueOther += $.trim($(this).val());
			
			if($.trim($(this).val()) != ""){
				if(chkParentValue == chkParentValueOther){
					cnt++;
				}
			}
		});
		if(cnt > 1){
			alert("동일 Stage에 "+$(obj).attr("alt")+"이(가) 중복입니다.");
			$(obj).val("");
			$(obj).focus();
		}
	}
	//MotherGroup Init 시 No정보를 초기화.
	var MotherGroupInit = function(obj, target){
		$(obj).parent().parent().find("input[name="+target+"]").val("");
	}
	
	//비표준품(Z)이면 Seat. NO 숨김
	var isStandardProcess = function(obj, target){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		var parentobj = $(obj).parent().parent();
		if($(obj).val().substring(0,1) == "Z"){
			$(parentobj).find("input[name="+target+"]").hide();
			$(parentobj).find(".standardGroup").find("input").show();
		}else if($(obj).val().substring(0,1) == ""){
			$(parentobj).find("input[name="+target+"]").show();				
			$(parentobj).find(".standardGroup").find("input").show();
			$(parentobj).find(".itemGroup").find("input").show();
		}else{
			$(parentobj).find("input[name="+target+"]").show();			
			$(parentobj).find(".standardGroup").find("input").hide();
		}
	}
	
	
	//Total 수량 계산
	function totalEaAction() {	
		var totalEa = 0;
		/* var bomQtyData = $.grep(jqGridObj.jqGrid('getRowData'), function(obj) {
			alert(obj.bom_qty);		
			return obj.bom_qty != ''; 
		});	 */
		var row_id = jqGridObj.getDataIDs();
		for(var i=0; i<row_id.length; i++) {
			
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
			totalEa += item.bom_qty * 1;
		}
		/* for(var i=0; i<bomQtyData.length; i++){
			totalEa += bomQtyData[i].bom_qty * 1;
		} */
		
		$("#totalEa").val(totalEa);
	}
	
	var chkSupplyValueToItem = function(itemRowId, ItemValue){	
		
		var vCatalog = ItemValue.toUpperCase();
		var item = jqGridObj.jqGrid( 'getRowData', itemRowId );
		
		var vTargetStr = item.str_flag;				
		
		if(vCatalog.indexOf("-") > 0){
			vCatalog = vCatalog.substring(0,vCatalog.indexOf("-"));
		}
		
		if(vTargetStr == "UN"){
			if(vCatalog == "1B101"
			|| vCatalog == "1B201"
			|| vCatalog == "1B301"
			|| vCatalog == "1B401"
			|| vCatalog == "1B501"
			|| vCatalog == "1B801"
			|| vCatalog == "1B902"
			|| vCatalog == "1BP08"
			|| vCatalog == "2AA01"
			|| vCatalog == "1A205"
			|| vCatalog == "2AD09"
			|| vCatalog == "3BK31"
			){
				jqGridObj.setCell (itemRowId, 'supply', 'N', '');
			}else{
				jqGridObj.setCell (itemRowId, 'supply', 'Y', '');
			}
		}else{
			jqGridObj.setCell (itemRowId, 'supply', 'N', '');
		}
	}
	
	var chkSupplyValueToValveNo = function(obj){	
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		var vValveNo = $(obj);
		var vTargetSupply = $(obj).parent().parent().find(".tdSupply").find("input[name=p_supply]");
		
		//해당 행의 Catalog를 구함.
		var vObjItemCode = $(obj).parent().parent().find(".tdItemCode").find("input[name=p_itemCode]").val();
		var vObjCatalog = "";
		if(vObjItemCode.indexOf("-") > 0){
			vObjCatalog = vObjItemCode.substring(0,vObjItemCode.indexOf("-"));
		}

		//부모 Valve품목 Search
		$("input[name=p_valveno]").each(function(){			
			//Valve No가 같으면 부모라 판단.
			if(vValveNo.val() == $(this).val() && $(this) != vValveNo){
				//부모열의 Item Code를 구함.
				var vItemCode = $(this).parent().parent().find(".tdItemCode").find("input[name=p_itemCode]").val();
				var vCatalog = "";
				if(vItemCode.indexOf("-") > 0){
					vCatalog = vItemCode.substring(0,vItemCode.indexOf("-"));
				}
				//alert(vCatalog);
				if((vCatalog == "Z5701" ||  vCatalog == "Z5702")
				&& (vObjCatalog != "Z5701" && vObjCatalog != "Z5702"))
				{
					$(vTargetSupply).val("Y");
					return false;
				}
			}
		});
	}
	
	//Process 필드가 NO인 것이 있으면 진행불가.
	var chkgridProcess = function(){
		
		var processData = $.grep(jqGridObj.jqGrid('getRowData'), function(obj) { 
			return obj.process == 'NO'; 
		});	
		
		if(processData.length > 0){
			alert("올바르지 않은 데이터가 있습니다. \n데이터를 확인하십시오.");
			return false;
		}else{
			return true;		
		}
	}
	
	//Search 초기화	
	var SearchInit =  function(){
		mode = "Search";
		$("#stepState").val("1");		
		$("#btnNext").attr("value", "NEXT");
		$("#InputArea").text("");
		$("#InputCheckArea").text("");	
		//$("#SearchArea").show();
		//$("#SearchCheckArea").text("");		
		$("#btnManager").removeAttr("disabled");
		$("#btnExlImp").removeAttr("disabled");	
		$("#btnAdd").removeAttr("disabled");	
		$("#btnDel").removeAttr("disabled");
		$("#btnBuybuy").removeAttr("disabled");
		
	}
	//Key IN 초기화
	var InputInit =  function(){
		mode = "Input";
		$("#stepState").val("1");
		$("#btnNext").attr("value", "NEXT");
		//$("#SearchArea").text("");
		//$("#SearchCheckArea").text("");
		$("#InputArea").show();
		$("#InputCheckArea").text("");	
		$("#btnManager").removeAttr("disabled");
		$("#btnExlImp").removeAttr("disabled");	
		$("#btnAdd").removeAttr("disabled");	
		$("#btnDel").removeAttr("disabled");
		$("#btnBuybuy").removeAttr("disabled");
	}	
	
	//TR일때 변경EA 자동입력
	function setChangeTray(rowId){
		jqGridObj.saveCell(kRow, idCol );
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
		var catalog_code = "";
		var formData = fn_getFormData('#application_form');
		var count = 0;

		//아이템코드 입력한 경우 앞5자리 카탈로그 추출
		if(item.item_code.length >= 5){
			for(var i=0; i<5; i++){
				catalog_code += item.item_code[i];
			}
		}
		//카탈로그 입력한 경우
		else{
			catalog_code = item.item_category_code;
		}
		
		$.post("getCatalogDesign.do?catalog_code=" + catalog_code + "&design_code=TRAY EA", formData, function(data)
		{	
			if(data.cnt != "0"){
				count = item.key_no.split(",").length;
				jqGridObj.saveCell(kRow, idCol );
				jqGridObj.jqGrid( 'setCell', rowId, 'bom_qty', count );
			}
		},"json");		
	}
	
	function stageNextClick() {
		jqGridObj.saveCell(kRow, idCol );
		var formData = fn_getFormData('#application_form');
		var changeRows = [];
		var vItemGroup = 0;
		
		getGridChangedData(jqGridObj,function(data) {
			changeRows = data;
			
			var dataList = { chmResultList : JSON.stringify(changeRows) };
			var parameters = $.extend({}, dataList, formData);
			
			$(".loadingBoxArea").show();
			$("input[name=p_isPaging]").val("Y");
			getJsonAjaxFrom("sscAddValidationCheckStage.do", parameters, null, callback_next);
		});
	}

	function excelImportType(){
		var row_id = jqGridObj.getDataIDs();
		for(var i=0; i<row_id.length; i++){
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
			if(item.usc_job_type == ""){
				setJobCode(row_id[i]);
			}
		}
	}
	
</script>
</body>

</html>
