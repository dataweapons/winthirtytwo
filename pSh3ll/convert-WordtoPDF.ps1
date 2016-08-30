    ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  Convert-WordToPDF
    ##  PURPOSE........:  Converts Word documents to PDF files.
    ##  REQUIREMENTS...:  PowerShell v2, Word 2007
    ##  NOTES..........:  This has been tested with Word 2010, it may also work
    ##                    with Word 2003 but has not been tested.
    ##--------------------------------------------------------------------------
    Function Convert-WordToPDF {
        <#
        .SYNOPSIS
         Converts Word documents to PDF files.

         For examples, type:
         Help Convert-WordToPDF -examples
        .DESCRIPTION
         This function uses the Word.Application COM Object to convert .doc or
         .docx files to PDF files. By default this function works on .doc files,
         If the file to be converted is a .docx file, use the -docx switch.
        .PARAMETER Path
         The full path (including file name) to the document to be converted.
        .PARAMETER Docx
         This optional switch allows the conversion of .docx files to PDF. If 
         this switch is omitted, and a .docx file is specified, the Function 
         will still convert the file, however the resulting file will have an 
         extension of .pdfx (you just need to delete the "x" off the end, and
         the file will open fine).
        .EXAMPLE
         C:\PS>Convert-WordToPDF c:\test.doc

         This example will convert the file c:\test.doc to a PDF file. The 
         resulting file will be saved to c:\test.pdf (the .doc file will not be 
         deleted).

        .EXAMPLE
         C:\PS>Convert-WordToPDF c:\test.docx -docx

         This example will convert the file c:\test.docx to a PDF file. The 
         resulting file will be saved to c:\test.pdf (the .docx file will not be
         deleted).

        .EXAMPLE
         C:\PS>"c:\test.doc" | Convert-WordToPDF

         This example will do the same thing as EXAMPLE 1, showing how to pass
         a document to the function for conversion using pipelining.

        .NOTES
         NAME......:  Convert-WordToPDF
         AUTHOR....:  Joe Glessner
         LAST EDIT.:  08JUN11
         CREATED...:  11APR11

        .LINK
         http://joeit.wordpress.com/
        .LINK
         http://msdn.microsoft.com/en-us/library/bb238158%28v=office.12%29.aspx
        #>
        [CmdletBinding()]
        Param(
            [Parameter(ValueFromPipeline=$True,
                Position=0,
                Mandatory=$True,
                HelpMessage="The filename and path for the Word document.")] 
            [ValidateScript({Test-Path (split-path $_)})]
            [String]$Path,
            [Switch]$Docx
        )#END: Param
        Write-Verbose "Setting Word constants..."
        $wdFormatPDF = [ref] 17
        Write-Verbose "Connection to the Word.Application COM Object..."
        $Word = New-Object -Com Word.Application
        $Word.Visible = $False
        Write-Verbose 'To enable debugging set $Word.Visible = $True'
        If (!(test-path $Path)) { 
            "File $Document does not exist!"
            Break 
        }#END: If (!(test-path $Path))
        Write-Verbose "Opening document $Path..."
        $existingDoc=$word.Documents.Open($Path)
        Write-Verbose "Changing file extension to '.pdf'..."
        If($Docx) {
            $SaveAsPath = $Path.Replace('.docx','.pdf')
        }#END: If($Docx)
        Else {
            $SaveAsPath = $Path.Replace('.doc','.pdf')
        }#END: Else
        If(test-path $SaveAsPath) { 
            Write-Verbose "Delete the output file if it already exists..."
            rm $SaveAsPath
        }#END: If(test-path $saveaspath)
        Write-Verbose "Saving file $SaveAsPath..."
        $ExistingDoc.SaveAs( [ref] $SaveAsPath, $wdFormatPDF )
        Write-Verbose "Closing document $Path..."
        $existingDoc.Close()
        Write-Verbose "Exiting Word..."
        $Word.Quit()
    }#END: Function Convert-WordToPDF
