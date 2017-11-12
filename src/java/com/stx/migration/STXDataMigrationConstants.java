/**
 * <pre>
 * ������Ʈ�� : STX���� PLM ���� ������Ʈ
 * �ý��۸�   : MIGRATION (STX)
 * ����       : 1.0
 * �ۼ���     : ������
 * �ۼ�����   : 2005/06/29
 * V 1.0      : ������, 2005/06/29
 * </pre>
 * ���       : STX Migration PGM���� ���Ǵ� STX Project ���� ���� ������� ����
 * ���ó     : STX Migration PGM
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
	// 20050831 bom_new �߰�.
    public static final String STR_CATEGORY_BOM_NEW    = "bom_new"; 
    
    public static final String STR_EXCEL_SHEET_IDX     = "sheetIdx";
    public static final String STR_EXCEL_SHEET_NAME    = "sheetName";
    public static final String STR_EXCEL_ROW_IDX       = "rowIdx";

    public static final String STR_COLUMN_ITEM_LEVEL        = "LV";
    public static final String STR_COLUMN_ITEM_NAME         = "�ں�ǰ �ڵ�";
    public static final String STR_COLUMN_ITEM_FN           = "SERIAL";
    public static final String STR_COLUMN_ITEM_REVISION     = "REV NO";
    public static final String STR_COLUMN_ITEM_DESCRIPTION  = "DESCRIPTION";
    public static final String STR_COLUMN_ITEM_UOM          = "����";
    public static final String STR_COLUMN_ITEM_QTY          = "����";
    public static final String STR_COLUMN_ITEM_WEIGHT       = "�߷�";
    public static final String STR_COLUMN_ITEM_MATERIAL_CAT = "����";
    public static final String STR_COLUMN_ITEM_REL_DRAWING  = "�����ȣ";
    
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
	// 20050831 bom_new �߰�.
	public static final String STR_COLUMN_ITEM_NAME3         = "�ں�ǰ Item No";   
    public static final String STR_COLUMN_ITEM_REVISION3     = "�ں�ǰ Item Rev";
	public static final String STR_COLUMN_BOM_QTY            = "����";   

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

    public static final String STR_COLUMN_DOC_TYPE           = "��������";
    public static final String STR_COLUMN_DOC_NAME           = "������ȣ";
    public static final String STR_COLUMN_DOC_REVISION       = "������";
    public static final String STR_COLUMN_DOC_TITLE          = "����";
    public static final String STR_COLUMN_DOC_OWNER          = "�ۼ���";
    public static final String STR_COLUMN_DOC_ORIGINATOR     = "�����";
    public static final String STR_COLUMN_DOC_STATE          = "����";
    public static final String STR_COLUMN_DOC_RDGROUP        = "����ó";
    public static final String STR_COLUMN_DOC_REL_PROJECTS   = "������Ʈ";
    public static final String STR_COLUMN_DOC_REL_MODELS     = "��";
    public static final String STR_COLUMN_DOC_REL_ITEMS      = "������";
    public static final String STR_COLUMN_DOC_REL_DOCUMENTS  = "���ù���";
    public static final String STR_COLUMN_DOC_ATTACH_PATHS   = "Path,����";
    public static final String STR_COLUMN_DOC_ATTACH_FORMATS = "����";

    public static final String STR_COLUMN_CAD_TYPE           = "��������";
    public static final String STR_COLUMN_CAD_NAME           = "�����ȣ";
    public static final String STR_COLUMN_CAD_REVISION       = "������";
    public static final String STR_COLUMN_CAD_TITLE          = "�����";
    public static final String STR_COLUMN_CAD_STATE          = "����";
    public static final String STR_COLUMN_CAD_OWNER          = "�ۼ���";
    public static final String STR_COLUMN_CAD_ORIGINATOR     = "�����";
    public static final String STR_COLUMN_CAD_BASIC_RULE     = "�ۼ���Ģ";
    public static final String STR_COLUMN_CAD_CATEGORY       = "���鱸��";
    public static final String STR_COLUMN_CAD_SCALE          = "������";
    public static final String STR_COLUMN_CAD_SHEET          = "�ż�";
    public static final String STR_COLUMN_CAD_TEL            = "��ȭ��ȣ";
    public static final String STR_COLUMN_CAD_MODEL          = "��";
    public static final String STR_COLUMN_CAD_PROJECT        = "������Ʈ";
    public static final String STR_COLUMN_CAD_ITEM           = "����ITEM";
    public static final String STR_COLUMN_CAD_ITEM_REV		 = "����ITEM REV";
    public static final String STR_COLUMN_CAD_ECO            = "����ECO";
    public static final String STR_COLUMN_CAD_ECR            = "����ECR";
    public static final String STR_COLUMN_CAD_MAKER          = "����Ŀ";
    public static final String STR_COLUMN_CAD_REL_DESIGNER   = "��������";
    public static final String STR_COLUMN_CAD_ATTACH_PATHS   = "Path,����";
    public static final String STR_COLUMN_CAD_ATTACH_FORMATS = "����";
    
    public static final String STR_COLUMN_FEATURE_SEQ_NO = "No";
    public static final String STR_COLUMN_FEATURE_TYPE = "�з� Code";
    public static final String STR_COLUMN_FEATURE_GROUP_CODE = "Group Code";
    public static final String STR_COLUMN_FEATURE_GROUP = "Group";
    public static final String STR_COLUMN_FEATURE_SELECTION = "Type ����";
    public static final String STR_COLUMN_SUB_FEATURE_MARKETING_NAME = "Values TYPE";
    public static final String STR_COLUMN_SUB_FEATURE_VALUE_NAME = "Value Name";
    public static final String STR_COLUMN_SUB_FEATURE_DESCRIPTION = "��� Description";
    public static final String STR_COLUMN_SUB_FEATURE_MAKER = "Sub. Values Maker";
    public static final String STR_COLUMN_SUB_FEATURE_COUNTRY = "Sub. Values ����";
    public static final String STR_COLUMN_SUB_FEATURE_SELECTION = "Sub. Values ����";
    public static final String STR_COLUMN_SUB_FEATURE_NOTES = "�⺻����";
    public static final String STR_COLUMN_SUB_FEATURE_PEBLOCK = "P.E Block";
	///////////////////// ���� PE BLOCK �߰� BEGINS  /////////////////////////////
    public static final String STR_COLUMN_SUB_FEATURE_GUPEBLOCK = "���� P.E Block";
	///////////////////// ���� PE BLOCK �߰� BEGINS  /////////////////////////////
    
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
    
    public static final String STR_COLUMN_VAL_CHECKED = "��";
    
    public static final String[] STR_COLUMN_VAL_ESCAPES = {"-", "?"};
    
    /* ERRORS */
    public static final String ERR_INVALID_INPUT_PARAMS           = "\n���� �Ķ���Ͱ� �ùٸ��� �ʽ��ϴ�.\n\nUsage:\n" + 
                                                                     "java -Xms512m -Xmx512m migratestx <migration category> <path> <server> [user] [password] [update allowance] [detailed logging]\n" + 
                                                                     "- * <>: �ʼ� �Է� �׸�\n" + 
                                                                     "- * []: ���� �Է� �׸�\n" +
                                                                     "- <migration category>: ���̱׷��̼��� ���Ž� ������ ���� (bom | document | drawing | sales_template)\n" + 
                                                                     "- <path>: ���Ž� �����Ͱ� �����ϴ� ���� �Ǵ� ������ ������ ���. ������ ��� ���ϸ� ����\n" + 
                                                                     "- <server>: Matrix ���� ���� ��� (IP)\n" + 
                                                                     "- [<user=>user]: ����ڸ�. �����Ǵ� ��� 'creator'�� ����\n" + 
                                                                     "- [<password=>password]: ������� ���� ��й�ȣ\n" +
                                                                     "- [<allowUpdate=>update allowance]: �����Ϸ��� ��Ұ� �̹� �����ϴ� ��� �����ϴ� ����� �Ӽ� ������ ������Ʈ �� �� ����. (true | false, ����Ʈ�� false)\n" + 
                                                                     "- [<detailedLog=>detailed log]: �α����Ͽ� ��ϵǴ� �α׿� �� ��ҿ� ���� ó�� ������ ����� �� ����. (true | false, ����Ʈ�� false)\n" + 
                                                                     "- (ex) java -Xms512m -Xmx512m migratestx bom D:\\sample_data\\ localhost user=myId password=myPasswd allowUpdate=true detailedLog=true\n"; 
    public static final String ERR_INVALID_INPUT_PARAMS_FILE_SPEC = "\n���� �Ǵ� ������ �������� �ʽ��ϴ�. �Է� ��θ� Ȯ���Ͻʽÿ�.";
    public static final String ERR_INVALID_INPUT_PARAMS_CATEGORY  = ERR_INVALID_INPUT_PARAMS;
    public static final String ERR_INVALID_INPUT_PARAMS_SERVER    = "\n���� �̸� �Ǵ� ����� ������ �ùٸ��� �ʰų� ������ �� ���� �����Դϴ�.";
    public static final String ERR_DOC_ATTACH_FILE_NOT_FOUND      = "";

    /* MESSAGES */
    public static final String MSG_START_MIGRATION             = "\n\n���̱׷��̼� �۾��� �����մϴ�.\n" + 
                                                                  "�� �۾��� �Ϸ��ϱ���� ���� �ð��� �ҿ�� �� �ֽ��ϴ�. �۾��� �Ϸ�� �� ���� ��ٸ��ʽÿ�...\n";
    public static final String MSG_END_MIGRATION               = "���̱׷��̼� �۾��� ��� �Ϸ��߽��ϴ�.";
    public static final String MSG_STOPPING_MIGRATION          = "���̱׷��̼� �۾��� �����մϴ�. ��� ��ٸ��ʽÿ�...";
    public static final String MSG_START_FILE_MIGRATION        = "\n* ����(��)�� ���� ���Ž� �������� ������ �а� ���̱׷��̼��� �����մϴ�...\n" + 
                                                                 "* (���̱׷��̼��� ���� ������ ����˴ϴ�.)\n"; 
    public static final String MSG_GET_FILES                   = "���̱׷��̼��� ���Ž� ������ ����(.xls)���� �����մϴ�.";
    public static final String MSG_NO_FILE_TO_MIGRATE          = "���̱׷��̼��� ���Ž� ������ ����(*.xls)�� �����ϴ�. �Է� ��θ� Ȯ���Ͻʽÿ�.";
    public static final String MSG_SUB_PROC_END                = "�Ϸ�: ";
    public static final String MSG_TARGET_FILE_NUM             = "���̱׷��̼� ��� ���� ���� = ";
    public static final String MSG_NUMBER_OF_COUNT             = "��"; 
    public static final String MSG_LOG_FILE_NOT_CREATED        = "\n�α� ������ ������ �� �����ϴ�.";
    public static final String MSG_CONTINUE_WITHOUT_LOG        = "�α� ������ ��� ���̱׷��̼� �۾��� ��� ����˴ϴ�.\n";
    public static final String MSG_COMMON_REASON               = "- ����: ";
    public static final String MSG_FILE_NAME                   = "\n\n[����: ";
    public static final String MSG_READ_DATA_FROM_FILE        = "���Ž� �����͸� �а� ���̱׷��̼��� �����ϱ� ���� ��ü���� �����߽��ϴ�.";
    public static final String MSG_SUB_PROC_END2               = " (�Ϸ�)";
    public static final String MSG_SUB_PROC_FAILURE            = " (����)";
    //public static final String MSG_COMMON_REASON               = "- (���� ����): ";
    public static final String MSG_RETRY_THIS_FILE             = "- >>> ���̱׷��̼� �۾����� �� ������ ���ܵǾ����ϴ�. ������ ������ �� �� ���Ͽ� ���� ���̱׷��̼��� �ٽ� �����Ͻʽÿ�.";
    public static final String MSG_END_CONVERT_DATA_WITH_ERROR = "\n������ ��ȯ �۾� ������ �ߴܵǾ����ϴ�. (����)";
    public static final String MSG_WILL_NOT_ROLL_BACK          = "- >>> (* �̹� Ŀ�Ե� �׸���� ������ Roll-back ���� �ʾҽ��ϴ�.)";
    public static final String MSG_COMMON_WARNING              = "(Warning) ";
    public static final String MSG_BOM_NO_LEVEL                = "���� ������ ���� �׸��� �����߽��ϴ�. ������ �Է� ������ �ƴ��� Ȯ���Ͻʽÿ�.";
    public static final String MSG_EMPTY_ITEMS                 = "- >>> ��ȯ�� �׸��� �����ϴ�.";
    public static final String MSG_PROCESSED_NUM_OF            = " �� �׸��� ó��(Ŀ��)�Ǿ����ϴ�.";
    public static final String MSG_CREATED_NUM_OF              = " �� ������";
    public static final String MSG_UPDATED_NUM_OF              = " �� ���ŵ�";
    public static final String MSG_UPDATED_IGNORED_NUM_OF      = " �� ���õ�(Not Allow Update)";
    public static final String MSG_IGNORED_NUM_OF              = " �� ���õ�(Not Item)";
    public static final String MSG_ITEM_AND_BOM                = "(Item & BOM)";
    public static final String MSG_ERROR_LOCATION              = "\n- >>> �����߻� ��ġ: ";
    public static final String MSG_START_CONVERT_DATA          = "������ ��ȯ�� �����մϴ�...";
    public static final String MSG_END_CONVERT_DATA            = "������ ��ȯ�� �Ϸ��߽��ϴ�. (�Ϸ�)";
    public static final String MSG_NEW_ITEM_BOM_CREATED        = "���ο� Item (& BOM) ��Ұ� �����Ǿ����ϴ�.";
    public static final String MSG_ITEM_BOM_UPDATED            = "�����ϴ� Item (& BOM) ��Ұ� ���ŵǾ����ϴ�.";
    public static final String MSG_ITEM_BOM_NOT_UPDATED        = "Item (& BOM) ��Ұ� �̹� �����Ͽ� �� �׸��� ���õǾ����ϴ�.";
    public static final String MSG_ITEM_IGNORED                = "�� �׸��� ���õǾ����ϴ�. (Not Item & BOM)";
    public static final String MSG_ITEM_TNR                    = "Item TNR = ";
    public static final String MSG_SEE_LOG_FILE                = "MIGRATION ���� ����� �Ʒ��� �α� ���Ͽ� ��ϵǾ��ֽ��ϴ�.";
    public static final String MSG_DOCUMENT_UPDATED            = "�����ϴ� Document ��Ұ� ���ŵǾ����ϴ�.";
    public static final String MSG_DOCUMENT_NOT_UPDATED        = "Document ��Ұ� �̹� �����Ͽ� �� �׸��� ���õǾ����ϴ�.";
    public static final String MSG_NEW_DOCUMENT_CREATED        = "���ο� Document ��Ұ� �����Ǿ����ϴ�.";
    public static final String MSG_DOCUMENT_TNR                = "Document TNR = ";
    public static final String MSG_DOCUMENT                    = "(Document)";
    public static final String MSG_CAD_UPDATED                 = "�����ϴ� CAD Drawing ��Ұ� ���ŵǾ����ϴ�.";
    public static final String MSG_CAD_NOT_UPDATED             = "CAD Drawing ��Ұ� �̹� �����Ͽ� �� �׸��� ���õǾ����ϴ�.";
    public static final String MSG_NEW_CAD_CREATED             = "���ο� CAD Drawing ��Ұ� �����Ǿ����ϴ�.";
    public static final String MSG_CAD_TNR                     = "CAD Drawing TNR = ";
    public static final String MSG_CAD_DRAWING                 = "(CAD Drawing)";
    public static final String MSG_FEATURE_CREATED             = "Feature, Feature List ��ҿ� ���� Relationship�� �����Ǿ����ϴ�.";
    public static final String MSG_FEATURE_UPDATED             = "�����ϴ� Feature, Feature List ��ҿ� ���� Relationship�� ���ŵǾ����ϴ�.";
    public static final String MSG_FEATURE_NOT_UPDATED         = "Feature ��ҿ� ���� ��� �� Relationship)�� �̹� �����Ͽ� �� �׸��� ���õǾ����ϴ�.";
    public static final String MSG_FEATURE_TNR                 = "Feature TNR = ";
    public static final String MSG_SUB_FEATURE_CREATED         = "(Sub) Feature, (Sub) Feature List ��ҿ� ���� Relationship�� �����Ǿ����ϴ�.";
    public static final String MSG_SUB_FEATURE_UPDATED         = "�����ϴ� (Sub) Feature, (Sub) Feature List ��ҿ� ���� Relationship�� ���ŵǾ����ϴ�.";
    public static final String MSG_SUB_FEATURE_NOT_UPDATED     = "(Sub) Feature ��ҿ� ���� ��� �� Relationship)�� �̹� �����Ͽ� �� �׸��� ���õǾ����ϴ�.";
    public static final String MSG_SUB_FEATURE_TNR             = "(Sub) Feature TNR = ";
    public static final String MSG_ITEM_IGNORED_GENERAL        = "�� �׸��� ���õǾ����ϴ�.";
    public static final String MSG_PROCESSED_NUM_OF_FEATURE    = " �� Feature ���� �׸��� ó��(Ŀ��)�Ǿ����ϴ�.";
    public static final String MSG_CREATED_NUM_OF_FEATURE         = " �� Feature ���� �׸� ������";
    public static final String MSG_UPDATED_NUM_OF_FEATURE         = " �� Feature ���� �׸� ���ŵ�";
    public static final String MSG_UPDATED_IGNORED_NUM_OF_FEATURE = " �� Feature ���� �׸� ���õ�(Not Allow Update)";
    public static final String MSG_IGNORED_NUM_OF_FEATURE         = " �� Feature ���� �׸� ���õ�";
   
    /* LOG MESSAGES */
    public static final String LOG_START_LOG               = "$ [LEGACY DATA MIGRATION ���� �α�]";
    public static final String LOG_START_SPACE_LINE        = "$ ";
    public static final String LOG_PROJECT_NAME            = "$ - (��)STX ���� PLM ���� ������Ʈ";
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
    public static final String LOG_COMMON_UPDATE_TRUE      = "TRUE - �̹� �����ϴ� ��ҵ��� ������ �ش� ��ҵ��� ���� �Ӽ����� ������Ʈ �˴ϴ�.";
    public static final String LOG_COMMON_UPDATE_FALSE     = "FALSE - �̹� �����ϴ� ��ҵ��� ������ ���Ž� �������� ���� �׸���� ���õ˴ϴ�.";
    public static final String LOG_COMMON_DETAILED_LOG     = "TRUE - ���Ž� �������� �� �׸� �� ���� ����� �α׷� ����մϴ�.";
    public static final String LOG_COMMON_NOT_DETAILED_LOG = "FALSE - ���Ž� �������� �� �׸� �� ���� ����� �α׿� ��ϵ��� �ʽ��ϴ�.";
    public static final String LOG_COMMON_CAT_BOM          = "Items & BOMs";
    public static final String LOG_COMMON_CAT_BOM_NEW      = "BOMs";
    public static final String LOG_COMMON_CAT_DOCUMENT     = "Documents";
    public static final String LOG_COMMON_CAT_DRAWING     = "CAD Drawings";
    public static final String LOG_TARGET_FILES            = "[MIGRATION ���� ��� ����(��)]";
    public static final String LOG_START_MIGRATION         = "MIGRATION �۾��� �����մϴ�...";
    public static final String LOG_START_MIGRATION2        = "(���̱׷��̼� �۾��� ���� ������ ����˴ϴ�.)";
    public static final String LOG_FILE_NAME               = "[����: ";
    public static final String LOG_FEATURE_MIG_MODEL_INFO_PREFIX  = "\n+++ Model (STX) ��� - ";
    public static final String LOG_FEATURE_MIG_MODEL_INFO_POSTFIX = " - �� ���� Sales Template�� ����(����)�մϴ� +++";
} 