<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title>USC DELETE</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>

<body>

<form id="application_form" name="application_form"  >
		<div class="subtitle">
		USC DELETE
		</div>
		<table class="searchArea conSearch">
			<col width="*"/>
			<tr>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_blue2" value="APPLY" id="btnApply"/>
					</div>
				</td>	
			</tr>
		</table>
		<table class="insertArea">
			<col width="*"/>
			<tr>
				<th>선택</th>
				<th>대상</th>
				<th>REMARK</th>
			</tr>
			<tr>
				<td><input type="radio" name="p_delete_gbn" value="BLOCK" checked></td>
				<td>BLOCK</td>
				<td>BLOCK 하위 대상 모두 삭제됨</td>
			</tr>
			<tr>
				<td><input type="radio" name="p_delete_gbn" value="ACTIVITY"></td>
				<td>ACTIVITY</td>
				<td>ACTIVITY 하위 대상 모두 삭제됨</td>
			</tr>
			<tr>
				<td><input type="radio" name="p_delete_gbn" value="JOB"></td>
				<td>JOB</td>
				<td>JOB 하위 대상 모두 삭제됨</td>
			</tr>
			
		</table>
</form>
<script type="text/javascript" >
	var resultData = [];

	$(document).ready(function(){
		//btnApply 버튼 클릭 시 Ajax로 eco no를 포험한 usc정보를 저장한다.
		$("#btnApply").click(function(){
			var args = window.dialogArguments;
			
			if(confirm("적용 하시겠습니까?")) {
				var row_id = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');
				var gbn = $('input:radio[name=p_delete_gbn]:checked').val();
				var del_cd = "";				
				
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'deleteUscMain.do?delete_gbn=' + gbn;
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							lodingBox.remove();
							window.returnValue = "OK";
							self.close();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}).always( function() {
				    	lodingBox.remove();	
					});
				});				
			}			
		});
	});
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var args = window.dialogArguments;
		var changedData = $.grep(args.jqGridObj.jqGrid('getRowData'), function( obj ) {
			return obj.oper == 'D';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
</script>
</body>

</html>