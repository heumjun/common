/**
 * <pre>
 * 프로젝트명 : FKL-PLM-MIGRATION
 * 시스템명   : MIGRATION (COMMON MODULE)
 * 버전       : 1.0
 * 작성자     : 김혜수
 * 작성일자   : 2005/06/29
 * V 1.0      : 김혜수, 2005/06/29
 * </pre>
 * 기능       : Migration PGM에서 사용되는 공통 상수들을 정의
 * 사용처     : Migration PGM
 */
package com.stx.migration;
public class FKLDataMigrationCommonConstants 
{
    /* COMMON CONSTANTS */
    public static final boolean FKL_DEBUG_MODE = false;

    /* STRING CONSTANTS */
    public static final String STR_COMMON_EXCEL_FILE_EXT = ".xls";
    public static final String STR_COMMON_SIGNATURE_COMMENT = "migration - signature ignored";
    public static final String STR_COMMON_CHECKIN_REASON    = "migration - attached";
  
    public static final String STR_PARAM_DELIMITER            	= "=";
    public static final String STR_PARAM_USER                 		= "user";
    public static final String STR_PARAM_PASSWORD            = "password";
    public static final String STR_PARAM_ALLOW_UPDATE     = "allowUpdate";
    public static final String STR_PARAM_DETAILED_LOG       = "detailedLog";
    public static final String STR_PARAM_DEFAULT_USER       = "creator";
    public static final String STR_PARAM_DEFAULT_PASSWORD     = "";
    public static final String STR_PARAM_DEFAULT_ALLOW_UPDATE = "false";
    public static final String STR_PARAM_DEFAULT_DETAILE_LOG  = "false";

    public static final String STR_LOG_DIRECTORY  = "logs";
    public static final String STR_LOG_FILE_NAME  = "migration_log";
    public static final String STR_LOG_FILE_EXT   = ".log";

    public static final String STR_MQL_HISTORY_OFF = "history off";
    public static final String STR_MQL_HISTORY_ON  = "history on";
    public static final String STR_MQL_TRIGGER_OFF = "trigger off";
    public static final String STR_MQL_TRIGGER_ON  = "trigger on";

    public static final String STR_COMMON_UNKNOWN_LOCATION = "(알 수 없는 위치)";
   
    public static final String STR_VALUE_DELIM   = ",";
    public static final String STR_VALUE_MASTER  = "Master";
    public static final String STR_VALUE_PROJECT = "Project";
    public static final String STR_VALUE_ITEM    = "Item";
    public static final String STR_VALUE_MUST_SEL_ONE = "Must Select Only One";
    public static final String STR_VALUE_MAY_SEL_ONE = "May Select Only One";
    public static final String STR_VALUE_MAY_SEL_ONE_OR_MORE = "May Select One Or More";
    public static final String STR_VALUE_FEATURE_REV = "1";
    public static final String STR_VALUE_YES   = "Yes";
    public static final String STR_VALUE_NO   = "No";
    public static final String STR_VALUE_INCLUSION = "Inclusion";
    
