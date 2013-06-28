<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
   xmlns:uuid="uuid"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:xs = "http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
	<xsl:output method="text" media-type="text/plain"/>
	
	<xsl:variable name="utc-timestamp" select="current-dateTime()"/>
	<xsl:param name="sensorId"/>
	<xsl:param name="foi"/>
	<xsl:template match="ROOT">	
		
		<xsl:apply-templates select="S"/>
	</xsl:template>
	
	<xsl:template name="generateObservation">
		<xsl:value-of select="concat('&#10;','&#60;','http://lsm.deri.ie/resource/',$observationId,'&#62; ',
	    			'&#60;','http://www.w3.org/1999/02/22-rdf-syntax-ns#type','&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#Observation','&#62;. '),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$observationId,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#observedBy','&#62;',' &#60;',$sensorId,'&#62;.'),	    			
	    			concat('&#60;','http://lsm.deri.ie/resource/',$observationId,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#observationResultTime','&#62;',' &#34;',$utc-timestamp,'&#34;&#94;&#94;&#60;','http://www.w3.org/2001/XMLSchema#dateTime&#62;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$observationId,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#featureOfInterest','&#62;',' &#60;','http://lsm.deri.ie/resource/',$foi,'&#62;.')
           			" separator="&#10;"/>
	</xsl:template>
	
	<xsl:template match="S">
		<xsl:for-each select="P">			
 			<xsl:apply-templates select="T"/>			
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="P">		
		<xsl:call-template name="noUnit">
			<xsl:with-param name="name" select="'StationPlatform'"/>
			<xsl:with-param name="value" select="@N" />
			<xsl:with-param name="observationId" select="@Id" />
		</xsl:call-template>	
	</xsl:template>
	
	<xsl:template match="T">								
		<xsl:call-template name="generateObservation">
			<xsl:with-param name="sensorId" select="concat('http://lsm.deri.ie/resource/',$sensorId)"/>
			<xsl:with-param name="observationId" select="@Id"/>
		</xsl:call-template>
		<xsl:call-template name="noUnit">
				<xsl:with-param name="name" select="'StationPlatform'"/>
				<xsl:with-param name="value" select="parent::node()/@N" />
				<xsl:with-param name="observationId" select="@Id"/>
			</xsl:call-template>
		<xsl:call-template name="noUnit">
			<xsl:with-param name="name" select="'TrainNumber'"/>
			<xsl:with-param name="value" select="@SetNo" />
			<xsl:with-param name="observationId" select="@Id" />
		</xsl:call-template>
		<xsl:call-template name="hasUnit">
			<xsl:with-param name="name" select="'SecondToStation'"/>
			<xsl:with-param name="value" select="@SecondsTo" />
			<xsl:with-param name="unit" select="'second'" />
			<xsl:with-param name="observationId" select="@Id" />
		</xsl:call-template>
		<xsl:call-template name="hasUnit">
			<xsl:with-param name="name" select="'TimeToStation'"/>
			<xsl:with-param name="value" select="@TimeTo" />
			<xsl:with-param name="unit" select="'minute'" />
			<xsl:with-param name="observationId" select="@Id" />
		</xsl:call-template>
		<xsl:call-template name="noUnit">
			<xsl:with-param name="name" select="'Status'"/>
			<xsl:with-param name="value" select="@Location" />
			<xsl:with-param name="observationId" select="@Id" />
		</xsl:call-template>
		<xsl:call-template name="noUnit">
			<xsl:with-param name="name" select="'Destination'"/>
			<xsl:with-param name="value" select="@Destination" />
			<xsl:with-param name="observationId" select="@Id" />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="hasUnit">
		<xsl:param name="name"/>
		<xsl:param name="value"/>		
		<xsl:param name="unit"/>
		<xsl:variable name ="realvalue">
		  <xsl:choose>
		     <xsl:when test ="$value!=''">
		      <xsl:value-of select ="$value"/> 
		     </xsl:when>
		     <xsl:otherwise>-999</xsl:otherwise>
		  </xsl:choose>
   		</xsl:variable>
		<xsl:variable name="tempid" select="uuid:generateID()"/>
		<xsl:variable name="classURL" select="document('observedproperty.xml')/Root/items/item[name=$name]/class"/>
		<xsl:variable name="observedId" select="document('observedproperty.xml')/Root/items/item[name=$name]/url"/>
	    <xsl:value-of select="concat('&#10;','&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://www.w3.org/1999/02/22-rdf-syntax-ns#type','&#62; ','&#60;',$classURL,'&#62;. '),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://lsm.deri.ie/ont/lsm.owl#isObservedPropertyOf','&#62; ','&#60;',
	    			'http://lsm.deri.ie/resource/',$observationId,'&#62;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://lsm.deri.ie/ont/lsm.owl#value','&#62;',' &#34;',$realvalue,'&#34;&#94;&#94;&#60;','http://www.w3.org/2001/XMLSchema#double&#62;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://lsm.deri.ie/ont/lsm.owl#unit','&#62; ','&#34;',$unit,'&#34;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#observedProperty','&#62; ','&#60;',$observedId,'&#62;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#observationResultTime','&#62;',' &#34;',$utc-timestamp,'&#34;&#94;&#94;&#60;','http://www.w3.org/2001/XMLSchema#dateTime&#62;.')
           			" separator="&#10;"/>
	</xsl:template>
	
	<xsl:template name="noUnit">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="observationId"/>
		<xsl:variable name="tempid" select="uuid:generateID()"/>
		<xsl:variable name="observedId" select="document('observedproperty.xml')/items/item[name=$name]/url"/>
	    <xsl:value-of select="concat('&#10;','&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://www.w3.org/1999/02/22-rdf-syntax-ns#type','&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#',$name,'&#62;. '),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://lsm.deri.ie/ont/lsm.owl#isObservedPropertyOf','&#62; ','&#60;',
	    			'http://lsm.deri.ie/resource/',$observationId,'&#62;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://lsm.deri.ie/ont/lsm.owl#value','&#62;',' &#34;',$value,'&#34;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#observedProperty','&#62; ','&#60;',$observedId,'&#62;.'),
	    			concat('&#60;','http://lsm.deri.ie/resource/',$tempid,'&#62; ',
	    			'&#60;','http://purl.oclc.org/NET/ssnx/ssn#observationResultTime','&#62;',' &#34;',$utc-timestamp,'&#34;&#94;&#94;&#60;','http://www.w3.org/2001/XMLSchema#dateTime&#62;.')
           			" separator="&#10;"/>
	</xsl:template>
	
	<xsl:function name="uuid:generateID">
       <!-- generate unique ID -->
       <xsl:variable name="duration-from-1582" as="xs:dayTimeDuration" >
           <xsl:sequence select="current-dateTime() - xs:dateTime('1582-10-15T00:00:00.000Z')" />
       </xsl:variable> 
        <xsl:variable name="random-offset" as="xs:integer">
           <xsl:sequence select="uuid:next-nr() mod 10000"></xsl:sequence>
       </xsl:variable>
       <!-- do the math to get the 100 nano second intervals -->
       <xsl:sequence select="concat(
           (days-from-duration($duration-from-1582) * 24 * 60 * 60 +
           hours-from-duration($duration-from-1582) * 60 * 60 +
           minutes-from-duration($duration-from-1582) * 60 +
           seconds-from-duration($duration-from-1582)) * 1000 * 10000 +
			$random-offset, uuid:get-id())" />  
   </xsl:function>
   <xsl:function name="uuid:next-nr" as="xs:integer">
       <xsl:variable name="node"><xsl:comment /></xsl:variable>
       <xsl:sequence select="xs:integer(replace(generate-id($node),'\D', ''))" />
   </xsl:function>
   <!-- generates some kind of unique id -->
   <xsl:function name="uuid:get-id" as="xs:string">
       <xsl:sequence select="generate-id(uuid:_get-node())" />
   </xsl:function>
   <xsl:function name="uuid:_get-node"><xsl:comment /></xsl:function>
</xsl:stylesheet>
