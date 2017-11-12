package stxship.dis.paint.block.service;

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
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
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
import stxship.dis.paint.importPaint.dao.PaintImportPaintDAO;
import stxship.dis.paint.pattern.dao.PaintPatternDAO;
import stxship.dis.paint.pr.dao.PaintPRDAO;

/**
 * @파일명 : PaintBlockServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 *     PaintBlock 서비스
 *     </pre>
 */
@Service("paintBlockService")
public class PaintBlockServiceImpl extends CommonServiceImpl implements PaintBlockService {

	@Resource(name = "paintBlockDAO")
	private PaintBlockDAO paintBlockDAO;

	@Resource(name = "paintPatternDAO")
	private PaintPatternDAO paintPatternDAO;

	@Resource(name = "paintPRDAO")
	private PaintPRDAO paintPRDAO;

	@Resource(name = "paintImportPaintDAO")
	private PaintImportPaintDAO paintImportPaintDAO;

	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * block정보를 업데이트 하고 난후 처리(재정의)
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataUpdate(Map<String, Object> rowData) {
		// block정보 업데이트
		String superResult = super.gridDataUpdate(rowData);
		if (DisConstants.RESULT_SUCCESS.equals(superResult)) {
			return deletePatternScheme(rowData);
		} else {
			return superResult;
		}
	}

