#include "protheus.ch"
#include "report.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} REL_PES
Relatório de Listagem de Pessoas cadastradas, feito em TReport
 @author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 19/11/2018
@version P1
/*/
//-------------------------------------------------------------------
Function REL_PES()
    Local oReport 
    Local oZZP 

    Pergunte("ZZP001",.F.) 
    
    DEFINE REPORT oReport NAME "Listagem de Pessoas" TITLE "Relação de Pessoas Cadastradas" PARAMETER "ZZP001"; 
       ACTION {|oReport| PrintReport(oReport)}
       
                DEFINE SECTION oZZP OF oReport TITLE "Pessoas" TABLES "ZZP" // TOTAL IN COLUMN // PAGE HEADER
                DEFINE CELL NAME "ZZP_IDPES" OF oZZP ALIAS "ZZP"
                DEFINE CELL NAME "ZZP_NOME" OF oZZP ALIAS "ZZP"
                
    oReport:HideParamPage()    
    oReport:PrintDialog()
Return

Static Function PrintReport(oReport) 
    Local cAlias := "" 
    
        #IFDEF TOP
        	cAlias := GetNextAlias()
        
        	MakeSqlExp("ZZP001")
        
        	BEGIN REPORT QUERY oReport:Section(1)
        
        	BeginSql alias cAlias
        		SELECT ZZP_IDPES,ZZP_NOME
        		FROM %table:ZZP% ZZP
        		WHERE ZZP_FILIAL = %xfilial:ZZP% AND ZZP.%notDel%
        		ORDER BY ZZP_FILIAL,ZZP_IDPES
        	EndSql
        
        	END REPORT QUERY oReport:Section(1)
        	oReport:Section(1):Print()       
    #ENDIF
Return