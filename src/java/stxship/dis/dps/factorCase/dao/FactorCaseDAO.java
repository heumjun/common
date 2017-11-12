/**
 * 
 */
package stxship.dis.dps.factorCase.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.dps.common.dao.DpsCommonDAO;

/** 
 * @파일명	: FactorCaseDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 9. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 시수 적용율 Case 관리  
 * </pre>
 */
@Repository("factorCaseDAO")
public class FactorCaseDAO extends DpsCommonDAO {
	/**
	 * 
	 * @메소드명	: updateDefaultCase
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수 적용율 Case관리 default case 설정
	 * </pre>
	 * @param param
	 */
	public void updateDefaultCase(Map<String, Object> param) {
		updateDps("factorCaseMainGridSave.updateDefaultCase", param);
	}

}
