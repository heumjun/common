package stxship.dis.item.createItem.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("createItemDAO")
public class CreateItemDAO extends CommonDAO {

	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;
	
	/**
	 * @메소드명 : selectShipTypeFlag
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		SHIP TYPE
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String selectShipTypeFlag(Map<String, Object> map) {
		return (String) selectOne("itemCreateList.selectShipTypeFlag", map);
	}

	/**
	 * @메소드명 : insertItemCodeCreate
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 		ITEM CODE 채번
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int insertItemCodeCreate(Map<String, Object> map) {
		return insert("saveItemCreate.insertItemCodeCreate", map);
	}

	/**
	 * @메소드명 : updateItemConfirm
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 수정
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int updateItemConfirm(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return update("saveItemCreate.updateItemConfirm", map);
	}

	/**
	 * @메소드명 : deleteCatalogConfirmItemList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 삭제
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int deleteCatalogConfirmItemList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return delete("saveItemCreate.deleteCatalogConfirmItemList", map);
	}

	/**
	 * @메소드명 : selectitemExcelExportList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 리스트 엑셀 출력
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectitemExcelExportList(Map<String, Object> map) {
		return selectList("itemExcelExportList.list", map);
	}

	/**
	 * @메소드명 : insertCatalogItemListUpload
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 카달로그 엑셀 업로드 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int insertCatalogItemListUpload(Map<String, Object> map) {
		return insert("saveItemCreate.insertCatalogItemListUpload", map);
	}

	/**
	 * @메소드명 : deleteCatalogItemListUp
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 리스트 삭제 
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int deleteCatalogItemListUp(Map<String, Object> map) {
		return delete("saveItemCreate.deleteCatalogItemListUp", map);
	}

	/**
	 * @메소드명 : deleteCatalogItemList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 리스트 삭제 
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int deleteCatalogItemList(Map<String, Object> map) {
		return delete("saveItemCreate.deleteCatalogItemList", map);
	}

	/**
	 * @메소드명 : selectCatalogAttribute
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		카달로그 ATTR 
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectCatalogAttribute(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("itemCreateList.selectCatalogAttribute", map);
	}

	/**
	 * @메소드명 : procedureItemCheck
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 체크 프로시저 호출
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public void procedureItemCheck(Map<String, Object> map) {
		selectOne("itemCreateList.procedureItemCheck", map);
	}

	/**
	 * @메소드명 : procedureItemWeightCheck
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 WEIGHT 체크 프로시저 호출
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> procedureItemWeightCheck(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("itemCreateList.procedureItemWeightCheck", map);
	}

	/**
	 * @메소드명 : procedureItemUpload
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 업로드 프로시저 
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> procedureItemUpload(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("itemCreateList.procedureItemUpload", map);
	}

	/**
	 * @메소드명 : selectExistCatalogItemUpload
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		카달로그 아이템 업로드 존재 리스트
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public String selectExistCatalogItemUpload(Map<String, Object> map) {
		return (String) selectOne("itemCreateList.selectExistCatalogItemUpload", map);
	}

	/**
	 * @메소드명 : selectItemAllCatalog
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectItemAllCatalog(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("itemCreateList.selectAllCatalog", map);
	}

	
	
	public List<Map<String, Object>> itemAttributeCheck(Map<String, Object> map) {
		return selectList("itemCreateList.itemAttributeCheck", map);
	}

	public Map<String, Object> itemCloneAction(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("itemCreateList.itemCloneAction", map);
	}

	public int itemAttributeDelete(Map<String, Object> map) {
		return delete("itemCreateList.itemAttributeDelete", map);
	}
	
	public Map<String, Object> saveItemNextAction(Map<String, Object> map) {
		disSession.selectList("itemCreateList.saveItemNextAction", map);
		return map;
	}
}
