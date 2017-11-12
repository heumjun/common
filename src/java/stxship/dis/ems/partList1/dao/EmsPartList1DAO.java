package stxship.dis.ems.partList1.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("emsPartList1DAO")
public class EmsPartList1DAO extends CommonDAO {
	
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
	 * 
	 * @메소드명	: selectEmsPartList1
	 * @날짜     : 2017. 2. 1.
	 * @작성자    : 황성준
	 * @설명		: 
	 * <pre>
	 * USC 리스트 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEmsPartList1(String queryId, Map<String, Object> map) {
		printQueryId(queryId);
		disSession.selectList(queryId, map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscCodeNameList
	 * @날짜     : 2017. 2. 1.
	 * @작성자    : 황성준
	 * @설명		: 
	 * <pre>
	 *  uscCodeNameList 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscCodeNameList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectList(map.get(DisConstants.MAPPER_NAME) + ".list", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: gridPartListDataInsert
	 * @날짜     : 2017. 2. 1.
	 * @작성자    : 황성준
	 * @설명		: 
	 * <pre>
	 * gridPartListDataInsert 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> gridPartListMainInsert(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne(map.get(DisConstants.MAPPER_NAME) + ".mainInsert", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: gridPartListMainDelete
	 * @날짜     : 2017. 2. 1.
	 * @작성자    : 황성준
	 * @설명		: 
	 * <pre>
	 * gridPartListMainDelete 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> gridPartListMainDelete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne(map.get(DisConstants.MAPPER_NAME) + ".mainDelete", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: gridPartListSubDelete
	 * @날짜     : 2017. 2. 1.
	 * @작성자    : 황성준
	 * @설명		: 
	 * <pre>
	 * gridPartListSubDelete 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> gridPartListSubDelete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne(map.get(DisConstants.MAPPER_NAME) + ".subDelete", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: gridPartListSubInsert
	 * @날짜     : 2017. 2. 1.
	 * @작성자    : 황성준
	 * @설명		: 
	 * <pre>
	 * gridPartListSubInsert 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> gridPartListSubInsert(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne(map.get(DisConstants.MAPPER_NAME) + ".subInsert", map);
		return map;
	}

}
