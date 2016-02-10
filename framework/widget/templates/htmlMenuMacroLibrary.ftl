<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#include "htmlCommonMacroLibrary.ftl">
<#-- 
Cato: NOTE: since macro renderer initial context mod, macros here now have access to a few widget context objects part of the initial
context, such as request, response, locale, and to some extent (since 2016-01-06), uiLabelMap.
WARN: no code run here or indirectly from here should assume full current context present. only use well-known generic vars.
-->

<#-- Cato: Experimental one-shot macro menu rendering 
 items: list of maps, each entry corresponding roughly to old @renderMenuItemBegin arguments
    item map contains "linkInfo" and "imageInfo" maps, corresponding roughly to @renderLink and @renderImage args.
-->
<#macro renderMenuFull boundaryComment="" id="" style="" title="" inlineEntries=false menuCtxRole="" items=[]>
  <#--<p><@objectAsScript lang="raw" object=items /></p>-->
  <#-- TODO: unfragment this (the point is to not have to have this fragmented, but need to test) -->
  <@renderMenuBegin boundaryComment=boundaryComment id=id style=style title=title inlineEntries=inlineEntries menuCtxRole=menuCtxRole />
  <#list items as item>
    <#local linkStr = "">
    <#if item.linkInfo?has_content>
      <#local linkInfo = item.linkInfo>
      <#local linkStr><@renderLink linkInfo.linkUrl linkInfo.parameterList linkInfo.targetWindow linkInfo.uniqueItemName linkInfo.actionUrl linkInfo.linkType linkInfo.id linkInfo.style linkInfo.name linkInfo.height linkInfo.width linkInfo.text linkInfo.imgStr linkInfo.menuCtxRole /></#local>
    </#if>
    <#local imgStr = "">
    <#if item.imageInfo?has_content>
      <#local imgInfo = item.imageInfo>
      <#local imgStr><@renderImage imgInfo.src imgInfo.id imgInfo.style imgInfo.width imgInfo.height imgInfo.border imgInfo.menuCtxRole /></#local>
    </#if>

    <@renderMenuItemBegin item.style linkStr item.toolTip item.containsNestedMenus item.menuCtxRole />
      <#-- TODO: what else goes here... nested menus? image? -->
    <@renderMenuItemEnd item.containsNestedMenus item.menuCtxRole />
  </#list>
  <@renderMenuEnd boundaryComment=boundaryComment style=style inlineEntries=inlineEntries menuCtxRole=menuCtxRole />
</#macro>


<#-- 
Menu styles can be set via menu-container-style attribute. The rendering will differ if one of the following classes is set
    * menu-main
    * menu-sidebar
    * menu-button
    * menu-tab // ToDo
-->
<#macro renderMenuBegin boundaryComment="" id="" style="" title="" inlineEntries=false menuCtxRole="">
  <#local styleSet = splitStyleNamesToSet(style)>
  <#local remStyle = "">
<#if boundaryComment?has_content>
<!-- ${boundaryComment} -->
</#if>
  <#if !inlineEntries>
    <#if styleSet.contains("menu-main")>
      <#local remStyle = removeStyleNames(style, "menu-main")>
        <li class="${styles.menu_main_wrap!}"><a href="#" class="${styles.menu_main_item_link!}"
            <#if styles.framework?has_content && styles.framework =="bootstrap"> data-toggle="dropdown"</#if>>${title!}<#if styles.framework?has_content && styles.framework =="bootstrap"> <i class="fa fa-fw fa-caret-down"></i></#if></a>
      <#local classes = joinStyleNames(styles.menu_main!, remStyle)>
    <#elseif styleSet.contains("menu-sidebar")>
      <#local remStyle = removeStyleNames(style, "menu-sidebar")>
        <nav class="${styles.nav_sidenav!""}">
            <#if navigation?has_content><h2>${navigation!}</h2></#if>
      <#local classes = joinStyleNames(styles.menu_sidebar!, remStyle)>
    <#elseif styleSet.contains("menu-button")>
      <#local remStyle = removeStyleNames(style, "menu-button")>
      <#local classes = joinStyleNames(styles.menu_button!, remStyle)>
    <#elseif styleSet.contains("menu-tab")>    
      <#local remStyle = removeStyleNames(style, "menu-tab")>
      <#local classes = joinStyleNames(styles.menu_tab!, remStyle)>
    <#elseif styleSet.contains("button-bar")>
      <#-- NOTE (2016-02-08): There should be no more "button-bar" style left in *Menus.xml... should all go through CommonButtonBarMenu (menu-button) or alternative base menu -->
      <#local remStyle = removeStyleNames(style, ["button-bar"])> <#-- ["button-bar", "no-clear"] -->
      <#-- right now translating button-bar menu-container-style here to avoid modifying all menu styles
           note: in stock, button-bar usually accompanied by one of: button-style-2, tab-bar; also found: no-clear (removed above) -->
      <#-- WARN: stock ofbiz usually applied styles to a containing div, 
           not sure should keep that behavior or not, but might not consistent with foundation styles? -->
      <#local classes = joinStyleNames(styles.menu_button!, remStyle)>
    <#else>
      <#-- all other cases -->
      <#-- WARN: stock ofbiz usually applied styles to a containing div, 
           not sure should keep that behavior or not, but might not consistent with foundation styles? -->
      <#local classes = joinStyleNames(styles.menu_default!, style)>
    </#if>
        <ul<#if id?has_content> id="${id}"</#if><#if classes?has_content> class="${classes}"</#if>>
            <#-- Hardcoded alternative that will always display a Dashboard link on top of the sidebar
            <#local dashboardLink><a href="<@ofbizUrl>/main</@ofbizUrl>">${uiLabelMap.CommonDashboard!}</a></#local>
            <@renderMenuItemBegin style="${styles.menu_sidebar_itemdashboard!}" linkStr=dashboardLink! /><@renderMenuItemEnd/>-->
  </#if>
   <#local dummy = pushRequestStack("renderMenuStack", {"style":style,"remStyle":remStyle,"id":id,"inlineEntires":inlineEntries})> <#-- pushing info to stack, so that this can be used by subsequently --> 
