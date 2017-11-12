/**
 * <pre>
 * 프로젝트명 : STX조선 PLM 구축 프로젝트
 * 시스템명   : MIGRATION (STX)
 * 버전       : 1.0
 * 작성자     : 김혜수
 * 작성일자   : 2005/06/29
 * V 1.0      : 김혜수, 2005/06/29
 * </pre>
 * 기능       : STX Migration PGM에서 사용되는 STX Project 관련 공통 상수들을 정의
 * 사용처     : STX Migration PGM
 */
 package com.stx.migration;
 
public class STXDataMigrationConstants 
{
    /* STRING CONSTANTS */
    public static final String STR_CATEGORY_BOM        = "bom";
    public static final String STR_CATEGORY_DOCUMENT   = "document";
    public static final String STR_CATEGORY_DRAWING    = "drawing";
    public static final String STR_CATEGORY_SALES_TEMPLATE = "sales_template";
    public static final String STR_CATEGORY_BOM_OLD    = "bom_old"; 
	// 20050831 bom_new 추가.
    public static final String STR_CATEGORY_BOM_NEW    = "bom_new"; 
    
    public static final String STR_EXCEL_SHEET_IDX     = "sheetIdx";
    public static final String STR_EXCEL_SHEET_NAME    = "sheetName";
    public static final String STR_EXCEL_ROW_IDX       = "rowIdx";

    public static final String STR_COLUMN_ITEM_LEVEL        = "LV";
    public static final String STR_COLUMN_ITEM_NAME         = "자부품 코드";
    public static final String STR_COLUMN_ITEM_FN           = "SERIAL";
    public static final String STR_COLUMN_ITEM_REVISION     = "REV NO";
    public static final String STR_COLUMN_ITEM_DESCRIPTION  = "DESCRIPTION";
    public static final String STR_COLUMN_ITEM_UOM          = "단위";
    public static final String STR_COLUMN_ITEM_QTY          = "수량";
    public static final String STR_COLUMN_ITEM_WEIGHT       = "중량";
    public static final String STR_COLUMN_ITEM_MATERIAL_CAT = "재질";
    public static final String STR_COLUMN_ITEM_REL_DRAWING  = "도면번호";
    
    public static final String STR_COLUMN_ITEM_LEVEL2        = "Level";
    public static final String STR_COLUMN_ITEM_NAME2         = "Item No";
    public static final String STR_COLUMN_ITEM_FN2           = "Serial";
    public static final String STR_COLUMN_ITEM_REVISION2     = "Item Rev";
    public static final String STR_COLUMN_ITEM_DESCRIPTION2  = "Description";
    public static final String STR_COLUMN_ITEM_UOM2          = "Unit Of Measure";
    public static final String STR_COLUMN_ITEM_QTY2          = "QUANTITY";
    public static final String STR_COLUMN_ITEM_WEIGHT2       = "Weight";
    public static final String STR_COLUMN_ITEM_MATERIAL_CAT2 = "CATEGORY";
    
    public static final String STR_COLUMN_ITEM_ORA_TEMPLATE  = "Oracle Template (ERP)";
    public static final String STR_COLUMN_ITEM_CABLE_TYPE    = "Cable Type";
    public static final String STR_COLUMN_ITEM_CABLE_LEN     = "Cable Length";
    public static final String STR_COLUMN_ITEM_THINNER_CODE  = "Thinner Code";   
    public static final String STR_COLUMN_ITEM_PAINT_CODE    = "Paint Code";    
    public static final String STR_COLUMN_ITEM_PART_FAMILY   = "Part Family(PLM)";
    public static final String STR_COLUMN_ITEM_ATTR0         = "ATTRIBUTE0";   
    public static final String STR_COLUMN_ITEM_ATTR1         = "ATTRIBUTE1";   
    public static final String STR_COLUMN_ITEM_ATTR2         = "ATTRIBUTE2";   
    public static final String STR_COLUMN_ITEM_ATTR3         = "ATTRIBUTE3";   
    public static final String STR_COLUMN_ITEM_ATTR4         = "ATTRIBUTE4";   
    public static final String STR_COLUMN_ITEM_ATTR5         = "ATTRIBUTE5";   
    public static final String STR_COLUMN_ITEM_ATTR6         = "ATTRIBUTE6";   
    public static final String STR_COLUMN_ITEM_ATTR7         = "ATTRIBUTE7";   
    public static final String STR_COLUMN_ITEM_ATTR8         = "ATTRIBUTE8";   
    public static final String STR_COLUMN_ITEM_ATTR9         = "ATTRIBUTE9";   
    public static final String STR_COLUMN_ITEM_ATTR10        = "ATTRIBUTE10";  
    public static final String STR_COLUMN_ITEM_ATTR11        = "ATTRIBUTE11";  
    public static final String STR_COLUMN_ITEM_ATTR12        = "ATTRIBUTE12";  
    public static final String STR_COLUMN_ITEM_ATTR13        = "ATTRIBUTE13";  
    public static final String STR_COLUMN_ITEM_ATTR14        = "ATTRIBUTE14";  
	// 20050831 bom_new 추가.
	public static final String STR_COLUMN_ITEM_NAME3         = "자부품 Item No";   
    public static final String STR_COLUMN_ITEM_REVISION3     = "자부품 Item Rev";
	public static final String STR_COLUMN_BOM_QTY            = "수량";   

