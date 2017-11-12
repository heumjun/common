package stxship.dis.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * @파일명 : DisBaseDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 17.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 		공통 : DIS DAO
 *     </pre>
 */
@Repository("disMailDAO")
public class DisMailDAO extends CommonDAO {

	/**
	 * @메소드명 : mailPromoteSendList
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	1. DisMailUtil에서 사용
	 *  2. 메일 내용 가져오는 쿼리
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> mailPromoteSendList(Map<String, Object> map) {
		return selectList("Mail.mailPromoteSendList", map);
	}

	/**
	 * @메소드명 : mailPromoteOwnerSendList
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	1. DisMailUtil에서 사용
	 *  2. 보내는 사람 받아옴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public Map<String, Object> mailPromoteOwnerSendList(Map<String, Object> map) {
		return selectOne("Mail.mailPromoteOwnerSendList", map);
	}
	
	/** 
	 * @메소드명	: selectEcrToEcoRelatedSendList
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *  1. DisMailUtil에서 사용
	 *  2. 메일 내용 가져오는 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectEcrToEcoRelatedSendList(Map<String, Object> map) {
		return selectList("Mail.selectEcrToEcoRelatedSendList", map);
	}
	
	/** 
	 * @메소드명	: selectEcrPromoteSendList
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *  1. DisMailUtil에서 사용
	 *  2. 메일 내용 가져오는 쿼리
	 * </pre>
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> selectEcrPromoteSendList(Map<String, Object> map) {
		return selectList("Mail.selectEcrToEcoRelatedSendList", map);
	}
	

}
