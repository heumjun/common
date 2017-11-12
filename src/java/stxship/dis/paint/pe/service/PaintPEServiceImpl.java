package stxship.dis.paint.pe.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
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
import stxship.dis.paint.block.dao.PaintBlockDAO;
import stxship.dis.paint.pattern.dao.PaintPatternDAO;
import stxship.dis.paint.pe.dao.PaintPEDAO;

/**
 * @파일명 : PaintPEServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint PE 의 서비스
 *     </pre>
 */
@Service("paintPEService")
public class PaintPEServiceImpl extends CommonServiceImpl implements PaintPEService {

	@Resource(name = "paintPEDAO")
	private PaintPEDAO paintPEDAO;

	@Resource(name = "paintBlockDAO")
	private PaintBlockDAO paintBlockDAO;

	@Resource(name = "paintPatternDAO")
	private PaintPatternDAO paintPatternDAO;

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * getDuplicationCnt의 재정의
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCnt(Map<String, Object> rowData) {
		String superResult = super.getDuplicationCnt(rowData);

		if (DisConstants.RESULT_FAIL.equals(superResult)) {
			DisMessageUtil.getMessage("paint.massage6",
					new Object[] { rowData.get("pe_code"), rowData.get("block_code") });
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : peExcelImport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE정보의 인포트 처리
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@Override
	public ModelAndView peExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
		org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);

		List<CellRangeAddress> regionsList = new ArrayList<CellRangeAddress>();
		for (int i = 0; i < sheet.getNumMergedRegions(); i++) {
			regionsList.add(sheet.getMergedRegion(i));
		}

		Iterator<Row> rowIterator = sheet.iterator();

		List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();
		String project_no = (String) commandMap.get("project_no");
		String revision = (String) commandMap.get("revision");

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();
			if (row.getRowNum() > 4) {

				if (row.getCell(4) != null && !isNullBlockCode(row, 4))
					uploadList.add(toMap(regionsList, sheet, row, project_no, revision));
				else if (row.getCell(15) != null && !isNullBlockCode(row, 15))
					uploadList.add(toMap(regionsList, sheet, row, project_no, revision));

			} else {
				System.out.println("====Excel to DB Insert====");
			}
		}
		for (Map<String, Object> excelRow : uploadList) {
			excelRow.put("pre_pe_code", "");
			excelRow.put("pre_pe_color", "");

			String sPrePeCode = getPrePeCode(uploadList, excelRow);

			if ("".equals(sPrePeCode)) {

			} else if ("color_code".equals(sPrePeCode)) {
				excelRow.put("pre_pe_color", "color_code");
			} else {
				excelRow.put("pre_pe_code", excelRow.get(sPrePeCode));
			}
		}

		for (int i = uploadList.size() - 1; i >= 0; i--) {
			Map<String, Object> deleteRow = uploadList.get(i);

			if (null == deleteRow.get("block_code") || "".equals(deleteRow.get("block_code"))) {
				uploadList.remove(i);
			}
		}

		//복호화 파일 삭제
		DisEGDecrypt.deleteDecryptFile(file);
		
		mav.addObject("uploadList", JSONArray.fromObject(uploadList).toString());

