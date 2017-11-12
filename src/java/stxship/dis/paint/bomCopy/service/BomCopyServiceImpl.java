package stxship.dis.paint.bomCopy.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.paint.bomCopy.dao.BomCopyDAO;

/**
 * @파일명 : BomCopyServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * BomCopy에서 사용되는 서비스
 *     </pre>
 */
@Service("bomCopyService")
public class BomCopyServiceImpl extends CommonServiceImpl implements BomCopyService {

	@Resource(name = "bomCopyDAO")
	private BomCopyDAO bomCopyDAO;

	/**
	 * @메소드명 : saveGridList
	 * @날짜 : 2016. 3. 10.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM COPY
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveGridList(CommandMap commandMap) throws Exception {
		// 결과값 최초
		Map<String, Object> pkgParam = new HashMap<String, Object>();
		pkgParam.putAll(commandMap.getMap());
		bomCopyDAO.selectOne("saveBomCopy.copy", pkgParam);

		String error_code = DisStringUtil.nullString(pkgParam.get("p_error_code"));
		String error_msg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));

		if (!"S".equals(error_code)) {
			throw new DisException(error_msg);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}
