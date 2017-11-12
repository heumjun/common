package stxship.dis.paint.area.service;

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
import stxship.dis.paint.area.dao.PaintAreaDAO;

/**
 * @파일명 : PaintAreaServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *     PaintAreaService
 *     </pre>
 */
@Service("paintAreaService")
public class PaintAreaServiceImpl extends CommonServiceImpl implements PaintAreaService {

	@Resource(name = "paintAreaDAO")
	private PaintAreaDAO paintAreaDAO;

	/**
	 * @메소드명 : paintAreaExcelImport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 업로드를 실행
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public ModelAndView areaExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception {

		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
		org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);
		Iterator<Row> rowIterator = sheet.iterator();
		List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();
		while (rowIterator.hasNext()) {
			Row row = rowIterator.next();
			System.out.println(row.getRowNum() + ">>" + row.getCell(0) + "," + row.getCell(1) + "," + row.getCell(2)
					+ "," + row.getCell(3));

			// 첫번째는 컬럼 정보
			if (row.getRowNum() == 0) {
				System.out.println("====Excel to DB Insert====");
			} else {
				// Map에 insert 파라미트 설정한다.
				uploadList.add(toMap(row));
			}
		}
		
		DisEGDecrypt.deleteDecryptFile(file);

		ModelAndView mav = new ModelAndView();
		mav.addObject("uploadList", JSONArray.fromObject(uploadList).toString());
		mav.setViewName("paint/popUp/popUpAreaExcelList");
		return mav;
	}

	/**
	 * @메소드명 : paintAreaExcelExport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View paintAreaExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Area Code");
		colName.add("Area Name");
		colName.add("Loss Code");
		colName.add("AF Code");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = paintAreaDAO.paintAreaExcelExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add((String) rowData.get("AREA_CODE"));
			row.add((String) rowData.get("AREA_DESC"));
			row.add((String) rowData.get("LOSS_CODE"));

			String afCode = null;
			if (rowData.get("AF_CODE") == null)
				afCode = "";
			else if (rowData.get("AF_CODE").equals("0"))
				afCode = "Not";
			else
				afCode = (String) rowData.get("AF_CODE");
			row.add(afCode);

			colValue.add(row);
		}
		modelMap.put("excelName", "PaintArea");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();

	}

	/**
	 * @메소드명 : saveExcelPaintArea
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Excel로부터 입력받은 Area정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveExcelPaintArea(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> areaList = DisJsonUtil.toList(commandMap.get("areaList"));
		// 중복 체크
		boolean isError = false;
		for (Map<String, Object> rowData : areaList) {
			rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.NO);
			rowData.put(DisConstants.ERROR_MSG_KEY, "");
			int nExist = paintAreaDAO.duplicateCheck(rowData);
			int nNotExist = paintAreaDAO.selectExistLossCodeCnt(rowData);
			if (nExist == 0 && nNotExist > 0) {
				// 정상
			} else {
				isError = true;
				// 오류 발생
				rowData.put(DisConstants.IS_ERROR_KEY, DisConstants.Y);

				if (nExist > 0) {
					rowData.put(DisConstants.ERROR_MSG_KEY, DisMessageUtil.getMessage("common.message4", "Area Code"));
				} else if (nExist == 0 && nNotExist == 0) {
					rowData.put(DisConstants.ERROR_MSG_KEY, DisMessageUtil.getMessage("common.message5", "Loss Code"));
				}
			}
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (isError) {
			result.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			result.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.message6"));
			result.put("areaList", areaList);
			return result;

		} else {
			// 데이터 입력
			for (Map<String, Object> rowData : areaList) {
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				int insertResult = paintAreaDAO.paintAreaInsert(rowData);
				if (insertResult == 0) {
					throw new DisException("common.message6");
				}
			}
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		}
	}

	private Map<String, Object> toMap(Row row) {
		// 편집해야됩니다.
		Map<String, Object> map = new HashMap<String, Object>();
		Object cell3 = "0";
		if (row.getCell(3) == null || "Not".equals(row.getCell(3).toString()) || "NOT".equals(row.getCell(3).toString())) {
			cell3 = "0";
		} else {
			cell3 = DisExcelUtil.getCellValue(row.getCell(3));
		}

		map.put("area_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
		map.put("area_desc", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1)));
		map.put("loss_code", row.getCell(2) == null ? "" : DisExcelUtil.getCellValue(row.getCell(2)));
		map.put("af_code", cell3);
		System.out.println(cell3);
		return map;
	}

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     중복체크(재정의)
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCnt(Map<String, Object> rowData) {
		String result = super.getDuplicationCnt(rowData);
		int dupResult = 0;
		if (result.equals(DisConstants.RESULT_SUCCESS)) {
			dupResult = paintAreaDAO.selectExistLossCodeCnt(rowData);
			if (dupResult == 0) {
				return DisMessageUtil.getMessage("common.message3", (String) rowData.get("area_code"));
			} else if (result.equals(DisConstants.RESULT_SUCCESS)) {
				dupResult = paintAreaDAO.selectExistAreaDescCnt(rowData);
				if (dupResult > 0) {
					return DisMessageUtil.getMessage("paint.message13",
							new Object[] { rowData.get("area_code"), rowData.get("area_desc") });
				}
			}
		} else {
			return DisMessageUtil.getMessage("common.message1", (String) rowData.get("area_code"));
		}
		return DisConstants.RESULT_SUCCESS;
	}

	/**
	 * @메소드명 : gridDataDelete
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * gridData를 삭제하기전 사용하고 있는곳 체크
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataDelete(Map<String, Object> rowData) {
		int nExist = paintAreaDAO.selectExistUsingAreaCnt(rowData);
		if (nExist > 0) {
			return DisMessageUtil.getMessage("paint.message14", (String) rowData.get("area_code"));
		} else {
			return super.gridDataDelete(rowData);
		}
	}
}