		mav.setViewName("paint/popUp/popUpPEExcelList");
		return mav;
	}

	/**
	 * @메소드명 : saveExcelPaintPE
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀에서 입력된 PE정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveExcelPaintPE(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> peList = DisJsonUtil.toList(commandMap.get("peList"));
		// 중복 체크
		boolean isError = false;
		for (Map<String, Object> rowData : peList) {
			rowData.put(DisConstants.IS_ERROR_KEY, "N");
			rowData.put(DisConstants.ERROR_MSG_KEY, "");
			int nExist = paintPEDAO.duplicateCheck(rowData);
			int nNotExist = paintPEDAO.selectExistBlockCodeCnt(rowData);
			if (nExist == 0 && nNotExist > 0) {
				// 정상
			} else {
				// 오류 발생
				isError = true;
				rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.Y);

				if (nExist > 0) {
					rowData.put(DisConstants.ERROR_MSG_KEY,
							DisMessageUtil.getMessage("common.message4", "P.E의 Block Code"));
				} else if (nExist == 0 && nNotExist == 0) {
					rowData.put(DisConstants.ERROR_MSG_KEY, DisMessageUtil.getMessage("common.message5", "Block Code"));
				}
			}
		}

		if (isError) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			result.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.message6"));
			result.put("peList", peList);
			return result;
		} else {

			// 데이터 입력
			for (Map<String, Object> rowData : peList) {
				int insertResult = paintPEDAO.paintPEInsert(rowData);
				if (insertResult == 0) {
					throw new DisException("common.message6");
				}
			}
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		}
	}

	private Map<String, Object> toMap(List<CellRangeAddress> regionsList, Sheet sheet, Row row, Object projectNo,
			Object revision) {
		// 편집해야됩니다.
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("project_no", projectNo);
		map.put("revision", revision);
		map.put("pe_code", row.getCell(1) == null ? "" : getCellValue(regionsList, sheet, row.getCell(1)));
		map.put("pre1_pe_code", row.getCell(2) == null ? "" : getCellValue(regionsList, sheet, row.getCell(2)));
		map.put("pre2_pe_code", row.getCell(3) == null ? "" : getCellValue(regionsList, sheet, row.getCell(3)));
		map.put("block_code", row.getCell(4) == null ? "" : getCellValue(regionsList, sheet, row.getCell(4)));
		map.put("pe_gbn", row.getCell(15) == null ? "" : getCellValue(regionsList, sheet, row.getCell(15)));

		return map;
	}

	private String getPrePeCode(List<Map<String, Object>> uploadList, Map<String, Object> excelRow) {

		if ("선PE".equals(excelRow.get("pe_gbn"))) {

			if (!"".equals(excelRow.get("pre1_pe_code"))) {

				String sPre1PeCode = (String) excelRow.get("pre1_pe_code");
				for (Map<String, Object> searchRow : uploadList) {

					if (sPre1PeCode.equals(searchRow.get("pre1_pe_code")) && "조립PE".equals(searchRow.get("pe_gbn"))) {
						return "pre1_pe_code";
					}
				}
				return "pre2_pe_code";
			} else {
				return "pre2_pe_code";
			}
		} else if ("조립PE".equals(excelRow.get("pe_gbn")) || "".equals(excelRow.get("pe_gbn"))) {

			if (!"".equals(excelRow.get("pre1_pe_code"))) {

				String sPre1PeCode = (String) excelRow.get("pre1_pe_code");
				for (Map<String, Object> searchRow : uploadList) {

					if (sPre1PeCode.equals(searchRow.get("pre1_pe_code")) && "선PE".equals(searchRow.get("pe_gbn"))) {
						return "pre1_pe_code";
					}
				}
				return "color_code";

			} else {
				return "color_code";
			}
		}

		return "";
	}

	private Object getCellValue(List<CellRangeAddress> regionsList, Sheet sheet, Cell cell) {

		for (CellRangeAddress region : regionsList) {
			if (region.isInRange(cell.getRowIndex(), cell.getColumnIndex())) {
				int rowNum = region.getFirstRow();
				int colIndex = region.getFirstColumn();

				cell = sheet.getRow(rowNum).getCell(colIndex);
			}
		}

		return DisExcelUtil.getCellValue(cell);
	}

	private boolean isNullBlockCode(Row row, int nCell) {
		boolean isNull = false;

		if (row.getCell(nCell).getCellType() == 0) {
			if (row.getCell(nCell).getNumericCellValue() == 0)
				isNull = true;
		} else {
			if ("".equals(row.getCell(nCell).getStringCellValue()))
				isNull = true;
		}

		return isNull;
	}

	/**
	 * @메소드명 : peExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE정보의 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View peExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("P.E Code");
		colName.add("PRE PE");
		colName.add("BLOCK");
		colName.add("이관블럭");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = paintPEDAO.selectList("selectPEExport.list", commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add((String) rowData.get("pe_code"));
			row.add((String) rowData.get("pre_pe_code"));
			row.add((String) rowData.get("block_code"));
			row.add((String) rowData.get("trans_block_flag"));

			colValue.add(row);
		}

		modelMap.put("excelName", commandMap.get("project_no") + "_" + commandMap.get("revision") + "_PaintPE");

		modelMap.put("colName", colName);

		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

	public String gridDataUpdate(Map<String, Object> data) {
		// block정보 업데이트
		String superResult = super.gridDataUpdate(data);
		// 데이터 입력
		String sPattern = null;
		int nUndefine = 0;
		data.put("pattern_code", "");
		data.put("season_code", "0");
		if (DisConstants.RESULT_SUCCESS.equals(superResult)) {
			List<Map<String, Object>> allPatternList = paintPatternDAO.selectAllPatternList(data);

			for (Map<String, Object> rowData : allPatternList) {

				if ((sPattern == null || !sPattern.equals(rowData.get("pattern_code")))
						&& ("Y".equals(rowData.get("define_flag")))) {

					// 확정 해제 합니다.
					paintPatternDAO.deletePatternScheme(rowData);
					paintPatternDAO.updatePatternCodeUndefine(rowData);

					sPattern = (String) rowData.get("pattern_code");
					nUndefine = nUndefine + 1;
				}
			}
		} else {
			return superResult;
		}
		return DisConstants.RESULT_SUCCESS;
	}

	@Override
	public String gridDataDelete(Map<String, Object> data) {
		String superResult = super.gridDataDelete(data);
		// 데이터 입력
		String sPattern = null;
		int nUndefine = 0;
		if (DisConstants.RESULT_SUCCESS.equals(superResult)) {
			data.put("pattern_code", "");
			data.put("season_code", "0");
			List<Map<String, Object>> allPatternList = paintPatternDAO.selectAllPatternList(data);

			for (Map<String, Object> rowData : allPatternList) {

				if ((sPattern == null || !sPattern.equals(rowData.get("pattern_code")))
						&& ("Y".equals(rowData.get("define_flag")))) {

					// 확정 해제 합니다.
					paintPatternDAO.deletePatternScheme(rowData);
					paintPatternDAO.updatePatternCodeUndefine(rowData);

					sPattern = (String) rowData.get("pattern_code");
					nUndefine = nUndefine + 1;
				}
			}
		} else {
			return superResult;
		}
		return DisConstants.RESULT_SUCCESS;
	}
}
