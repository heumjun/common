package stxship.dis.dps.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.dps.common.dao.DpsCommonDAO;

import com.stx.common.util.StringUtil;

/**
 * @파일명 : DpsCommonServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * DpsCommon에서 사용되는 서비스
 *     </pre>
 */
@Service("dpsCommonService")
public class DpsCommonServiceImpl extends CommonServiceImpl implements DpsCommonService {

	@Resource(name = "dpsCommonDAO")
	private DpsCommonDAO dpsCommonDAO;
	
	private static String[] timeKeys = {"0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", 
		"1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", 
		"1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400"};

	/**
	 * 
	 * @메소드명	: getEmployeeInfo
	 * @날짜		: 2016. 7. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * user 정보 취득 및 로그 남김
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String,Object> getEmployeeInfo(Map<String,Object> param) throws Exception {
		Map<String,Object> returnMap = dpsCommonDAO.getEmployeeInfo(param);
		dpsCommonDAO.insertLog(param);
		return returnMap;
	}
	
	/**
	 * 
	 * @메소드명	: getEmployeeInfo_Dalian
	 * @날짜		: 2016. 7. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 대련(중국) 로그인 정보 취득
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String,Object> getEmployeeInfoDalian(Map<String,Object> param) throws Exception {
		return dpsCommonDAO.getEmployeeInfoDalian(param);
	}
	
	/**
	 * 
	 * @메소드명	: getEmployeeInfo_Maritime
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 사번의 사원이름, 직책, 부서정보를 쿼리  // - (FOR MARITIME) 해양사업관리팀/해양종합설계팀 인원의 공정조회 기능 부여 (* 임시기능)
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getEmployeeInfoMaritime(Map<String, Object> param) throws Exception {
		return dpsCommonDAO.getEmployeeInfoMaritime(param);
	}
	
	/**
	 * 
	 * @메소드명	: getGridDataDPS
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGridDataDps(Map<String, Object> map) throws Exception {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return dpsCommonDAO.selectListDps(mapperSql, map);
	}
	
	/**
	 * 
	 * @메소드명	: getGridListDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Dps 공통 그리드 리스트 출력의 기본 처리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getGridListDps(CommandMap commandMap)throws Exception {
		// 각 로직별 커스텀 서비스를 취득
		// CommonService customService = (CommonService)
		// commandMap.get(DisConstants.CUSTOM_SERVICE_KEY);

		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		List<Map<String, Object>> listData = getGridDataDps(commandMap.getMap());

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			listRowCnt = getGridListSizeDps(commandMap.getMap());
		}
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: getGridListSizeDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public Object getGridListSizeDps(Map<String, Object> map) throws Exception {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MEPPER_GET_TOTAL_RECORD;
		return dpsCommonDAO.selectOneDps(mapperSql, map);
	}
	/**
	 * 
	 * @메소드명	: getGridListNoPagingDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getGridListNoPagingDps(CommandMap commandMap) throws Exception {
		commandMap.put(DisConstants.IS_PAGING, DisConstants.NO);
		return getGridListDps(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: gridDataInsertDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String gridDataInsertDps(Map<String, Object> rowData) throws Exception {
		String mapperSql = (rowData.containsKey("mybatisName") ? String.valueOf(rowData.get("mybatisName")) : rowData.get(DisConstants.MAPPER_NAME))
				+ DisConstants.MAPPER_SEPARATION
				+ (rowData.containsKey("mybatisId") ? String.valueOf(rowData.get("mybatisId")) : DisConstants.MAPPER_INSERT);
		int insertResult = dpsCommonDAO.insertDps(mapperSql, rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	/**
	 * 
	 * @메소드명	: gridDataUpdateDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String gridDataUpdateDps(Map<String, Object> rowData) throws Exception {
		String mapperSql = (rowData.containsKey("mybatisName") ? String.valueOf(rowData.get("mybatisName")) : rowData.get(DisConstants.MAPPER_NAME))
				+ DisConstants.MAPPER_SEPARATION
				+ (rowData.containsKey("mybatisId") ? String.valueOf(rowData.get("mybatisId")) : DisConstants.MAPPER_UPDATE);
		int updateResult = dpsCommonDAO.updateDps(mapperSql, rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	/**
	 * 
	 * @메소드명	: gridDataDeleteDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String gridDataDeleteDps(Map<String, Object> rowData) throws Exception {
		String mapperSql = (rowData.containsKey("mybatisName") ? String.valueOf(rowData.get("mybatisName")) : rowData.get(DisConstants.MAPPER_NAME))
				+ DisConstants.MAPPER_SEPARATION
				+ (rowData.containsKey("mybatisId") ? String.valueOf(rowData.get("mybatisId")) : DisConstants.MAPPER_DELETE);
		int deleteResult = dpsCommonDAO.deleteDps(mapperSql, rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	/**
	 * 
	 * @메소드명	: getDuplicationCntDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 service
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getDuplicationCntDps(Map<String, Object> rowData) throws Exception {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_DUPLICATE_CNT;

		int result = dpsCommonDAO.selectOneDps(mapperSql, rowData);
		if (result > 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	/**
	 * 
	 * @메소드명	: saveGridListDps
	 * @날짜		: 2016. 8. 4.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS 공통 그리드 데이터 수집 service
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveGridListDps(CommandMap commandMap) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		// 결과값 최초
		String result = DisConstants.RESULT_FAIL;
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			// INSERT인경우 중복체크
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// !! 중복체크 쿼리는 CNT로 받아올것 !! 데이터 NULL체크는 하지 않는다.
				result = getDuplicationCntDps(rowData);
				if (result.equals(DisConstants.RESULT_SUCCESS)) {
					result = gridDataInsertDps(rowData);
				} else if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(DisMessageUtil.getMessage("common.default.duplication"), "");
				} else {
					throw new DisException(result);
				}
			}
			// UPDATE 인경우
			else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataUpdateDps(rowData);
			}
			// DELETE 인경우
			else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataDeleteDps(rowData);
			}
		}
		if (result.equals(DisConstants.RESULT_SUCCESS)) {
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultMessage(result);
		} else if (result.equals(DisConstants.RESULT_FAIL)) {
			// 실패한경우(실패 메시지가 없는 경우)
			throw new DisException();
		} else {
			// 실패한경우(실패 메시지가 있는 경우)
			throw new DisException(result);
		}

	}

	/**
	 * 
	 * @메소드명	: updateProgressSearchableProjectList
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 조회가능 호선 업데이트 
	 * </pre>
	 * @param param
	 * @throws Exception
	 */
	@Override
	public void updateProgressSearchableProjectList(Map<String, Object> param) throws Exception {
		dpsCommonDAO.updateProgressSearchableProjectList(param);
	}
	
