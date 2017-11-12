package stxship.dis.paint.stage.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import net.sf.json.JSONArray;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.stage.dao.PaintStageDAO;

/**
 * @파일명 : PaintStageServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Stage 서비스
 *     </pre>
 */
@Service("paintStageService")
public class PaintStageServiceImpl extends CommonServiceImpl implements PaintStageService {

	@Resource(name = "paintStageDAO")
	private PaintStageDAO paintStageDAO;

	/**
	 * @메소드명 : stageExcelImport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀에서 입력된 Stage정보를 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@Override
	public ModelAndView stageExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
		org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);

		List<CellRangeAddress> regionsList = new ArrayList<CellRangeAddress>();
		for (int i = 0; i < sheet.getNumMergedRegions(); i++) {
			regionsList.add(sheet.getMergedRegion(i));
		}
		
		//복호화 파일 삭제
		DisEGDecrypt.deleteDecryptFile(file);

		Iterator<Row> rowIterator = sheet.iterator();

		List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();
			System.out.println(row.getRowNum() + ">>" + row.getCell(0) + "," + row.getCell(1));
			// 첫번째는 컬럼 정보
			if (row.getRowNum() == 0) {
				System.out.println("====Excel to DB Insert====");
			} else {
				// Map에 insert 파라미트 설정한다.
				uploadList.add(toMap(row));
			}

		}
		mav.addObject("uploadList", JSONArray.fromObject(uploadList).toString());

		mav.setViewName("paint/popUp/popUpStageExcelList");
		return mav;
	}

	private Map<String, Object> toMap(Row row) {
		// 편집해야됩니다.
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("stage_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
		map.put("block_rate", row.getCell(1) == null ? "0" : DisExcelUtil.getCellValue(row.getCell(1)));
		map.put("pe_rate", row.getCell(2) == null ? "0" : DisExcelUtil.getCellValue(row.getCell(2)));
		map.put("dock_rate", row.getCell(3) == null ? "0" : DisExcelUtil.getCellValue(row.getCell(3)));
		map.put("quay_rate", row.getCell(4) == null ? "0" : DisExcelUtil.getCellValue(row.getCell(4)));

		return map;
	}

	/**
	 * @메소드명 : saveExcelPaintStage
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀로 입력된 Stage정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveExcelPaintStage(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> stageList = DisJsonUtil.toList(commandMap.get("stageList"));
		// 중복 체크
		boolean isError = false;

		for (Map<String, Object> rowData : stageList) {
			rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.NO);
			int nExist = paintStageDAO.duplicateCheck(rowData);
			if (nExist > 0) {
				isError = true;
				rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.Y);
			}
		}
		if (isError) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			result.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.duplication", ""));
			result.put("stageList", stageList);
			return result;

		} else {
			// 데이터 입력
			for (Map<String, Object> rowData : stageList) {
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				int insertResult = paintStageDAO.paintStageInsert(rowData);
				if (insertResult == 0) {
					throw new DisException("common.message6");
				}
			}
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		}
	}

	/**
	 * @메소드명 : stageExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * stage정보를 엑셀로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View stageExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Stage Code");
		colName.add("Block Rate");
		colName.add("PE Rate");
		colName.add("Dock Rate");
		colName.add("Quay Rate");
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();
		List<Map<String, Object>> list = paintStageDAO.selectStageExport(commandMap.getMap());
		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
			row.add(rowData.get("stage_code"));
			row.add(rowData.get("block_rate"));
			row.add(rowData.get("pe_rate"));
			row.add(rowData.get("dock_rate"));
			row.add(rowData.get("quay_rate"));
			colValue.add(row);
		}
		modelMap.put("excelName", "PaintStage");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();
	}

}
