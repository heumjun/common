package stxship.dis.ems.partList1.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.ems.partList1.dao.EmsPartList1DAO;

@Service("emsPartList1Service")
public class EmsPartList1ServiceImpl extends CommonServiceImpl implements EmsPartList1Service {

	@Resource(name = "emsPartList1DAO")
	private EmsPartList1DAO emsPartList1DAO;
	
	/**
	 * 
	 * @메소드명	: getEmsPartList1List
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * getEmsPartList1List
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getEmsPartList1List(CommandMap commandMap) {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		Map<String, Object> resultData = getEmsPartList1GridData(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("vcursor");
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			for (Map<String, Object> rowData : listData) {
				listRowCnt = rowData.get("p_cnt");
				break;
			}			
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
	 * @메소드명	: savePartListGridData
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * PARTLIST  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePartListGridData(CommandMap commandMap) throws Exception {
		// TODO Auto-generated method stub
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
		String result_msg = "";
		Map<String, Object> updateResult = new HashMap<String, Object>();
		for (Map<String, Object> rowData : saveList) {
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			updateResult = emsPartList1DAO.gridPartListMainInsert(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}	
		String gridDataList1 = commandMap.get("chmResultList1").toString();
		commandMap.remove("chmResultList1");
		
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList1 = new ObjectMapper().readValue(gridDataList1, typeRef);
		
		if(commandMap.get("p_partlist_s") != null && saveList1.size() == 0) {
			Map<String, Object> rowData = new HashMap<String, Object>();
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("part_list_s", commandMap.get("p_partlist_s"));
			
			updateResult = emsPartList1DAO.gridPartListSubDelete(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		} else {			
			for (Map<String, Object> rowData : saveList1) {
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				updateResult = emsPartList1DAO.gridPartListSubDelete(rowData);
				result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
				result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
				
				if(!result.equals("S")) {
					// 실패한경우(실패 메시지가 있는 경우)
					throw new DisException(result_msg);
				}
				break;
			}
		}		

		for (Map<String, Object> rowData : saveList1) {
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			updateResult = emsPartList1DAO.gridPartListSubInsert(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}
		return DisMessageUtil.getResultMessage("success");
	}
	
	/**
	 * 
	 * @메소드명	: savePartListCopy
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * PARTLIST  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePartListCopy(CommandMap commandMap) throws Exception {
		// TODO Auto-generated method stub
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
		String result_msg = "";
		String[] prj_no = commandMap.get("chk_series").toString().split(",");
		Map<String, Object> updateResult = new HashMap<String, Object>();
		for(int i = 0; i < prj_no.length; i++) {
			for (Map<String, Object> rowData : saveList) {
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				rowData.put("project_no", prj_no[i]);
				
				updateResult = emsPartList1DAO.gridPartListMainInsert(rowData);
				result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
				result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
				
				if(!result.equals("S")) {
					// 실패한경우(실패 메시지가 있는 경우)
					throw new DisException(result_msg);
				}
			}			
		}
		return DisMessageUtil.getResultMessage("success");
	}
	
	/**
	 * 
	 * @메소드명	: savePartListSsc
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * PARTLIST  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePartListSsc(CommandMap commandMap) throws Exception {
		// TODO Auto-generated method stub
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
		String result_msg = "";
		Map<String, Object> updateResult = new HashMap<String, Object>();
		
		for (Map<String, Object> rowData : saveList) {
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			updateResult = emsPartList1DAO.gridPartListMainInsert(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}			
		
		return DisMessageUtil.getResultMessage("success");
	}
	
	/**
	 * 
	 * @메소드명	: savePartListGridData
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * PARTLIST  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> deletePartList(CommandMap commandMap) throws Exception {
		// TODO Auto-generated method stub
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
		String result_msg = "";
		Map<String, Object> updateResult = new HashMap<String, Object>();
		for (Map<String, Object> rowData : saveList) {
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			updateResult = emsPartList1DAO.gridPartListMainDelete(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}	

		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList1 = new ObjectMapper().readValue(gridDataList, typeRef);
		
		for (Map<String, Object> rowData : saveList1) {
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			updateResult = emsPartList1DAO.gridPartListSubDelete(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
			break;
		}
		return DisMessageUtil.getResultMessage("success");
	}
	
	/**
	 * @메소드명 : getEmsPartList1GridData
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
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
	public Map<String, Object> getEmsPartList1GridData(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return emsPartList1DAO.selectEmsPartList1(mapperSql, map);
	}
	
	/**
	 * 
	 * @메소드명	: uscCodeNameList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * USC ACTIVITY STANDARD  조회 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> uscCodeNameList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Map<String, Object> resultData = emsPartList1DAO.uscCodeNameList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("vcursor");

		return listData;
	}
	
	/**
	 * 
	 * @메소드명	: partListExcelExport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * partListExcelExport 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View partListExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// TODO Auto-generated method stub
		// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
			// 엑셀 출력 데이터 가져오기
			Map<String, Object> resultData2 = getPartListExcelExport(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData2.get("vcursor");
			
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
	 * @메소드명 : getPartListExcelExport
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * getPartListExcelExport
	 * </pre>
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getPartListExcelExport(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME).toString().replaceAll("ExcelExport", "List") + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return emsPartList1DAO.selectEmsPartList1(mapperSql, map);
	}
	
}