    public static final String STR_TYPE_ITEM                = "Part";
    public static final String STR_TYPE_CAD_DRAWING   = "CAD Drawing";
    public static final String STR_TYPE_DOCUMENT        = "Document";
    public static final String STR_TYPE_MODEL               = "Products";
    public static final String STR_TYPE_PROJECT            = "Product Configuration";
    public static final String STR_TYPE_BASIC_DRAWING  = "STX Basic Drawing";
    public static final String STR_TYPE_DIARAM              = "STX Diagram";
    public static final String STR_TYPE_MGMT_DRAWING      = "STX Management Drawing";
    public static final String STR_TYPE_CALC_DRAWING        = "STX Calculate Sheet";
    public static final String STR_TYPE_CONTRACT_DRAWING    = "STX Contract Drawing";
    public static final String STR_TYPE_ARRANGE_DRAWING     = "STX Arrangement Drawing";
    public static final String STR_TYPE_INSTALL_DRAWING     = "STX Installation Drawing";
    public static final String STR_TYPE_EQUIP_DRAWING       = "STX Equipment Drawing";
    public static final String STR_TYPE_CUTTING_DRAWING     = "STX Cutting Drawing";
    public static final String STR_TYPE_ASSEMBLY_DRAWING    = "STX Assembly Drawing";
    public static final String STR_TYPE_MANUFACTURE_DRAWING = "STX Manufacture Drawing";
    public static final String STR_TYPE_PIECE_DRAWING       = "STX Piece Drawing";
    public static final String STR_TYPE_MAKER_DRAWING       = "STX Maker Drawing";
    public static final String STR_TYPE_ECO                 = "ECO";
    public static final String STR_TYPE_ECR                 = "ECR";
    public static final String STR_TYPE_MAKER               = "STX Maker";
    public static final String STR_TYPE_FEATURE             = "Feature";
    public static final String STR_TYPE_ACCOMMODATION       = "STX Accommodation";
    public static final String STR_TYPE_AUTOMATION_ELECTRIC = "STX Automation";
    public static final String STR_TYPE_GENERAL             = "STX General";
    public static final String STR_TYPE_HULL_PIPING         = "STX Hull Piping";
    public static final String STR_TYPE_HULL_STRUCTURE      = "STX Hull Structure";
    public static final String STR_TYPE_MACHINERY           = "STX Machinery";
    public static final String STR_TYPE_MATERIAL_PROTECTION = "STX Material Protection";
    public static final String STR_TYPE_SHIP_EQUIPMENT      = "STX Ship Equipment Out Fitting";
    public static final String STR_TYPE_PIPE_JOINT_FITTING  = "STX Pipe Joint Fitting";
    public static final String STR_TYPE_VALVE_FITTING       = "STX Valve Fitting";
    public static final String STR_TYPE_ELECTRICAL_NAVI     = "STX Electrical Navigation";
    public static final String STR_TYPE_FEATURE_LIST        = "Feature List";
    public static final String STR_TYPE_PART_FAMILY         = "Part Family";
    
    public static final String STR_REL_EBOM              = "EBOM";
    public static final String STR_REL_PRAT_SPEC         = "Part Specification";
    public static final String STR_REL_REF_DOCUMENT      = "Reference Document";
    public static final String STR_REL_MODEL_SPEC        = "STX Model Specification";
    public static final String STR_REL_PROJECT_SPEC      = "STX Project Specification";
    public static final String STR_REL_MAKER_DRAWING     = "STX Maker Designated Drawing";
    public static final String STR_REL_FEATURE_LIST_FROM = "Feature List From";
    public static final String STR_REL_FEATURE_LIST_TO   = "Feature List To";
    public static final String STR_REL_PART_FAMILY_MEMBER = "Part Family Member";
	
