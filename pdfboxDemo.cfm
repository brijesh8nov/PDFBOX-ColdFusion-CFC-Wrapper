<!--- PDFBOX Demo --->
<!--- Created By : Brijesh Chauhan --->
<!--- Date Created: 29th July 2011 --->

<cfset pdfFileCompletePath = 'C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\web\pdfbox\INV0018WE.pdf' />
<cfset PrinterName = 'blackWhite'/>

<!--- Calling the component with PrinterName --->
<cfset result = createObject("component",'pdfbox').pdfBoxPrint(pdfFileCompletePath,PrinterName)/>

<!--- Calling the component without PrinterName, will print using DEFAULT printer --->
<cfset result = createObject("component",'pdfbox').pdfBoxPrint(pdfFileCompletePath)/>

<cfdump var="#result#">
