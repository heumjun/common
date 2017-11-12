package stxship.dis.paint.outfitting.service;

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
import stxship.dis.paint.outfitting.dao.OutfittingDAO;

/**
 * @파일명 : OutfittingServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Outfitting의 서비스
 *     </pre>
 */
@Service("outfittingService")
public class OutfittingServiceImpl extends CommonServiceImpl implements OutfittingService {

	@Resource(name = "outfittingDAO")
	private OutfittingDAO outfittingDAO;

	/**
	 * @메소드명 : getGridData
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 팀별 구분을 선택했을때
	 * 실행되는 맵퍼는 선택된 팀별 구분코드와 일치하는 맵퍼가 된다.
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		String mapperName = (String) map.get(DisConstants.MAPPER_NAME);
		String sqlId;
		if ("selectOutfittingList".equals(mapperName)) {
			String mapperPreName = (String) map.get("searchGbn");
			if (map.get("searchGbn").toString().startsWith("etc")) {
				mapperPreName = "etc";
			}
			if (map.get("searchGbn").toString().startsWith("condensatePipe")) {
				mapperPreName = "condensatePipe";
			}
			if (map.get("searchGbn").toString().startsWith("noSmokingMark")) {
				mapperPreName = "noSmokingMark";
			}
			if (map.get("searchGbn").toString().startsWith("funnelMarking")) {
				mapperPreName = "funnelMarking";
			}
			
			if (map.get("searchGbn").toString().startsWith("fwdUpperDeckFinish")) {
				mapperPreName = "fwdUpperDeckFinish";
			}
			if (map.get("searchGbn").toString().startsWith("exteriorFullCoat")) {
				mapperPreName = "exteriorFullCoat";
			}
			if (map.get("searchGbn").toString().startsWith("bowEmblemAndShipNameAndSideMark")) {
				mapperPreName = "bowEmblemAndShipNameAndSideMark";
			}
			if (map.get("searchGbn").toString().startsWith("condensatePipe")) {
				mapperPreName = "condensatePipe";
			}
			if (map.get("searchGbn").toString().startsWith("spillTank")) {
				mapperPreName = "spillTank";
			}
			if (map.get("searchGbn").toString().startsWith("outerPlateMarking")) {
				mapperPreName = "outerPlateMarking";
			}
			if (map.get("searchGbn").toString().startsWith("uppDkOutfittingAndMarking")) {
				mapperPreName = "uppDkOutfittingAndMarking";
			}
			if (map.get("searchGbn").toString().startsWith("foremastAndCreane")) {
				mapperPreName = "foremastAndCreane";
			}
			if (map.get("searchGbn").toString().startsWith("megongWelding")) {
				mapperPreName = "megongWelding";
			}			
			sqlId = mapperPreName + DisConstants.MAPPER_SEPARATION + DisConstants.MAPPER_GET_LIST;
		} else {
			sqlId = mapperName + DisConstants.MAPPER_SEPARATION + DisConstants.MAPPER_GET_LIST;
		}
		List<Map<String, Object>> result = null;
		try {
			result = outfittingDAO.selectList(sqlId, map);
		} catch (Exception e) {
			sqlId = "etc" + DisConstants.MAPPER_SEPARATION + DisConstants.MAPPER_GET_LIST;
			result = outfittingDAO.selectList(sqlId, map);
		}
		return result;
	}

	/**
	 * @메소드명 : getGridListSize
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 팀별 구분을 선택했을때
	 * 실행되는 맵퍼는 선택된 팀별 구분코드와 일치하는 맵퍼가 된다.
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public Object getGridListSize(Map<String, Object> map) {
		String mapperName = (String) map.get(DisConstants.MAPPER_NAME);
		String sqlId;
		if ("selectOutfittingList".equals(mapperName)) {
			String mapperPreName = (String) map.get("searchGbn");
			if (map.get("searchGbn").toString().startsWith("etc")) {
				mapperPreName = "etc";
			}
			if (map.get("searchGbn").toString().startsWith("condensatePipe")) {
				mapperPreName = "condensatePipe";
			}
			if (map.get("searchGbn").toString().startsWith("noSmokingMark")) {
				mapperPreName = "noSmokingMark";
			}
			if (map.get("searchGbn").toString().startsWith("funnelMarking")) {
				mapperPreName = "funnelMarking";
			}
			if (map.get("searchGbn").toString().startsWith("fwdUpperDeckFinish")) {
				mapperPreName = "fwdUpperDeckFinish";
			}
			if (map.get("searchGbn").toString().startsWith("exteriorFullCoat")) {
				mapperPreName = "exteriorFullCoat";
			}
			if (map.get("searchGbn").toString().startsWith("bowEmblemAndShipNameAndSideMark")) {
				mapperPreName = "bowEmblemAndShipNameAndSideMark";
			}
			if (map.get("searchGbn").toString().startsWith("condensatePipe")) {
				mapperPreName = "condensatePipe";
			}
			if (map.get("searchGbn").toString().startsWith("spillTank")) {
				mapperPreName = "spillTank";
			}
			if (map.get("searchGbn").toString().startsWith("outerPlateMarking")) {
				mapperPreName = "outerPlateMarking";
			}
			if (map.get("searchGbn").toString().startsWith("uppDkOutfittingAndMarking")) {
				mapperPreName = "uppDkOutfittingAndMarking";
			}
			if (map.get("searchGbn").toString().startsWith("foremastAndCreane")) {
				mapperPreName = "foremastAndCreane";
			}
			if (map.get("searchGbn").toString().startsWith("megongWelding")) {
				mapperPreName = "megongWelding";
			}				
			sqlId = mapperPreName + DisConstants.MAPPER_SEPARATION + DisConstants.MEPPER_GET_TOTAL_RECORD;
		} else {
			sqlId = mapperName + DisConstants.MAPPER_SEPARATION + DisConstants.MEPPER_GET_TOTAL_RECORD;
		}
		return outfittingDAO.selectOne(sqlId, map);
	}

	/**
	 * @메소드명 : saveOutfittingArea
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 입력된 면적을 저장하는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveOutfittingArea(CommandMap commandMap) throws Exception {

		int nExist = outfittingDAO.selectExistOutfittingArea(commandMap.getMap());
		int result = 0;
		if (nExist > 0) {
			result = outfittingDAO.updateOutfittingArea(commandMap.getMap());
		} else {
			result = outfittingDAO.insertOutfittingArea(commandMap.getMap());
		}
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveAddOutfitting
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택된 팀별 구분에 해당하는 값을 프로젝트에 추가하는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveAddOutfitting(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> outfittingList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		int result = 0;

		for (Map<String, Object> rowData : outfittingList) {

			// 필수 항목
			rowData.put("project_no", commandMap.get("project_no"));
			rowData.put("revision", commandMap.get("revision"));
			rowData.put("paint_gbn", commandMap.get("paint_gbn"));
			rowData.put("team_count", commandMap.get("team_count"));
			rowData.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			int nExist = outfittingDAO.selectExistOutfittingPaintItem(rowData);

			if (nExist > 0) {
				result = outfittingDAO.deleteOutfittingPaintItem(rowData);
				//throw new DisException("paint.message11", (String) rowData.get("paint_item"));
			}
			result = outfittingDAO.insertOutfittingPaintItem(rowData);
			if (result == 0) {
				throw new DisException();
			}
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveMinusOutfitting
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택된 팀별 구분에 해당하는 값을 프로젝트에서 삭제하는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveMinusOutfitting(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> outfittingList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		int result = 0;

		for (Map<String, Object> rowData : outfittingList) {
			// 필수 항목
			rowData.put("project_no", commandMap.get("project_no"));
			rowData.put("revision", commandMap.get("revision"));
			rowData.put("paint_gbn", commandMap.get("paint_gbn"));
			rowData.put("team_count", commandMap.get("team_count"));
			rowData.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			result = outfittingDAO.deleteOutfittingPaintItem(rowData);
			if (result == 0) {
				throw new DisException();
			}
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : outfittingExcelExport
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀의 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View outfittingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Team Name");
		colName.add("Paint Code");
		colName.add("Paint Desc");
		colName.add("Quantity");
		colName.add("Theory Quantity");

		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = outfittingDAO.selectOutfittingExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();

			row.add(rowData.get("team_desc"));
			row.add(rowData.get("paint_item"));
			row.add(rowData.get("item_desc"));
			row.add(rowData.get("quantity"));
			row.add(rowData.get("theory_quantity"));

			colValue.add(row);
		}
		modelMap.put("excelName", commandMap.get("project_no") + "_" + commandMap.get("revision") + "_Outfitting");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}
}
