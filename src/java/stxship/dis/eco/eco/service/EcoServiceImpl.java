package stxship.dis.eco.eco.service;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMailUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.eco.eco.dao.EcoDAO;

/**
 * @파일명 : EcoServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *     EcoService
 *     </pre>
 */
@Service("ecoService")
public class EcoServiceImpl extends CommonServiceImpl implements EcoService {

	@Resource(name = "ecoDAO")
	private EcoDAO ecoDAO;

	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;

	public void sendMail(Map<String, Object> params) throws Exception {
		String main_code = (String) params.get("main_code");
		String states_code = (String) params.get("states_code");
		String states_desc = "";
		String mail_eco_cause = (String) params.get("mail_eco_cause");
		String mail_main_desc = (String) params.get("mail_main_desc");
		String notify_msg = DisStringUtil.nullString(params.get("notify_msg"));
		String promote = (String) params.get("promote");
		String action = "확인";
		String fromMail = "";
		String toMail = "";
		String subject = "";

		if ("PROMOTE".equals(promote)) {
			if ("CREATE".equals(states_code)) {
				states_desc = "접수";
				action = "결재 진행";
				fromMail = params.get("design_engineer_mail") + "";
				toMail = params.get("manufacturing_engineer_mail") + "";
			}
			if ("REVIEW".equals(states_code)) {
				states_desc = "Release";
				fromMail = params.get("manufacturing_engineer_mail") + "";
				toMail = params.get("design_engineer_mail") + "";
			}
		} else {
			if ("CANCEL".equals(promote)) {
				states_desc = "취소";
				fromMail = params.get("manufacturing_engineer_mail") + "";
				toMail = params.get("design_engineer_mail") + "";
			} else {
				if ("REVIEW".equals(states_code)) {
					states_desc = "반려";
					fromMail = params.get("manufacturing_engineer_mail") + "";
					toMail = params.get("design_engineer_mail") + "";
				}
			}
		}
		// 메일 제목 작성
		subject = DisMessageUtil.getMessage("mail.eco.subject1",
				new String[] { params.get("main_code") + "", states_desc, action });

		// 메일 내용을 가져온다.
		List<Map<String, Object>> ecrList = ecoDAO.selectList("Mail.mailPromoteSendList", params);
		Template template = velocityEngine.getTemplate("./mailTemplate/ecoMail.template", "UTF-8");
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put("main_code", main_code);
		velocityContext.put("states_desc", states_desc);
		velocityContext.put("mail_main_desc", mail_main_desc);
		velocityContext.put("mail_eco_cause", mail_eco_cause);
		velocityContext.put("notify_msg", notify_msg);
		velocityContext.put("action", action);
		velocityContext.put("ecrList", ecrList);
		StringWriter stringWriter = new StringWriter();
		template.merge(velocityContext, stringWriter);
		DisMailUtil.sendEmail(fromMail, toMail, "", subject, stringWriter.toString());
		
		for (int i = 0; ecrList.size() > i; i++) { // ECR 과 NOTI담당자에게 메일 보냄
			Map<String, Object> ecrListMap = ecrList.get(i);
			if ("ECR".equals(ecrListMap.get("state_type"))) {
				if ("PROMOTE".equals(promote)) {
					if ("CREATE".equals(states_code)) {
						states_desc = "연계";
						fromMail = params.get("design_engineer_mail") + "";
						toMail = ecrListMap.get("ep_mail") + "";
					}
					if ("REVIEW".equals(states_code)) {
						states_desc = "Complete";
						fromMail = params.get("manufacturing_engineer_mail") + "";
						toMail = ecrListMap.get("ep_mail") + "";
					}
				} else {
					if ("CANCEL".equals(promote)) {
						states_desc = "취소";
						fromMail = params.get("manufacturing_engineer_mail") + "";
						toMail = ecrListMap.get("ep_mail") + "";
					} else {
						if ("REVIEW".equals(states_code)) {
							states_desc = "반려";
							fromMail = params.get("manufacturing_engineer_mail") + "";
							toMail = ecrListMap.get("ep_mail") + "";
						}
					}

				}
				// 메일 제목 작성
				subject = DisMessageUtil.getMessage("mail.eco.subject2",
						new String[] { ecrListMap.get("main_name") + "", states_desc });
				Template template2 = velocityEngine.getTemplate("./mailTemplate/ecoEcrMail.template", "UTF-8");
				VelocityContext velocityContext2 = new VelocityContext();
				velocityContext2.put("main_code", main_code);
				velocityContext2.put("states_desc", states_desc);
				velocityContext2.put("notify_msg", notify_msg);
				velocityContext2.put("mail_main_desc", mail_main_desc);
				velocityContext2.put("mail_eco_cause", mail_eco_cause);
				velocityContext2.put("ecr_main_name", ecrListMap.get("main_name"));
				velocityContext2.put("ecr_baseOn", ecrListMap.get("baseOn"));
				velocityContext2.put("ecr_main_desc", ecrListMap.get("main_desc"));

				StringWriter stringWriter2 = new StringWriter();
				template2.merge(velocityContext2, stringWriter2);
				DisMailUtil.sendEmail(fromMail, toMail, "", subject, stringWriter2.toString());

			} else if ("NOTIFI".equals(ecrListMap.get("state_type"))) {
				if ("PROMOTE".equals(promote)) {
					if ("REVIEW".equals(states_code)) {
						subject = DisMessageUtil.getMessage("mail.eco.subject3", params.get("main_code") + "");
						DisMailUtil.sendEmail(fromMail, ecrListMap.get("ep_mail") + "", "", subject,
								stringWriter.toString());
					}
				}
			}
		}
	}

