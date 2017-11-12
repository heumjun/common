<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

Block 
<select name="p_block" style="width:60px;" onchange="BlockOnChange();">
	<c:forEach var="item" items="${moveList}" varStatus="count">
	<option value="<c:out value="${item.d_block_no}" />"  <c:if test="${requestbox.p_block == item.d_block_no}">  selected="selected" </c:if> >
		<c:out value="${item.d_block_no}" />
	</option>
	<c:if test="${moveListSize == 0}" >
		<option value=""></option>
	</c:if>	
	</c:forEach>
</select>
Stage  
<select name="p_stage" style="width:60px;">
	<option value=""></option>
	<option value="01">01</option>
	<option value="02">02</option>
	<option value="03">03</option>
</select>
STR 
<select name="p_str" style="width:60px;">
	<option value=""></option>
	<option value="BT">BT</option>
	<option value="BI">BI</option>
	<option value="BC">BC</option>
</select>

<script>
	//Block 정보 변경
	var BlockOnChange = function(obj){
		$("input[name=p_modifyEA]").val("");
	}
</script>