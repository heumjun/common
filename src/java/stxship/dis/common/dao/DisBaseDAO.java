package stxship.dis.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * @파일명 : DisBaseDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 17.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 		공통 : DIS DAO
 *     </pre>
 */
@Repository("disBaseDAO")
public class DisBaseDAO extends CommonDAO {

	/**
	 * @메소드명 : getSelectBoxDataList
	 * @날짜 : 2015. 12. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		공통 셀렉트 박스 리스트 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getSelectBoxDataList(Map<String, Object> map) {
		return selectList("commonSelectBox." + map.get("p_query"), map);
	}

	/** 
	 * @메소드명	: insertEngineerRegister
	 * @날짜		: 2016. 7. 8.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 엔지니어 등록 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public int insertEngineerRegister(Map<String, Object> map) {
		return insert("saveEngineerRegister.insert", map);
	}
}
