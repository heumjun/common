package stxship.dis.ecr.ecr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("ecrDAO")
public class EcrDAO extends CommonDAO {

	/**
	 * @메소드명 : saveEcr
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR SAVE
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int saveEcr(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return insert("saveEcr.save", map);
	}

	/**
	 * @메소드명 : selectEcrExcelExportList
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR 엑셀 Export
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectEcrExcelExportList(Map<String, Object> map) {
		return selectList("ecrExcelExportList.list", map);
	}

	/**
	 * @메소드명 : ecrPromoteDemote
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR Promote and Demote
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int saveEcrPromoteDemote(Map<String, Object> map) {
		return insert("saveEcrPromoteDemoteProc.save", map);
	}

	/**
	 * @메소드명 : deleteRelatedECOs
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	RelatedEcos 삭제
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int deleteRelatedECOs(Map<String, Object> map) {
		return delete("saveEcrRelatedECOs.delete", map);
	}

	/**
	 * @메소드명 : selectEcoCauseList
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * Related ECO 저장 시 원인 받아오는 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectEcoCauseList(Map<String, Object> map) {
		return selectList("saveEcrRelatedECOs.selectEcoCauseList", map);
	}

	/**
	 * @메소드명 : insertEcrToEcoRelated
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		Related 저장
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int insertEcrToEcoRelated(Map<String, Object> map) {
		return insert("saveEcrRelatedECOs.insertEcrToEcoRelated", map);
	}
	
	/**
	 * @메소드명 : sscAddValidation
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	ECR STATUS 변경 : PLAN_ECO -> COMPLETE
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> insertEcrStatusUpdateEcoRelated(Map<String, Object> map) {
		return selectOne("saveEcrRelatedECOs.insertEcrStatusUpdateEcoRelated", map);
	}

}