	public static final String STR_COLUMN_BOM_PROJECT        = "PROJECT";   
    public static final String STR_COLUMN_BOM_ATTR1          = "BOM ATTRIBUTE1";  
    public static final String STR_COLUMN_BOM_ATTR2          = "BOM ATTRIBUTE2";  
    public static final String STR_COLUMN_BOM_ATTR3          = "BOM ATTRIBUTE3";  
    public static final String STR_COLUMN_BOM_ATTR4          = "BOM ATTRIBUTE4";  
    public static final String STR_COLUMN_BOM_ATTR5          = "BOM ATTRIBUTE5";  
    public static final String STR_COLUMN_BOM_ATTR6          = "BOM ATTRIBUTE6";  
    public static final String STR_COLUMN_BOM_ATTR7          = "BOM ATTRIBUTE7";  
    public static final String STR_COLUMN_BOM_ATTR8          = "BOM ATTRIBUTE8";  
    public static final String STR_COLUMN_BOM_ATTR9          = "BOM ATTRIBUTE9";  
    public static final String STR_COLUMN_BOM_ATTR10         = "BOM ATTRIBUTE10"; 
    public static final String STR_COLUMN_BOM_ATTR11         = "BOM ATTRIBUTE11"; 
    public static final String STR_COLUMN_BOM_ATTR12         = "BOM ATTRIBUTE12"; 
    public static final String STR_COLUMN_BOM_ATTR13         = "BOM ATTRIBUTE13"; 
    public static final String STR_COLUMN_BOM_ATTR14         = "BOM ATTRIBUTE14"; 
    public static final String STR_COLUMN_BOM_ATTR15         = "BOM ATTRIBUTE15"; 

    public static final String STR_COLUMN_DOC_TYPE           = "문서구분";
    public static final String STR_COLUMN_DOC_NAME           = "문서번호";
    public static final String STR_COLUMN_DOC_REVISION       = "리비전";
    public static final String STR_COLUMN_DOC_TITLE          = "제목";
    public static final String STR_COLUMN_DOC_OWNER          = "작성자";
    public static final String STR_COLUMN_DOC_ORIGINATOR     = "담당자";
    public static final String STR_COLUMN_DOC_STATE          = "상태";
    public static final String STR_COLUMN_DOC_RDGROUP        = "배포처";
    public static final String STR_COLUMN_DOC_REL_PROJECTS   = "프로젝트";
    public static final String STR_COLUMN_DOC_REL_MODELS     = "모델";
    public static final String STR_COLUMN_DOC_REL_ITEMS      = "아이템";
    public static final String STR_COLUMN_DOC_REL_DOCUMENTS  = "관련문서";
    public static final String STR_COLUMN_DOC_ATTACH_PATHS   = "Path,파일";
    public static final String STR_COLUMN_DOC_ATTACH_FORMATS = "포맷";

