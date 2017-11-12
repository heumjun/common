/*
 * @Class Name : Constants.java
 * @Description : 상수 정의 class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2013.12.26    배동오         최초 생성
 *
 * @author 배동오
 * @since 2013.12.26
 * @version 1.0
 * @see
 */
package com.stxdis.util.constant;

/**
 * 상수 정의.
 */
public class DISConstants {
    
	/*
	 * --------------------------------------------------------------------------------------
	 * 케릭터셋
	 * --------------------------------------------------------------------------------------
	 */
	/** The Constant DEL_ID_NORMAL. */
	public static final String CHARACTER_SET_UTF_8 = "UTF-8"; // 사용
	public static final String ADMIN_EMAIL = "xxx@naver.com"; // 관리자단 공통 이메일 연락처
	public static final String ADMIN_PHONE = "xxx-xxx-xxxx"; // 관리자단 공통  연락처
	
	public static final String POPUP	   = "jsp/popup/";
	public static final String BASEINFO	   = "jsp/baseInfo/";
	public static final String COM	   	   = "jsp/com/"; // 공통 히스토리 나오기 위해 사용
	public static final String DWG		   = "jsp/dwg/";
	public static final String ECO		   = "jsp/eco/";
	public static final String ECR		   = "jsp/ecr/";
	public static final String DOC		   = "jsp/doc/";  //문서
	public static final String ITEM		   = "jsp/item/"; //아이템
	public static final String PAINT	   = "jsp/paint/";
	public static final String EXCEL	   = "uploaddata/temp";
	public static final String ECRBASEDON  = "jsp/ecrBasedOn/";
	public static final String BOM		   = "jsp/bom/";
	public static final String LOGIN	   = "jsp/login/";
	public static final String MAIN		   = "jsp/mainframe/";
	public static final String MANUAL   = "jsp/manual/";
	public static final String SYSTEM	   = "jsp/system/";
	
	public static final String PLM_ITEM_NONSTADARD_DEFAULT_CIPHER = "7";
	public static final String PLM_ITEM_CODE_CIPHER 			  = "O|3,ZJ|3,ZK|3,ZL|3,VC|3,ZR|5,V|6,R|4,A|4,PD|9,9|None";
	public static final String PLM_ORGANIZATION_ID 			  	  = "82"; // ECO PROJECT 연결시 ERP에 있는지 확인하기 위해 국가코드 필요  function STX_DIS_EXIST_PROJECT 에서 사용
	
	public static final String ADMIN_ADDRESS = "plmadmin@stxship.com";
	public static final String PAINT_DWG_NO  = "M2020000";
	
	
}
