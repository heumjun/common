package stxship.dis.buyerClass.letterFaxTotal.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.buyerClass.letterFaxTotal.dao.LetterFaxTotalDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : LetterFaxTotalServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * LetterFaxTotal에서 사용되는 서비스
 *     </pre>
 */
@Service("letterFaxTotalService")
public class LetterFaxTotalServiceImpl extends CommonServiceImpl implements LetterFaxTotalService {

	@Resource(name = "letterFaxTotalDAO")
	private LetterFaxTotalDAO letterFaxTotalDAO;
	
}