    public static final String STR_COLUMN_CAD_TYPE           = "도면종류";
    public static final String STR_COLUMN_CAD_NAME           = "도면번호";
    public static final String STR_COLUMN_CAD_REVISION       = "리비전";
    public static final String STR_COLUMN_CAD_TITLE          = "도면명";
    public static final String STR_COLUMN_CAD_STATE          = "상태";
    public static final String STR_COLUMN_CAD_OWNER          = "작성자";
    public static final String STR_COLUMN_CAD_ORIGINATOR     = "담당자";
    public static final String STR_COLUMN_CAD_BASIC_RULE     = "작성규칙";
    public static final String STR_COLUMN_CAD_CATEGORY       = "도면구분";
    public static final String STR_COLUMN_CAD_SCALE          = "스케일";
    public static final String STR_COLUMN_CAD_SHEET          = "매수";
    public static final String STR_COLUMN_CAD_TEL            = "전화번호";
    public static final String STR_COLUMN_CAD_MODEL          = "모델";
    public static final String STR_COLUMN_CAD_PROJECT        = "프로젝트";
    public static final String STR_COLUMN_CAD_ITEM           = "관련ITEM";
    public static final String STR_COLUMN_CAD_ITEM_REV		 = "관련ITEM REV";
    public static final String STR_COLUMN_CAD_ECO            = "관련ECO";
    public static final String STR_COLUMN_CAD_ECR            = "관련ECR";
    public static final String STR_COLUMN_CAD_MAKER          = "메이커";
    public static final String STR_COLUMN_CAD_REL_DESIGNER   = "설계담당자";
    public static final String STR_COLUMN_CAD_ATTACH_PATHS   = "Path,파일";
    public static final String STR_COLUMN_CAD_ATTACH_FORMATS = "포맷";
    
    public static final String STR_COLUMN_FEATURE_SEQ_NO = "No";
    public static final String STR_COLUMN_FEATURE_TYPE = "분류 Code";
    public static final String STR_COLUMN_FEATURE_GROUP_CODE = "Group Code";
    public static final String STR_COLUMN_FEATURE_GROUP = "Group";
    public static final String STR_COLUMN_FEATURE_SELECTION = "Type 구분";
    public static final String STR_COLUMN_SUB_FEATURE_MARKETING_NAME = "Values TYPE";
    public static final String STR_COLUMN_SUB_FEATURE_VALUE_NAME = "Value Name";
    public static final String STR_COLUMN_SUB_FEATURE_DESCRIPTION = "사양 Description";
    public static final String STR_COLUMN_SUB_FEATURE_MAKER = "Sub. Values Maker";
    public static final String STR_COLUMN_SUB_FEATURE_COUNTRY = "Sub. Values 국가";
    public static final String STR_COLUMN_SUB_FEATURE_SELECTION = "Sub. Values 선택";
    public static final String STR_COLUMN_SUB_FEATURE_NOTES = "기본도면";
    public static final String STR_COLUMN_SUB_FEATURE_PEBLOCK = "P.E Block";
	///////////////////// 구역 PE BLOCK 추가 BEGINS  /////////////////////////////
    public static final String STR_COLUMN_SUB_FEATURE_GUPEBLOCK = "구역 P.E Block";
	///////////////////// 구역 PE BLOCK 추가 BEGINS  /////////////////////////////
    
    public static final String STR_COLUMN_SUB_FEATURE_SYNOPSIS = "REMARK";
    
    public static final String STR_COLUMN_VAL_ACCOMMODATION = "ACCOMMODATION";
    public static final String STR_COLUMN_VAL_AUTOMATION = "AUTOMATION SYSTEM";
    public static final String STR_COLUMN_VAL_GENERAL = "GENERAL";
    public static final String STR_COLUMN_VAL_HULL_PIPING = "HULL PIPING SYSTEM";
    public static final String STR_COLUMN_VAL_HULL_STRUCTURE = "HULL STRUCTURE";
    public static final String STR_COLUMN_VAL_MAIN_MACHINERY = "MAIN MACHINERY COMPONENT";
    public static final String STR_COLUMN_VAL_MATERIAL_PROTECTION = "MATERIAL PROTECTION";
    public static final String STR_COLUMN_VAL_SHIP_EQUIPMENT = "SHIP'S EQUIPMENT AND OUTFIT";
    public static final String STR_COLUMN_VAL_PIPE_JOINT_FITTING = "PIPE JOINT FITTING";
    public static final String STR_COLUMN_VAL_VALVE_FITTING = "VALVE FITTING";
    public static final String STR_COLUMN_VAL_ELECTRICAL_SYSTEM = "ELECTRICAL SYSTEM AND NAVIGATION EQUIPMENT";
    
    public static final String STR_COLUMN_VAL_MUST_SEL_ONLY_ONE = "M";
    public static final String STR_COLUMN_VAL_MUST_SEL_ONLY_ONE_2 = "A";
    public static final String STR_COLUMN_VAL_MAY_SEL_ONLY_ONE = "O";
    
    public static final String STR_COLUMN_VAL_CHECKED = "√";
    
    public static final String[] STR_COLUMN_VAL_ESCAPES = {"-", "?"};
    
