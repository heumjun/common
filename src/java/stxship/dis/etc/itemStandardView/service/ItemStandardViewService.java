package stxship.dis.etc.itemStandardView.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : ItemStandardViewService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ItemStandardView에서 사용되는 서비스
 *     </pre>
 */
public interface ItemStandardViewService extends CommonService {

	List<Map<String, Object>> selectItemStandardViewLevel1(CommandMap commandMap);

	List<Map<String, Object>> selectItemStandardViewLevel2(CommandMap commandMap);

	List<Map<String, Object>> selectItemStandardViewLevel3(CommandMap commandMap);

	List<Map<String, Object>> itemStandardViewSearch(CommandMap commandMap);
}
