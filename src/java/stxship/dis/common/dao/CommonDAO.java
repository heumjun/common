package stxship.dis.common.dao;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @파일명 : CommonDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * 공통 DAO
 *     </pre>
 */
@Repository("commonDAO")
public class CommonDAO {
	protected Log log = LogFactory.getLog(CommonDAO.class);

	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;

	/** ERP */
	@Autowired
	private SqlSessionTemplate erpSession;

	/** DPS */
	@Autowired
	private SqlSessionTemplate dpsSession;

	/**
	 * @메소드명 : printQueryId
	 * @날짜 : 2016. 7. 5.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     로그출력
	 *     </pre>
	 * 
	 * @param queryId
	 */
	protected void printQueryId(String queryId) {
		if (log.isDebugEnabled()) {
			log.debug("\t QueryId  \t:  " + queryId);
		}
	}

	public int insert(String queryId, Object params) {
		printQueryId(queryId);
		return disSession.insert(queryId, params);
	}

	public int update(String queryId, Object params) {
		printQueryId(queryId);
		return disSession.update(queryId, params);
	}

	public int delete(String queryId, Object params) {
		printQueryId(queryId);
		return disSession.delete(queryId, params);
	}

	public Object selectOne(String queryId) {
		printQueryId(queryId);
		return disSession.selectOne(queryId);
	}

	public <T> T selectOne(String queryId, Object params) {
		printQueryId(queryId);
		return disSession.selectOne(queryId, params);
	}

	public List<Object> selectList(String queryId) {
		printQueryId(queryId);
		return disSession.selectList(queryId);
	}

	public List<Map<String, Object>> selectList(String queryId, Object params) {
		printQueryId(queryId);
		return disSession.selectList(queryId, params);
	}

	public int insertErp(String queryId, Object params) {
		printQueryId(queryId);
		return erpSession.insert(queryId, params);
	}

	public int updateErp(String queryId, Object params) {
		printQueryId(queryId);
		return erpSession.update(queryId, params);
	}

	public int deleteErp(String queryId, Object params) {
		printQueryId(queryId);
		return erpSession.delete(queryId, params);
	}

	public Object selectOneErp(String queryId) {
		printQueryId(queryId);
		return erpSession.selectOne(queryId);
	}

	public <T> T selectOneErp(String queryId, Object params) {
		printQueryId(queryId);
		return erpSession.selectOne(queryId, params);
	}

	public List<Object> selectListErp(String queryId) {
		printQueryId(queryId);
		return erpSession.selectList(queryId);
	}

	public List<Map<String, Object>> selectListErp(String queryId, Object params) {
		printQueryId(queryId);
		return erpSession.selectList(queryId, params);
	}

	public int insertDps(String queryId, Object params) {
		printQueryId(queryId);
		return dpsSession.insert(queryId, params);
	}

	public int updateDps(String queryId, Object params) {
		printQueryId(queryId);
		return dpsSession.update(queryId, params);
	}

	public int deleteDps(String queryId, Object params) {
		printQueryId(queryId);
		return dpsSession.delete(queryId, params);
	}

	public Object selectOneDps(String queryId) {
		printQueryId(queryId);
		return dpsSession.selectOne(queryId);
	}

	public <T> T selectOneDps(String queryId, Object params) {
		printQueryId(queryId);
		return dpsSession.selectOne(queryId, params);
	}

	public List<Object> selectListDps(String queryId) {
		printQueryId(queryId);
		return dpsSession.selectList(queryId);
	}

	public List<Map<String, Object>> selectListDps(String queryId, Object params) {
		printQueryId(queryId);
		return dpsSession.selectList(queryId, params);
	}

	public Map<String, Object> manualInfoList(Map<String, Object> map) {
		return selectOne("manualList.manualInfoList", map);
	}
}