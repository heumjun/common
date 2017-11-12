package com.stx.common.util;

import java.util.LinkedList;
import java.util.HashMap;

public class TreeDraw {

	public final static int BRANCH0 = 0;
	public final static int BRANCH1 = 1;
	public final static int BRANCH2 = 2;
	public final static int BRANCH3 = 3;
	public final static int FOLDED_ICON = 4;
	public final static int UNFOLDED_ICON = 5;
	public final static int NODE_ICON = 6;
	String[] branchImages = { "branch_0.gif", "branch_1.gif", "branch_2.gif", "branch_3.gif", "icon_folded.png", "icon_unfolded.png", "icon_default.png" };
	public String imagePath = "";

	public String decorationHead = "";
	public String decorationTail = "";
	public String goFunctionName = "go";

	private boolean isUseIcon = true;
	private boolean isUseBranch = false;

	protected boolean isDecoratable(TreeNode node) {
		if (node.hasChild()) {
			return true;
		} else {
			return false;
		}
	}

	protected boolean isFoldable(TreeNode node) {
		return true;
	}

	/**
	 * 링크에 사용될 url을 반환합니다. 본 예제에서는 linkURL이란 속성값을 사용하고, 만약 그 값이 없으면 메뉴노드를 접기/펼치기를 토글하도록 합니다. 이 외에 jsp 화일에서 node.setAttribute() 메소드를 적당히 사요한다면 여기세어 그 값을 가지고서 적당한 url을 만들 수 있습니다. 물론 javascript function
	 * 컬도 가능하지요.
	 */
	protected String getLinkedURL(TreeNode node) {
		String url = "";
		url = (String) node.getAttribute("linkURL");
		if (url == null) {
			url = getToggleUrl(node);
		}
		return url;
	}

	HashMap iconImageMap = new HashMap();
	{
		iconImageMap.put("default", "icon_default.png");
		iconImageMap.put("folded", "icon_folded.png");
		iconImageMap.put("unfolded", "icon_unfolded.png");
	}

	public final static String DEFAULT_ICON_IMAGE = "icon_default.png";

	public void setImagePath(String imagePath) {
		if (!imagePath.endsWith("/")) {
			imagePath = imagePath + "/";
		}
		this.imagePath = imagePath;
	}

	public void setDecorationHead(String decorationHead) {
		this.decorationHead = decorationHead;
	}

	public String getDecorationHead() {
		return decorationHead;
	}

	public void setDecorationTail(String decorationTail) {
		this.decorationTail = decorationTail;
	}

	public String getDecorationTail() {
		return decorationTail;
	}

	public void setIconImage(String objectName, String imageFileName) {
		iconImageMap.put(objectName, imageFileName);
	}

	public void setGoFunctionName(String goFunctionName) {
		this.goFunctionName = goFunctionName;
	}

	public String getActoinFunctionName() {
		return goFunctionName;
	}

	public void setUseIcon(boolean isUseIcon) {
		this.isUseIcon = isUseIcon;
	}

	public boolean isUseIcon() {
		return isUseIcon;
	}

	public void setUseBranch(boolean isUseBranch) {
		this.isUseBranch = isUseBranch;
	}

	public boolean isUseBranch() {
		return isUseBranch();
	}

	public String getDesignedHtml(TreeNode rootNode) {
		String html = "";
		if (rootNode.getName().equals("")) { // if root node has not name, skip root
			rootNode.setDepth(-1);
		}
		setBranchCodes(rootNode);
		html = getHtml(rootNode);
		return html;
	}

	private String getHtml(TreeNode node) {

		String html = "";

		if (node.getDepth() >= 0) {
			html += getHtml(node.getUniqueKey(), node.getName(), getBranchHtml(node), getIconHtml(node), getLinkedURL(node), getLinkTarget(node), getDecorationHead(node), getDecorationTail(node),
					getToggleUrl(node));
		}
		LinkedList childNodes = node.getChildNodes();

		if (!node.getFullName().equals("") && isFoldable(node) && node.hasChild()) {
			String folded = "block";
			if (node.isInitFolded()) {
				folded = "none";
			}
			html += "<SPAN ID=\"" + node.getUniqueKey() + "\" style=\"display:" + folded + ";\">\n";
			// html += "<SPAN ID=\""+node.getUniqueKey()+node.getReplacedFullName()+"\" style=\"display:"+folded+"; margin-left:0px\">\n";
		}

		for (int i = 0; i < childNodes.size(); i++) {
			html += getHtml((TreeNode) childNodes.get(i));
		}

		if (!node.getFullName().equals("") && isFoldable(node) && node.hasChild()) {
			html += "</SPAN>\n";
		}

		return html;

	}

