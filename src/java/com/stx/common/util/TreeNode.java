package com.stx.common.util;

import java.util.LinkedList;
import java.util.HashMap;
import java.util.Random;

public class TreeNode {


	private String name = "";
	private int depth = 0;
	private String linkedURL = "";
	private String linkTarget;
	private int[] branchCodes;
	private LinkedList childNodes = new LinkedList();
	private HashMap attribute = new HashMap();
	private String uniqueKey = "ID";
	private String nodeType = "default";
	private boolean isInitFolded = true;


	private TreeNode parentNode = null;

	public TreeNode() {
		//generateUniqueKey();
	}

	public TreeNode(String name) {
		this.name = name;
		generateUniqueKey();
	}   

	public TreeNode(String uniqueKey, String name) {
		this.name = name;
		this.uniqueKey = uniqueKey ;
	}   

	private void generateUniqueKey() {
        Random random = new Random((new java.util.Date()).getTime());
		uniqueKey = "id"+random.nextInt(100000);
	}
	public String getUniqueKey() { return uniqueKey; }


	public void setName(String name) {
		this.name = name;
	}
	public String getName() { return name; }


	public void setDepth(int depth) {
		this.depth = depth;
		for(int i=0;i<childNodes.size();i++) {
			((TreeNode)childNodes.get(i)).setDepth(depth+1);
		}
	}
	public int getDepth() { return depth; }


	public void setParentNode(TreeNode parentNode) {
		this.parentNode = parentNode;
	}
	public TreeNode getParentNode() { return parentNode; }


	public void setLinkedURL(String linkedURL) {
		this.linkedURL = linkedURL;
	}
	public String getLinkedURL() { return linkedURL; }


	public void setLinkTarget(String linkTarget) {
		this.linkTarget = linkTarget;
	}
	public String getLinkTarget() { return linkTarget; }


	public void setNodeType(String nodeType) {
		this.nodeType = nodeType;
	}
	public String getNodeType() { return nodeType; }


	public void setIsInitFolded(boolean isInitFolded) {
		this.isInitFolded = isInitFolded;
	}
	public boolean isInitFolded() { return isInitFolded; }


	public void addChildNode(TreeNode node) {
		node.setDepth(depth+1);
		node.setParentNode(this);
		childNodes.addLast(node);
	}
	public LinkedList getChildNodes() { return childNodes; }


	public void setAttribute(String name, String value) {
		attribute.put(name,value);
	}
	public String getAttribute(String name) {
		return (String)attribute.get(name);
	}


	public void setBranchCodes(int[] branchCodes) {
		int c=0;
		while(branchCodes[c]>=0) {
			c++;
		}
		this.branchCodes = new int[c];
		for(int i=0;i<c;i++) {
			this.branchCodes[i] = branchCodes[i];
		}
	}
	public int[] getBranchCodes() { return branchCodes; }


	public LinkedList getNodesList() {
		LinkedList nodes = new LinkedList();
		nodes.addLast(this);
		for(int i=0;i<childNodes.size();i++) {
			addLast(nodes,((TreeNode)childNodes.get(i)).getNodesList());
		}
		return nodes;	
	}

	private LinkedList addLast(LinkedList to, LinkedList from) {
		for(int i=0;i<from.size();i++) {
			to.addLast(from.get(i));
		}
		return to;
	}


	public String getFullName() {

		String fullName = "";

		if(parentNode!=null) {
			fullName = parentNode.getFullName();
		}

		if(!fullName.equals("")) { fullName += " "+name; }
		else { fullName = name; }

		return fullName;

	}

	
	public String getReplacedFullName() {
		String fullName = getFullName();
		fullName = replace(fullName," ","_");
		fullName = replace(fullName,".","D");
		fullName = replace(fullName,"!","1");
/*
		fullName = replace(fullName,"@","2");
		fullName = replace(fullName,"#","3");
		fullName = replace(fullName,"$","4");
		fullName = replace(fullName,"%","5");
		fullName = replace(fullName,"^","6");
		fullName = replace(fullName,"&","7");
		fullName = replace(fullName,"*","8");
		fullName = replace(fullName,"(","9");
		fullName = replace(fullName,")","_");
		fullName = replace(fullName,"!","_");
		fullName = replace(fullName,"`","_");
		fullName = replace(fullName,"~","_");
		fullName = replace(fullName,"<","_");
		fullName = replace(fullName,">","_");
		fullName = replace(fullName,"?","_");
		fullName = replace(fullName,",","_");
		fullName = replace(fullName,".","_");
		fullName = replace(fullName,"/","_");
*/
		return fullName;
	}


	public boolean hasChild() {
		if(childNodes.size()>0) { return true; }
		else { return false; }
	}
	

	public TreeNode getRootParent() {
		if(parentNode==null) { return this; }
		else { return parentNode.getRootParent(); }
	}

	public String toString() {
		String toString = "";
		for(int i=0;i<depth;i++) { toString += " "; }
		toString += name+"\n";
		for(int i=0;i<childNodes.size();i++) {
			toString += ((TreeNode)childNodes.get(i)).toString();
		}
		return toString;
	}



	public static String replace(String src, String from, String to) {

		StringBuffer dest = null;

		try {

			if (src == null) return null;

			dest = new StringBuffer("");
			int  length = from.length();
			int  srcLength = src.length();
			int  index = 0;
			int  oldIndex = 0;

			while ((index = src.indexOf(from, oldIndex)) >= 0) {
				dest.append(src.substring(oldIndex, index));
				dest.append(to);
				oldIndex = index + length;
			}
			if (oldIndex < srcLength) { dest.append(src.substring(oldIndex, srcLength)); }

		} catch (Exception e) {
			return src;
		}
		
		return dest.toString();
	
	}

	
}
