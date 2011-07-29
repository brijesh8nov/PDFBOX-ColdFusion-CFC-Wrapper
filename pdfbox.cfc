<!--- -------------------------------------------------------------------- --->
<!--- PDFBOX component to print pdfdocument directly to the NETWORK printer --->
<!--- 
	  1. Users PDFBOX library , http://pdfbox.apache.org/
	  2. Uses JAVALOADER to load the PDFBOX library, http://javaloader.riaforge.org/ 
--->
<!--- Created By : Brijesh Chauhan, brijesh@brijeshradhika.com --->
<!--- Created date: 28 July 2011 --->
<!--- Modified Date : 29 July 2011 : Added Printer option, by default PrintPDF fuction does not allow to specify the printer, added code for this --->
<!--- -------------------------------------------------------------------- --->

<cfcomponent hint="This is a WRAPPER to PDFFOX Silent print functionality">
<cffunction name="pdfBoxPrint" access="public" returntype="any" output="yes">
	<cfargument name="pdfFilePath" type="string" required="yes" hint="Complete PATH to the PDF file which needs to be printed">
    <cfargument name="defaultPrinterName" type="string" required="no"  default="" hint="If no printer name is specified, it will use the DEFAULT printer">
    <cfargument name="silentPrintD" type="boolean" required="no" default="1" hint="this can be 1 or 0, by default it prints the without the dialog box">
    <cfargument name="pdfpassword" type="any" required="no" default="" hint="if the PDF is protected, then you need to pass the password to it.">
    
    <!--- Variables --->
    <cfset var pdfFile = JavaCast('String','#Arguments.pdfFilePath#') />
    <cfset var password = JavaCast('String','#Arguments.pdfpassword#') />
    <cfset var silentPrint = JavaCast('boolean','#Arguments.silentPrintD#') />
    <cfset var printerName = JavaCast('String','#Arguments.defaultPrinterName#')/>
    
    <cfscript>
		// Javaloader configurations 
		var libpaths = [];
		ArrayAppend(libpaths, expandPath("./lib/pdfbox-app-1.6.0.jar"));
		var loader = createObject("component", "javaloader.JavaLoader").init(loadPaths=libpaths, loadColdFusionClassPath=true);
		// Required JAVA objects 
		var printerJob = CreateObject("Java","java.awt.print.PrinterJob");
		var printService = CreateObject("Java","javax.print.PrintService");
	</cfscript>
    
    <!--- Processing --->
    <cfset var PDDocument = loader.create("org.apache.pdfbox.pdmodel.PDDocument") />
    <cfset var document = PDDocument.load(pdfFile) />
    <cfset var printJob = PrinterJob.getPrinterJob() />
    <cfset var printService = PrinterJob.lookupPrintServices() />
    
    <!--- A bit of LOGIC --->
    
    <cftry>
    <!--- If document is encrypted, need to decrypt is --->
    	<cfif document.isEncrypted()>
        	 <cfset document.decrypt( password ) />
         </cfif>
     <!--- Find the printer which needs to do the JOB --->
         <cfif printerName NEQ ''>
         	<cfset var printerFound = 0/>
            <cfloop from="1" to="#ArrayLen(printService)#" index="i">
            	<cfif NOT printerFound>
            	<cfif printService[i].getName().indexOf(printerName) NEQ -1>
                	<cfset printJob.setPrintService(printService[i])/>
                    <cfset printerFound = 1/>
				</cfif>
                </cfif>
            </cfloop>
           <cfelse>
           <!--- Just use the DEFAULT PRINTER --->
           		<cfset printJob.setPrintService(printService[1])/>
         </cfif>
     <!--- DO PRINTING --->
         <cfif silentPrint>
         	<cfset document.silentPrint(printJob)/>
         <cfelse>
         	<cfset document.print(printJob)/>
         </cfif>
      <cfcatch type="any">
      	<cfset Message = '#cfcatch.Message#' />	
      </cfcatch>
      <cffinally>
      		<cfif document NEQ ''>
				<cfset document.close()/>
            </cfif>
      </cffinally>           
    </cftry>
    <cfset Message = 'Job Send To Printer Sucessfully'/>
    <cfreturn Message/>
</cffunction>
</cfcomponent>