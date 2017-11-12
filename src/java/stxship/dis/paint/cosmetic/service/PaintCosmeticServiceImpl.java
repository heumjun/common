package stxship.dis.paint.cosmetic.service;

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
import stxship.dis.paint.cosmetic.dao.PaintCosmeticDAO;

/**
 * @파일명 : PaintCosmeticServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Cosmetic 서비스
 *     </pre>
 */
@Service("paintCosmeticService")
public class PaintCosmeticServiceImpl extends CommonServiceImpl implements PaintCosmeticService {

	@Resource(name = "paintCosmeticDAO")
	private PaintCosmeticDAO paintCosmeticDAO;

	/**
	 * @메소드명 : saveCosmeticArea
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CosmeticArea를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveCosmeticArea(CommandMap commandMap) throws Exception {
		int nExist = paintCosmeticDAO.selectExistCosmeticArea(commandMap.getMap());
		int result = 0;
		if (nExist > 0) {
			result = paintCosmeticDAO.updateCosmeticArea(commandMap.getMap());
		} else {
			result = paintCosmeticDAO.insertCosmeticArea(commandMap.getMap());
		}
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveAddCosmetic
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * [+] 를 선택했을때 Cosmetic저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveAddCosmetic(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> cosmeticList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		for (Map<String, Object> rowData : cosmeticList) {
			// 필수 항목
			rowData.put("project_no", commandMap.get("project_no"));
			rowData.put("revision", commandMap.get("revision"));
			rowData.put("paint_gbn", commandMap.get("paint_gbn"));
			rowData.put("team_count", commandMap.get("team_count"));
			rowData.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			int nExist = paintCosmeticDAO.selectExistCosmeticPaintItem(rowData);
			if (nExist > 0) {
				result = paintCosmeticDAO.deleteCosmeticPaintItem(rowData);
				/*throw new DisException("paint_massage11", (String) rowData.get("paint_item"));*/
			}
			result = paintCosmeticDAO.insertCosmeticPaintItem(rowData);
			if (result == 0) {
				throw new DisException();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveMinusCosmetic
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * [-] 를 선택했을때 Cosmetic삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveMinusCosmetic(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> cosmeticList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		int result = 0;

		for (Map<String, Object> rowData : cosmeticList) {
			// 필수 항목
			rowData.put("project_no", commandMap.get("project_no"));
			rowData.put("revision", commandMap.get("revision"));
			rowData.put("paint_gbn", commandMap.get("paint_gbn"));
			rowData.put("team_count", commandMap.get("team_count"));
			rowData.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			result = paintCosmeticDAO.deleteCosmeticPaintItem(rowData);
			if (result == 0) {
				throw new DisException();
			}
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : cosmeticExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Cosmetic엑셀 정보를 출력.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View cosmeticExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Team Name");
		colName.add("Paint Code");
		colName.add("Paint Desc");
		colName.add("Quantity");
		colName.add("Theory Quantity");

		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = paintCosmeticDAO.selectCosmeticExport(commandMap.getMap());

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
		modelMap.put("excelName", commandMap.get("project_no") + "_" + commandMap.get("revision") + "_Cosmetic");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

	/**
	 * @메소드명 : getGridData
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * selectCosmeticList인경우 선택된 Cosmetic정보를 얻기위해
	 * searchGbn으로 입력받은 키로 해당하는 Cosmeticm 정보를 취득하여 반환한다.
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		String mapperName = (String) map.get(DisConstants.MAPPER_NAME);
		String sqlId;
		if ("selectCosmeticList".equals(mapperName)) {
			String mapperPreName = (String) map.get("searchGbn");
			if (map.get("searchGbn").toString().startsWith("etc")) {
				mapperPreName = "cosmeticEtc";
			}
			sqlId = mapperPreName + DisConstants.MAPPER_SEPARATION + DisConstants.MAPPER_GET_LIST;
		} else {
			sqlId = mapperName + DisConstants.MAPPER_SEPARATION + DisConstants.MAPPER_GET_LIST;
		}
		List<Map<String, Object>> result = null;
		// 해당하는 Cosmetic 쿼리가 존재 하지 않으면 ETC쿼리를 실행하여 반환한다.
		try {
			result = paintCosmeticDAO.selectList(sqlId, map);
		} catch (Exception e) {
			sqlId = "cosmeticEtc" + DisConstants.MAPPER_SEPARATION + DisConstants.MAPPER_GET_LIST;
			result = paintCosmeticDAO.selectList(sqlId, map);
		}
		return result;
	}

	/**
	 * @메소드명 : getGridListSize
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * SearchGbn에 해당하는 그리드리스트 사이즈를 취득
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public Object getGridListSize(Map<String, Object> map) {
		String mapperName = (String) map.get(DisConstants.MAPPER_NAME);
		String sqlId;
		if ("selectCosmeticList".equals(mapperName)) {
			String mapperPreName = (String) map.get("searchGbn");
			if (map.get("searchGbn").toString().startsWith("etc")) {
				mapperPreName = "cosmeticEtc";
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
			sqlId = mapperPreName + DisConstants.MAPPER_SEPARATION + DisConstants.MEPPER_GET_TOTAL_RECORD;
		} else {
			sqlId = mapperName + DisConstants.MAPPER_SEPARATION + DisConstants.MEPPER_GET_TOTAL_RECORD;
		}
		return paintCosmeticDAO.selectOne(sqlId, map);
	}
}
