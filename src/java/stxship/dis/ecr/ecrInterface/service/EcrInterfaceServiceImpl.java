package stxship.dis.ecr.ecrInterface.service;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.DisMailDAO;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMailUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.ecr.ecrInterface.dao.EcrInterfaceDAO;

/** 
 * @파일명	: EcrInterfaceServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2015. 12. 17. 
 * @작성자	: BaekJaeHo 
 * @설명
 * <pre>
 * 		ECR Interface Service
 * </pre>
 */
@Service("ecrInterfaceService")
public class EcrInterfaceServiceImpl extends CommonServiceImpl implements EcrInterfaceService {

	@Resource(name = "ecrInterfaceDAO")
	private EcrInterfaceDAO ecrInterfaceDAO;
	
	@Resource(name = "disMailDAO")
	private DisMailDAO disMailDAO;

	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;	

	
	/** 
	 * @메소드명	: getEcrInterfaceList
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *	ERP Interface List 받아옴.
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getEcrInterfaceList( CommandMap commandMap ) {
			
		//특수선 접수자 조회
		Map<String, Object> ifEmpNoMap = ecrInterfaceDAO.selectEcrIFEmpNoList(commandMap.getMap());
		
		String isSpecialShip = "N";
		String specialShipEmpno = ""; 
				
		if(ifEmpNoMap != null){
			specialShipEmpno = DisStringUtil.nullString( ifEmpNoMap.get( "emp_no" ) );
		}
		
		//로그인된 사번과 특수선 접수자 사번 비교
		//if( specialShipEmpno.equals( DisStringUtil.nullString( commandMap.get(DisConstants.SESSION_LOGIN_ID) ) ) ) {
		if( specialShipEmpno.equals( DisStringUtil.nullString( commandMap.get(DisConstants.SET_DB_LOGIN_ID) ) ) ) {		
			isSpecialShip = "Y";
		}
		
		//조회조건
		commandMap.put("is_special_ship", isSpecialShip );
		
		//공통 모듈의 Grid List를 받아온다.
		return super.getGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: saveECRInterface01
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *		Interface un-Completed I/F(ECR create) 버튼 클릭 시 로직
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> saveECRInterface01( CommandMap commandMap ) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			List<Map<String, Object>> ecrInterfaceList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
			
			int processCnt = 0;
			
			String error_msg = "";
			
			for( Map<String, Object> rowData : ecrInterfaceList ) {
				Map<String, Object> param = new HashMap<String, Object>();
				//feedback no
				param.put("p_cd_ocr", rowData.get( "feedback_no" ) == null ? "" : rowData.get( "feedback_no" ).toString());
				//login id
				param.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				String sEcrNo = DisStringUtil.nullString( rowData.get( "ecr_no" ) );
				
				if( "-".equals( sEcrNo ) ) {
					processCnt++;
					
					//I/F 프로시저 호출
					ecrInterfaceDAO.stxDisEcrIfProc(param);
					
					//프로시저 결과 메시지 받음
					error_msg = DisStringUtil.nullString( param.get( "p_error_msg" ) );
					
					//성공이면 메일링 
					if( "S".equals( param.get( "p_error_code" ) ) ) {
						String to_mail01 = param.get("p_to_mail01") == null ? "" : param.get("p_to_mail01").toString();
						if( !"".equals( to_mail01 ) ) {
							Map<String, Object> mailParam1 = new HashMap<String, Object>();
							
							mailParam1.put("from_mail", DisConstants.ADMIN_ADDRESS);
							mailParam1.put("to_mail", param.get("p_to_mail01"));
							mailParam1.put("main_code", param.get("p_ecr_name"));
							mailParam1.put("feedback_no", param.get("p_cd_ocr"));
							mailParam1.put("description", param.get("p_description"));
							mailParam1.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));	
							
							//생성자에게 메일발송
							sendMail(mailParam1);
							
							//메일 발송
							/*DisMailUtil.ecrIfMailSend( mailParam1 );*/
						}
						
						String to_mail02 = param.get("p_to_mail02") == null ? "" : param.get("p_to_mail02").toString();
						if( !"".equals( to_mail02 ) ) {
							Map<String, Object> mailParam2 = new HashMap<String, Object>();
							
							mailParam2.put("from_mail", DisConstants.ADMIN_ADDRESS);
							mailParam2.put("to_mail", param.get("p_to_mail02"));
							mailParam2.put("main_code", param.get("p_ecr_name"));
							mailParam2.put("feedback_no", param.get("p_cd_ocr"));
							mailParam2.put("description", param.get("p_description"));
							mailParam2.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
							
							//결재자에게 메일발송
							sendMail(mailParam2);
							
							//메일 발송
							/*DisMailUtil.ecrIfMailSend( mailParam2 );*/
						}
					}
				}
			}
			

			if( processCnt == 0 ) {
				throw new Exception("작업 가능한 상태가 아닙니다.");
			}
			
			if(error_msg.equals("")){
				rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisConstants.RESULT_SUCCESS);
			}else{
				throw new Exception(error_msg);
			}
			

		} catch( Exception e ) {
			throw new Exception(e.getMessage());
		}
		return rtnMap;
	}
	
	/** 
	 * @메소드명	: saveECRInterface02
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> saveECRInterface02( CommandMap commandMap ) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			List<Map<String, Object>> ecrInterfaceList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
			
			int isOk = 0;
			for( Map<String, Object> rowData : ecrInterfaceList ) {
				
				isOk += ecrInterfaceDAO.updateRemovePLMList(rowData);
			}

			
			if(isOk == ecrInterfaceList.size()){
				rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisConstants.RESULT_SUCCESS);
			}else{
				throw new Exception(DisConstants.RESULT_FAIL);
			}
			

		} catch( Exception e ) {
			throw new Exception(e.getMessage());
		}
		return rtnMap;
	}

	
	/** 
	 * @메소드명	: sendMail
	 * @날짜		: 2017. 03. 07.
	 * @작성자	: 강선중
	 * @설명		: ECR Interface 메일링
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */	
	public void sendMail(Map<String, Object> params) throws Exception {

		// 보내는 사람
		Map<String, Object> ownerMap = disMailDAO.mailPromoteOwnerSendList(params);
		String fromMail = DisStringUtil.nullString(ownerMap.get("sendOwnerMail"));
		// 메일 내용을 가져온다.
		Map<String, Object> ecrInfo = disMailDAO.selectOne("Mail.selectEcrMailInfo", params);

		String action = "확인";
		String states_desc = "생성";
		String subject = "";
		String toMail = "";
		String ccMail = "";
		
		toMail = params.get("to_mail") + "";

		// 메일 제목 작성
		subject = DisMessageUtil.getMessage("mail.ecrInterface.subject1",
				new String[] { params.get("main_code") + "", states_desc, action });		
		

		Template template = velocityEngine.getTemplate("./mailTemplate/ecrInterfaceMail.template", "UTF-8");
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put("main_code", params.get("main_code"));
		velocityContext.put("states_desc", states_desc);
		velocityContext.put("ecr_description", ecrInfo.get("ecr_description"));
		velocityContext.put("ecr_based_on", ecrInfo.get("ecr_based_on"));
		velocityContext.put("feedback_no", params.get("feedback_no"));		
		velocityContext.put("action", action);

		StringWriter stringWriter = new StringWriter();
		template.merge(velocityContext, stringWriter);
		DisMailUtil.sendEmail(fromMail, toMail, ccMail, subject, stringWriter.toString());
	}	
}