	/**
	 * @메소드명 : saveEcrResult
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR결과 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveEcrResult(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> ecoList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		int result = 0;

		int i = 0;
		for (Map<String, Object> rowData : ecoList) {

			if ("Y".equals(DisStringUtil.nullString(rowData.get("enable_flag")))) {

				String isaveDel = DisStringUtil.nullString(commandMap.get("saveDel")); // c.getSaveDel();
				// 순번저장
				rowData.put("no", i);
				// toid 저장할 main_code ECO CODE
				rowData.put("main_code_to", commandMap.get("main_code"));
				// Type 구분(ECR)
				rowData.put("main_type", "ECR");
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				if (isaveDel.equals("save")) {
					int dup = ecoDAO.ecrDuplicateCheck(rowData);
					if (dup > 0) {
						throw new DisException("common.default.duplication", "");
					}
					// eco와 연결된 ecr 저장
					result = ecoDAO.insertEngRel(rowData);
				} else if (isaveDel.equals("del")) {
					// eco와 연결된 ecr 삭제
					result = ecoDAO.deleteEngRel(rowData);
				}
				i++;
			}
			if (result == 0) {
				throw new DisException();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : ecoExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * eco를 엑셀로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View ecoExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		List<String> colName = new ArrayList<String>();
		colName.add("NAME");
		colName.add("Related ECR");
		colName.add("ECO Type");
		colName.add("ECO Cause");
		colName.add("기술변경 담당자");
		colName.add("결재자");
		colName.add("ECO Project");
		colName.add("ECO Description");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = ecoDAO.infoEcoExcelList(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add(DisStringUtil.nullString(rowData.get("main_name")));
			row.add(DisStringUtil.nullString(rowData.get("eng_change_name")));
			row.add(DisStringUtil.nullString(rowData.get("permanent_temporary_flag")));
			row.add(DisStringUtil.nullString(rowData.get("couse_desc")));
			row.add(DisStringUtil.nullString(rowData.get("design_engineer")));
			row.add(DisStringUtil.nullString(rowData.get("manufacturing_engineer")));
			row.add(DisStringUtil.nullString(rowData.get("eng_eco_project")));
			row.add(DisStringUtil.nullString(rowData.get("main_description")));

			colValue.add(row);
		}

		modelMap.put("excelName", "Eco");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

	/**
	 * @메소드명 : saveEco
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO의 저장처리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveEco(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> ecoList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		int updateResult = 0;
		String mainName = "";
		for (Map<String, Object> rowData : ecoList) {
			String permanent_temporary_flag = DisStringUtil.nullString(rowData.get("permanent_temporary_flag"));
			if (permanent_temporary_flag.equals("영구")) {
				permanent_temporary_flag = "5";
			} else {
				permanent_temporary_flag = "7";
			}

			String eng_change_req_code = DisStringUtil.nullString(rowData.get("eng_change_req_code"));

			if ("".equals(eng_change_req_code) || eng_change_req_code == null) {
				rowData.put("eng_change_req_code", "false");
			}

			rowData.put("design_engineer_name", commandMap.get("design_engineer_reg"));
			rowData.put("manufacturing_engineer_name", commandMap.get("manufacturing_engineer_reg"));
			rowData.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("permanent_temporary_flag", permanent_temporary_flag);

			Map<String, Object> pkgParam = new HashMap<String, Object>();
			pkgParam.put("p_permanent_temporary_flag", permanent_temporary_flag);
			pkgParam.put("p_loginid", (String) commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam.put("p_main_description", (String) rowData.get("main_description"));

			Map<String, Object> pkgParam2 = new HashMap<String, Object>();

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				ecoDAO.stxDisEcoMasterInsertProc(pkgParam);
				String err_code = DisStringUtil.nullString(pkgParam.get("p_err_code"));
				String error_msg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				if (!"S".equals(err_code)) {
					throw new DisException(error_msg);
				}

				pkgParam2.put("p_eng_change_order_code", pkgParam.get("p_eng_change_order_code"));
				pkgParam2.put("p_eng_change_order_desc", rowData.get("main_description"));
				pkgParam2.put("p_permanent_temporary_flag", permanent_temporary_flag);
				pkgParam2.put("p_eco_cause", rowData.get("eco_cause"));
				pkgParam2.put("p_design_engineer", rowData.get("design_engineer_emp_no"));
				pkgParam2.put("p_manufacturing_engineer", rowData.get("manufacturing_engineer_emp_no"));
				pkgParam2.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				if (rowData.get("eng_change_req_code").equals("false")) {
					pkgParam2.put("p_eng_change_req_code", "");
				} else {
					pkgParam2.put("p_eng_change_req_code", rowData.get("eng_change_req_code"));
				}

				ecoDAO.stxDisEcoDetailInsertProc(pkgParam2);

				String err_code2 = DisStringUtil.nullString(pkgParam2.get("p_err_code"));
				String error_msg2 = DisStringUtil.nullString(pkgParam2.get("p_error_msg"));

				if (!"S".equals(err_code2)) {
					throw new DisException(error_msg2);
				}

				// String engChangeOrderNameH =
				// DisStringUtil.nullString(pkgParam2.get("p_eng_change_order_name_h"));
				// String engChangeOrderNameN =
				// DisStringUtil.nullString(pkgParam2.get("p_eng_change_order_name_n"));
				mainName = (String) pkgParam.get("p_eng_change_order_code");// engChangeOrderNameH
																			// +
																			// engChangeOrderNameN;

			} else if ("U".equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				pkgParam2.put("p_permanent_temporary_flag", rowData.get("permanent_temporary_flag"));
				pkgParam2.put("p_eco_cause", rowData.get("eco_cause"));
				// pkgParam2.put( "p_eng_eco_project", rowData.get(
				// "eng_eco_project" ) );
				pkgParam2.put("p_design_engineer", rowData.get("design_engineer_emp_no"));
				pkgParam2.put("p_manufacturing_engineer", rowData.get("manufacturing_engineer_emp_no"));
				pkgParam2.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam2.put("p_main_description", rowData.get("main_description"));

				if (rowData.get("eng_change_req_code").equals("false")) {
					pkgParam2.put("p_eng_change_req_code", "");
				} else {
					pkgParam2.put("p_eng_change_req_code", rowData.get("eng_change_req_code"));
				}

				// pkgParam2.put( "p_eng_eco_project_code", rowData.get(
				// "eng_eco_project_Code" ) );
				pkgParam2.put("p_eng_change_order_code", rowData.get("main_code"));

				// eco 저장
				ecoDAO.updateEco(pkgParam2);
				
				String error_code = DisStringUtil.nullString(pkgParam2.get("p_err_code"));
				String error_msg = DisStringUtil.nullString(pkgParam2.get("p_err_msg"));

				if (!"S".equals(error_code)) {
					throw new DisException(error_msg);
				}
				
				//stx_dis_statereq 에서도 수정
				updateResult = ecoDAO.updateEngineerRegister(pkgParam2);
				
				if(updateResult == 0) {
					throw new DisException();
				}
			}

			Map<String, Object> pkgHisParam = new HashMap<String, Object>();
			String sType = DisStringUtil.nullString(rowData.get("permanent_temporary_flag")) == "5" ? "영구" : "잠정";

			if ("I".equals(DisStringUtil.nullString(rowData.get(DisConstants.FROM_GRID_OPER)))) {
				pkgHisParam.put("p_eco_name", mainName);
				pkgHisParam.put("p_action_type", "INSERT");
			} else if ("U".equals(DisStringUtil.nullString(rowData.get(DisConstants.FROM_GRID_OPER)))) {
				pkgHisParam.put("p_action_type", "UPDATE");
				pkgHisParam.put("p_eco_name", rowData.get("main_code"));
			}
			pkgHisParam.put("p_insert_empno", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			pkgHisParam.put("p_related_ecr", rowData.get("eng_change_name"));
			pkgHisParam.put("p_type", sType);
			pkgHisParam.put("p_eco_cause", rowData.get("couse_desc"));
			pkgHisParam.put("p_design_engineer", rowData.get("design_engineer"));
			pkgHisParam.put("p_manufacturing_engineer", rowData.get("manufacturing_engineer"));
			pkgHisParam.put("p_states_code", rowData.get("states_desc"));
			// pkgHisParam.put( "p_project", rowData.get( "eng_eco_project" ) );
			pkgHisParam.put("p_eco_description", rowData.get("main_description"));

			ecoDAO.insertEcoHistory(pkgHisParam);

			String error_code = DisStringUtil.nullString(pkgHisParam.get("p_error_code"));
			String error_msg = DisStringUtil.nullString(pkgHisParam.get("p_error_msg"));

			if (!"S".equals(error_code)) {
				throw new DisException(error_msg);
			}
		}

		Map<String, String> result = DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		result.put("main_name", mainName);
		return result;
	}
	
	/**
	 * @메소드명 : saveEco
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO의 저장처리
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveEco1(CommandMap commandMap) throws Exception {
		
		String mainName = "";

		String eng_change_req_code = DisStringUtil.nullString(commandMap.get("eng_change_req_code"));

		if ("".equals(eng_change_req_code) || eng_change_req_code == null) {
			commandMap.put("eng_change_req_code", "false");
		}

		commandMap.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		commandMap.put("permanent_temporary_flag", "7");

		Map<String, Object> pkgParam = new HashMap<String, Object>();
		pkgParam.put("p_permanent_temporary_flag", "7");
		pkgParam.put("p_loginid", (String) commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		pkgParam.put("p_main_description", (String) commandMap.get("main_description"));

		Map<String, Object> pkgParam2 = new HashMap<String, Object>();

		ecoDAO.stxDisEcoMasterInsertProc(pkgParam);
		String err_code = DisStringUtil.nullString(pkgParam.get("p_err_code"));
		String error_msg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
		if (!"S".equals(err_code)) {
			throw new DisException(error_msg);
		}

		pkgParam2.put("p_eng_change_order_code", pkgParam.get("p_eng_change_order_code"));
		pkgParam2.put("p_eng_change_order_desc", commandMap.get("main_description"));
		pkgParam2.put("p_permanent_temporary_flag", "7");
		pkgParam2.put("p_eco_cause", commandMap.get("eco_cause"));
		pkgParam2.put("p_design_engineer", commandMap.get("design_engineer_emp_no"));
		pkgParam2.put("p_manufacturing_engineer", commandMap.get("manufacturing_engineer_emp_no"));
		pkgParam2.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		if (commandMap.get("eng_change_req_code").equals("false")) {
			pkgParam2.put("p_eng_change_req_code", "");
		} else {
			pkgParam2.put("p_eng_change_req_code", commandMap.get("eng_change_req_code"));
		}

		ecoDAO.stxDisEcoDetailInsertProc(pkgParam2);

		String err_code2 = DisStringUtil.nullString(pkgParam2.get("p_err_code"));
		String error_msg2 = DisStringUtil.nullString(pkgParam2.get("p_err_msg"));

		if (!"S".equals(err_code2)) {
			throw new DisException(error_msg2);
		}

		mainName = (String) pkgParam.get("p_eng_change_order_code");

		Map<String, Object> pkgHisParam = new HashMap<String, Object>();
		String sType = "잠정";

		pkgHisParam.put("p_eco_name", mainName);
		pkgHisParam.put("p_action_type", "INSERT");
		pkgHisParam.put("p_insert_empno", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		pkgHisParam.put("p_related_ecr", commandMap.get("eng_change_name"));
		pkgHisParam.put("p_type", sType);
		pkgHisParam.put("p_eco_cause", commandMap.get("couse_desc"));
		pkgHisParam.put("p_design_engineer", commandMap.get("design_engineer"));
		pkgHisParam.put("p_manufacturing_engineer", commandMap.get("manufacturing_engineer"));
		pkgHisParam.put("p_states_code", commandMap.get("states_desc"));
		pkgHisParam.put("p_eco_description", commandMap.get("main_description"));

		ecoDAO.insertEcoHistory(pkgHisParam);

		String error_code = DisStringUtil.nullString(pkgHisParam.get("p_error_code"));
		String error_message = DisStringUtil.nullString(pkgHisParam.get("p_error_msg"));

		if (!"S".equals(error_code)) {
			throw new DisException(error_message);
		}

		Map<String, String> result = DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		result.put("main_name", mainName);
		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> promoteDemote(CommandMap commandMap) throws Exception {
		// Promote or Demote Processing
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("p_eco_no", commandMap.get("eco_no") == null ? "" : commandMap.get("main_code"));

		param.put("p_main_code", commandMap.get("main_code") == null ? "" : commandMap.get("main_code"));
		// promote or demote
		param.put("p_appr_type", commandMap.get("promote") == null ? "" : commandMap.get("promote"));
		// Comments
		param.put("p_notify_msg", commandMap.get("notify_msg") == null ? "" : commandMap.get("notify_msg"));
		// login id
		param.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		String statesDesc = commandMap.get("states_desc") == null ? "" : commandMap.get("states_desc").toString();
		
		// ECO의 최신 상태 재추출하여 작업 가능 여부 판단
		String statesDescLast = ecoDAO.getLastEcoStatesDesc(param);
		
		// ECO 최신 상태가 Release 혹은 파라미터 값과 일치하지 않으면 에러
		if("Release".equals(statesDescLast) || !statesDesc.equals(statesDescLast))
		{
			throw new DisException("ECO가 이미 Release 혹은 상태가 일치하지 않아 작업 불가한 상태입니다.\nECO 재조회 후 확인 바랍니다.");
		}

		int orderNo = 0;

		if ("Create".equals(statesDesc)) {
			orderNo = 0;
		} else if ("Review".equals(statesDesc)) {
			orderNo = 1;
		} else if ("Release".equals(statesDesc)) {
			orderNo = 2;
		}

		param.put("p_no", orderNo);

		param.put("p_states_code", commandMap.get("states_code") == null ? "" : commandMap.get("states_code"));

		ecoDAO.stxDisEcoPromoteDemoteProc(param);

		if (!"S".equals(DisStringUtil.nullString(param.get("p_error_code")))) {
			throw new DisException(DisStringUtil.nullString(param.get("p_error_msg")));
		}

		// 메일 발송
		sendMail(commandMap.getMap());
		// promoteDemoteMailSend(commandMap.getMap());

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveReleaseNotificationResults
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> saveReleaseNotificationResults(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> ecoList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		String isaveDel = DisStringUtil.nullString(commandMap.get("saveDel"));

		int i = 0;

		for (Map<String, Object> rowData : ecoList) {
			String iDel = DisStringUtil.nullString(rowData.get("enable_flag"));
			// 순번저장
			rowData.put("no", i);
			// 결재가 아닌 참조자 저장
			rowData.put("states_type", "NOTIFI");
			// toid 저장할 main_code
			rowData.put("main_code", commandMap.get("main_code"));

			int duplicationCnt;
			if (isaveDel.equals("save")) {
				duplicationCnt = ecoDAO.selectOne("saveEcoReleaseNotificationResults.duplicate", rowData);
				if (duplicationCnt == 0) {
					// eco와 연결된 참조자 저장
					ecoDAO.insert("saveEcoReleaseNotificationResults.insertStateReq", rowData);
				}
			} else if (isaveDel.equals("del")) {
				if (iDel.equals("Y")) {
					// eco와 연결된 참조자 삭제
					ecoDAO.insert("saveEcoReleaseNotificationResults.deleteStateReq", rowData);
				}
			}
			i++;
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	@Override
	public List<Map<String, Object>> ecoRegisterInfo(CommandMap commandMap) {
		// TODO Auto-generated method stub
		// 리스트를 취득한다.
		Map<String, Object> resultData = ecoDAO.ecoRegisterInfo(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("vcursor");

		return listData;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @메소드명 : saveReleaseNotificationGroup
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 그룹 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> saveEcoReleaseNotificationGroup(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> saveMailReceiverGroupList = DisJsonUtil
				.toList(commandMap.get((DisConstants.FROM_GRID_DATA_LIST)));

		String description = (String) commandMap.get("groupName");

		// group sequence 따기
		String seq = ecoDAO.selectOne("saveEcoReleaseNotificationGroup.getSeqNextVal", commandMap.getMap());

		Map<String, Object> mapParam = new HashMap<String, Object>();
		// 세션처리해서 현재 접속한 사람의 emp_no를 넣어준다
		mapParam.put("user", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		mapParam.put("group_id", seq);
		mapParam.put("description", description);

		ecoDAO.insert("saveEcoReleaseNotificationGroup.addSTX_DIS_ECO_NOTI_GROUP_HEAD", mapParam);
		int duplicationCnt;
		for (Map<String, Object> rowData : saveMailReceiverGroupList) {
			rowData.put("group_id", seq);
			rowData.put("user", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			duplicationCnt = ecoDAO.selectOne("saveEcoReleaseNotificationGroup.duplicate", rowData);
			if (duplicationCnt == 0) {
				ecoDAO.insert("saveEcoReleaseNotificationGroup.addSTX_DIS_ECO_NOTI_GROUP_DETAIL", rowData);
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}	
	
	/**
	 * @메소드명 : delEcoReleaseNotificationGroup
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 그룹 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */	
	@Override
	public Map<String, String> delEcoReleaseNotificationGroup(CommandMap commandMap) throws Exception {
		ecoDAO.delete("delEcoReleaseNotificationGroup.delete_STX_DIS_ECO_NOTI_GROUP_HEAD", commandMap.getMap());
		ecoDAO.delete("delEcoReleaseNotificationGroup.delete_STX_DIS_ECO_NOTI_GROUP_DETAIL", commandMap.getMap());
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}	

}