    public static final String STR_ATTR_UOM             = "Unit of Measure";
    public static final String STR_ATTR_WEIGHT          = "Weight";
    //public static final String STR_ATTR_MATERIAL_CAT    = "Material Category";
    public static final String STR_ATTR_MATERIAL_CAT    = "ItemCategory";
    public static final String STR_ATTR_FN              = "Find Number";
    public static final String STR_ATTR_QUANTITY        = "Quantity";
    public static final String STR_ATTR_TITLE           = "Title";
    public static final String STR_ATTR_ORIGINATOR      = "Originator";
    public static final String STR_ATTR_RD_GROUP        = "Release Distribution Group";
    public static final String STR_ATTR_BASIC_RULE      = "STX Basic Rule";
    public static final String STR_ATTR_SCALE           = "STX Scale";
    public static final String STR_ATTR_SHEET           = "STX Sheet";
    public static final String STR_ATTR_TEL             = "STX Tel";
    public static final String STR_ATTR_DRAWING_KIND    = "STX Drawing Kind";
    public static final String STR_ATTR_REL_DESIGNER    = "STX Related Designer";
    public static final String STR_ATTR_CHECKIN_REASON  = "Checkin Reason";
    public static final String STR_ATTR_MARKETING_NAME  = "Marketing Name";
    public static final String STR_ATTR_MARKETING_TEXT  = "Marketing Text";
    public static final String STR_ATTR_SELECTION_TYPE  = "Feature Selection Type";
    public static final String STR_ATTR_SEQUENCE_ORDER  = "Sequence Order";
    public static final String STR_ATTR_MAKER           = "STX Maker";
    public static final String STR_ATTR_COUNTRY         = "STX Country";
    public static final String STR_ATTR_NOTES           = "Notes";
    public static final String STR_ATTR_PE_BLOCK        = "STX PE Block";
    public static final String STR_ATTR_SYNOPSIS        = "Synopsis";
    public static final String STR_ATTR_DEFAULT_SEL     = "Default Selection";
    public static final String STR_ATTR_MARKETING_FEATURE  = "Marketing Feature";
    public static final String STR_ATTR_TECHNICAL_FEATURE  = "Technical Feature";
    public static final String STR_ATTR_RULE_TYPE  = "Rule Type";
    public static final String STR_ATTR_MAX_QTY = "Maximum Quantity";
    public static final String STR_ATTR_MIN_QTY = "Minimum Quantity";
    
    public static final String STR_ATTR_ITEM_ORA_TEMPLATE  = "Oracle Template";
    public static final String STR_ATTR_ITEM_CABLE_TYPE    = "Cable Type";
    public static final String STR_ATTR_ITEM_CABLE_LEN     = "Cable Length";
    public static final String STR_ATTR_ITEM_THINNER_CODE  = "Thinner Code";   
    public static final String STR_ATTR_ITEM_PAINT_CODE    = "Paint Code";    
    public static final String STR_ATTR_ITEM_ATTR0         = "Attr0";   
    public static final String STR_ATTR_ITEM_ATTR1         = "Attr1";   
    public static final String STR_ATTR_ITEM_ATTR2         = "Attr2";   
    public static final String STR_ATTR_ITEM_ATTR3         = "Attr3";   
    public static final String STR_ATTR_ITEM_ATTR4         = "Attr4";   
    public static final String STR_ATTR_ITEM_ATTR5         = "Attr5";   
    public static final String STR_ATTR_ITEM_ATTR6         = "Attr6";   
    public static final String STR_ATTR_ITEM_ATTR7         = "Attr7";   
    public static final String STR_ATTR_ITEM_ATTR8         = "Attr8";   
    public static final String STR_ATTR_ITEM_ATTR9         = "Attr9";   
    public static final String STR_ATTR_ITEM_ATTR10       = "Attr10";  
    public static final String STR_ATTR_ITEM_ATTR11       = "Attr11";  
    public static final String STR_ATTR_ITEM_ATTR12       = "Attr12";  
    public static final String STR_ATTR_ITEM_ATTR13       = "Attr13";  
    public static final String STR_ATTR_ITEM_ATTR14       = "Attr14";  
    
