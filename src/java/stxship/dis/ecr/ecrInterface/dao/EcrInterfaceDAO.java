package stxship.dis.ecr.ecrInterface.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("ecrInterfaceDAO")
public class EcrInterfaceDAO extends CommonDAO {

	/**
	 * @메소드명 : selectEcrIFEmpNoList
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	특수선 접수자 조회
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectEcrIFEmpNoList(Map<String, Object> map) {
		return selectOne("ecrInterfaceList.selectEcrIFEmpNoList", map);
	}

	/**
	 * @메소드명 : stxDisEcrIfProc
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR Interface Procedure 호출
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public int stxDisEcrIfProc(Map<String, Object> map) {
		return insert("ecrInterfaceList.stxDisEcrIfProc", map);
	}
	
	
	/** 
	 * @메소드명	: updateRemovePLMList
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param map
	 * @return
	 */
	public int updateRemovePLMList(Map<String, Object> map) {
		return update("ecrInterfaceList.updateRemovePLMList", map);
	}
	
	

}
