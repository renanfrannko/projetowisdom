#include "protheus.ch"
#include "report.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} REL_CAT
Relatório de Listagem de Categorias cadastradas, feito em TReport
 @author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 19/11/2018
@version P1
/*/
//-------------------------------------------------------------------
Function REL_CAT()
    Local oReport 
    Local oZZC 
    
    DEFINE REPORT oReport NAME "Listagem de Categorias" TITLE "Relação de Categorias Cadastradas"; 
       ACTION {|oReport| PrintReport(oReport)}
       
                DEFINE SECTION oZZC OF oReport TITLE "Categorias" TABLES "ZZC" // TOTAL IN COLUMN // PAGE HEADER
                DEFINE CELL NAME "ZZC_IDCAT" OF oZZC ALIAS "ZZC"
                DEFINE CELL NAME "ZZC_DESCR" OF oZZC ALIAS "ZZC"
                
    oReport:HideParamPage()    
    oReport:PrintDialog()
Return

Static Function PrintReport(oReport) 
    Local cAlias := "" 
    
        #IFDEF TOP
        	cAlias := GetNextAlias()
                
        	BEGIN REPORT QUERY oReport:Section(1)
        
        	BeginSql alias cAlias
        		SELECT ZZC_IDCAT,ZZC_DESCR
        		FROM %table:ZZC% ZZC
        		WHERE ZZC_FILIAL = %xfilial:ZZC% AND ZZC.%notDel%
        		ORDER BY ZZC_FILIAL,ZZC_IDCAT
        	EndSql
        
        	END REPORT QUERY oReport:Section(1)
        	oReport:Section(1):Print()       
    #ENDIF
Return