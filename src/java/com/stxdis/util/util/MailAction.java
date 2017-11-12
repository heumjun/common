package com.stxdis.util.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.stereotype.Controller;

import stxship.dis.common.controller.CommonController;

/**
 * 메일 발송에 관한 controller 클래스를 정의한다.
 * @author 최경호
 * @since 2014.07.10
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2014.07.10  최경호          최초 생성
 *
 * </pre>
 */

@Controller
public class MailAction extends CommonController { 

	public static void main(HashMap argsMap) {                  
		System.out.println("SimpleEmail Start");                   
		//String smtpHostServer = "203.169.4.20";    // IDC에서 쓰라고 제공해준 SMTP 주소 LOCAL 테스트 시 사용     
		String smtpHostServer = "211.51.145.57";
		Properties props = System.getProperties();           
		props.put("mail.smtp.host", smtpHostServer);     
		props.put("mail.smtp.port", "25"); 
	    
		Session session = Session.getInstance(props, null);    
		
		
		String emailID = "ckred@onestx.com";   
		String toList = "";
		String subject = "";
		String message = "";
	//	sendEmail(session, emailID,"SimpleEmail Testing Subject", "SimpleEmail Testing Body");     
	} 
	
		
	
	
	/**
	 * 메일 보내기
	 * 
	 * @param	Session	session
	 * @param	String	fromEmail
	 * @param	String	toEmail
	 * @param	String	subject
	 * @param	String	body
	 * @return	NONE
	 * */
	public static void sendEmail( Session session, String fromEmail, String toEmail, String subject, String body ) {
		try {
			//mail 제목에 [테스트] 표시 유무
			boolean isTest = false;
			
			if( isTest ) {
				subject = "[테스트]" + subject;
			}
						
			//String smtpHostServer = "203.169.4.20";    // IDC에서 쓰라고 제공해준 SMTP 주소 LOCAL 테스트 시 사용     
			String smtpHostServer = "211.51.145.57";			
			
			Properties props = System.getProperties();           
			props.put("mail.smtp.host", smtpHostServer);     
			props.put("mail.smtp.port", "25"); 
		    
			session = Session.getInstance(props, null);  
			
			//set message headers
			MimeMessage msg = new MimeMessage(session);
			msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
			msg.addHeader("format", "flowed");
			msg.addHeader("Content-Transfer-Encoding", "8bit");
			
			//보내는사람
			msg.setFrom(new InternetAddress(fromEmail, ""));
			//제목
			msg.setSubject(subject, "UTF-8");
			//내용
			msg.setContent(body, "text/html; charset=utf-8");
			//보낸날짜
			msg.setSentDate(new Date());
			//받는사람
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));

