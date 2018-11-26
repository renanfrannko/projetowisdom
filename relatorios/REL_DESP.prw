#include 'protheus.ch'
#include 'report.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} REL_DESP
Relatório de Listagem de Despesas x Categorias, feito em TReport
Visualização é feito com quebra por Pessoas
@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 19/11/2018
@version P1
/*/
//-------------------------------------------------------------------
Function REL_DESP()
	Local oReport
	Local oZZP
	Local oZZD	
		
    Pergunte("ZZP001",.F.) 
    
    DEFINE REPORT oReport NAME "Listagem de Despesas" TITLE "Relação de Despesas Cadastradas por Categorias" PARAMETER "ZZP001"; 
       ACTION {|oReport| PrintReport(oReport)}
       
	DEFINE SECTION oZZP OF oReport TITLE "Pessoa" TABLE "ZZP" // TOTAL IN COLUMN // PAGE HEADER
	oZZP:SetHeaderSection(.F.) // define se imprime cabeçalho das células na quebra de seção
	oZZP:SetPageBreak() // define a quebra de pagina, ou seja, o resultado de cada pessoa é apresentado em páginas separadas
	
		DEFINE CELL NAME "ZZP_IDPES" OF oZZP ALIAS "ZZP"
		DEFINE CELL NAME "ZZP_NOME"  OF oZZP ALIAS "ZZP"
		
	DEFINE SECTION oZZD OF oZZP TITLE "Despesa" TABLE "ZZD"
	
		DEFINE CELL NAME "DESPESA"    OF oZZD TITLE "Despesas" SIZE 10
        DEFINE CELL NAME "ZZD_NCAT"   OF oZZD ALIAS "ZZD" TITLE "Categoria"
        DEFINE CELL NAME "ZZD_VALOR"  OF oZZD ALIAS "ZZD" TITLE "Total da Despesa" SIZE 17
 
	// Faz a somatoria das despesas 
	DEFINE FUNCTION FROM oZZD:Cell("ZZD_VALOR") FUNCTION SUM
             
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
			ZZD_NCAT, SUM(ZZD_VALOR) ZZD_VALOR
			
		FROM %table:ZZP% ZZP, %table:ZZD% ZZD
		
		WHERE ZZD.%notDel% AND ZZD_IDPES = ZZP_IDPES
		
		GROUP BY ZZD_NCAT, ZZP_IDPES, ZZP_NOME
		
		ORDER BY ZZP_IDPES
		
	EndSql
	
	END REPORT QUERY oReport:Section(1)
	
	oReport:Section(1):Section(1):SetParentQuery()
	oReport:Section(1):Section(1):SetParentFilter( { |cParam|  (cAlias)->ZZP_IDPES == cParam }, { || (cAlias)-> ZZP_IDPES })
	
	oReport:Section(1):Print()
	
	#ENDIF
Return
