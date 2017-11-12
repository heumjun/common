package stxship.dis.bom.pending.service;

import java.util.List;
import java.util.Map;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PendingService extends CommonService {
	
	//프로젝트에 해당하는 마스터호선 반환.
	public Object pendingMasterNo(CommandMap commandMap);
	
	//Pending 메인 리스트 반환.
	public Map<String, Object> pendingMainList(CommandMap commandMap) throws Exception;
	
	//Pending 메인 리스트 결과 Excel 다운로드
	public View pendingExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
	
	//Pending 메인화면에서 부서에 해당하는 도면리스트 ARK(Auto Recommand Keyword) 반환.
	public String selectAutoCompleteDwgNoList(CommandMap commandMap);
	
	//Pending 메인 리스트에서 WORK 클릭시 SSC-Bom 내용 리스트 반환.
	public Map<String, Object> popupPendingWorkList(CommandMap commandMap);
	
	//Pending-ADD 리스트 결과.
	//pending-ADD DWG 클릭 시 Popup 화면 호출
	//popupPendingAddGetDwgno 화면에서 도면리스트 반환.
	public Map<String, Object> popupPendingAddGetDwgnoList(CommandMap commandMap) throws Exception;
	
	//pending-ADD 메인Grid에 Excel Import 실행.
	public List<Map<String, Object>> pendingAddWorkExcelImportAction(CommandMap commandMap) throws Exception;
	
	//Pending-ADD 화면에서 pending_work TempTable에 Insert.
	public Map<String, Object> pendingWorkInsert(CommandMap commandMap) throws Exception;
	
	//Pending-ADD 화면에서 TempTable 리스트 반환.
	public Map<String, Object> pendingNextAction(CommandMap commandMap) throws Exception;
	
	//Pending-ADD 화면에서 DELETE2 클릭 시 TempTable 데이터 삭제
	public Map<String, Object> pendingWorkDelete(CommandMap commandMap) throws Exception;
	
	//Pending-ADD 화면에서 Apply시 Pending 생성.
	public Map<String, Object> pendingApplyAction(CommandMap commandMap) throws Exception;
	
	//Pending-DELETE 화면에서 pending_work TempTable에 Insert.
	public Map<String, Object> pendingDelWorkInsert(CommandMap commandMap) throws Exception;
	
	//Pending-DELETE 화면에서 pending_work TempTable에 Insert.
	public Map<String, Object> pendingDelNextAction(CommandMap commandMap) throws Exception;
	
	//Pending-DELETE 화면에서 Apply시 Pending 삭제.
	public Map<String, Object> pendingDelApplyAction(CommandMap commandMap) throws Exception;

	
	@JsonIgnore
	public Map<String, Object> pendingChekedMainList(CommandMap commandMap) throws Exception;

	public Map<String, Object> pendingModifyValidationCheck(CommandMap commandMap) throws Exception;

	public Map<String, Object> pendingWorkValidationList(CommandMap commandMap) throws Exception;

	public Map<String, Object> pendingModifyApplyAction(CommandMap commandMap) throws Exception;

	public Map<String, Object> pendingBomApplyAction(CommandMap commandMap) throws Exception;

	public Map<String, Object> pendingCancelAction(CommandMap commandMap) throws Exception;

	public Map<String, Object> pendingRestoreAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> pendingDeleteTemp(CommandMap commandMap) throws Exception;

	public String getDwgnoList(CommandMap commandMap) throws Exception;
}
