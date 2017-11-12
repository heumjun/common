package stxship.dis.dwg.dwgApprove.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : DwgApproveService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgApprove에서 사용되는 서비스
 *     </pre>
 */
public interface DwgApproveService extends CommonService {

	Map<String, String> dwgReturn(CommandMap commandMap) throws Exception;

	Map<String, String> dwgApprove(CommandMap commandMap) throws Exception;

	View dwgApproveExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

}