	/**
	 * 
	 * @메소드명	: deleteSaveProjectList
	 * @날짜		: 2016. 7. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 선택 호선 저장된 목록 삭제
	 * </pre>
	 * @param commandMap
	 * @throws Exception
	 */
	@Override
	public void deleteSaveProjectList(CommandMap commandMap) throws Exception {
		String mapperSql = commandMap.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_DELETE;
		dpsCommonDAO.deleteDps(mapperSql, commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: projectSaveSearchAbleItem
	 * @날짜		: 2016. 7. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	필요항목 재구성 및 오버로딩
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> projectSaveSearchAbleItem(CommandMap commandMap,List<String> externalGridParamKeyList) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			//그리드 외부에 있는 키값을 그리드 값안에 넣기 위한 설정
			for(String key : externalGridParamKeyList) rowData.put(key, commandMap.get(key));
			// UPDATE 인경우
			if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				gridDataUpdateDps(rowData);
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
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
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDepartmentList() throws Exception {
		return dpsCommonDAO.getDepartmentList();
	}

	@Override
	public List<Map<String, Object>> getReasonCodeList() throws Exception {
		return dpsCommonDAO.getReasonCodeList();
	}
	
	/**
	 * 
	 * @메소드명	: getERPSessionValue
	 * @날짜		: 2016. 8. 5.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ERP Session GET
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getERPSessionValue() throws Exception {
		return dpsCommonDAO.getERPSessionValue();
	}
	
	/**
	 * 
	 * @메소드명	: deleteERPDwgDpsTemp
	 * @날짜		: 2016. 8. 5.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *STX_DWG_DPS_TEMPORARY@STXERP 세션 삭제 
	 * </pre>
	 * @param erpSessionId
	 * @throws Exception
	 */
	@Override
	public void deleteERPDwgDpsTemp(String erpSessionId) throws Exception {
		dpsCommonDAO.deleteERPDwgDpsTemp(erpSessionId);
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
	@Override
	public void insertERPDwgDpsTemp(Map<String, Object> map) throws Exception {
		dpsCommonDAO.insertERPDwgDpsTemp(map);
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
	@Override
	public List<Map<String, Object>> getMHFactorCaseList() throws Exception {
		return dpsCommonDAO.getMHFactorCaseList();
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
	@Override
	public List<Map<String, Object>> getMHFactorCaseAndValueList()
			throws Exception {
		return dpsCommonDAO.getMHFactorCaseAndValueList();
	}
	/**
	 * 
	 * @메소드명	: isDepartmentManagerYN
	 * @날짜		: 2016. 8. 10.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *isDepartmentManager(): 부서 관리자(팀장, 파트장) 여부
	 * </pre>
	 * @param titleStr
	 * @return
	 * @throws Exception
	 */
	@Override
	public String isDepartmentManagerYN(String titleStr) throws Exception {
		
		if (StringUtil.isNullString(titleStr)) return "N";

		if (titleStr.equals("팀장") || titleStr.equals("팀장대") || titleStr.equals("팀장(대)") ||
            titleStr.equals("파트장") || titleStr.equals("파트대") || titleStr.equals("파트장(대)"))
		{ return "Y"; }

		return "N";
	}
	
	/**
	 * 
	 * @메소드명	: getProgressDepartmentList
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 공정사용 부서 목록을 쿼리
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getProgressDepartmentList() throws Exception {
		return dpsCommonDAO.getProgressDepartmentList();
	}
	
	/**
	 * 
	 * @메소드명	: isTeamManager
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 관리자(팀장 Only) 여부
	 * </pre>
	 * @param titleStr
	 * @return
	 */
	@Override
	public boolean isTeamManager(String titleStr)
	{
		if (!StringUtil.isNullString(titleStr) && (titleStr.equals("팀장") || titleStr.equals("팀장대") || titleStr.equals("팀장(대)"))) return true;
		else return false;
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
	 * @throws Exception
	 */
	@Override
	public List<Map<String,Object>> getPartListUnderTeamStr(String teamDeptCode) throws Exception {
		return dpsCommonDAO.getPartListUnderTeamStr(teamDeptCode);
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getBaseWorkTime(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getBaseWorkTime(commandMap.getMap());
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
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPartPersons2(HashMap<String, Object> param) throws Exception {
		return dpsCommonDAO.getPartPersons2(param);
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
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getAllDepartmentList() throws Exception { 
		return dpsCommonDAO.getAllDepartmentList();
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
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getOPCodesForRevision() throws Exception {
		return dpsCommonDAO.getOPCodesForRevision();
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
	 * @param loginUserInfo
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPartPersons(Map<String, Object> param) throws Exception {
		return dpsCommonDAO.getPartPersons(param);
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getMHInputConfirmYN(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getMHInputConfirmYN(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: getDateDPInfo
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 날짜의 휴일 여부와, 사번 + 날짜의 시수입력 사항을 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String,Object> getDateDPInfo(CommandMap commandMap) throws Exception {
		Map<String,Object> map = new CaseInsensitiveMap();
		map.put("holydaycheck", getDateHolidayInfo(commandMap));
		map.put("inputlockdate", getDPInputLockDate(commandMap));
		map.put("mhinputstring", getMHInputConfirmYN(commandMap));
		
		return map;
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getDateHolidayInfo(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getDateHolidayInfo(commandMap.getMap());
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDesignMHInputs(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getDesignMHInputs(commandMap.getMap());
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getDPInputLockDate(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getDPInputLockDate(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: getSelectedProjectList
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 사번에 대해 선택된 작업호선 목록을 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getSelectedProjectList(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getSelectedProjectList(commandMap.getMap());
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getInvalidSelectedProjectList(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getInvalidSelectedProjectList(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: getDesignMHConfirmExist
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *사번 + 기간에 결재완료된 입력시수가 존재하는지 체크(쿼리)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getDesignMHConfirmExist(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getDesignMHConfirmExist(commandMap.getMap());
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String,Object> getDesignProgressInfo(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getDesignProgressInfo(commandMap.getMap());
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
	 * @param commandMap
	 */
	@Override
	public List<Map<String,Object>> getDrawingTypesForWorkAction(CommandMap commandMap) {
		return dpsCommonDAO.getDrawingTypesForWorkAction(commandMap.getMap());
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
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getShipTypeAction(CommandMap commandMap) throws Exception {
		return dpsCommonDAO.getShipTypeAction(commandMap.getMap());
	}
	
	public String[] getTimeKeys(){
		return timeKeys;
	}
	/**
	 * 
	 * @메소드명	: getDrawingWorkStartDate
	 * @날짜		: 2016. 9. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 도면의 출도일자 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public String getDrawingWorkStartDate(CommandMap commandMap) {
		return dpsCommonDAO.getDrawingWorkStartDate(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: getAllDepartmentOfSTXShipList
	 * @날짜		: 2016. 7. 28.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 원인 부서 목록 호출 쿼리
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String,Object>> getAllDepartmentOfSTXShipList() throws Exception {
		return dpsCommonDAO.getAllDepartmentOfSTXShipList();
	}
	/**
	 * 
	 * @메소드명	: getAllDepartmentOfSTXShipList_Dalian
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 원인 부서 목록 호출 쿼리 (대련 사용가능 임시기능)
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getAllDepartmentOfSTXShipList_Dalian()throws Exception {
		return dpsCommonDAO.getAllDepartmentOfSTXShipList_Dalian();
	}
	
	/**
	 * 
	 * @메소드명	: getPartPersonsForDPProgress
	 * @날짜		: 2016. 7. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *  부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자&시수입력&공정입력 비 대상자 제외
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPartPersonsForDPProgress(Map<String,Object> param)
			throws Exception {
		if (StringUtil.isNullString(String.valueOf(param.get("dept_code")))) throw new Exception("Department Code is null");
		return dpsCommonDAO.getPartPersonsForDPProgress(param);
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
	 * @param loginUserInfo
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPartPersons_Dalian(Map<String, Object> param) throws Exception {
		return dpsCommonDAO.getPartPersons_Dalian(param);
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
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getProgressSearchableProjectList(Map<String, Object> param,boolean openOnly) throws Exception {
		return dpsCommonDAO.getProgressSearchableProjectList(param,openOnly);
	}
	
	/**
	 * 
	 * @메소드명	: getProgressSearchableProjectList_Dalian
	 * @날짜		: 2016. 7. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *공정부분 조회가능 Project 리스트 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getProgressSearchableProjectList_Dalian(Map<String, Object> param) throws Exception {
		return dpsCommonDAO.getProgressSearchableProjectList_Dalian(param);
	}
	/**
	 * 
	 * @메소드명	: getPartOutsidePersonsForDPProgress
	 * @날짜		: 2016. 9. 27.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *  getPartOutsidePersonsForDPProgress() : 부서(파트)의 외주구성원 목록을 쿼리 
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPartOutsidePersonsForDPProgress(Map<String, Object> param) throws Exception {
		return dpsCommonDAO.getPartOutsidePersonsForDPProgress(param);
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
	 * @throws Exception
	 */
	@Override
	public String getDPProgressLockDate(Map<String,Object> param) throws Exception {
		return dpsCommonDAO.getDPProgressLockDate(param);
	}
	/**
	 * 
	 * @메소드명	: getKeyEventDates
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *호선의 Key Event 일자를 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	@Override
	public Map<String,Object> getKeyEventDates(Map<String, Object> map) {
		return dpsCommonDAO.getKeyEventDates(map);
	}
	
}
