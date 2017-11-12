package stxship.dis.common.util;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;

/**
 * @파일명 : DisPageUtil.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 그리드에서 표현되어질 페이지정보를 취득하기위한 클레스
 *     </pre>
 */
public class DisPageUtil {
	/**
	 * @메소드명 : getPageCount
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드의 페이지 사이즈와 리스트 총 사이즈를 이용해 라스트 페이지를 구한다.
	 *     </pre>
	 * 
	 * @param p_pageSize
	 * @param p_listRowCnt
	 * @return
	 */
	public static int getPageCount(Object p_pageSize, Object p_listRowCnt) {
		int pageSize = 99999;
		int listRowCnt = 1;

		if (p_pageSize != null) {
			pageSize = Integer.parseInt(p_pageSize.toString());
		}
		if (p_listRowCnt != null) {
			listRowCnt = Integer.parseInt(p_listRowCnt.toString());
		}
		int pageCount = 0;
		int remain;

		// 총 페이지 수를 구하기 위한 나머지 계산
		remain = listRowCnt % pageSize;
		if (remain == 0)
			pageCount = listRowCnt / pageSize;
		else
			pageCount = listRowCnt / pageSize + 1;

		return pageCount;
	}

	/**
	 * @메소드명 : actionPageBefore
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 페이징 작업 전처리
	 * 1. SSC 메인에 사용
	 * 2. START NO와 END NO를 구함
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public static CommandMap actionPageBefore(CommandMap commandMap) {
		// 페이징 처리 START
		int pageSize = Integer.parseInt(commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE).toString());
		int curPageNo = Integer.parseInt(commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO).toString());

		// 페이지 전처리
		int p_page_start_no = (curPageNo - 1) * pageSize;
		int p_page_end_no = p_page_start_no + pageSize;

		commandMap.put("p_page_start_no", p_page_start_no);
		commandMap.put("p_page_end_no", p_page_end_no);

		return commandMap;
	}

	/**
	 * @메소드명 : actionPageAfter
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 페이징 작업 후처리
	 * 1. SSC 메인에 사용
	 * 2. 현재 페이지, 마지막 페이지, 총 레코드 수를 구해서 DB리스트와 함께 RETUREN MAP에 넣어준다.
	 *     </pre>
	 * 
	 * @param commandMap
	 *            : 초기 받아온 맵
	 * @param result
	 *            : 리턴할 맵
	 * @param list
	 *            : DB 데이터 리스트
	 * @return
	 */
	public static Map<String, Object> actionPageAfter(CommandMap commandMap, Map<String, Object> result,
			List<Map<String, Object>> list) {

		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);

		if(list.size() > 0){
			// 리스트 최대 값을 구함.
			// 첫번째 행의 cnt를 받아옴.
			Map<String, Object> map = list.get(0);
			int listRowCnt = Integer.parseInt(map.get("cnt").toString());
	
			// 라스트 페이지를 구한다.
			Object lastPageCnt = "page>total";
			if (!"N".equals(commandMap.get("isPaging"))) {
				lastPageCnt = getPageCount(pageSize, listRowCnt);
			}
	
			// 페이징에 필요한 값들 넣음
			result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
			result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
			result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
			result.put(DisConstants.GRID_RESULT_DATA, list);
		}
		return result;
	}
	
}
