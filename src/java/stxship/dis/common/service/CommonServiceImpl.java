package stxship.dis.common.service;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;
import stxship.dis.common.dao.DisBaseDAO;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;

/**
 * @파일명 : CommonServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * DIS 공통 서비스 각 로직에서 상속 되어짐
 * </pre>
 */
@Service("commonService")
public class CommonServiceImpl implements CommonService {

	/**
	 * 공통 DAO정의
	 */
	@Resource(name = "commonDAO")
	private CommonDAO commonDAO;

	@Resource(name = "disBaseDAO")
	private DisBaseDAO disBaseDAO;

	/**
	 * @메소드명 : errorService
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 Exception 처리 에러 내용을 DB에 저장
	 * </pre>
	 * 
	 * @param ex
	 * @param request
	 */
	@Override
	public void errorService(Exception ex, HttpServletRequest request) {
		Map<String, Object> errorLogMap = new HashMap<String, Object>();
		errorLogMap.put("execute_url", request.getRequestURI());
		errorLogMap.put(DisConstants.SET_DB_LOGIN_ID, DisSessionUtil.getUserId());
		errorLogMap.put("error_msg", ex.getMessage());
		errorLogMap.put("client_ip", request.getRemoteAddr().toString());
		commonDAO.insert("saveErrorLog.insert", errorLogMap);
	}

	/**
	 * @메소드명 : getGridList
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드 리스트 출력의 기본 처리 로직을 구현
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getGridList(CommandMap commandMap) {
		// 각 로직별 커스텀 서비스를 취득
		// CommonService customService = (CommonService)
		// commandMap.get(DisConstants.CUSTOM_SERVICE_KEY);

		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		List<Map<String, Object>> listData = getGridData(commandMap.getMap());

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			listRowCnt = getGridListSize(commandMap.getMap());
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
	 * @메소드명 : getGridListNoPaging
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 페이징이 없는 그리드 리스트 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getGridListNoPaging(CommandMap commandMap) {
		commandMap.put(DisConstants.IS_PAGING, DisConstants.NO);
		return getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridList
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 변경된 데이타 처리 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveGridList(CommandMap commandMap) throws Exception {
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
				result = getDuplicationCnt(rowData);
				if (result.equals(DisConstants.RESULT_SUCCESS)) {
					result = gridDataInsert(rowData);
				} else if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(DisMessageUtil.getMessage("common.default.duplication"), "");
				} else {
					throw new DisException(result);
				}
			}
			// UPDATE 인경우
			else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataUpdate(rowData);
			}
			// DELETE 인경우
			else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataDelete(rowData);
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
	 * @메소드명 : getUserRole
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 유저의 권한을 받아오는 처리
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getUserRole(CommandMap commandMap) {
		// 유저의 권한정보를 취득
		// 권한정보(권한이 선택되어졌을경우 : 세션에 권한정보가 들어있다)
		// 권한정보가 선택된 경우에는 선택된 권한으로 유저의 권한정보를 취득한다.
		if (DisSessionUtil.getObject("roleCode") != null && !"".equals(DisSessionUtil.getObject("roleCode"))) {
			commandMap.put("roleCode", DisSessionUtil.getObject("roleCode"));
		} else {
			commandMap.put("roleCode", "");
		}
		return commonDAO.selectOne("Role.selectUserRoleByMenuId", commandMap.getMap());
	}

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용 (그리드 데이터 입력)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataInsert(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_INSERT;
		int insertResult = commonDAO.insert(mapperSql, rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 수정)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataUpdate(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_UPDATE;
		int updateResult = commonDAO.update(mapperSql, rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : gridDataDelete
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 삭제)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataDelete(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_DELETE;
		int deleteResult = commonDAO.delete(mapperSql, rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 중복체크)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCnt(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_DUPLICATE_CNT;

		int result = commonDAO.selectOne(mapperSql, rowData);
		if (result > 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : getGridData
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용   (그리드 데이터 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return commonDAO.selectList(mapperSql, map);
	}

	/**
	 * @메소드명 : getGridListSize
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용   (그리드 데이터 리스트 사이즈 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public Object getGridListSize(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MEPPER_GET_TOTAL_RECORD;
		return commonDAO.selectOne(mapperSql, map);
	}

	/**
	 * @메소드명 : getDbDataOne
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드가 아닌 단일 DB정보를 받아옴
	 * 1. 맵핑 파일은 액션서블릿명과 연동된다.
	 *    EX)infoEmpNoRegister.do ->infoEmpNoRegister.xml
	 * 2. 리턴값은 "select" 에 담겨진다.
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getDbDataOne(CommandMap commandMap) {
		String mapperSql = "";
		if (commandMap.get(DisConstants.MAPPER) == null) {
			mapperSql = commandMap.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
					+ DisConstants.MEPPER_GET_SELECT;
		} else {
			mapperSql = commandMap.get(DisConstants.MAPPER).toString();

		}
		return commonDAO.selectOne(mapperSql, commandMap.getMap());
	}

	@Override
	public int updateDbData(CommandMap commandMap) {
		String mapperSql = "";
		if (commandMap.get(DisConstants.MAPPER) == null) {
			mapperSql = commandMap.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
					+ DisConstants.MAPPER_UPDATE;
		} else {
			mapperSql = commandMap.get(DisConstants.MAPPER).toString();

		}
		return commonDAO.update(mapperSql, commandMap.getMap());
	}

	/**
	 * @메소드명 : getDbDataList
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드가 아닌 리스트 DB정보를 받아옴
	 * 1. 맵핑 파일은 액션서블릿명과 연동된다.
	 *    EX)infoEmpNoRegister.do ->infoEmpNoRegister.xml
	 * 2. 리턴값은 "list" 에 담겨진다.
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getDbDataList(CommandMap commandMap) {
		String mapperSql = "";
		if (commandMap.get(DisConstants.MAPPER) == null) {
			mapperSql = commandMap.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
					+ DisConstants.MAPPER_GET_LIST;
		} else {
			mapperSql = commandMap.get(DisConstants.MAPPER).toString();

		}
		return commonDAO.selectList(mapperSql, commandMap.getMap());
	}

	/**
	 * @메소드명 : saveEngineerRegister
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 결재자 검색 팝업에서 결재자 선택후 저장
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws DisException
	 */
	@Override
	public Map<String, String> saveEngineerRegister(CommandMap commandMap) throws Exception {
		//int result = disBaseDAO.insertEngineerRegister(commandMap.getMap());
		//if (result == 0) {
		//	throw new DisException();
		//}
		//return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		try{
			disBaseDAO.insertEngineerRegister(commandMap.getMap());
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		} catch(Exception e) {
			e.printStackTrace();
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
	}

