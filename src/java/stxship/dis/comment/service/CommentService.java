package stxship.dis.comment.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * 
 * @파일명		: CommentService.java 
 * @프로젝트	: DIS
 * @날짜		: 2017. 7. 4. 
 * @작성자		: 이상빈 
 * @설명
 * <pre>
 * 	COMMENT 수신, COMMENT MAIN, COMMENT 승인 (SERVICE CLASS)
 * </pre>
 */
public interface CommentService extends CommonService {
	
	//**************************************************************************
	// commentReceipt(수신문서) MAIN METHOD START 
	//**************************************************************************
	
	// commentReceipt 담당팀 SelectBoxDataList
	public String commentReceiptTeamSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	// commentReceipt 담당부서 SelectBoxDataList
	public String commentReceiptDeptSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	// 메인 리스트 호출
	public Map<String, Object> commentReceiptList(CommandMap commandMap) throws Exception;
	
	// commentReceipt 담당파트 없으면 삭제
	public Map<String, Object> commentReceiptDeleteAction(CommandMap commandMap) throws Exception;
	
	// commentReceiptList Row 첨부파일 다운로드
	public View commentReceiptFileDownload(CommandMap commandMap, Map<String, Object> modelMap);
	
	// 메인화면에서 선택된 1개의 Row를 부서지정 선택 팝업창으로 넘겨준다.
	public Map<String, Object> popUpReceiptTeamList(CommandMap commandMap) throws Exception;
	
	// 부서지정 팝업 내 그리드에서 담당팀 SelectBox 리스트
	public List<Map<String, Object>> commentReceiptGridTeamList(CommandMap commandMap) throws Exception;
	
	// 부서지정 팝업에서 부서지정 후 Apply Action
	public Map<String, Object> commentReceiptTeamApplyAction(CommandMap commandMap) throws Exception;
	
	// 메인화면에서 선택된 1개의 Row를 담당자 선택 팝업창으로 넘겨준다.
	public Map<String, Object> popUpReceiptUserIdList(CommandMap commandMap) throws Exception;
	
	// 담당자 팝업 내 그리드에서 담당파트 SelectBox 리스트
	public List<Map<String, Object>> commentReceiptGridDeptList(CommandMap commandMap) throws Exception;
	
	// 담당자 팝업 내 그리드에서 담당자 SelectBox 리스트
	public List<Map<String, Object>> commentReceiptGridUserList(CommandMap commandMap) throws Exception;
	
	// 담당자 팝업 - 참조메일에서 User 리스트
	public List<Map<String, Object>> commentReceiptUserList(CommandMap commandMap) throws Exception;
	
	// 담당자 팝업에서 담당자 지정 후 Apply Action
	public Map<String, Object> commentReceiptUserApplyAction(CommandMap commandMap) throws Exception;
	
	// 메인화면에서 선택된 1개의 Row를 도면 선택 팝업창으로 넘겨준다.
	public Map<String, Object> popUpReceiptDwgList(CommandMap commandMap) throws Exception;
	
	// 도면 팝업에서 도면 지정 후 Apply Action(Update)
	public Map<String, Object> commentReceiptDwgApplyAction(CommandMap commandMap) throws Exception;
	
	// COMMENT 수신화면 담당자지정 - 참조메일 부서 목록
	public String commentReceiptUserEtcDeptSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	// commentReceipt 엑셀 다운로드
	public View commentReceiptExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	//**************************************************************************
	// commentReceipt(수신문서) MAIN METHOD END
	//**************************************************************************
	
	
	
	
	//**************************************************************************
	// commentReceipt(수신문서) ADD Method START
	//**************************************************************************
	
	// commentReceipt ADD - Grid 내 프로젝트 자동완성
	public String commentReceiptProjectNoList(CommandMap commandMap) throws Exception;
	
	// commentReceipt ADD 부서에 따른 도면 리스트
	public List<Map<String, Object>> commentReceiptDwgNoList(CommandMap commandMap) throws Exception;
	
