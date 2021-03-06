<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
    <xsl:template match="CMSMenuItemAdd">
        <h2>
            <a href="/adm/content/menu">
                <xsl:value-of select="$locale/cms/adm/menu/h2"/>
            </a>
            <xsl:text> → </xsl:text>
            <a href="/adm/content/menu/view/{@id}">
                <xsl:value-of select="$locale/cms/adm/items/h2"/>
            </a>
            <xsl:text> → </xsl:text>
            <xsl:value-of select="$locale/cms/adm/menuitem/add-item-title"/>
        </h2>
        <h3>
            <xsl:value-of select="$locale/cms/adm/menuitem/options"/>
        </h3>
        <xsl:call-template name="CMSMenuItem"/>
    </xsl:template>

    <xsl:template match="CMSMenuItemEdit">
        <h2>
            <a href="/adm/content/menu">
                <xsl:value-of select="$locale/cms/adm/menu/h2"/>
            </a>
            <xsl:text> → </xsl:text>
            <a href="/adm/content/menu/view/{@id}">
                <xsl:value-of select="$locale/cms/adm/items/h2"/>
            </a>
            <xsl:text> → </xsl:text>
            <xsl:value-of select="$locale/cms/adm/menuitem/edit-item-title"/>
        </h2>
        <h3>
            <xsl:value-of select="$locale/cms/adm/menuitem/options"/>
        </h3>
        <xsl:call-template name="CMSMenuItem"/>
    </xsl:template>

    <xsl:template name="CMSMenuItem">
        <table class="form">
            <colgroup>
                <col style="width: 250px"/>
                <col/>
            </colgroup>
            <thead>
                <tr>
                    <th>
                        <xsl:value-of select="$locale/cms/adm/menuitem/type"/>
                    </th>
                    <td>
                        <select name="type" onchange="cms.switchItemForm(this.value)">
                            <option value="page">
                                <xsl:value-of select="$locale/cms/adm/menuitem/type-page"/>
                            </option>
                            <option value="link">
                                <xsl:if test="name()='CMSMenuItemEdit' and not(@page) and (@link)">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$locale/cms/adm/menuitem/type-link"/>
                            </option>
                            <option value="empty">
                                <xsl:if test="name()='CMSMenuItemEdit' and not(@page) and not (@link)">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$locale/cms/adm/menuitem/type-empty"/>
                            </option>
                        </select>
                    </td>
                </tr>
                <xsl:call-template name="CMSMenuItemParentSelect"/>
            </thead>
        </table>
        <!-- Add/edit page -->
        <div id="pageForm" class="menuItemForm">
            <xsl:choose>
                <xsl:when test="page">
                    <form action="/adm/content/menu/savepage" method="post" class="ajaxer">
                        <input type="hidden" name="menu" value="{@menu}"/>
                        <input type="hidden" name="id" value="{@id}"/>
                        <input type="hidden" name="parent" value="{@parent}"/>
                        <table class="form">
                            <colgroup>
                                <col style="width: 250px"/>
                                <col/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>
                                        <xsl:value-of select="$locale/cms/adm/menuitem/type-page"/>
                                    </th>
                                    <td>
                                        <select name="page">
                                            <xsl:for-each select="page">
                                                <option value="{@id}">
                                                    <xsl:if test="@id=../@page">
                                                        <xsl:attribute name="selected">
                                                            <xsl:text>selected</xsl:text>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="@title"/>
                                                </option>
                                            </xsl:for-each>
                                        </select>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <input type="submit" class="large_spacing" value="{$locale/cms/adm/menuitem/submit}"/>
                    </form>
                </xsl:when>
                <xsl:otherwise>
                    <span class="message">
                        <xsl:value-of select="$locale/cms/adm/menuitem/no-pages"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <!-- Add/edit link -->
        <div id="linkForm" style="display:none" class="menuItemForm">
            <form action="/adm/content/menu/savelink" method="post" class="ajaxer">
                <input type="hidden" name="menu" value="{@menu}"/>
                <input type="hidden" name="id" value="{@id}"/>
                <xsl:if test="name()='CMSMenuItemEdit' and not(@page) and @link">
                    <script type="text/javascript">cms.switchItemForm('link');</script>
                </xsl:if>
                <table class="form">
                    <colgroup>
                        <col style="width: 250px"/>
                        <col/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>
                                <xsl:value-of select="$locale/cms/adm/menuitem/link-label"/>
                            </th>
                            <td>
                                <input type="text" name="label" class="full-width" value="{@label}"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <xsl:value-of select="$locale/cms/adm/menuitem/type-link"/>
                            </th>
                            <td>
                                <input type="text" name="link" class="full-width" value="{@link}"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="form-buttons">
                    <input type="submit" value="{$locale/cms/adm/menuitem/submit}"/>
                </div>
            </form>
        </div>
        <!-- Add/edit empty item -->
        <div id="emptyForm" style="display:none" class="menuItemForm">
            <form action="/adm/content/menu/saveempty" method="post" class="ajaxer">
                <input type="hidden" name="menu" value="{@menu}"/>
                <input type="hidden" name="id" value="{@id}"/>
                <xsl:if test="name()='CMSMenuItemEdit' and not(@page) and not(@link)">
                    <script type="text/javascript">cms.switchItemForm('empty');</script>
                </xsl:if>
                <table class="form">
                    <colgroup>
                        <col style="width: 250px"/>
                        <col/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>
                                <xsl:value-of select="$locale/cms/adm/menuitem/link-label"/>
                            </th>
                            <td>
                                <input type="text" name="label" class="full-width" value="{@label}"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="form-buttons">
                    <input type="submit" value="{$locale/cms/adm/menuitem/submit}"/>
                </div>
            </form>
        </div>
    </xsl:template>

    <xsl:template name="CMSMenuItemParentSelect">
        <tr>
            <th>Parent:</th>
            <td>
                <select name="parent" onchange="$('input[name=\'parent\']').val($(this).val())">
                    <option value="0">—</option>
                    <xsl:call-template name="CMSMenuItemParentOption"/>
                </select>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="CMSMenuItemParentOption">
        <xsl:param name="nodeSet" select="parents"/>
        <xsl:param name="parent" select="''"/>
        <xsl:param name="depth" select="0"/>
        <xsl:param name="depthSpace" select="''"/>
        <xsl:for-each select="$nodeSet/menuitem[@parent=$parent]">
            <xsl:if test="not($nodeSet/../@id) or not(@id=$nodeSet/../@id)">
                <option value="{@id}">
                    <xsl:if test="@id=$nodeSet/../@parent">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$depthSpace"/>
                    <xsl:value-of select="@label"/>
                </option>
                <xsl:if test="$depth+1&lt;number($nodeSet/@depth)">
                    <xsl:call-template name="CMSMenuItemParentOption">
                        <xsl:with-param name="nodeSet" select="$nodeSet"/>
                        <xsl:with-param name="parent" select="@id"/>
                        <xsl:with-param name="depth" select="$depth+1"/>
                        <xsl:with-param name="depthSpace" select="concat('&#160;&#160;',$depthSpace)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
