package stxship.dis.common.util;

import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.DisMailDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : DisMailUtil.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 17.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 	메일 발송에 관한 Util
 *     </pre>
 */

public class DisMailUtil extends CommonServiceImpl {

	@Resource(name = "mailSender")
	private static JavaMailSender mailSender;

	public void setMailSender(JavaMailSender mailSender) {
		DisMailUtil.mailSender = mailSender;
	}

	@Resource(name = "disMailDAO")
	private static DisMailDAO disMailDAO;

	public static void sendEmail(String fromEmail, String toEmail, String ccEmail, String subject, String body)
			throws Exception {
		System.out.println("to:" + toEmail);
		System.out.println("cc:" + ccEmail);
		System.out.println("from:" + fromEmail);
		System.out.println("subject:" + subject);
		System.out.println("content:" + body);
		
		MimeMessage message = mailSender.createMimeMessage();
		
		if (DisConstants.Y.equals(DisMessageUtil.getMessage("mail.test"))) {
			subject = "[TEST] "+subject;
			System.out.println(DisMessageUtil.getMessage("mail.test.address"));
			message.addRecipients(RecipientType.TO, DisMessageUtil.getMessage("mail.test.address"));
			message.addRecipients(RecipientType.TO, "donghyupyang@onestx.com");
		} else {
			message.addRecipients(RecipientType.TO, toEmail);
			//message.addRecipients(RecipientType.TO, "k9006@onestx.com");
			message.addRecipients(RecipientType.CC, ccEmail);
			//message.addRecipients(RecipientType.CC, "k9006@onestx.com");
		}
		message.setFrom(new InternetAddress(fromEmail));
		message.setSubject(subject, "UTF-8");
		message.setText(body, "UTF-8", "html");
		
		try {
			mailSender.send(message);
		} catch(MailException e) {
			e.printStackTrace();
		}

	}

