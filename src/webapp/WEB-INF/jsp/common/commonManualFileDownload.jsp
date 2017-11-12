<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
	<iframe id="hiddenFrame" name="hiddenFrame" src="/AddOn/EP/stxManualDSView.jsp" style="display:none"></iframe>
	<input type="hidden" id="pgm_id" name="pgm_id" value="${manualInfo.pgm_id}" />
	<input type="hidden" id="revision_no" name="revision_no" value="${manualInfo.revision_no}" />
	<c:if test="${manualInfo.revision_no ne null}">
		<div style="cursor: pointer; vertical-align: text-bottom; display: inline-block; top: 7px; position: absolute;">
			<img src="/images/book.png" alt="메뉴얼 다운로드" onclick="javascript:hiddenFrame.go_fileView('/manualFileView.do?p_revision_no=${manualInfo.revision_no}&p_pgm_id=${manualInfo.pgm_id}','${manualInfo.filename}','${loginID}')" />
		</div>
	</c:if>
<script>
function manualDownload(pgm_id, revision_no) {
	var attURL = "manualFileView.do?";
    attURL += "p_pgm_id="+$("#pgm_id").val();
    attURL += "&p_revision_no="+$("#revision_no").val();

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

    //window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
}
</script>