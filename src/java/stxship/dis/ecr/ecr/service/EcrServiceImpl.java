package stxship.dis.ecr.ecr.service;

import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.DisMailDAO;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMailUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.ecr.ecr.dao.EcrDAO;

/**
 * @파일명 : EcrServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 16.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 *		ECR Service
 *     </pre>
 */
@Service("ecrService")
public class EcrServiceImpl extends CommonServiceImpl implements EcrService {

	@Resource(name = "ecrDAO")
	private EcrDAO ecrDAO;

	@Resource(name = "disMailDAO")
	private DisMailDAO disMailDAO;

	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;

	public void sendMail(Map<String, Object> params) throws Exception {

		// 보내는 사람
		Map<String, Object> ownerMap = disMailDAO.mailPromoteOwnerSendList(params);
		String fromMail = DisStringUtil.nullString(ownerMap.get("sendOwnerMail"));
		// 메일 내용을 가져온다.
		Map<String, Object> ecrInfo = disMailDAO.selectOne("Mail.selectEcrMailInfo", params);
		List<Map<String, Object>> ecoList = disMailDAO.selectList("Mail.selectEcrRelEcoMailInfo", params);
		String action = "확인";
		String states_desc = "";
		String subject = "";
		String toMail = "";
		String ccMail = "";
		if ("promote".equals(DisStringUtil.nullString(params.get("promote")))) {
			if ("Create".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "접수";
				action = "결재 조치";
				toMail = ecrInfo.get("manufacturing_ep_mail") + "";
			} else if ("Evaluate".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "평가";
				action = "결재 조치";
				toMail = ecrInfo.get("manufacturing_ep_mail") + "";
			} else if ("Review".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "승인";
				action = "ECO 조치";
				ccMail = ecrInfo.get("create_ep_mail") + "";
				// ECR 결재자, 관련자, 관련자의 파트장에게 메일 송부
				toMail = ecrInfo.get("manufacturing_ep_mail") + "," + ecrInfo.get("related_person_emp_name") + "," + ecrInfo.get("related_person_partjang");
			}
		} else if ("demote".equals(DisStringUtil.nullString(params.get("promote")))) {
			if ("Evaluate".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "평가 반려";
				action = "사유 확인";
				toMail = ecrInfo.get("create_ep_mail") + "";
			} else if ("Review".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "결제 반려";
				action = "사유 확인";
				toMail = ecrInfo.get("create_ep_mail") + "";
			} else if ("Plan ECO".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "결제 반려";
				action = "사유 확인";
				toMail = ecrInfo.get("evaluator_ep_mail") + "";
			} else if ("Complete".equals(DisStringUtil.nullString(params.get("states_desc")))) {
				states_desc = "PLAN ECO 상태로";
				action = "확인";
				toMail = ecrInfo.get("create_ep_mail") + "";
			}
		} else if ("cancel".equals(DisStringUtil.nullString(params.get("promote")))) {
			states_desc = "취소";
			action = "확인";
			toMail = ecrInfo.get("create_ep_mail") + "";
		} else if ("ecorelated".equals(DisStringUtil.nullString(params.get("promote")))) {
			states_desc = "ECO 연계";
			action = "확인";
			toMail = ecrInfo.get("create_ep_mail") + "";
		}

		// 메일 제목 작성
		subject = DisMessageUtil.getMessage("mail.ecr.subject1",
				new String[] { params.get("main_code") + "", states_desc, action });

		Template template = velocityEngine.getTemplate("./mailTemplate/ecrMail.template", "UTF-8");
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put("main_code", params.get("main_code"));
		velocityContext.put("states_desc", states_desc);
		velocityContext.put("notify_msg", DisStringUtil.nullString(params.get("notify_msg")));
		velocityContext.put("ecr_description", ecrInfo.get("ecr_description"));
		velocityContext.put("ecr_based_on", ecrInfo.get("ecr_based_on"));
		velocityContext.put("action", action);
		velocityContext.put("ecoList", ecoList);
		StringWriter stringWriter = new StringWriter();
		template.merge(velocityContext, stringWriter);
		DisMailUtil.sendEmail(fromMail, toMail, ccMail, subject, stringWriter.toString());
	}

