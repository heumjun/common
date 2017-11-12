package stxship.dis.system.menu.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface ManageMenuService extends CommonService {

	/**
	 * @메소드명 : getTreeMenuList
	 * @날짜 : 2015. 11. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 좌측 메뉴 트리 리스트를 구한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	List<Map<String, Object>> getTreeMenuList(CommandMap commandMap);

	/**
	 * @메소드명 : getApproveAndNoticeList
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * APPROVE정보와 공지정보를 취득하여 모델에 설정한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> getApproveAndNoticeList(CommandMap commandMap);
	
	List<Map<String, Object>> getBookmarkList(CommandMap commandMap);
	
	List<Map<String, Object>> getUserBookmarkList(CommandMap commandMap);
	
	Map<String, Object> getMenuId(CommandMap commandMap);
}
