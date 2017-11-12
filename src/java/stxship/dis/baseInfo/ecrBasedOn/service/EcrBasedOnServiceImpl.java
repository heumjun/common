package stxship.dis.baseInfo.ecrBasedOn.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.ecrBasedOn.dao.EcrBasedOnDAO;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : EcrBasedOnServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ECR ECO Mapping 메뉴 선택시 사용되는 서비스
 *     </pre>
 */
@Service("ecrBasedOnService")
public class EcrBasedOnServiceImpl extends CommonServiceImpl implements EcrBasedOnService {

	@Resource(name = "ecrBasedOnDAO")
	private EcrBasedOnDAO ecrBasedOnDAO;

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR ECO Mapping 정보를 저장시에 중복체크는 하지 않음
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String getDuplicationCnt(Map<String, Object> rowData) {
		return DisConstants.RESULT_SUCCESS;
	}
}
