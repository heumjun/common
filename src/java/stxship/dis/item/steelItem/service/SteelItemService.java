package stxship.dis.item.steelItem.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : BomStatusService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 10. 4.
 * @작성자	: 황성준
 * @설명
 * 
 * 	<pre>
 * Bom현황에서 사용되는 서비스
 *     </pre>
 */
public interface SteelItemService extends CommonService {

	public Map<String, Object> getSteelItemList(CommandMap commandMap);
	
	public Map<String, Object> saveSteelItem(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> getSteelItemGridData(Map<String, Object> map);
	
}
