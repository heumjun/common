package stxship.dis.bom.bomNeeds.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : BomStatusService.java
 * @프로젝트 : DIS
 * @날짜 : 2017. 1. 15.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * Bom현황에서 사용되는 서비스
 *     </pre>
 */
public interface BomNeedsService extends CommonService {

	public Map<String, Object> bomNeedsList(CommandMap commandMap) throws Exception;

	public View bomNeedsExcelList(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
}
