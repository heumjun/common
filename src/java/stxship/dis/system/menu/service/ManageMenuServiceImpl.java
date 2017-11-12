package stxship.dis.system.menu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.system.menu.dao.ManageMenuDAO;

/**
 * @파일명 : ManageMenuServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 4. 22.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * 메뉴관련 서비스
 *     </pre>
 */
@Service("manageMenuService")
public class ManageMenuServiceImpl extends CommonServiceImpl implements ManageMenuService {

	@Resource(name = "manageMenuDAO")
	private ManageMenuDAO manageMenuDAO;

	/**
	 * @메소드명 : getApproveAndNoticeList
	 * @날짜 : 2016. 4. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 메인 프레임의 공자사항 리스트, 결제 리스트를 가져온다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> getApproveAndNoticeList(CommandMap commandMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		// APPROVECNT리스트를 구한다.
		result.put(DisConstants.MAIN_APPROVE_CNT_LIST, manageMenuDAO.getApproveCntList(commandMap.getMap()));
		// 공지리스트를 구한다.
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, 7);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, 1);
		result.put(DisConstants.MAIN_NOTICE_LIST, manageMenuDAO.getNoticeMainList(commandMap.getMap()));
		return result;
	}

	/**
	 * @메소드명 : getTreeMenuList
	 * @날짜 : 2016. 4. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  좌측 메뉴 관리 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getTreeMenuList(CommandMap commandMap) {
		// 권한그룹이 선택되어 좌측메뉴를 취득할때는 선택된 권한그룹을 세션에 담는다.
		if (commandMap.get("roleCode") != null && !"".equals(commandMap.get("roleCode"))) {
			DisSessionUtil.setObject("roleCode", commandMap.get("roleCode"));
		} else {
			DisSessionUtil.setObject("roleCode", "");
		}
		// 메뉴의 트리리스트를 구한다.
		return manageMenuDAO.getTreeMenuList(commandMap.getMap());
	}

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용  (그리드 데이터 중복체크)
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCnt(Map<String, Object> rowData) {
		return DisConstants.RESULT_SUCCESS;
	}
	
	/**
	 * @메소드명 : getBookmarkList
	 * @날짜 : 2017. 03. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *  북마크 좌측 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getBookmarkList(CommandMap commandMap) {
		// 권한그룹이 선택되어 좌측메뉴를 취득할때는 선택된 권한그룹을 세션에 담는다.
		if (commandMap.get("roleCode") != null && !"".equals(commandMap.get("roleCode"))) {
			DisSessionUtil.setObject("roleCode", commandMap.get("roleCode"));
		} else {
			DisSessionUtil.setObject("roleCode", "");
		}
		// 메뉴의 트리리스트를 구한다.
		return manageMenuDAO.getBookmarkList(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : getUserBookmarkList
	 * @날짜 : 2017. 03. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *  북마크 우측 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getUserBookmarkList(CommandMap commandMap) {
		// 권한그룹이 선택되어 좌측메뉴를 취득할때는 선택된 권한그룹을 세션에 담는다.
		if (commandMap.get("roleCode") != null && !"".equals(commandMap.get("roleCode"))) {
			DisSessionUtil.setObject("roleCode", commandMap.get("roleCode"));
		} else {
			DisSessionUtil.setObject("roleCode", "");
		}
		// 메뉴의 트리리스트를 구한다.
		return manageMenuDAO.getUserBookmarkList(commandMap.getMap());
	}
	
	@Override
	public Map<String, Object> getMenuId(CommandMap commandMap) {
		return manageMenuDAO.getMenuId(commandMap.getMap());
	}	
}
