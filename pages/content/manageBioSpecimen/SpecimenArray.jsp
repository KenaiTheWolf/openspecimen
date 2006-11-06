<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/nlevelcombo.tld" prefix="ncombo" %>

<%@ page import="edu.wustl.catissuecore.util.global.Constants"%>
<%@ page import="java.util.Map,java.util.List"%>
<%@ page import="edu.wustl.catissuecore.actionForm.SpecimenArrayForm"%>
<%@ page import="edu.wustl.common.util.tag.ScriptGenerator" %>

<html:messages id="messageKey" message="true" header="messages.header" footer="messages.footer">
	<%=messageKey%>
</html:messages>
<html:errors/>
<% 
	SpecimenArrayForm form = (SpecimenArrayForm)request.getAttribute("specimenArrayForm");
	String exceedsMaxLimit = (String)request.getAttribute(Constants.EXCEEDS_MAX_LIMIT);
	String operation = (String)request.getAttribute(Constants.OPERATION);
	String submittedFor=(String)request.getAttribute(Constants.SUBMITTED_FOR);
	String formAction;
    if (operation.equals(Constants.EDIT))
    {
        formAction = Constants.SPECIMENARRAY_EDIT_ACTION;
    }
    else
    {
        formAction = Constants.SPECIMENARRAY_ADD_ACTION;
    }
%>	
<script language="JavaScript" type="text/javascript" src="jss/javaScript.js"></script>
<script language="JavaScript" type="text/javascript" src="jss/CustomListBox.js"></script>
<script language="JavaScript" type="text/javascript" src="jss/Hashtable.js"></script>
<html:form action="<%=formAction%>">
<html:hidden property="id" />
<html:hidden property="operation" value="<%=operation%>"/>
<html:hidden property="submittedFor" value="<%=submittedFor%>"/>
<html:hidden property="subOperation" value=""/>
<html:hidden property="createSpecimenArray" value="<%=form.getCreateSpecimenArray()%>"/>

