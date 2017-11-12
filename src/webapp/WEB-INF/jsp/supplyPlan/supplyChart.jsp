<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>견적물량관리</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>

<style>
#chartdiv {
	width		: 100%;
	height		: 250px;
	font-size	: 11px;
}				
input[type=text] {text-transform: uppercase;}	
</style>

<form name="application_form" id="application_form">
<div id="mainDiv" class="mainDiv">
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
<input type="hidden" id="loginId" name="loginId" value="${loginUser.user_id}"/>
<input type="hidden" id="supply_admin" name="supply_admin" value=""/>

<div class= "subtitle">
견적물량관리
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
 
	<table class="searchArea conSearch" >
		<col width="60">
		<col width="100">
		<col width="60">
		<col width="200">
		<col width="60">
		<col width="200">
		<col width="*">

		<tr>
			<th>PROJECT</th>
			<td>
				<input type="text" id="p_project_no" class="required" maxlength="5" name="p_project_no" alt="Project" style="width:70px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
			</td>
			
			<th>견적항목</th>
			<td>
				<select name="p_sel_join_data" id="p_sel_join_data" style="width:150px;" onchange="javascript:joinDataOnChange(this);" >
				</select>
				<input type="hidden" name="p_join_data" value=""  />
			</td>
			
			<th>직종</th>
			<td>
				<input type="text" id="p_group2" class="commonInput" name="p_group2" style="width:150px; text-align:center;" />
			</td>

			<td class="bdl_no" colspan="2">
				<div class="button endbox">
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="조 회"  id="btnSearch"  class="btn_blue"/>
						<input type="button" value="저 장"  id="btnSave"  class="btn_blue"/>
					</c:if>
				</div>
			</td>
		</tr>
		</table>
		
		<!-- <div class="chartDiv" id="chartdiv" style="display: none;"></div> -->
		
		<div class="content">
			<table id = "jqGridMainList"></table>
			<div   id = "bottomJqGridMainList"></div>
		</div>	
	</div>	
</form>

<script src="https://www.amcharts.com/lib/3/amcharts.js"></script>
<script src="https://www.amcharts.com/lib/3/serial.js"></script>
<script src="https://www.amcharts.com/lib/3/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="https://www.amcharts.com/lib/3/plugins/export/export.css" type="text/css" media="all" />
<script src="https://www.amcharts.com/lib/3/themes/light.js"></script>

<script type="text/javascript">

//그리드 사용 전역 변수
var idRow;
var idCol;
var kRow;
var kCol;
var row_selected = 0;
var jqGridObj = $("#jqGridMainList");
var chkcell = {cellId:undefined, chkval:undefined};
var precell = {cellId:undefined, chkval:undefined};

var gridColModel = new Array();
gridColModel.push({label:'견적항목', name:'join_data_desc', width:100, align:'center', sortable:false, title:false, cellattr:jsFormatterCell} );
gridColModel.push({label:'UOM', name:'uom', width:100, align:'center', sortable:false, title:false, cellattr:preFormatterCell} );
gridColModel.push({label:'직종', name:'group2', width:100, align:'center', sortable:false, title:false} );
gridColModel.push({label:'견적물량(A)', name:'estimate_supply', width:100, align:'center', sortable:false, title:false, editable:true} );
gridColModel.push({label:'사업계획물량(B)', name:'purpose_supply', width:100, align:'center', sortable:false, title:false} );
gridColModel.push({label:'설계목표물량(C)', name:'correspond_supply', width:100, align:'center', sortable:false, title:false, hidden:true} );
gridColModel.push({label:'목표율(C/B)', name:'correspond_per', width:100, align:'center', sortable:false, title:false, hidden:true} );
gridColModel.push({label:'실적물량(D)', name:'result_supply', width:100, align:'center', sortable:false, title:false} );
gridColModel.push({label:'계획달성율(D/B)', name:'purpose_per', width:100, align:'center', sortable:false, title:false} );
gridColModel.push({label:'목표달성율(D/C)', name:'result_per', width:100, align:'center', sortable:false, title:false, hidden:true} );
gridColModel.push({label:'project_no', name:'project_no', width:100, align:'center', sortable:false, title:false, hidden:true} );
gridColModel.push({label:'join_data', name:'join_data', width:100, align:'center', sortable:false, title:false, hidden:true} );
gridColModel.push({label:'dept_code', name:'dept_code', width:100, align:'center', sortable:false, title:false, hidden:true} );
gridColModel.push({label:'oper', name:'oper', width:25, align:'center', sortable:false, title:false, hidden:true} );

