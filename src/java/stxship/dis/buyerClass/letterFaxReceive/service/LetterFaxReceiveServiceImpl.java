package stxship.dis.buyerClass.letterFaxReceive.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.buyerClass.letterFaxReceive.dao.LetterFaxReceiveDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : LetterFaxReceiveServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxReceive에서 사용되는 서비스
 *     </pre>
 */
@Service("letterFaxReceiveService")
public class LetterFaxReceiveServiceImpl extends CommonServiceImpl implements LetterFaxReceiveService {

	@Resource(name = "letterFaxReceiveDAO")
	private LetterFaxReceiveDAO letterFaxReceiveDAO;
}
