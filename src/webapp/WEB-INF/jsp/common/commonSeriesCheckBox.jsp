<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<div class="commonSeries">
<c:choose>
	<c:when test="${requestbox.p_ischeck == 'N'}">
		시리즈(<label><input type="checkbox" id="SerieschkAll" onclick="SeriesChkAllClick();" <c:out value="${requestbox.p_able}" /> />ALL</label>)	
	</c:when>
	<c:otherwise>
		시리즈(<label><input type="checkbox" id="SerieschkAll" checked="checked" onclick="SeriesChkAllClick();" <c:out value="${requestbox.p_able}" />/>ALL</label>)	
	</c:otherwise>
</c:choose>
<c:forEach var="item" items="${seriesList}" >
	<label>
		<c:choose>
			<c:when test="${requestbox.p_ischeck == 'N'}">
				<input type="checkbox" name="p_series" value="<c:out value="${item.d_project_no}" />" class="chkSeries" onclick="SeriesChkItemClick()" <c:out value="${requestbox.p_able}" />/>
			</c:when>
			<c:otherwise>
				<input type="checkbox" name="p_series" value="<c:out value="${item.d_project_no}" />" class="chkSeries" checked="checked" onclick="SeriesChkItemClick()" <c:out value="${requestbox.p_able}" />/>
			</c:otherwise>
		</c:choose>
		<c:out value="${item.d_project_no}" />
	</label>
</c:forEach>
</div>
<script>
	//시리즈 ALL 클릭		
	var SeriesChkAllClick = function(){
		if(($("#SerieschkAll").is(":checked"))){
			$(".chkSeries").each(function(){
				if($(this).attr("disabled") != "disabled"){
					$(this).prop("checked", true);					
				}
			});
		}else{
			$(".chkSeries").prop("checked", false);
		}
	}
	
	//개별 클릭시 ALL 체크 해제
	var SeriesChkItemClick = function(){
		$("#SerieschkAll").prop("checked", false);
	}
</script>