</#macro>

<#macro renderMenuEnd boundaryComment="" style="" inlineEntries=false menuCtxRole="">
  <#local styleSet = splitStyleNamesToSet(style)>
  <#local menu = popRequestStack("renderMenuStack")>
  <#if !inlineEntries>
    <#--        
    <#if isSubMenu>
            </ul>
    <#else>
        </ul>
        </li>
        <#global isSubMenu=true/>
    </#if>
    -->
    <#if styleSet.contains("menu-main")>
            </ul>
        </li>
    <#elseif styleSet.contains("menu-sidebar")>
            </ul>
        </nav>
    <#elseif styleSet.contains("menu-button")>
        </ul>
    <#elseif styleSet.contains("menu-tab")>
        </ul>
    <#elseif styleSet.contains("button-bar")>
        </ul>
    <#else>
        </ul>
    </#if>
  </#if>
  
  <#if !readRequestStack("renderMenuStack")??> <#-- if top-level menu -->
    <#local renderMenuHiddenFormContent = getRequestVar("renderMenuHiddenFormContent")!"">
    <#if renderMenuHiddenFormContent?has_content>
      ${renderMenuHiddenFormContent}
      <#-- note: we don't have to worry about recursion here; will accumulate all forms from sub-menus as well;
           note: for simplicity, don't use xxxRequestStack for now, probably not needed -->
      <#local dummy = setRequestVar("renderMenuHiddenFormContent", "")>
    </#if>
  </#if>
<#if boundaryComment?has_content>
<!-- ${boundaryComment} -->
</#if>
</#macro>

<#macro renderImage src id style width height border menuCtxRole="">
<img src="${src}"<#if id?has_content> id="${id}"</#if><#if style?has_content> class="${style}"</#if><#if width?has_content> width="${width}"</#if><#if height?has_content> height="${height}"</#if><#if border?has_content> border="${border}"</#if> />
</#macro>

<#macro renderLink linkUrl parameterList targetWindow uniqueItemName actionUrl linkType="" id="" style="" name="" height="" width="" text="" imgStr="" menuCtxRole="">
<#-- Cato: hack: for screenlet nav menus, always impose buttons if no style specified, 
     because can't centralize these menus easily anywhere else. -->
<#if menuCtxRole=="screenlet-nav-menu">
  <#if !style?has_content>
    <#local style = "${styles.menu_section_item_link!}">
  </#if>
</#if>
<#-- Cato: treat "none" keyword as requesting empty style, as workaround -->
<#if style == "none">
  <#local style = "">
</#if>

  <#if linkType?has_content && "hidden-form" == linkType>
    <#local hiddenFormContent>
<form method="post" action="${actionUrl}"<#if targetWindow?has_content> target="${targetWindow}"</#if> onsubmit="javascript:submitFormDisableSubmits(this)" name="${uniqueItemName}" class="menu-widget-action-form"><#rt/>
    <#list parameterList as parameter>
<input name="${parameter.name}" value="${parameter.value}" type="hidden"/><#rt/>
    </#list>
</form><#rt/>
    </#local>
    <#local renderMenuHiddenFormContent = getRequestVar("renderMenuHiddenFormContent")!"">
    <#local dummy = setRequestVar("renderMenuHiddenFormContent", renderMenuHiddenFormContent+hiddenFormContent)>
  </#if>
<#if (linkType?has_content && "hidden-form" == linkType) || linkUrl?has_content>
<a<#if id?has_content> id="${id}"</#if><#if style?has_content> class="${style}"</#if><#if name?has_content> name="${name}"</#if><#if targetWindow?has_content> target="${targetWindow}"</#if> href="<#if "hidden-form"==linkType>javascript:document.${uniqueItemName}.submit()<#else>${linkUrl}</#if>"><#rt/>
</#if>
<#if imgStr?has_content>${imgStr}</#if><#if text?has_content>${text}</#if><#rt/>
<#if (linkType?has_content && "hidden-form" == linkType) || linkUrl?has_content></a><#rt/></#if>
</#macro>

<#macro renderMenuItemBegin style linkStr toolTip="" containsNestedMenus=false menuCtxRole="">
        <li<#if style?has_content> class="${style}"</#if><#if toolTip?has_content> title="${toolTip}"</#if>><#if linkStr?has_content>${linkStr}</#if><#if containsNestedMenus><ul></#if><#rt/>
</#macro>

<#macro renderMenuItemEnd containsNestedMenus=false menuCtxRole="">
<#if containsNestedMenus></ul></#if></li>
</#macro>
