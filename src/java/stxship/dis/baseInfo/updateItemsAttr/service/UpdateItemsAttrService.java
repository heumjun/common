package stxship.dis.baseInfo.updateItemsAttr.service;

import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : UpdateItemsAttrService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Update Item Attr 메뉴가 선택되었을때 사용되는 서비스
 *     </pre>
 */
public interface UpdateItemsAttrService extends CommonService {

	/**
	 * @메소드명 : updatePlmErpDBcommandMap
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 인포트 된 내용을 PLM ERP DB에 업데이트 한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> updatePlmErpDBcommandMap(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : itemAttributeExcelImport
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀의 내용을 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param response
	 * @throws Exception
	 */
	public void itemAttributeExcelImport(CommonsMultipartFile file, HttpServletResponse response, CommandMap commandMap) throws Exception;

}
