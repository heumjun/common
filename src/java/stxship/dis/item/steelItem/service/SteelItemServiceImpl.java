package stxship.dis.item.steelItem.service;

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

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.item.steelItem.dao.SteelItemDAO;

/**
 * @파일명 : BomStatusServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 10. 4.
 * @작성자	: 황성준
 * @설명
 * 
 * 	<pre>
 * Bom현황 에서 사용되는 서비스
 *     </pre>
 */
@Service("steelItemService")
public class SteelItemServiceImpl extends CommonServiceImpl implements SteelItemService {

	@Resource(name = "steelItemDAO")
	private SteelItemDAO steelItemDAO;	
	
	/**
	 * 
	 * @메소드명	: getSteelItemList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * 강재 ITEM 생성 조회 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getSteelItemList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		Map<String, Object> resultData = getSteelItemGridData(commandMap.getMap());
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
	 * @메소드명	: saveSteelItem
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * 강재 ITEM 생성 저장 패키지 호출 서비스
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveSteelItem(CommandMap commandMap) throws Exception {
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
		String item_code = "";
		Map<String, Object> updateResult = new HashMap<String, Object>();
		List<Map<String, Object>> listData = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> rowData : saveList) {
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			updateResult = steelItemDAO.saveSteelItem(rowData);
			result = updateResult.get("error_code") == null ? "" : updateResult.get("error_code").toString();
			result_msg = updateResult.get("error_msg") == null ? "" : updateResult.get("error_msg").toString();
			item_code = updateResult.get("item_code") == null ? "" : updateResult.get("item_code").toString();
			
			rowData.put("error_code", result);
			rowData.put("error_msg", result_msg);
			rowData.put("item_code", item_code);
			
			listData.add(rowData);
			
			//if(!result.equals("S")) {
				// 실패한경우(실패 메시지가 있는 경우)
				//throw new DisException(result + " --- " + result_msg);
			//}
		}		
		//return DisMessageUtil.getResultMessage("success");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put(DisConstants.GRID_RESULT_DATA, listData);
		return resultMap;
	}
	
	/**
	 * @메소드명 : getSteelItemGridData
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
	public Map<String, Object> getSteelItemGridData(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return steelItemDAO.selectSteelItemList(mapperSql, map);
	}

}