getAjaxHtml($("#p_sel_join_data"),"commonSelectBoxDataList.do?sb_type=sel&sd_type=SUPPLY_PLAN_TRACK&p_query=getSupplyChartJoinDataList", null, null);

$(document).ready(function(){
	
	// 접속권한에 따른 설정 
	$.post( "supplyManageLoginGubun.do", "", function( data ) {
		$("#supply_admin").val(data.supply_admin);
		if(data.supply_admin == 'N'){ 
			fn_buttonDisabled([ "#btnSave" ]); 
		}
	}, "json" );	
	
	var objectHeight = gridObjectHeight(1);
	
	jqGridObj.jqGrid({ 
        datatype: 'json',
        url:'',
        mtype : '',
        postData : fn_getFormData('#application_form'),
        colModel: gridColModel,
        gridview: true,
        viewrecords: true,
        autowidth: true,
        cellEdit : true,
        cellsubmit : 'clientArray', // grid edit mode 2
		scrollOffset : 17,
        multiselect: false,
        shrinkToFit: false,
        height: 460,
        pager: '#bottomJqGridMainList',
        rowList:[100,500,1000],
        rowNum:100, 
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
		gridComplete: function () {
			
			var rows = jqGridObj.getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				
				//미입력 영역 회색 표시
				//jqGridObj.jqGrid( 'setCell', rows[i], 'join_data_desc', '', { background : '#DADADA' } );
				//jqGridObj.jqGrid( 'setCell', rows[i], 'uom', '', { background : '#DADADA' } );
				//jqGridObj.jqGrid( 'setCell', rows[i], 'dept_name', '', { background : '#DADADA' } );
				
				jqGridObj.jqGrid( 'setCell', rows[i], 'estimate_supply', '', { background : '#F7FC96' } );
				jqGridObj.jqGrid( 'setCell', rows[i], 'purpose_supply', '', { background : '#DADADA' } );
				jqGridObj.jqGrid( 'setCell', rows[i], 'correspond_supply', '', { background : '#DADADA' } );
				jqGridObj.jqGrid( 'setCell', rows[i], 'correspond_per', '', { background : '#DADADA' } );
				jqGridObj.jqGrid( 'setCell', rows[i], 'result_supply', '', { background : '#DADADA' } );
				jqGridObj.jqGrid( 'setCell', rows[i], 'purpose_per', '', { background : '#DADADA' } );
				jqGridObj.jqGrid( 'setCell', rows[i], 'result_per', '', { background : '#DADADA' } );
				
				var totalCell = jqGridObj.getCell( rows[i], "group2" );
				if(totalCell == "TOTAL") {
					//$("#jqGridMainList tr").eq(rows[i]).children("td:eq(3)").attr("disabled", "disabled");
					jqGridObj.jqGrid( 'setCell', rows[i], 'group2', '', { background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'estimate_supply', '', { background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'estimate_supply', '', 'not-editable-cell' );
				}

			}
			
			var grid = this;
			$('td[name="cellRowspan"]', grid).each(function() {
				var spans = $('td[rowspanid="'+this.id+'"]',grid).length+1;
				if(spans > 1) {
					$(this).attr('rowspan', spans);
				} 
			});

		},
		onCellSelect : function( rowid, iCol, cellcontent, e ) {
			jqGridObj.saveCell(kRow, idCol );
			
			var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
		},
		afterSaveCell : chmResultEditEnd
	}); //end of jqGrid
	//grid resize
   fn_gridresize( $(window), jqGridObj, 120 );
	
	// 조회 버튼
	$("#btnSearch").click(function() {
		if(uniqeValidation()){
			fn_search();
		}
	});
	
	$("#btnSave").click(function() {
		
		fn_applyData("#jqGridMainList", kRow, kCol);
		
		var changeResultRows =  getChangedGridInfo("#jqGridMainList");
		
		/* if (!fn_checkPlanValidate(changePlanResultRows)) { 
			return;	
		} */
			
		// ERROR표시를 위한 ROWID 저장
		var ids = $("#jqGridMainList").jqGrid('getDataIDs');
		/* for(var  j = 0; j < ids.length; j++) {	
			//$('#planGrid').setCell(ids[j],'operId',ids[j]);
		} */
		
		var url			= "supplyChartSaveAction.do";
		var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
		var formData 	= fn_getFormData('#application_form');
		
		lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
		var parameters = $.extend({},dataList,formData);
				
		
	$.post(url, parameters, function(data) {

				lodingBox.remove();

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
			}, 'json').error(function() {
				alert('시스템 오류입니다.\n전산담당자에게 문의해주세요.');
			}).always(function() {
				lodingBox.remove();
				fn_search();
			});
		});

		//fn_buttonDisabledUser(userid, ["#btnSave","#btnRevisionAdd"]);
	}); //end of ready Function 	

	/***********************************************************************************************																
	 * 이벤트 함수 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	/*
	 function numFormatter(cellvalue, options, rowObject ) {
	 //if(cellvalue != 'undefined' && cellvalue != '') {
	
	 var txtNumber = '' + cellvalue;    // 입력된 값을 문자열 변수에 저장합니다.

	 if (isNaN(txtNumber) || txtNumber == "") {    // 숫자 형태의 값이 정상적으로 입력되었는지 확인합니다.
	 //alert("숫자만 입력 하세요");
	 return '';
	 } else {
	 var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');    // 정규식 형태 생성
	 var arrNumber = txtNumber.split('.');    // 입력받은 숫자를 . 기준으로 나눔. (정수부와 소수부분으로 분리)
	 arrNumber[0] += '.'; // 정수부 끝에 소수점 추가

	 do {
	 arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2'); // 정수부에서 rxSplit 패턴과 일치하는 부분을 찾아 replace 처리
	 } while (rxSplit.test(arrNumber[0])); // 정규식 패턴 rxSplit 가 정수부 내에 있는지 확인하고 있다면 true 반환. 루프 반복.

	 if (arrNumber.length > 1) { // txtNumber를 마침표(.)로 분리한 부분이 2개 이상이라면 (즉 소수점 부분도 있다면)
	 return arrNumber.join(''); // 배열을 그대로 합칩. (join 함수에 인자가 있으면 인자를 구분값으로 두고 합침)
	 } else { // txtNumber 길이가 1이라면 정수부만 있다는 의미.
	 return arrNumber[0].split('.')[0]; // 위에서 정수부 끝에 붙여준 마침표(.)를 그대로 제거함.
	 }
	 }
	 }

	 function perFormatter(cellvalue, options, rowObject ) {
	 //if(cellvalue != 'undefined' && cellvalue != '') {
	
	 var txtNumber = '' + cellvalue;    // 입력된 값을 문자열 변수에 저장합니다.

	 if (isNaN(txtNumber) || txtNumber == "") {    // 숫자 형태의 값이 정상적으로 입력되었는지 확인합니다.
	 //alert("숫자만 입력 하세요");
	 return '';
	 } else {
	 var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');    // 정규식 형태 생성
	 var arrNumber = txtNumber.split('.');    // 입력받은 숫자를 . 기준으로 나눔. (정수부와 소수부분으로 분리)
	 arrNumber[0] += '.'; // 정수부 끝에 소수점 추가

	 do {
	 arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2'); // 정수부에서 rxSplit 패턴과 일치하는 부분을 찾아 replace 처리
	 } while (rxSplit.test(arrNumber[0])); // 정규식 패턴 rxSplit 가 정수부 내에 있는지 확인하고 있다면 true 반환. 루프 반복.

	 if (arrNumber.length > 1) { // txtNumber를 마침표(.)로 분리한 부분이 2개 이상이라면 (즉 소수점 부분도 있다면)
	 return arrNumber.join('') + '%'; // 배열을 그대로 합칩. (join 함수에 인자가 있으면 인자를 구분값으로 두고 합침)
	 } else { // txtNumber 길이가 1이라면 정수부만 있다는 의미.
	 return arrNumber[0].split('.')[0] + '%'; // 위에서 정수부 끝에 붙여준 마침표(.)를 그대로 제거함.
	 }
	 }
	 }
	 */

	var joinDataOnChange = function(obj) {
		$("input[name=p_join_data]").val($(obj).find("option:selected").val());
		//$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
	}

	//afterSaveCell oper 값 지정
	function chmResultEditEnd(irow, cellName, val, iRow, iCol) {

		var item = jqGridObj.jqGrid('getRowData', irow);
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid("setRowData", irow, item);
		//$( "input.editable,select.editable", this ).attr( "editable", "0" );

		//입력 후 대문자로 변환
		jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
	}

	function jsFormatterCell(rowid, val, rowObject, cm, rdata) {
		var result = '';

		if (chkcell.chkval != val) {
			var cellId = this.id + '_row_' + rowid + '-' + cm.name;
			result = 'rowspan="1" id="' + cellId + '" + name="cellRowspan"';
			chkcell = {
				cellId : cellId,
				chkval : val
			};
		} else {
			result = 'style="display:none" rowspanid="' + chkcell.cellId + '"';
		}
		return result;
	}

	function preFormatterCell(rowid, val, rowObject, cm, rdata) {
		var result = '';
		var data = rowObject.join_data_desc;

		if (precell.chkval != data) {
			var cellId = this.id + '_row_' + rowid + '-' + cm.name;
			result = 'rowspan="1" id="' + cellId + '" + name="cellRowspan"';
			precell = {
				cellId : cellId,
				chkval : data
			};
		} else {
			result = 'style="display:none" rowspanid="' + precell.cellId + '"';
		}
		return result;
	}

	//그리드에 변경된 데이터Validation체크하는 함수	
	function fn_checkPlanValidate(arr1) {
		var result = true;
		var message = "";
		var ids;

		if (arr1.length == 0) {
			result = false;
			message = "변경된 내용이 없습니다.";
		}

		if (result && arr1.length > 0) {
			ids = $("#planGrid").jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {
				var oper = $("#planGrid").jqGrid('getCell', ids[i], 'oper');

				if (oper == 'I' || oper == 'U') {

					var val1 = $("#planGrid").jqGrid('getCell', ids[i], 'project_no');
					if ($.jgrid.isEmpty(val1)) {
						result = false;
						message = "Project No Field is required";

						setErrorFocus("#planGrid", ids[i], 1, 'project_no');
						break;
					}

				}
			}
		}

		if (!result) {
			alert(message);
		} else {
			if (confirm('변경된 데이터를 저장하시겠습니까?') == 0) {
				result = false;
			}
		}

		return result;
	}

	//그리드의 변경된 row만 가져오는 함수
	function getChangedGridInfo(gridId) {
		var changedData = $.grep($(gridId).jqGrid('getRowData'), function(obj) {
			return obj.oper == 'I' || obj.oper == 'U';
		});

		//changedData = changedData.concat(deleteData);	

		return changedData;
	}

	/***********************************************************************************************																
	 * 기능 함수 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/

	/***********************************************************************************************																
	 * 서비스 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/

	// 프로젝트 Plan 정보를 조회
	function fn_search() {
		fn_initPrevCellVal();
		var sUrl = "supplyChartList.do";
		jqGridObj.jqGrid("clearGridData");
		jqGridObj.jqGrid('setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData("#application_form")
		}).trigger("reloadGrid");
	}

	// Cell - Merge변수 초기화
	function fn_initPrevCellVal() {	
		chkcell = {cellId:undefined, chkval:undefined};
		precell = {cellId:undefined, chkval:undefined};
	}
	
	//필수 항목 Validation
	var uniqeValidation = function() {
		var rnt = true;
		$(".required").each(function() {
			if ($(this).val() == "") {
				$(this).focus();
				alert($(this).attr("alt") + "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}
</script>
</body>
</html>