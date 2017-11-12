package stxship.dis.baseInfo.catalogMgnt.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : HighRankCatalogDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 상위Catalog가 선택되어졌을때 사용되는 DAO
 *     </pre>
 */
@Repository("highRankCatalogDAO")
public class HighRankCatalogDAO extends CommonDAO {

	public Integer selectExistCatalogValueAssy(Map<String, Object> rowData) {
		return selectOne("saveHighRankCatalog.selectExistCatalogValueAssy", rowData);
	}

	public int updateCatalogValueAssy(Map<String, Object> rowData) {
		return update("saveHighRankCatalog.updateCatalogValueAssy", rowData);
	}

	public int insertCatalogValueAssy(Map<String, Object> rowData) {
		return insert("saveHighRankCatalog.insertCatalogValueAssy", rowData);
	}
}
