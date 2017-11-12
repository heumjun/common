package stxship.dis.paint.outfitting.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : OutfittingService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *     Outfitting의 서비스
 *     </pre>
 */
public interface OutfittingService extends CommonService {

	Map<String, String> saveOutfittingArea(CommandMap commandMap) throws Exception;

	Map<String, String> saveAddOutfitting(CommandMap commandMap) throws Exception;

	Map<String, String> saveMinusOutfitting(CommandMap commandMap) throws Exception;

	View outfittingExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}
