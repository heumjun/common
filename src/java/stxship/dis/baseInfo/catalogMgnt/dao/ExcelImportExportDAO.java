package stxship.dis.baseInfo.catalogMgnt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : ExcelImportExportDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 Excel의 Import,Export되었을때 사용되는 DAO
 *     </pre>
 */
@Repository("excelImportExportDAO")
public class ExcelImportExportDAO extends CommonDAO {

	public int deleteCatalogAttrExist(Map<String, Object> param) {
		return delete("catalogExcelImport.deleteCatalogAttrExist", param);
	}

	public int insertCatalogAttrUpload(Map<String, Object> rowData) {
		return insert("catalogExcelImport.insertCatalogAttrUpload", rowData);
	}

	public int procedureCatalogCheck(Map<String, Object> param) {
		return insert("catalogExcelImport.procedureCatalogCheck", param);
	}

	public int procedureCatalogUpload(Map<String, Object> param) {
		return insert("catalogExcelImport.procedureCatalogUpload", param);
	}

	public List<Map<String, Object>> selectExcelDownLoad(Map<String, Object> map) {
		return selectList("catalogExcelExport.selectExcelDownLoad", map);
	}
}
