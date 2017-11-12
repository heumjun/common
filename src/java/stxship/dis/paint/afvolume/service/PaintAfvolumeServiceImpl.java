package stxship.dis.paint.afvolume.service;

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
import stxship.dis.paint.afvolume.dao.PaintAfvolumeDAO;

/**
 * @파일명 : PaintAfvolumeServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 11.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  A/F Volume 서비스
 *     </pre>
 */
@Service("paintAfvolumeService")
public class PaintAfvolumeServiceImpl extends CommonServiceImpl implements PaintAfvolumeService {

	@Resource(name = "paintAfvolumeDAO")
	private PaintAfvolumeDAO paintAfvolumeDAO;

	/**
	 * @메소드명 : savePaintAfvolume
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 구간 정보 저장 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintAfvolume(CommandMap commandMap) throws Exception {
		// AFT 구간 정보를 저장한다.
		int result = 0;
		commandMap.put("section_cls", "AFT");
		commandMap.put("separated_val", (String) commandMap.get("aft_quantity"));
		result = paintAfvolumeDAO.insertAFVolume(commandMap.getMap());
		if (result == 0) {
			throw new DisException();
		}
		// MID 구간 정보를 저장한다.
		commandMap.put("section_cls", "MID");
		commandMap.put("separated_val", (String) commandMap.get("mid_quantity"));
		result = paintAfvolumeDAO.insertAFVolume(commandMap.getMap());
		if (result == 0) {
			throw new DisException();
		}
		// FWD 구간 정보를 저장한다.
		commandMap.put("section_cls", "FWD");
		commandMap.put("separated_val", (String) commandMap.get("fwd_quantity"));
		result = paintAfvolumeDAO.insertAFVolume(commandMap.getMap());
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

}