	private String getHtml(String UniqueKey, String name, String branchHtml, String iconHtml, String linkedURL, String linkTarget, String decorationHead, String decorationTail, String toggleURL) {

		String html = "";

		html += decorationHead + name + decorationTail;
		String targetHtml = "";
		if (!linkTarget.equals("")) {
			targetHtml = " target=\"" + linkTarget + "\"";
		}

		if (!linkedURL.equals("")) {
			html = "<a href=\"" + linkedURL + "\"" + targetHtml + " style=\"font-family: 'dotum'; font-size: 12px; color: #000;\">" + "&nbsp;" + html + " </a>";
		} else {
			html = "<a href=\"" + toggleURL + "\" style=\"font-family: 'dotum'; font-size: 12px; color: #000;\">" + "&nbsp;" + html + " </a>";
		}
		html = branchHtml + iconHtml + html;

		html += "<SPAN ID=\"" + "P_" + UniqueKey + "\" ></SPAN><br>\n";

		return html;
		//

	}

	protected String getBranchHtml(TreeNode node) {

		String html = "";
		int[] branchCodes = node.getBranchCodes();
		for (int i = 0; i < branchCodes.length - 1; i++) { // value of branchCodes[length-1] is icon code
			if (!isUseBranch) {
				html += "&nbsp;";
			} else {
				html += getBranchImageHtml(branchCodes[i]);
			}
		}

		return html;
	}

	protected String getIconHtml(TreeNode node) {

		if (!isUseIcon) {
			return "";
		}

		String html = "";
		int[] branchCodes = node.getBranchCodes();
		String iconCode = branchCodes[branchCodes.length - 1] + "";
		if (iconCode.equals(NODE_ICON + "")) {
			iconCode = node.getNodeType();
		} else if (iconCode.equals(FOLDED_ICON + "")) {
			iconCode = "folded";
		} else if (iconCode.equals(UNFOLDED_ICON + "")) {
			iconCode = "unfloded";
		}

		if (node.hasChild()) {
			html += "<a href=\"" + getFoldScript(node) + "\">" + getIconImageHtml(iconCode, (node.getUniqueKey())) + "</a>";
		} else {
			html += getIconImageHtml(iconCode);
		}

		return html;
	}

	private String getBranchImageHtml(int branchCode) {
		return getImageHtml(branchImages[branchCode], "");
	}

	private String getIconImageHtml(String iconCode) {
		return getIconImageHtml(iconCode, "");
	}

	private String getIconImageHtml(String iconCode, String imageTagId) {
		String iconImageFile = (String) iconImageMap.get(iconCode);
		if (iconImageFile == null) {
			iconImageFile = DEFAULT_ICON_IMAGE;
		}
		return getImageHtml(iconImageFile, imageTagId);
	}

	private String getImageHtml(String imageFileName, String imageTagId) {

		String id = "";
		if ((imageTagId != null) && (!imageTagId.equals(""))) {
			id = " id=\"img_" + imageTagId + "\"";
		}
		
		return "<img align='absmiddle' src='" + imagePath + imageFileName + "'" + id + " border=0 style=\"padding: 5px;\">";
		
	}

	protected String getToggleUrl(TreeNode node) {
		return getFoldScript(node);
	}

	protected String getFoldScript(TreeNode node) {
		String html = "";
		if (isFoldable(node)) {
			html = "javascript:toggle('" + getToggleKey(node) + "')";
		}
		return html;
	}

	protected String getToggleKey(TreeNode node) {
		return node.getUniqueKey();
		// return node.getUniqueKey()+node.getReplacedFullName();
	}

	protected String getDecorationHead(TreeNode node) {

		String html = "";
		if (isDecoratable(node)) {
			html = decorationHead;
		}

		return html;
	}

	protected String getDecorationTail(TreeNode node) {
		String html = "";
		if (isDecoratable(node)) {
			html = decorationTail;
		}
		return html;
	}

