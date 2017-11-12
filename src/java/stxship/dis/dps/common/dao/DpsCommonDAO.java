package stxship.dis.dps.common.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : DpsCommonDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpsCommon에서 사용되는 DAO
 *     </pre>
 */
@Repository("dpsCommonDAO")
public class DpsCommonDAO extends CommonDAO {
	
	/**
	 * 
	 * @메소드명	: getEmployeeInfo
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 사번의 사원이름, 직책, 부서정보를 쿼리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> getEmployeeInfo(Map<String,Object> param) throws Exception {
		Map<String,Object> returnMap = selectOneDps("dpsCommon.selectEmployeeInfo", param);
		
		if(returnMap == null) return null;
		String adminYN = "N";
		if(returnMap.get("GROUPNO") != null && 
			("Administrators".equals(returnMap.get("GROUPNO")) || "해양공정관리자".equals(returnMap.get("GROUPNO"))) ) {
			adminYN = "Y";
		}

		returnMap.put("is_admin", adminYN);
		
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: insertLog
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ERP 권한로그 테이블에 로그를 기록
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertLog(Map<String,Object> param) throws Exception {
		return insertDps("dpsCommon.insertLog", param);
	}
	/**
	 * 
	 * @메소드명	: getEmployeeInfo_Dalian
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 사번의 사원이름, 직책, 부서정보를 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	 * </pre>
	 * @param param
	 * @return
	 */
	public Map<String,Object> getEmployeeInfoDalian(Map<String,Object> param) {
		Map<String,Object> returnMap = selectOneDps("dpsCommon.selectEmployeeInfoDalian", param);
		if(returnMap == null) return null;
		returnMap.put("is_admin", "N");
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: getEmployeeInfo_Maritime
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *(FOR MARITIME) 해양종합설계팀 인원의 관리자 권한 체크 (* 임시기능)
	 * </pre>
	 * @param param
	 * @return
	 */
	public Map<String, Object> getEmployeeInfoMaritime(Map<String, Object> param) {
		return selectOneDps("dpsCommon.selectEmployeeInfoMaritime", param);
	}
	
	/**
	 * 
	 * @메소드명	: updateProgressSearchableProjectList
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 조회가능 호선 업데이트 쿼리
	 * </pre>
	 * @param param
	 * @throws Exception
	 */
	public void updateProgressSearchableProjectList(Map<String, Object> param) throws Exception{
		// 먼저 DP 확정된 모든 호선은 PLM_SEARCHABLE_PROJECT 테이블에 등록시킨다(이미 있으면 무시, 없으면 Insert)
		
		updateDps("saveProjectSearchItem.updateProgressSearchableProjectList", param);
	}
	
	/**
	 * 
	 * @메소드명	: getDepartmentList
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 설계 부서목록 전체를 쿼리
	 * </pre>
	 * @return
	 */
	public List<Map<String, Object>> getDepartmentList()  throws Exception{
		List<Object> departmentList = selectListDps("dpsCommon.selectDepartmentList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : departmentList){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: getReasonCodeList
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연 사유 코드 리스트
	 * </pre>
	 * @return
	 */
	public List<Map<String, Object>> getReasonCodeList() {
		List<Object> reasonCodeList = selectListDps("dpsCommon.selectReasonCodeList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : reasonCodeList){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: getERPSessionValue
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ERP Session GET
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public String getERPSessionValue() throws Exception{
		return String.valueOf(selectOne("dpsCommon.selectERPSessionValue"));
	}
	
	/**
	 * 
	 * @메소드명	: deleteERPDwgDpsTemp
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Temp Table Erp세션 삭제
	 * </pre>
	 * @param erpSessionId
	 */
	public void deleteERPDwgDpsTemp(String erpSessionId) {
		deleteDps("dpsCommon.deleteERPDwgDpsTemp", erpSessionId);
	}
	
	/**
	 * 
	 * @메소드명	: insertERPDwgDpsTemp
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Temp Table Erp 세션 삽입
	 * </pre>
	 * @param map
	 */
	public void insertERPDwgDpsTemp(Map<String, Object> map) {
		insertDps("dpsCommon.insertERPDwgDpsTemp",map);
	}
	/**
	 * 
	 * @메소드명	: getMHFactorCaseList
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수 적용율 Case 목록 로드
	 * </pre>
	 * @return
	 */
	public List<Map<String, Object>> getMHFactorCaseList() {
		List<Object> mhFactorCaseList = selectListDps("dpsCommon.selectMHFactorCaseList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : mhFactorCaseList){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: getMHFactorCaseAndValueList
	 * @날짜		: 2016. 8. 10.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수 적용 케이스 value 리턴
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getMHFactorCaseAndValueList() {
		List<Object> mhFactorCaseValueList = selectListDps("dpsCommon.selectMHFactorCaseAndValueList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : mhFactorCaseValueList){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	
	/**
	 * 
	 * @메소드명	: getProgressDepartmentList
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 목록을 쿼리
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getProgressDepartmentList() throws Exception{
		List<Object> departmentList = selectListDps("dpsCommon.selectProgressDepartmentList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : departmentList){
			Map<String,Object> temp = (Map<String,Object>)item;
			returnList.add(temp);
		}
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: getPartListUnderTeamStr
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 팀 하위의 파트 부서코드 리스트를 CSV 형태로 리턴
	 * </pre>
	 * @param teamDeptCode
	 * @return
	 */
	public List<Map<String,Object>> getPartListUnderTeamStr(String teamDeptCode) {
		List<Map<String,Object>> departmentList = selectListDps("dpsCommon.selectPartListUnderTeamStr",teamDeptCode);
		return departmentList;
	}
	/**
	 * 
	 * @메소드명	: getBaseWorkTime
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 기간의 당연투입시수를 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public String getBaseWorkTime(Map<String, Object> map) {
		return selectOneDps("dpsCommon.selectBaseWorkTime", map);
	}
	
	/**
	 * 
	 * @메소드명	: getPartPersons2
	 * @날짜		: 2016. 8. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자 & 시수입력 비 대상자 제외 (다수 개 부서 처리)
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPartPersons2(HashMap<String, Object> param) {
		return selectListDps("dpsCommon.selectPartPersons2", param);
	}
	/**
	 * 
	 * @메소드명	: getAllDepartmentList
	 * @날짜		: 2016. 8. 22.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 전체 부서 목록을 쿼리
	 * </pre>
	 * @return
	 */
	public List<Map<String, Object>> getAllDepartmentList() {
		// TODO Auto-generated method stub
		List<Object> departmentList = selectListDps("dpsCommon.selectAllDepartmentList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : departmentList){
			Map<String,Object> temp = (Map<String,Object>)item;
			String dept_code = String.valueOf(temp.get("dept_code"));
			if ("101101".equals(dept_code)) continue; // (임시처리) 부회장 Skip
			if ("267000".equals(dept_code)) continue; // (임시처리) 정보운영팀 Skip 
			if ("290000".equals(dept_code)) continue; // (임시처리) PI팀 Skip
			
			returnList.add(temp);
		}
		
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: getOPCodesForRevision
	 * @날짜		: 2016. 8. 22.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 개정 관련 OP CODE 정보 쿼리
	 * </pre>
	 * @return
	 */
	public List<Map<String, Object>> getOPCodesForRevision() {
		// TODO Auto-generated method stub
		List<Object> opCodeList = selectListDps("dpsCommon.selectOPCodesForRevision");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : opCodeList){
			Map<String,Object> temp = (Map<String,Object>)item;
			
			returnList.add(temp);
		}
		
		return returnList;
	}
	
	/**
	 * 
	 * @메소드명	: getPartPersons
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자 & 시수입력 비 대상자 제외
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPartPersons(Map<String, Object> param)  throws Exception{
		return  selectListDps("dpsCommon.selectPartPersons",param);
	}
	/**
	 * 
	 * @메소드명	: getMHInputConfirmYN
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 사번 + 날짜의 시수입력의 결재 여부를 쿼리
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public String getMHInputConfirmYN(Map<String, Object> map) throws Exception{
		String returnString = selectOneDps("dpsCommon.selectMHInputConfirmYN", map); 
		if(returnString == null) returnString= "N";
		return returnString;
	}
	/**
	 * 
	 * @메소드명	: getDateHolidayInfo
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *getDateHolidayInfo() : 해당 날짜의 휴일 여부를 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public String getDateHolidayInfo(Map<String, Object> map) {
		Map<String,Object> returnMap =selectOneDps("dpsCommon.selectDateHolidayInfo",map);
		String returnStr = String.valueOf(returnMap.get("isworkday"));
		if (returnMap.containsKey("insideworktime") && "4".equals(String.valueOf(returnMap.get("insideworktime")))) returnStr = "4H";
		return returnStr;
	}
	/**
	 * 
	 * @메소드명	: getDesignMHInputs
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 사번 + 날짜의 시수입력 사항을 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getDesignMHInputs(Map<String, Object> map) {
		return selectListDps("dpsCommon.selectDesignMHInputs", map);
	}
	/**
	 * 
	 * @메소드명	: getDPInputLockDate
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param map
	 * @return
	 */
	public String getDPInputLockDate(Map<String, Object> map) {
		return selectOneDps("dpsCommon.selectDPInputLockDate",map);
	}
	/**
	 * 
	 * @메소드명	: getSelectedProjectList
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 사번에 대해 선택된 작업호선 목록을 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getSelectedProjectList(Map<String, Object> map) {
		return selectListDps("dpsCommon.selectSelectedProjectList", map);
	}
	/**
	 * 
	 * @메소드명	: getInvalidSelectedProjectList
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *  해당 사번에 대해 선택된 작업호선 항목들 중에 호선명 변경 등으로 비-유효해진 항목들을 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getInvalidSelectedProjectList(Map<String, Object> map) {
		return selectListDps("dpsCommon.selectInvalidSelectedProjectList", map);
	}
	/**
	 * 
	 * @메소드명	: getDesignMHConfirmExist
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *사번 + 기간에 결재완료된 입력시수가 존재하는지 체크(쿼리)
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> getDesignMHConfirmExist(Map<String, Object> map) {
		return selectOneDps("dpsCommon.selectDesignMHConfirmExist", map);
	}
	/**
	 * 
	 * @메소드명	: getDesignProgressInfo
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	  *도면 하나에 대한 공정정보 조회
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String,Object> getDesignProgressInfo(Map<String, Object> map) {
		return selectOneDps("dpsCommon.selectDesignProgressInfo",map);
	}
	/**
	 * 
	 * @메소드명	: getDrawingTypesForWorkAction
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서 + 호선에 대해 할당된 도면구분(도면코드의 첫 글자)들을 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getDrawingTypesForWorkAction(Map<String, Object> map) {
		String projectNo = String.valueOf(map.get("projectNo"));
		if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);
		map.put("projectNo", projectNo);
		
		List<Map<String,Object>> returnList = selectListDps("dpsCommon.selectDrawingTypesForWork1", map);
		
		//if (returnList.size() == 0) resultStr = "B"; // 생성된 DP가 없어도(PLM_ACTIVITY 테이블에 데이터 X) 기본도(B) 항목은 기본 표시한다

		// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
		// : DPC_HEAD 테이블에서 Max CaseNo 이고 DWGDEPTCODE 가 해당 부서인 것이면서 
		// : SHIPTYPE(선종) 컬럼 값이 해당 호선의 선종을 포함하는 것이 대상 
		// : - 참고: SHIPTYPE 컬럼 값은 Bit 합으로 되어 있고 선종코드는 코드테이블(CCC_CODE)에 정의되어 있다
		if(returnList.size() == 0){
			returnList = selectListDps("dpsCommon.selectDrawingTypesForWork2", map);
		}
		// Start :: 2015-02-04 Kang seonjung : (서광훈 과장 요청) 선체생산설계-선형기술P(480100)는 000029(선형기술P), 000051(선체생설P) 조회 가능
		// 선형기술P가 선체생설P 도면 조회 때도 DP에 없으면 WBS에서 가져옴
		List<Map<String,Object>> returnList2 = null;
		if("480100".equals(String.valueOf(map.get("departCode")))) 
		{
			returnList2 = selectListDps("dpsCommon.selectDrawingTypesForWork3", map);
			if(returnList2.size() == 0){
				// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
				returnList2 = selectListDps("dpsCommon.selectDrawingTypesForWork4", map);
			}
		}
		if(returnList2 != null ){
			for(Map<String,Object> temp : returnList2){
				returnList.add(temp);
			}
		}
		
		return returnList;
	}
	/**
	 * 
	 * @메소드명	: getShipTypeAction
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS에 정의된 선종 리스트 쿼리
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getShipTypeAction(Map<String, Object> map) throws Exception{
		return selectListDps("dpsCommon.selectShipType", map);
	}
	/**
	 * 
	 * @메소드명	: getDrawingWorkStartDate
	 * @날짜		: 2016. 9. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *도면의 출도일자 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public String getDrawingWorkStartDate(Map<String, Object> map) {
		return selectOneDps("dpsCommon.selectDrawingWorkStartDate", map);
	}
	
	/**
	 * 
	 * @메소드명	: getAllDepartmentOfSTXShipList
	 * @날짜		: 2016. 7. 28.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 원인 부서목록 호출 쿼리
	 * </pre>
	 * @return
	 */
	public List<Map<String,Object>> getAllDepartmentOfSTXShipList()  throws Exception{
		List<Object> departmentList = selectListDps("dpsCommon.selectAllDepartmentOfSTXShipList");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : departmentList){
			Map<String,Object> temp = (Map<String,Object>)item;
			if ("101000".equals(temp.get("dept_code"))) continue; // (임시처리) 중역실 Skip
			if ("101101".equals(temp.get("dept_code"))) continue; // (임시처리) 총괄(유럽) Skip
			if ("101140".equals(temp.get("dept_code"))) continue; // (임시처리) 회장 Skip
			if ("101220".equals(temp.get("dept_code"))) continue; // (임시처리) 대표(유럽) Skip
			if ("267000".equals(temp.get("dept_code"))) continue; // (임시처리) 정보운영팀 Skip 
			if ("290000".equals(temp.get("dept_code"))) continue; // (임시처리) PI팀 Skip
			returnList.add(temp);
		}
		return returnList;
	}
	
	/**
	 * 
	 * @메소드명	: getAllDepartmentOfSTXShipList_Dalian
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *원인 부서목록 호출 쿼리 (대련 사용 가능처리 임시기능)
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getAllDepartmentOfSTXShipList_Dalian() throws Exception{
		List<Object> departmentList = selectListDps("dpsCommon.selectAllDepartmentOfSTXShipList_Dalian");
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Object item : departmentList){
			Map<String,Object> temp = (Map<String,Object>)item;
			if ("101000".equals(temp.get("dept_code"))) continue; // (임시처리) 중역실 Skip
			if ("101101".equals(temp.get("dept_code"))) continue; // (임시처리) 총괄(유럽) Skip
			if ("101140".equals(temp.get("dept_code"))) continue; // (임시처리) 회장 Skip
			if ("101220".equals(temp.get("dept_code"))) continue; // (임시처리) 대표(유럽) Skip
			if ("267000".equals(temp.get("dept_code"))) continue; // (임시처리) 정보운영팀 Skip 
			if ("290000".equals(temp.get("dept_code"))) continue; // (임시처리) PI팀 Skip
			returnList.add(temp);
		}
		return returnList;
	}
	
	/**
	 * 
	 * @메소드명	: getPartPersonsForDPProgress
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자&시수입력&공정입력 비 대상자 제외
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPartPersonsForDPProgress(Map<String,Object> param) throws Exception{
		return selectListDps("dpsCommon.selectPartPersonsForDPProgress",param);
	}
	
	/**
	 * 
	 * @메소드명	: getPartPersons_Dalian
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서(파트)의 구성원(파트원) 목록을 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPartPersons_Dalian(Map<String, Object> param)  throws Exception{
		return  selectListDps("dpsCommon.selectPartPersons_Dalian",param);
	}
	/**
	 * 
	 * @메소드명	: getProgressSearchableProjectList
	 * @날짜		: 2016. 9. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 공정부분 조회가능 Project 리스트 쿼리
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getProgressSearchableProjectList(Map<String, Object> param,boolean openOnly) throws Exception{
		param.put("openOnly", openOnly);
		if(!openOnly)updateDps("dpsCommon.updatePlmSearchableProject", param);
		return selectListDps("dpsCommon.selectProgressSearchableProjectList", param);
	}
	
	/**
	 * 
	 * @메소드명	: getProgressSearchableProjectList_Dalian
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 공정부분 조회가능 Project 리스트 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getProgressSearchableProjectList_Dalian(Map<String, Object> param)  throws Exception{
		List<Map<String, Object>> departmentList = selectListDps("dpsCommon.selectProgressSearchableProjectList_Dalian",param);
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> item : departmentList){
			item.put("state", "ALL");
			item.put("serialno", "0");
			returnList.add(item);
		}
		return  returnList;
	}
	/**
	 * 
	 * @메소드명	: getPartOutsidePersonsForDPProgress
	 * @날짜		: 2016. 9. 27.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *getPartOutsidePersonsForDPProgress() : 부서(파트)의 외주구성원 목록을 쿼리 
	 * </pre>
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getPartOutsidePersonsForDPProgress(Map<String, Object> param)  throws Exception{
		return selectListDps("dpsCommon.selectPartOutsidePersonsForDPProgress",param);
	}
	
	/**
	 * 
	 * @메소드명	: getDPProgressLockDate
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 입력불가 일자 수치 쿼리
	 * </pre>
	 * @param param
	 * @return
	 */
	public String getDPProgressLockDate(Map<String,Object> param){
		return selectOneDps("dpsCommon.selectDPProgressLockDate", param);
	}
	/**
	 * 
	 * @메소드명	: getKeyEventDates
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 호선의 Key Event 일자를 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String,Object> getKeyEventDates(Map<String, Object> map) {
		return selectOneDps("dpsCommon.selectKeyEventDates", map);
	}
}