	/**
	 * @메소드명 : saveEcr
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR 저장 & 수정
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveEcr(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> ecrList = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		for (Map<String, Object> rowData : ecrList) {
			Map<String, Object> pkgParam = new HashMap<String, Object>();

			// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
			for (String key : rowData.keySet()) {
				pkgParam.put("p_" + key, rowData.get(key));
			}

			// User Id 세션에서 셋팅
			pkgParam.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
			ecrDAO.saveEcr(pkgParam);

			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
			// String sErrCode =
			// DisStringUtil.nullString(pkgParam.get("p_error_code"));
			// String sEcrName =
			// DisStringUtil.nullString(pkgParam.get("p_ecror_name"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
		}

		// 리턴 메시지 담음
		return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
	}

	public View ecrExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("ECR Name");
		colName.add("상태");
		colName.add("기술변경내용");
		//colName.add("Related Project");
		colName.add("관련자");
		colName.add("기술변경원인");
		//colName.add("평가자");
		colName.add("결재자");
		//colName.add("작업자");
		colName.add("작성자");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> itemList = ecrDAO.selectEcrExcelExportList(commandMap.getMap());

		for (Map<String, Object> rowData : itemList) {
			List<String> row = new ArrayList<String>();

			String main_name = DisStringUtil.nullString(rowData.get("main_name"));
			String eng_change_related_project = DisStringUtil.nullString(rowData.get("eng_change_related_project"));
			String eng_change_description = DisStringUtil.nullString(rowData.get("eng_change_description"));
			String related_person_emp_name = DisStringUtil.nullString(rowData.get("related_person_emp_name"));
			String eng_change_based_on = DisStringUtil.nullString(rowData.get("couse_desc"));
			String evaluator_emp_no = DisStringUtil.nullString(rowData.get("evaluator_emp_no"));
			String design_engineer = DisStringUtil.nullString(rowData.get("design_engineer"));
			String states_desc = DisStringUtil.nullString(rowData.get("states_desc"));
			String locker_by_name = DisStringUtil.nullString(rowData.get("locker_by_name"));
			String created_by_name = DisStringUtil.nullString(rowData.get("created_by_name"));

			//ECR
			row.add(main_name);
			//상태
			row.add(states_desc);
			//Related Project
			//row.add(eng_change_related_project);
			//기술변경내용
			row.add(eng_change_description);
			//관련자
			row.add(related_person_emp_name);
			//기술변경원인
			row.add(eng_change_based_on);
			//평가자
			//row.add(evaluator_emp_no);
			//결재자
			row.add(design_engineer);
			//작업자
			//row.add(locker_by_name);
			//작성자
			row.add(created_by_name);

			colValue.add(row);
		}

		// 오늘 날짜 구함 시작
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);
		// 오늘 날짜 구함 끝

		modelMap.put("excelName", commandMap.get("main_name") + "_" + dateToday);
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

	/**
	 * @메소드명 : saveEcrLifeCycle
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		Ecr Promote and Demote
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveEcrPromoteDemote(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		/*
		 * List<Map<String, Object>> ecrPromoteDemotelist = DisJsonUtil
		 * .toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		 */

		String sErrorMsg = "";
		// String sErrorCode = "";

		// for (Map<String, Object> rowData : ecrPromoteDemotelist) {
		// Promote or Demote Processing
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("p_main_code", commandMap.get("main_code"));
		// ECR
		param.put("p_main_type", commandMap.get("states_type"));
		// promote or demote
		param.put("p_appr_type", commandMap.get("promote"));
		// Comments
		param.put("p_notify_msg", commandMap.get("notify_msg"));
		// login id
		param.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		String statesDesc = DisStringUtil.nullString(commandMap.get("states_desc"));

		int orderNo = 0;
		
