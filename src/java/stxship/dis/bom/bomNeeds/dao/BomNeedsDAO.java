package stxship.dis.bom.bomNeeds.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : bomNeedsDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 12. 6.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * bomNeeds에서 사용되는 DAO
 *     </pre>
 */
@Repository("bomNeedsDAO")
public class BomNeedsDAO extends CommonDAO {
	
	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;

	/**
	 * @메소드명 : bomNeedsList
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : ChoHeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 * bomNeeds 리스트 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> bomNeedsList(Map<String, Object> map) {
		disSession.selectList("bomNeedsList.list", map);
		return map;
	}

}
