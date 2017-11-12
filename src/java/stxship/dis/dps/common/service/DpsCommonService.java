package stxship.dis.dps.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : DpsCommonService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpsCommon에서 사용되는 서비스
 *     </pre>
 */
public interface DpsCommonService extends CommonService {
	
	public Map<String,Object> getEmployeeInfo(Map<String,Object> param) throws Exception;
	
	public Map<String,Object> getEmployeeInfoDalian(Map<String,Object> param) throws Exception;

	public Map<String, Object> getEmployeeInfoMaritime(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> getGridDataDps(Map<String, Object> map) throws Exception;
	
	public Map<String, Object> getGridListDps(CommandMap commandMap) throws Exception;
	
	public Object getGridListSizeDps(Map<String, Object> map) throws Exception;
	
	public Map<String, Object> getGridListNoPagingDps(CommandMap commandMap) throws Exception;
	
	public String gridDataInsertDps(Map<String, Object> rowData) throws Exception;
	
	public String gridDataUpdateDps(Map<String, Object> rowData) throws Exception;
	
	public String gridDataDeleteDps(Map<String, Object> rowData) throws Exception;
	
	public String getDuplicationCntDps(Map<String, Object> rowData) throws Exception;
	
	public Map<String, String> saveGridListDps(CommandMap commandMap) throws Exception;
	
	public void updateProgressSearchableProjectList(Map<String, Object> param) throws Exception;

	public void deleteSaveProjectList(CommandMap commandMap) throws Exception;

	public Map<String, String> projectSaveSearchAbleItem(CommandMap commandMap,List<String> externalKey) throws Exception;

	public List<Map<String, Object>> getDepartmentList() throws Exception;
	
	public List<Map<String,Object>> getReasonCodeList() throws Exception;
	
	public String getERPSessionValue() throws Exception;

	public void deleteERPDwgDpsTemp(String erpSessionId) throws Exception;

	public void insertERPDwgDpsTemp(Map<String, Object> map) throws Exception;
	
	public List<Map<String,Object>> getMHFactorCaseList() throws Exception;
	
	public List<Map<String, Object>> getMHFactorCaseAndValueList() throws Exception;
	
	public String isDepartmentManagerYN(String titleStr) throws Exception;
	
	public List<Map<String,Object>>getProgressDepartmentList() throws Exception;
	
	public boolean isTeamManager(String titleStr) throws Exception;
	
	public List<Map<String,Object>> getPartListUnderTeamStr(String teamDeptCode) throws Exception;
	
	public String getBaseWorkTime(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> getPartPersons2(HashMap<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> getPartPersons(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> getAllDepartmentList() throws Exception;
	
	public List<Map<String, Object>> getOPCodesForRevision() throws Exception;

	public String getMHInputConfirmYN(CommandMap commandMap) throws Exception;

	public Map<String,Object> getDateDPInfo(CommandMap commandMap)throws Exception;
	
	public String getDateHolidayInfo(CommandMap commandMap)throws Exception;
	
	public List<Map<String,Object>> getDesignMHInputs(CommandMap commandMap) throws Exception;
	
	public String getDPInputLockDate(CommandMap commandMap) throws Exception;
	
	public List<Map<String,Object>> getSelectedProjectList(CommandMap commandMap) throws Exception;
	
	public List<Map<String,Object>> getInvalidSelectedProjectList(CommandMap commandMap) throws Exception;

	public Map<String, Object> getDesignMHConfirmExist(CommandMap commandMap) throws Exception;

	public Map<String,Object> getDesignProgressInfo(CommandMap commandMap)throws Exception;
	
	public List<Map<String,Object>> getDrawingTypesForWorkAction(CommandMap commandMap)throws Exception;

	public List<Map<String,Object>> getShipTypeAction(CommandMap commandMap)throws Exception;
	
	public String[] getTimeKeys();

	public String getDrawingWorkStartDate(CommandMap commandMap);
	
	public List<Map<String,Object>> getAllDepartmentOfSTXShipList() throws Exception;
	
	public List<Map<String,Object>> getAllDepartmentOfSTXShipList_Dalian() throws Exception;
	
	public List<Map<String, Object>> getPartPersonsForDPProgress(Map<String,Object> param) throws Exception;
	
	public List<Map<String, Object>> getPartPersons_Dalian(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> getProgressSearchableProjectList(Map<String, Object> param,boolean openOnly) throws Exception;
	
	public List<Map<String, Object>> getProgressSearchableProjectList_Dalian(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> getPartOutsidePersonsForDPProgress(Map<String, Object> param) throws Exception;
	
	public String getDPProgressLockDate(Map<String,Object> param)throws Exception;

	public Map<String,Object> getKeyEventDates(Map<String, Object> map);
}
