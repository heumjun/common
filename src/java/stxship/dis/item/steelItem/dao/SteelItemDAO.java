package stxship.dis.item.steelItem.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : steelItemDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 10. 4.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * steelItem에서 사용되는 DAO
 *     </pre>
 */
@Repository("steelItemDAO")
public class SteelItemDAO extends CommonDAO {
	
	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;

	/**
	 * 
	 * @메소드명	: selectSteelItemList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * SteelItem 리스트 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectSteelItemList(String queryId, Map<String, Object> map) {
		printQueryId(queryId);
		disSession.selectList(queryId, map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: saveSteelItem
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * saveSteelItem 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> saveSteelItem(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveSteelItem.update", map);
		return map;
	}
	
}
