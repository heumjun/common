package stxship.dis.baseInfo.codeMaster.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.codeMaster.dao.CodeMasterDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : CodeMasterServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 23.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 코드마스터 서비스
 *     </pre>
 */
@Service("codeMasterService")
public class CodeMasterServiceImpl extends CommonServiceImpl implements CodeMasterService {

	@Resource(name = "codeMasterDAO")
	private CodeMasterDAO codeMasterDAO;
}
