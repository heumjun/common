package stxship.dis.etc.documentView.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : DocumentViewService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 8. 31.
 * @작성자 : 정재동
 * @설명
 * 
 * 	<pre>
 * DocumentView에서 사용되는 서비스
 *     </pre>
 */
public interface DocumentViewService extends CommonService {

	List<Map<String, Object>> selectDocumentView(CommandMap commandMap);

	View documentFileDownload(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, Object> documentAddSave(HttpServletResponse response, HttpServletRequest request, CommandMap commandMap)throws Exception;

	Map<String, Object> documentDelete(HttpServletResponse response, HttpServletRequest request, CommandMap commandMap)throws Exception;

	
}