    /* ERRORS */
    public static final String ERR_INVALID_INPUT_PARAMS           = "\n실행 파라미터가 올바르지 않습니다.\n\nUsage:\n" + 
                                                                     "java -Xms512m -Xmx512m migratestx <migration category> <path> <server> [user] [password] [update allowance] [detailed logging]\n" + 
                                                                     "- * <>: 필수 입력 항목\n" + 
                                                                     "- * []: 선택 입력 항목\n" +
                                                                     "- <migration category>: 마이그레이션할 레거시 데이터 구분 (bom | document | drawing | sales_template)\n" + 
                                                                     "- <path>: 레거시 데이터가 존재하는 폴더 또는 파일의 완전한 경로. 파일의 경우 파일명 포함\n" + 
                                                                     "- <server>: Matrix 서버 접속 경로 (IP)\n" + 
                                                                     "- [<user=>user]: 사용자명. 생략되는 경우 'creator'로 접속\n" + 
                                                                     "- [<password=>password]: 사용자의 접속 비밀번호\n" +
                                                                     "- [<allowUpdate=>update allowance]: 생성하려는 요소가 이미 존재하는 경우 존재하는 요소의 속성 값들을 업데이트 할 지 여부. (true | false, 디폴트는 false)\n" + 
                                                                     "- [<detailedLog=>detailed log]: 로그파일에 기록되는 로그에 각 요소에 대한 처리 정보를 기록할 지 여부. (true | false, 디폴트는 false)\n" + 
                                                                     "- (ex) java -Xms512m -Xmx512m migratestx bom D:\\sample_data\\ localhost user=myId password=myPasswd allowUpdate=true detailedLog=true\n"; 
    public static final String ERR_INVALID_INPUT_PARAMS_FILE_SPEC = "\n파일 또는 폴더가 존재하지 않습니다. 입력 경로를 확인하십시오.";
    public static final String ERR_INVALID_INPUT_PARAMS_CATEGORY  = ERR_INVALID_INPUT_PARAMS;
    public static final String ERR_INVALID_INPUT_PARAMS_SERVER    = "\n서버 이름 또는 사용자 정보가 올바르지 않거나 접속할 수 없는 서버입니다.";
    public static final String ERR_DOC_ATTACH_FILE_NOT_FOUND      = "";