    public static final String STR_ATTR_BOM_PROJECT     = "Component Location";   
    public static final String STR_ATTR_BOM_ATTR1          = "ATTRIBUTE1";  
    public static final String STR_ATTR_BOM_ATTR2          = "ATTRIBUTE2";  
    public static final String STR_ATTR_BOM_ATTR3          = "ATTRIBUTE3";  
    public static final String STR_ATTR_BOM_ATTR4          = "ATTRIBUTE4";  
    public static final String STR_ATTR_BOM_ATTR5          = "ATTRIBUTE5";  
    public static final String STR_ATTR_BOM_ATTR6          = "ATTRIBUTE6";  
    public static final String STR_ATTR_BOM_ATTR7          = "ATTRIBUTE7";  
    public static final String STR_ATTR_BOM_ATTR8          = "ATTRIBUTE8";  
    public static final String STR_ATTR_BOM_ATTR9          = "ATTRIBUTE9";  
    public static final String STR_ATTR_BOM_ATTR10        = "ATTRIBUTE10"; 
    public static final String STR_ATTR_BOM_ATTR11        = "ATTRIBUTE11"; 
    public static final String STR_ATTR_BOM_ATTR12        = "ATTRIBUTE12"; 
    public static final String STR_ATTR_BOM_ATTR13        = "ATTRIBUTE13"; 
    public static final String STR_ATTR_BOM_ATTR14        = "ATTRIBUTE14"; 
    public static final String STR_ATTR_BOM_ATTR15        = "ATTRIBUTE15"; 

    public static final String STR_POLICY_OF_ITEM       = "EC Part";
    public static final String STR_POLICY_OF_DOCUMENT   = "STX Document";
    public static final String STR_POLICY_OF_CAD        = "CAD Drawing";
    public static final String STR_POLICY_OF_MAKER_CAD  = "STX Maker Drawing";
    public static final String STR_POLICY_OF_FEATURE    = "Product Feature";
    public static final String STR_POLICY_OF_FEATURE_LIST = "Rule";
    
    public static final String STR_CAD_STATUS_1         = "Preliminary";
    public static final String STR_CAD_STATUS_2         = "Review";
    public static final String STR_CAD_STATUS_3         = "Approved";
    public static final String STR_CAD_STATUS_4         = "Release";
    
    public static final String STR_DOCUMENT_STATUS_1    = "Preliminary";
    public static final String STR_DOCUMENT_STATUS_2    = "Review";
    public static final String STR_DOCUMENT_STATUS_3    = "Release";
    
    public static final String STR_DEFAULT_VAULT       = "eService Production";

    /* ERRORS */
    public static final String ERR_BOM_NO_LEVEL              = "Item/BOM - 레벨 정보가 누락되었습니다.";
    public static final String ERR_BOM_NO_NAME               = "Item/BOM - 이름 정보가 누락되었습니다.";
    public static final String ERR_BOM_NO_FN                    = "Item/BOM - F/N 정보가 누락되었습니다.";
    public static final String ERR_BOM_INVALID_LEVEL       = "Item/BOM - 레벨 정보가 유효하지 않습니다.";
    public static final String ERR_BOM_CANNOT_FIND_PARENT_ITEM  = "레벨 정보가 유효하지 않습니다.";
    public static final String ERR_BOM_CANNOT_FIND_REL_DRAWING  = "관련 도면이 존재하지 않습니다.";
    public static final String ERR_BOM_CANNOT_FIND_PART_FAMILY  = "Part Family가 존재하지 않습니다.";

    public static final String ERR_DOC_NO_TYPE                  = "Document - 타입 정보가 누락되었습니다.";
    public static final String ERR_DOC_NO_NAME                  = "Document - 이름 정보가 누락되었습니다.";
    public static final String ERR_DOC_NO_REVISION              = "Document - Revision 정보가 누락되었습니다.";
    public static final String ERR_DOC_NO_TITLE                 = "Document - Title 정보가 누락되었습니다.";
    public static final String ERR_DOC_NO_OWNER                 = "Document - Owner 정보가 누락되었습니다.";
    public static final String ERR_DOC_NO_STATE                 = "Document - State 정보가 누락되었습니다.";

    public static final String ERR_DOC_INVALID_ATTACH           = "첨부 파일 정보가 올바르지 않습니다.";
    public static final String ERR_DOC_INVALID_ATTACH_FILE      = "첨부 파일이 존재하지 않습니다.";
    public static final String ERR_DOC_INVALID_ATTACH_FORMAT    = "첨부 파일 포맷 정보가 올바르지 않습니다.";

