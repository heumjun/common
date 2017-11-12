package stxship.dis.baseInfo.catalogMgnt.service;

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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.baseInfo.catalogMgnt.dao.ExcelImportExportDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.GenericExcelView;

/**
 * @파일명 : ExcelImportExportServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 Excel의 Import,Export되었을때 사용되는 서비스
 *     </pre>
 */
@Service("excelImportExportService")
public class ExcelImportExportServiceImpl extends CommonServiceImpl implements ExcelImportExportService {

	@Resource(name = "excelImportExportDAO")
	private ExcelImportExportDAO excelImportExportDAO;

	/**
	 * @메소드명 : catalogAttrExist
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 업로드시에 업로드된 Catalog속성이 있는지를 확인
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public String catalogAttrExist(CommandMap commandMap) {
		String existYn = (String) excelImportExportDAO.selectOne("infoCatalogAttrExist.selectExistCatalogAttrUpload",
				commandMap.getMap());
		return existYn;
	}

	/**
	 * @메소드명 : catalogExcelImport
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
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
	public void catalogExcelImport(CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response)
			throws Exception {
		int result = 0;
		StringBuffer sb = null;
		Map<String, Object> param = new HashMap<String, Object>();
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		param.put("catalog_code", commandMap.get("catalog_code") == null ? "" : commandMap.get("catalog_code"));

		Workbook workbook = WorkbookFactory.create(new FileInputStream(DecryptFile));
		Sheet sheet = workbook.getSheetAt(0);

		Iterator<Row> rowIterator = sheet.iterator();

		List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();
		while (rowIterator.hasNext()) {
			Row row = rowIterator.next();

			// 첫번째는 컬럼 정보
			if (row.getRowNum() != 0) {
				// Map에 insert 파라미트 설정한다.
				uploadList.add(toMap(row));
			}
		}

		//복호화 파일 삭제
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		// NULL 체크한다.
		if (uploadList.size() > 0) {
			for (Map<String, Object> rowData : uploadList) {
				if ("".equals(rowData.get("attribute_type")) || "".equals(rowData.get("attribute_code"))) {
					sb = resultPopUp("EXCEL의 ATTRUBUTE_TYPE, ATTRIBUTE_CODE는 필수 입력값 입니다.");
					break;
				}
			}
		}
		if (sb == null) {
			if (DisConstants.Y.equals(commandMap.get("delete_yn"))) {
				result = excelImportExportDAO.deleteCatalogAttrExist(param);
			}
			for (Map<String, Object> rowData : uploadList) {
				result = excelImportExportDAO.insertCatalogAttrUpload(rowData);
			}

			param.put("p_catalog_code", commandMap.get("catalog_code") == null ? "" : commandMap.get("catalog_code"));

			// 체크 프로시저 호출
			result = excelImportExportDAO.procedureCatalogCheck(param);

			if (param.get("p_err_code") != null && "S".equals(param.get("p_err_code"))) {
				// 저장 프로시저 호출
				result = excelImportExportDAO.procedureCatalogUpload(param);

				if (param.get("p_err_code") != null && !"S".equals(param.get("p_err_code"))) {
					// 오류 처리
					sb = resultPopUp((String) param.get("p_err_msg"));
				}
			} else {
				// 오류 처리
				sb = resultPopUp((String) param.get("p_err_msg"));
			}

			if (sb == null) {
				sb = resultPopUp("엑셀 업로드 완료되었습니다.");
			}
		}
		if (result == 0) {
			// 실패한경우
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			if (sb == null) {
				resultPopUp("실패했습니다.");
			}
		}
		// 결과값에 따른 메시지를 담아 전송
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().println(sb);
	}

	/**
	 * @메소드명 : catalogExcelExport
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
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
	public View catalogExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("CATALOG");
		colName.add("ITEM/BOM속성 구분");
		colName.add("물성치");
		colName.add("물성치항목");
		colName.add("물성치 테이터 타입");
		colName.add("상위 물성치");
		colName.add("최소값");
		colName.add("최대값");
		colName.add("속성값");
		colName.add("채번코드");
		colName.add("상위속성");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = excelImportExportDAO.selectExcelDownLoad(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add((String) rowData.get("CATALOG_CODE"));
			row.add((String) rowData.get("ATTRIBUTE_TYPE"));
			row.add((String) rowData.get("ATTRIBUTE_CODE"));
			row.add((String) rowData.get("ATTRIBUTE_NAME"));
			row.add((String) rowData.get("ATTRIBUTE_DATA_TYPE"));
			row.add((String) rowData.get("ASSY_ATTRIBUTE_CODE"));

			row.add(rowData.get("ATTRIBUTE_DATA_MIN") == null ? "" : String.valueOf(rowData.get("ATTRIBUTE_DATA_MIN")));
			row.add(rowData.get("ATTRIBUTE_DATA_MAX") == null ? "" : String.valueOf(rowData.get("ATTRIBUTE_DATA_MAX")));
			row.add((String) rowData.get("VALUE_CODE"));
			row.add((String) rowData.get("ITEM_MAKE_VALUE"));
			row.add((String) rowData.get("ASSY_VALUE_CODE"));

			colValue.add(row);
		}

		modelMap.put("excelName", "Catalog");

		modelMap.put("colName", colName);

		modelMap.put("colValue", colValue);

		return new GenericExcelView();

	}

	public Map<String, Object> toMap(Row row) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("catalog_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
		map.put("attribute_type", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1)));
		map.put("attribute_code", row.getCell(2) == null ? "" : DisExcelUtil.getCellValue(row.getCell(2)));
		map.put("attribute_name", row.getCell(3) == null ? "" : DisExcelUtil.getCellValue(row.getCell(3)));
		map.put("attribute_data_type", row.getCell(4) == null ? "" : DisExcelUtil.getCellValue(row.getCell(4)));
		map.put("assy_attribute_code", row.getCell(5) == null ? "" : DisExcelUtil.getCellValue(row.getCell(5)));
		map.put("attribute_data_min", row.getCell(6) == null ? "" : DisExcelUtil.getCellValue(row.getCell(6)));
		map.put("attribute_data_max", row.getCell(7) == null ? "" : DisExcelUtil.getCellValue(row.getCell(7)));
		map.put("value_code", row.getCell(8) == null ? "" : DisExcelUtil.getCellValue(row.getCell(8)));
		map.put("value_name", row.getCell(9) == null ? "" : DisExcelUtil.getCellValue(row.getCell(9)));
		map.put("assy_value_code", row.getCell(10) == null ? "" : DisExcelUtil.getCellValue(row.getCell(10)));

		return map;
	}

	public StringBuffer resultPopUp(String message) {
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\" >");
		sb.append("alert('" + message + "');");
		sb.append("location.href='popUpCatalogExcelUpload.do';");
		sb.append("</script>");

		return sb;
	}
}
