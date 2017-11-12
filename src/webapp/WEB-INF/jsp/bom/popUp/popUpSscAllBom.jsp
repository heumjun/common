<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC ALL Bom</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

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
	.guide {
		float: right;
		font-size: 11px;
		color: #2a2a2a;
		margin-right: 40px;
	}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			SSC ALL Bom -
			<jsp:include page="../common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>필수입력사항</span>
		</div>
		
		<input type="hidden" name="p_item_type_cd" value="${p_item_type_cd}" />		
		<input type="hidden" name="p_chk_series" value="${p_chk_series}" />	
		<input type="hidden" name="p_dwg_no" value="${p_dwg_no}" />	
		<input type="hidden" name="p_block_no" value="${p_block_no}" />	
		<input type="hidden" name="p_stage_no" value="${p_stage_no}" />	
		<input type="hidden" name="p_str_flag" value="${p_str_flag}" />	
		<input type="hidden" name="p_attr1" value="${p_attr1}" />
		<input type="hidden" name="p_attr2" value="${p_attr2}" />
		<input type="hidden" name="p_attr5" value="${p_attr5}" />	
		<input type="hidden" name="p_desc_detail" value="${p_desc_detail}" />	
		<input type="hidden" name="p_dept_code" value="${p_dept_code}" />	
		<input type="hidden" name="p_mother_code" value="${p_mother_code}" />	
		<input type="hidden" name="p_item_code" value="${p_item_code}" />	
		<input type="hidden" name="p_start_date" value="${p_start_date}" />	
		<input type="hidden" name="p_end_date" value="${p_end_date}" />	
		<input type="hidden" name="p_state_flag" value="${p_state_flag}" />	
		<input type="hidden" name="p_is_eco" value="${p_is_eco}" />	
		<input type="hidden" name="p_release" value="${p_release}" />	
		<input type="hidden" name="p_piece_no" value="${p_piece_no}" />	
		<input type="hidden" name="p_upperaction" value="${p_upperaction}" />	
		<input type="hidden" name="p_job_status" value="${p_job_status}" />	
		
		<table class="searchArea conSearch">
		<col width="80"/>
		<col width="200"/>
		<col width="*"/>
			<tr>
				<th>ECO NO.</th>
				<td>
					<input type="text" name="p_eco_no" class="required" value="" style="width:70px;" />
					<input type="button" value="CREATE" id="btnCreateEco" class="btn_blue" style=" height:22px;"/>
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_red2" value="APPLY" id="btnApply"/>
						<input type="button" class="btn_blue" value="CLOSE" id="btnClose"/>
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
		<jsp:include page="../common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
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
	
	$(':input').each(function(index) {
		if($(this).val() == 'undefined') {
			$(this).val('');
		}
    });
	
	/* var parent_value = window.dialogArguments;
	$("input[name=p_item_type_cd]").val(parent_value.application_form.p_item_type_cd.value);
	$("input[name=p_chk_series]").val(parent_value.application_form.p_chk_series.value);
	$("input[name=p_dwg_no]").val(parent_value.application_form.p_dwg_no.value);
	$("input[name=p_block_no]").val(parent_value.application_form.p_block_no.value);
	$("input[name=p_stage_no]").val(parent_value.application_form.p_stage_no.value);
	$("input[name=p_str_flag]").val(parent_value.application_form.p_str_flag.value);
	$("input[name=p_attr1]").val(parent_value.application_form.p_attr1.value);
	$("input[name=p_desc_detail]").val(parent_value.application_form.p_desc_detail.value);
	$("input[name=p_dept_code]").val(parent_value.application_form.p_dept_code.value);
	$("input[name=p_mother_code]").val(parent_value.application_form.p_mother_code.value);
	$("input[name=p_item_code]").val(parent_value.application_form.p_item_code.value);
	$("input[name=p_start_date]").val(parent_value.application_form.p_start_date.value);
	$("input[name=p_end_date]").val(parent_value.application_form.p_end_date.value);
	$("input[name=p_state_flag]").val(parent_value.application_form.p_state_flag.value);
	$("input[name=p_is_eco]").val(parent_value.application_form.p_is_eco.value);
	$("input[name=p_release]").val(parent_value.application_form.p_release.value);
	$("input[name=p_upperaction]").val(parent_value.application_form.p_upperaction.value);
	$("input[name=p_job_status]").val(parent_value.application_form.p_job_status.value); */

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
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){
			//history.go(-1);
			self.close();
		});
		
		
		$("#btnECO").click(function(){
			var sUrl = "eco.do?menu_id=M00036";
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
			
			//BOM에 반영	
			if(confirm("ECO 적용하시겠습니까?")){
				$(".loadingBoxArea").show();
				$.post("sscAllBomApplyAction.do", formData, function(data)
				{	
					$(".loadingBoxArea").hide();
					alert(data.resultMsg);
					
					dialogArguments.fn_search();
					window.close();
				},"json");
			}
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
			if (e.keyCode == 27) { 
				e.preventDefault();
			} // esc 막기
			
			if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA"){
				if(e.keyCode == 8) {
					return false;
				}
			}
			
		}); 
	});
	
		
</script>
</body>

</html>