    public static final String ERR_CAD_NO_CATEGORY              = "CAD Drawing - 도면구분 정보가 누락되었습니다.";
    public static final String ERR_CAD_INVALID_CATEGORY         = "CAD Drawing - 도면구분 정보가 올바르지 않습니다.";
    public static final String ERR_CAD_NO_TYPE                  = "CAD Drawing - 타입 정보가 누락되었습니다.";
    public static final String ERR_CAD_INVALID_TYPE             = "CAD Drawing - 타입 정보가 올바르지 않습니다.";
    public static final String ERR_CAD_NO_NAME                  = "CAD Drawing - 이름 정보가 누락되었습니다.";
    public static final String ERR_CAD_NO_REVISION              = "CAD Drawing - Revision 정보가 누락되었습니다.";
    public static final String ERR_CAD_NO_TITLE                 = "CAD Drawing - Title 정보가 누락되었습니다.";
    public static final String ERR_CAD_NO_OWNER                 = "CAD Drawing - Owner 정보가 누락되었습니다.";
    public static final String ERR_CAD_NO_STATE                 = "CAD Drawing - State 정보가 누락되었습니다.";
    public static final String ERR_CAD_NO_MASTER                = "CAD Drawing - 모델 정보가 누락되었습니다. (Master 도면)";
    public static final String ERR_CAD_NO_PROJECT               = "CAD Drawing - 프로젝트 정보가 누락되었습니다. (Project 도면)";
    public static final String ERR_CAD_NO_ITEM                  = "CAD Drawing - 아이템 정보가 누락되었습니다. (Item 도면)";
    
    public static final String ERR_COMMON_NO_PROJECT            = "Project (STX) 요소가 존재하지 않습니다.";
    public static final String ERR_COMMON_NO_MODEL              = "Model (STX) 요소가 존재하지 않습니다.";
    public static final String ERR_COMMON_NO_ITEM               = "Item (STX) 요소가 존재하지 않습니다.";
    public static final String ERR_COMMON_NO_DOCUMENT           = "Document 요소가 존재하지 않습니다.";
    public static final String ERR_COMMON_NO_ELEMENT            = "요소가 존재하지 않습니다.";
    
    public static final String ERR_FEATURE_NO_SEQ               = "Feature - Sequence Number 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_INVALID_SEQ          = "Feature - Sequence Number 정보가 유효하지 않습니다.";
    public static final String ERR_FEATURE_NO_MODEL_NO          = "Feature - Model Number 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_INVALID_MODEL_NO     = "Feature - Model Number 정보가 유효하지 않습니다.";
    public static final String ERR_FEATURE_NO_GROUP_CODE        = "Feature - Group Code 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_INVALID_GROUP_CODE   = "Feature - Group Code 정보가 유효하지 않습니다.";
    public static final String ERR_FEATURE_NO_FEATURE_TYPE      = "Feature - Feature Type 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_INVALID_FEATURE_TYPE = "Feature - Feature Type 정보가 유효하지 않습니다.";
    public static final String ERR_FEATURE_NO_FEATURE_SELECTION = "Feature - Feature Selection 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_NO_FEATURE_DESC      = "Feature - Feature Description 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_INVALID_FEATURE_DESC = "Feature - Feature Description 정보가 유효하지 않습니다.";
    public static final String ERR_FEATURE_INVALID_FEATURE_SELECTION = "Feature - Feature Selection 정보가 유효하지 않습니다.";
    public static final String ERR_FEATURE_NO_SUB_FEATURE_MARKETING = "Feature - Sub Feature Marketing Name 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_NO_SUB_FEATURE_VALUE_NAME = "Feature - Sub Feature Name 정보가 누락되었습니다.";
    public static final String ERR_FEATURE_NO_SUB_FEATURE_DESC  = "Feature - Sub Feature Description 정보가 누락되었습니다.";

    public static final String ERR_INTERNAL = "Internal Error";
}