	/*
	 * public static void main(HashMap argsMap) { System.out.println(
	 * "SimpleEmail Start"); String smtpHostServer = "203.169.4.20"; // IDC에서
	 * 쓰라고 제공해준 SMTP 주소 Properties props = System.getProperties();
	 * props.put("mail.smtp.host", smtpHostServer); props.put("mail.smtp.port",
	 * "25");
	 * 
	 * Session session = Session.getInstance(props, null);
	 * 
	 * String emailID = "ckred@onestx.com"; String toList = ""; String subject =
	 * ""; String message = ""; // sendEmail(session, emailID,
	 * "SimpleEmail Testing Subject", // "SimpleEmail Testing Body"); }
	 * 
	 * public static String promoteDemoteMailSend2(@RequestParam Map<String,
	 * Object> params) throws Exception { System.out.println("SimpleEmail Start"
	 * ); String smtpHostServer = "203.169.4.20"; Properties props =
	 * System.getProperties(); props.put("mail.smtp.host", smtpHostServer);
	 * props.put("mail.smtp.port", "25");
	 * 
	 * Session session = Session.getInstance(props, null);
	 * 
	 * String fromMail = ""; String mailName = ""; String mainDescription = "";
	 * String statesDesc = ""; String mainType = ""; String createdBy = "";
	 * String toMail = ""; String mailMsg = ""; String msgMainType = ""; String
	 * subMailMsg = ""; String msgMailName = ""; String msgCreatedBy = "";
	 * String subject = ""; String couse = ""; String baseOn = ""; String
	 * mailMsgEcr = ""; String ecomailMsg = ""; String created_by_name = "";
	 * String promote = ""; String notifyMsg = ""; String no = "";
	 * 
	 * statesDesc = params.get("states_desc") == null ? "" :
	 * params.get("states_desc").toString(); couse =
	 * params.get("mail_eco_cause") == null ? "" :
	 * params.get("mail_eco_cause").toString(); mainDescription =
	 * params.get("mail_main_desc") == null ? "" :
	 * params.get("mail_main_desc").toString(); created_by_name =
	 * params.get("created_by_name") == null ? "" :
	 * params.get("created_by_name").toString(); promote = params.get("promote")
	 * == null ? "" : params.get("promote").toString(); mailName = "ECO NO : " +
	 * params.get("mail_main_name") == null ? "" :
	 * params.get("mail_main_name").toString();
	 * 
	 * if ("Create".equals(statesDesc) && "promote".equals(promote)) { fromMail
	 * = params.get("created_by_mail") + ""; toMail =
	 * params.get("manufacturing_engineer_mail") + ""; // 결재자 } else if
	 * ("Review".equals(statesDesc) || ("Create".equals(statesDesc) &&
	 * "cancle".equals(promote))) { fromMail =
	 * params.get("manufacturing_engineer_mail") + ""; toMail =
	 * params.get("created_by_mail") + ""; }
	 * 
	 * if ("Create".equals(statesDesc) && "promote".equals(promote)) { subject =
	 * "[DIS][알림]" + mailName + "가 접수되었습니다. 조치 바랍니다."; mailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; mailMsg +=
	 * "<font size=2><p><b>" + mailName + "가 접수되었습니다. 조치 바랍니다. </b></p></font>";
	 * } else if ("Review".equals(statesDesc) || "cancle".equals(promote)) {
	 * 
	 * if ("promote".equals(promote)) { subject = "[DIS][알림]" + mailName +
	 * "가 Release 되었습니다. 확인바랍니다."; mailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; mailMsg +=
	 * "<font size=2><p><b>" + mailName +
	 * "가 Release 되었습니다. 확인바랍니다. </b></p></font>"; } else if
	 * ("demote".equals(promote)) { subject = "[DIS][알림]" + mailName +
	 * "가 반려 되었습니다. 확인바랍니다."; mailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; mailMsg +=
	 * "<font size=2><p><b>" + mailName + "가 반려 되었습니다. 확인바랍니다. </b></p></font>";
	 * } else { // cancle 인경우 subject = "[DIS][알림]" + mailName +
	 * "가 Cancle 되었습니다. 확인바랍니다."; mailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; mailMsg +=
	 * "<font size=2><p><b>" + mailName +
	 * "가 Cancle 되었습니다. 확인바랍니다. </b></p></font>"; } }
	 * 
	 * mailMsg +=
	 * "<font size=2><p>&nbsp;--------------------- 아래-----------------------</p>"
	 * ; ecomailMsg = "<br />&nbsp;&nbsp;&nbsp;&nbsp;- " + mailName; ecomailMsg
	 * += "<br />&nbsp;&nbsp;&nbsp;&nbsp;- ECO 원인 CODE : " + couse; ecomailMsg
	 * += "<br />&nbsp;&nbsp;&nbsp;&nbsp;- ECO Description : " +
	 * mainDescription;
	 * 
	 * // 메일 내용을 가져온다. List<Map<String, Object>> list =
	 * disMailDAO.mailPromoteSendList(params);
	 * 
	 * // List<Map<String, Object>> list = //
	 * stxDisCommonService.queryForMapList("Main.mailPromoteSendList", //
	 * params); // msg 내용가져오는 쿼리
	 * 
	 * ------------------- 메세지 시작 -- 내용부분 ---------------------------------
	 * 
	 * for (int i = 0; list.size() > i; i++) {
	 * 
	 * Map<String, Object> stateslistMap = (Map<String, Object>) list.get(i);
	 * 
	 * String ecrMainType = String.valueOf(stateslistMap.get("state_type")); //
	 * ROUTE,ECR // 등 String ecrMailName =
	 * String.valueOf(stateslistMap.get("main_name")); // ECO // NO // : //
	 * 1405285011 // 등 String ecrMainDescription =
	 * String.valueOf(stateslistMap.get("main_desc")); // 주석 no =
	 * String.valueOf(stateslistMap.get("no")); baseOn =
	 * String.valueOf(stateslistMap.get("baseOn"));
	 * 
	 * if ("ECR".equals(ecrMainType)) { mailMsgEcr =
	 * "<br />&nbsp;&nbsp;&nbsp;&nbsp;- ECR NO : " + ecrMailName; mailMsgEcr +=
	 * "<br />&nbsp;&nbsp;&nbsp;&nbsp;- ECR Based On : " + baseOn; mailMsgEcr +=
	 * "<br />&nbsp;&nbsp;&nbsp;&nbsp;- ECR Description : " +
	 * ecrMainDescription;
	 * 
	 * } if ("ROUTE".equals(ecrMainType) && "1".equals(no)) { notifyMsg =
	 * String.valueOf(stateslistMap.get("notify_msg")); mailMsg +=
	 * "<br /> 사유 : " + notifyMsg; } }
	 * 
	 * mailMsg += ecomailMsg; mailMsg += mailMsgEcr + "</font>";
	 * 
	 * sendEmail(session, fromMail, toMail, subject, mailMsg); // ECO 메일 보냄
	 * 
	 * for (int i = 0; list.size() > i; i++) { // ECR 과 NOTI담당자에게 메일 보냄
	 * 
	 * java.util.Map stateslistMap = (java.util.Map) list.get(i);
	 * 
	 * String ecrMainType = String.valueOf(stateslistMap.get("state_type")); //
	 * ECO,ECR // 등 String epMail =
	 * String.valueOf(stateslistMap.get("ep_mail")); String subecrMailName =
	 * String.valueOf(stateslistMap.get("main_name")); // ECO // NO // : //
	 * 1405285011 // 등
	 * 
	 * if ("Create".equals(statesDesc)) { if ("ECR".equals(ecrMainType)) {
	 * String subjectEcr = ""; String subEcrMailMsg = ""; if
	 * ("promote".equals(promote)) { subjectEcr = "[DIS][알림] 귀하가 발행하신 ECR No." +
	 * subecrMailName + "가  아래 ECO가 연계되었습니다."; subEcrMailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; subEcrMailMsg +=
	 * "<br /> 발행하신 ECR No." + subecrMailName + "가  아래 ECO가 연계되었습니다."; } else {
	 * 
	 * subjectEcr = "[DIS][알림] 귀하가 발행하신 ECR No." + subecrMailName +
	 * "의 아래 ECO가   Cancle 되었습니다."; subEcrMailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; subEcrMailMsg +=
	 * "<br /> 발행하신 ECR No." + subecrMailName + "의  아래 ECO가 Cancle 되었습니다.";
	 * subEcrMailMsg += "<br />사유 : " + notifyMsg; }
	 * 
	 * subEcrMailMsg += "<br /> 확인 하시기 바랍니다."; subEcrMailMsg +=
	 * "<br /> <font size=2><p>&nbsp;--------------------- 아래-----------------------"
	 * ; subEcrMailMsg += mailMsgEcr; subEcrMailMsg += ecomailMsg + "</font>";
	 * 
	 * sendEmail(session, fromMail, toMail, subjectEcr, subEcrMailMsg); }
	 * 
	 * } else if ("Review".equals(statesDesc)) { String subEcrMailMsg = ""; if
	 * ("ECR".equals(ecrMainType)) { if ("promote".equals(promote)) { subject =
	 * "[DIS][알림] 귀하가 발행하신 ECR No." + subecrMailName + "가  Complete 처리되었습니다.";
	 * subEcrMailMsg = "<font size=2><p><b>수고 많으십니다. </b></p></font>";
	 * subEcrMailMsg += "<br /> 아래 ECR이 Complete 처리 되었으니 참조 바랍니다."; } else {
	 * subject = "[DIS][알림] 귀하가 발행하신 ECR No." + subecrMailName +
	 * "의  아래 ECO가 Cancle 되었습니다."; subEcrMailMsg =
	 * "<font size=2><p><b>수고 많으십니다. </b></p></font>"; subEcrMailMsg +=
	 * "<br /> 아래 ECO가 Cancle 처리 되었으니 참조 바랍니다."; subEcrMailMsg += "<br />사유 : "
	 * + notifyMsg; } subEcrMailMsg +=
	 * "<br /> <font size=2><p>&nbsp;--------------------- 아래-----------------------"
	 * ; subEcrMailMsg += mailMsgEcr; subEcrMailMsg += ecomailMsg; subEcrMailMsg
	 * += "<br />&nbsp;&nbsp;&nbsp;&nbsp;Related Person : " + created_by_name +
	 * "</font>";
	 * 
	 * sendEmail(session, fromMail, toMail, subject, subEcrMailMsg); } else if
	 * ("NOTIFI".equals(ecrMainType)) { if ("promote".equals(promote)) { String
	 * subjectNoti = "[DIS][알림] " + mailName + " Release Notification.";
	 * sendEmail(session, fromMail, toMail, subjectNoti, mailMsg); // ECO // 메일
	 * // 보냄 } } } } ------------------- 메일 보내기 끝
	 * -----------------------------------
	 * 
	 * return null; }
	 * 
	 *//**
		 * ECR Mail 발송
		 * 
		 * @param Map<String,
		 *            Object> rowData
		 * @return String
		 */
	/*
	 * public static String ecrPromoteDemoteMailSend(Map<String, Object>
	 * rowData) throws Exception {
	 * 
	 * String smtpHostServer = "203.169.4.20";
	 * 
	 * Properties props = System.getProperties(); props.put("mail.smtp.host",
	 * smtpHostServer); props.put("mail.smtp.port", "25");
	 * 
	 * Session session = Session.getInstance(props, null);
	 * 
	 * // mainBean f = new mainBean();
	 * 
	 * rowData.put("emp_no",
	 * DisStringUtil.nullString(DisSessionUtil.getUserId()));
	 * 
	 * // 보내는 사람 Map<String, Object> ownerMap =
	 * disMailDAO.mailPromoteOwnerSendList(rowData); //
	 * stxDisCommonService.queryForObject( "Main.mailPromoteOwnerSendList", //
	 * rowData );
	 * 
	 * String fromMail =
	 * DisStringUtil.nullString(ownerMap.get("sendOwnerMail")); // 보내는 // 사람
	 * 
	 * List<Map<String, Object>> list = null; if
	 * ("ecorelated".equals(DisStringUtil.nullString(rowData.get("promote")))) {
	 * // msg 내용가져오는 쿼리 list =
	 * disMailDAO.selectEcrToEcoRelatedSendList(rowData); } else { // msg 내용가져오는
	 * 쿼리 list = disMailDAO.selectEcrPromoteSendList(rowData); }
	 * 
	 * String ecrNo = ""; String ecrNoSubject = ""; String ecrBasedOn = "";
	 * String description = ""; String ecrRelatedPerson = ""; String epMail =
	 * ""; String mainName = ""; String notifyMsg = "";
	 * 
	 * String subMailMsg = ""; String subject = ""; String mailMsg = "";
	 * 
	 * if ("promote".equals(DisStringUtil.nullString(rowData.get("promote")))) {
	 * // 승인 int k = 1;
	 * 
	 * for (int i = 0; list.size() > i; i++) { Map<String, Object> stateslistMap
	 * = (Map<String, Object>) list.get(i);
	 * 
	 * ecrNo = DisStringUtil.nullString(stateslistMap.get("ecr_no"));
	 * ecrNoSubject =
	 * DisStringUtil.nullString(stateslistMap.get("ecr_no_subject")); ecrBasedOn
	 * = DisStringUtil.nullString(stateslistMap.get("ecr_based_on"));
	 * description = DisStringUtil.nullString(stateslistMap.get("description"));
	 * description = description.replace("\n", "<br />"); ecrRelatedPerson =
	 * DisStringUtil.nullString(stateslistMap.get("ecr_related_person"));
	 * ecrRelatedPerson = ecrRelatedPerson.replace("\n", "<br />"); epMail =
	 * DisStringUtil.nullString(stateslistMap.get("ep_mail")); mainName =
	 * DisStringUtil.nullString(stateslistMap.get("main_name"));
	 * 
	 * subMailMsg = "<span><p>&nbsp;" + (k++) + ". " + ecrNo + "</p></span>";
	 * subMailMsg += "<span><p>&nbsp;" + (k++) + ". " + ecrBasedOn +
	 * "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) + ". " +
	 * description + "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) +
	 * ". " + ecrRelatedPerson + "</p></span>";
	 * 
	 * k = 1;
	 * 
	 * if
	 * ("Create".equals(DisStringUtil.nullString(rowData.get("states_desc")))) {
	 * // Create ==>> Evaluate mailMsg = "<span><p><b>수고많으십니다.</b></p></span>";
	 * mailMsg += "<span><p>아래 ECR이 접수 되었으니 평가 조치 바랍니다.</p></span>"; mailMsg +=
	 * "<span><p>------------아 래-----------</p></span>"; mailMsg += subMailMsg;
	 * mailMsg += "<span><p><b>수고 하세요.</b></p></span>";
	 * 
	 * subject = "[DIS][알림] " + ecrNoSubject + " 이 접수 되었습니다. 평가 바랍니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } else
	 * if
	 * ("Evaluate".equals(DisStringUtil.nullString(rowData.get("states_desc"))))
	 * { // Evaluate ==>> Review mailMsg =
	 * "<span><p><b>수고많으십니다.</b></p></span>"; mailMsg +=
	 * "<span><p>아래 ECR이 평가 되었으니 결재 조치 바랍니다.</p></span>"; mailMsg +=
	 * "<span><p>------------아 래-----------</p></span>"; mailMsg += subMailMsg;
	 * mailMsg += "<span><p><b>수고 하세요.</b></p></span>";
	 * 
	 * subject = "[DIS][결재요청] " + ecrNoSubject + " 이 접수 되었습니다. 결재 바랍니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } else
	 * if ("Rview".equals(DisStringUtil.nullString(rowData.get("states_desc"))))
	 * { // Review ==>> Plan ECO mailMsg =
	 * "<span><p><b>수고많으십니다.</b></p></span>"; mailMsg +=
	 * "<span><p>아래 ECR이 승인되어 Plan ECO 단계까지 진행되었습니다.</p></span>"; mailMsg +=
	 * subMailMsg; mailMsg +=
	 * "<span><p><b>ECR No. 참조하여 개정도면 및 ECO 조치 바랍니다.</b></p></span>";
	 * 
	 * subject = "[DIS][알림] " + ecrNoSubject + " 이 진행 되었습니다. ECO 조치 바랍니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } } }
	 * else if
	 * ("demote".equals(DisStringUtil.nullString(rowData.get("promote")))) { //
	 * 반려 for (int i = 0; list.size() > i; i++) { Map<String, Object>
	 * stateslistMap = (Map<String, Object>) list.get(i);
	 * 
	 * ecrNoSubject =
	 * DisStringUtil.nullString(stateslistMap.get("ecr_no_subject")); epMail =
	 * DisStringUtil.nullString(stateslistMap.get("ep_mail")); notifyMsg =
	 * DisStringUtil.nullString(rowData.get("notify_msg")); notifyMsg =
	 * notifyMsg.replace("\n", "<br />"); // comment
	 * 
	 * if
	 * ("Evaluate".equals(DisStringUtil.nullString(rowData.get("states_desc"))))
	 * { // Evaluate ==>> Create mailMsg =
	 * "<span><p><b>수고많으십니다.</b></p></span>"; mailMsg += "<br />"; mailMsg +=
	 * "<span><p>귀하가 발행하신 ECR이 반려되었습니다.</p></span>"; mailMsg +=
	 * "<span><p>아래 Comment 확인 하시어 후속 조치 바랍니다.</p></span>"; mailMsg += "<br />";
	 * mailMsg += "<span><p><b>Evaluator Comments</b></p></span>"; mailMsg +=
	 * "<span><p>" + notifyMsg + "</p></span>";
	 * 
	 * subject = "[DIS][알림] " + ecrNoSubject + " 이 반려되었습니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } else
	 * if
	 * ("Review".equals(DisStringUtil.nullString(rowData.get("states_desc")))) {
	 * // Review ==>> Evaluate mailMsg = "<span><p><b>수고많으십니다.</b></p></span>";
	 * mailMsg += "<br />"; mailMsg +=
	 * "<span><p>귀하가 평가하신 ECR이 반려되었습니다.</p></span>"; mailMsg +=
	 * "<span><p>아래 Comment 확인 하시어 후속 조치 바랍니다.</p></span>"; mailMsg += "<br />";
	 * mailMsg += "<span><p><b>Reviewers Comments</b></p></span>"; mailMsg +=
	 * "<span><p>" + notifyMsg + "</p></span>";
	 * 
	 * subject = "[DIS][알림] " + ecrNoSubject + " 이 반려되었습니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } } }
	 * else if
	 * ("cancel".equals(DisStringUtil.nullString(rowData.get("promote")))) { //
	 * 취소
	 * 
	 * int k = 1;
	 * 
	 * for (int i = 0; list.size() > i; i++) { Map<String, Object> stateslistMap
	 * = (Map<String, Object>) list.get(i);
	 * 
	 * ecrNo = DisStringUtil.nullString(stateslistMap.get("ecr_no"));
	 * ecrNoSubject =
	 * DisStringUtil.nullString(stateslistMap.get("ecr_no_subject")); ecrBasedOn
	 * = DisStringUtil.nullString(stateslistMap.get("ecr_based_on"));
	 * description = DisStringUtil.nullString(stateslistMap.get("description"));
	 * description = description.replace("\n", "<br />"); ecrRelatedPerson =
	 * DisStringUtil.nullString(stateslistMap.get("ecr_related_person"));
	 * ecrRelatedPerson = ecrRelatedPerson.replace("\n", "<br />"); epMail =
	 * DisStringUtil.nullString(stateslistMap.get("ep_mail")); mainName =
	 * DisStringUtil.nullString(stateslistMap.get("main_name"));
	 * 
	 * subMailMsg = "<span><p>&nbsp;" + (k++) + ". " + ecrNo + "</p></span>";
	 * subMailMsg += "<span><p>&nbsp;" + (k++) + ". " + ecrBasedOn +
	 * "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) + ". " +
	 * description + "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) +
	 * ". " + ecrRelatedPerson + "</p></span>";
	 * 
	 * k = 1;
	 * 
	 * if
	 * ("Create".equals(DisStringUtil.nullString(rowData.get("states_desc")))) {
	 * // Create ==>> Evaluate mailMsg = "<span><p><b>수고많으십니다.</b></p></span>";
	 * mailMsg += "<span><p>아래 ECR이 삭제 처리 되었으니 확인 바랍니다.</p></span>"; mailMsg +=
	 * "<span><p>------------아 래-----------</p></span>"; mailMsg += subMailMsg;
	 * mailMsg += "<span><p><b>수고 하세요.</b></p></span>";
	 * 
	 * subject = "[DIS][알림] " + ecrNoSubject + " 가 삭제 처리 되었습니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } } }
	 * else if
	 * ("ecorelated".equals(DisStringUtil.nullString(rowData.get("promote")))) {
	 * // ECR-ECO Related
	 * 
	 * int k = 1;
	 * 
	 * for (int i = 0; list.size() > i; i++) { Map<String, Object> stateslistMap
	 * = (Map<String, Object>) list.get(i);
	 * 
	 * ecrNo = DisStringUtil.nullString(stateslistMap.get("ecr_no"));
	 * ecrNoSubject = DisStringUtil.nullString(stateslistMap.get("ecr_title"));
	 * ecrBasedOn = DisStringUtil.nullString(stateslistMap.get("ecr_based_on"));
	 * String ecr_description =
	 * DisStringUtil.nullString(stateslistMap.get("ecr_description"));
	 * ecr_description = ecr_description.replace("\n", "<br />");
	 * 
	 * String ecoNo = DisStringUtil.nullString(stateslistMap.get("eco_no"));
	 * String ecoCreator =
	 * DisStringUtil.nullString(stateslistMap.get("created_by")); String
	 * ecoCause = DisStringUtil.nullString(stateslistMap.get("eco_cause"));
	 * String eco_description =
	 * DisStringUtil.nullString(stateslistMap.get("eco_description"));
	 * eco_description = eco_description.replace("\n", "<br />");
	 * 
	 * epMail = DisStringUtil.nullString(stateslistMap.get("ep_mail"));
	 * 
	 * subMailMsg = "<span><p>&nbsp;" + (k++) + ". " + ecrNo + "</p></span>";
	 * subMailMsg += "<span><p>&nbsp;" + (k++) + ". " + ecrBasedOn +
	 * "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) + ". " +
	 * ecr_description + "</p></span>";
	 * 
	 * subMailMsg += "<span><p>&nbsp;" + (k++) + ". " + ecoNo + "</p></span>";
	 * subMailMsg += "<span><p>&nbsp;" + (k++) + ". " + ecoCreator +
	 * "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) + ". " + ecoCause
	 * + "</p></span>"; subMailMsg += "<span><p>&nbsp;" + (k++) + ". " +
	 * eco_description + "</p></span>";
	 * 
	 * k = 1;
	 * 
	 * mailMsg = "<span><p><b>수고많으십니다.</b></p></span>"; mailMsg +=
	 * "<span><p>발행하신 " + ecrNoSubject + " 에 아래 ECO가 연계되었습니다.</p></span>";
	 * mailMsg += "<span><p>확인 하시기 바랍니다.</p></span>"; mailMsg +=
	 * "<span><p>------------아 래-----------</p></span>"; mailMsg += subMailMsg;
	 * mailMsg += "<span><p><b>수고 하세요.</b></p></span>";
	 * 
	 * subject = "[DIS][알림] 귀하가 발행하신 " + ecrNoSubject + " 에 아래 ECO가 연계되었습니다.";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); } }
	 * 
	 * return null; }
	 * 
	 *//**
		 * 메일 보내기
		 * 
		 * @param Session
		 *            session
		 * @param String
		 *            fromEmail
		 * @param String
		 *            toEmail
		 * @param String
		 *            subject
		 * @param String
		 *            body
		 * @return NONE
		 */
	/*
	 * public static void sendEmail(Session session, String fromEmail, String
	 * toEmail, String subject, String body) { try { // mail 제목에 [테스트] 표시 유무
	 * boolean isTest = true;
	 * 
	 * if (isTest) { subject = "[테스트]" + subject; }
	 * 
	 * String smtpHostServer = "203.169.4.20";
	 * 
	 * Properties props = System.getProperties(); props.put("mail.smtp.host",
	 * smtpHostServer); props.put("mail.smtp.port", "25");
	 * 
	 * session = Session.getInstance(props, null);
	 * 
	 * // set message headers MimeMessage msg = new MimeMessage(session);
	 * msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
	 * msg.addHeader("format", "flowed");
	 * msg.addHeader("Content-Transfer-Encoding", "8bit");
	 * 
	 * // 보내는사람 msg.setFrom(new InternetAddress(fromEmail, "")); // 제목
	 * msg.setSubject(subject, "UTF-8"); // 내용 msg.setContent(body,
	 * "text/html; charset=utf-8"); // 보낸날짜 msg.setSentDate(new Date()); // 받는사람
	 * msg.setRecipients(Message.RecipientType.TO,
	 * InternetAddress.parse(toEmail, false));
	 * 
	 * Transport.send(msg);
	 * 
	 * } catch (Exception e) { e.printStackTrace(); } }
	 * 
	 *//**
		 * ERP FEEDBACK ECR 통보메일 발송
		 * 
		 * @param Map<String,
		 *            Object> mailParam
		 * @return NONE
		 */
	/*
	 * public static void ecrIfMailSend(Map<String, Object> mailParam) { String
	 * smtpHostServer = "203.169.4.20";
	 * 
	 * Properties props = System.getProperties(); props.put("mail.smtp.host",
	 * smtpHostServer); props.put("mail.smtp.port", "25");
	 * 
	 * Session session = Session.getInstance(props, null);
	 * 
	 * String fromMail = DisStringUtil.nullString(mailParam.get("from_mail"));
	 * // String epMail = DisStringUtil.nullString( mailParam.get("to_mail") );
	 * String epMail = "clever@onestx.com"; String ecr_name =
	 * DisStringUtil.nullString(mailParam.get("ecr_name")); String feedback_no =
	 * DisStringUtil.nullString(mailParam.get("feedback_no")); String
	 * description = DisStringUtil.nullString(mailParam.get("description"));
	 * 
	 * String mailMsg = ""; mailMsg +=
	 * "<br/ >ERP FEEDBACK 기능에 의해 아래 ECR이 생성되었습니다..<br /><br />"; mailMsg +=
	 * "&nbsp;&nbsp;&nbsp;<b> 1. ECR No. : </b> " + ecr_name + "<br /><br />";
	 * mailMsg += "&nbsp;&nbsp;&nbsp;<b> 2. FEEDBACK : </b> " + feedback_no +
	 * "<br /><br />"; mailMsg +=
	 * "&nbsp;&nbsp;&nbsp;<b> 3. Description  : </b> " + description +
	 * "<br /><br />";
	 * 
	 * String subject = "";
	 * 
	 * subject = "Create Feedback ECR ( " + ecr_name + " ).";
	 * 
	 * // 메일 보내기 sendEmail(session, fromMail, epMail, subject, mailMsg); }
	 * 
	 *//**
		 * 2015-02-25 Kang seonjung 메일 보내기 (발신자는 시스템 admin, 수신자는 다수)
		 * 
		 * @param ArrayList
		 *            toList
		 * @param String
		 *            subject
		 * @param String
		 *            body
		 * @return NONE
		 */
	/*
	 * public static void sendEmailAdmin(ArrayList<Map<String, Object>> toList,
	 * String subject, String body) throws Exception { if (toList.size() < 0)
	 * return;
	 * 
	 * try { // mail 제목에 [테스트] 표시 유무 boolean isTest = true;
	 * 
	 * if (isTest) { subject = "[테스트]" + subject; }
	 * 
	 * String smtpHostServer = "203.169.4.20";
	 * 
	 * Properties props = System.getProperties(); props.put("mail.smtp.host",
	 * smtpHostServer); props.put("mail.smtp.port", "25");
	 * 
	 * Session session = Session.getInstance(props, null);
	 * 
	 * // set message headers MimeMessage msg = new MimeMessage(session);
	 * msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
	 * msg.addHeader("format", "flowed");
	 * msg.addHeader("Content-Transfer-Encoding", "8bit");
	 * 
	 * // 보내는사람 (발신자는 시스템) String sender = "plmadmin@onestx.com";
	 * msg.setFrom(new InternetAddress(sender, "Admin")); // 받는사람
	 * msg.setRecipients(Message.RecipientType.TO, getEmailToList(toList)); //
	 * 제목 msg.setSubject(subject, "UTF-8"); // 내용 msg.setContent(body,
	 * "text/html; charset=utf-8"); // 보낸날짜 msg.setSentDate(new Date());
	 * 
	 * // ** send mail javax.mail.Transport.send(msg);
	 * 
	 * } catch (Exception e) { e.printStackTrace();
	 * 
	 * } }
	 * 
	 *//**
		 * 2015-02-25 Kang seonjung 메일 보내기 (발신자 1인, 수신자는 다수)
		 * 
		 * @param ArrayList
		 *            toList
		 * @param String
		 *            fromList
		 * @param String
		 *            subject
		 * @param String
		 *            body
		 * @return NONE
		 */
	/*
	 * public static void sendEmail(ArrayList toList, String fromList, String
	 * subject, String body) throws Exception { if (toList.size() < 0) return;
	 * 
	 * try { // mail 제목에 [테스트] 표시 유무 boolean isTest = true;
	 * 
	 * if (isTest) { subject = "[테스트]" + subject; } String smtpHostServer =
	 * "203.169.4.20";
	 * 
	 * Properties props = System.getProperties(); props.put("mail.smtp.host",
	 * smtpHostServer); props.put("mail.smtp.port", "25");
	 * 
	 * Session session = Session.getInstance(props, null);
	 * 
	 * // set message headers MimeMessage msg = new MimeMessage(session);
	 * msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
	 * msg.addHeader("format", "flowed");
	 * msg.addHeader("Content-Transfer-Encoding", "8bit");
	 * 
	 *//***
		 * 이게 안되서 메일 호출 시 fromList 주는 걸로 변경 Map ttt =
		 * SessionUtils.getAuthenticatedUser(); System.out.print("ttt = " +ttt);
		 * String sender = (String)ttt.get("ep_mail"); //String sender =
		 * (String)SessionUtils.getAuthenticatedUser().get( "ep_mail" );
		 * //String sender = (String)SessionUtils.getAuthenticatedUser().get(
		 * "user_id" ); System.out.println("sendEmail sender = "+sender);
		 */
	/*
	 * 
	 * String sender = fromList; if (sender == null && "null".equals(sender) &&
	 * "".equals(sender)) { sender = "plmadmin@onestx.com"; }
	 * 
	 * // 보내는사람 msg.setFrom(new InternetAddress(sender, "")); // 받는사람
	 * msg.setRecipients(Message.RecipientType.TO, getEmailToList(toList)); //
	 * 제목 msg.setSubject(subject, "UTF-8"); // 내용 msg.setContent(body,
	 * "text/html; charset=utf-8"); // 보낸날짜 msg.setSentDate(new Date());
	 * 
	 * // ** send mail javax.mail.Transport.send(msg);
	 * 
	 * } catch (Exception e) { e.printStackTrace();
	 * 
	 * } }
	 * 
	 *//**
		 * 2015-02-25 Kang seonjung 복수 이메일주소를 메일 수신자에 할당
		 * 
		 * @param ArrayList
		 *            slMailList
		 * @return InternetAddress[]
		 */
	/*
	 * private static InternetAddress[] getEmailToList(ArrayList slMailList)
	 * throws Exception { InternetAddress[] address = new
	 * InternetAddress[slMailList.size()]; for (int i = 0; i <
	 * slMailList.size(); i++) { address[i] = new InternetAddress((String)
	 * slMailList.get(i)); } return address; }
	 * 
	 *//**
		 * 2015-02-25 Kang seonjung PLM ADD ON PGM에서 메일 호출 시
		 * 
		 * @param ArrayList
		 *            mailParam
		 * @return
		 *//*
		 * public static void sendEmailWithFullAddress(Map<String, Object>
		 * mailParam) throws Exception { sendEmail((ArrayList)
		 * mailParam.get("toList"), (String) mailParam.get("fromList"), (String)
		 * mailParam.get("subject"), (String) mailParam.get("message")); }
		 */

}