		if ("Create".equals(statesDesc)) {
			orderNo = 0;
		} else if ("Review".equals(statesDesc)) {
			orderNo = 1;
		} else if ("Plan ECO".equals(statesDesc)) {
			orderNo = 2;
		} else if ("Complete".equals(statesDesc)) {
			orderNo = 2;
		}		
/*****
		if ("Create".equals(statesDesc)) {
			orderNo = 0;
		} else if ("Evaluate".equals(statesDesc)) {
			orderNo = 1;
		} else if ("Review".equals(statesDesc)) {
			orderNo = 2;
		} else if ("Plan ECO".equals(statesDesc)) {
			orderNo = 3;
		}
*****/
		param.put("p_no", orderNo);

		param.put("p_states_code", commandMap.get("states_code") == null ? "" : commandMap.get("states_code"));

		ecrDAO.saveEcrPromoteDemote(param);

		sErrorMsg = param.get("p_err_msg") == null ? "" : param.get("p_err_msg").toString();
		// sErrorCode = param.get("p_err_code") == null ? "" :
		// param.get("p_err_code").toString();

		// 오류가 있으면 스탑
		if (!"".equals(sErrorMsg)) {
			throw new DisException(sErrorMsg);
		}
		// 메일 발송
		// DisMailUtil.ecrPromoteDemoteMailSend(commandMap.getMap());
		sendMail(commandMap.getMap());
		// 리턴 메시지 담음
		return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : deleteRelatedECOs
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> deleteRelatedECOs(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> ecrPromoteDemotelist = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		int isOk = 0;

		for (Map<String, Object> rowData : ecrPromoteDemotelist) {

			isOk = ecrDAO.deleteRelatedECOs(rowData);

			// 오류가 있으면 스탑
			if (isOk <= 0) {
				throw new DisException(DisConstants.RESULT_FAIL);
			}
		}
		// ECR STATUS 변경 : PLAN_ECO -> COMPLETE
		commandMap.put("ecr_main_code", commandMap.get("main_code")); // ECR
		ecrDAO.insertEcrStatusUpdateEcoRelated(commandMap.getMap());

		// 리턴 메시지 담음
		return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveEcrToEcoRelated
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveEcrToEcoRelated(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> ecrPromoteDemotelist = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		// ECO 원인 리스트 받아옴
		List<Map<String, Object>> ecoBauseCodelist = ecrDAO.selectEcoCauseList(commandMap.getMap());

		String sEcrBaseCode = "";
		String sEngChangeOrderCause = "";

		int cnt = 0;
		int isOk = 0;

		for (Map<String, Object> rowData : ecrPromoteDemotelist) {

			sEngChangeOrderCause = DisStringUtil.nullString(rowData.get("eng_change_order_cause"));
			String sMainName = DisStringUtil.nullString(rowData.get("main_name"));

			for (Map<String, Object> ecoBauseCodeData : ecoBauseCodelist) {
				sEcrBaseCode = DisStringUtil.nullString(ecoBauseCodeData.get("sub_states_code"));
				if (sEngChangeOrderCause.equals(sEcrBaseCode)) {
					cnt++;
				}
			}
			if (cnt == 0) {
				throw new DisException("[" + sMainName + "] 원인코드가 기술변경원인에 맵핑되어 있지 않습니다.");
			}
			cnt = 0;
		}

		for (Map<String, Object> rowData : ecrPromoteDemotelist) {
			commandMap.put("ecr_main_code", commandMap.get("main_code")); // ECR
			commandMap.put("eco_main_code", rowData.get("main_code")); // ECO
			// insert
			isOk = ecrDAO.insertEcrToEcoRelated(commandMap.getMap());
			if (isOk > 0) {
				commandMap.put("promote", "ecorelated");
				// 메일 발송
				// DisMailUtil.ecrPromoteDemoteMailSend(commandMap.getMap());
				sendMail(commandMap.getMap());
			} else {
				throw new DisException(DisConstants.RESULT_FAIL);
			}
		}
		// ECR STATUS 변경 : PLAN_ECO -> COMPLETE
		commandMap.put("ecr_main_code", commandMap.get("main_code")); // ECR
		ecrDAO.insertEcrStatusUpdateEcoRelated(commandMap.getMap());
		// 리턴 메시지 담음
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}
