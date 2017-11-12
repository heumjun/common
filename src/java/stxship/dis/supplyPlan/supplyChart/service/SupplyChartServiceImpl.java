package stxship.dis.supplyPlan.supplyChart.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.paint.importPaint.dao.PaintImportPaintDAO;
import stxship.dis.supplyPlan.supplyChart.dao.SupplyChartDAO;

@Service("supplyChartService")
public class SupplyChartServiceImpl extends CommonServiceImpl implements SupplyChartService {

	@Resource(name = "supplyChartDAO")
	private SupplyChartDAO supplyChartDAO;

	@Override
	public Map<String, Object> supplyChartList(CommandMap commandMap) {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		List<Map<String, Object>> listData = getGridData(commandMap.getMap());

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
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@Override
	public Map<String, Object> supplyChartSaveAction(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> supplyCharList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		String sErrorMsg = "";

		try {
			//pending Work 테이블 비움
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			for (Map<String, Object> rowData : supplyCharList) {

				Map<String, Object> pkgParam = new HashMap<String, Object>();
				
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				supplyChartDAO.supplyChartSaveAction(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}

				// 여기까지 Exception 없으면 성공 메시지
				commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			}

		}  catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return commandMap.getMap();
	}


}
