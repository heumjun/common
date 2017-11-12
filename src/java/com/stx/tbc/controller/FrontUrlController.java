package com.stx.tbc.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.library.RequestManager;
import com.stx.common.service.IService;
import com.stx.common.service.ServiceForward;
import com.stx.tbc.service.*;


/**
 * Servlet implementation class for Servlet: FrontUrlController
 *
 */
 public class FrontUrlController extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
    /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public FrontUrlController() {
		super();
	}   	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doProcess(request, response);
		
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doProcess(request, response);
		
	}  
	private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		response.setContentType("text/html;charset=euc-kr");
		
		String requestUri  = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command     = requestUri.substring(contextPath.length()+1);
		
		
		IService service       = null;
		ServiceForward forward = null;
		RequestBox box ;
		
		try
		{
			/* 세션 체크
			matrix.db.Context context = null;
			context = Framework.getFrameContext(request.getSession());
			System.out.println("session=>"+context.getUser());
			*/
			
			box = RequestManager.getBox(request);
			
			//Mapping Area Start ▼--------------------------------------//
			//----------------------------------------------------------//

			
			if(command.equals("tbcMain.tbc"))
			{
				service = new TbcMainService();
			}else if(command.equals("tbcItemAddExcelImportPopup.tbc"))
			{
				service = new TbcItemAddExcelImportPopupService();
				
			}else if(command.equals("tbcCableTypeMainBody.tbc"))
			{
				service = new TbcCableTypeMainBodyService();
				
			}else if(command.equals("tbcCableTypeMain.tbc"))
			{
				service = new TbcCableTypeMainService();
				
			}else if(command.equals("tbcCommonGetSeries.tbc"))
			{
				service = new TbcCommonGetSeriesService();
				
			}else if(command.equals("tbcItemAddStageMainCheck.tbc"))
			{
				service = new TbcItemAddStageMainCheckService();
				
			}else if(command.equals("tbcItemAddStageGetMother.tbc"))
			{
				service = new TbcItemAddStageGetMotherService();
				
			}else if(command.equals("tbcBuyBuyEaModify.tbc"))
			{
				service = new TbcBuyBuyEaModifyService();
				
			}else if(command.equals("tbcItemAddStageSetting.tbc"))
			{
				service = new TbcItemAddStageSettingService();
			}else if(command.equals("tbcBuyBuyEaModifyAction.tbc"))
			{		
				service = new TbcBuyBuyEaModifyActionService();
			}else if(command.equals("tbcProjectCopyAction.tbc"))
			{		
				service = new TbcProjectCopyActionService();
			}else if(command.equals("tbcProjectCopyBody.tbc"))
			{		
				service = new TbcProjectCopyBodyService();
			}else if(command.equals("tbcProjectCopy.tbc"))
			{		
				service = new TbcProjectCopyService();
			}else if(command.equals("tbcItemAddMainBack.tbc"))
			{		
				service = new TbcItemAddMainBackService();
			}else if(command.equals("tbcPendingManagerMainRestoreAction.tbc"))
			{		
				service = new TbcPendingManagerMainRestoreActionService();
			}else if(command.equals("tbcBuyBuyModifyAction.tbc"))
			{		
				service = new TbcBuyBuyModifyActionService();
			}else if(command.equals("tbcBuyBuyModifyCheck.tbc"))
			{		
				service = new TbcBuyBuyModifyCheckService();
			}else if(command.equals("tbcBuyBuyModify.tbc"))
			{
				service = new TbcBuyBuyModifyService();
			}else if(command.equals("tbcBuyBuyItemValidationAction.tbc"))
			{
				service = new TbcBuyBuyItemValidationService();
			}else if(command.equals("tbcUnitManagerBomAction.tbc"))
			{
				service = new TbcUnitManagerBomActionService();
			}else if(command.equals("tbcUnitManagerDeleteAction.tbc"))
			{
				service = new TbcUnitManagerDeleteActionService();
			}else if(command.equals("tbcUnitManagerAddAction.tbc"))
			{
				service = new TbcUnitManagerAddActionService();
			}else if(command.equals("tbcUnitManagerExcelImport.tbc"))
			{
				service = new TbcUnitManagerExcelImportService();
			}else if(command.equals("tbcUnitManagerBodyExcel.tbc"))
			{
				service = new TbcUnitManagerBodyExcelService();
			}else if(command.equals("tbcUnitManagerBody.tbc"))
			{
				service = new TbcUnitManagerBodyService();
			}else if(command.equals("tbcUnitManagerMain.tbc"))
			{
				service = new TbcUnitManagerMainService();
			}else if(command.equals("tbcBuyBuyRestoreAction.tbc"))
			{
				service = new TbcBuyBuyRestoreActionService();
			}else if(command.equals("tbcBuyBuyBomAction.tbc"))
			{
				service = new TbcBuyBuyBomActionService();
			}else if(command.equals("tbcBuyBuyDeleteAction.tbc"))
			{
				service = new TbcBuyBuyDeleteActionService();
			}else if(command.equals("tbcBuyBuySaveAction.tbc"))
			{
				service = new TbcBuyBuySaveActionService();
			}else if(command.equals("tbcBuyBuyAutoComplete.tbc"))
			{
				service = new TbcBuyBuyAutoCompleteService();
			}else if(command.equals("tbcBuyBuyBody.tbc"))
			{
				service = new TbcBuyBuyBodyService();
			}else if(command.equals("tbcItemMasterInterfaceBody.tbc"))
			{
				service = new TbcItemMasterInterfaceBodyService();
			}else if(command.equals("tbcItemMasterInterfaceAction.tbc"))
			{
				service = new TbcItemMasterInterfaceActionService();
			}else if(command.equals("tbcTBCItemMasterInterface.tbc"))
			{
				service = new TbcItemMasterInterfaceService();
			}else if(command.equals("tbcItemDiffCheckMainBody.tbc"))
			{
				service = new TbcItemDiffCheckMainBodyService();
			}else if(command.equals("tbcItemDiffCheckMain.tbc"))
			{
				service = new TbcItemDiffCheckMainService();
			}else if(command.equals("tbcPendingManagerAddWorkingExcelImport.tbc"))
			{
				service = new TbcPendingManagerAddWorkingExcelImportService();
			}else if(command.equals("tbcPendingManagerAddMainExcel.tbc"))
			{
				service = new TbcPendingManagerAddMainExcelService();
			}else if(command.equals("tbcPendingManagerAddWorkDelete.tbc"))
			{
				service = new TbcPendingManagerAddWorkDeleteService();
			}else if(command.equals("tbcPendingManagerAddGetDwgPendingExcel.tbc"))
			{
				service = new TbcPendingManagerAddGetDwgPendingExcelService();
			}else if(command.equals("tbcPendingManagerBomMainBody.tbc"))
			{
				service = new TbcPendingManagerBomMainBodyService();
			}else if(command.equals("tbcPendingManagerAddGetDwgPendingBody.tbc"))
			{
				service = new TbcPendingManagerAddGetDwgPendingBodyService();
			}else if(command.equals("tbcPendingManagerAddGetDwgPending.tbc"))
			{
				service = new TbcPendingManagerAddGetDwgPendingService();
			}else if(command.equals("tbcPendingExcelPrint.tbc"))
			{
				service = new TbcPendingManagerExcelPrintService();
			}else if(command.equals("tbcItemConfirmAction.tbc"))
			{
				service = new TbcItemConfirmActionService();
			}else if(command.equals("tbcGetTrayNoCheck.tbc"))
			{
				service = new TbcGetTrayNoCheckService();
			}else if(command.equals("tbcPendingManagerMainSaveAction.tbc"))
			{
				service = new TbcPendingManagerMainSaveActionService();
			}else if(command.equals("tbcPendingManagerBomAction.tbc"))
			{
				service = new TbcPendingManagerBomActionService();
			}else if(command.equals("tbcPendingManagerBomMain.tbc"))
			{
				service = new TbcPendingManagerBomMainService();
			}else if(command.equals("tbcPendingManagerDeleteAction.tbc"))
			{		
				service = new TbcPendingManagerDeleteActionService();
			}else if(command.equals("tbcPendingManagerMainBody.tbc"))
			{		
				service = new TbcPendingManagerMainBodyService();
			}else if(command.equals("tbcPendingManagerAddInsert.tbc"))
			{		
				service = new TbcPendingManagerAddInsertService();
			}else if(command.equals("tbcPendingManagerAddDwgnoTransferBody.tbc"))
			{		
				service = new TbcPendingManagerAddDwgnoTransferBodyService();
			}else if(command.equals("tbcPendingManagerAddGetDwgnoBody.tbc"))
			{		
				service = new TbcPendingManagerAddGetDwgnoBodyService();
			}else if(command.equals("tbcPendingManagerAddGetDwgno.tbc"))
			{		
				service = new TbcPendingManagerAddGetDwgnoService();
			}else if(command.equals("tbcPendingManagerAddTempInsert.tbc"))
			{		
				service = new TbcPendingManagerAddTempInsertService();
			}else if(command.equals("tbcPendingManagerAddMainBodyDetail2.tbc"))
			{		
				service = new TbcPendingManagerAddMainBodyDetail2Service();
			}else if(command.equals("tbcPendingManagerAddMainBodyDetail.tbc"))
			{		
				service = new TbcPendingManagerAddMainBodyDetailService();
			}else if(command.equals("tbcPendingManagerAddMainBody.tbc"))
			{		
				service = new TbcPendingManagerAddMainBodyService();
			}else if(command.equals("tbcPendingManagerAddMain.tbc"))
			{		
				service = new TbcPendingManagerAddMainService();
			}else if(command.equals("tbcPendingManagerMain.tbc"))
			{		
				service = new TbcPendingManagerMainService();
			}else if(command.equals("tbcCommonSelectBoxDataList.tbc"))
			{		
				service = new TbcCommonGetSelectBoxListService();
			}else if(command.equals("tbcCommonGetAutoCompleteList.tbc"))
			{		
				service = new TbcCommonGetAutoCompleteListService();
			}else if(command.equals("tbcMainExcelPrint.tbc"))
			{		
				service = new TbcMainExcelPrintService();  
			}else if(command.equals("tbcSaveAction.tbc"))
			{		
				service = new TbcSaveActionService();
			}else if(command.equals("tbcRestoreAction.tbc"))
			{		
				service = new TbcRestoreActionService();
			}else if(command.equals("tbcBomAction.tbc"))
			{		
				service = new TbcBomActionService();
			}else if(command.equals("tbcItemModifyAction.tbc"))
			{		
				service = new TbcItemModifyActionService();
			}else if(command.equals("tbcCommonGetRevTextBox.tbc"))
			{		
				service = new TbcCommonGetRevTextBoxService();
			}else if(command.equals("tbcCommonGetRevSelectBox.tbc"))
			{		
				service = new TbcCommonGetRevSelectBoxService();
			}
			else if(command.equals("tbcCommonGetSeriesCheckBox.tbc"))
			{		
				service = new TbcCommonGetSeriesCheckBoxService();
			} else if(command.equals("tbcItemAddManagerTransferBody.tbc"))
			{		
				service = new TbcItemAddManagerTransferBodyService();
			} else if(command.equals("tbcItemAddMainInputBody.tbc"))
			{		
				service = new TbcItemAddMainInputBodyService();
			} else if(command.equals("tbcItemAddManagerBody.tbc"))
			{		
				service = new TbcItemAddManagerBodyService();
			} else if(command.equals("tbcItemAddManager.tbc"))
			{		
				service = new TbcItemAddManagerService();
			}else if(command.equals("tbcDeleteAction.tbc"))
			{		
				service = new TbcItemDeleteActionService();
			} else if(command.equals("tbcModifyCheck.tbc"))
			{		
				service = new TbcItemModifyCheckService();
			} else if(command.equals("tbcDeleteCheck.tbc"))
			{		
				service = new TbcItemDeleteCheckService();
			} else if(command.equals("tbcItemAddMainCheck.tbc"))
			{		
				service = new TbcItemAddMainCheckService();
			} else if(command.equals("tbcItemAddMainInsert.tbc"))
			{		
				service = new TbcItemAddMainInsertService();
			} else if(command.equals("tbcItemAddMainDelete.tbc"))
			{		
				service = new TbcItemAddMainDeleteService();
			} else if(command.equals("tbcMainBody.tbc"))
			{		
				service = new TbcMainBodyService();
			} else if(command.equals("tbcItemAdd.tbc"))
			{		
				service = new TbcItemAddService();
			} else if(command.equals("tbcItemAddExcelImport.tbc"))
			{		
				service = new TbcItemAddExcelImportService();
			} else if(command.equals("tbcBom.tbc"))
			{		
				service = new TbcBomService();
			} else if(command.equals("tbcItemDelete.tbc"))
			{		
				service = new TbcItemDeleteService();
			} else if(command.equals("tbcItemModify.tbc"))
			{		
				service = new TbcItemModifyService();
			} else if(command.equals("tbcAfterInf.tbc"))
			{		
				service = new TbcAfterInfService();
			}
			else if(command.equals("tbcAfterInfoMainPopup.tbc"))
			{		
				service = new TbcAfterInfoMainService();
				
			}
			else if(command.equals("tbcAfterInfoSscBody.tbc"))
			{		
				service = new TbcAfterInfoSscBodyService();
				
			}
			else if(command.equals("tbcAfterInfoPRBody.tbc"))
			{		
				service = new TbcAfterInfoPRBodyService();
				
			}
			else if(command.equals("tbcAfterInfoORBody.tbc"))
			{		
				service = new TbcAfterInfoORBodyService();
			}
			else if(command.equals("tbcDwgMain.tbc"))
			{
				//?p_daoName=TBC_DWG&p_queryType=select&p_process=list
				service = new TbcDwgMainService();
			}
			else if(command.equals("tbcDwgUserList.tbc"))
			{
				//?p_daoName=TBC_DWG&p_queryType=select&p_process=list
				service = new TbcDwgUserListService();
			}
			else if(command.equals("dwgSearchList.tbc"))
			{
				service = new TbcDwgMainListService(); 
			}
			else if(command.equals("tbcDwgInformation.tbc"))
			{
				service = new TbcDwgInformationService(); 
			}
			else if(command.equals("tbcDwgMailReceiver.tbc"))
			{
				service = new TbcDwgMailReceiverService(); 
			}
			else if(command.equals("tbcDwgInformationList.tbc"))
			{
				service = new TbcDwgInformationListService();  
			}
			else if(command.equals("tbcDwgPopupView.tbc"))
			{
				service = new TbcDwgPopupViewService();  
			}
			else if(command.equals("tbcDwgPopupViewList.tbc"))
			{
				service = new TbcDwgPopupViewListService();  
			}
			else if(command.equals("tbcDwgComplete.tbc"))
			{
				service = new TbcDwgCompleteService();  
			}
			else if(command.equals("tbcDwgCompleteList.tbc"))
			{
				service = new TbcDwgCompleteListService();  
			}
			else if(command.equals("tbcItemTrans.tbc"))
			{
				service = new TbcItemTransService();  
			}
			else if(command.equals("tbcItemTransUpload.tbc"))
			{
				service = new TbcItemTransUploadService();  
			}
			else if(command.equals("tbcItemTransDownload.tbc"))
			{
				service = new TbcItemTransDownloadService();  
			}
			else if(command.equals("tbcItemTransExcelPrint.tbc"))
			{		
				service = new TbcItemTransExcelPrintService();  
			}
		
			
			
			
			//----------------------------------------------------------//
			//Mapping Area End ▲----------------------------------------//
			forward = service.execute(request, response, box);
			
			request.setAttribute("requestbox", box);
			
			if(forward.isForward()&& forward.isRedirect()){
				response.sendRedirect(forward.getPath());
			}
			else if(forward.isForward()&& !forward.isRedirect())
			{
				RequestDispatcher rd = request.getRequestDispatcher(forward.getPath());
				rd.forward(request, response);
			}
		}
		catch(Exception ex)
		{
			
			ex.printStackTrace();
		}
		
	}
}
