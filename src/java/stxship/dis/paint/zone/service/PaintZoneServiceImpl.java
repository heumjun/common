package stxship.dis.paint.zone.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.pattern.dao.PaintPatternDAO;
import stxship.dis.paint.zone.dao.PaintZoneDAO;

/**
 * @파일명 : PaintZoneServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 *  Paint Zone의 서비스
 *     </pre>
 */
@Service("paintZoneService")
public class PaintZoneServiceImpl extends CommonServiceImpl implements PaintZoneService {

	@Resource(name = "paintZoneDAO")
	private PaintZoneDAO paintZoneDAO;

	@Resource(name = "paintPatternDAO")
	private PaintPatternDAO paintPatternDAO;

	/**
	 * @메소드명 : zoneExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone정보를 엑셀로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View zoneExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Zone Code");
		colName.add("Quay");
		colName.add("Area Code");
		colName.add("Area Desc");
		colName.add("대표구역");
		colName.add("GROUP");

		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = paintZoneDAO.selectList("selectZoneExport.list", commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();

			row.add(rowData.get("zone_code"));
			row.add(rowData.get("quay"));
			row.add(rowData.get("area_code"));
			row.add(rowData.get("area_desc"));
			row.add(rowData.get("area_master"));
			row.add(rowData.get("area_group"));

			colValue.add(row);
		}

		modelMap.put("excelName", commandMap.get("project_no") + "_" + commandMap.get("revision") + "_PaintZone");

		modelMap.put("colName", colName);

		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

	/**
	 * @메소드명 : savePaintZone
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone 정보 저장. 저장 시 대표구역 및 Group 유효성 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintZone(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> zoneList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		String result = DisConstants.RESULT_FAIL;

		// 1.Paint Zone 저장
		for (Map<String, Object> rowData : zoneList) {
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

			// 존재하는 PatternCode취득
			int deleteResult = 0;
			String sPatternCode = paintZoneDAO.selectExistPatternCode(rowData);
			if (sPatternCode != null) {
				// Pattern Code 설정
				rowData.put("pattern_code", sPatternCode);

				// Pattern 확정 해제
				deleteResult = paintPatternDAO.deletePatternScheme(rowData);
				if (deleteResult == 0) {
					// 확정 해제가 안된경우는 확정이 안되어있어 Scheme테이블에 데이터가 없는경우이므로 업무흐름상에
					// 정상처리
				}
				deleteResult = paintPatternDAO.updatePatternCodeUndefine(rowData);
				if (deleteResult == 0) {
					// 확정 해제가 안된경우는 확정이 안되어있어 이미 확정플러그가 D로 되어있으므로 업무흐름상에 정상처리
				}
			}
		}

		// 2. 동일 ZONE에 Quay 종류가 2개 이상일 수 없다. (동일 Quay가 다른 Zone에서는 사용 가능)
		List<Map<String, Object>> checkList_1;

		checkList_1 = paintZoneDAO.selectZoneQuayValidCheck(commandMap.getMap());

		String tempResult_1 = "";
		for (Map<String, Object> checkMap_1 : checkList_1) {
			String zone_code = (String) checkMap_1.get("ZONE_CODE");
			if (!"".equals(tempResult_1)) {
				tempResult_1 += ", " + zone_code;
			} else {
				tempResult_1 += zone_code;
			}
		}

		if (!"".equals(tempResult_1)) {
			// 에러 메시지 처리
			tempResult_1 = "[ " + tempResult_1 + " ] ZONE의 QUAY가 1개가 아닙니다.\n";

			throw new DisException(tempResult_1);
		}

		// 3. 저장 이후 Valid 체크
		// 동일 그룹 내에서 대표구역 1개가 아니거나, 그룹 내 대표구역이 없는 경우 체크
		List<Map<String, Object>> checkList;

		checkList = paintZoneDAO.selectZoneAreaGroupValidCheck(commandMap.getMap());

		String tempResult = "";
		for (Map<String, Object> checkMap : checkList) {
			String zone_code = (String) checkMap.get("ZONE_CODE");
			String area_group = (String) checkMap.get("AREA_GROUP");
			String check_msg = (String) checkMap.get("CHECK_MSG");

			if ("DUP".equals(check_msg)) {
				tempResult += "[ " + zone_code + " ] ZONE의 " + "( " + area_group + " ) GROUP의 대표구역이 중복입니다.\n";
			} else if ("NON".equals(check_msg)) {
				tempResult += "[ " + zone_code + " ] ZONE의 " + "( " + area_group + " ) GROUP의 대표구역이 없습니다.\n";
			}
		}

		if (!"".equals(tempResult)) {
			result = tempResult;
		}

		// 3. 실행결과 메시지 처리
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
	 * @메소드명 : checkPaintZone
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * ZONE - Area Group 일괄 지정 시 유효한 Zone Code인지 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> checkExistPaintZone(CommandMap commandMap) {
		Map<String, Object> result = (Map<String, Object>) paintZoneDAO.checkExistPaintZone(commandMap.getMap());
		return result;
	}
}
