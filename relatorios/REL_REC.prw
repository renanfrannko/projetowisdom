#include 'protheus.ch'
#include 'report.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} REL_REC
Relatório de Listagem de Receitas x Categorias, feito em TReport
Visualização é feito com quebra por Pessoas
@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 25/11/2018
@version P1
/*/
//-------------------------------------------------------------------

Function REL_REC()
	Local oReport
	Local oZZP
	Local oZZR	
		
    Pergunte("ZZP001",.F.) 
    
    DEFINE REPORT oReport NAME "Listagem de Receitas" TITLE "Relação de Receitas Cadastradas por Categorias" PARAMETER "ZZP001"; 
       ACTION {|oReport| PrintReport(oReport)}
       
	DEFINE SECTION oZZP OF oReport TITLE "Pessoa" TABLE "ZZP" // TOTAL IN COLUMN // PAGE HEADER
	oZZP:SetHeaderSection(.F.) // define se imprime cabeçalho das células na quebra de seção
	oZZP:SetPageBreak() // define a quebra de pagina, ou seja, o resultado de cada pessoa é apresentado em páginas separadas
	
		DEFINE CELL NAME "ZZP_IDPES" OF oZZP ALIAS "ZZP"
		DEFINE CELL NAME "ZZP_NOME"  OF oZZP ALIAS "ZZP"
		
	DEFINE SECTION oZZR OF oZZP TITLE "Receita" TABLES "ZZR","ZZC"
	
		DEFINE CELL NAME "RECEITA"    OF oZZR TITLE "Receitas" SIZE 10
        DEFINE CELL NAME "ZZR_IDCAT"  OF oZZR ALIAS "ZZR"
        DEFINE CELL NAME "ZZC_DESCR"  OF oZZR ALIAS "ZZC" TITLE "Categoria"
        DEFINE CELL NAME "ZZR_VALOR"  OF oZZR ALIAS "ZZR" TITLE "Total da receita" SIZE 17
 	
 	oZZR:Cell("ZZR_IDCAT"):Disable() //defino que a celula id de categoria não deve aparecer no relatorio
 		
	// Faz a somatoria das receitas 
	DEFINE FUNCTION FROM oZZR:Cell("ZZR_VALOR") FUNCTION SUM
             
	oReport:HideParamPage()
	oReport:PrintDialog()
Return

Static Function PrintReport(oReport)
	Local cAlias := ""
		
	#IFDEF TOP  // Só passa por esse trecho quem está utilizando banco de dados
		cAlias := GetNextAlias()  //   Criar uma tabela temporária.
					
		MakeSqlEXP("ZZP001")
		
	BEGIN REPORT QUERY oReport:Section(1)
	
	BeginSQL alias cAlias
	
		SELECT ZZP_IDPES, ZZP_NOME,		
			ZZC_DESCR, 
			ZZR_VALOR
			
		FROM %table:ZZP% ZZP, %table:ZZC% ZZC, %table:ZZR% ZZR
		
		WHERE ZZR.%notDel% AND ZZR_IDPES = ZZP_IDPES AND
			  ZZR_IDCAT = ZZC_IDCAT
		
		GROUP BY ZZC_DESCR, ZZP_IDPES, ZZP_NOME, ZZR_VALOR
		
		ORDER BY ZZP_IDPES
		
	EndSql

	END REPORT QUERY oReport:Section(1)
	
	oReport:Section(1):Section(1):SetParentQuery()
	oReport:Section(1):Section(1):SetParentFilter( { |cParam|  (cAlias)->ZZP_IDPES == cParam }, { || (cAlias)-> ZZP_IDPES })
	
	oReport:Section(1):Print()
	
	#ENDIF
Return
