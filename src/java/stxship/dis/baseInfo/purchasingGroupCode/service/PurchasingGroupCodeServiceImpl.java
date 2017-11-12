package stxship.dis.baseInfo.purchasingGroupCode.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.purchasingGroupCode.dao.PurchasingGroupCodeDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : PurchasingGroupCodeServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * PurchasingGroupCode에서 사용되는 서비스
 *     </pre>
 */
@Service("purchasingGroupCodeService")
public class PurchasingGroupCodeServiceImpl extends CommonServiceImpl implements PurchasingGroupCodeService {

	@Resource(name = "purchasingGroupCodeDAO")
	private PurchasingGroupCodeDAO purchasingGroupCodeDAO;

}