	private void setBranchCodes(TreeNode node) {

		LinkedList nodes = node.getNodesList();
		int[] branchCodes = new int[100];
		for (int i = 0; i < branchCodes.length; i++) {
			branchCodes[i] = -1;
		}

		int depth = -1;
		int lastDepth = -1;

		for (int i = nodes.size() - 1; i >= 0; i--) {

			lastDepth = depth;

			TreeNode currentNode = (TreeNode) nodes.get(i);
			depth = currentNode.getDepth();
			if (i == nodes.size() - 1) { // the node is the last. so newly set branchCode
				for (int j = 0; j < depth - 1; j++) {
					branchCodes[j] = BRANCH0;
				}
				try {
					branchCodes[depth - 1] = BRANCH2;
				} catch (ArrayIndexOutOfBoundsException e) {
				}
				branchCodes[depth] = NODE_ICON;
				currentNode.setBranchCodes(branchCodes);
				continue;
			}

			// for branchCode == depth+1
			branchCodes[depth + 1] = -1;

			if (depth < 0) {
				continue;
			}
			// for branchCode == depth
			try {
				if (depth > lastDepth) {
					branchCodes[depth] = NODE_ICON;
				} else if (depth < lastDepth) {
					branchCodes[depth] = FOLDED_ICON;
				} else {
					branchCodes[depth] = NODE_ICON;
				}
			} catch (ArrayIndexOutOfBoundsException e) {
			}

			// for branchCode == depth-1
			try {
				if (depth > lastDepth) {
					branchCodes[depth - 1] = BRANCH2;
				} else if (depth < lastDepth) {
					if (branchCodes[depth - 1] == BRANCH1) {
						branchCodes[depth - 1] = BRANCH3;
					} else {
						branchCodes[depth - 1] = BRANCH2;
					}
				} else {
					branchCodes[depth - 1] = BRANCH3;
				}
			} catch (ArrayIndexOutOfBoundsException e) {
			}

			for (int j = depth - 2; j >= 0; j--) {
				if ((branchCodes[j] == BRANCH1) || (branchCodes[j] == BRANCH2) || (branchCodes[j] == BRANCH3)) {
					branchCodes[j] = BRANCH1;
				} else {
					branchCodes[j] = BRANCH0;
				}
			}

			currentNode.setBranchCodes(branchCodes);

		}

	}

	protected String getLinkTarget(TreeNode node) {

		String target = node.getLinkTarget();
		if (target == null) {
			target = node.getRootParent().getLinkTarget();
		}

		if (target == null) {
			target = "";
		}

		return target;

	}

	public static String getJavascript() {

		String html = "";

		html += "<script language=\"javascript\">\n";

		html += "\n";
		html += "	function toggle(currentMenu) {\n";
		html += "		if(eval(\"document.all.\"+currentMenu+\"!=null\")) {\n";
		html += "			spanBlockStyle = eval(\"document.all.\" + currentMenu + \".style\");\n";
		html += "			if (spanBlockStyle.display == \"block\") {\n";
		html += "				if(eval(\"document.all.img_\"+currentMenu+\"!=null\")) {\n";
		html += "					imageObject = eval(\"document.all.img_\" + currentMenu);\n";
		html += "					imageObject.src = replace(imageObject.src,\"icon_unfolded.png\",\"icon_folded.png\");\n";
		html += "				}\n";
		html += "				spanBlockStyle.display = \"none\";\n";
		html += "			}\n";
		html += "			else if (spanBlockStyle.display == \"none\") {\n";
		html += "				if(eval(\"document.all.img_\"+currentMenu+\"!=null\")) {\n";
		html += "					imageObject = eval(\"document.all.img_\" + currentMenu);\n";
		html += "					imageObject.src = replace(imageObject.src,\"icon_folded.png\",\"icon_unfolded.png\");\n";
		html += "				}\n";
		html += "				spanBlockStyle.display = \"block\";\n";
		html += "			}\n";
		html += "		}\n";
		html += "	}\n";
		html += "\n";

		html += "	function toggleAndGo(currentMenu) {\n";
		html += "		toggle(currentMenu);\n";
		html += "		go(currentMenu);\n";
		html += "	}\n";
		html += "\n";

		html += "	function replace(source,from,to) {\n";
		html += "		var result = '';\n";
		html += "		var index0 = source.indexOf(from);\n";
		html += "		while(index0>0) {\n";
		html += "			source = source.substring(0,index0) + to + source.substring(index0+from.length+1);\n";
		html += "			index0 = source.indexOf(from);\n";
		html += "		}\n";
		html += "		return source;\n";
		html += "	}\n";
		html += "\n";

		html += "</script>\n";

		return html;
	}

}
