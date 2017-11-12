package stxship.dis.ems.partList.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("emsPartListDAO")
public class EmsPartListDAO extends CommonDAO {
	/**
	 * @메소드명 : sscBuyBuyMainList
	 * @날짜 : 2016. 3. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> emsPartListMainList(Map<String, Object> map) {
		return selectListErp("emsPartListMain.emsPartListMainList", map);
	}

	/**
	 * @메소드명 : procEmsPartListSaveAction
	 * @날짜 : 2016. 3. 30.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param map
	 */
	public void procEmsPartListSaveAction(Map<String, Object> map) {
		selectOneErp("emsPartListMain.procEmsPartListSaveAction", map);
	}

	/**
	 * @메소드명 : emsPartListJobList
	 * @날짜 : 2016. 3. 30.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS JOB LIST 출력
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> emsPartListJobList(Map<String, Object> map) {
		return selectListErp("emsPartListMain.emsPartListJobList", map);
	}

	/**
	 * @메소드명 : emsPartListSelecteOne
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> emsPartListSelectOne(Map<String, Object> map) {
		return selectOneErp("emsPartListMain.emsPartListSelectOne", map);
	}

	/**
	 * @메소드명 : emsPartListBomDetail
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS PARTLIST 세부 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> emsPartListBomDetail(Map<String, Object> map) {
		return selectListErp("emsPartListMain.emsPartListBomDetail", map);
	}

	/**
	 * @메소드명 : emsPartListMainList
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> emsPartListProjectCopyNextList(Map<String, Object> map) {
		return selectListErp("emsPartListMain.emsPartListProjectCopyNextList", map);
	}

	/**
	 * @메소드명 : emsPartListId
	 * @날짜 : 2016. 4. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PartList ID 구함
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String emsPartListId(Map<String, Object> map) {
		return selectOneErp("emsPartListMain.emsPartListId", map);
	}

}
