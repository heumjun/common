/**
 * 
 */
package stxship.dis.dps.dpDataMgmtOld.dao;

import java.util.HashMap;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.dps.common.dao.DpsCommonDAO;

/** 
 * @파일명	: DataMgmtDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 10. 
 * @작성자	: 조중호
 * @설명
 * <pre>
 * 설계시수 Data관리 DAO 
 * </pre>
 */
@Repository("dataMgmtOldDAO")
public class DataMgmtOldDAO extends DpsCommonDAO {

	public List<Map<String, Object>> selectDataMgmtList(Map<String, Object> map) {
		return selectListDps("dataMgmtOld.selectDataMgmtList", map);
	}
	
	

}
