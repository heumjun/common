<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>BuyBuy Bom Main</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.header  {height:20px; padding-top:10px;}
	.header .searchArea {position:relative; width:99%; height:20px;  margin-bottom:6px; }
	.header .searchArea .searchDetail{position:relative; float:left; height:30px; margin:0 0px 4px 0px; font-weight:bold; }
	.header .searchArea .commonInput{width:70px; text-align:center;}
	.header .searchArea .uniqInput {background-color:#FFE0C0;}
	.header .searchArea .readonlyInput {background-color:#D9D9D9;}

	.header .searchArea .buttonArea1{position:relative; float:right; width:30%; text-align:right; }	
	.header .searchArea .buttonArea1 input{width:70px; height:22px; }

	/*.itemInput {text-transform: uppercase;} */
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
	.header .searchArea .buttonArea #btnForm{float:left;}
	.uniqCell{background-color:#F7FC96}
	
	.subButtonArea input{border:1px solid #888; background-color:#B2C3F2; margin-bottom:4px; width:66px; }
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			BUY-BUY Bom
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_isPaging" value="" />
		<input type="hidden" name="p_master_no" value="${p_master_no}" />
		<input type="hidden" name="p_item_type_cd" value="${p_item_type_cd}" />		
		<input type="hidden" name="p_row_standard" value="" />		
		<input type="hidden" name="p_ssc_sub_id" value="${p_ssc_sub_id}" />
		<input type="hidden" name="p_dept_code" value="${p_dept_code}" />
		<input type="hidden" name="bomType" value="${bomType}" />
		<input type="hidden" name="p_dwg_no" value="${p_dwg_no}" />
		<input type="hidden" id="p_arrDistinct" name="p_arrDistinct" value="${p_arrDistinct}" />	
		<table class="searchArea conSearch">
		<col width="60"/>
		<col width="180"/>
		<col width="*"/>
			<tr>
				<th>ECO NO.</th>
				<td>
					<input type="text" name="p_eco_no" class="required" value="" style="width:70px;" />
					<input type="button" value="CREATE" id="btnCreateEco" class="btn_blue2" style=" height:22px;"/>
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_red2" value="APPLY" id="btnApply"/>
						<input type="button" class="btn_blue2" value="CLOSE" id="btnClose"/>
					</div>
					<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
				</td>
			</tr>
		</table>
		<div class="content">
			<table id="jqGridBomMainList"></table>
			<div id="bottomJqGridBomMainList"></div>
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
	var usc_chag_flag = "";
	var menuId = '';
	
	//필수 입력 값의 배경 색 지정
	var jqGridObj = $("#jqGridBomMainList");
	
	$(document).ready(function(){	
		
		var vAble = "";
		
		$("input[name=p_usc_chg_flag]").each(function(){
			if($(this).val() == "Y"){
				vAble = "disabled='disabled'";	
				usc_chag_flag = "Y";
				return;							
			}
		});
		
		var vItemTypeCd = $("input[name=p_item_type_cd]").val();

		var gridColModel = new Array();

		//그리드 기본 셋팅 
		gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:100, align:'center', sortable:true, title:false, hidden:true} );
		gridColModel.push({label:'STATE', name:'state_flag', width:60, align:'center', sortable:true, title:false} );
		//gridColModel.push({label:'MASTER', name:'master_ship', width:50, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'PROJECT', name:'project_no', width:70, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'DWG NO.', name:'dwg_no', width:110, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'ITEM CODE', name:'item_code', width:120, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'DESCRIPTION', name:'item_desc', width:300, align:'left', sortable:true} );
		gridColModel.push({label:'EA', name:'ea', width:80, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'WEIGHT', name:'item_weight', width:80, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'OPER', name:'oper', hidden:true } );
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'sscBuyBuyBomList.do',
            postData : fn_getFormData('#application_form'),
            mtype : 'POST',
            colModel: gridColModel,
            gridview: true,
            viewrecords: true,
            rownumbers:false,
            autowidth: true,
            cellEdit : false,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: false,
            shrinkToFit : false,
            height: 560,
            //pager: '#bottomJqGridBomMainList',
            //rowList:[100,500,1000],
	        rowNum:99999, 
	        recordtext: '내용 {0} - {1}, 전체 {2}',
       	 	emptyrecords:'조회 내역 없음',
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	idRow = rowid;
            	idCol = iCol;
            	kRow  = iRow;
            	kCol  = iCol;
            }	       
			,
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
				row_selected = rowid;
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj );
    	
	    var jsonGridData = new Array();
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){
			history.go(-1);
		});
		
		
		$("#btnECO").click(function(){
			
			//메뉴ID를 가져오는 공통함수 
			getMenuId("eco.do", callback_MenuId);
			
			var sUrl = "eco.do?menu_id=" + menuId;
			window.open( sUrl, "popCreateEco", "width=1500 height=750 toolbar=no menubar=no location=no" ).focus();
		});
		
		//Next 클릭
		$("#btnApply").click(function(){

			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			

			if($("input[name=p_eco_no]").val() == ""){
				alert("ECO No를 입력해주십시오.");
				return false;
			}
			
			var rtn = ecoCheck($("input[name=p_eco_no]"), '7');
			if(!rtn){
				return false;
			}
			
			var formData = fn_getFormData('#application_form');
			var changeRows = [];
			
			//그리드의 내용을 받는다.
			getGridChangedData(jqGridObj,function(data) {
				changeRows = data;
				
				if (changeRows.length == 0) {
					alert("내용이 없습니다.");
					return;
				}
				
				/* var row_id = '';
				if($("input[name=bomType]").val() == 'ALL') {
					row_id = jqGridObj.jqGrid('getDataIDs');
				} else {
					row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
					if(row_id == ""){
						alert("행을 선택하십시오.");
						return false;
					}
				} */
				
				var row_id = jqGridObj.jqGrid('getDataIDs');
				
				var ssc_sub_id = new Array();
				for(var i=0; i<row_id.length; i++){
					
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
					
					ssc_sub_id.push(item.ssc_sub_id);
				}
				
				//BOM에 반영	
				if(confirm("ECO 적용하시겠습니까?")){

					$(".loadingBoxArea").show();
					$.post("sscBomApplyAction.do?ssc_sub_id="+ssc_sub_id, formData, function(data)
					{	
						$(".loadingBoxArea").hide();
						alert(data.resultMsg);
						$("#btnClose").click();
					},"json");
				}
			});
		});	
		
		
		//ECO 추가
		$( "#btnCreateEco" ).click( function() {
			var dialog = $( '<p>ECO를 연결합니다.</p>' ).dialog( {
				buttons : {
					"SEARCH" : function() {
						//var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupECORelated&save=bomAddEco&ecotype=5&menu_id=${menu_id}",
						var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
								window,
								"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off" );

						if( rs != null ) {
							$( "input[name=p_eco_no]" ).val( rs[0] );
							/* $( "#eco_main_name" ).val( rs[1] ); */
							//$( "#eco_states_desc" ).val( rs[2] );
						}

						dialog.dialog( 'close' );
					},
// 					"생성" : function() {
						
// 						var sUrl = "eco.do?popupDiv=bomAddEco&popup_type=PAINT&menu_id=M00036";

// 						var rs = window.showModalDialog(sUrl,
// 								window,
// 								"dialogWidth:1200px; dialogHeight:500px; center:on; scroll:off; states:off");
// 						if( rs != null ) {
// 							$( "input[name=p_eco_no]" ).val( rs[0] );
// 							/* $( "#eco_main_name" ).val( rs[0] ); */
// 						}
// 						dialog.dialog( 'close' );
// 					},
					"CREATE" : function() {
						var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=&mainType=ECO",
								"ECONO",
								"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
						if( rs != null ) {
							$( "input[name=p_eco_no]" ).val( rs[0] );
						}
						dialog.dialog( 'close' );
					},
					"CANCEL" : function() {
						dialog.dialog( 'close' );
					}
				}
			} );
		});
			
			
			
		$(document).keydown(function (e) { 
			if (e.keyCode == 27 || e.keyCode == 8) { 
				e.preventDefault();
			} // esc 막기
		}); 
	});
		
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
		
</script>
</body>

</html>
