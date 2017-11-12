package stxship.dis.usc.uscMain.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : UscDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 14.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * Usc에서 사용되는 DAO
 *     </pre>
 */
@Repository("uscDAO")
public class UscDAO extends CommonDAO {
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
	 * 
	 * @메소드명	: getUscList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * USC 리스트 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectUscList(String queryId, Map<String, Object> map) {
		printQueryId(queryId);
		disSession.selectList(queryId, map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscCodeNameList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 *  uscCodeNameList 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscCodeNameList(Map<String, Object> map) {
		disSession.selectList(map.get(DisConstants.MAPPER_NAME) + ".list", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscBlockImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscBlockImportCheck 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscBlockImportCheck(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("uscMainList.uscBlockImportCheck", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscActivityImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscActivityImportCheck 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscActivityImportCheck(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("uscMainList.uscActivityImportCheck", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscMainEconoCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscMainEconoCreate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscMainEconoCreate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("uscMainList.uscMainEconoCreate", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscMasterCode
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscMasterCode 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public String uscMasterCode(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return (String) selectOne("uscMainList.uscMasterCode", map);
	}
	
	/**
	 * 
	 * @메소드명	: uscAreaCodeName
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscAreaCodeName 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public String uscAreaCodeName(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return (String) selectOne("uscMainList.uscAreaCodeName", map);
	}
	
	/**
	 * 
	 * @메소드명	: uscMainEcoUpdate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscMainEcoUpdate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscMainEcoUpdate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveUscMain.uscMainEcoUpdate", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscMainEcoCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscMainEcoCreate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscMainEcoCreate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveUscMain.uscMainEcoCreate", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: jobCreateAddCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * jobCreateAddCheck 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> jobCreateAddCheck(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("uscJobCreateList.jobCreateAddCheck", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: jobCreateMoveCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * jobCreateMoveCheck 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> jobCreateMoveCheck(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("uscJobCreateList.jobCreateMoveCheck", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscJobCreateEconoCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscJobCreateEconoCreate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscJobCreateEconoCreate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("uscJobCreateList.uscJobCreateEconoCreate", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscJobCreateEcoUpdate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscJobCreateEcoUpdate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscJobCreateEcoUpdate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveUscJobCreate.uscJobCreateEcoUpdate", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: uscJobCreateEcoCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscJobCreateEcoCreate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> uscJobCreateEcoCreate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveUscJobCreate.uscJobCreateEcoCreate", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: restoreUscValidationJobCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * Restore 하기전 A상태의 같은 아이템코드가 이미 존재하는 경우 에러
	 * </pre>
	 * @param map
	 * @return
	 */
	public int restoreUscValidationJobCreate(Map<String, Object> map) {
		return disSession.selectOne("saveUscJobCreate.restoreUscValidationJobCreate", map);
	}
	
	/**
	 * 
	 * @메소드명	: restoreUscJobCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * restoreUscJobCreate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> restoreUscJobCreate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveUscJobCreate.uscJobCreateEcoRestore", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: cancelUscJobCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * cancelUscJobCreate 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> cancelUscJobCreate(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne("saveUscJobCreate.uscJobCreateEcoCancel", map);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: gridUscDataInsert
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * gridUscDataInsert 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> gridUscDataInsert(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectOne(map.get(DisConstants.MAPPER_NAME) + ".insert", map);
		return map;
	}

}
