package stxship.dis.bom.bomNeeds.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.bom.bomNeeds.dao.BomNeedsDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.common.util.GenericExcelView4;

/**
 * @파일명 : BomStatusServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2017. 1. 15.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * Bom현황 에서 사용되는 서비스
 *     </pre>
 */
@Service("bomNeedsService")
public class BomNeedsServiceImpl extends CommonServiceImpl implements BomNeedsService {

	@Resource(name = "bomNeedsDAO")
	private BomNeedsDAO bomNeedsDAO;

	@Override
	public Map<String, Object> bomNeedsList(CommandMap commandMap) {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = bomNeedsDAO.bomNeedsList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		listRowCnt = listData.get(0).get("ALL_CNT").toString();
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			//listRowCnt = getGridListSize(commandMap.getMap());
		}
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);
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

	@Override
	public View bomNeedsExcelList(CommandMap commandMap, Map<String, Object> modelMap) {
		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
			// 그리드의 헤더를 콜네임으로 설정
			/*for (String p_col_name : p_col_names) {
				colName.add(new String(p_col_name.getBytes("utf-8"),"utf-8"));
			}*/
	
			// 리스트를 취득한다.
			Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
			Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);

			//Excel출력 페이지는 단일 페이지=1, 출력은 9999999건까지 제약조건
			curPageNo = "1"; 
			pageSize = "999999";
			commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
			commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
			
			Map<String, Object> resultData = bomNeedsDAO.bomNeedsList(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData.get("p_refer");
			
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

			modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
			
		}  catch (Exception e) {
			e.printStackTrace();
		}
		
		return new GenericExcelView();
	}	

}
