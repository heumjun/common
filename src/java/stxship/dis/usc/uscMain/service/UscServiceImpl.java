package stxship.dis.usc.uscMain.service;

import java.io.File;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileScanner;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.usc.uscMain.dao.UscDAO;

/**
 * @파일명 : UscServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 10. 4.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * Usc에서 사용되는 서비스
 *     </pre>
 */
@Service("uscService")
public class UscServiceImpl extends CommonServiceImpl implements UscService {

	@Resource(name = "uscDAO")
	private UscDAO uscDAO;

	/**
	 * 
	 * @메소드명	: getUscActivityStdList
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
	public Map<String, Object> getUscList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		Map<String, Object> resultData = getUscGridData(commandMap.getMap());
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
		
		if(commandMap.get("p_act_catalog") != null) {
			result.put("p_act_catalog", commandMap.get("p_act_catalog").toString());
		}

		return result;
	}	
	
	/**
	 * 
	 * @메소드명	: infoAreaList
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
		// 리스트를 취득한다.
		Map<String, Object> resultData = uscDAO.uscCodeNameList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("vcursor");

		return listData;
	}
	
	/**
	 * @메소드명 : getUscGridData
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
	public Map<String, Object> getUscGridData(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return uscDAO.selectUscList(mapperSql, map);
	}
	
	/**
	 * @메소드명 : getUscExcelExport
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
	public Map<String, Object> getUscExcelExport(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME).toString().replaceAll("ExcelExport", "List") + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return uscDAO.selectUscList(mapperSql, map);
	}
	
	
	/**
	 * 
	 * @메소드명	: saveUscActivityStd
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 *USC ACTIVITY STANDARD  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveUscActivityStd(CommandMap commandMap) throws Exception {
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
			
			if(commandMap.get("delete_gbn") != null) {
				rowData.put("delete_gbn", commandMap.get("delete_gbn"));
			}
			
			//JOB CREATE - ADD 에서 사용할때
			if(rowData.get("str_flag") != null) {
				rowData.put("job_str_flag", rowData.get("str_flag"));
			}
			if(rowData.get("upper_block") == null) {
				rowData.put("upper_block","");
			}
			if(rowData.get("area") == null) {
				rowData.put("area","");
			}
			if(rowData.get("state_flag") == null) {
				rowData.put("state_flag","A");
			}
			if(commandMap.get("pgm_link").equals("restoreUscMain.do")){
				rowData.put("block_code", rowData.get("block_code"));
			}
			else if(commandMap.get("p_job_pop") != null) {
				if(commandMap.get("p_job_pop").equals("Y")) {
					rowData.put("block_code", rowData.get("block_no"));
				}
			}
			/*else if(rowData.get("block_no") != null) {
				rowData.put("block_code", rowData.get("block_no"));
			}*/
			if(rowData.get("eco_no") == null) {
				rowData.put("eco_no", "");
			}
			if(rowData.get("work_yn") == null) {
				rowData.put("work_yn", "");
			}else{
				rowData.put("work_yn", rowData.get("work_yn"));
			}
			
			updateResult = uscDAO.gridUscDataInsert(rowData);
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
	 * @메소드명	: saveUscMainEco
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * USC MAIN ECO  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveUscMainEco(CommandMap commandMap) throws Exception {
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
			rowData.put("p_eco_no", commandMap.getMap().get("p_eco_no"));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			updateResult = uscDAO.uscMainEcoUpdate(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}
		
		Map<String, Object> rowData1 = new HashMap<String, Object>();
		rowData1.put("p_eco_no", commandMap.getMap().get("p_eco_no"));
		rowData1.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String, Object> createResult = uscDAO.uscMainEcoCreate(rowData1);
		result = createResult.get("error_code") == null ? "" : createResult.get("error_code").toString();
		result_msg = createResult.get("error_msg") == null ? "" : createResult.get("error_msg").toString();
		if (result.equals("S")) {
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultMessage("success");
		} else {
			// 실패한경우(실패 메시지가 있는 경우)
			throw new DisException(result_msg);
		}
	}
	
