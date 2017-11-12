package stxship.dis.etc.itemStandardUpload.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : ItemStandardUploadDAO.java
 * @프로젝트 : DIMS
 * @날짜 : 2016. 9. 19.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * ItemStandardUpload에서 사용되는 DAO
 *     </pre>
 */
@Repository("itemStandardUploadDAO")
public class ItemStandardUploadDAO extends CommonDAO {
	
	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;

	public List<Map<String, Object>> getSelectBoxDataList(Map<String, Object> map) {
		return selectList("itemStandardUpload." + map.get("p_query"), map);
	}
	
	public <T> T selectOne(String queryId, Object params) {
		printQueryId(queryId);
		return disSession.selectOne(queryId, params);
	}
	
	public int insertFileUpLoad(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return insert("itemStandardUpload.insert", map);
	}
	
	public List<Map<String, Object>> getServerInfoList() {
		return selectList("itemStandardUpload.selectServerInfoList", null);
	}
	
	/**
	 * @메소드명 : selectCatalogList
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *	카탈로그 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectCatalogList(Map<String, Object> map) {
		return selectList("itemStandardUpload.selectCatalogList", map);
	}

}
