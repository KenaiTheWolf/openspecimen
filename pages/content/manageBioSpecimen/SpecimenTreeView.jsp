<html>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/nlevelcombo.tld" prefix="ncombo" %>
<%@ page import="java.util.*"%>
<%@ page import="edu.wustl.common.beans.NameValueBean"%>
<%@ page import="edu.wustl.common.tree.QueryTreeNodeData"%>
<%@ page import="edu.wustl.catissuecore.util.global.Constants"%>

<%
		String participantId=(String)request.getAttribute(Constants.CP_SEARCH_PARTICIPANT_ID);
		String cpId=(String)request.getAttribute(Constants.CP_SEARCH_CP_ID);
		String access = null;
		access = (String)session.getAttribute("Access");
		String divHeight = "200";
		if(access != null && access.equals("Denied"))
		{
			divHeight = "280";		
		}

%>
<head>
	<link rel="stylesheet" type="text/css" href="css/styleSheet.css" />
	<title>DHTML Tree samples. dhtmlXTree - Action handlers</title>
	<link rel="STYLESHEET" type="text/css" href="dhtml_comp/css/dhtmlXTree.css">
	<script language="JavaScript" type="text/javascript" src="dhtml_comp/js/dhtmXTreeCommon.js"></script>
	<script language="JavaScript" type="text/javascript" src="dhtml_comp/js/dhtmlXTree.js"></script>
	<script language="JavaScript" type="text/javascript" src="jss/javaScript.js"></script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0">
		<tr>	
			<td class="formLabelAllBorder" colspan="2" width="161">
				<b>Specimen Details :</b>
			</td>
		</tr>	
		<tr>
			<td align="left" colspan="2">
				<div id="treeboxbox_tree" style="width:166; height:<%=divHeight%>;background-color:#f5f5f5;border :1px solid Silver;; overflow:auto;"/>
			</td>
			
		</tr>
		<tr>
			<td colspan="2">
		
			<input type="hidden" name="participantId" value="<%=participantId%>"/>
			<input type="hidden" name="cpId" value="<%=cpId%>"/>
			</td>
	</tr>		
	</table>

	<script language="javascript">
			//This function is called when any of the node is selected in tree 
			function tonclick(id)
			{
				var index = id.indexOf(":");
				var isFuture = "";
				if(index != -1)
				{
					isFuture = id.substring(index+1);
					var str = id.substring(0,index);
				}
				else
				{
				var str = id;
				}
				var name = tree.getItemText(id);
				var i = str.indexOf('_');
				var obj1 = str.substring(0,i);
				var id1 = str.substring(i+1);
				if(obj1 == "<%=Constants.SPECIMEN_COLLECTION_GROUP%>")
				{
					<%if(access != null && access.equals("Denied"))
					{%>
					window.parent.frames[2].location = "CPQuerySpecimenCollectionGroupForTech.do?pageOf=pageOfSpecimenCollectionGroupCPQuery&operation=edit&id="+id1+"&name="+name;
					<%}else {%>
					if(isFuture != "")
					{
					/**
					 * Patch Id : FutureSCG_19
					 * Description : collectionPointLabel attribute added
	 				 */
					var ind = isFuture.indexOf(":");
					var eventId = isFuture.substring(0,ind);
					window.parent.frames[2].location = "QuerySpecimenCollectionGroupSearch.do?pageOf=pageOfSpecimenCollectionGroupAdd&operation=add&id="+id1+"&<%=Constants.CP_SEARCH_PARTICIPANT_ID%>="+<%=participantId%>+"&<%=Constants.CP_SEARCH_CP_ID%>="+<%=cpId%>+"&<%=Constants.QUERY_RESULTS_COLLECTION_PROTOCOL_EVENT_ID%>="+eventId;
					}else
					{
						window.parent.frames[2].location = "QuerySpecimenCollectionGroupSearch.do?pageOf=pageOfSpecimenCollectionGroupCPQueryEdit&operation=edit&id="+id1+"&<%=Constants.CP_SEARCH_PARTICIPANT_ID%>="+<%=participantId%>+"&<%=Constants.CP_SEARCH_CP_ID%>="+<%=cpId%>;
					}
					<%}%>
				}
				else
				{
					window.parent.frames[2].location = "QuerySpecimenSearch.do?pageOf=pageOfNewSpecimenCPQuery&operation=edit&id="+id1+"&<%=Constants.CP_SEARCH_PARTICIPANT_ID%>="+<%=participantId%>+"&<%=Constants.CP_SEARCH_CP_ID%>="+<%=cpId%>;
				}
			};
									
			// Creating the tree object								
			tree=new dhtmlXTreeObject("treeboxbox_tree","100%","100%",0);
			tree.setImagePath("dhtml_comp/imgs/");
			tree.setOnClickHandler(tonclick);
			<%-- in this tree for root node parent node id is "0" --%>
			<%-- creating the nodes of the tree --%>
			<% Vector treeData = (Vector)request.getAttribute("treeData");
				if(treeData != null && treeData.size() != 0)
				{
					Iterator itr  = treeData.iterator();
					while(itr.hasNext())
					{
						QueryTreeNodeData data = (QueryTreeNodeData) itr.next();
						String tooltipText = data.getToolTipText();
						String parentId = "0";	
						String id = data.getIdentifier().toString();
						if(!data.getParentIdentifier().equals("0"))
						{
							parentId = data.getParentObjectName() + "_"+ data.getParentIdentifier().toString();
		
						}
						String nodeId = data.getObjectName() + "_"+id;
						String img = "Specimen.GIF";
						if(data.getObjectName().equals(Constants.SPECIMEN_COLLECTION_GROUP))
						{
							int index = id.indexOf(":");
							if(index != -1)
							{
								img = "SpecimenCollectionGroupFuture.GIF";
							}
							else
							{
								img = "SpecimenCollectionGroup.GIF";
							}
						}
			%>
					tree.insertNewChild("<%=parentId%>","<%=nodeId%>","<%=data.getDisplayName()%>",0,"<%=img%>","<%=img%>","<%=img%>","");
					tree.setUserData("<%=nodeId%>","<%=nodeId%>","<%=data%>");	
					tree.setItemText("<%=nodeId%>","<%=data.getDisplayName()%>","<%=data.getDisplayName()%>");
			<%	
					}
				}

			%>
			tree.closeAllItems("0");
			<%if(request.getParameter("nodeId") != null)
			{
				String nodeId = request.getParameter("nodeId");
				
			%>
			<%-- opening and selecting the node which is selected by user --%>
			var parentId = tree.getParentId("<%=nodeId%>");
			tree.openItem(parentId);
			tree.selectItem("<%=nodeId%>",false);
			tree.openItem("<%=nodeId%>");
			
			<%}%>	
	</script>


</body>

</html>