    /* MESSAGES */
    public static final String MSG_START_MIGRATION             = "\n\n마이그레이션 작업을 시작합니다.\n" + 
                                                                  "이 작업은 완료하기까지 많은 시간이 소요될 수 있습니다. 작업이 완료될 때 까지 기다리십시오...\n";
    public static final String MSG_END_MIGRATION               = "마이그레이션 작업을 모두 완료했습니다.";
    public static final String MSG_STOPPING_MIGRATION          = "마이그레이션 작업을 종료합니다. 잠시 기다리십시오...";
    public static final String MSG_START_FILE_MIGRATION        = "\n* 파일(들)로 부터 레거시 데이터의 정보를 읽고 마이그레이션을 수행합니다...\n" + 
                                                                 "* (마이그레이션은 파일 단위로 수행됩니다.)\n"; 
    public static final String MSG_GET_FILES                   = "마이그레이션할 레거시 데이터 파일(.xls)들을 수집합니다.";
    public static final String MSG_NO_FILE_TO_MIGRATE          = "마이그레이션할 레거시 데이터 파일(*.xls)이 없습니다. 입력 경로를 확인하십시오.";
    public static final String MSG_SUB_PROC_END                = "완료: ";
    public static final String MSG_TARGET_FILE_NUM             = "마이그레이션 대상 파일 개수 = ";
    public static final String MSG_NUMBER_OF_COUNT             = "개"; 
    public static final String MSG_LOG_FILE_NOT_CREATED        = "\n로그 파일을 생성할 수 없습니다.";
    public static final String MSG_CONTINUE_WITHOUT_LOG        = "로그 파일이 없어도 마이그레이션 작업은 계속 수행됩니다.\n";
    public static final String MSG_COMMON_REASON               = "- 이유: ";
    public static final String MSG_FILE_NAME                   = "\n\n[파일: ";
    public static final String MSG_READ_DATA_FROM_FILE        = "레거시 데이터를 읽고 마이그레이션을 수행하기 위한 개체들을 구성했습니다.";
    public static final String MSG_SUB_PROC_END2               = " (완료)";
    public static final String MSG_SUB_PROC_FAILURE            = " (실패)";
    //public static final String MSG_COMMON_REASON               = "- (실패 원인): ";
    public static final String MSG_RETRY_THIS_FILE             = "- >>> 마이그레이션 작업에서 이 파일이 제외되었습니다. 문제를 수정한 후 이 파일에 대한 마이그레이션을 다시 실행하십시오.";
    public static final String MSG_END_CONVERT_DATA_WITH_ERROR = "\n데이터 변환 작업 실행이 중단되었습니다. (실패)";
    public static final String MSG_WILL_NOT_ROLL_BACK          = "- >>> (* 이미 커밋된 항목들의 정보는 Roll-back 되지 않았습니다.)";
    public static final String MSG_COMMON_WARNING              = "(Warning) ";
    public static final String MSG_BOM_NO_LEVEL                = "레벨 정보가 없는 항목을 무시했습니다. 데이터 입력 오류가 아닌지 확인하십시오.";
    public static final String MSG_EMPTY_ITEMS                 = "- >>> 변환할 항목이 없습니다.";
    public static final String MSG_PROCESSED_NUM_OF            = " 개 항목이 처리(커밋)되었습니다.";
    public static final String MSG_CREATED_NUM_OF              = " 개 생성됨";
    public static final String MSG_UPDATED_NUM_OF              = " 개 갱신됨";
    public static final String MSG_UPDATED_IGNORED_NUM_OF      = " 개 무시됨(Not Allow Update)";
    public static final String MSG_IGNORED_NUM_OF              = " 개 무시됨(Not Item)";
    public static final String MSG_ITEM_AND_BOM                = "(Item & BOM)";
    public static final String MSG_ERROR_LOCATION              = "\n- >>> 에러발생 위치: ";
    public static final String MSG_START_CONVERT_DATA          = "데이터 변환을 시작합니다...";
    public static final String MSG_END_CONVERT_DATA            = "데이터 변환을 완료했습니다. (완료)";
    public static final String MSG_NEW_ITEM_BOM_CREATED        = "새로운 Item (& BOM) 요소가 생성되었습니다.";
    public static final String MSG_ITEM_BOM_UPDATED            = "존재하는 Item (& BOM) 요소가 갱신되었습니다.";
    public static final String MSG_ITEM_BOM_NOT_UPDATED        = "Item (& BOM) 요소가 이미 존재하여 이 항목은 무시되었습니다.";
    public static final String MSG_ITEM_IGNORED                = "이 항목은 무시되었습니다. (Not Item & BOM)";
    public static final String MSG_ITEM_TNR                    = "Item TNR = ";
    public static final String MSG_SEE_LOG_FILE                = "MIGRATION 실행 결과는 아래의 로그 파일에 기록되어있습니다.";
    public static final String MSG_DOCUMENT_UPDATED            = "존재하는 Document 요소가 갱신되었습니다.";
    public static final String MSG_DOCUMENT_NOT_UPDATED        = "Document 요소가 이미 존재하여 이 항목은 무시되었습니다.";
    public static final String MSG_NEW_DOCUMENT_CREATED        = "새로운 Document 요소가 생성되었습니다.";
    public static final String MSG_DOCUMENT_TNR                = "Document TNR = ";
    public static final String MSG_DOCUMENT                    = "(Document)";
    public static final String MSG_CAD_UPDATED                 = "존재하는 CAD Drawing 요소가 갱신되었습니다.";
    public static final String MSG_CAD_NOT_UPDATED             = "CAD Drawing 요소가 이미 존재하여 이 항목은 무시되었습니다.";
    public static final String MSG_NEW_CAD_CREATED             = "새로운 CAD Drawing 요소가 생성되었습니다.";
    public static final String MSG_CAD_TNR                     = "CAD Drawing TNR = ";
    public static final String MSG_CAD_DRAWING                 = "(CAD Drawing)";
    public static final String MSG_FEATURE_CREATED             = "Feature, Feature List 요소와 관련 Relationship이 생성되었습니다.";
    public static final String MSG_FEATURE_UPDATED             = "존재하는 Feature, Feature List 요소와 관련 Relationship이 갱신되었습니다.";
    public static final String MSG_FEATURE_NOT_UPDATED         = "Feature 요소와 관련 요소 및 Relationship)가 이미 존재하여 이 항목은 무시되었습니다.";
    public static final String MSG_FEATURE_TNR                 = "Feature TNR = ";
    public static final String MSG_SUB_FEATURE_CREATED         = "(Sub) Feature, (Sub) Feature List 요소와 관련 Relationship이 생성되었습니다.";
    public static final String MSG_SUB_FEATURE_UPDATED         = "존재하는 (Sub) Feature, (Sub) Feature List 요소와 관련 Relationship이 갱신되었습니다.";
    public static final String MSG_SUB_FEATURE_NOT_UPDATED     = "(Sub) Feature 요소와 관련 요소 및 Relationship)가 이미 존재하여 이 항목은 무시되었습니다.";
    public static final String MSG_SUB_FEATURE_TNR             = "(Sub) Feature TNR = ";
    public static final String MSG_ITEM_IGNORED_GENERAL        = "이 항목은 무시되었습니다.";
    public static final String MSG_PROCESSED_NUM_OF_FEATURE    = " 개 Feature 단위 항목이 처리(커밋)되었습니다.";
    public static final String MSG_CREATED_NUM_OF_FEATURE         = " 개 Feature 단위 항목 생성됨";
    public static final String MSG_UPDATED_NUM_OF_FEATURE         = " 개 Feature 단위 항목 갱신됨";
    public static final String MSG_UPDATED_IGNORED_NUM_OF_FEATURE = " 개 Feature 단위 항목 무시됨(Not Allow Update)";
    public static final String MSG_IGNORED_NUM_OF_FEATURE         = " 개 Feature 단위 항목 무시됨";
   