	/**
	 * 
	 * @메소드명	: saveUscJobCreateEco
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * JOB CREATE ECO  저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveUscJobCreateEco(CommandMap commandMap) throws Exception {
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
			rowData.put("p_eco_no", commandMap.getMap().get("p_eco_no"));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			updateResult = uscDAO.uscJobCreateEcoUpdate(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}
		
		Map<String, Object> rowData1 = new HashMap<String, Object>();
		rowData1.put("p_eco_no", commandMap.getMap().get("p_eco_no"));
		rowData1.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String, Object> createResult = uscDAO.uscJobCreateEcoCreate(rowData1);
		result = createResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
		result_msg = createResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
		if (result.equals("S")) {
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultMessage("success");
		} else {
			// 실패한경우(실패 메시지가 있는 경우)
			throw new DisException(result_msg);
		}
	}
	
	/**
	 * 
	 * @메소드명	: restoreUscJobCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * restoreUscJobCreate
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> restoreUscJobCreate(CommandMap commandMap) throws Exception {
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
		
		int validationCnt = 0;
		for (Map<String, Object> rowData : saveList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			validationCnt += uscDAO.restoreUscValidationJobCreate(rowData);
		}
		
		Map<String, String> resultData = new HashMap<String, String>();
		if (validationCnt > 0){
			resultData.put("resultMsg", "동일 품목의 'A' 상태를 모두 삭제한 후 Restore 해야 합니다.");
			resultData.put("result", "");
		}
		else{
			for (Map<String, Object> rowData : saveList) {
				Map<String, Object> updateResult = new HashMap<String, Object>();
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				updateResult = uscDAO.restoreUscJobCreate(rowData);
				result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
				result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
				
				if(!result.equals("S")) {
					// 실패한경우(실패 메시지가 있는 경우)
					throw new DisException(result_msg);
				}
			}
			resultData.put("resultMsg", "처리가 완료되었습니다.");
			resultData.put("result", "success");
		}
		return resultData;
	}
	
	/**
	 * 
	 * @메소드명	: cancelUscJobCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * restoreUscJobCreate
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> cancelUscJobCreate(CommandMap commandMap) throws Exception {
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
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			updateResult = uscDAO.cancelUscJobCreate(rowData);
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
	 * @메소드명	: excelExportByProc
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UscActivityStd 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View uscExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// TODO Auto-generated method stub
		// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
			//엑셀 출력 전체 사이즈 가져오기
			commandMap.put("curPageNo", 1);
			commandMap.put("pageSize", 1);
			Map<String, Object> resultData = getUscExcelExport(commandMap.getMap());
			List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("vcursor");			
			
			Object listRowCnt = "";
			for (Map<String, Object> rowData : listData) {
				listRowCnt = rowData.get("p_cnt");
				break;
			}
			commandMap.put("pageSize", listRowCnt);
			
			// 엑셀 출력 데이터 가져오기
			Map<String, Object> resultData2 = getUscExcelExport(commandMap.getMap());
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
	 * @메소드명 : uscActivityStdExcelImportAction
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *	엑셀 업로드 Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> uscActivityStdExcelImportAction(CommandMap commandMap) throws Exception {
		/*if(commandMap.get("type").toString().equals("xlsx")) {
			return FileScanner.excelToList1((MultipartFile) commandMap.get("file"), 1, true, 0);
		} else {*/
		return FileScanner.DecryptExcelToList((File) commandMap.get("file"), 1, true, 0);
		//}
	}
	
	/**
	 * 
	 * @메소드명	: uscMasterCode
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscMasterCode  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public String uscMasterCode(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		String str = uscDAO.uscMasterCode(map);

		return str;
	}
	
	/**
	 * 
	 * @메소드명	: uscAreaCodeName
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscAreaCodeName  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public String uscAreaCodeName(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		String str = uscDAO.uscAreaCodeName(map);

		return str;
	}
	
	/**
	 * 
	 * @메소드명	: uscActivityImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscActivityImportCheck  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public String uscActivityImportCheck(CommandMap commandMap) throws Exception {
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

			updateResult = uscDAO.uscActivityImportCheck(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!"".equals(result_msg)) {
				return result_msg;
			}
		}		

		return result_msg;
	}
	
	/**
	 * 
	 * @메소드명	: uscVirtualBlockImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscVirtualBlockImportCheck  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public String uscVirtualBlockImportCheck(CommandMap commandMap) throws Exception {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		//Map<String, Object> resultData = uscDAO.uscActivityImportCheck(map);
		//String str = (String) resultData.get("error_msg") == null ? "" : resultData.get("error_msg").toString();
		
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
		String[] projects = commandMap.get("chk_series").toString().split(",");
		Map<String, Object> updateResult = new HashMap<String, Object>();
		
		for(int i = 0; i < projects.length; i++) {
			for (Map<String, Object> rowData : saveList) {
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				rowData.put("project_no", projects[i]);
	
				updateResult = uscDAO.uscActivityImportCheck(rowData);
				result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
				result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
				
				if(!"".equals(result_msg)) {
					return result_msg;
				}
			}		
		}
		return result_msg;
	}
	
	/**
	 * 
	 * @메소드명	: useJobActAction
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * useJobActAction  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, String> useJobActAction(CommandMap commandMap) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		List<Map<String, Object>> actList = new ArrayList<Map<String, Object>>();
		
		String project_no;
		String area = "";
		String block_no = "";
		String block_catalog = "";
		String block_str_flag = "";

		int i = 0;
		String projects = "";
		String etcs = "";		
		String[] etcsArray = null;
		String[] pjtArray = null;
		
		for (Map<String, Object> rowData : saveList) {
			project_no = rowData.get("project_no").toString();
			area = rowData.get("area").toString();
			block_no = rowData.get("block").toString();
			block_catalog = rowData.get("bk_code").toString();
			block_str_flag = rowData.get("block_str_flag").toString();
			
			etcsArray = etcs.split(",");
			pjtArray = projects.split(",");
			
			int pjtCnt = 0;
			int etcCnt = 0;
			
			commandMap.getMap().put("mapperName", "uscActivityImport");
			commandMap.getMap().put("p_project_no", project_no);
			commandMap.getMap().put("p_area", area);
			commandMap.getMap().put("p_block_no", block_no);
			commandMap.getMap().put("p_block_catalog", block_catalog);
			commandMap.getMap().put("p_block_str_flag", block_str_flag);
			commandMap.put("rows", 100);
			commandMap.put("page", 1);
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map = this.getUscList(commandMap);
			List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("rows");					
			for (int a = 0; a < list.size(); a++) {
				actList.add(list.get(a));
			}
		}
		
		String[] pjt = projects.split(",");
		
		List<Map<String, Object>> bomList = new ArrayList<Map<String, Object>>();
		String str = "";
		
		Map<String, Object> checkResult = new HashMap<String, Object>();
		for (Map<String, Object> rowData1 : actList) {
			Map<String, Object> resultData = new HashMap<String, Object>();
			resultData.put("project_no", rowData1.get("project_no") == null ? "" : rowData1.get("project_no").toString());
			resultData.put("block_no", rowData1.get("block_no") == null ? "" : rowData1.get("block_no").toString());
			resultData.put("job_catalog", rowData1.get("job_catalog") == null ? "" : rowData1.get("job_catalog").toString());
			resultData.put("job_str_flag", rowData1.get("str_flag") == null ? "" : rowData1.get("str_flag").toString());
			resultData.put("block_str_flag", rowData1.get("block_str_flag") == null ? "" : rowData1.get("block_str_flag").toString());
			resultData.put("block_catalog", rowData1.get("block_catalog") == null ? "" : rowData1.get("block_catalog").toString());
			resultData.put("activity_catalog", rowData1.get("activity_catalog") == null ? "" : rowData1.get("activity_catalog").toString());
			resultData.put("area", rowData1.get("area") == null ? "" : rowData1.get("area").toString());
			resultData.put("usc_job_type", rowData1.get("usc_job_type") == null ? "" : rowData1.get("usc_job_type").toString());
			resultData.put("work_yn", rowData1.get("work_yn") == null ? "" : rowData1.get("work_yn").toString());
			resultData.put("upper_block", rowData1.get("upper_block") == null ? "" : rowData1.get("upper_block").toString());
			checkResult = uscDAO.uscActivityImportCheck(resultData);
			String result = checkResult.get("error_code") == null ? "" : checkResult.get("error_code").toString();
			String result_msg = checkResult.get("error_msg") == null ? "" : checkResult.get("error_msg").toString();
			
			if(!"".equals(result_msg)) {
				throw new DisException(result_msg);
			} else {
				bomList.add(resultData);
			}
		}
		
		// 결과값 최초
		String result = DisConstants.RESULT_FAIL;
		String result_msg = "";
		Map<String, Object> updateResult = new HashMap<String, Object>();
		for (Map<String, Object> rowData2 : bomList) {
			rowData2.put("p_eco_no", commandMap.getMap().get("p_eco_no"));
			rowData2.put("state_flag", "A");
			rowData2.put("delete_gbn", "");
			rowData2.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			updateResult = uscDAO.uscMainEcoUpdate(rowData2);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			
			if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				throw new DisException(result_msg);
			}
		}
		 
		Map<String, Object> rowData3 = new HashMap<String, Object>();
		rowData3.put("p_eco_no", commandMap.getMap().get("p_eco_no"));
		rowData3.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String, Object> createResult = uscDAO.uscMainEcoCreate(rowData3);
		result = createResult.get("error_code") == null ? "" : createResult.get("error_code").toString();
		result_msg = createResult.get("error_msg") == null ? "" : createResult.get("error_msg").toString();
		if (result.equals("S")) {
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultMessage("success");
		} else {
			// 실패한경우(실패 메시지가 있는 경우)
			throw new DisException(result_msg);
		}
	}
	
	/**
	 * 
	 * @메소드명	: useActivityImport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * useActivityImport  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> useActivityImport(CommandMap commandMap) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		List<Map<String, Object>> actList = new ArrayList<Map<String, Object>>();
		
		String project_no;
		String area = "";
		String block_no = "";
		String block_catalog = "";
		String block_str_flag = "";

		int i = 0;
		String projects = "";
		String etcs = "";		
		String[] etcsArray = null;
		//String[] pjtArray = null;
		
		for (Map<String, Object> rowData : saveList) {
			project_no = rowData.get("project_no").toString();
			area = rowData.get("area").toString();
			block_no = rowData.get("block_no").toString();
			block_catalog = rowData.get("block_catalog").toString();
			block_str_flag = rowData.get("block_str_flag").toString();
			
			etcsArray = etcs.split(",");
			//pjtArray = projects.split(",");
			
			int pjtCnt = 0;
			int etcCnt = 0;
			
			commandMap.getMap().put("mapperName", "uscActivityImport");
			commandMap.getMap().put("p_project_no", project_no);
			commandMap.getMap().put("p_area", area);
			commandMap.getMap().put("p_block_no", block_no);
			commandMap.getMap().put("p_block_catalog", block_catalog);
			commandMap.getMap().put("p_block_str_flag", block_str_flag);
			commandMap.put("rows", 100);
			commandMap.put("page", 1);
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			if(i > 0) {				
				for(int etc = 0; etc < etcsArray.length; etc++) {
					if((project_no + "^" + area + "^" + block_no + "^" + block_catalog + "^" + block_str_flag).equals(etcsArray[etc])) {
						etcCnt++;						
					}
				}				
				if(etcCnt == 0) {
					map = this.getUscList(commandMap);
					List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("rows");					
					for (int a = 0; a < list.size(); a++) {
						actList.add(list.get(a));
					}
					etcs = etcs + "," + (project_no + "^" + area + "^" + block_no + "^" + block_catalog + "^" + block_str_flag);
				}
			} else {
				map = this.getUscList(commandMap);
				List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("rows");					
				for (int a = 0; a < list.size(); a++) {
					actList.add(list.get(a));
				}
				etcs = etcs + (project_no + "^" + area + "^" + block_no + "^" + block_catalog + "^" + block_str_flag);
			}	
			
			i++;
		}
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_DATA, actList);
		result.put("projects", projects);
		return result;
	}
	
	/**
	 * 
	 * @메소드명	: uscMainEconoCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscMainEconoCreate  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> uscMainEconoCreate(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Map<String, Object> resultData = uscDAO.uscMainEconoCreate(map);

		return resultData;
	}
	
	/**
	 * 
	 * @메소드명	: uscJobCreateEconoCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscJobCreateEconoCreate  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> uscJobCreateEconoCreate(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Map<String, Object> resultData = uscDAO.uscJobCreateEconoCreate(map);

		return resultData;
	}
	
	/**
	 * 
	 * @메소드명	: uscBlockImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscBlockImportCheck  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> uscBlockImportCheck(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				
		String[] series_chk = DisStringUtil.nullString(commandMap.get("series_chk")).split(",");
		for(int i = 0; i < series_chk.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			commandMap.getMap().put("project_no", series_chk[i]);
			Map<String, Object> resultMap = uscDAO.uscBlockImportCheck(commandMap.getMap());
			map.put("project_no", series_chk[i]);
			map.put("area", resultMap.get("p_area"));
			map.put("block", resultMap.get("p_block"));
			map.put("bk_code", resultMap.get("p_bk_code"));
			map.put("block_str_flag", resultMap.get("p_block_str_flag"));
			map.put("diff", resultMap.get("error_msg") == null ? "OK" : "DIFF");
			map.put("oper", "I");
			list.add(map);
		}		
		return list;
	}
	
	/**
	 * 
	 * @메소드명	: jobCreateAddCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * jobCreateAddCheck  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> jobCreateAddCheck(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				
		String[] series_chk = DisStringUtil.nullString(commandMap.get("series_chk")).split(",");
		for(int i = 0; i < series_chk.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			commandMap.getMap().put("project_no", series_chk[i]);
			Map<String, Object> resultMap = uscDAO.jobCreateAddCheck(commandMap.getMap());
			map.put("representative_pro_num", commandMap.get("p_project_no"));
			map.put("project_no", series_chk[i]);
			map.put("block_no", resultMap.get("p_block_no"));
			map.put("block_str_flag", resultMap.get("p_block_str_flag"));
			map.put("usc_job_type", resultMap.get("p_usc_job_type"));
			map.put("act_code", resultMap.get("o_act_code"));
			map.put("job_code", resultMap.get("p_job_catalog"));
			map.put("str_flag", resultMap.get("p_str_flag"));
			map.put("process", resultMap.get("error_msg"));
			map.put("oper", "S");
			map.put("error_flag", resultMap.get("error_flag"));
			list.add(map);
		}		
		return list;
	}
	
	/**
	 * 
	 * @메소드명	: jobCreateMoveCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * jobCreateMoveCheck  패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> jobCreateMoveCheck(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Map<String, Object> resultData = uscDAO.jobCreateMoveCheck(map);

		return resultData;
	}

}