<table summary="" cellpadding="0" cellspacing="0" border="0" class="contentPage" width="100%">
<tr>
	<td>
		<table summary="" cellpadding="3" cellspacing="0" border="0" width="100%">
			<tr>
				<td class="formMessage" colspan="3">* indicates a required field</td>
			</tr>
			
			<tr>
				<td class="formTitle" height="20" colspan="6">
					<logic:equal name="operation" value="<%=Constants.ADD%>">
						<bean:message key="array.title"/>
					</logic:equal>
					<logic:equal name="operation" value="<%=Constants.EDIT%>">
						<bean:message key="array.editTitle"/>
					</logic:equal>
				</td>
			</tr>

			<tr>
				<td class="formRequiredNotice" width="5">*</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="specimenArrayType">
						<bean:message key="array.arrayType" />
					</label>
				</td>
				<td class="formField">
					<html:select property="specimenArrayTypeId" styleClass="formFieldVerySmallSized" styleId="state" size="1" onchange="changeArrayType()">
						<html:options collection="<%=Constants.SPECIMEN_ARRAY_TYPE_LIST%>" labelProperty="name" property="value"/>
					</html:select>
					
					<html:link href="#" styleId="newSpecimenArrayType" onclick="addNewAction('SpecimenArrayAddNew.do?addNewForwardTo=specimenarraytype&forwardTo=specimenarray&addNewFor=specimenArrayTypeId&subOperation=ChangeArraytype')">
							<bean:message key="buttons.addNew" />
					</html:link>
					
				</td>

				<td class="formRequiredNoticeWithoutLeftBorder" width="5">*</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="createdBy">
						<bean:message key="array.createdBy" />
					</label>
				</td>
				<td class="formField">
					<html:select property="createdBy" styleClass="formFieldVerySmallSized" styleId="state" size="1">
						<html:options collection="<%=Constants.USERLIST%>" labelProperty="name" property="value"/>
					</html:select>
				</td>
			</tr>
			<tr>
				<td class="formRequiredNotice" width="5">*</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="arrayLabel">
						<bean:message key="array.arrayLabel" />
					</label>
				</td>
				<td class="formField">
					<html:text styleClass="formFieldVerySmallSized"  maxlength="20"  size="20" styleId="name" property="name"/>
				</td>

				<td class="formRequiredNoticeWithoutLeftBorder" width="5">&nbsp;</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="barcode">
						<bean:message key="array.barcode"/> 
					</label>
				</td>
				<td class="formField">
					<html:text styleClass="formFieldVerySmallSized"  maxlength="50"  size="30" styleId="barcode" property="barcode"/>
				</td>
			</tr>

			<tr>
				<td class="formRequiredNotice" width="5">*</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="specimenClass">
						<bean:message key="arrayType.specimenClass" />
					</label>
				</td>
				<td class="formField">
					<html:select property="specimenClass" styleClass="formFieldVerySmallSized" styleId="state" size="1" disabled="true">
						<html:options collection="<%=Constants.SPECIMEN_CLASS_LIST%>" labelProperty="name" property="value"/>
					</html:select>
				</td>

				<td class="formRequiredNoticeWithoutLeftBorder" width="5">*</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="specimenType">
						<bean:message key="arrayType.specimenType" />
					</label>
				</td>
				<td class="formField">
					<html:select property="specimenTypes" styleClass="formFieldVerySmallSized" styleId="state" size="4" multiple="true" disabled="true">
						<html:options collection="<%=Constants.SPECIMEN_TYPE_LIST%>" labelProperty="name" property="value"/>
					</html:select>
				</td>
			</tr>
			
				 <tr>
				 	<td class="formRequiredNotice" width="5">*</td>
					<td class="formRequiredLabelWithoutBorder">
					   <label for="className">
					   		<bean:message key="specimen.positionInStorageContainer"/>
					   </label>
					</td>
										<%-- n-combo-box start --%>
				<%
					Map dataMap = (Map) request.getAttribute(Constants.AVAILABLE_CONTAINER_MAP);
										
					String[] labelNames = {"ID","Pos1","Pos2"};
					labelNames = Constants.STORAGE_CONTAINER_LABEL;
					String[] attrNames = { "storageContainer", "positionDimensionOne", "positionDimensionTwo"};
					
					//String[] initValues = new String[3];
					//initValues[0] = form.getStorageContainer();
					//initValues[1] = String.valueOf(form.getPositionDimensionOne());
					//initValues[2] = String.valueOf(form.getPositionDimensionTwo());
					
					String[] initValues = new String[3];
					List initValuesList = (List)request.getAttribute("initValues");
					if(initValuesList != null)
					{
						initValues = (String[])initValuesList.get(0);
					}

					//System.out.println("NewSpecimen :: "+initValues[0]+"<>"+initValues[1]+"<>"+initValues[2]);			
					String rowNumber = "1";
					String styClass = "formFieldSized5";
					String tdStyleClass = "customFormField";
					String onChange = "onCustomListBoxChange(this)";
					String arrayTypeId = form.getSpecimenArrayTypeId()+"";
					String frameUrl = "ShowFramedPage.do?pageOf=pageOfSpecimen&amp;containerStyleId=customListBox_1_0&amp;xDimStyleId=customListBox_1_1&amp;yDimStyleId=customListBox_1_2"
							+ "&" + Constants.CAN_HOLD_SPECIMEN_ARRAY_TYPE +"=" + arrayTypeId;
					String buttonOnClicked = "javascript:NewWindow('"+frameUrl+"','name','810','320','yes');return false";
					String noOfEmptyCombos = "3";
				%>
				
				<%=ScriptGenerator.getJSForOutermostDataTable()%>
				<%=ScriptGenerator.getJSEquivalentFor(dataMap,rowNumber)%>
				
				<td class="formField" colSpan="4">
						<ncombo:containermap dataMap="<%=dataMap%>" 
											attributeNames="<%=attrNames%>" 
											initialValues="<%=initValues%>"  
											styleClass = "<%=styClass%>" 
											tdStyleClass = "<%=tdStyleClass%>" 
											labelNames="<%=labelNames%>" 
											rowNumber="<%=rowNumber%>" 
											onChange="<%=onChange%>" 
											noOfEmptyCombos = "<%=noOfEmptyCombos%>"
											
											buttonName="mapButton" 
											value="Map"
											buttonOnClick = "<%=buttonOnClicked%>"
											formLabelStyle="formLabelBorderless"
											buttonStyleClass="actionButton" />				
				</td>
				<%-- n-combo-box end --%>
				 </tr>
					<logic:equal name="exceedsMaxLimit" value="true">
					<tr>
						<td>
							<bean:message key="container.maxView"/>
						</td>
					</tr>
				</logic:equal>

			<tr>
				<td class="formRequiredNotice" width="5">&nbsp;</td>
				<td class="formRequiredLabelWithoutBorder">
					<label for="comments">
						<bean:message key="app.comments"/>
					</label>
				</td>
				<td class="formField">
					<html:textarea styleClass="formFieldVerySmallSized" rows="3" styleId="comments" property="comment"/>
				</td>
				<td class="formRequiredLabel" colspan="3">
					<table cellspacing="0" border="0" width="100%">
						<tr>
							<td class="formRequiredNoticeWithoutBorder" width="5">&nbsp;</td>
							<td class="formFieldNoBordersBold" colspan="2">
								<label for="capacity">
									<bean:message key="app.capacity" /> &nbsp;:
								</label>
							</td>
						</tr>
						<tr>
							<td class="formRequiredNoticeWithoutBorder" width="5">&nbsp;</td>
							<td class="formFieldNoBordersBold">
								<label for="oneDimensionCapacity">
									<bean:message key="app.oneDimension" />
								</label>
							</td>
							<td class="formFieldNoBordersBold">
								<html:text styleClass="formFieldVerySmallSized" maxlength="10"  size="30" styleId="oneDimensionCapacity" property="oneDimensionCapacity" readonly="true"/>
							</td>
						</tr>
						<tr>
							<td class="formRequiredNoticeWithoutBorder" width="5">&nbsp;</td>
							<td class="formFieldNoBordersBold">
								<label for="oneDimensionCapacity">
									<bean:message key="app.twoDimension" />
								</label>
							</td>
							<td class="formFieldNoBordersBold">
								<html:text styleClass="formFieldVerySmallSized" maxlength="10"  size="30" styleId="twoDimensionCapacity" property="twoDimensionCapacity" readonly="true"/>
							</td>
						</tr>
					</table>			
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>	
				<td colspan="6">
						<table summary="" cellpadding="3" cellspacing="0" border="0" width="100%">
						<tr>
							<td class="formTitle" height="20" colspan="7" width="100%">
								<label for="addspecimens">
									<bean:message key="array.addspecimens" />
								</label>
							</td>
						</tr>
						<tr width="100%">
							<td class="formRequiredNotice" width="5">*</td>
							<td class="formRequiredLabelWithoutBorder">
								<label for="array.enterSpecimenBy">
									<bean:message key="array.enterSpecimenBy" />
								</label>
							</td>
							<td class="formField" colspan="4">
								<html:radio styleId="enterSpecimenBy" property="enterSpecimenBy" value="Label" onclick="doClickEnterSpecimenBy();"/> Label 
								<html:radio styleId="enterSpecimenBy" property="enterSpecimenBy" value="Barcode" onclick="doClickEnterSpecimenBy();"/> Barcode 
							</td>
						</tr>
						<% 
							boolean disabled= true; 
							if (form.getCreateSpecimenArray().equals("yes")) 
							{
								disabled = false; 
						%>
						<tr>
							<td class="formField" colspan="7">
								<APPLET
									CODEBASE = "<%=Constants.APPLET_CODEBASE%>"
									ARCHIVE = "CaTissueApplet.jar"
									CODE = "<%=Constants.SPECIMEN_ARRAY_APPLET%>"
									ALT = "Specimen Array Applet"
									NAME = "<%=Constants.SPECIMEN_ARRAY_APPLET_NAME%>"
									width="100%" height="150" MAYSCRIPT>
									<PARAM name='type' value="application/x-java-applet;jpi-version=1.4.2"/>
									<PARAM name='name' value="<%=Constants.SPECIMEN_ARRAY_APPLET_NAME%>"/>
									<PARAM name='rowCount' value="<%=form.getOneDimensionCapacity()%>"/>
									<PARAM name='columnCount' value="<%=form.getTwoDimensionCapacity()%>"/>
									<PARAM name='enterSpecimenBy' value="<%=form.getEnterSpecimenBy()%>"/>
									<PARAM name='specimenClass' value="<%=form.getSpecimenClass()%>"/>									
									<PARAM name='session_id' value="<%=session.getId()%>"/>
									<PARAM NAME = '<%=Constants.APPLET_SERVER_URL_PARAM_NAME%>' VALUE = "<%=Constants.APPLET_SERVER_HTTP_START_STR%><%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>">
								</APPLET>
							</td>
							</tr>
						</table>
				</td>
			</tr>
			<%}%>
			<tr>
				<td align="right" colspan="6">
				<!-- action buttons begins -->
					<table cellpadding="4" cellspacing="0" border="0">
						<tr>
							<td>
								<html:button property="uploadSpecimenArrayButton" styleClass="actionButton" onclick="doUploadSpecimenArray();" disabled="<%=disabled%>">
									<bean:message  key="buttons.uploadSpecimenArray" />
								</html:button>
							</td>
						</tr>
					</table>
				<!-- action buttons end -->
				</td>
			</tr>
		</table>
	 </td>
   </tr>
</table>
</html:form>