    /* LOG MESSAGES */
    public static final String LOG_START_LOG               = "$ [LEGACY DATA MIGRATION 실행 로그]";
    public static final String LOG_START_SPACE_LINE        = "$ ";
    public static final String LOG_PROJECT_NAME            = "$ - (주)STX 조선 PLM 구축 프로젝트";
    public static final String LOG_START_DATETIME          = "$ START TIME                       : ";
    public static final String LOG_END_DATETIME            = "$ END TIME : ";
    public static final String LOG_INPUT_PARAM_ACCESS      = "$ ENVIRONMENT VARIABLE (ACCESS)    : ";
    public static final String LOG_INPUT_PARAM_CATEGORY    = "$ ENVIRONMENT VARIABLE (CATEGORY)  : ";
    public static final String LOG_INPUT_PARAM_FILE_SPEC   = "$ ENVIRONMENT VARIABLE (FILE_SPEC) : ";
    public static final String LOG_INPUT_PARAM_UPDATE      = "$ ENVIRONMENT VARIABLE (UPDATE)    : ";
    public static final String LOG_INPUT_PARAM_DETAIL_LOG  = "$ ENVIRONMENT VARIABLE (LOG LEVEL) : ";
    public static final String LOG_COMMON_SERVER           = "server=";
    public static final String LOG_COMMON_USER             = "user=";
    public static final String LOG_COMMON_PASSWORD         = "password=";
    public static final String LOG_COMMON_UPDATE_TRUE      = "TRUE - 이미 존재하는 요소들이 있으면 해당 요소들의 관련 속성들이 업데이트 됩니다.";
    public static final String LOG_COMMON_UPDATE_FALSE     = "FALSE - 이미 존재하는 요소들이 있으면 레거시 데이터의 관련 항목들은 무시됩니다.";
    public static final String LOG_COMMON_DETAILED_LOG     = "TRUE - 레거시 데이터의 각 항목 별 실행 결과를 로그로 기록합니다.";
    public static final String LOG_COMMON_NOT_DETAILED_LOG = "FALSE - 레거시 데이터의 각 항목 별 실행 결과는 로그에 기록되지 않습니다.";
    public static final String LOG_COMMON_CAT_BOM          = "Items & BOMs";
    public static final String LOG_COMMON_CAT_BOM_NEW      = "BOMs";
    public static final String LOG_COMMON_CAT_DOCUMENT     = "Documents";
    public static final String LOG_COMMON_CAT_DRAWING     = "CAD Drawings";
    public static final String LOG_TARGET_FILES            = "[MIGRATION 실행 대상 파일(들)]";
    public static final String LOG_START_MIGRATION         = "MIGRATION 작업을 시작합니다...";
    public static final String LOG_START_MIGRATION2        = "(마이그레이션 작업은 파일 단위로 수행됩니다.)";
    public static final String LOG_FILE_NAME               = "[파일: ";
    public static final String LOG_FEATURE_MIG_MODEL_INFO_PREFIX  = "\n+++ Model (STX) 요소 - ";
    public static final String LOG_FEATURE_MIG_MODEL_INFO_POSTFIX = " - 에 대한 Sales Template을 생성(갱신)합니다 +++";
} 