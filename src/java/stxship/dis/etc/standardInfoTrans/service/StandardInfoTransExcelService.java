package stxship.dis.etc.standardInfoTrans.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : StandardInfoTransExcelService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 4. 18.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 *  기준정보등록요청 엑셀 다운로드 서비스
 *     </pre>
 */
public interface StandardInfoTransExcelService extends CommonService {

	View standardInfoTransMainExcelPrint(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	View standardInfoTransDetailExcelPrint(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	View standardInfoTransDetailExcelPrintItem(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

}