	// commentReceipt ADD NEXT ACTION
	public Map<String, Object> commentReceiptAddValidationCheck(CommandMap commandMap) throws Exception;
	
	// commentReceipt ADD NEXT ACTION 이후 데이터 리스트
	public Map<String, Object> commentReceiptWorkValidationList(CommandMap commandMap) throws Exception;
	
	// commentReceipt ADD Apply ACTION
	public Map<String, Object> commentReceiptAddApplyAction(CommandMap commandMap) throws Exception;
	
	// commentReceipt ADD 그리드 row에 파일첨부 반영
	public Map<String, Object> commentReceiptAttachFileAction(MultipartFile file, CommandMap commandMap) throws Exception;
	
	// commentReceipt ADD EXCEL IMPORT
	public List<Map<String, Object>> commentReceiptExcelImportAction(CommandMap commandMap) throws Exception;
	
	//**************************************************************************
	// commentReceipt(수신문서) ADD Method END
	//**************************************************************************
	
	
	
	
	//**************************************************************************
	//comment Main Method START
	//**************************************************************************

	// COMMENT 화면 - 도면번호 목록 자동완성
	public String commentAutoCompleteDwgNoList(CommandMap commandMap) throws Exception;
	
	// COMMENT 메인 목록 호출
	public Map<String, Object> commentList(CommandMap commandMap) throws Exception;
	
	// COMMENT 메인 수신NO 리스트
	public List<Map<String, Object>> commentReceiptNoList(CommandMap commandMap) throws Exception;

	// COMMENT 메인 저장
	public Map<String, Object> commentMainSaveAction(CommandMap commandMap) throws Exception;

	// COMMENT PCF 다운로드
	public View commentPCFExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	// COMMENT MAIN 승인요청
	public Map<String, Object> commentReqeustApplyAction(CommandMap commandMap) throws Exception;
	
	// COMMENT 화면 - 그리드 내 발신번호 목록
	public List<Map<String, Object>> commentRefNoList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> popUpCommentCommentAttachList(CommandMap commandMap) throws Exception;
	
	//**************************************************************************
	//comment Main Method END
	//**************************************************************************
	
	
	
	//**************************************************************************
	// comment 승인 Method START
	//**************************************************************************
	
	// COMMENT 승인화면 - 왼쪽 그리드 목록
	public Map<String, Object> commentAdminMaList(CommandMap commandMap) throws Exception;
	
	// COMMENT 승인화면 - 오른쪽 그리드 목록
	public Map<String, Object> commentAdminDeList(CommandMap commandMap) throws Exception;
	
	// COMMENT 승인화면 - 승인/반려 ACTION
	public Map<String, Object> commentAdminConfirmAction(CommandMap commandMap) throws Exception;
	
	//**************************************************************************
	// comment 승인 Method END
	//**************************************************************************
	
	
	
	//**************************************************************************
	// comment 현황 Method START
	//**************************************************************************
	List<Map<String, Object>> commentChartList(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> commentChartDetailList(CommandMap commandMap) throws Exception;
	
	String commentSelectBoxTeamList(CommandMap commandMap) throws Exception;
	
	String commentSelectBoxPartList(CommandMap commandMap) throws Exception;

	String commentSelectBoxUserList(CommandMap commandMap) throws Exception;
	
	//**************************************************************************
	// comment 현황 Method END
	//**************************************************************************

	public List<Map<String, Object>> commentExcelImportAction(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> commentReplyExcelImportAction(CommandMap commandMap) throws Exception;

	public Object commentExcelTeamCode(Map<String, Object> pkgParam) throws Exception;

	public String commentReceiptNoSelectBoxDataList(CommandMap commandMap) throws Exception;

	public Map<String, Object> commentImportConfirmProc(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> commentReplyImportConfirmProc(CommandMap commandMap) throws Exception;

}
