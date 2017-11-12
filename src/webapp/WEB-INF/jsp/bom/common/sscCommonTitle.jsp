<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:choose>
	<c:when test="${p_item_type_cd == 'CA'}">
		Elec Cable Piece
	</c:when>
	<c:when test="${p_item_type_cd == 'SU'}">
		Pipe Support
	</c:when>
	<c:when test="${p_item_type_cd == 'GE'}">
		General
	</c:when>
	<c:when test="${p_item_type_cd == 'PI'}">
		Pipe Piece
	</c:when>
	<c:when test="${p_item_type_cd == 'OU'}">
		Outfitting
	</c:when>
	<c:when test="${p_item_type_cd == 'SE'}">
		Elec Seat
	</c:when>
	<c:when test="${p_item_type_cd == 'TR'}">
		Elec Tray 
	</c:when>
	<c:when test="${p_item_type_cd == 'VA'}">
		Valve
	</c:when>
	<c:when test="${p_item_type_cd == 'EQ'}">
		Equipment
	</c:when>
	<c:when test="${p_item_type_cd == 'PA'}">
		PAINT
	</c:when>
</c:choose>