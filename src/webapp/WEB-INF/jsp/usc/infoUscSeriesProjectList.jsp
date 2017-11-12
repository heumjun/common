<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="commonSeries">
<c:choose>
	<c:when test="${p_ischeck == 'N'}">
		시리즈(<label><input type="checkbox" id="SerieschkAll" onclick="SeriesChkAllClick();" <c:out value="${p_able}" /> />ALL</label>)	
	</c:when>
	<c:otherwise>
		시리즈(<label><input type="checkbox" id="SerieschkAll" checked="checked" onclick="SeriesChkAllClick();" <c:out value="${p_able}" />/>ALL</label>)	
	</c:otherwise>
</c:choose>
<c:forEach var="item" items="${seriesList}" varStatus="var" >
	<c:if test="${var.index==0}">
		<input type="hidden" id="rep_pro_num" name="rep_pro_num" value="<c:out value="${item.representative_pro_num}" />" />
	</c:if>
	<label>
		<c:choose>
			<c:when test="${p_ischeck == 'N'}">
				<input type="checkbox" id="p_series_<c:out value="${item.project_no}" />" name="p_series" value="<c:out value="${item.project_no}" />" class="chkSeries" onclick="SeriesChkItemClick()" <c:out value="${p_able}" />/>
			</c:when>
			<c:otherwise>
				<input type="checkbox" id="p_series_<c:out value="${item.project_no}" />" name="p_series" value="<c:out value="${item.project_no}" />" class="chkSeries" checked="checked" onclick="SeriesChkItemClick()" <c:out value="${p_able}" />/>
			</c:otherwise>
		</c:choose>
		<c:out value="${item.project_no}" />
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