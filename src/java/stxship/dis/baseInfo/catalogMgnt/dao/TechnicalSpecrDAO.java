package stxship.dis.baseInfo.catalogMgnt.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : TechnicalSpecrDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 비용성코드 생성이 선택되어졌을때 사용되는 DAO
 *     </pre>
 */
@Repository("technicalSpecrDAO")
public class TechnicalSpecrDAO extends CommonDAO {

	public Map<String, Object> selectTechnicalSpec(Map<String, Object> map) {
		return selectOne("saveTechnicalSpec.selectTechnicalSpec", map);
	}

	public String selectUnitOfMeasure(Map<String, Object> map) {
		return selectOne("saveTechnicalSpec.selectUnitOfMeasure", map);
	}

	public String selectUserName(Map<String, Object> param) {
		return selectOne("saveTechnicalSpec.selectUserName", param);
	}

	public String selectExistSystemItems(Map<String, Object> param) {
		return selectOne("saveTechnicalSpec.selectExistSystemItems", param);
	}

	public int procedurePlmItemInterface(Map<String, Object> param) {
		return selectOne("saveTechnicalSpec.procedurePlmItemInterface", param);
	}
}
