<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%
	String p_buy_item_code = getCheckReqXSS(request, "p_buy_item_code", "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>After Info</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">

.sub_tit {
	font-size:9pt;
	padding-left:10px;
	margin:10px 0 10px 0;
	font-weight:bold;
	vertical-align:middle;
}
table.detailArea {
	position: relative;
	margin-top: 5px;
	margin-bottom: 1px;
	border-left: 1px solid #d6ddee;
	border-right: 1px solid #d6ddee;
	border-bottom: 1px solid #d6ddee;
	border-collapse: collapse;
}
table.detailArea th {
	font-size: 11px;
	height: 20px;
	color: #324877;
	padding: 5px 0 5px 10px;
	border-top: 1px solid #d6ddee;
	border-left: 1px solid #d6ddee;
	background: #f7f7f7;
	text-align: center;
}

table.detailArea td {
	font-size: 11px;
	height: 20px;
	padding: 5px 0 5px 10px;
	border-top: 1px solid #d6ddee;
	border-left: 1px solid #d6ddee;
	letter-spacing: -0.05em;
	text-align: center;
}
</style>
</head>
<body>
	<form id="application_form" name="application_form" >
		<input type="hidden" name="p_ssc_sub_id" value="${p_ssc_sub_id}" />
		<input type="hidden" name="p_item_type_cd" value="${p_item_type_cd}" />
		<input type="hidden" name="p_buy_item_code" value="<%=p_buy_item_code %>" />
		<input type="hidden" name="p_level" value="${p_level}" />
		
		<div id="wrap">
			<div class="ex_upload">● After Information</div>
			<div class="sub_tit">□ SSC 정보</div> 
			<table id="item_detail" class="detailArea conSearch">
				<tr>
					<th>PROJECT</th>					
					<th>DWG NO.</th>
					<th>BLOCK</th>
					<th>STAGE</th>
					<th>STR</th>
					<th>TYPE</th>
					<th>JOB ITEM</th>
					<th>PENDING</th>
					<th>ITEM CODE</th>
					<c:if test="${p_item_type_cd == 'PI'}">
						<th>PIECE NO</th>
					</c:if>
					<c:if test="${p_item_type_cd == 'SU'}">
						<th>SUP NO</th>
					</c:if>
					<c:if test="${p_item_type_cd == 'VA'}">
						<th>VALVE NO</th>
					</c:if>
					<c:if test="${p_item_type_cd == 'OU'}">
						<th>MARK NO</th>
					</c:if>
					<c:if test="${p_item_type_cd == 'SE'}">
						<th>SEAT NO</th>
					</c:if>
					<c:if test="${p_item_type_cd == 'TR'}">
						<th>TRAY NO</th>
					</c:if>
					<th>EA</th>
					<th>Weight</th>
					<th>ECO NO.</th>
					<th>RELEASE</th>
				</tr>
				<tr>
					<td>${afterInfo.project_no}</td>
					<td>${afterInfo.dwg_no}</td>
					<td>${afterInfo.block_no}</td>
					<td>${afterInfo.stage_no}</td>
					<td>${afterInfo.str_flag}</td>
					<td>${afterInfo.usc_job_type}</td>
					<td>${afterInfo.job_cd}</td>
					<td>${afterInfo.mother_code}</td>
					<td>${afterInfo.item_code}</td>
					<c:if test="${p_item_type_cd == 'PI' || p_item_type_cd == 'SU' || p_item_type_cd == 'VA' || p_item_type_cd == 'OU' || p_item_type_cd == 'SE' || p_item_type_cd == 'TR'}">
						<td>${afterInfo.key_no}</td>
					</c:if>
					<td>${afterInfo.bom_qty}</td>
					<td>${afterInfo.item_weight}</td>
					<td>${afterInfo.eco_no}</td>
					<td>${afterInfo.release_desc}</td>
				</tr>
			</table>
			<c:if test="${p_item_type_cd == 'PI'}">
				<table id="item_detail" class="detailArea conSearch">
					<tr>
						<th>관경</th>					
						<th>재질</th>
						<th>SCH</th>
						<th>TYPE</th>
						<th>급관</th>
						<th>형태</th>
						<th>압력</th>
						<th>외부</th>
						<th>내부</th>
						<th>RT/CD</th>
						<th>CERT</th>
						<th>NDT</th>
					</tr>
					<tr>
						<td>${afterInfo.attr1}</td>
						<td>${afterInfo.attr2}</td>
						<td>${afterInfo.attr3}</td>
						<td>${afterInfo.attr4}</td>
						<td>${afterInfo.attr5}</td>
						<td>${afterInfo.attr6}</td>
						<td>${afterInfo.attr7}</td>
						<td>${afterInfo.attr8}</td>
						<td>${afterInfo.attr9}</td>
						<td>${afterInfo.attr10}</td>
						<td>${afterInfo.attr11}</td>
						<td>${afterInfo.attr12}</td>
					</tr>
				</table>
			</c:if>
			<c:if test="${p_item_type_cd == 'VA'}">
				<table id="item_detail" class="detailArea conSearch">
					<tr>
						<th>CLASS</th>					
						<th>PRESS</th>
						<th>N.D(A)</th>
						<th>BODY MAT'L</th>
						<th>SEAT MAT'L</th>
						<th>COAT IN</th>
						<th>COAT OUT</th>
						<th>L/NAMEPLATE</th>
						<th>TYPE1</th>
						<th>TYPE2</th>
						<th>POSITION</th>
					</tr>
					<tr>
						<td>${afterInfo.valve_class}</td>
						<td>${afterInfo.press}</td>
						<td>${afterInfo.nda}</td>
						<td>${afterInfo.body_mat}</td>
						<td>${afterInfo.seat_mat}</td>
						<td><input type="text" name="p_coat_in" value="${afterInfo.coat_in}" /></td>
						<td><input type="text" name="p_coat_out" value="${afterInfo.coat_out}" /></td>
						<td><input type="text" name="p_letter_nameplate" value="${afterInfo.letter_nameplate}" /></td>
						<td><input type="text" name="p_type1" value="${afterInfo.type1}" /></td>
						<td><input type="text" name="p_type2" value="${afterInfo.type2}" /></td>
						<td><input type="text" name="p_position" value="${afterInfo.position}" /></td>
					</tr>
				</table>
			</c:if>
			<c:if test="${p_item_type_cd == 'SE'}">
				<table id="item_detail" class="detailArea conSearch">
					<tr>
						
						<th>DETAIL</th>
						<th>PAINT1</th>
						<th>재질</th>
						<th>E_BOLT</th>
						<th>PAD</th>
						<th>W1</th>
						<th>W</th>
						<th>a</th>
						<th>L</th>
						<th>L1</th>
						<th>b</th>
						<th>D</th>
						<th>d</th>
						<th>a1</th>
						<th>E/B</th>
						<th>1</th>
						<th>2</th>
						<th>3</th>
					</tr>
					<tr>
						<td>${afterInfo.bom_item_detail}</td>
						<td>${afterInfo.se_paint}</td>
						<td>${afterInfo.se_material}</td>
						<td>${afterInfo.se_earth_bolt}</td>
						<td>${afterInfo.se_pad}</td>
						<td>${afterInfo.seat_dim_w1}</td>		
						<td>${afterInfo.seat_dim_w}</td>		
						<td>${afterInfo.seat_dim_a}</td>
						<td>${afterInfo.seat_dim_l1}</td>
						<td>${afterInfo.seat_dim_l}</td>
						<td>${afterInfo.seat_dim_b}</td>
						<td>${afterInfo.seat_dim_d}</td>
						<td>${afterInfo.seat_dim_d1}</td>
						<td>${afterInfo.seat_dim_a1}</td>
						<td>${afterInfo.seat_earth_bolt}</td>
						<td>${afterInfo.seat_material1}</td>
						<td>${afterInfo.seat_material2}</td>
						<td>${afterInfo.seat_material3}</td>	
					</tr>
				</table>
			</c:if>
			<c:if test="${p_item_type_cd == 'CA'}">
				<table id="item_detail" class="detailArea conSearch">
					<tr>
						
						<th>Type</th>
						<th>From Deck</th>
						<th>From Equipment</th>
						<th>To Deck</th>
						<th>To Equipment</th>
						<th>포설 Deck</th>
						<th>Pallet</th>
					</tr>
					<tr>
						<td>${afterInfo.COMP_NAME}</td>
						<td>${afterInfo.FROMDECK}</td>
						<td>${afterInfo.FROMEQUIPMEMT}</td>
						<td>${afterInfo.TO_DECK}</td>
						<td>${afterInfo.TO_EQUIP}</td>
						<td>${afterInfo.SUPPLY_DECK}</td>		
						<td>${afterInfo.PALLET}</td>		
					</tr>
				</table>
			</c:if>
			<div class="sub_tit">□ 생산 정보</div> 
			<table id="item_detail" class="detailArea conSearch">
				<tr>
					<th>입고일</th>
					<th>물류담당자</th>
					<th>작업부서</th>
					<th>작업시작일</th>
					<th>작업종료일</th>
					<th>작업상태</th>
					<th>요청수량</th>
					<th>요청일</th>	
				</tr>
				<tr>
					<td>${afterInfo.tran_date}</td>
					<td>${afterInfo.tran_user}</td>
					<td>${afterInfo.work_dept}</td>
					<td>${afterInfo.work_start_date}</td>
					<td>${afterInfo.work_endate}</td>
					<td>${afterInfo.work_status}</td>
					<td>${afterInfo.required_ea}</td>
					<td>${afterInfo.required_date}</td>
				</tr>
			</table>
			
			<div class="sub_tit">□ 발주 정보</div> 
			<table id="item_detail" class="detailArea conSearch">
				<tr>
					<th>구분</th>
					<th>PR NO.</th>
					<th>PR EA</th>
					<th>PR DATE</th>
					<th>PO NO.</th>
					<th>납기일</th>
					<th>조달담당자</th>
					<th>제작업체</th>
					<th>입고수량</th>
				</tr>
				<tr>
					<td>${afterInfo.wip_class}</td>
					<td>${afterInfo.pr_no}</td>
					<td>${afterInfo.pr_ea}</td>
					<td>${afterInfo.pr_date}</td>
					<td>${afterInfo.po_no}</td>
					<td>${afterInfo.need_by_date}</td>
					<td>${afterInfo.agent_user}</td>
					<td>${afterInfo.vender}</td>
					<td>${afterInfo.delivered_date}</td>
				</tr>
			</table>
			<div class="content">
				<table id="itemAttList"></table>
				<div id="pItemAttList"></div>
			</div>
			<div style="float: right; margin: 10px 10px 0 0">
				<c:if test="${p_item_type_cd == 'VA'}">
					<input type="button" id="btnSave" value="저장" class="btn_blue2" /> 
				</c:if>
				<input type="button" id="btnCancle" value="닫기" class="btn_blue2" />
			</div>
		</div>
	</form>

	<script type="text/javascript">

	$(document).ready(function(){
		$("#btnSave").click(function(){
			//승인 로직
			if(confirm('저장하시겠습니까?')){
				var formData = fn_getFormData('#application_form');
				$(".loadingBoxArea").show();
				
				$.post("sscAfterInfoSaveAction.do",formData ,function(data){
					$(".loadingBoxArea").hide();
					alert(data.resultMsg);
					location.reload();
				},"json");
			}	
		});
		
		$("#btnCancle").click(function(){
			self.close();
		});
	});
	</script>
</body>
</html>
<%!
	/**
	 * request XSS 처리
	 **/
	public String getCheckReqXSS(javax.servlet.http.HttpServletRequest req, String parameter, String default_value) {
	    String req_value = (req.getParameter(parameter) == null ||  req.getParameter(parameter).equals("")) ? default_value : req.getParameter(parameter);
	    req_value = req_value.replaceAll("</?[a-zA-Z][0-9a-zA-Z가-\uD7A3ㄱ-ㅎ=/\"\'%;:,._()\\-# ]+>","");
	    req_value = req_value.replaceAll(">","");
	    req_value = req_value.replaceAll("</a","");
	    return req_value;
	}
%>