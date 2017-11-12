package com.stx.tbc.dao.factory;

import com.stx.tbc.dao.*;

public class DaoCreator extends FactoryDAO{

	protected Idao createDao(String daoName) 
	{
		// TODO Auto-generated method stub
		

		if(daoName.equals("TBC_MAIN")){
			return new TbcMainDao();
		}else if(daoName.equals("TBC_CABLETYPEDAO")){
			return new TbcCableTypeDao();
		}else if(daoName.equals("TBC_PROJECTCOPYDAO")){
			return new TbcProjectCopyDao();
		}else if(daoName.equals("TBC_PENDINGMANAGERRESTOREDAO")){
			return new TbcPendingManagerRestoreDao();
		}else if(daoName.equals("TBC_UNITMANAGERDAO")){
			return new TbcUnitManagerDao();
		}else if(daoName.equals("TBC_BUYBUYDAO")){
			return new TbcBuyBuyDao();
		}else if(daoName.equals("TBC_ITEMDIFFCHECKDAO")){
			return new TbcItemDiffCheckDao();
		}else if(daoName.equals("TBC_ITEMMASTERINTERFACEDAO")){
			return new TbcItemMasterInterfaceDao();
		}else if(daoName.equals("TBC_CONFIRMDAO")){
			return new TbcConfirmDao();
		}else if(daoName.equals("TBC_PENDINGMANAGERBOMDAO")){
			return new TbcPendingManagerBomDao();
		}else if(daoName.equals("TBC_PENDINGMANAGERDELETEDAO")){
			return new TbcPendingManagerDeleteDao();
		}else if(daoName.equals("TBC_PENDINGMANAGERMAINDAO")){
			return new TbcPendingManagerMainDao();
		}else if(daoName.equals("TBC_PENDINGMANAGERADDDAO")){
			return new TbcPendingManagerAddDao();
		}else if(daoName.equals("TBC_SAVEDAO")){
			return new TbcSaveDao();
		}else if(daoName.equals("TBC_RESTOREDAO")){
			return new TbcRestoreDao();
		}else if(daoName.equals("TBC_COMMONDAO")){
			return new TbcCommonDao();
		}else if(daoName.equals("TBC_BOMDAO")){
			return new TbcBomDao();
		}else if(daoName.equals("TBC_ITEMDELETEDAO")){
			return new TbcItemDeleteDao();
		}else if(daoName.equals("TBCITEMMODIFYDAO")){
			return new TbcItemModifyDao();
		}else if(daoName.equals("TBC_ITEMADDEXCEL")){
			return new TbcItemExcelDao();
		}else if(daoName.equals("TBC_VA_ITEMADD")){
			return new Tbc_VA_ItemAddDao();
		}else if(daoName.equals("TBC_TR_ITEMADD")){
			return new Tbc_TR_ItemAddDao();
		}else if(daoName.equals("TBC_PI_ITEMADD")){
			return new Tbc_PI_ItemAddDao();
		}else if(daoName.equals("TBC_CA_ITEMADD")){
			return new Tbc_CA_ItemAddDao();
		}else if(daoName.equals("TBC_SU_ITEMADD")){
			return new Tbc_SU_ItemAddDao();
		}else if(daoName.equals("TBC_GE_ITEMADD")){
			return new Tbc_GE_ItemAddDao();
		}else if(daoName.equals("TBC_OU_ITEMADD")){
			return new Tbc_OU_ItemAddDao();
		}else if(daoName.equals("TBC_SE_ITEMADD")){
			return new Tbc_SE_ItemAddDao();
		}else if(daoName.equals("TBC_Test")){
			return new TbcTestDao();
		}else if(daoName.equals("TBC_AFTERINFO")){
			return new TbcAfterInfoDao();
		}else if(daoName.equals("TBC_DWG")){
			return new TbcDwgDao(); 
		}else if(daoName.equals("TBC_DWGMAIN")){
			return new TbcDwgMainDao(); 
		}else if(daoName.equals("TBC_DWGINFORMATION")){
			return new TbcDwgInformationDao();    
		}else if(daoName.equals("TBC_DWGPOPUPVIEW")){
			return new TbcDwgPopUpViewDao();     
		}else if(daoName.equals("TBC_DWGCOMPLETE")){
			return new TbcDwgCompleteDao();      
		}else if(daoName.equals("TBC_DWGMAILRECEIVER")){
			return new TbcDwgMailReceiverDao();      
		}else if(daoName.equals("TBC_BUYBUYMODIFY")){
			return new TbcBuyBuyModifyDao();      
		}else if(daoName.equals("TBC_ITEMTRANS")){
			return new TbcItemTransDao(); 
		}
		else {
			return null;
		}
	}
}

