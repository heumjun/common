package stxship.dis.baseInfo.catalogMgnt.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : CatalogMgntDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 사용되는 DAO
 *     </pre>
 */
@Repository("catalogMgntDAO")
public class CatalogMgntDAO extends CommonDAO {

	public int deleteCatalogMgnt(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteCatalogMgnt", rowData);
	}

	public int insertCatalogValue(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogValue", rowData);
	}

	public int updateCatalogValue(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateCatalogValue", rowData);
	}

	public int deleteCatalogValue(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteCatalogValue", rowData);
	}
	
	public int insertCatalogLength(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogLength", rowData);
	}

	public int updateCatalogLength(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateCatalogLength", rowData);
	}

	public int deleteCatalogLength(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteCatalogLength", rowData);
	}

	public int deleteItemAttributeBase(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteItemAttributeBase", rowData);
	}

	public int deleteItemValue(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.deleteItemValue", rowData);
	}

	public int deleteTopItemValue(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteTopItemValue", rowData);
	}

	public int insertBomAttributeBase(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertBomAttributeBase", rowData);
	}

	public int updateBomAttributeBase(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateBomAttributeBase", rowData);
	}

	public int deleteBomAttributeBase(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteBomAttributeBase", rowData);
	}

	public int insertBomValue(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertBomValue", rowData);
	}

	public int deleteBomValue(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteBomValue", rowData);
	}

	public int insertTopBomValue(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertTopBomValue", rowData);
	}

	public int deleteTopBomValue(Map<String, Object> rowData) {
		return delete("saveCatalogMgnt.deleteTopBomValue", rowData);
	}

	public Map<String, String> selectCategoryFromPartFamily(Map<String, Object> map) {
		return selectOne("categoryFromPartFamily.selectCategoryFromPartFamily", map);
	}

	public Map<String, Object> selectAdditionalPurchaseInfo(Map<String, Object> map) {
		return selectOne("catalogMgntAdditionalPurchaseInfo.selectAdditionalPurchaseInfo", map);
	}

	public String selectExistCatalog(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectExistCatalog", rowData);
	}

	public String selectExistCatalogAttribute(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectExistCatalogAttribute", rowData);
	}

	public Object selectExistCatalogAttributeValue(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectExistCatalogAttributeValue", rowData);
	}

	public String selectCatalogHisRevNo(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectCatalogHisRevNo", rowData);
	}

	public String selectExistMtlItemCatalogGroupsB(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectExistMtlItemCatalogGroupsB", rowData);
	}

	public int insertCatalogMgnt(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogMgnt", rowData);
	}

	public int insertCatalogHis(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogHis", rowData);
	}

	public int insertMtlItemCatalogGroupsB(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertMtlItemCatalogGroupsB", rowData);
	}

	public int insertMtlItemCatalogGroupsTL(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertMtlItemCatalogGroupsTL", rowData);
	}

	public String selectVCategory(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectVCategory", rowData);
	}

	public Map<String, Object> selectCategoryId(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectCategoryId", rowData);
	}

	public String selectExistCatalogCateRelation(Map<String, Object> mapCategoryId) {
		return selectOne("saveCatalogMgnt.selectExistCatalogCateRelation", mapCategoryId);
	}

	public int insertCatalogCateRelation(Map<String, Object> mapCategoryId) {
		return insert("saveCatalogMgnt.insertCatalogCateRelation", mapCategoryId);
	}

	public int updateCatalogMgnt(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateCatalogMgnt", rowData);
	}

	public String selectItemCatalogGroupId(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectItemCatalogGroupId", rowData);

	}

	public String selectCategoryId2(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectCategoryId2", rowData);
	}

	public Map<String, Object> selectCatalogInfo(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectCatalogInfo", rowData);
	}

	public int updateMtlItemCatalogGroupsB(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateMtlItemCatalogGroupsB", rowData);
	}

	public int updateMtlItemCatalogGroupsTL(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateMtlItemCatalogGroupsTL", rowData);
	}

	public int updateCatalogCateRelation(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateCatalogCateRelation", rowData);
	}

	public int insertItemAttributeBase(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertItemAttributeBase", rowData);
	}

	public String selectCatalogAttrHisRevNo(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectCatalogAttrHisRevNo", rowData);
	}

	public int insertCatalogAttributeHis(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogAttributeHis", rowData);
	}

	public String selectExistDescriptiveElements(Map<String, Object> rowData) {
		return selectOne("saveCatalogMgnt.selectExistDescriptiveElements", rowData);
	}

	public int insertDescriptiveElements(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertDescriptiveElements", rowData);
	}

	public int updateItemAttributeBase(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateItemAttributeBase", rowData);
	}

	public int updateDescriptiveElements(Map<String, Object> rowData) {
		return update("saveCatalogMgnt.updateDescriptiveElements", rowData);
	}

	public int insertCatalogAttributeValueDeHis(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogAttributeValueDeHis", rowData);
	}

	public int insertItemValue(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertItemValue", rowData);
	}

	public int insertCatalogAttributeValueHis(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogAttributeValueHis", rowData);
	}

	public int insertCatalogAttributeValueHis2(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogAttributeValueHis2", rowData);
	}

	public int insertTopItemValue(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertTopItemValue", rowData);
	}

	public int insertCatalogAttributeValueDeHis2(Map<String, Object> rowData) {
		return insert("saveCatalogMgnt.insertCatalogAttributeValueDeHis2", rowData);
	}
}