	/**
	 * @메소드명 : getSelectBoxDataList
	 * @날짜 : 2015. 12. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 셀렉트박스
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String getSelectBoxDataList(CommandMap commandMap) throws Exception {

//		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
//		// p_query를 이용하여 셀렉트 박스 내용 받음.
//		if(commandMap.get("cursor").equals("cursor")) {
//			Map<String, Object> resultData = disBaseDAO.getSelectBoxDataListCursor(commandMap.getMap());
//			list = (List<Map<String, Object>>)resultData.get("p_refer");
//		} else {
//			list = disBaseDAO.getSelectBoxDataList(commandMap.getMap());
//		}
		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = disBaseDAO.getSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}

	@Override
	public View excelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		// 그리드에서 받아온 엑셀 헤더를 설정한다.
		String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();
		// 그리드에서 받아온 데이터 네임을 배열로 설정
		String[] p_data_names = commandMap.get("p_data_name").toString().split(",");

		List<Map<String, Object>> itemList = this.getDbDataList(commandMap);
		boolean startFlag = true;
		for (Map<String, Object> rowData : itemList) {
			// 그리드의 헤더를 콜네임으로 설정
			List<String> row = new ArrayList<String>();
			for (int i = 0; i < p_col_names.length; i++) {
				if (startFlag) {
					colName.add(p_col_names[i]);
				}
				row.add(DisStringUtil.nullString(rowData.get(p_data_names[i])));
			}
			startFlag = false;
			colValue.add(row);
		}

		// 오늘 날짜 구함 시작
		modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();
	}

	/**
	 * @메소드명 : isDpsAdmin
	 * @날짜 : 2016. 7. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Dps 유저정보
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, String> getDpsUserInfo(CommandMap commandMap) {
		Map<String, String> result = commonDAO.selectOneDps("dpsCommon.dpsUserInfo", commandMap.getMap());
		if (result != null) {
			if (result.get("groupno") != null
					&& (result.get("groupno").equals("Administrators") || result.get("groupno").equals("PLM관리자") || result
							.get("groupno").equals("해양공정관리자"))) {
				result.put("adminYN", "Y");
			} else {
				result.put("adminYN", "N");
			}
		}
		return result;
	}
	
	/**
	 * @메소드명 : saveGridList
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 변경된 데이타 처리 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveManualGridList(CommandMap commandMap) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		String gridDetailDataList = commandMap.get("chmDetailResultList").toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		List<Map<String, Object>> saveDetailList = new ObjectMapper().readValue(gridDetailDataList, typeRef);
		// 결과값 최초
		String result = DisConstants.RESULT_FAIL;
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			// INSERT인경우 중복체크
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// !! 중복체크 쿼리는 CNT로 받아올것 !! 데이터 NULL체크는 하지 않는다.
				result = getDuplicationCnt(rowData);
				if (result.equals(DisConstants.RESULT_SUCCESS)) {
					result = gridDataInsert(rowData);
				} else if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(DisMessageUtil.getMessage("common.default.duplication"), "");
				} else {
					throw new DisException(result);
				}
			}
			// UPDATE 인경우
			else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataUpdate(rowData);
			}
			// DELETE 인경우
			else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataDelete(rowData);
			}
		}
		for (Map<String, Object> rowData : saveDetailList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			// INSERT인경우 중복체크
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// !! 중복체크 쿼리는 CNT로 받아올것 !! 데이터 NULL체크는 하지 않는다.
				result = getDuplicationCnt(rowData);
				if (result.equals(DisConstants.RESULT_SUCCESS)) {
					result = gridDataInsert(rowData);
				} else if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(DisMessageUtil.getMessage("common.default.duplication"), "");
				} else {
					throw new DisException(result);
				}
			}
			// UPDATE 인경우
			else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				//result = gridDataUpdate(rowData);
				//result = commonDAO.update("", rowData);
				int updateResult = commonDAO.update("saveManual.detailUpdate", rowData);
				if (updateResult == 0) {
					result = DisConstants.RESULT_FAIL;
				} else {
					result = DisConstants.RESULT_SUCCESS;
				}
			}
			// DELETE 인경우
			else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataDelete(rowData);
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
	 * @메소드명 : manualInfoList
	 * @날짜 : 2017. 02. 09.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 해당 페이지 메뉴얼 제공을 위한 공통로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> manualInfoList(CommandMap commandMap) {
		return commonDAO.manualInfoList(commandMap.getMap());
	}

	/**
	 * @메소드명 : getErpGridList
	 * @날짜 : 2017. 3. 1.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드 리스트 출력의 기본 처리 로직을 구현(ERP Session)
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getErpGridList(CommandMap commandMap) {
		// 각 로직별 커스텀 서비스를 취득
		// CommonService customService = (CommonService)
		// commandMap.get(DisConstants.CUSTOM_SERVICE_KEY);

		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		List<Map<String, Object>> listData = getErpGridData(commandMap.getMap());

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			listRowCnt = getErpGridListSize(commandMap.getMap());
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
	 * @메소드명 : getEprGridData
	 * @날짜 : 2017. 3. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용   (그리드 데이터 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getErpGridData(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return commonDAO.selectListErp(mapperSql, map);
	}
	
	/**
	 * @메소드명 : getErpGridListSize
	 * @날짜 : 2017. 3. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용   (그리드 데이터 리스트 사이즈 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public Object getErpGridListSize(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MEPPER_GET_TOTAL_RECORD;
		return commonDAO.selectOneErp(mapperSql, map);
	}
	
	
	
	//TODO
//////////////////
	/**
	 * @메소드명 : saveGridList
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 변경된 데이타 처리 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveErpGridList(CommandMap commandMap) throws Exception {
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
				result = getDuplicationCntErp(rowData);
				if (result.equals(DisConstants.RESULT_SUCCESS)) {
					result = gridDataInsertErp(rowData);
				} else if (result.equals(DisConstants.RESULT_FAIL)) {
					throw new DisException(DisMessageUtil.getMessage("common.default.duplication"), "");
				} else {
					throw new DisException(result);
				}
			}
			// UPDATE 인경우
			else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataUpdateErp(rowData);
			}
			// DELETE 인경우
			else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = gridDataDeleteErp(rowData);
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
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용 (그리드 데이터 입력)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataInsertErp(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_INSERT;
		int insertResult = commonDAO.insertErp(mapperSql, rowData);
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	
	/**
	 * @메소드명 : gridDataUpdateErp
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 수정)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataUpdateErp(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_UPDATE;
		int updateResult = commonDAO.updateErp(mapperSql, rowData);
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : gridDataDeleteErp
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 *  각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 삭제)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataDeleteErp(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_DELETE;
		int deleteResult = commonDAO.deleteErp(mapperSql, rowData);
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	
	
	/**
	 * @메소드명 : getErpDuplicationCnt
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 중복체크)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCntErp(Map<String, Object> rowData) {
		String mapperSql = rowData.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_DUPLICATE_CNT;

		int result = commonDAO.selectOneErp(mapperSql, rowData);
		if (result > 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
	
	
	/**
	 * @메소드명 : getErpGridListNoPaging
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 페이징이 없는 그리드 리스트 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getErpGridListNoPaging(CommandMap commandMap) {
		commandMap.put(DisConstants.IS_PAGING, DisConstants.NO);
		return getErpGridList(commandMap);
	}	

}