	/**
	 * @메소드명 : gridDataDelete
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * block정보를 삭제한후 처리(재정의)
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataDelete(Map<String, Object> rowData) {
		int deleteResult = 0;
		String superResult = super.gridDataDelete(rowData);
		if (DisConstants.RESULT_SUCCESS.equals(superResult)) {
			// PR의 블럭을 삭제하기 위한 로직
			// Block Code로만 카운트
			rowData.put("blockCntFlag", DisConstants.Y);
			int nExist = paintBlockDAO.duplicateCheck(rowData);
			// 모든 블럭이 삭제되었을경우
			if (nExist == 0) {
				// 해당 호선의 시리즈 리스트를 가져온다.
				List<Map<String, Object>> seriesList = paintImportPaintDAO.selectSeriesProjectNo(rowData);
				Map<String, Object> prBlockDeleteParam;
				for (Map<String, Object> series : seriesList) {
					// PLAN 시리즈가 아닌경우
					if (!"PLAN".equals(series.get("planflag"))) {
						prBlockDeleteParam = new HashMap<String, Object>();
						prBlockDeleteParam.put("project_no", series.get("project_no"));
						prBlockDeleteParam.put("revision", rowData.get("revision"));
						prBlockDeleteParam.put("block_code", rowData.get("block_code"));
						// PR Block을 삭제한다.
						paintPRDAO.deletePaintPRBlock(prBlockDeleteParam);
					}
				}
			}
			// 삭제된 Block정보의 AreaCode의 존재 여부 체크
			int nCnt = paintBlockDAO.selectExistAreaCodeFromBlock(rowData);
			// 존재하는 PatternCode취득
			String sPatternCode = paintBlockDAO.selectExistPatternCode(rowData);
			if (sPatternCode != null) {
				// Pattern Code 설정
				rowData.put("pattern_code", sPatternCode);
				if (nCnt == 0) {
					// Area 삭제
					deleteResult = paintBlockDAO.deletePaintPatternArea(rowData);
					if (deleteResult == 0) {
						return DisMessageUtil.getMessage("paint.message22", "Pattern Area");
					}
				}
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
				int nAreaCnt = paintPatternDAO.selectCountPatternArea(rowData);
				if (nAreaCnt == 0) {
					// 아이템 삭제
					deleteResult = paintPatternDAO.deletePaintPatternAllItem(rowData);
					if (deleteResult == 0) {
						return DisMessageUtil.getMessage("paint.message22", "아이템");
					}
					// Pattern 삭제
					deleteResult = paintPatternDAO.deletePaintPattern(rowData);
					if (deleteResult == 0) {
						return DisMessageUtil.getMessage("paint.message22", "Pattern");
					}
				}
			}
		} else {
			return superResult;
		}
		return DisConstants.RESULT_SUCCESS;
	}

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2016. 5. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block정보를 추가한후 처리(재정의)
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataInsert(Map<String, Object> rowData) {
		// block정보 업데이트
		String superResult = super.gridDataInsert(rowData);
		if (DisConstants.RESULT_SUCCESS.equals(superResult)) {
			return deletePatternScheme(rowData);
		} else {
			return superResult;
		}
	}

	/**
	 * @메소드명 : deletePatternScheme
	 * @날짜 : 2016. 5. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern코드가 존재여부 체크후 확정 해제 처리
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	public String deletePatternScheme(Map<String, Object> rowData) {
		int updateResult = 0;
		// Pattern코드가 존재여부 체크
		String sPatternCode = paintBlockDAO.selectExistPatternCode(rowData);
		if (sPatternCode != null) {
			// Pattern Code 설정
			rowData.put("pattern_code", sPatternCode);
			// Pattern 확정 해제
			updateResult = paintPatternDAO.deletePatternScheme(rowData);
			if (updateResult == 0) {
				// 확정 해제가 안된경우는 확정이 안되어있어 Scheme테이블에 데이터가 없는경우이므로 업무흐름상에
				// 정상처리
			}
			updateResult = paintPatternDAO.updatePatternCodeUndefine(rowData);
			if (updateResult == 0) {
				// 확정 해제가 안된경우는 확정이 안되어있어 이미 확정플러그가 D로 되어있으므로 업무흐름상에 정상처리
			}
		}
		return DisConstants.RESULT_SUCCESS;
	}

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 중복 카운트를 체크(재정의)
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCnt(Map<String, Object> rowData) {
		String result = super.getDuplicationCnt(rowData);
		if (!DisConstants.RESULT_SUCCESS.equals(result)) {
			return DisMessageUtil.getMessage("paint.message2",
					new Object[] { rowData.get("block_code"), rowData.get("area_code") });
		} else {
			return result;
		}
	}

	/**
	 * @메소드명 : blockExcelImport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * block정보를 엑셀로부터 취득
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@Override
	public ModelAndView blockExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception {

		Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
		Sheet sheet = workbook.getSheetAt(0);

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
			System.out.println(row.getRowNum() + ">>" + row.getCell(0) + "," + row.getCell(1));
			// 첫번째는 컬럼 정보
			if (row.getRowNum() == 0) {
				System.out.println("====Excel to DB Insert====");
			} else {
				if (row.getCell(0) == null) {
					break;
				}
				// Map에 insert 파라미트 설정한다.
				uploadList.add(toMap(row, project_no, revision));
			}

		}
		
		//복호화 파일 삭제
		DisEGDecrypt.deleteDecryptFile(file);

		ModelAndView mav = new ModelAndView();
		mav.addObject("uploadList", JSONArray.fromObject(uploadList).toString());
		mav.setViewName("paint/popUp/popUpBlockExcelList");
		return mav;
	}

	private Map<String, Object> toMap(Row row, Object projectNo, Object revision) {
		// 편집해야됩니다.
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("project_no", projectNo);
		map.put("revision", revision);
		map.put("block_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
		map.put("area_code", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1)));
		map.put("area_desc", row.getCell(2) == null ? "" : DisExcelUtil.getCellValue(row.getCell(2)));
		map.put("area", row.getCell(3) == null ? "0" : DisExcelUtil.getCellValue(row.getCell(3)));

		return map;
	}

	/**
	 * @메소드명 : saveExcelPaintBlock
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀데이터로부터 Paint Block을 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveExcelPaintBlock(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> blockList = DisJsonUtil.toList(commandMap.get("blockList"));
		// 중복 체크
		boolean isError = false;
		for (Map<String, Object> rowData : blockList) {
			rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.NO);
			rowData.put(DisConstants.ERROR_MSG_KEY, "");
			int nExist = paintBlockDAO.duplicateCheck(rowData);

			int nNotExist = paintBlockDAO.selectExistAreaCodeCnt(rowData);

			if (nExist == 0 && nNotExist > 0) {
				// 정상
			} else {
				// 오류 발생
				rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.Y);
				if (nExist > 0) {
					rowData.put(DisConstants.ERROR_MSG_KEY,
							DisMessageUtil.getMessage("common.message4", "Block Code의 Area Code"));
				} else if (nExist == 0 && nNotExist == 0) {
					rowData.put(DisConstants.ERROR_MSG_KEY, DisMessageUtil.getMessage("common.message5", "Area Code"));
				}
				isError = true;
			}
		}
		if (isError) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			result.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.message6"));
			result.put("blockList", blockList);
			return result;
		} else {
			// 데이터 입력
			int insertResult = 0;
			for (Map<String, Object> rowData : blockList) {
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				insertResult = paintBlockDAO.paintBlockInsert(rowData);
				if (insertResult == 0) {
					throw new DisException("common.message6");
				} else {
					deletePatternScheme(rowData);
				}
			}
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		}
	}

	/**
	 * @메소드명 : blockExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * block정보를 엑셀로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View blockExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Block Code");
		colName.add("Area Code");
		colName.add("Area Desc");
		colName.add("Area");

		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = paintBlockDAO.selectBlockExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
			row.add(rowData.get("block_code"));
			row.add(rowData.get("area_code"));
			row.add(rowData.get("area_desc"));
			row.add(rowData.get("area"));
			colValue.add(row);
		}
		modelMap.put("excelName", commandMap.get("project_no") + "_" + commandMap.get("revision") + "_PaintBlock");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}
}
