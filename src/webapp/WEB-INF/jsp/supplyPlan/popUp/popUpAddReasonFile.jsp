<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>DOCUMENT</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
<style type="text/css">
ul.pop_addfile {width:100%;}
ul.pop_addfile li {float:left; width:100%; border-bottom:1px solid #c7c7c7; padding:10px 10px 10px 20px; margin-bottom:10px;}
.li_box {float:left; margin-right:20px;}
</style>
		<form id="upload" action="saveReasonFile.do" method="POST" enctype="multipart/form-data">
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
			<input type="hidden" id="seq" name="seq" value="${seq}"/>
			
			<div id="wrap">
				<div class="ex_upload">File & Commentes</div>
				<ul class="pop_addfile mgt10">
				<li>
				<div class="li_box"><input type="file" name="formfile" size="30"  class="h25"/></div><div><textarea rows="3" name="commentes" cols="40"></textarea></div></li>
				</ul>
			</div>
			<div style="margin-top:5px; margin-right:10px; float:right;">
				<input type="hidden" id="data" name="data" />
				<input type="submit" value="저장" class="btn_blue"/>
				<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
			</div>
		</form>
		<script type="text/javascript">
		$(document).ready( function() {
			$( '#upload' ).ajaxForm( {
				// 반환할 데이터의 타입. 'json'으로 하면 IE 에서만 제대로 동작하고 크롬, FF에서는 응답을 수신하지
				// 못하는 문제점을 발견하였다. dataType을 정의하지 않을 경우 기본 값은 null 이다.
				dataType : 'text',
				beforeSerialize : function() {
					// form을 직렬화하기전 엘레먼트의 속성을 수정할 수도 있다.
				},
				beforeSubmit : function() {
					$('#result').html('uploading...');
				},
				success : function( data ) {
					// 크롬, FF에서 반환되는 데이터(String)에는 pre 태그가 쌓여있으므로
					// 정규식으로 태그 제거. IE의 경우 정상적으로 값이 반환된다.
					//data = data.replace(/[<][^>]*[>]/gi, '');

					// JSON 객체로 변환
					//var jData = JSON.parse(data);

					//opener.fn_search();
					//self.close();

					//$('#result').html('Success - ' + jData.result);

					var returnValue = 'ok';
					window.returnValue = returnValue;
					self.close();
				}
			} );

			$( "#btncancle" ).click( function() {
				self.close();
			} );

		} );

		//######## 메시지 Call ########//
		var afterDBTran = function( json ) {
			if ( result == "duplication" || result == "fail" )
				alert( json.resultMsg );

			return result;
		};
		</script>
	</body>
</html>