			Transport.send(msg);               
			
		} catch (Exception e) {           
			e.printStackTrace();        
		}   
	}
   

	/**
	 * ERP FEEDBACK ECR 통보메일 발송
	 * 
	 * @param	Map<String, Object>	mailParam
	 * @return	NONE
	 * */
	public static void ecrIfMailSend(Map<String, Object> mailParam) {
		
		//String smtpHostServer = "203.169.4.20";    // IDC에서 쓰라고 제공해준 SMTP 주소 LOCAL 테스트 시 사용     
		String smtpHostServer = "211.51.145.57";		
		
		Properties props = System.getProperties();           
		props.put("mail.smtp.host", smtpHostServer);     
		props.put("mail.smtp.port", "25"); 
	    
		Session session = Session.getInstance(props, null);
		
		String fromMail = StringUtil.nullString( mailParam.get("from_mail") );
		String epMail = StringUtil.nullString( mailParam.get("to_mail") );
		String ecr_name = StringUtil.nullString( mailParam.get("ecr_name") );
		String feedback_no = StringUtil.nullString( mailParam.get("feedback_no") );
		String description = StringUtil.nullString( mailParam.get("description") );
		
		String mailMsg= "";
		mailMsg += "<br/ >ERP FEEDBACK 기능에 의해 아래 ECR이 생성되었습니다..<br /><br />";
		mailMsg += "&nbsp;&nbsp;&nbsp;<b> 1. ECR No. : </b> " + ecr_name + "<br /><br />";
		mailMsg += "&nbsp;&nbsp;&nbsp;<b> 2. FEEDBACK : </b> " + feedback_no + "<br /><br />";
		mailMsg += "&nbsp;&nbsp;&nbsp;<b> 3. Description  : </b> "+description+"<br /><br />";
		
		String subject = "";
		
		subject = "Create Feedback ECR ( "+ecr_name+" ).";
		
		//메일 보내기
		sendEmail( session, fromMail, epMail, subject, mailMsg );
	} 
	
	
	

	/** 2015-02-25 Kang seonjung
	 * 메일 보내기 (발신자는 시스템 admin, 수신자는 다수)
	 *	 
	 * @param	ArrayList toList
	 * @param	String	subject
	 * @param	String	body
	 * @return	NONE
	 * */
    public static void sendEmailAdmin (ArrayList toList, String subject, String body)	throws Exception
	{
		if (toList.size() < 0) return;
					
		try {
			//mail 제목에 [테스트] 표시 유무
			boolean isTest = false;
			
			if( isTest ) {
				subject = "[테스트]" + subject;
			}
			
			
			//String smtpHostServer = "203.169.4.20";    // IDC에서 쓰라고 제공해준 SMTP 주소 LOCAL 테스트 시 사용     
			String smtpHostServer = "211.51.145.57";
			
			Properties props = System.getProperties();           
			props.put("mail.smtp.host", smtpHostServer);     
			props.put("mail.smtp.port", "25"); 
		    
			Session session = Session.getInstance(props, null);  
			
			//set message headers
			MimeMessage msg = new MimeMessage(session);
			msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
			msg.addHeader("format", "flowed");
			msg.addHeader("Content-Transfer-Encoding", "8bit");
			
			//보내는사람 (발신자는 시스템)
			String sender = "plmadmin@onestx.com";
			msg.setFrom(new InternetAddress(sender,"Admin"));	
			//받는사람
			msg.setRecipients(Message.RecipientType.TO, getEmailToList(toList));
			//제목
			msg.setSubject(subject, "UTF-8");
			//내용
			msg.setContent(body, "text/html; charset=utf-8");
			//보낸날짜
			msg.setSentDate(new Date());

			
			//** send mail
			javax.mail.Transport.send(msg);
			
		} catch (Exception e) {
			e.printStackTrace();
	
		}
	}   
    
	/** 2015-02-25 Kang seonjung
	 * 메일 보내기 (발신자 1인, 수신자는 다수)
	 *	 
	 * @param	ArrayList toList
	 * @param	String	fromList
	 * @param	String	subject
	 * @param	String	body
	 * @return	NONE
	 * */
    public static void sendEmail (ArrayList toList, String fromList, String subject, String body)	throws Exception
	{
		if (toList.size() < 0) return;
					
		try {
			//mail 제목에 [테스트] 표시 유무
			boolean isTest = false;
			
			if( isTest ) {
				subject = "[테스트]" + subject;
			}			
			
			//String smtpHostServer = "203.169.4.20";    // IDC에서 쓰라고 제공해준 SMTP 주소 LOCAL 테스트 시 사용     
			String smtpHostServer = "211.51.145.57";
			
			Properties props = System.getProperties();           
			props.put("mail.smtp.host", smtpHostServer);     
			props.put("mail.smtp.port", "25"); 
		    
			Session session = Session.getInstance(props, null);  
			
			//set message headers
			MimeMessage msg = new MimeMessage(session);
			msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
			msg.addHeader("format", "flowed");
			msg.addHeader("Content-Transfer-Encoding", "8bit");			
			
			/*** 이게 안되서 메일 호출 시 fromList 주는 걸로 변경
			Map ttt = SessionUtils.getAuthenticatedUser();
			System.out.print("ttt = "+ttt);
			String sender = (String)ttt.get("ep_mail");
			//String sender = (String)SessionUtils.getAuthenticatedUser().get( "ep_mail" );			
			//String sender = (String)SessionUtils.getAuthenticatedUser().get( "user_id" );
			System.out.println("sendEmail sender = "+sender);
			*/
			
			String sender = fromList;
			if(sender==null && "null".equals(sender) && "".equals(sender))
			{
				sender = "plmadmin@onestx.com";
			}
			
			//보내는사람
			msg.setFrom(new InternetAddress(sender,""));	
			//받는사람
			msg.setRecipients(Message.RecipientType.TO, getEmailToList(toList));
			//제목
			msg.setSubject(subject, "UTF-8");
			//내용
			msg.setContent(body, "text/html; charset=utf-8");
			//보낸날짜
			msg.setSentDate(new Date());

			
			//** send mail
			javax.mail.Transport.send(msg);
			
		} catch (Exception e) {
			e.printStackTrace();
	
		}
	}       
    
	/** 2015-02-25 Kang seonjung
	 * 복수 이메일주소를 메일 수신자에 할당
	 * 
	 * @param	ArrayList	slMailList
	 * @return	InternetAddress[]
	 * */    
	private static InternetAddress[] getEmailToList(ArrayList slMailList) throws Exception
	{
		InternetAddress[] address = new InternetAddress[slMailList.size()];
		for(int i= 0; i< slMailList.size(); i++ ) {
			address[i] = new InternetAddress((String)slMailList.get(i));
		}
		return address;
	}
	
	/** 2015-02-25 Kang seonjung
	 * PLM ADD ON PGM에서 메일 호출 시
	 * 
	 * @param	ArrayList	mailParam
	 * @return	
	 * */  	
    public static void sendEmailWithFullAddress(Map<String, Object> mailParam) throws Exception
	{        
		sendEmail((ArrayList)mailParam.get("toList"), (String)mailParam.get("fromList"), (String)mailParam.get("subject"), (String)mailParam.get("message"));
    }	
	
	
 }