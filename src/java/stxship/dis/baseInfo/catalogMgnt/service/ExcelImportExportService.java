package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : ExcelImportExportService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 Excel의 Import,Export되었을때 사용되는 서비스
 *     </pre>
 */
public interface ExcelImportExportService extends CommonService {

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
	String catalogAttrExist(CommandMap commandMap);

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
	void catalogExcelImport(CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response)
			throws Exception;

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
	View catalogExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

}
